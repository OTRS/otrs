// --
// OTRS.Customer.js - provides functions for the customer login
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.App.Customer.js,v 1.7 2010-04-22 22:36:08 fn Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};
OTRS.App = OTRS.App || {};

/**
 * @namespace
 * @exports TargetNS as OTRS.App.Customer
 * @description
 *      This namespace contains all form functions.
 */
OTRS.App.Customer = (function (TargetNS) {
    /**
     * @function
     * @description
     *      This function initializes the login functions.
     *      Time gets tracked in an hidden field.
     *      In the login we have for steps:
     *      1. input field gets focused -> label gets greyed out via class="Focused"
     *      2. something is typed -> label gets hidden
     *      3. user leaves input field -> if the field is blank the label gets shown again, 'focused' class gets removed
     *      4. first input field gets focused
     * @return nothing
     */
    TargetNS.InitLogin = function() {
        var $Inputs = $('input').not(':checkbox, :hidden, :radio'),
            Now = new Date(),
            Diff = Now.getTimezoneOffset();
        
        $('#TimeOffset').val(Diff);
        
        $Inputs
            .focus(function(){
                $(this).prev('label').addClass('Focused');
            })
            .bind('keyup change', function(){
                ToggleLabel(this);
            })
            .blur(function(){
                var $Label = $(this).prev('label');
                if (!$(this).val()) {
                    $Label.show();
                }
                $Label.removeClass('Focused');
            })
            .first().focus();
        CheckInputs($Inputs);
    };

    /**
     * @function
     * @param {DOMObject} $PopulatedInput is a filled out input filled
     * @description
     *      This function hides the label of the given field if there is value in the field.
     *      If there is no value in the given field the label is made visible.
     * @return nothing
     */
    
    function ToggleLabel(PopulatedInput) {
        var $PopulatedInput = $(PopulatedInput),
            $Label = $PopulatedInput.prev('label');
        if ($PopulatedInput.val() != "") {
            $Label.hide();
        }
        else {
            $Label.show();
        }
    };

    /**
     * @function
     * @param {jQueryObject} $Inputs is an object containing input fields
     * @description
     *      This function is used initially and hides labels of
     *      already filled out input fields (auto population of browsers)
     *      and focuses on the first next 'non-filled-out' input field.
     * @return nothing
     */
    function CheckInputs($Inputs){
        var LastFilledElement = 0;
        $.each($Inputs, function(Index, Input) {
            if($(Input).val()){
                ToggleLabel(Input);
                LastFilledElement = Index;
            }
        });
        if (LastFilledElement != 0) {
            $Inputs[LastFilledElement + 1].focus();
        }
    }

    /**
     * @function
     * @description
     *      This function makes the whole row in the MyTickets and CompanyTickets view clickable.
     * @return nothing
     */
    
    TargetNS.ClickableRow = function(){
        $("table tr").click(function(){
            window.location.href = $("a", this).attr("href");
        });
    };

    /**
     * @function
     * @description
     *      This function adds the class 'Js' to the 'Body' div to enhance the interface (clickable rows).
     * @return nothing
     */
    TargetNS.Enhance = function(){
        $('body').addClass('Js');
    }

    /**
     * @function
     * @description
     *      This function binds functions to the 'MessageHeader' and the 'Reply' button
     *      to toggle the visibility of the MessageBody and the reply form.
     *      Also it checks the iframes to resize them to their full (inner) size
     *      and hides the quotes inside the iframes + adds an anchor to toggle the visibility of the quotes
     * @return nothing
     */
    TargetNS.InitTicketZoom = function(){
        var $Messages = $('#Messages > li'),
            $LastIframe = $Messages.last().find('iframe'),
            $MessageHeaders = $('.MessageHeader', $Messages);
           
        $MessageHeaders.click(function(Event){
            var $Message = $(this).parent();
            ToggleMessage($Message);
            Event.preventDefault();
        });
        $('#ReplyButton').click(function(Event){
            Event.preventDefault();
            var $FollowUp = $(this).parent().toggleClass('Visible');
            $('html').animate({scrollTop: $('#Body').height()}, 0);
            RichTextFocus();
        });
        CheckIframe($LastIframe);
        $LastIframe
        //$Messages.not(':last').removeClass('Visible');
    }
    
    function ToggleMessage($Message){
        var $Status = $('> input[name=ArticleState]', $Message);
        switch ($Status.val()){
            case "untouched":
                LoadMessage($Message, $Status);
            break;
            case "true":
                $Message.removeClass('Visible');
                $Status.val("false");
            break;
            case "false":
                $Message.addClass('Visible');
                $Status.val("true");
            break;
        }
        /*  Change Subject to Loading */
        /*  Load iframe -> get title and put it in src */
        /*  Hide quotes and resize -> HideQuote(Iframe) */
        /*  Set StateStorage to true */
        /*  Show MessageContent -> add class Visible */
        /*  Change Subject back from Loading */
        
        
        /*var Visible = $Message.hasClass('Invisible') ? false : true,
            $StateStorage = $('> input[name=ArticleShown]', $Message);
            
            
        if(Visible){
            $Message.addClass('Invisible');
            $StateStorage.val("false");
        }
        else {
            $Message.removeClass('Invisible');
            $StateStorage.val("true");
        }*/
    }
    
    function LoadMessage($Message, $Status){
        var $SubjectHolder = $('h3 span', $Message),
            Subject = $SubjectHolder.text(),
            LoadingString = $SubjectHolder.attr('title'),
            $Iframe = $('iframe', $Message),
            Source = $Iframe.attr('title');
        $SubjectHolder.text(LoadingString);
        $Iframe.attr('src', Source);
        CheckIframe($Iframe);
        $Message.addClass('Visible');
        $Status.val('true');
        $SubjectHolder.text(Subject);
    }

    /**
     * @function
     * @param {DOMObject} an iframe
     * @description
     *      This function contains some workarounds for all browsers to get resize the iframe
     * @see http://sonspring.com/journal/jquery-iframe-sizing
     * @return nothing
     */
    function CheckIframe(Iframe){
        if ($.browser.safari || $.browser.opera){
            $(Iframe).load(function(){
                setTimeout(HideQuote, 0, this);
            });
            var Source = Iframe.src;
            Iframe.src = '';
            Iframe.src = Source;
        }
        else {
            $(Iframe).load(function(){
                HideQuote(this);
            });
        }
    }

    /**
     * @function
     * @param {DOMObject} an iframe
     * @description
     *      finds the quote in an iframe (type=cite), hides it and 
     *      adds an anchor in front of the hidden quote to toggle the visibility of the quote
     * @return nothing
     */
    
    function HideQuote(Iframe){
        $(Iframe)
            .contents().find('[type=cite]').hide()
            .before('<a href="" style="color:blue">Show quoted text</a>')
            // add a toggle listener to the anchor (the prev element we just added)
            .prev().toggle(
                function(){ // show quote, change anchor name, recalculate iframe height
                    $(this).next().show().text("Hide quoted text");
                    CalculateHeight($(Iframe));
                },
                function(){ // hide quote, change anchor name, recalculate iframe height
                    $(this).next().hide().text("Show quoted text");
                    CalculateHeight($(Iframe));
                }
            );
        // initial height calculation
        CalculateHeight(Iframe);
    }

    /**
     * @function
     * @param {DOMObject} an iframe
     * @description
     *      sets the size of the iframe to the size of its inner html
     *      .contents accesses the iframe to get its height
     * @return nothing
     */
    
    function CalculateHeight(Iframe){ 
        var Newheight = $(Iframe).contents().find('html').outerHeight();
        if(Newheight > 2500){ Newheight = 2500; }
        $(Iframe).height(Newheight);
    }

    return TargetNS;
}(OTRS.App.Customer || {}));