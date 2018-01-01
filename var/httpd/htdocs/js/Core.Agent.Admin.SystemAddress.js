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
 * @namespace Core.Agent.Admin.SystemAddress
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special function for AdminSystemAddress module.
 */
 Core.Agent.Admin.SystemAddress = (function (TargetNS) {

    /*
    * @name Init
    * @memberof Core.Agent.Admin.SystemAddress
    * @function
    * @description
    *      This function initializes table filter.
    */
    TargetNS.Init = function () {
        Core.UI.Table.InitTableFilter($('#FilterSystemAddresses'), $('#SystemAddresses'));
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.SystemAddress || {}));
