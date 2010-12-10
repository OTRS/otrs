// --
// Core.AJAX.UnitTest.js - UnitTests
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.AJAX.UnitTest.js,v 1.5 2010-12-10 13:35:31 mg Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};
Core.AJAX = Core.AJAX || {};

Core.AJAX = (function (Namespace) {
    Namespace.RunUnitTests = function(){
        var ContentUpdateTests;

        module('Core.AJAX');
        test('Core.AJAX.SerializeForm()', function(){


            var Tests =
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
                     Result: 'Element=1%2C2;',
                     Name:   'Multi-select with multiple values'

                 },
                 {
                     HTML:   '<select name="Element" multiple="multiple"><option value="1" selected="selected">one</option><option value="2">two</option></select>',
                     Result: 'Element=1;',
                     Name:   'Multi-Select with one value'

                 },
                 {
                     HTML:   '<select name="Element" multiple="multiple"><option value="1">one</option><option value="2">two</option></select>',
                     Result: 'Element=;',
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

            expect(Tests.length);

            /*
             * Create a form containter for the tests
             */
            $('body').append('<form id="CORE_AJAX_SerializeFormTest"></form>');

            /*
             * Run the tests
             */
            $.each(Tests, function(){
                $('#CORE_AJAX_SerializeFormTest').empty().append(this.HTML);
                equals(Core.AJAX.SerializeForm($('#CORE_AJAX_SerializeFormTest'), this.Ignore), this.Result, this.Name);

            });

            /*
             * Cleanup form container and contents
             */
            $('#CORE_AJAX_TestForm1').remove();
        });

        ContentUpdateTests =
        [
             {
                 Expect: 2,
                 Name: 'Core.AJAX.ContentUpdate() simple select',
                 URL: 'sample/Core.AJAX.ContentUpdate1.html',
                 ResultCheck: function() {
                     equals($('#Core_AJAX_ContentUpdateTest_Element').val(), 2, 'Simple select');
                     equals($('#CORE_AJAX_ContentUpdateTest').children().length, 1, 'Number of form children');
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
                    start();
                }
            });
        });

    };

    return Namespace;
}(Core.AJAX || {}));