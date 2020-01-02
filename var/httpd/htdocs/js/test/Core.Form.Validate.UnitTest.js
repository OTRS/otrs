// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var Core = Core || {};
Core.Form = Core.Form || {};

Core.Form.Validate = (function (Namespace) {
    Namespace.RunUnitTests = function(){
        QUnit.module('Core.Form.Validate');
        QUnit.test('Remove ServerError only after the user changed the field - bug#6736', function(Assert){
            var $TestForm = $('<form id="TestForm" class="Validate"></form>');

            Assert.expect(14);

            /*
             * Create a form container for the tests
             */
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

            //overload ServerError dialog
            Core.UI.Dialog.ShowAlert = function () {
                return true;
            };
            Core.Form.Validate.Init();

            $.each($('#TestForm').find("input, textarea, select"), function() {
                // only focus and leave field again, the same as a validation
                Core.Form.Validate.ValidateElement($(this));

                Assert.equal($(this).hasClass('Error'), true);

                // now focus field, change something and leave again
                if ($(this).is('input[type="text"], input[type="password"], input:hidden, textarea, select')) {
                    $(this).val('2');
                }
                else if ($(this).is('input[type="checkbox"], input[type="radio"]')) {
                    if (!$(this).prop('checked')) {
                        $(this).prop('checked', true);
                    }
                    else {
                        $(this).prop('checked', false);
                    }
                }

                Core.Form.Validate.ValidateElement($(this));

                Assert.equal($(this).hasClass('Error'), false);
            });

            /*
             * Cleanup div container and contents
             */
            $('#TestForm').remove();
        });

        QUnit.test('Validation methods (single field)', function(Assert){
            /*
             * Create a form container for the tests
             */
            var SingleFieldValidationMethods,
                $TestForm = $('<form id="TestForm" class="Validate"></form>');
            $TestForm.append('<input type="text" value="" id="ObjectOne" name="ObjectOne" />');
            $('body').append($TestForm);

            /*
             * Run the tests
             */

            Core.Config.Set('CheckEmailAddresses', 1);
            Core.Form.Validate.Init();

            SingleFieldValidationMethods = [
                {
                    Method: 'Validate_Required',
                    Content1: '',
                    Content2: 'Content',
                    Desc1: 'field empty',
                    Desc2: 'field not empty'
                },
                {
                    Method: 'Validate_Number',
                    Content1: 'abcde',
                    Content2: '1234',
                    Desc1: 'with chars',
                    Desc2: 'with numbers'
                },
                {
                    Method: 'Validate_Email',
                    Content1: 'abcde',
                    Content2: 'abc@defg.xy',
                    Desc1: 'no mails',
                    Desc2: 'mail address'
                },
                {
                    Method: 'Validate_Email_Optional',
                    Content1: 'abcde',
                    Content2: 'abc@defg.xy',
                    Desc1: 'no mails',
                    Desc2: 'mail address'
                },
                {
                    Method: 'Validate_Email_Optional',
                    Content1: 'abcde',
                    Content2: '',
                    Desc1: 'no mails',
                    Desc2: 'empty field is also allowed instead of mail address'
                },
                {
                    Method: 'Validate_DateYear',
                    Content1: '19988',
                    Content2: '2011',
                    Desc1: 'number, but no year',
                    Desc2: 'really a year'
                },
                {
                    Method: 'Validate_DateMonth',
                    Content1: '0',
                    Content2: '11',
                    Desc1: 'number, but no month',
                    Desc2: 'really a month'
                },
                {
                    Method: 'Validate_DateHour',
                    Content1: '26',
                    Content2: '15',
                    Desc1: 'number, but no hour',
                    Desc2: 'really an hour'
                },
                {
                    Method: 'Validate_DateMinute',
                    Content1: '76',
                    Content2: '53',
                    Desc1: 'number, but no minute',
                    Desc2: 'really a minute'
                },
                {
                    Method: 'Validate_TimeUnits',
                    Content1: '3:45',
                    Content2: '2.87',
                    Desc1: 'no time unit',
                    Desc2: 'time unit'
                }
            ];

            Assert.expect(SingleFieldValidationMethods.length * 2);

            // Test: Single Field Validations
            $.each(SingleFieldValidationMethods, function () {
                var ValidationObject = this;
                $('#ObjectOne').addClass(ValidationObject.Method);
                $('#ObjectOne').val(ValidationObject.Content1);
                Core.Form.Validate.ValidateElement($('#ObjectOne'));

                Assert.equal($('#ObjectOne').hasClass('Error'), true, ValidationObject.Method + ': ' + ValidationObject.Desc1);

                $('#ObjectOne').val(ValidationObject.Content2);
                Core.Form.Validate.ValidateElement($('#ObjectOne'));

                Assert.equal($('#ObjectOne').hasClass('Error'), false, ValidationObject.Method + ': ' + ValidationObject.Desc2);
                $('#ObjectOne').removeClass(ValidationObject.Method);
            });

            // Cleanup div container and contents
            $('#TestForm').remove();
        });

        QUnit.test('Validation methods (multiple field)', function(Assert){

            /*
             * Create a form container for the tests
             */
            var NewDate,
                $TestForm = $('<form id="TestForm" class="Validate"></form>');
            $TestForm.append('<input type="text" value="" id="ObjectOne" name="ObjectOne" />');
            $TestForm.append('<input type="text" value="" id="ObjectTwo" name="ObjectTwo" />');
            $TestForm.append('<input type="text" value="" id="ObjectThree" name="ObjectThree" />');
            $TestForm.append('<input type="text" value="" id="TestDay" name="TestDay" />');
            $TestForm.append('<input type="text" value="" id="TestMonth" name="TestMonth" />');
            $TestForm.append('<input type="text" value="" id="TestYear" name="TestYear" />');
            $('body').append($TestForm);

            /*
             * Run the tests
             */

            Core.Form.Validate.Init();

            Assert.expect(48);

            // Test: Validate_DateDay
            $('#ObjectOne').addClass('Validate_DateDay Validate_DateYear_ObjectTwo Validate_DateMonth_ObjectThree');
            $('#ObjectOne').val('30');

            $('#ObjectTwo').val('2011');
            $('#ObjectThree').val('2');

            Core.Form.Validate.ValidateElement($('#ObjectOne'));

            Assert.equal($('#ObjectOne').hasClass('Error'), true, 'Validate_DateDay: 30.2.2011');

            $('#ObjectOne').val('28');
            Core.Form.Validate.ValidateElement($('#ObjectOne'));

            Assert.equal($('#ObjectOne').hasClass('Error'), false, 'Validate_DateDay: 28.2.2011');

            $('#ObjectOne').val('15');
            $('#ObjectTwo').val('2011');
            $('#ObjectThree').val('13');

            Assert.equal($('#ObjectOne').hasClass('Error'), false, 'Validate_DateDay: 15.13.2011');

            $('#ObjectOne').removeClass('Validate_DateDay Validate_DateYear_ObjectTwo Validate_DateMonth_ObjectThree');


            // Test: Validate_DateInFuture
            $('#ObjectOne').addClass('Validate_DateDay Validate_DateYear_ObjectTwo Validate_DateMonth_ObjectThree Validate_DateInFuture');

            NewDate = new Date();
            NewDate.setDate(NewDate.getDate() - 2);

            $('#ObjectOne').val(NewDate.getDate());
            $('#ObjectTwo').val(NewDate.getFullYear());
            $('#ObjectThree').val(NewDate.getMonth() + 1);

            Core.Form.Validate.ValidateElement($('#ObjectOne'));

            Assert.equal($('#ObjectOne').hasClass('Error'), true, 'Validate_DateInFuture: today - 2 days');

            NewDate = new Date();
            NewDate.setDate(NewDate.getDate() + 2);

            $('#ObjectOne').val(NewDate.getDate());
            $('#ObjectTwo').val(NewDate.getFullYear());
            $('#ObjectThree').val(NewDate.getMonth() + 1);

            Core.Form.Validate.ValidateElement($('#ObjectOne'));

            Assert.equal($('#ObjectOne').hasClass('Error'), false, 'Validate_DateInFuture: today + 2 days');


            // Test: Validate_DateInFuture - with checkbox
            $TestForm.append('<input type="checkbox" class="DateSelection" value="" id="Checkbox" />');

            NewDate = new Date();
            NewDate.setDate(NewDate.getDate() - 2);

            $('#ObjectOne').val(NewDate.getDate());
            $('#ObjectTwo').val(NewDate.getFullYear());
            $('#ObjectThree').val(NewDate.getMonth() + 1);

            $('#Checkbox').prop('checked', false);
            Core.Form.Validate.ValidateElement($('#ObjectOne'));

            Assert.equal($('#ObjectOne').hasClass('Error'), false, 'Validate_DateInFuture with unchecked checkbox: today - 2 days');

            $('#Checkbox').prop('checked', true);
            Core.Form.Validate.ValidateElement($('#ObjectOne'));

            Assert.equal($('#ObjectOne').hasClass('Error'), true, 'Validate_DateInFuture with checked checkbox: today - 2 days');

            NewDate = new Date();
            NewDate.setDate(NewDate.getDate() + 2);

            $('#ObjectOne').val(NewDate.getDate());
            $('#ObjectTwo').val(NewDate.getFullYear());
            $('#ObjectThree').val(NewDate.getMonth() + 1);

            $('#Checkbox').prop('checked', false);
            Core.Form.Validate.ValidateElement($('#ObjectOne'));

            Assert.equal($('#ObjectOne').hasClass('Error'), false, 'Validate_DateInFuture with unchecked checkbox: today + 2 days');

            $('#Checkbox').prop('checked', true);
            Core.Form.Validate.ValidateElement($('#ObjectOne'));

            Assert.equal($('#ObjectOne').hasClass('Error'), false, 'Validate_DateInFuture with checked checkbox: today + 2 days');

            $('#Checkbox').remove();


            // Test: Validate_DateInFuture - with radio button
            $TestForm.append('<input type="radio" name="Radio" value="0" id="Radio0" />');
            $TestForm.append('<input type="radio" class="DateSelection" name="Radio" value="1" id="Radio1" />');

            NewDate = new Date();
            NewDate.setDate(NewDate.getDate() - 2);

            $('#ObjectOne').val(NewDate.getDate());
            $('#ObjectTwo').val(NewDate.getFullYear());
            $('#ObjectThree').val(NewDate.getMonth() + 1);

            $('#Radio0').prop('checked', true);
            Core.Form.Validate.ValidateElement($('#ObjectOne'));

            Assert.equal($('#ObjectOne').hasClass('Error'), false, 'Validate_DateInFuture with unchecked radio button: today - 2 days');

            $('#Radio1').prop('checked', true);
            Core.Form.Validate.ValidateElement($('#ObjectOne'));

            Assert.equal($('#ObjectOne').hasClass('Error'), true, 'Validate_DateInFuture with checked radio button: today - 2 days');

            NewDate = new Date();
            NewDate.setDate(NewDate.getDate() + 2);

            $('#ObjectOne').val(NewDate.getDate());
            $('#ObjectTwo').val(NewDate.getFullYear());
            $('#ObjectThree').val(NewDate.getMonth() + 1);

            $('#Radio0').prop('checked', true);
            Core.Form.Validate.ValidateElement($('#ObjectOne'));

            Assert.equal($('#ObjectOne').hasClass('Error'), false, 'Validate_DateInFuture with unchecked radio button: today + 2 days');

            $('#Radio1').prop('checked', true);
            Core.Form.Validate.ValidateElement($('#ObjectOne'));

            Assert.equal($('#ObjectOne').hasClass('Error'), false, 'Validate_DateInFuture with checked radio button: today + 2 days');

            $('input[type="radio"][name="Radio"]').remove();

            $('#ObjectOne').removeClass('Validate_DateDay Validate_DateYear_ObjectTwo Validate_DateMonth_ObjectThree Validate_DateInFuture');

            // Test: Validate_DateAfter (against field)
            $('#ObjectOne').addClass('Validate_DateDay Validate_DateMonth_ObjectTwo Validate_DateYear_ObjectThree Validate_DateAfter Validate_DateAfter_Test');

            $('#ObjectOne').val('23');
            $('#ObjectTwo').val('3');
            $('#ObjectThree').val('2016');

            $('#TestDay').val('24');
            $('#TestMonth').val('3');
            $('#TestYear').val('2016');

            Core.Form.Validate.ValidateElement($('#ObjectOne'));

            Assert.equal($('#ObjectOne').hasClass('Error'), true, 'Validate_DateAfter: 24.3.2016 vs 23.3.2016 (against field)');

            $('#ObjectOne').removeClass('Validate_DateAfter_Start');


            // Test: Validate_DateAfter (against value)
            $('#ObjectOne').data('validate-date-after', '2016-03-22');

            Core.Form.Validate.ValidateElement($('#ObjectOne'));

            Assert.equal($('#ObjectOne').hasClass('Error'), false, 'Validate_DateAfter: 22.3.2016 vs 23.3.2016 (against value)');

            $('#ObjectOne').removeData('validate-date-after');
            $('#ObjectOne').removeClass('Validate_DateAfter');


            // Test: Validate_DateBefore (against field)
            $('#ObjectOne').addClass('Validate_DateBefore Validate_DateBefore_Test');

            Core.Form.Validate.ValidateElement($('#ObjectOne'));

            Assert.equal($('#ObjectOne').hasClass('Error'), false, 'Validate_DateBefore: 23.3.2016 vs 24.3.2016 (against field)');

            $('#ObjectOne').removeClass('Validate_DateBefore_Test');


            // Test: Validate_DateBefore (against value)
            $('#ObjectOne').data('validate-date-before', '2016-03-22');

            Core.Form.Validate.ValidateElement($('#ObjectOne'));

            Assert.equal($('#ObjectOne').hasClass('Error'), true, 'Validate_DateBefore: 23.3.2016 vs 21.3.2016 (against value)');

            $('#ObjectOne').removeData('validate-date-before');
            $('#ObjectOne').removeClass('Validate_DateDay Validate_DateMonth_ObjectTwo Validate_DateYear_ObjectThree Validate_DateAfter Validate_DateAfter_Test Validate_DateBefore');

            // Test: Validate_DateNotInFuture
            $('#ObjectOne').addClass('Validate_DateDay Validate_DateYear_ObjectTwo Validate_DateMonth_ObjectThree Validate_DateNotInFuture');

            NewDate = new Date();
            NewDate.setDate(NewDate.getDate() + 2);

            $('#ObjectOne').val(NewDate.getDate());
            $('#ObjectTwo').val(NewDate.getFullYear());
            $('#ObjectThree').val(NewDate.getMonth() + 1);

            Core.Form.Validate.ValidateElement($('#ObjectOne'));

            Assert.equal($('#ObjectOne').hasClass('Error'), true, 'Validate_DateNotInFuture: today + 2 days');

            NewDate = new Date();
            NewDate.setDate(NewDate.getDate() - 2);

            $('#ObjectOne').val(NewDate.getDate());
            $('#ObjectTwo').val(NewDate.getFullYear());
            $('#ObjectThree').val(NewDate.getMonth() + 1);

            Core.Form.Validate.ValidateElement($('#ObjectOne'));

            Assert.equal($('#ObjectOne').hasClass('Error'), false, 'Validate_DateNotInFuture: today - 2 days');


            // Test: Validate_DateNotInFuture - with checkbox
            $TestForm.append('<input type="checkbox" class="DateSelection" value="" id="Checkbox" />');

            NewDate = new Date();
            NewDate.setDate(NewDate.getDate() + 2);

            $('#ObjectOne').val(NewDate.getDate());
            $('#ObjectTwo').val(NewDate.getFullYear());
            $('#ObjectThree').val(NewDate.getMonth() + 1);

            $('#Checkbox').prop('checked', false);
            Core.Form.Validate.ValidateElement($('#ObjectOne'));

            Assert.equal($('#ObjectOne').hasClass('Error'), false, 'Validate_DateNotInFuture with unchecked checkbox: today + 2 days');

            $('#Checkbox').prop('checked', true);
            Core.Form.Validate.ValidateElement($('#ObjectOne'));

            Assert.equal($('#ObjectOne').hasClass('Error'), true, 'Validate_DateNotInFuture with checked checkbox: today + 2 days');

            NewDate = new Date();
            NewDate.setDate(NewDate.getDate() - 2);

            $('#ObjectOne').val(NewDate.getDate());
            $('#ObjectTwo').val(NewDate.getFullYear());
            $('#ObjectThree').val(NewDate.getMonth() + 1);

            $('#Checkbox').prop('checked', false);
            Core.Form.Validate.ValidateElement($('#ObjectOne'));

            Assert.equal($('#ObjectOne').hasClass('Error'), false, 'Validate_DateNotInFuture with unchecked checkbox: today - 2 days');

            $('#Checkbox').prop('checked', true);
            Core.Form.Validate.ValidateElement($('#ObjectOne'));

            Assert.equal($('#ObjectOne').hasClass('Error'), false, 'Validate_DateNotInFuture with checked checkbox: today - 2 days');

            $('#Checkbox').remove();


            // Test: Validate_DateNotInFuture - with radio button
            $TestForm.append('<input type="radio" name="Radio" value="0" id="Radio0" />');
            $TestForm.append('<input type="radio" class="DateSelection" name="Radio" value="1" id="Radio1" />');

            NewDate = new Date();
            NewDate.setDate(NewDate.getDate() + 2);

            $('#ObjectOne').val(NewDate.getDate());
            $('#ObjectTwo').val(NewDate.getFullYear());
            $('#ObjectThree').val(NewDate.getMonth() + 1);

            $('#Radio0').prop('checked', true);
            Core.Form.Validate.ValidateElement($('#ObjectOne'));

            Assert.equal($('#ObjectOne').hasClass('Error'), false, 'Validate_DateNotInFuture with unchecked radio button: today + 2 days');

            $('#Radio1').prop('checked', true);
            Core.Form.Validate.ValidateElement($('#ObjectOne'));

            Assert.equal($('#ObjectOne').hasClass('Error'), true, 'Validate_DateNotInFuture with checked radio button: today + 2 days');

            NewDate = new Date();
            NewDate.setDate(NewDate.getDate() - 2);

            $('#ObjectOne').val(NewDate.getDate());
            $('#ObjectTwo').val(NewDate.getFullYear());
            $('#ObjectThree').val(NewDate.getMonth() + 1);

            $('#Radio0').prop('checked', true);
            Core.Form.Validate.ValidateElement($('#ObjectOne'));

            Assert.equal($('#ObjectOne').hasClass('Error'), false, 'Validate_DateNotInFuture with unchecked radio button: today - 2 days');

            $('#Radio1').prop('checked', true);
            Core.Form.Validate.ValidateElement($('#ObjectOne'));

            Assert.equal($('#ObjectOne').hasClass('Error'), false, 'Validate_DateNotInFuture with checked radio button: today - 2 days');

            $('input[type="radio"][name="Radio"]').remove();

            $('#ObjectOne').removeClass('Validate_DateDay Validate_DateYear_ObjectTwo Validate_DateMonth_ObjectThree Validate_DateNotInFuture');

            // Test: Validate_Equal
            $('#ObjectOne').addClass('Validate_Equal Validate_Equal_ObjectTwo');
            $('#ObjectOne').val('abc');
            $('#ObjectTwo').val('def');

            Core.Form.Validate.ValidateElement($('#ObjectOne'));
            Assert.equal($('#ObjectOne').hasClass('Error'), true, 'Validate_Equal: two fields are not equal');

            $('#ObjectTwo').val('abc');

            Core.Form.Validate.ValidateElement($('#ObjectOne'));
            Assert.equal($('#ObjectOne').hasClass('Error'), false, 'Validate_Equal: two fields are equal');

            $('#ObjectOne').addClass('Validate_Equal_ObjectThree');
            $('#ObjectThree').val('def');

            Core.Form.Validate.ValidateElement($('#ObjectOne'));
            Assert.equal($('#ObjectOne').hasClass('Error'), true, 'Validate_Equal: three fields are not equal (2 are, 1 not)');

            $('#ObjectThree').val('abc');

            Core.Form.Validate.ValidateElement($('#ObjectOne'));
            Assert.equal($('#ObjectOne').hasClass('Error'), false, 'Validate_Equal: three fields are equal');

            $('#ObjectOne').removeClass('Validate_Equal Validate_Equal_ObjectTwo Validate_Equal_ObjectThree');


            // Test: Validate_DependingRequiredAND
            $('#ObjectOne').addClass('Validate_DependingRequiredAND Validate_Depending_ObjectTwo');
            $('#ObjectOne').val('');
            $('#ObjectTwo').val('def');

            Core.Form.Validate.ValidateElement($('#ObjectOne'));
            Assert.equal($('#ObjectOne').hasClass('Error'), true, 'Validate_DependingRequiredAND: field is empty, depending field not');

            $('#ObjectOne').val('abc');

            Core.Form.Validate.ValidateElement($('#ObjectOne'));
            Assert.equal($('#ObjectOne').hasClass('Error'), false, 'Validate_DependingRequiredAND: both fields are not empty');

            $('#ObjectTwo').val('');
            Core.Form.Validate.ValidateElement($('#ObjectOne'));
            Assert.equal($('#ObjectOne').hasClass('Error'), false, 'Validate_DependingRequiredAND: field is not empty, but depending field is empty');

            $('#ObjectOne').addClass('Validate_Depending_ObjectThree');
            $('#ObjectOne').val('');
            $('#ObjectThree').val('def');

            Core.Form.Validate.ValidateElement($('#ObjectOne'));
            Assert.equal($('#ObjectOne').hasClass('Error'), true, 'Validate_DependingRequiredAND: field is empty, one depending field is not empty');

            $('#ObjectTwo').val('abc');

            Core.Form.Validate.ValidateElement($('#ObjectOne'));
            Assert.equal($('#ObjectOne').hasClass('Error'), true, 'Validate_DependingRequiredAND: field is empty, both depending fields are not empty');

            $('#ObjectOne').val('abc');

            Core.Form.Validate.ValidateElement($('#ObjectOne'));
            Assert.equal($('#ObjectOne').hasClass('Error'), false, 'Validate_DependingRequiredAND: field is not empty, both depending fields are not empty');

            $('#ObjectOne').removeClass('Validate_DependingRequiredAND Validate_Depending_ObjectTwo Validate_Depending_ObjectThree');


            // Test: Validate_DependingRequiredOR
            $('#ObjectOne').addClass('Validate_DependingRequiredOR Validate_Depending_ObjectTwo');
            $('#ObjectOne').val('');
            $('#ObjectTwo').val('');

            Core.Form.Validate.ValidateElement($('#ObjectOne'));
            Assert.equal($('#ObjectOne').hasClass('Error'), true, 'Validate_DependingRequiredOR: both fields empty');

            $('#ObjectTwo').val('abc');

            Core.Form.Validate.ValidateElement($('#ObjectOne'));
            Assert.equal($('#ObjectOne').hasClass('Error'), false, 'Validate_DependingRequiredOR: first empty, second not');

            $('#ObjectOne').val('abc');
            $('#ObjectTwo').val('');

            Core.Form.Validate.ValidateElement($('#ObjectOne'));
            Assert.equal($('#ObjectOne').hasClass('Error'), false, 'Validate_DependingRequiredOR: second empty, first not');

            $('#ObjectTwo').val('def');

            Core.Form.Validate.ValidateElement($('#ObjectOne'));
            Assert.equal($('#ObjectOne').hasClass('Error'), false, 'Validate_DependingRequiredOR: both not empty');

            $('#ObjectOne').addClass('Validate_Depending_ObjectThree');
            $('#ObjectOne').val('');
            $('#ObjectTwo').val('');
            $('#ObjectThree').val('');

            Core.Form.Validate.ValidateElement($('#ObjectOne'));
            Assert.equal($('#ObjectOne').hasClass('Error'), true, 'Validate_DependingRequiredOR: three fields empty');

            $('#ObjectOne').val('abc');

            Core.Form.Validate.ValidateElement($('#ObjectOne'));
            Assert.equal($('#ObjectOne').hasClass('Error'), false, 'Validate_DependingRequiredOR: 1 filled. 2+3 empty');

            $('#ObjectOne').val('');
            $('#ObjectTwo').val('def');

            Core.Form.Validate.ValidateElement($('#ObjectOne'));
            Assert.equal($('#ObjectOne').hasClass('Error'), false, 'Validate_DependingRequiredOR: 1 empty. 2 filled. 3 empty');

            $('#ObjectOne').val('');
            $('#ObjectTwo').val('');
            $('#ObjectThree').val('xyz');

            Core.Form.Validate.ValidateElement($('#ObjectOne'));
            Assert.equal($('#ObjectOne').hasClass('Error'), false, 'Validate_DependingRequiredOR: 1 + 2 empty. 3 filled');

            $('#ObjectOne').val('abc');
            $('#ObjectTwo').val('def');
            $('#ObjectThree').val('');

            Core.Form.Validate.ValidateElement($('#ObjectOne'));
            Assert.equal($('#ObjectOne').hasClass('Error'), false, 'Validate_DependingRequiredOR: 1 + 2 filled. 3 empty');

            $('#ObjectOne').val('');
            $('#ObjectTwo').val('def');
            $('#ObjectThree').val('xyz');

            Core.Form.Validate.ValidateElement($('#ObjectOne'));
            Assert.equal($('#ObjectOne').hasClass('Error'), false, 'Validate_DependingRequiredOR: 1 empty. 2 + 3 filled');

            $('#ObjectOne').val('abc');
            $('#ObjectTwo').val('def');
            $('#ObjectThree').val('xyz');

            Core.Form.Validate.ValidateElement($('#ObjectOne'));
            Assert.equal($('#ObjectOne').hasClass('Error'), false, 'Validate_DependingRequiredOR: three fields not empty');

            // Cleanup div container and contents
            $('#TestForm').remove();
        });

        QUnit.test('HighlightError() and UnHighlightError()', function(Assert){

            /*
             * Create a form container for the tests
             */
            var $TestForm = $('<form id="TestForm" class="Validate"></form>');

            $TestForm.append('<label class="Mandatory" for="ObjectOne"><span class="Marker">*</span>ObjectOne</label>');
            $TestForm.append('<input type="text" value="" id="ObjectOne" name="ObjectOne"/>');
            $TestForm.append('<label class="Mandatory" for="ObjectTwo"><span class="Marker">*</span>ObjectTwo</label>');
            $TestForm.append('<input type="text" value="" id="ObjectTwo" name="ObjectTwo" class="ServerError"/>');
            $('body').append($TestForm);

            /*
             * Run the tests
             */

            Core.Form.Validate.Init();

            Assert.expect(15);

            // Test HighlightError()
            Assert.equal($('#ObjectOne').hasClass('Error'), false, 'No Error class before HighlightError() for Error type');

            Core.Form.Validate.HighlightError($('#ObjectOne'), 'Error');
            Assert.equal($('#ObjectOne').hasClass('Error'), true, 'Error class after HighlightError() for Error type');
            Assert.equal($('#ObjectOne').attr('aria-invalid'), "true", 'Attribute aria-invalid is true after HighlightError() for Error type');
            Assert.equal($('#TestForm').find("label[for=ObjectOne]").hasClass('LabelError'), false, 'No LabelError class for label after HighlightError() for Error type');

            // For ServerError type HighlightError() is done in Core.Form.Validate.Init()
            Assert.equal($('#ObjectTwo').hasClass('Error'), true, 'Error class after HighlightError() for ServerError type');
            Assert.equal($('#ObjectTwo').attr('aria-invalid'), "true", 'Attribute aria-invalid is true after HighlightError() for ServerError type');
            Assert.equal($('#TestForm').find("label[for=ObjectTwo]").hasClass('LabelError'), true, 'LabelError class for label after HighlightError() for ServerError type');

            // Test UnHighlightError()
            Core.Form.Validate.UnHighlightError($('#ObjectOne'));
            Assert.equal($('#ObjectOne').hasClass('Error'), false, 'No Error class after UnHighlightError() for Error type');
            Assert.equal($('#ObjectOne').attr('aria-invalid'), "false", 'Attribute aria-invalid is false after UnHighlightError() for Error type');

            // For ServerError type, we need to change field value to remove error class
            Core.Form.Validate.UnHighlightError($('#ObjectTwo'));
            Assert.equal($('#ObjectTwo').hasClass('Error'), true, 'Error class after UnHighlightError() for ServerError type');
            Assert.equal($('#ObjectTwo').attr('aria-invalid'), "true", 'Attribute aria-invalid is true after UnHighlightError() for ServerError type');
            Assert.equal($('#TestForm').find("label[for=ObjectTwo]").hasClass('LabelError'), true, 'LabelError class for label after UnHighlightError() for ServerError type');

            $('#ObjectTwo').val('abc');
            $('#ObjectTwo').blur();

            Assert.equal($('#ObjectTwo').hasClass('Error'), false, 'No Error class after inputed value for ServerError type');
            Assert.equal($('#ObjectTwo').attr('aria-invalid'), "false", 'Attribute aria-invalid is false after inputed value for ServerError type');
            Assert.equal($('#TestForm').find("label[for=ObjectTwo]").hasClass('LabelError'), false, 'No LabelError class for label after inputed value for ServerError type');

            // Cleanup div container and contents
            $('#TestForm').remove();
        });

    };

    return Namespace;
}(Core.Form.Validate || {}));
