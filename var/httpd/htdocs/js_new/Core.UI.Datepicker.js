// --
// Core.UI.Datepicker.js - Datepicker
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.UI.Datepicker.js,v 1.5 2010-06-18 09:04:33 mn Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.UI = Core.UI || {};

/**
 * @namespace
 * @exports TargetNS as Core.Datepicker
 * @description
 *      This namespace contains the datepicker functions
 */
Core.UI.Datepicker = (function (TargetNS) {
    var VacationDays,
        VacationDaysOneTime,
        LocalizationData,
        DatepickerCount = 0;

    function CheckDate(DateObject) {
        var DayDescription = '',
            DayClass = '';

        // Get defined days from Config, if not done already
        if (typeof VacationDays === 'undefined') {
            VacationDays = Core.Config.Get('Datepicker.VacationDays').TimeVacationDays;
        }
        if (typeof VacationDaysOneTime === 'undefined') {
            VacationDaysOneTime = Core.Config.Get('Datepicker.VacationDays').TimeVacationDaysOneTime;
        }

        // Check if date is one of the vacation days
        if (typeof VacationDays[DateObject.getMonth() + 1] !== 'undefined' &&
            typeof VacationDays[DateObject.getMonth() + 1][DateObject.getDate()] !== 'undefined') {
            DayDescription += VacationDays[DateObject.getMonth() + 1][DateObject.getDate()];
            DayClass = 'Highlight ';
        }

        // Check if date is one of the one time vacation days
        if (typeof VacationDaysOneTime[DateObject.getFullYear()] !== 'undefined' &&
            typeof VacationDaysOneTime[DateObject.getFullYear()][DateObject.getMonth() + 1] !== 'undefined' &&
            typeof VacationDaysOneTime[DateObject.getFullYear()][DateObject.getMonth() + 1][DateObject.getDate()] !== 'undefined') {
            DayDescription += VacationDaysOneTime[DateObject.getFullYear()][DateObject.getMonth() + 1][DateObject.getDate()];
            DayClass = 'Highlight ';
        }

        if (DayClass.length) {
            return [true, DayClass, DayDescription];
        }
        else {
            return [true, ''];
        }
    }

    /**
     * @function
     * @description
     *      This function initializes the datepicker on the defined elements.
     * @param {Object} Element The jQuery object of a text input field which should get  a datepicker.
     *                 Or a hash with the Keys 'Year', 'Month' and 'Day' and as values the jQueryObjects of the select drop downs.
     * @param {jQueryObject} $Image The jQuery object of the datepicker icon element
     * @return nothing
     */
    TargetNS.Init = function (Element, $Image) {
        var $DatepickerElement,
            HasDateSelectBoxes = false,
            I;

        if (typeof LocalizationData === 'undefined') {
            LocalizationData = Core.Config.Get('Datepicker.Localization');
        }

        // Increment number of initialized datepickers on this site
        DatepickerCount++;

        // Check, if datepicker is used with a single input element or with three select boxes
        if (isJQueryObject(Element) && Element.is(':text')) {
            $DatepickerElement = Element;
        }
        else if (typeof Element === 'object' &&
                 typeof Element['Day'] !== 'undefined' &&
                 typeof Element['Month'] !== 'undefined' &&
                 typeof Element['Year'] !== 'undefined' &&
                 isJQueryObject(Element['Day'], Element['Month'], Element['Year'])) {
            HasDateSelectBoxes = true;

            // Create a new hidden input field for the datepicker
            $DatepickerElement = $('<input>').attr('type', 'hidden').attr('id', 'Datepicker' + DatepickerCount);
            Element['Year'].after($DatepickerElement);
        }
        else {
            return false;
        }

        // Define options hash
        Options = {
            beforeShowDay: function (DateObject) {
                return CheckDate(DateObject);
            },
            showOn: 'focus',
            prevText: LocalizationData.PrevText,
            nextText: LocalizationData.NextText,
            firstDay: 0,
            showMonthAfterYear: 0,
            monthNames: LocalizationData.MonthNames,
            monthNamesShort: LocalizationData.MonthNamesShort,
            dayNames: LocalizationData.DayNames,
            dayNamesShort: LocalizationData.DayNamesShort,
            dayNamesMin: LocalizationData.DayNamesMin,
            isRTL: LocalizationData.IsRTL
        };

        if (HasDateSelectBoxes) {
            Options.onSelect = function (DateText, Instance) {
                var Year = Instance.selectedYear,
                    Month = Instance.selectedMonth + 1,
                    Day = Instance.selectedDay;

                // Update the three select boxes
                Element['Year'].find('option[value=' + Year + ']').attr('selected', 'selected');
                Element['Month'].find('option[value=' + Month + ']').attr('selected', 'selected');
                Element['Day'].find('option[value=' + Day + ']').attr('selected', 'selected');
            };
            Options.beforeShow = function (Input, Instance) {
                $(Input).val('');
                return {
                    defaultDate: new Date(Element.Year.val(), Element.Month.val() - 1, Element.Day.val())
                }
            };

        }

        $DatepickerElement.datepicker(Options);

        // add click event to datepicker icon
        if (isJQueryObject($Image)) {
            $Image.click(function () {
                $DatepickerElement.trigger('focus');
                return false;
            });
        }

        // do not show the datepicker container div.
        $('#ui-datepicker-div').hide();
    };

    return TargetNS;
}(Core.UI.Datepicker || {}));