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
 * @namespace Core.Agent.Admin.GenericInterfaceErrorHandlingRequestRetry
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special functions for the GenericInterface request retry module.
 */
Core.Agent.Admin.GenericInterfaceErrorHandlingRequestRetry = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Admin.GenericInterfaceErrorHandlingRequestRetry
     * @function
     * @description
     *      Initializes the module functions.
     */
    TargetNS.Init = function () {

        // hide and show the related retry fields
        $('#ScheduleRetry').off('change.ScheduleRetry').on('change.ScheduleRetry', function(){

            if ($('#ScheduleRetry').val() === '1') {

                $('#ScheduleRetryFields').fadeIn();
                Core.UI.InputFields.Activate($('#ScheduleRetryFields'));
            }
            else {
                $('#ScheduleRetryFields').fadeOut();
            }
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.GenericInterfaceErrorHandlingRequestRetry || {}));
