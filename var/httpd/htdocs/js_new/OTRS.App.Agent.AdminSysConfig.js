// --
// OTRS.Agent.Dashboard.js - provides the special module functions for TicketZoom
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.App.Agent.AdminSysConfig.js,v 1.1 2010-04-22 18:08:28 mg Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};
OTRS.App = OTRS.App || {};
OTRS.App.Agent = OTRS.App.Agent || {};

/**
 * @namespace
 * @exports TargetNS as OTRS.App.Agent.AdminSysConfig
 * @description
 *      This namespace contains the special module functions for the SysConfig module.
 */
OTRS.App.Agent.AdminSysConfig = (function (TargetNS) {
    /**
     * @function
     * @return nothing
     *      This function initializes the special module functions
     */
    TargetNS.Init = function () {
        $('.AdminSysConfig h3 input:checkbox').click(function(){
            $(this).parent('h3').parent('fieldset').toggleClass('Invalid');
        });
    };

    return TargetNS;
}(OTRS.App.Agent.Dashboard || {}));