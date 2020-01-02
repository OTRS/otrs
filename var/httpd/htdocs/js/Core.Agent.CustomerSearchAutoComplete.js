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
        $("#CustomerAutoComplete, .CustomerAutoComplete").each(function () {
            Core.Agent.CustomerSearch.Init($(this));
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
 }(Core.Agent.CustomerSearchAutoComplete || {}));
