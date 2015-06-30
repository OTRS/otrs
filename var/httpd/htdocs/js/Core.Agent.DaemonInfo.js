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

/**
 * @namespace Core.Agent.Daemon
 * @memberof Core.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the Daemon module.
 */
Core.Agent.Daemon = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Daemon
     * @function
     * @param {Boolean} Params - Initialization and internationalization parameters.
     * @param {Object} Params.Localization - Localization strings.
     * @description
     *      This function initialize correctly all other functions according to the local language.
     */
    TargetNS.Init = function (Params) {
        TargetNS.Localization = Params.Localization;
    };

    /**
     * @private
     * @name ShowWaitingDialog
     * @memberof Core.Agent.Daemon
     * @function
     * @description
     *      Shows waiting dialog until daemon start screen is ready.
     */
    function ShowWaitingDialog(){
        Core.UI.Dialog.ShowContentDialog('<div class="Spacing Center"><span class="AJAXLoader" title="' + Core.Config.Get('LoadingMsg') + '"></span></div>', Core.Config.Get('LoadingMsg'), '240px', 'Center', true);
    }

    /**
     * @name OpenDaemonStartDialog
     * @memberof Core.Agent.Daemon
     * @function
     * @description
     *      This function open the daemon start dialog.
     */

    TargetNS.OpenDaemonStartDialog = function(){

        var Data = {
            Action: 'AgentDaemonInfo'
        };

        ShowWaitingDialog();

        // call dialog HTML via AJAX
        Core.AJAX.FunctionCall(
            Core.Config.Get('CGIHandle'),
            Data,
            function (HTML) {

                // if the waiting dialog was canceled, do not show the daemon
                //  dialog as well
                if (!$('.Dialog:visible').length) {
                    return;
                }

                // show main dialog
                Core.UI.Dialog.ShowContentDialog(HTML, 'Start OTRS Daemon Information', '240px', 'Center', true);

                // set cancel button action
                $('#DaemonFormCancel').bind('click', function() {

                    // close main dialog
                    Core.UI.Dialog.CloseDialog($('#DaemonRunDialog'));
                });

            }, 'html'
        );
    };

    return TargetNS;
}(Core.Agent.Daemon || {}));

// set action to daemon notify band link
$('.DaemonInfo').bind('click', function() {
    Core.Agent.Daemon.OpenDaemonStartDialog();
    return false;
});
