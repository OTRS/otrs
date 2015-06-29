// --
// Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
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
 * @namespace Core.Agent.Admin.SysConfig
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the SysConfig module.
 */
Core.Agent.Admin.SysConfig = (function (TargetNS) {
    /**
     * @name Init
     * @memberof Core.Agent.Admin.SysConfig
     * @function
     * @description
     *      Initializes SysConfig screen.
     */
    TargetNS.Init = function () {
        $('#AdminSysConfig h3 input[type="checkbox"]').click(function () {
            $(this).parent('h3').parent('fieldset').toggleClass('Invalid');
        });
    };

    return TargetNS;
}(Core.Agent.Admin.SysConfig || {}));
