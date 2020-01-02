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
 * @namespace Core.Agent.Admin.PGP
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module function for PGP module.
 */
 Core.Agent.Admin.PGP = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Admin.PGP
     * @function
     * @description
     *      This function initializes the special module functions
     */
    TargetNS.Init = function () {

        // Bind click function to remove button
        $('#PGP a.TrashCan').on('click', function () {
            if (window.confirm(Core.Language.Translate('Do you really want to delete this key?'))) {
                return true;
            }
            return false;
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
 }(Core.Agent.Admin.PGP || {}));
