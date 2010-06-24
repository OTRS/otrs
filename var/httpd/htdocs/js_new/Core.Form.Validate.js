// --
// Core.Form.Validate.js - provides functions for validating form inputs
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.Form.Validate.js,v 1.3 2010-06-24 10:50:13 mn Exp $
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
        SubmitFunction:     {}
    };

    /*
     * check dependencies first
     */
    if (!Core.Debug.CheckDependency('Core.Form.Validate', 'Core.UI.Accessibility', 'Core.UI.Accessibility')) {
        return;
    }

    function HighlightError(Element, ErrorType) {
        var $Element = $(Element),
            InputErrorMessageHTML,
            InputErrorMessageText;

        /*
         * Check error type and correct it, if necessary
         */
        if (ErrorType !== 'Error' && ErrorType !== 'ServerError') {
            ErrorType = 'Error';
        }

        /*
         * Add error class to field and its label
         */
        $Element.addClass(Options.ErrorClass);
        $(Element.form).find("label[for=" + Element.id + "]").addClass(Options.ErrorLabelClass);

        /*
         * mark field as invalid for screenreader users
         */
        $Element.attr('aria-invalid', true);

        /* Get the target element and find the associated hidden div with the
         * error message.
         */
        InputErrorMessageHTML = $('#' + $Element.attr('id') + ErrorType).html();
        InputErrorMessageText = $('#' + $Element.attr('id') + ErrorType).text();

        if (InputErrorMessageHTML && InputErrorMessageHTML.length) {
            // if error field is a RTE, it is a little bit more difficult
            if ($('#cke_' + Element.id).length) {
                Core.Form.ErrorTooltips.InitRTETooltip($Element, InputErrorMessageHTML);
            } else {
                Core.Form.ErrorTooltips.InitTooltip($Element, InputErrorMessageHTML);
            }
        }

        /*
         * speak the error message for screen reader users
         */
        Core.UI.Accessibility.AudibleAlert(InputErrorMessageText);
    }

    function UnHighlightError(Element) {
        var $Element = $(Element);

        /*
         * remove error classes from element and its label
         */
        $Element.removeClass(Options.ErrorClass);
        $(Element.form).find("label[for=" + Element.id + "]").removeClass(Options.ErrorLabelClass);

        /*
         * mark field as valid for screenreader users
         */
        $Element.attr('aria-invalid', false);

        // if error field is a RTE, it is a little bit more difficult
        if ($('#cke_' + Element.id).length) {
            Core.Form.ErrorTooltips.RemoveRTETooltip($Element);
        } else {
            Core.Form.ErrorTooltips.RemoveTooltip($Element);
        }
    }

    // this function prevents the default placing of the error messages
    function OnErrorElement(Error, Element) {
        return true;
    }

    function OnSubmit(Form) {
        $(Form).removeClass('ClientError').removeClass('LabelError');
        if ($.isFunction(Options.SubmitFunction[Form.id])) {
            Options.SubmitFunction[Form.id](Form);
        }
        else {
            Form.submit();
        }
    }

    /*
     * Definitions of all OTRS specific rules and rule methods
     */
    $.validator.addMethod("Validate_Required", $.validator.methods.required, "");
    $.validator.addMethod("Validate_Number", $.validator.methods.digits, "");
    $.validator.addMethod("Validate_Email", $.validator.methods.email, "");
    $.validator.addMethod("Validate_RequiredDropdown", function (Value, Element) {
        return ($(Element).find('option:selected').text() !== '-');
    }, "")

    $.validator.addMethod("Validate_RequiredRichtext", function (Value, Element) {
        if (Core.UI.RichTextEditor.IsEnabled($(Element))) {
            Core.UI.RichTextEditor.UpdateLinkedField($(Element));
        }
        return ($(Element).val().length > 0);
    }, "")

    $.validator.addMethod("Validate_DateYear", function (Value, Element) {
        return (parseInt(Value, 10) > 999 && parseInt(Value, 10) < 10000);
    }, "");

    $.validator.addMethod("Validate_DateMonth", function (Value, Element) {
        return (parseInt(Value, 10) > 0 && parseInt(Value, 10) < 13);
    }, "");

    $.validator.addMethod("Validate_DateDay", function (Value, Element) {
        var Classes = $(Element).attr('class'),
            DateObject,
            RegExYear,
            RegExMonth,
            YearElement = '',
            MonthElement = '',
            DateYearClassPrefix = 'Validate_DateYear_',
            DateMonthClassPrefix = 'Validate_DateMonth_';
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
               return true;
           }
        }
        return false;
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

    $.validator.addClassRules("Validate_Required", {
        Validate_Required: true
    });

    $.validator.addClassRules("Validate_Number", {
        Validate_Digits: true
    });

    $.validator.addClassRules("Validate_Email", {
        Validate_Email: true
    });

    $.validator.addClassRules("Validate_RequiredDropdown", {
        Validate_RequiredDropdown: true
    });

    $.validator.addClassRules("Validate_RequiredRichtext", {
        Validate_RequiredRichtext: true
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

    /*
     * Adds a generic "depending required" rule:
     * The element needs a list of IDs in the class attribute. This element is required, if one of the given IDs is a element, which contains content itself (logical AND).
     */
    $.validator.addClassRules("Validate_DependingRequiredAND", {
        Validate_Required: {
            depends: function (Element) {
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

                var I,
                    ApplyRule = 0,
                    DependentElementIDs = [];

                DependentElementIDs = GetDependentElements(Element);
                if (DependentElementIDs.length) {
                    for (I = 0; I < DependentElementIDs.length; I++) {
                        if ($('#' + DependentElementIDs[I].trim()).val().length) {
                            ApplyRule++;
                            break;
                        }
                    }
                    return ApplyRule;
                }
            }
        }
    });

    /*
     * Adds another generic "depending required" rule:
     * The element needs a list of IDs in the class attribute. One of the elements (this one or the ones given by ID) is required (logical OR).
     */
    $.validator.addClassRules("Validate_DependingRequiredOR", {
        Validate_Required: {
            depends: function (Element) {
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

                var I,
                    ApplyRule = 1,
                    DependentElementIDs = [];

                DependentElementIDs = GetDependentElements(Element);
                if (DependentElementIDs.length) {
                    for (I = 0; I < DependentElementIDs.length; I++) {
                        if ($('#' + DependentElementIDs[I].trim()).val().length) {
                            ApplyRule = 0;
                        }
                    }
                    return ApplyRule;
                }
            }
        }
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
            $ServerErrors;

        if (Options.FormClass) {
            FormSelector = 'form.' + Options.FormClass;
        }
        else {
            FormSelector = 'form';
        }
        $(FormSelector).validate({
            ignoreTitle: true,
            errorClass: Options.ErrorClass,
            highlight: HighlightError,
            unhighlight: UnHighlightError,
            errorPlacement: OnErrorElement,
            submitHandler: OnSubmit
        });

        /*
         * If on document load there are Error classes present, there were validation errors on server side.
         * Show an alert message and initialize the tooltips.
         */
        $ServerErrors = $('input, textarea, select').filter('.' + Options.ServerErrorClass);
        if ($ServerErrors.length) {
            $ServerErrors.each(function () {
                HighlightError(this, 'ServerError');
            });
            Core.UI.Dialog.ShowAlert('Fehler!', 'Bei einem oder mehreren Formular-Eingaben sind Fehler aufgetreten!');
        }
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
        if (Name && typeof MethodHash === "Object") {
            $.validator.addClassRules(Name, MethodHash);
        }
    };

    return TargetNS;
}(Core.Form.Validate || {}));