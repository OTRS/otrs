// --
// Core.Agent.SchedulerInfo.js - provides the special module functions for the scheduler.
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
 * @namespace
 * @exports TargetNS as Core.Agent.Admin.Scheduler
 * @description
 *      This namespace contains the special module functions for the Scheduler module.
 */
Core.Agent.Scheduler = (function (TargetNS) {

    /**
     * @function
     * @param {Object} Params, initialization and internationalization parameters.
     * @return nothing
     *      This function initialize correctly all other function according to the local language
     */
    TargetNS.Init = function (Params) {
        TargetNS.Localization = Params.Localization;
    };


    /**
     * @function
     * @private
     * @return nothing
     * @description Shows waiting dialog until scheduler start screen is ready.
     */
    function ShowWaitingDialog(){
        Core.UI.Dialog.ShowContentDialog('<div class="Spacing Center"><span class="AJAXLoader" title="' + Core.Config.Get('LoadingMsg') + '"></span></div>', Core.Config.Get('LoadingMsg'), '240px', 'Center', true);
    }

    /**
     * @function
     * @return nothing
     *      This function open the scheduler start dialog.
     */

    TargetNS.OpenSchedulerStartDialog = function(){

        var Data = {
            Action: 'AgentSchedulerInfo',
        };

        ShowWaitingDialog();

        // call dialog HTML via AJAX
        Core.AJAX.FunctionCall(
            Core.Config.Get('CGIHandle'),
            Data,
            function (HTML) {

                // if the waiting dialog was canceled, do not show the scheduler
                //  dialog as well
                if (!$('.Dialog:visible').length) {
                    return;
                }

                // show main dialog
                Core.UI.Dialog.ShowContentDialog(HTML, 'Start Scheduler Information', '240px', 'Center', true);

                // set cancel button action
                $('#SchedulerFormCancel').bind('click', function() {

                    // close main dialog
                    Core.UI.Dialog.CloseDialog($('#SchedulerRunDialog'));
                });

            }, 'html'
        );
    };

    return TargetNS;
}(Core.Agent.Scheduler || {}));

// set action to scheduler notify band link
$('.SchedulerInfo').bind('click', function() {
    Core.Agent.Scheduler.OpenSchedulerStartDialog();
    return false;
});
