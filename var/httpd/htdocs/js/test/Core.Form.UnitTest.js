// --
// Core.Form.UnitTest.js - UnitTests
// Copyright (C) 2001-2012 OTRS AG, http://otrs.org/\n";
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};

Core.Form = (function (Namespace) {
    Namespace.RunUnitTests = function(){
        module('Core.Form');
        test('Core.Form.DisableForm() and Core.Form.EnableForm()', function(){

            expect(26);

            /*
             * Create a form containter for the tests
             */
            var $TestForm = $('<form id="TestForm"></form>');
            $TestForm.append('<input type="text" value="ObjectOne" id="ObjectOne" name="ObjectOne" />');
            $TestForm.append('<input type="text" readonly="readonly" data-initially-readonly="readonly" value="ObjectOne" id="ObjectOne" name="ObjectOne" />');
            $TestForm.append('<input type="password" value="ObjectTwo" id="ObjectTwo" name="ObjectTwo" />');
            $TestForm.append('<input type="checkbox" value="ObjectThree" id="ObjectThree" name="ObjectThree" />');
            $TestForm.append('<input type="radio" value="ObjectFour" id="ObjectFour" name="ObjectFour" />');
            $TestForm.append('<input type="file" value="" id="ObjectFive" name="ObjectFive" />');
            $TestForm.append('<input type="hidden" value="ObjectSix" id="ObjectSix" name="ObjectSix" />');
            $TestForm.append('<textarea id="ObjectSeven" name="ObjectSeven">ObjectSeven</textarea>');
            $TestForm.append('<select id="ObjectEight" name="ObjectEight"><option value="1">EightOne</option><option value="2">EightTwo</option></select>');
            $TestForm.append('<button value="ObjectNine" type="submit" id="ObjectNine">ObjectNine</button>');
            $TestForm.append('<button value="ObjectTen" type="button" id="ObjectTen">ObjectTen</button>');
            $TestForm.append('<button value="ObjectTen" type="button" disabled="disabled" data-initially-disabled="disabled" id="ObjectTen">ObjectTen</button>');
            $('body').append($TestForm);

            /*
             * Run the tests
             */

            /*
             * Disable a form containter
             */
            Core.Form.DisableForm($('#TestForm'));

            equal($('#TestForm').hasClass("AlreadyDisabled"), true, 'Form is already disabled' );

            $.each($('#TestForm').find("input, textarea, select, button"), function(key, value) {


                var readonlyValue = $(this).attr('readonly');
                var tagnameValue  = $(this).prop('tagName');
                var typeValue     = $(this).attr('type');
                var disabledValue = $(this).attr('disabled');

                if (tagnameValue == "BUTTON") {
                    equal(disabledValue, 'disabled', 'disabledValue for BUTTON' );
                }
                else {
                    if (typeValue == "hidden") {
                        equal(readonlyValue, undefined, 'readonlyValue for ' + tagnameValue );
                    }
                    else {
                        equal(readonlyValue, 'readonly', 'readonlyValue for ' + tagnameValue  );
                    }
                }
            });


            /*
             * Enable a form containter
             */
            Core.Form.EnableForm($('#TestForm'));

            equal($('#TestForm').hasClass("AlreadyDisabled"), false, 'Form is not already disabled' );

            $.each($('#TestForm').find("input, textarea, select, button"), function(key, value) {

                var readonlyValue = $(this).attr('readonly');
                var tagnameValue  = $(this).prop('tagName');
                var typeValue     = $(this).attr('type');
                var disabledValue = $(this).attr('disabled');
                var expectedDisabledValue = $(this).data('initially-disabled') ? 'disabled' : undefined;
                var expectedReadonlyValue = $(this).data('initially-readonly') ? 'readonly' : undefined;


                if (tagnameValue == "BUTTON") {
                    equal(disabledValue, expectedDisabledValue, 'enabledValue for BUTTON' );
                }
                else {
                    if (typeValue == "hidden") {
                        equal(readonlyValue, expectedReadonlyValue, 'readonlyValue for ' + tagnameValue );
                    }
                    else {
                        equal(readonlyValue, expectedReadonlyValue, 'readonlyValue for ' + tagnameValue );
                    }
                }
            });

            /*
             * Cleanup div container and contents
             */
            $('#TestForm').remove();
        });
    };

    return Namespace;
}(Core.Form || {}));
