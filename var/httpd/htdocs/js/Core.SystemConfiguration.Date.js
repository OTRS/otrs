// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var Core = Core || {};
Core.SystemConfiguration = Core.SystemConfiguration || {};

/**
 * @namespace Core.SystemConfiguration
 * @memberof Core
 * @author OTRS AG
 * @description
 *      This namespace contains the special functions for SystemConfiguration.Date module.
 */
Core.SystemConfiguration.Date = (function (TargetNS) {

    /**
     * @public
     * @name ValueGet
     * @memberof Core.SystemConfiguration.Date
     * @function
     * @param {jQueryObject} $Object - jquery object that holds Day value.
     * @description
     *      This function return selected Date/DateTime value.
     * @returns {String} Date/DateTime value (example: 2016-11-25)
     */
    TargetNS.ValueGet = function ($Object) {
        var Value;

        // There are many input/select fields, but we should calcutale Date only once.
        if ($Object.attr("name").endsWith("Day")) {
            Value = DateValueGet($Object);
        }

        return Value;
    };

    /**
     * @public
     * @name CheckID
     * @memberof Core.SystemConfiguration.Date
     * @function
     * @param {jQueryObject} $Object - jquery object that holds Day value.
     * @param {Number} OldID - old element ID
     * @description
     *      This function performs dedicated commands during CheckIDs().
     *      In this case, element classes are updated.
     */
    TargetNS.CheckID = function ($Object, OldID) {
        var ID,
            OldSubID,
            SubID,
            Class,
            ErrorDivID;

        if ($Object.hasClass("Entry")) {
            ID = $Object.attr("id");
        }
        else {
            ID = $Object.attr("data-suffix");
        }

        if (!OldID.endsWith("Day")) {
            return;
        }

        // get id without the "Day" suffix (needed for other items)
        SubID = ID.substr(0, ID.length - 3);
        OldSubID = OldID.substr(0, OldID.length - 3);

        Class = $Object.attr("class");

        // update class for year
        Class = Class.replace(
            "Validate_DateYear_" + OldSubID + "Year",
            "Validate_DateYear_" + SubID + "Year"
        );

        // update class for month
        Class = Class.replace(
            "Validate_DateMonth_" + OldSubID + "Month",
            "Validate_DateMonth_" + SubID + "Month"
        );
        $Object.attr("class", Class);

        // Escape selector - from now on we use it as selector(not a class), so it must be escaped properly.
        OldSubID = Core.App.EscapeSelector(OldSubID);

        // Year
        ErrorDivID = $('div#' + OldSubID + "YearError").attr('id');
        ErrorDivID.replace(
            OldSubID,
            SubID
        );
        $('div#' + OldSubID + "YearError").attr('id', ErrorDivID);

        // Month
        ErrorDivID = $('div#' + OldSubID + "MonthError").attr('id');
        ErrorDivID.replace(
            OldSubID,
            SubID
        );
        $('div#' + OldSubID + "MonthError").attr('id', ErrorDivID);

        // Day
        ErrorDivID = $('div#' + OldSubID + "DayError").attr('id');
        ErrorDivID.replace(
            OldSubID,
            SubID
        );
        $('div#' + OldSubID + "DayError").attr('id', ErrorDivID);
    };

    /**
     * @private
     * @name DateValueGet
     * @memberof Core.SystemConfiguration.Date
     * @function
     * @param {jQueryObject} $Object - jquery object that holds Day value.
     * @description
     *      This function return selected Date/DateTime value.
     * @returns {String} Date/DateTime value (example: 2016-11-25 12:45:00)
     */
    function DateValueGet($Object) {
        var
            Day,
            Month,
            Year,
            Prefix,
            Result;

        // extract prefix
        Prefix = $Object.attr("id");
        Prefix = Prefix.substr(0, Prefix.length - 3);

        // Escape selector.
        Prefix = Core.App.EscapeSelector(Prefix);

        if ($Object.is('select')) {
            Day = $Object.find("option:selected").val();
            if (Day < 10) {
                Day = "0" + Day;
            }
            Month = $("#" + Prefix + "Month").find("option:selected").val();
            if (Month < 10) {
                Month = "0" + Month;
            }
            Year = $("#" + Prefix + "Year").find("option:selected").val();
        }
        else {
            Day = $Object.val();
            Month = $("#" + Prefix + "Month").val();
            Year = $("#" + Prefix + "Year").val();
        }

        Result = Year + "-" + Month + "-" + Day;

        return Result;
    }

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.SystemConfiguration.Date || {}));
