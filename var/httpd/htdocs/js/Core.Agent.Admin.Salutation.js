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
 * @namespace Core.Agent.Admin.Salutation
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module function for AdminSalutation.
 */
 Core.Agent.Admin.Salutation = (function (TargetNS) {

    /*
    * @name Init
    * @memberof Core.Agent.Admin.Salutation
    * @function
    * @description
    *      This function initializes the table filter.
    */
    TargetNS.Init = function () {
        Core.UI.Table.InitTableFilter($('#FilterSalutations'), $('#Salutations'));
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.Salutation || {}));
