// --
// Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};

/**
 * @namespace Core.Agent.CustomerSearchAutoComplete
 * @memberof Core.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains the special module function for initialize autocomplete.
 */
 Core.Agent.CustomerSearchAutoComplete = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.CustomerSearchAutoComplete
     * @function
     * @description
     *      This function initializes autocomplete in customer search fields.
     */
    TargetNS.Init = function () {
        Core.Agent.CustomerSearch.Init($("#CustomerAutoComplete, .CustomerAutoComplete"));
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
 }(Core.Agent.CustomerSearchAutoComplete || {}));
