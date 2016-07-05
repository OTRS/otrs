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
 * @namespace Core.Agent.TicketBulk
 * @memberof Core.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains special module functions for the TicketBulk.
 */
Core.Agent.TicketBulk = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.TicketBulk
     * @function
     * @description
     *      This function initializes the functionality for the TicketBulk screen.
     */
    TargetNS.Init = function () {

        var TicketBulkURL = Core.Config.Get('TicketBulkURL');

        // bind radio and text input fields
        $('#MergeTo').bind('blur', function() {
            if ($(this).val()) {
                $('#OptionMergeTo').prop('checked', true);
            }
        });

        // initialize the ticket action popups
        Core.Agent.TicketAction.Init();

        // execute function in the parent window
        Core.UI.Popup.ExecuteInParentWindow(function(WindowObject) {
            WindowObject.Core.UI.Popup.FirePopupEvent('URL', { URL: TicketBulkURL }, false);
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.TicketBulk || {}));
