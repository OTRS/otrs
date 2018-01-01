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
 * @namespace Core.Agent.Admin.DynamicFieldCheckbox
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the DynamicFieldCheckbox module.
 */
Core.Agent.Admin.DynamicFieldCheckbox = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Admin.DynamicFieldCheckbox
     * @function
     * @description
     *       Initialize module functionality
     */
    TargetNS.Init = function () {
        $('.ShowWarning').on('change keyup', function () {
            $('p.Warning').removeClass('Hidden');
        });

        Core.Agent.Admin.DynamicField.ValidationInit();
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.DynamicFieldCheckbox || {}));
