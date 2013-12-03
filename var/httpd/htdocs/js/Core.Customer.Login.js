// --
// Core.Customer.Login.js - provides functions for the customer login
// Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
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
     * @param {DOMObject} $PopulatedInput is a filled out input filled
     * @description
     *      This function hides the label of the given field if there is value in the field
     *      or the field has focus, otherwise the label is made visible.
     */
    function ToggleLabel(PopulatedInput) {
        var $PopulatedInput = $(PopulatedInput),
            $Label = $PopulatedInput.prev('label');

        if ($PopulatedInput.val() !== "" || $PopulatedInput[0] === document.activeElement) {
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
     *      Time gets tracked in a hidden field.
     *      In the login we have four steps:
     *      1. input field gets focused -> label gets greyed out via class="Focused"
     *      2. something is typed -> label gets hidden
     *      3. user leaves input field -> if the field is blank the label gets shown again, 'focused' class gets removed
     *      4. first input field gets focused
     */
    TargetNS.Init = function (Options) {
        var $Inputs = $('input:not(:checked, :hidden, :radio)'),
            $LocalInputs,
            Location,
            Now = new Date(),
            Diff = Now.getTimezoneOffset(),
            $Label,
            $SliderNavigationLinks = $('#Slider a');

        // Browser is too old
        if (!Core.Debug.BrowserCheckCustomer()) {
            $('#Login').hide();
            $('#Reset').hide();
            $('#Signup').hide();
            $('#OldBrowser').show();
            return;
        }

        // enable login form
        Core.Form.EnableForm($('#Login form, #Reset form, #Signup form'));

        $('#TimeOffset').val(Diff);

        $Inputs
            .focus(function () {
                $Label = $(this).prev('label');
                $(this).prev('label').addClass('Focused');
                if ($(this).val()) {
                    $Label.hide();
                }
            })
            .bind('keyup change', function () {
                ToggleLabel(this);
            })
            .blur(function () {
                $Label = $(this).prev('label');
                if (!$(this).val()) {
                    $Label.show();
                }
                $Label.removeClass('Focused');
            });

         $('#User').blur(function () {
            if ($(this).val()) {
                // set the username-value and hide the field's label
                $('#ResetUser').val('').prev('label').hide();
            }
         });

         // check labels every 250ms, not all changes can be caught via
         //     events (e. g. when the user selects a predefined value
         //     from a browser auto completion list).
         window.setInterval(function(){
             $.each($Inputs, function(Index, Input) {
                 if($(Input).val()){
                     ToggleLabel(Input);
                 }
             });
         }, 250);

        // Fill the reset-password input field with the same value the user types in the login screen
        // so that the user doesnt have to type in his user name again if he already did
        $('#User').blur(function () {
            if ($(this).val()) {
                // clear the username-value and hide the field's label
                $('#ResetUser').val($(this).val()).prev('label').hide();
            }
        });

        // detect the location ("SignUp", "Reset" or "Login"):
        // default location is "Login"
        Location = '#Login';

        // check if the url contains an anchor
        if (document.location.toString().match('#')) {

            // cut out the anchor
            Location = '#' + document.location.toString().split('#')[1];
        }

        // get the input fields of the current location
        $LocalInputs = $(Location).find('input:not(:checked, :hidden, :radio)');

        // focus the first one
        $LocalInputs.first().focus();

        // add all tab-able inputs
        $LocalInputs.add($(Location + ' a, button'));

        // collect all global tab-able inputs
        // give the input fields of all other slides a negative 'tabindex' to prevent
        // the user from accidentally jumping to a hidden input field via the tab key
        $Inputs.add('a, button').not($LocalInputs).attr('tabindex', -1);

        // Change the 'tabindex' according to the navigation of the user
        $SliderNavigationLinks.click(function () {
            var I = 0,
                TargetID,
                $TargetInputs;

            TargetID = $(this).attr('href');

            // get the target id out of the href attribute of the anchor
            $TargetInputs = $(TargetID + ' input:not(:checked, :hidden, :radio), ' + TargetID +' a, ' + TargetID + ' button');

            // give the inputs on the slide the user just leaves all a 'tabindex' of '-1'
            $(this).parentsUntil('#SlideArea').last().find('input:not(:checked, :hidden, :radio), a, button').attr('tabindex', -1);

            // give all inputs on the new shown slide an increasing 'tabindex'
            for (I; I< $TargetInputs.length; I++) {
                $TargetInputs.eq(I).attr('tabindex', I + 1);
            }
        });

        // shake login box on authentication failure
        if (Options && Options.LastLoginFailed) {
            Core.UI.Shake($('#Login'));
        }
    };

    return TargetNS;
}(Core.Customer.Login || {}));
