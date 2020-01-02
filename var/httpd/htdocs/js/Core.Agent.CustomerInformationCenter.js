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
 * @namespace Core.Agent.CustomerInformationCenter
 * @memberof Core.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for CustomerInformationCenter.
 */
Core.Agent.CustomerInformationCenter = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.CustomerInformationCenter
     * @function
     * @description
     *      This function binds click event for opening search dialog.
     */
    TargetNS.Init = function () {

        // Binds event for opening search dialog
        $('#CustomerInformationCenterHeading').on('click', function() {
            Core.Agent.CustomerInformationCenterSearch.OpenSearchDialog();
            return false;
        });

    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.CustomerInformationCenter || {}));
