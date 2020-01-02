// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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
 * @namespace Core.Agent.Admin.DynamicFieldDateTime
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the DynamicFieldDateTime module.
 */
Core.Agent.Admin.DynamicFieldDateTime = (function (TargetNS) {

    /**
     * @name ToggleYearsPeriod
     * @memberof Core.Agent.Admin.DynamicFieldDateTime
     * @function
     * @returns {Boolean} false
     * @param {Number} YearsPeriod - 0 or 1 to show or hide the Years in Future and in Past fields.
     * @description
     *      This function shows or hide two fields (Years In future and Years in Past) depending
     *      on the YearsPeriod parameter
     */
    TargetNS.ToggleYearsPeriod = function (YearsPeriod) {
        if (YearsPeriod === '1') {
            $('#YearsPeriodOption').removeClass('Hidden');
        }
        else {
            $('#YearsPeriodOption').addClass('Hidden');
        }
        return false;
    };

    /**
     * @name Init
     * @memberof Core.Agent.Admin.DynamicFieldDateTime
     * @function
     * @description
     *       Initialize module functionality
     */
    TargetNS.Init = function () {
        $('.ShowWarning').on('change keyup', function () {
            $('p.Warning').removeClass('Hidden');
        });

        $('#YearsPeriod').on('change', function () {
            TargetNS.ToggleYearsPeriod($(this).val());
        });

        Core.Agent.Admin.DynamicField.ValidationInit();
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.DynamicFieldDateTime || {}));
