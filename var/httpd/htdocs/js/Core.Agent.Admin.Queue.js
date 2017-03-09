// --
// Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
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
 * @namespace Core.Agent.Admin.Queue
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module function for AdminQueue.
 */
 Core.Agent.Admin.Queue = (function (TargetNS) {

    /*
    * @name Init
    * @memberof Core.Agent.Admin.Queue
    * @function
    * @description
    *      This function initializes filter.
    */
    TargetNS.Init = function () {

        Core.UI.Table.InitTableFilter($("#FilterQueues"), $("#Queues"));

        Core.Config.Set('EntityType', 'Queue');
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.Queue || {}));
