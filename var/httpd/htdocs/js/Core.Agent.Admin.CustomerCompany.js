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
 * @namespace Core.Agent.Admin.CustomerCompany
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module function for CustomerCompany module.
 */
 Core.Agent.Admin.CustomerCompany = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Admin.CustomerCompany
     * @function
     * @description
     *      This function disables all elements of the given form in Edit screen depending of ReadOnly parameter.
     */
    TargetNS.Init = function () {
        if (parseInt(Core.Config.Get('ReadOnly'), 10) === 1) {
            Core.Form.DisableForm($("form#edit"));
        }
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
 }(Core.Agent.Admin.CustomerCompany || {}));
