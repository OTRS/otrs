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
 * @namespace Core.Agent.Admin.QueueAutoResponse
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special function for AdminQueueAutoResponse module.
 */
 Core.Agent.Admin.QueueAutoResponse = (function (TargetNS) {

    /*
    * @name Init
    * @memberof Core.Agent.Admin.QueueAutoResponse
    * @function
    * @description
    *      This function initializes filters.
    */
    TargetNS.Init = function () {
        Core.UI.Table.InitTableFilter($('#FilterQueues'), $('#Queues'));
        Core.UI.Table.InitTableFilter($('#FilterAutoResponses'), $('#AutoResponses'));
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.QueueAutoResponse || {}));
