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

/**
 * @namespace Core.Agent.Header
 * @memberof Core.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains the functions for handling Header in framework.
 */
Core.Agent.Header = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Header
     * @function
     * @description
     *      Initializes the module functionality.
     */
    TargetNS.Init = function () {

        // Bind event on ToolBarSearchProfile field
        $('#ToolBarSearchProfile').on('change', function (Event) {
            $(Event.target).closest('form').submit();
            Event.preventDefault();
            Event.stopPropagation();
            return false;
        });

        // Initialize auto complete searches
        Core.Agent.CustomerInformationCenterSearch.InitAutocomplete($('#ToolBarCICSearchCustomerID'), "SearchCustomerID");
        Core.Agent.CustomerUserInformationCenterSearch.InitAutocomplete($('#ToolBarCICSearchCustomerUser'), "SearchCustomerUser");

        // Initialize full text search
        Core.Agent.Search.InitToolbarFulltextSearch();

        // Bind event on Simulate RTL button
        $('.DebugRTL').on('click', function () {
            Core.Debug.SimulateRTLPage();
        });

    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Header || {}));
