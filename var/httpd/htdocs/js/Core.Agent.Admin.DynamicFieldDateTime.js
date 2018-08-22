// --
// Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};
Core.Agent.Admin = Core.Agent.Admin || {};

/**
 * @namespace
 * @exports TargetNS as Core.Agent.Admin.DynamicFielddropdown
 * @description
 *      This namespace contains the special module functions for the DynamicFieldDropdown module.
 */
Core.Agent.Admin.DynamicFieldDateTime = (function (TargetNS) {

    /**
     * @function
     * @param {bool} YearsPeriod, 0 or 1 to show or hide the Years in Future and in Past fields.
     * @return nothing
     *      This function shows or hide two fields (Years In future and Years in Past) depending
     *      on the YearsPeriod parameter
     */

    TargetNS.ToogleYearsPeriod = function (YearsPeriod){

        if (YearsPeriod === '1') {
            $('#YearsPeriodOption').removeClass('Hidden');
        }
        else {
            $('#YearsPeriodOption').addClass('Hidden');
        }
        return false;
    };

    return TargetNS;
}(Core.Agent.Admin.DynamicFieldDateTime || {}));
