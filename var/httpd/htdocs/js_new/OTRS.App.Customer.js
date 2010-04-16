// --
// OTRS.Customer.js - provides functions for the customer login
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.App.Customer.js,v 1.2 2010-04-16 18:07:45 fn Exp $
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
 * @description
 *      This namespace contains all form functions.
 */
OTRS.App.Customer = (function (Namespace) {
    /**
     * @function
     * @description
     *      This function initializes the login functions. 
     *      In the login we have three steps:
     *      1. input field gets focused -> label gets greyed out via class="focused"
     *      2. something is typed -> label gets hidden
     *      3. user leaves input field -> if the field is blank the label gets shown again, 'focused' class gets removed
     *      After the bindings of the functions to the input fields the 
     * @return nothing
     */
    Namespace.InitLogin = function() {
        var Inputs = $('input').not(':checkbox, :hidden'),
            Now = new Date(),
            Diff = Now.getTimezoneOffset();
            
        $('#TimeOffset').val(Diff);
        
        Inputs
            .focus(function(){
                $(this).prev('label').addClass('focused');
            })
            .bind('keyup change', function(){
                Namespace.ToggleLabel($(this));
            })
            .blur(function(){
                if (!$(this).val()) {
                    $(this).prev('label').show();
                }
                $(this).prev('label').removeClass('focused');
            })
            .first().focus();
        CheckInputs(Inputs);
    };
    
    /**
     * @function
     * @param {DOMObject} $PopulatedInput is a filled out input filled
     * @description
     *      This function hides the label of the given field if there is value in the field. 
     *      If there is no value in the given field the label is made visible.
     * @return nothing
     */
    
    Namespace.ToggleLabel = function(PopulatedInput){
        if ($(PopulatedInput).val() != "") {
            $(PopulatedInput).prev('label').hide();
        }
        else {
            $(PopulatedInput).prev('label').show();
        }
    };

    /**
     * @function
     * @description
     *      This function is used initially and hides labels of 
     *      already filled out input fields (auto population of browsers)
     *      and to focus on the first next 'non-filled-out' input field.
     * @return nothing
     */
    function CheckInputs($Inputs){
        $.each($Inputs, function(Index, Input){
            if($(Input).val()){
                Namespace.ToggleLabel(Input);
                $Inputs[Index+1].focus();
            }
        });
    }
    
    /**
     * @function
     * @description
     *      This function makes the whole row in the MyTickets and CompanyTickets view clickable.
     * @return nothing
     */
    Namespace.ClickableRow = function(){
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
    Namespace.Enhance = function(){
        $('#Body').addClass('Js');
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
    Namespace.InitTicketZoom = function(){
        var Iframes = $('iframe');
        $('.MessageHeader').click(function(event){
            event.preventDefault();
            $(this).parents('.Message').toggleClass('Visible');
        });
        $('.Reply').click(function(event){
            event.preventDefault();
            var Footer = $(this).parents('.MessageFooter').toggleClass('Visible');
            $('textarea', Footer).focus();
        });
        $.each(Iframes, function(Index, Iframe){
            CheckIframes(Iframe);
        });
        Iframes.not(':last').parents('.Message').removeClass('Visible');
    }
    
    /**
     * @function
     * @param {DOMObject} an iframe
     * @description
     *      This function contains some workarounds for all browsers to get resize the iframe
     * @see http://sonspring.com/journal/jquery-iframe-sizing
     * @return nothing
     */
    function CheckIframes(Iframe){
        
        if ($.browser.safari || $.browser.opera){
            $(this).load(function(){
                    setTimeout(HideQuote, 0, this);
                }
            );
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
     *      sets the size of the iframe to the size of its inner html
     *      .contents accesses the iframe to get its height
     * @return nothing
     */
    
    function CalculateHeight(Iframe){ 
        // .contents to access the iframe document
        var Newheight = $(Iframe).contents().find('html').outerHeight();
        $(Iframe).height(Newheight);
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
        $(Iframe).contents().find('[type=cite]').hide()
        // add an anchor in front of them
        .before('<a href="" style="color:blue">Show quoted text</a>')
        // add a toggle listener to the anchor (the prev element we just added)
        .prev().toggle(
            function(){ // show quote, change anchor name, recalculate iframe height
                $(this).next().show();
                $(this).text("Hide quoted text");
                CalculateHeight($(Iframe));
            },
            function(){ // hide quote, change anchor name, recalculate iframe height
                $(this).next().hide();
                $(this).text("Show quoted text");
                CalculateHeight($(Iframe));
            }
        );
        // initial height calculation
        CalculateHeight(Iframe);
    }
    
    return Namespace;
}(OTRS.App.Customer || {}));