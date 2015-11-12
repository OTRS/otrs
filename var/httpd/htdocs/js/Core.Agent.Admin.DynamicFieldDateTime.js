// --
// Core.Agent.Admin.DynamicFieldDateTime.js - provides the special module functions for the Date Time Dynamic Fields.
// Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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
