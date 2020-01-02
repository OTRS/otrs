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
 *      This namespace contains the special functions for SystemConfiguration.VacationDays module.
 */
Core.SystemConfiguration.VacationDays = (function (TargetNS) {

    /**
     * @public
     * @name ValueGet
     * @memberof Core.SystemConfiguration.VacationDays
     * @function
     * @param {jQueryObject} $Object - jquery object that holds VacationDays value.
     * @description
     *      This function return selected VacationDays value.
     * @returns {String} VacationDays.
     */
    TargetNS.ValueGet = function ($Object) {
        var Value;

        // There are many input/select fields, but we should calcutale Date only once.
        if ($Object.attr("id").endsWith("Day")) {
            Value = VacationDaysValueGet($Object);
        }

        return Value;
    };

    /**
     * @private
     * @name VacationDaysValueGet
     * @memberof Core.SystemConfiguration.VacationDays
     * @function
     * @param {jQueryObject} $Object - jquery object.
     * @returns {Object} - Vacation days data.
     * @description
     *      This function calcutates vacation days.
     */
    function VacationDaysValueGet($Object) {
        var Prefix,
            Result,
            Month,
            Day,
            Description;

        Prefix = $Object.attr("id");
        Prefix = Prefix.substr(0, Prefix.length - 3);

        // Escape selector.
        Prefix = Core.App.EscapeSelector(Prefix);

        Month = parseInt($Object.parent().find("#" + Prefix + "Month").val(), 10);
        Day = parseInt($Object.val(), 10);
        Description = $Object.parent().find("#" + Prefix + "Description").val();

        Result = {};
        Result[Month] = {};
        Result[Month][Day] = Description;

        return Result;
    }

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.SystemConfiguration.VacationDays || {}));
