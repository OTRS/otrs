// --
// Copyright (C) 2001-2017 OTRS AG, http://otrs.com/\n";
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

            expect(22);

            /*
             * Create a form containter for the tests
             */
            var $TestForm = $('<form id="TestForm"></form>');
            $TestForm.append('<input type="text" value="ObjectOne" id="ObjectOne" name="ObjectOne" />');
            $TestForm.append('<input type="password" value="ObjectTwo" id="ObjectTwo" name="ObjectTwo" />');
            $TestForm.append('<input type="checkbox" value="ObjectThree" id="ObjectThree" name="ObjectThree" />');
            $TestForm.append('<input type="radio" value="ObjectFour" id="ObjectFour" name="ObjectFour" />');
            $TestForm.append('<input type="file" value="" id="ObjectFive" name="ObjectFive" />');
            $TestForm.append('<input type="hidden" value="ObjectSix" id="ObjectSix" name="ObjectSix" />');
            $TestForm.append('<textarea id="ObjectSeven" name="ObjectSeven">ObjectSeven</textarea>');
            $TestForm.append('<select id="ObjectEight" name="ObjectEight"><option value="1">EightOne</option><option value="2">EightTwo</option></select>');
            $TestForm.append('<button value="ObjectNine" type="submit" id="ObjectNine">ObjectNine</button>');
            $TestForm.append('<button value="ObjectTen" type="button" id="ObjectTen">ObjectTen</button>');
            $('body').append($TestForm);

            /*
             * Run the tests
             */

            /*
             * Disable a form containter
             */
            Core.Form.DisableForm($('#TestForm'));

            equals($('#TestForm').hasClass("AlreadyDisabled"), true );

            $.each($('#TestForm').find("input, textarea, select, button"), function(key, value) {
                var readonlyValue = $(this).attr('readonly');
                var tagnameValue  = $(this).attr('tagName');
                var typeValue     = $(this).attr('type');
                var disabledValue = $(this).attr('disabled');

                if (readonlyValue == 'readonly') {
                    readonlyValue = true;
                }

                if (tagnameValue == "BUTTON") {
                    equals(disabledValue, true );
                }
                else {
                    if (typeValue == "hidden") {
                        notEqual(readonlyValue, true );
                    }
                    else {
                        equals(readonlyValue, true );
                    }
                }
            });


            /*
             * Enable a form containter
             */
            Core.Form.EnableForm($('#TestForm'));

            notEqual($('#TestForm').hasClass("AlreadyDisabled"), true );

            $.each($('#TestForm').find("input, textarea, select, button"), function(key, value) {
                var readonlyValue = $(this).attr('readonly');
                var tagnameValue  = $(this).attr('tagName');
                var typeValue     = $(this).attr('type');
                var disabledValue = $(this).attr('disabled');

                if (readonlyValue == undefined) {
                    readonlyValue = false;
                }

                if (tagnameValue == "BUTTON") {
                    equals(disabledValue, false );
                }
                else {
                    if (typeValue == "hidden") {
                        equals(readonlyValue, false );
                    }
                    else {
                        equals(readonlyValue, false );
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
