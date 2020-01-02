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
 * @namespace Core.Agent.Admin.SystemMaintenance
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special function for AdminSystemMaintenance module.
 */
 Core.Agent.Admin.SystemMaintenance = (function (TargetNS) {

    /*
    * @name Init
    * @memberof Core.Agent.Admin.SystemMaintenance
    * @function
    * @description
    *      This function initializes module functionality.
    */
    TargetNS.Init = function () {

        // Initialize table filter
        Core.UI.Table.InitTableFilter($('#FilterSystemMaintenances'), $('#SystemMaintenances'));

        // Initialize bind click on delete action
        $('.SystemMaintenanceDelete').on('click', function (Event) {

            if (window.confirm(Core.Language.Translate("Do you really want to delete this scheduled system maintenance?"))) {
                return true;
            }

            // don't interfere with MasterAction
            Event.stopPropagation();
            Event.preventDefault();
            return false;
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.SystemMaintenance || {}));
