// --
// Core.AJAX.UnitTest.js - UnitTests
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.AJAX.UnitTest.js,v 1.1 2010-12-09 11:54:06 mg Exp $
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
                     HTML:   '<input type="checkbox" value="test" name="Checkbox" checked="checked">',
                     Result: 'Checkbox=test;',
                     Name:   'Checkbox with custom value, checked'

                 },
                 {
                     HTML:   '<input type="checkbox" value="test" name="CheckboxCustomValue">',
                     Result: 'CheckboxCustomValue=;',
                     Name:   'Checkbox with custom value, unchecked'

                 },
                 {
                     HTML:   '<select name="Select" multiple="multiple"><option value="1" selected="selected">one</option><option value="2" selected="selected">two</option></select>',
                     Result: 'Select=1%2C2;',
                     Name:   'Select with multiple values'

                 },
                 {
                     HTML:   '<select name="Select" multiple="multiple"><option value="1">one</option><option value="2">two</option></select>',
                     Result: 'Select=;',
                     Name:   'Select, empty'

                 }

            ];

            expect(Tests.length);

            /*
             * Create a form containter for the tests
             */
            $('body').append('<form id="CORE_AJAX_TestForm1"></form>');

            /*
             * Run the tests
             */
            $.each(Tests, function(){
                $('#CORE_AJAX_TestForm1').empty().append(this.HTML);
                equals(Core.AJAX.SerializeForm($('#CORE_AJAX_TestForm1')), this.Result, this.Name);

            });

            /*
             * Cleanup form container and contents
             */
            $('#CORE_AJAX_TestForm1').remove();
        });
    };

    return Namespace;
}(Core.AJAX || {}));