// --
// Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
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
 * @namespace Core.Agent.Admin.Log
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for log.
 */
 Core.Agent.Admin.Log = (function (TargetNS) {

    /*
    * @name Init
    * @memberof Core.Agent.Admin.Log
    * @function
    * @description
    *      This function initializes log filter and click event for hint hiding.
    */
    TargetNS.Init = function () {

        /* initialize filter */
        Core.UI.Table.InitTableFilter($('#FilterLogEntries'), $('#LogEntries'));

        /* create click event for hint hiding */
        $('#HideHint').on('click', function() {
           $(this).parents('.SidebarColumn').hide();
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.Log || {}));
