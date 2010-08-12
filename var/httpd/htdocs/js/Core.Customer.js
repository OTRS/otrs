// --
// Core.Customer.js - provides functions for the customer login
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.Customer.js,v 1.6 2010-08-12 03:22:07 mp Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};

/**
 * @namespace
 * @exports TargetNS as Core.Customer
 * @description
 *      This namespace contains all form functions.
 */
Core.Customer = (function (TargetNS) {
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
     */
    TargetNS.InitLogin = function (LoginFailed) {
        var $Inputs = $('input:not(:checked, :hidden, :radio)'),
            Now = new Date(),
            Diff = Now.getTimezoneOffset(),
            $Label,
            $SliderNavigationLinks = $('#Slider a');

        
        $('#TimeOffset').val(Diff);

        $Inputs
            .focus(function () {
                $Label = $(this).prev('label');
                $(this).prev('label').addClass('Focused');
                if ($(this).val()) $Label.hide();
            })
            .bind('keyup change', function () {
                ToggleLabel(this);
            })
            .blur(function () {
                $Label = $(this).prev('label');
                if (!$(this).val())  $Label.show();
                $Label.removeClass('Focused');
            });
         
         $('#User').blur(function () {
            var value = $(this).val();
            if (value) {
                // set the username-value and hide the field's label
                $('#ResetUser').val('').prev('label').hide();
            }
         });
                        
          CheckInputs($Inputs);

        // Fill the reset-password input field with the same value the user types in the login screen
        // so that the user doesnt have to type in his user name again if he already did
        $('#User').blur(function () {
            var value = $(this).val();
            if (value) {
                // clear the username-value and hide the field's label
                $('#ResetUser').val(value).prev('label').hide();
            }
        });

        // detect the location ("SignUp", "Reset" or "Login"):
        // first get the url
        var LocationString = document.location.toString();

        // default location is "Login"
        var Location = '#Login';

        // check if the url contains an anchor
        if (LocationString.match('#')) {

            // cut out the anchor
            Location = '#' + LocationString.split('#')[1];
        }

        // get the input fields of the current location
        var $LocalInputs = $(Location).find('input:not(:checked, :hidden, :radio)');

        // focus the first one
        $LocalInputs.first().focus();

        // add all tab-able inputs
        $LocalInputs.add($(Location + ' a, button'));

        // collect all global tab-able inputs
        var $TabableInputs = $Inputs.add('a, button');

        // give the input fields of all other slides a negative 'tabindex' to prevent
        // the user from accidentally jumping to a hidden input field via the tab key
        $TabableInputs.not($LocalInputs).attr('tabindex', -1);


        // Change the 'tabindex' according to the navigation of the user
        $SliderNavigationLinks.click(function () {

            // get the target id out of the href attribute of the anchor
            var TargetID = $(this).attr('href');
            var I = 0;
            var $TargetInputs = $(TargetID + ' input:not(:checked, :hidden, :radio), ' + TargetID +' a, ' + TargetID+ ' button');
            var InputsLength = $TargetInputs.length;

            // give the inputs on the slide the user just leaves all a 'tabindex' of '-1'
            var Elements = $(this).parentsUntil('#SlideArea').last().find('input:not(:checked, :hidden, :radio), a, button').attr('tabindex', -1);

            // give all inputs on the new shown slide an increasing 'tabindex'
            for (I; I< InputsLength;I++) {
                $TargetInputs.eq(I).attr('tabindex', I + 1);
            }
        });

        // shake login box on autentification failed
        if (LoginFailed) {
            Core.UI.Shake($('#Login'));
        }
    };

    /**
     * @function
     * @param {DOMObject} $PopulatedInput is a filled out input filled
     * @description
     *      This function hides the label of the given field if there is value in the field.
     *      If there is no value in the given field the label is made visible.
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
     */
    function CheckInputs($Inputs){
        var LastFilledElement;
        var NavigationFocus = { 
            'User'     : 'Password', 
            'Password' : 'LoginSubmit',
            'ResetUser': 'ResetSubmit', 
        }; 

        $.each($Inputs, function(Index, Input) {
            if($(Input).val()){
                ToggleLabel(Input);
                LastFilledElement = this.id;
            }
        });
        
        if ($.inArray(LastFilledElement,NavigationFocus,true)) {
            $('#'+NavigationFocus[LastFilledElement]).focus();
           // $Inputs[LastFilledElement].focus();
        }
    }

    /**
     * @function
     * @description
     *      This function makes the whole row in the MyTickets and CompanyTickets view clickable.
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
     */
    TargetNS.Enhance = function(){
        $('body').addClass('Js');
    }

    TargetNS.InitFocus = function(){
        $('input[type="text"]').first().focus();
    }

    /**
     * @function
     * @description
     *      This function binds functions to the 'MessageHeader' and the 'Reply' button
     *      to toggle the visibility of the MessageBody and the reply form.
     *      Also it checks the iframes to resize them to their full (inner) size
     *      and hides the quotes inside the iframes + adds an anchor to toggle the visibility of the quotes
     */
    TargetNS.InitTicketZoom = function(){
        var $Messages = $('#Messages > li'),
            $VisibleMessage = $Messages.last(),
            $VisibleIframe = $('#VisibleFrame'),
            $MessageHeaders = $('.MessageHeader', $Messages),
            $FollowUp = $('#FollowUp'),
            $RTE = $('#RichText');

        $MessageHeaders.click(function(Event){
            ToggleMessage($(this).parent());
            Event.preventDefault();
        });
        $('#ReplyButton').click(function(Event){
            Event.preventDefault();
            $FollowUp.addClass('Visible');
            $('html').css({scrollTop: $('#Body').height()});
            Core.UI.RichTextEditor.Focus($RTE);
        });
        $('#CloseButton').click(function(Event){
            Event.preventDefault();
            $FollowUp.removeClass('Visible');
            $('html').css({scrollTop: $('#Body').height()});
        });
        /* correct the status saved in the hidden field of the initial visible message */
        $LastMessageStatus = $('> input[name=ArticleState]', $VisibleMessage).val("true");
        HideQuote($VisibleIframe);
    }

    /**
     * @function
     * @description
     *      This function checkes the value of a hidden input field containing the state of the article:
     *      untouched (= not yet loaded), true or false. If the article is allready loaded (-> true), and
     *      user calles this function by clicking on the messagehead, the article gets hidden by removing
     *      the class 'Visible' and the status changes to false. If the messagehead is clicked while the
     *      status is false (e.g. the article is hidden), the article gets the class 'Visible' again and
     *      the status gets changed to true.
     */

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
    }

    /**
     * @function
     * @description
     *      This function is called when an articles should be loaded. Our trick is, to hide the
     *      url of a containing iframe in the title attribute of the iframe so that it doesn't load
     *      immediately when the site loads. So we set the url in this function.
     */

    function LoadMessage($Message, $Status){
        var $SubjectHolder = $('h3 span', $Message),
            Subject = $SubjectHolder.text(),
            LoadingString = $SubjectHolder.attr('title'),
            $Iframe = $('iframe', $Message),
            Source = $Iframe.attr('title');

        /*  Change Subject to Loading */
        $SubjectHolder.text(LoadingString);

        /*  Load iframe -> get title and put it in src */
        if(Source != 'about:blank') $Iframe.attr('src', Source);

        var callback = function(){
            /*  Set StateStorage to true */
            $Status.val('true');

            /*  Show MessageContent -> add class Visible */
            $Message.addClass('Visible');

            /*  Change Subject back from Loading */
            $SubjectHolder.text(Subject).attr('title', Subject);
        }

        if ($Iframe.length != 0) {
            CheckIframe($Iframe, callback);
        }
        else {
            callback();
        }
    }

    /**
     * @function
     * @param {DOMObject} an iframe
     * @description
     *      This function contains some workarounds for all browsers to get resize the iframe
     * @see http://sonspring.com/journal/jquery-iframe-sizing
     */
    function CheckIframe(Iframe, callback){
        if ($.browser.safari || $.browser.opera){
            $(Iframe).load(function(){
                setTimeout(HideQuote, 0, this, callback);
            });
            var Source = Iframe.src;
            Iframe.src = '';
            Iframe.src = Source;
        }
        else {
            $(Iframe).load(function(){
                HideQuote(this, callback);
            });
        }
    }

    /**
     * @function
     * @param {DOMObject} an iframe
     * @description
     *      finds the quote in an iframe (type=cite), hides it and
     *      adds an anchor in front of the hidden quote to toggle the visibility of the quote
     */

    function HideQuote(Iframe, callback){
        $(Iframe)
            .contents().find('[type=cite]').hide()
            .before('<a href="" style="color:blue">Show quoted text</a>')
            // add a toggle listener to the anchor (the prev element we just added)
            .prev().toggle(
                function(){ // show quote, change anchor name, recalculate iframe height
                    $(this).text("Hide quoted text").next().show();
                    CalculateHeight(Iframe);
                },
                function(){ // hide quote, change anchor name, recalculate iframe height
                    $(this).text("Show quoted text").next().hide();
                    setTimeout(CalculateHeight, 200, Iframe);
                }
            );
        // initial height calculation
        CalculateHeight(Iframe);
        if(callback) callback();
    }

    /**
     * @function
     * @param {DOMObject} an iframe
     * @description
     *      sets the size of the iframe to the size of its inner html
     *      .contents accesses the iframe to get its height
     */

    function CalculateHeight(Iframe){
        var NewHeight = $(Iframe).contents().find('html').outerHeight();
        if(NewHeight > 2500) NewHeight = 2500;
        $(Iframe).height(NewHeight);
    }

    return TargetNS;
}(Core.Customer || {}));
