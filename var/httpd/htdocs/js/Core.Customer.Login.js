// --
// Core.Customer.js - provides functions for the customer login
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.Customer.Login.js,v 1.1 2010-08-24 09:29:57 mg Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.Customer = Core.Customer || {};

/**
 * @namespace
 * @exports TargetNS as Core.Customer.Login
 * @description
 *      This namespace contains all functions for the Customer login
 */
Core.Customer.Login = (function (TargetNS) {
    if (!Core.Debug.CheckDependency('Core.Customer.Login', 'Core.UI', 'Core.UI')) {
        return;
    }

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
    }

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
    TargetNS.Init = function (Options) {
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
        if (Options && Options.LastLoginFailed) {
            Core.UI.Shake($('#Login'));
        }
    };

    return TargetNS;
}(Core.Customer.Login || {}));
