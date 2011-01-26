// --
// Core.Form.Validate.UnitTest.js - UnitTests
// Copyright (C) 2001-2011 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.Form.Validate.UnitTest.js,v 1.1 2011-01-26 12:24:54 mn Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};
Core.Form = Core.Form || {};

Core.Form.Validate = (function (Namespace) {
    Namespace.RunUnitTests = function(){
        module('Core.Form.Validate');
        test('Remove ServerError only after the user changed the field - bug#6736', function(){

            expect(14);

            /*
             * Create a form containter for the tests
             */
            var $TestForm = $('<form id="TestForm" class="Validate"></form>');
            $TestForm.append('<input type="text" value="ObjectOne" id="ObjectOne" name="ObjectOne" class="ServerError" />');
            $TestForm.append('<input type="password" value="ObjectTwo" id="ObjectTwo" name="ObjectTwo" class="ServerError" />');
            $TestForm.append('<input type="checkbox" value="ObjectThree" id="ObjectThree" name="ObjectThree" class="ServerError" />');
            $TestForm.append('<input type="radio" value="ObjectFour" id="ObjectFour" name="ObjectFour" class="ServerError" />');
            $TestForm.append('<input type="hidden" value="ObjectSix" id="ObjectSix" name="ObjectSix" class="ServerError" />');
            $TestForm.append('<textarea id="ObjectSeven" name="ObjectSeven" class="ServerError">ObjectSeven</textarea>');
            $TestForm.append('<select id="ObjectEight" name="ObjectEight" class="ServerError"><option value="1">EightOne</option><option value="2">EightTwo</option></select>');
            $('body').append($TestForm);

            /*
             * Run the tests
             */

            /*
             * Disable a form containter
             */
            //overload ServerError dialog
            Core.UI.Dialog.ShowAlert = function () {
                return true;
            };
            Core.Form.Validate.Init();

            $.each($('#TestForm').find("input, textarea, select"), function() {
                // only focus and leave field again, the same as a validation
                Core.Form.Validate.ValidateElement($(this));

                equals($(this).hasClass('Error'), true);

                // now focus field, change something and leave again
                if ($(this).is('input:text, input:password, input:hidden, textarea, select')) {
                    $(this).val('2');
                }
                else if ($(this).is('input:checkbox, input:radio')) {
                    $(this).attr('checked', !$(this).attr('checked'));
                }

                Core.Form.Validate.ValidateElement($(this));

                equals($(this).hasClass('Error'), false);
            });

            /*
             * Cleanup div container and contents
             */
            $('#TestForm').remove();
        });
    };

    return Namespace;
}(Core.Form.Validate || {}));