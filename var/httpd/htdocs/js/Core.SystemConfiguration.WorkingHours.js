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
 *      This namespace contains the special functions for SystemConfiguration.WorkingHours module.
 */
Core.SystemConfiguration.WorkingHours = (function (TargetNS) {

    /**
     * @public
     * @name ValueGet
     * @memberof Core.SystemConfiguration.WorkingHours
     * @function
     * @param {jQueryObject} $Object - jquery object that holds WorkingHours value.
     * @description
     *      This function return selected WorkingHours value.
     * @returns {String} WorkingHours
     */
    TargetNS.ValueGet = function ($Object) {
        var Value,
            Day;

        Day = $Object.attr("data-day");
        Value = {};
        if ($Object.is(":checked")) {
            Value[Day] = [$Object.val()];
        }

        return Value;
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.SystemConfiguration.WorkingHours || {}));
