// --
// Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.SystemConfiguration = Core.SystemConfiguration || {};

/**
 * @namespace Core.SystemConfiguration
 * @memberof Core
 * @author OTRS AG
 * @description
 *      This namespace contains the special functions for SystemConfiguration.DateTime module.
 */
Core.SystemConfiguration.DateTime = (function (TargetNS) {

    /**
     * @public
     * @name ValueGet
     * @memberof Core.SystemConfiguration.DateTime
     * @function
     * @param {jQueryObject} $Object - jquery object that holds DateTime value.
     * @description
     *      This function return selected Date/DateTime value.
     * @returns {String} Date/DateTime value (example: 2016-11-25 12:45:00)
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
     * @memberof Core.SystemConfiguration.DateTime
     * @function
     * @param {jQueryObject} $Object - jquery object that holds Day value.
     * @param {Number} ID - element ID
     * @description
     *      This function performs dedicated commands during CheckIDs().
     *      In this case, element classes are updated.
     */
    TargetNS.CheckID = function ($Object, ID) {
        var OldID,
            OldSubID,
            SubID,
            Class;

        if ($Object.hasClass("Entry")) {
            OldID = $Object.attr("id");
        }
        else {
            OldID = $Object.attr("data-suffix");
        }

        // get id without the "Day" suffix (needed for other items)
        OldSubID = OldID;
        OldSubID = OldSubID.substr(0, OldSubID.length - 3);
        SubID = ID;
        SubID = ID.substr(0, ID.length - 3);

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

        // update class for hour
        Class = Class.replace(
            "Validate_DateHour_" + OldSubID + "Hour",
            "Validate_DateHour_" + SubID + "Hour"
        );

        // update class for minute
        Class = Class.replace(
            "Validate_DateMinute_" + OldSubID + "Minute",
            "Validate_DateMinute_" + SubID + "Minute"
        );

        $Object.attr("class", Class);
    };

    /**
     * @private
     * @name DateValueGet
     * @memberof Core.SystemConfiguration.DateTime
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
            Hour,
            Minute,
            Prefix,
            Result;

        // extract prefix
        Prefix = $Object.attr("id");
        Prefix = Prefix.substr(0, Prefix.length - 3);

        // Escape #
        Prefix = Prefix.replace(/#/g, '\\#');

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
            Hour = $("#" + Prefix + "Hour").find("option:selected").val();
            if (Hour !== undefined && Hour < 10) {
                Hour = "0" + Hour;
            }
            Minute = $("#" + Prefix + "Minute").find("option:selected").val();
            if (Minute !== undefined && Minute < 10) {
                Minute = "0" + Minute;
            }
        }
        else {
            Day = $Object.val();
            Month = $("#" + Prefix + "Month").val();
            Year = $("#" + Prefix + "Year").val();
            Hour = $("#" + Prefix + "Hour").val();
            Minute = $("#" + Prefix + "Minute").val();
        }

        Result = Year + "-" + Month + "-" + Day;
        if (Hour !== undefined) {
            Result += " " + Hour + ":" + Minute + ":00";
        }

        return Result;
    }

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.SystemConfiguration.DateTime || {}));
