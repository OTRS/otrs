// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var Core = Core || {};
Core.UI = Core.UI || {};

/**
 * @namespace Core.UI.Datepicker
 * @memberof Core.UI
 * @author OTRS AG
 * @description
 *      This namespace contains the datepicker functions.
 */
Core.UI.Datepicker = (function (TargetNS) {
    /**
     * @private
     * @name VacationDays
     * @memberof Core.UI.Datepicker
     * @member {Object}
     * @description
     *      Vacation days, defined in SysConfig.
     */
    var VacationDays,

    /**
     * @private
     * @name VacationDaysOneTime
     * @memberof Core.UI.Datepicker
     * @member {Object}
     * @description
     *      One time vacations, defined in SysConfig.
     */
        VacationDaysOneTime,

    /**
     * @private
     * @name DatepickerCount
     * @memberof Core.UI.Datepicker
     * @member {Number}
     * @description
     *      Number of initialized datepicker.
     */
        DatepickerCount = 0;

    if (!Core.Debug.CheckDependency('Core.UI.Datepicker', '$([]).datepicker', 'jQuery UI datepicker')) {
        return false;
    }

    /**
     * @private
     * @name CheckDate
     * @memberof Core.UI.Datepicker
     * @function
     * @returns {Array} First element is always true, second element contains the name of a CSS class, third element a description for the date.
     * @param {DateObject} DateObject - A JS date object to check.
     * @description
     *      Check if date is on of the defined vacation days.
     */
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
     * @name Init
     * @memberof Core.UI.Datepicker
     * @function
     * @returns {Boolean} false, if Parameter Element is not of the correct type.
     * @param {jQueryObject|Object} Element - The jQuery object of a text input field which should get a datepicker.
     *                                        Or a hash with the Keys 'Year', 'Month' and 'Day' and as values the jQueryObjects of the select drop downs.
     * @description
     *      This function initializes the datepicker on the defined elements.
     */
    TargetNS.Init = function (Element) {

        var $DatepickerElement,
            HasDateSelectBoxes = false,
            Options,
            ErrorMessage;

        if (typeof Element.VacationDays === 'object') {
            Core.Config.Set('Datepicker.VacationDays', Element.VacationDays);
        }

        /**
         * @private
         * @name LeadingZero
         * @memberof Core.UI.Datepicker.Init
         * @function
         * @returns {String} A number with leading zero, if needed.
         * @param {Number} Number - A number to convert.
         * @description
         *      Converts a one digit number to a string with leading zero.
         */
        function LeadingZero(Number) {
            if (Number.toString().length === 1) {
                return '0' + Number;
            }
            else {
                return Number;
            }
        }

        // Increment number of initialized datepickers on this site
        DatepickerCount++;

        // Check, if datepicker is used with three input element or with three select boxes
        if (typeof Element === 'object' &&
            typeof Element.Day !== 'undefined' &&
            typeof Element.Month !== 'undefined' &&
            typeof Element.Year !== 'undefined' &&
            isJQueryObject(Element.Day, Element.Month, Element.Year) &&
            // Sometimes it can happen that BuildDateSelection was called without placing the full date selection.
            //  Ignore in this case.
            Element.Day.length
        ) {

            $DatepickerElement = $('<input>').attr('type', 'hidden').attr('id', 'Datepicker' + DatepickerCount);
            Element.Year.after($DatepickerElement);

            if (Element.Day.is('select') && Element.Month.is('select') && Element.Year.is('select')) {
                HasDateSelectBoxes = true;
            }
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
            prevText: Core.Language.Translate('Previous'),
            nextText: Core.Language.Translate('Next'),
            firstDay: Element.WeekDayStart,
            showMonthAfterYear: 0,
            monthNames: [
                Core.Language.Translate('Jan'),
                Core.Language.Translate('Feb'),
                Core.Language.Translate('Mar'),
                Core.Language.Translate('Apr'),
                Core.Language.Translate('May'),
                Core.Language.Translate('Jun'),
                Core.Language.Translate('Jul'),
                Core.Language.Translate('Aug'),
                Core.Language.Translate('Sep'),
                Core.Language.Translate('Oct'),
                Core.Language.Translate('Nov'),
                Core.Language.Translate('Dec')
            ],
            monthNamesShort: [
                Core.Language.Translate('January'),
                Core.Language.Translate('February'),
                Core.Language.Translate('March'),
                Core.Language.Translate('April'),
                Core.Language.Translate('May_long'),
                Core.Language.Translate('June'),
                Core.Language.Translate('July'),
                Core.Language.Translate('August'),
                Core.Language.Translate('September'),
                Core.Language.Translate('October'),
                Core.Language.Translate('November'),
                Core.Language.Translate('December')
            ],
            dayNames: [
                Core.Language.Translate('Sunday'),
                Core.Language.Translate('Monday'),
                Core.Language.Translate('Tuesday'),
                Core.Language.Translate('Wednesday'),
                Core.Language.Translate('Thursday'),
                Core.Language.Translate('Friday'),
                Core.Language.Translate('Saturday')
            ],
            dayNamesShort: [
                Core.Language.Translate('Sun'),
                Core.Language.Translate('Mon'),
                Core.Language.Translate('Tue'),
                Core.Language.Translate('Wed'),
                Core.Language.Translate('Thu'),
                Core.Language.Translate('Fri'),
                Core.Language.Translate('Sat')
            ],
            dayNamesMin: [
                Core.Language.Translate('Su'),
                Core.Language.Translate('Mo'),
                Core.Language.Translate('Tu'),
                Core.Language.Translate('We'),
                Core.Language.Translate('Th'),
                Core.Language.Translate('Fr'),
                Core.Language.Translate('Sa')
            ],
            isRTL: Core.Config.Get('Datepicker.IsRTL')
        };

        Options.onSelect = function (DateText, Instance) {
            var Year = Instance.selectedYear,
                Month = Instance.selectedMonth + 1,
                Day = Instance.selectedDay;

            // Update the three select boxes
            if (HasDateSelectBoxes) {
                Element.Year.find('option[value=' + Year + ']').prop('selected', true);
                Element.Month.find('option[value=' + Month + ']').prop('selected', true);
                Element.Day.find('option[value=' + Day + ']').prop('selected', true);
            }
            else {
                Element.Year.val(Year);
                Element.Month.val(LeadingZero(Month));
                Element.Day.val(LeadingZero(Day));
            }
        };
        Options.beforeShow = function (Input) {
            $(Input).val('');
            return {
                defaultDate: new Date(Element.Year.val(), Element.Month.val() - 1, Element.Day.val())
            };
        };

        $DatepickerElement.datepicker(Options);

        // Add some DOM notes to the datepicker, but only if it was not initialized previously.
        //      Check if one additional DOM node is already present.
        if (!$('#' + Core.App.EscapeSelector(Element.Day.attr('id')) + 'DatepickerIcon').length) {

            // add datepicker icon and click event
            $DatepickerElement.after('<a href="#" class="DatepickerIcon" id="' + Element.Day.attr('id') + 'DatepickerIcon" title="' + Core.Language.Translate('Open date selection') + '"><i class="fa fa-calendar"></i></a>');

            if (Element.DateInFuture) {
                ErrorMessage = Core.Language.Translate('Invalid date (need a future date)!');
            }
            else if (Element.DateNotInFuture) {
                ErrorMessage = Core.Language.Translate('Invalid date (need a past date)!');
            }
            else {
                ErrorMessage = Core.Language.Translate('Invalid date!');
            }

            // Add validation error messages for all dateselection elements
            Element.Year
            .after('<div id="' + Element.Day.attr('id') + 'Error" class="TooltipErrorMessage"><p>' + ErrorMessage + '</p></div>')
            .after('<div id="' + Element.Month.attr('id') + 'Error" class="TooltipErrorMessage"><p>' + ErrorMessage + '</p></div>')
            .after('<div id="' + Element.Year.attr('id') + 'Error" class="TooltipErrorMessage"><p>' + ErrorMessage + '</p></div>');

            // only insert time element error messages if time elements are present
            if (Element.Hour && Element.Hour.length) {
                Element.Hour
                .after('<div id="' + Element.Hour.attr('id') + 'Error" class="TooltipErrorMessage"><p>' + ErrorMessage + '</p></div>')
                .after('<div id="' + Element.Minute.attr('id') + 'Error" class="TooltipErrorMessage"><p>' + ErrorMessage + '</p></div>');
            }
        }

        $('#' + Core.App.EscapeSelector(Element.Day.attr('id')) + 'DatepickerIcon').off('click.Datepicker').on('click.Datepicker', function () {
            $DatepickerElement.datepicker('show');
            return false;
        });

        // do not show the datepicker container div.
        $('#ui-datepicker-div').hide();
    };

    return TargetNS;
}(Core.UI.Datepicker || {}));
