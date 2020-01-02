// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
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

        QUnit.module('Core.AJAX');

        /*
         * Core.AJAX.SerializeForm
         */

        SerializeFormTests =
        [
             {
                 HTML: '',
                 Result: '',
                 Name: 'Empty form.'

             },
             {
                 HTML: '<input type="checkbox" value="test" checked="checked"/>',
                 Result: '',
                 Name: 'Checkbox without name'

             },
             {
                 HTML: '<input type="checkbox" value="test" name="Element" checked="checked"/>',
                 Result: 'Element=test;',
                 Name: 'Checkbox with custom value, checked'

             },
             {
                 HTML: '<input type="checkbox" value="test" name="Element@" checked="checked"/>',
                 Result: 'Element%40=test;',
                 Name: 'Checkbox funky name, checked'

             },
             {
                 HTML: '<input type="checkbox" name="Element" checked="checked"/>',
                 Result: 'Element=on;',
                 Name: 'Checkbox with custom value, checked'

             },
             {
                 HTML: '<input type="checkbox" name="Element" value="test" checked="checked"/><input type="checkbox" name="Element" value="test2" checked="checked"/><input type="checkbox" name="Element" value="test3"/>',
                 Result: 'Element=test;Element=test2;',
                 Name: 'Multiple checkboxes with the same name'

             },
             {
                 HTML: '<input type="checkbox" value="test" name="Element"/>',
                 Result: '',
                 Name: 'Checkbox with custom value, unchecked'

             },
             {
                 HTML: '<input type="radio" value="test" name="Element" checked="checked"/>',
                 Result: 'Element=test;',
                 Name: 'Radio with custom value, checked'

             },
             {
                 HTML: '<input type="radio" value="test" name="Element" /><input type="radio" value="test2" name="Element" checked="checked"/><input type="radio" value="test3" name="Element"/>',
                 Result: 'Element=test2;',
                 Name: 'Radio with custom value, checked'

             },
             {
                 HTML: '<input type="Radio" name="Element" checked="checked"/>',
                 Result: 'Element=on;',
                 Name: 'Multiple radios with custom value, checked'

             },
             {
                 HTML: '<input type="checkbox" value="test" name="Element"/>',
                 Result: '',
                 Name: 'Radio with custom value, unchecked'

             },
             {
                 HTML: '<select name="Element" multiple="multiple"><option value="1" selected="selected">one</option><option value="2" selected="selected">two</option></select>',
                 Result: 'Element=1;Element=2;',
                 Name: 'Multi-select with multiple values'

             },
             {
                 HTML: '<select name="Element" multiple="multiple"><option value="1" selected="selected">one</option><option value="2">two</option></select>',
                 Result: 'Element=1;',
                 Name: 'Multi-Select with one value'

             },
             {
                 HTML: '<select name="Element" multiple="multiple"><option value="1">one</option><option value="2">two</option></select>',
                 Result: '',
                 Name: 'Multi-select, empty'

             },
             {
                 HTML: '<select name="Element"><option value="1" selected="selected">one</option><option value="2" selected="selected">two</option></select>',
                 Result: 'Element=2;',
                 Name: 'Select with one value but multiple preselected'

             },
             {
                 HTML: '<select name="Element"><option value="1">one</option><option value="2">two</option></select>',
                 Result: 'Element=1;',
                 Name: 'Select, empty'

             },
             {
                 HTML: '<input type="text" name="Element"/>',
                 Result: 'Element=;',
                 Name: 'Textarea, empty'

             },
             {
                 HTML: '<input type="text" name="Element"/>',
                 Result: 'Element=;',
                 Name: 'Textarea, empty with value attribute'

             },
             {
                 HTML: '<input type="text" value="test" name="Element"/>',
                 Result: 'Element=test;',
                 Name: 'Textarea, simple'

             },
             {
                 HTML: '<textarea name="Element">1\n2</textarea>',
                 Result: 'Element=1%0A2;',
                 Name: 'Textarea, with newline'

             },
             {
                 HTML: '<textarea name="Element">1\n2</textarea><textarea name="Element2">1\n2</textarea>',
                 Ignore: { Element: 1 },
                 Result: 'Element2=1%0A2;',
                 Name: 'Textarea, test Ignore parameter'

             },
             {
                 HTML: '<input type="hidden" name="Element" value="12 3"/>',
                 Result: 'Element=12%203;',
                 Name: 'Hidden field'

             }
        ];

        QUnit.test('Core.AJAX.SerializeForm()', function(Assert){

            Assert.expect(SerializeFormTests.length);

            // Create a form container for the tests
            $('body').append('<form id="CORE_AJAX_SerializeFormTest"></form>');

            // Run the tests
            $.each(SerializeFormTests, function(){
                var Test = this;

                $('#CORE_AJAX_SerializeFormTest').empty().append(Test.HTML);
                Assert.equal(Core.AJAX.SerializeForm($('#CORE_AJAX_SerializeFormTest'), Test.Ignore), Test.Result, Test.Name);

            });

            // Cleanup form container and contents
            $('#CORE_AJAX_SerializeFormTest').remove();
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
                 ResultCheck: function(Assert) {
                     Assert.equal($('#Core_AJAX_ContentUpdateTest_Element').val(), 2, 'Simple select');
                     Assert.equal($('#CORE_AJAX_ContentUpdateTest').children().length, 1, 'Number of form children');
                 }
             }
        ];

        $.each(ContentUpdateTests, function(){
            var Test = this;

            QUnit.test(Test.Name, function(Assert){
                var Done = Assert.async();

                Assert.expect(Test.Expect);

                try {
                    $('body').append('<form id="CORE_AJAX_ContentUpdateTest"></form>');

                    Core.AJAX.ContentUpdate($('#CORE_AJAX_ContentUpdateTest'), Test.URL, function(){
                        try {
                            Test.ResultCheck(Assert);
                        }
                        finally {
                            $('#CORE_AJAX_ContentUpdateTest').remove();
                            Done();
                        }
                    });
                }
                catch (Error) {
                    Assert.equal(true, false, 'Exception was thrown');
                    Done();
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
                 Callback: function(Result, Assert, Done) {
                     Assert.equal(Result, "1\n2\n3\n-\n", 'Function call with simple data');
                     Done();
                 }
             }
         ];

        $.each(FunctionCallTests, function(){
            var Test = this;

            QUnit.test(Test.Name, function(Assert){
                var Done = Assert.async();

                Assert.expect(Test.Expect);

                Core.App.Subscribe('Event.AJAX.FunctionCall.Callback', function (Response) {
                    Test.Callback(Response, Assert, Done);
                });

                try {
                    Core.AJAX.FunctionCall(Test.URL, {}, $.noop, 'text');
                }
                catch (Error) {
                    Assert.equal(true, false, 'Exception was thrown');
                    Done();
                }
            }, 'text');
        });

        /*
         * Tests for error handling
         */

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

            QUnit.test(Test.Name, function (Assert) {
                var Done = Assert.async();

                function ChangeErrorHandlingForTest() {
                    ErrorHandlingFunc = Core.Exception.HandleFinalError;
                    Core.Exception.HandleFinalError = function (Exception) {
                        Assert.equal(Exception.GetType(), 'CommunicationError', 'Error handling called');
                        RestoreOrignal();
                        Done();
                    };

                    OldBaselink = Core.Config.Get('Baselink');
                }

                Assert.expect(Test.Expect);

                ChangeErrorHandlingForTest();
                Core.Config.Set('Baselink', Test.URL);
                try {
                    Core.AJAX.FormUpdate($('#FormUpdateErrorHandlingForm'), 'Subaction', 'Test1', ['Test2'], function () {
                        Assert.equal(true, false, 'Error handling was not called');
                        RestoreOrignal();
                        Done();
                    });
                }
                catch (Error) {
                    Assert.equal(true, false, 'Error caught, Exception was thrown');
                    RestoreOrignal();
                    Done();
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

            QUnit.test(Test.Name, function (Assert) {
                var Done = Assert.async();

                function ChangeErrorHandlingForTest() {
                    ErrorHandlingFunc = Core.Exception.HandleFinalError;
                    Core.Exception.HandleFinalError = function (Exception) {
                        Assert.equal(Exception.GetType(), 'CommunicationError', 'Error handling called');
                    };

                    OldBaselink = Core.Config.Get('Baselink');
                }

                Assert.expect(Test.Expect + 1);

                ChangeErrorHandlingForTest();
                try {
                    Core.AJAX.ContentUpdate($('#ContentUpdateErrorHandling'), Test.URL, function () {
                        Assert.ok(true, 'Complete callback called');
                        RestoreOrignal();
                        Done();
                    });
                }
                catch (Error) {
                    Assert.equal(true, false, 'Error caught, Exception was thrown');
                    RestoreOrignal();
                    Done();
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

            QUnit.test(Test.Name, function (Assert) {
                var Done = Assert.async();

                function ChangeErrorHandlingForTest() {
                    ErrorHandlingFunc = Core.Exception.HandleFinalError;
                    Core.Exception.HandleFinalError = function (Exception) {
                        Assert.equal(Exception.GetType(), 'CommunicationError', 'Error handling called');
                        RestoreOrignal();
                        Done();
                    };

                    OldBaselink = Core.Config.Get('Baselink');
                }

                Assert.expect(Test.Expect);

                ChangeErrorHandlingForTest();
                try {
                    Core.AJAX.FunctionCall(Test.URL, {}, Test.Callback);
                }
                catch (Error) {
                    Assert.equal(true, false, 'Error caught, Exception was thrown');
                    RestoreOrignal();
                    Done();
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

            QUnit.test(Test.Name, function (Assert) {
                var Done = Assert.async();

                function ChangeErrorHandlingForTest() {
                    ErrorHandlingFunc = Core.Exception.HandleFinalError;
                    Core.Exception.HandleFinalError = function (Exception) {
                        Assert.equal(Exception.GetType(), 'CommunicationError', 'Error handling called');
                        RestoreOrignal();
                        Done();
                    };

                    OldBaselink = Core.Config.Get('Baselink');
                }

                Assert.expect(Test.Expect);

                ChangeErrorHandlingForTest();
                // Special callback for this test
                Core.Exception.HandleFinalError = function (Exception) {
                    var ExceptionMessage = Exception.GetMessage();

                    Assert.ok(ExceptionMessage.match(/^Invalid callback method.+$/), 'Error handling called');
                    RestoreOrignal();
                    Done();
                };
                try {
                    Core.AJAX.FunctionCall(Test.URL, {}, Test.Callback, 'html');
                }
                catch (Error) {
                    Assert.equal(true, false, 'Error caught, Exception was thrown');
                    RestoreOrignal();
                    Done();
                }
            });
        });

        // test AJAX error message suppression on leaving the page
        QUnit.test('AJAX error handling on leaving the page', function (Assert) {
            var Done = Assert.async(),
                AboutToLeaveOriginal = Core.Exception.AboutToLeave,
                HandleFinalErrorOriginal = Core.Exception.HandleFinalError;

            Assert.expect(1);

            Core.Exception.AboutToLeave = true;

            Core.Exception.HandleFinalError = function (ErrorObject) {
                var ErrorShownToUser = HandleFinalErrorOriginal(ErrorObject);

                Assert.equal(ErrorShownToUser, false, 'AJAX errors should be suppressed when leaving the page (custom error handler called)');
                Done();

                Core.Exception.HandleFinalError = HandleFinalErrorOriginal;
                Core.Exception.AboutToLeave = AboutToLeaveOriginal;
            };

            //ChangeErrorHandlingForTest();
            try {
                Core.AJAX.FunctionCall('nonexisting.url', {}, function () {
                    Assert.equal(true, false, 'Callback on nonexisting URL');
                    Done();
                });
            }
            catch (Error) {
                Assert.equal(true, false, 'Error caught, unexpected Exception was thrown');
                Done();
            }
        });
    };

    return Namespace;
}(Core.AJAX || {}));
