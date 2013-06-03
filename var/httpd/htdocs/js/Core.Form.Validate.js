// --
// Core.Form.Validate.js - provides functions for validating form inputs
// Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.Form = Core.Form || {};

/**
 * @namespace
 * @exports TargetNS as Core.Form.Validate
 * @description
 *      This namespace contains all validation functions.
 * @requires
 *      Core.UI.Accessibility
 */
Core.Form.Validate = (function (TargetNS) {
    var Options = {
        FormClass:          'Validate',
        ErrorClass:         'Error',
        ErrorLabelClass:    'LabelError',
        ServerErrorClass:   'ServerError',
        ServerLabelClass:   'ServerLabelError',
        IgnoreClass:        'ValidationIgnore',
        SubmitFunction:     {}
    };

    /*
     * check dependencies first
     */
    if (!Core.Debug.CheckDependency('Core.Form.Validate', 'Core.UI.Accessibility', 'Core.UI.Accessibility')) {
        return;
    }

    if (!Core.Debug.CheckDependency('Core.Form.Validate', 'Core.UI.Dialog', 'Core.UI.Dialog')) {
        return;
    }

    if (!Core.Debug.CheckDependency('Core.Form.Validate', 'Core.Form', 'Core.Form')) {
        return;
    }

    if (!Core.Debug.CheckDependency('Core.Form.Validate', 'Core.UI.RichTextEditor', 'Core.UI.RichTextEditor')) {
        return;
    }

    if (!Core.Debug.CheckDependency('Core.Form.Validate', 'Core.Form.ErrorTooltips', 'Core.Form.ErrorTooltips')) {
        return;
    }

    if (!Core.Debug.CheckDependency('Core.Form.Validate', 'Core.App', 'Core.App')) {
        return;
    }

    /**
     * @function
     * @param {jQueryObject} $Element The jQuery object of the form  or any element
     * @param {String} ErrorType The error type (a class that identify the error type)
     * @return nothing
     * @description Show initialize the tooltips
     */
    TargetNS.HighlightError = function (Element, ErrorType) {
        var $Element = $(Element),
            InputErrorMessageHTML,
            InputErrorMessageText;

        // Check error type and correct it, if necessary
        if (ErrorType !== 'Error' && ErrorType !== 'ServerError') {
            ErrorType = 'Error';
        }

        // Check if the element has already an error class
        // (that means, this function call is an additional call)
        if ($Element.hasClass(Options.ErrorClass)) {
            return;
        }

        // Add error class to field and its label
        $Element.addClass(Options.ErrorClass);
        $(Element.form).find("label[for=" + Core.App.EscapeSelector(Element.id) + "]").addClass(Options.ErrorLabelClass);

        // mark field as invalid for screenreader users
        $Element.attr('aria-invalid', true);

        // save value of element for a later check if field value was changed.
        // if the field has a servererror class and the value was not changed,
        // keep the error class.
        if ($Element.is('input:checkbox, input:radio')) {
            $Element.data('ValidateOldValue', $Element.prop('checked'));
        }
        else {
            $Element.data('ValidateOldValue', $Element.val());
        }

        // Get the target element and find the associated hidden div with the
        // error message.
        InputErrorMessageHTML = $('#' + Core.App.EscapeSelector($Element.attr('id')) + ErrorType).html();
        InputErrorMessageText = $('#' + Core.App.EscapeSelector($Element.attr('id')) + ErrorType).text();

        if (InputErrorMessageHTML && InputErrorMessageHTML.length) {
            // if error field is a RTE, it is a little bit more difficult
            if ($('#cke_' + Element.id).length) {
                Core.Form.ErrorTooltips.InitRTETooltip($Element, InputErrorMessageHTML);
            } else {
                Core.Form.ErrorTooltips.InitTooltip($Element, InputErrorMessageHTML);
            }
        }

        // speak the error message for screen reader users
        Core.UI.Accessibility.AudibleAlert(InputErrorMessageText);

        // if the element, which has an validation error, is a richtext element, than manually trigger the focus event
        if (Core.UI.RichTextEditor.IsEnabled($Element)) {
            window.setTimeout(function () {
                $Element.focus();
            }, 0);
        }
    };

    /**
     * @function
     * @param {Object} Element The object of the form  or any element within this form that should be serialized
     * @return nothing
     * @description Remove error classes from element and its label
     */
    TargetNS.UnHighlightError = function (Element) {
        var $Element = $(Element),
            ElementValue,
            RemoveError = true;

        // check ServerError
        // if the field value has not changed, do not remove error class
        if ($Element.hasClass(Options.ServerErrorClass)) {
            if ($Element.is('input:checkbox, input:radio')) {
                ElementValue = $Element.prop('checked');
            }
            else {
                ElementValue = $Element.val();
            }

            if ($Element.data('ValidateOldValue') === ElementValue) {
                RemoveError = false;
            }
            else {
                $Element.removeData('ValidateOldValue');
            }
        }

        if (RemoveError) {
            // remove error classes from element and its label
            $Element.removeClass(Options.ErrorClass).removeClass(Options.ServerErrorClass);
            $(Element.form).find("label[for=" + Core.App.EscapeSelector(Element.id) + "]").removeClass(Options.ErrorLabelClass);

            // mark field as valid for screenreader users
            $Element.attr('aria-invalid', false);

            // if error field is a RTE, it is a little bit more difficult
            if ($('#cke_' + Element.id).length) {
                Core.Form.ErrorTooltips.RemoveRTETooltip($Element);
            } else {
                Core.Form.ErrorTooltips.RemoveTooltip($Element);
            }
        }
    };

    /**
     * @function
     * @private
     * @return nothing
     * @description This function prevents the default placing of the error messages
     */
    function OnErrorElement(Error, Element) {
        return true;
    }

    /**
     * @function
     * @private
     * @param {Object} Form The form object that should be submitted
     * @return nothing
     * @description This function performs the submit action for a form, allowing only be sent once
     */
    function OnSubmit(Form) {
        $(Form).removeClass('ClientError').removeClass('LabelError');
        if ($.isFunction(Options.SubmitFunction[Form.id])) {
            Options.SubmitFunction[Form.id](Form);
        }
        else {
            Form.submit();
        }
        if ($(Form).hasClass("PreventMultipleSubmits")) {
            // fix for Safari: this "disable" comes to early after the submit, so that some fields are
            // disabled before submitting and therefor are not submitted
            window.setTimeout(function () {
                Core.Form.DisableForm($(Form));
            }, 0);
        }
    }

    /**
     * @function
     * @private
     * @return nothing
     * @description
     *      Validator method for checking if a value is present for
     *      different types of elements.
     */
    function ValidatorMethodRequired(Value, Element) {
        var Text,
            $Element = $(Element);

        // special treatment of <select> elements in OTRS
        if (Element.nodeName.toLowerCase() === 'select') {
            Text = $(Element).find('option:selected').text();
            return (Text.length && Text !== '-');
        }

        // for rich text areas, update the linked field for the validation first
        if (Core.UI.RichTextEditor.IsEnabled($Element)) {
            CKEDITOR.instances[$Element.attr('id')].updateElement();
            Value = $Element.val();
        }

        // checkable inputs
        if ($Element.filter('input:checkbox, input:radio').length) {
            return $Element.filter(':checked').length > 0;
        }

        return $.trim(Value).length > 0;
    }

    /*
     * Definitions of all OTRS specific rules and rule methods
     */
    $.validator.addMethod("Validate_Required", ValidatorMethodRequired, "");
    $.validator.addMethod("Validate_Number", $.validator.methods.digits, "");

    // There is a configuration option in OTRS that controls if email addresses
    // should be validated or not.
    // If email address should be validated, this function is overwritten in Init method
    $.validator.addMethod("Validate_Email", ValidatorMethodRequired, "");

    // Use the maxlength attribute to have a dynamic validation
    // Textarea fields will need JS code to set the maxlength attribute since is not supported by
    // XHTML
    $.validator.addMethod("Validate_MaxLength",function (Value, Element) {

        // JS takes new lines '\n\r' in textarea elements as 1 character '\n' for length
        // calculation purposes therefore is needed to re-add the '\r' to get the correct length
        // for validation and match to perl and database criteria
        return ( Value.replace(/\n\r?/g, "\n\r").length <= $(Element).attr('maxlength') );
    }, "");

    $.validator.addMethod("Validate_DateYear", function (Value, Element) {
        return (parseInt(Value, 10) > 999 && parseInt(Value, 10) < 10000);
    }, "");

    $.validator.addMethod("Validate_DateMonth", function (Value, Element) {
        return (parseInt(Value, 10) > 0 && parseInt(Value, 10) < 13);
    }, "");

    function DateValidator (Value, Element, Options) {
        var Classes = $(Element).attr('class'),
        DateObject,
        RegExYear,
        RegExMonth,
        YearElement = '',
        MonthElement = '',
        DateYearClassPrefix = 'Validate_DateYear_',
        DateMonthClassPrefix = 'Validate_DateMonth_',
        DateCheck;

        RegExYear = new RegExp(DateYearClassPrefix);
        RegExMonth = new RegExp(DateMonthClassPrefix);
        $.each(Classes.split(' '), function (Index, Value) {
            if (RegExYear.test(Value)) {
                YearElement = Value.replace(DateYearClassPrefix, '');
            }
            if (RegExMonth.test(Value)) {
                MonthElement = Value.replace(DateMonthClassPrefix, '');
            }
        });
        if (YearElement.length && MonthElement.length && $('#' + YearElement).length && $('#' + MonthElement).length) {
            DateObject = new Date($('#' + YearElement).val(), $('#' + MonthElement).val() - 1, Value);
            if (DateObject.getFullYear() === parseInt($('#' + YearElement).val(), 10) &&
                DateObject.getMonth() + 1 === parseInt($('#' + MonthElement).val(), 10) &&
                DateObject.getDate() === parseInt(Value, 10)) {
                if (Options.DateInFuture) {
                    DateCheck = new Date();
                    DateCheck.setHours(0, 0, 0, 0);
                    if (DateObject >= DateCheck) {
                        return true;
                    }
                }
                else {
                    return true;
                }
            }
        }
        return false;
    }

    $.validator.addMethod("Validate_DateDay", function (Value, Element) {
        return DateValidator(Value, Element, {});
    }, "");

    $.validator.addMethod("Validate_DateInFuture", function (Value, Element) {
        return DateValidator(Value, Element, { DateInFuture: true });
    }, "");

    $.validator.addMethod("Validate_DateHour", function (Value, Element) {
        return (parseInt(Value, 10) >= 0 && parseInt(Value, 10) < 24);
    }, "");

    $.validator.addMethod("Validate_DateMinute", function (Value, Element) {
        return (parseInt(Value, 10) >= 0 && parseInt(Value, 10) < 60);
    }, "");

    $.validator.addMethod("Validate_TimeUnits", function (Value, Element) {
        return (Value === "" || /^-{0,1}\d+?((\.|,){0,1}\d+?){0,1}$/.test(Value));
    }, "");

    /*
     * Adds a generic method to compare if the given fields are equal
     */
    $.validator.addMethod("Validate_Equal", function (Value, Element) {
        var Classes = $(Element).attr('class'),
            EqualElements = [],
            ApplyRule = 0,
            EqualClassPrefix = 'Validate_Equal_',
            RegExEqual,
            I;
        RegExEqual = new RegExp(EqualClassPrefix);
        $.each(Classes.split(' '), function (Index, Value) {
            if (RegExEqual.test(Value)) {
                EqualElements.push(Value.replace(EqualClassPrefix, ''));
            }
        });
        if (EqualElements.length) {
            for (I = 0; I < EqualElements.length; I++) {
                if ($('#' + $.trim(EqualElements[I])).val() === Value) {
                    ApplyRule++;
                }
            }
            return (ApplyRule === EqualElements.length);
        }
    });

    $.validator.addClassRules("Validate_Required", {
        Validate_Required: true
    });

    $.validator.addClassRules("Validate_Number", {
        Validate_Number: true
    });

    $.validator.addClassRules("Validate_Email", {
        Validate_Email: true
    });

    $.validator.addClassRules("Validate_MaxLength", {
        Validate_MaxLength: true
    });

    // Backwards compatibility: these methods are deprecated, do not use them!
    // They will be removed in OTRS 3.1.
    $.validator.addClassRules("Validate_RequiredDropdown", {
        Validate_Required: true
    });
    $.validator.addClassRules("Validate_RequiredRichText", {
        Validate_Required: true
    });

    $.validator.addClassRules("Validate_DateYear", {
        Validate_DateYear: true
    });

    $.validator.addClassRules("Validate_DateMonth", {
        Validate_DateMonth: true
    });

    $.validator.addClassRules("Validate_DateDay", {
        Validate_DateDay: true
    });

    $.validator.addClassRules("Validate_DateHour", {
        Validate_DateHour: true
    });

    $.validator.addClassRules("Validate_DateMinute", {
        Validate_DateMinute: true
    });

    $.validator.addClassRules("Validate_TimeUnits", {
        Validate_TimeUnits: true
    });

    $.validator.addClassRules("Validate_Equal", {
        Validate_Equal: true
    });

    function GetDependentElements(Element) {
        var Classes = $(Element).attr('class'),
        DependentElementIDs = [],
        RegEx,
        DependingClassPrefix = 'Validate_Depending_';

        RegEx = new RegExp(DependingClassPrefix);
        $.each(Classes.split(' '), function (Index, Value) {
            if (RegEx.test(Value)) {
                DependentElementIDs.push(Value.replace(DependingClassPrefix, ''));
            }
        });
        return DependentElementIDs;
    }

    /*
     * Adds a generic "depending required" rule:
     * The element needs a list of IDs in the class attribute. This element is required, if one of the given IDs is a element, which contains content itself (logical AND).
     */
    $.validator.addMethod("Validate_DependingRequiredAND", function (Value, Element) {
        var I,
            DependentElementIDs = [],
            $DependentElement;

        DependentElementIDs = GetDependentElements(Element);

        for (I = 0; I < DependentElementIDs.length; I++) {
            $DependentElement = $('#' + $.trim(DependentElementIDs[I]));
            if (ValidatorMethodRequired($DependentElement.val(), $DependentElement[0])) {
                return ValidatorMethodRequired(Value, Element);
            }
        }
        return true;
    }, "");


    $.validator.addClassRules("Validate_DependingRequiredAND", {
        Validate_DependingRequiredAND: true
    });

    /*
     * Adds another generic "depending required" rule:
     * The element needs a list of IDs in the class attribute. One of the elements (this one or the ones given by ID) is required (logical OR).
     */
    $.validator.addMethod("Validate_DependingRequiredOR", function (Value, Element) {
        var I,
        DependentElementIDs = [],
        $DependentElement;

        DependentElementIDs = GetDependentElements(Element);

        for (I = 0; I < DependentElementIDs.length; I++) {
            $DependentElement = $('#' + $.trim(DependentElementIDs[I]));
            if (ValidatorMethodRequired($DependentElement.val(), $DependentElement[0])) {
                return true;
            }
        }
        return ValidatorMethodRequired(Value, Element);
    }, "");


    $.validator.addClassRules("Validate_DependingRequiredOR", {
        Validate_DependingRequiredOR: true
    });

    /**
     * @function
     * @description
     *      This function initializes the validation on all forms on the page which have a class named "Validate"
     * @return nothing
     */
    TargetNS.Init = function () {
        var i = 0,
            FormSelector,
            $ServerErrors,
            ServerErrorDialogCloseFunction;

        if (Options.FormClass) {
            FormSelector = 'form.' + Options.FormClass;
        }
        else {
            FormSelector = 'form';
        }

        // There is a configuration option in OTRS that controls if email addresses
        //  should be validated or not.
        if (Core.Config.Get('CheckEmailAddresses')) {
            $.validator.addMethod("Validate_Email", $.validator.methods.email, "");
        }

        // Init all forms separately, the validate plugin can
        //  only handle one at a time.
        $(FormSelector).each(function(){
            $(this).validate({
                ignoreTitle: true,
                errorClass: Options.ErrorClass,
                highlight: TargetNS.HighlightError,
                unhighlight: TargetNS.UnHighlightError,
                errorPlacement: OnErrorElement,
                submitHandler: OnSubmit,
                ignore: '.' + Options.IgnoreClass
            });
        });

        /*
         * If on document load there are Error classes present, there were validation errors on server side.
         * Show an alert message and initialize the tooltips.
         */
        $ServerErrors = $('input.' + Options.ServerErrorClass)
            .add('textarea.' + Options.ServerErrorClass)
            .add('select.' + Options.ServerErrorClass);

        if ($ServerErrors.length) {
            $ServerErrors.each(function () {
                TargetNS.HighlightError(this, 'ServerError');
            });

            // When the dialog closes, focus the first element which had a server error
            //  so that a tooltip will be shown to the user.
            ServerErrorDialogCloseFunction = function() {
                Core.UI.Dialog.CloseDialog($('.Dialog:visible'));
                $ServerErrors.eq(0).focus();
            };

            Core.UI.Dialog.ShowAlert(Core.Config.Get('ValidateServerErrorTitle'), Core.Config.Get('ValidateServerErrorMsg'), ServerErrorDialogCloseFunction);
        }
    };

    TargetNS.ValidateElement = function ($Element) {
        if (isJQueryObject($Element)) {
            return $Element.closest('form').validate().element($Element);
        }
        return false;
    };

    /**
     * @function
     * @description
     *      This function defines the function which is executed when validation was successful on submitting the form
     * @param {jQueryObject} $Form the form, for which this submit function is used
     * @param {Function} Func the function, which is executed on successful submitting the form. Gets the submitted form as a parameter.
     * @return nothing
     */
    TargetNS.SetSubmitFunction = function ($Form, Func) {
        if (!isJQueryObject($Form)) {
            return false;
        }
        if ($.isFunction(Func) && $Form.length) {
            Options.SubmitFunction[$Form.attr('id')] = Func;
        }
    };

    /**
     * @function
     * @description
     *      This function adds special validation methods, which check a special rule only, if another depending method returns true
     * @param {String} Name The name of the rule aka the name of the class attribute used.
     * @param {String} Basis The rule which should be applied
     * @param {Function} Depends This function defined, if the given basis rule should be checked or not
     *                   (parameter: the element which should be checked; returns true, if rule should be checked)
     * @return nothing
     */
    TargetNS.AddDependingValidation = function (Name, Basis, Depends) {
        var RuleHash = {};
        RuleHash[Basis] = {
            depends: Depends
        };
        $.validator.addClassRules(Name, RuleHash);
    };

    /**
     * @function
     * @description
     *      This function is used to add special validation methods. The name can be used to define new rules.
     * @param {String} Name The name of the method
     * @param {Function} Function This function defines the specific validation method (parameter: value, element, params). Returns true if the element is valid.
     * @return nothing
     */
    TargetNS.AddMethod = function (Name, Function) {
        if (Name && $.isFunction(Function)) {
            $.validator.addMethod(Name, Function, "");
        }
    };

    /**
     * @function
     * @description
     *      This function is used to add special validation rules. The name is also the class name you can use in the HTML.
     * @param {String} Name The name of the rule
     * @param {Object} MethodHash This JS object defines, which methods should be included in this rule, e.g. { OTRS_Validate_Required: true, OTRS-Validate_MinLength: 2 }
     * @return nothing
     */
    TargetNS.AddRule = function (Name, MethodHash) {
        if (Name && typeof MethodHash === "object") {
            $.validator.addClassRules(Name, MethodHash);
        }
    };

    /**
     * @function
     * @description
     *      This function is used to disable all the elements of a Form object.
     * @param {Object} Form The form object that should be submitted
     * @return nothing
     */
    TargetNS.DisableValidation = function ($Form) {
        // If no form is given, disable validation in all form elements on the complete site
        if (!isJQueryObject($Form)) {
            $Form = $('body');
        }

        $Form
            .find("input:not([type='hidden']), textarea, select")
            .addClass(Options.IgnoreClass);
    };

    /**
     * @function
     * @description
     *      This function is used to enable all the elements of a Form object.
     * @param {Object} Form The form object that should be submitted
     * @return nothing
     */
    TargetNS.EnableValidation = function ($Form) {
        // If no form is given, disable validation in all form elements on the complete site
        if (!isJQueryObject($Form)) {
            $Form = $('body');
        }

        $Form
            .find("input:not([type='hidden']), textarea, select")
            .removeClass(Options.IgnoreClass);
    };

    return TargetNS;
}(Core.Form.Validate || {}));
