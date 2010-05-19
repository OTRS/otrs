// --
// OTRS.Agent.Dashboard.js - provides the special module functions for TicketZoom
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.Agent.App.AdminSysConfig.js,v 1.1 2010-05-19 08:46:45 mg Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};
OTRS.Agent = OTRS.Agent || {};
OTRS.Agent.App = OTRS.Agent.App || {};

/**
 * @namespace
 * @exports TargetNS as OTRS.Agent.App.AdminSysConfig
 * @description
 *      This namespace contains the special module functions for the SysConfig module.
 */
OTRS.Agent.App.AdminSysConfig = (function (TargetNS) {
    /**
     * @function
     * @return nothing
     *      This function initializes the special module functions
     */
    TargetNS.Init = function () {
        $('.AdminSysConfig h3 input:checkbox').click(function () {
            $(this).parent('h3').parent('fieldset').toggleClass('Invalid');
        });
    };

    return TargetNS;
}(OTRS.Agent.App.AdminSysConfig || {}));