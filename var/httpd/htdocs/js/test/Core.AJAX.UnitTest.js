// --
// Core.AJAX.UnitTest.js - UnitTests
// Copyright (C) 2001-2012 OTRS AG, http://otrs.org/\n";
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.AJAX = Core.AJAX || {};

Core.AJAX = (function (Namespace) {
    Namespace.RunUnitTests = function(){
        var SerializeFormTests,
            ContentUpdateTests,
            FunctionCallTests,
            FormUpdateTests,
            ErrorHandlingFunc,
            OldBaselink;

        module('Core.AJAX');

        /*
         * Core.AJAX.SerializeForm
         */

        SerializeFormTests =
        [
             {
                 HTML:   '',
                 Result: '',
                 Name:   'Empty form.'

             },
             {
                 HTML:   '<input type="checkbox" value="test" checked="checked"/>',
                 Result: '',
                 Name:   'Checkbox without name'

             },
             {
                 HTML:   '<input type="checkbox" value="test" name="Element" checked="checked"/>',
                 Result: 'Element=test;',
                 Name:   'Checkbox with custom value, checked'

             },
             {
                 HTML:   '<input type="checkbox" value="test" name="Element@" checked="checked"/>',
                 Result: 'Element%40=test;',
                 Name:   'Checkbox funky name, checked'

             },
             {
                 HTML:   '<input type="checkbox" name="Element" checked="checked"/>',
                 Result: 'Element=on;',
                 Name:   'Checkbox with custom value, checked'

             },
             {
                 HTML:   '<input type="checkbox" name="Element" value="test" checked="checked"/><input type="checkbox" name="Element" value="test2" checked="checked"/><input type="checkbox" name="Element" value="test3"/>',
                 Result: 'Element=test;Element=test2;',
                 Name:   'Multiple checkboxes with the same name'

             },
             {
                 HTML:   '<input type="checkbox" value="test" name="Element"/>',
                 Result: '',
                 Name:   'Checkbox with custom value, unchecked'

             },
             {
                 HTML:   '<input type="radio" value="test" name="Element" checked="checked"/>',
                 Result: 'Element=test;',
                 Name:   'Radio with custom value, checked'

             },
             {
                 HTML:   '<input type="radio" value="test" name="Element" /><input type="radio" value="test2" name="Element" checked="checked"/><input type="radio" value="test3" name="Element"/>',
                 Result: 'Element=test2;',
                 Name:   'Radio with custom value, checked'

             },
             {
                 HTML:   '<input type="Radio" name="Element" checked="checked"/>',
                 Result: 'Element=on;',
                 Name:   'Multiple radios with custom value, checked'

             },
             {
                 HTML:   '<input type="checkbox" value="test" name="Element"/>',
                 Result: '',
                 Name:   'Radio with custom value, unchecked'

             },
             {
                 HTML:   '<select name="Element" multiple="multiple"><option value="1" selected="selected">one</option><option value="2" selected="selected">two</option></select>',
                 Result: 'Element=1;Element=2;',
                 Name:   'Multi-select with multiple values'

             },
             {
                 HTML:   '<select name="Element" multiple="multiple"><option value="1" selected="selected">one</option><option value="2">two</option></select>',
                 Result: 'Element=1;',
                 Name:   'Multi-Select with one value'

             },
             {
                 HTML:   '<select name="Element" multiple="multiple"><option value="1">one</option><option value="2">two</option></select>',
                 Result: '',
                 Name:   'Multi-select, empty'

             },
             {
                 HTML:   '<select name="Element"><option value="1" selected="selected">one</option><option value="2" selected="selected">two</option></select>',
                 Result: 'Element=2;',
                 Name:   'Select with one value but multiple preselected'

             },
             {
                 HTML:   '<select name="Element"><option value="1">one</option><option value="2">two</option></select>',
                 Result: 'Element=1;',
                 Name:   'Select, empty'

             },
             {
                 HTML:   '<input type="text" name="Element"/>',
                 Result: 'Element=;',
                 Name:   'Textarea, empty'

             },
             {
                 HTML:   '<input type="text" name="Element"/>',
                 Result: 'Element=;',
                 Name:   'Textarea, empty with value attribute'

             },
             {
                 HTML:   '<input type="text" value="test" name="Element"/>',
                 Result: 'Element=test;',
                 Name:   'Textarea, simple'

             },
             {
                 HTML:   '<textarea name="Element">1\n2</textarea>',
                 Result: 'Element=1%0A2;',
                 Name:   'Textarea, with newline'

             },
             {
                 HTML:   '<textarea name="Element">1\n2</textarea><textarea name="Element2">1\n2</textarea>',
                 Ignore: { Element: 1 },
                 Result: 'Element2=1%0A2;',
                 Name:   'Textarea, test Ignore parameter'

             },
             {
                 HTML:   '<input type="hidden" name="Element" value="12 3"/>',
                 Result: 'Element=12%203;',
                 Name:   'Hidden field'

             }
        ];

        test('Core.AJAX.SerializeForm()', SerializeFormTests.length, function(){

            // Create a form containter for the tests
            $('body').append('<form id="CORE_AJAX_SerializeFormTest"></form>');

            // Run the tests
            $.each(SerializeFormTests, function(){
                var Test = this;

                $('#CORE_AJAX_SerializeFormTest').empty().append(Test.HTML);
                equal(Core.AJAX.SerializeForm($('#CORE_AJAX_SerializeFormTest'), Test.Ignore), Test.Result, Test.Name);

            });

            // Cleanup form container and contents
            $('#CORE_AJAX_TestForm1').remove();
        });

        /*
         * Core.AJAX.ContentUpdate
         */

        ContentUpdateTests =
        [
             {
                 Expect: 2,
                 Name: 'Core.AJAX.ContentUpdate() simple select',
                 URL: 'sample/Core.AJAX.ContentUpdate1.html',
                 ResultCheck: function() {
                     equal($('#Core_AJAX_ContentUpdateTest_Element').val(), 2, 'Simple select');
                     equal($('#CORE_AJAX_ContentUpdateTest').children().length, 1, 'Number of form children');
                 }
             }
        ];

        $.each(ContentUpdateTests, function(){
            var Test = this;

            asyncTest(Test.Name, Test.Expect, function(){
                try {
                    $('body').append('<form id="CORE_AJAX_ContentUpdateTest"></form>');

                    Core.AJAX.ContentUpdate($('#CORE_AJAX_ContentUpdateTest'), Test.URL, function(){
                        try {
                            Test.ResultCheck();
                        }
                        catch (Error) {
                        }
                        finally {
                            $('#CORE_AJAX_ContentUpdateTest').remove();
                            start();
                        }
                    });
                }
                catch (Error) {
                    equal(true, false, 'Exception was thrown');
                    start();
                }
            });
        });

        /*
         * Core.AJAX.FunctionCall
         */

        FunctionCallTests =
        [
             {
                 Expect: 1,
                 Name: 'Core.AJAX.FunctionCall() simple select',
                 URL: 'sample/Core.AJAX.FunctionCall1.html',
                 Callback: function(Result) {
                     equal(Result, "1\n2\n3\n-", 'Function call with simple data');
                     start();
                 }
             }
         ];

        $.each(FunctionCallTests, function(){
            var Test = this;

            asyncTest(Test.Name, Test.Expect, function(){
                try {
                    Core.AJAX.FunctionCall(Test.URL, {}, Test.Callback, 'text');
                }
                catch (Error) {
                    equal(true, false, 'Exception was thrown');
                    start();
                }
            }, 'text');
        });

        /*
         * Tests for error handling
         */

        function ChangeErrorHandlingForTest() {
            ErrorHandlingFunc = Core.Exception.HandleFinalError;
            Core.Exception.HandleFinalError = function (Exception) {
                equal(Exception.GetType(), 'CommunicationError', 'Error handling called');
                start();
                RestoreOrignal();
            };

            OldBaselink = Core.Config.Get('Baselink');
        }

        function RestoreOrignal() {
            Core.Exception.HandleFinalError = ErrorHandlingFunc;
            Core.Config.Set('Baselink', OldBaselink);
        }

        // FormUpdate
        $('body').append('<div id="FormUpdateErrorHandling"><form id="FormUpdateErrorHandlingForm"><input type="text" value="Test1" name="Test1" id="Test1" /><input type="text" value="Test2" name="Test2" id="Test2" /></form></div>');

        FormUpdateTests =
        [
            {
                Expect: 1,
                Name: 'FormUpdate error handling - wrong url',
                URL: 'sample/Core.AJAX.FormUpdate-InvalidURL'
            },
            {
                Expect: 1,
                Name: 'FormUpdate error handling - empty response',
                URL: 'sample/Core.AJAX.EmptyResponse.html'
            }
        ];

        $.each(FormUpdateTests, function () {
            var Test = this;

            asyncTest(Test.Name, Test.Expect, function () {
                ChangeErrorHandlingForTest();
                Core.Config.Set('Baselink', Test.URL);
                try {
                    Core.AJAX.FormUpdate($('#FormUpdateErrorHandlingForm'), 'Subaction', 'Test1', ['Test2'], function () {
                        equal(true, false, 'Error handling was not called');
                        start();
                        RestoreOrignal();
                    });
                }
                catch (Error) {
                    equal(true, false, 'Error caught, Exception was thrown');
                    start();
                    RestoreOrignal();
                }
            });
        });

        //ContentUpdate
        $('#FormUpdateErrorHandling').remove();
        $('body').append('<div id="ContentUpdateErrorHandling"></div>');

        ContentUpdateTests =
        [
            {
                Expect: 1,
                Name: 'ContentUpdate error handling - wrong url',
                URL: 'sample/Core.AJAX.ContentUpdate-InvalidURL'
            },
            {
                Expect: 1,
                Name: 'ContentUpdate error handling - empty response',
                URL: 'sample/Core.AJAX.EmptyResponse.html'
            }
        ];

        $.each(ContentUpdateTests, function () {
            var Test = this;

            asyncTest(Test.Name, Test.Expect + 1, function () {
                ChangeErrorHandlingForTest();
                try {
                    Core.AJAX.ContentUpdate($('#ContentUpdateErrorHandling'), Test.URL, function () {
                        ok(true, 'Complete callback called');
                        RestoreOrignal();
                    });
                }
                catch (Error) {
                    equal(true, false, 'Error caught, Exception was thrown');
                    start();
                    RestoreOrignal();
                }
            });
        });

        // FunctionCall
        $('#ContentUpdateErrorHandling').remove();

        FunctionCallTests =
        [
            {
                 Expect: 1,
                 Name: 'FunctionCall error handling - wrong url',
                 URL: 'sample/Core.AJAX.FunctionCall-InvalidURL',
                 Callback: function () {
                     equal(true, false, 'Error handling was not called');
                     RestoreOrignal();
                 }
            }
        ];

        $.each(FunctionCallTests, function () {
            var Test = this;

            asyncTest(Test.Name, Test.Expect, function () {
                ChangeErrorHandlingForTest();
                try {
                    Core.AJAX.FunctionCall(Test.URL, {}, Test.Callback);
                }
                catch (Error) {
                    equal(true, false, 'Error caught, Exception was thrown');
                    start();
                    RestoreOrignal();
                }
            });
        });

        // FunctionCall - no callback defined
        FunctionCallTests =
        [
            {
                Expect: 1,
                Name: 'FunctionCall error handling - no callback',
                URL: 'sample/Core.AJAX.EmptyResponse.html',
                Callback: '2'
            }
        ];

        $.each(FunctionCallTests, function () {
            var Test = this;

            asyncTest(Test.Name, Test.Expect, function () {
                ChangeErrorHandlingForTest();
                // Special callback for this test
                Core.Exception.HandleFinalError = function (Exception) {
                    var ExceptionMessage = Exception.GetMessage();

                    ok(ExceptionMessage.match(/^Invalid callback method.+$/), 'Error handling called');
                    start();
                    RestoreOrignal();
                };
                try {
                    Core.AJAX.FunctionCall(Test.URL, {}, Test.Callback, 'html');
                }
                catch (Error) {
                    equal(true, false, 'Error caught, Exception was thrown');
                    start();
                    RestoreOrignal();
                }
            });
        });

        // test AJAX error message suppression on leaving the page
        asyncTest('AJAX error handling on leaving the page', 1, function () {
            var AboutToLeaveOriginal = Core.Exception.AboutToLeave,
                HandleFinalErrorOriginal = Core.Exception.HandleFinalError;

            Core.Exception.AboutToLeave = true;

            Core.Exception.HandleFinalError = function (ErrorObject, Trace) {
                var ErrorShownToUser = HandleFinalErrorOriginal(ErrorObject, Trace);

                equal(ErrorShownToUser, false, 'AJAX errors should be suppressed when leaving the page (custom error handler called)');
                start();

                Core.Exception.HandleFinalError = HandleFinalErrorOriginal;
                Core.Exception.AboutToLeave = AboutToLeaveOriginal;
            };

            //ChangeErrorHandlingForTest();
            try {
                Core.AJAX.FunctionCall('nonexisting.url', {}, function () {
                    equal(true, false, 'Callback on nonexisting URL');
                    start();
                });
            }
            catch (Error) {
                equal(true, false, 'Error caught, unexpected Exception was thrown');
                start();
            }
        });
    };

    return Namespace;
}(Core.AJAX || {}));