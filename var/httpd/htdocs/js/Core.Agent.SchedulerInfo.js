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
 * @namespace Core.Agent.Scheduler
 * @memberof Core.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the Scheduler module.
 */
Core.Agent.Scheduler = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Scheduler
     * @function
     * @param {Boolean} Params - Initialization and internationalization parameters.
     * @param {Object} Params.Localization - Localization strings.
     * @description
     *      This function initialize correctly all other function according to the local language.
     */
    TargetNS.Init = function (Params) {
        TargetNS.Localization = Params.Localization;
    };

    /**
     * @private
     * @name ShowWaitingDialog
     * @memberof Core.Agent.Scheduler
     * @function
     * @description
     *      Shows waiting dialog until scheduler start screen is ready.
     */
    function ShowWaitingDialog(){
        Core.UI.Dialog.ShowContentDialog('<div class="Spacing Center"><span class="AJAXLoader" title="' + Core.Config.Get('LoadingMsg') + '"></span></div>', Core.Config.Get('LoadingMsg'), '240px', 'Center', true);
    }

    /**
     * @name OpenSchedulerStartDialog
     * @memberof Core.Agent.Scheduler
     * @function
     * @description
     *      This function open the scheduler start dialog.
     */
    TargetNS.OpenSchedulerStartDialog = function(){

        var Data = {
            Action: 'AgentSchedulerInfo'
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
