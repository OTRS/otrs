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
 * @namespace Core.Agent.TicketSplit
 * @memberof Core.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for TicketSplit.
 */
Core.Agent.TicketSplit = (function (TargetNS) {

    /**
     * @function
     * @param {String} Action which is used in framework right now.
     * @param {String} Used profile name.
     * @return nothing
     *      This function open the extended split dialog after clicking on "spit" button in AgentTicketZoom.
     */

    TargetNS.OpenSplitSelection = function (DataHref) {

        // extract the parameters from the DataHref string
        var DataHrefArray = DataHref.split(';'),
            TicketIDArray = DataHrefArray[1].split('='),
            ArticleIDArray = DataHrefArray[2].split('='),
            LinkTicketIDArray = DataHrefArray[3].split('='),
            Data = {
                Action: 'AgentSplitSelection',
                TicketID: TicketIDArray[1],
                ArticleID: ArticleIDArray[1],
                LinkTicketID: LinkTicketIDArray[1]
            };

        // Show waiting dialog.
        Core.UI.Dialog.ShowWaitingDialog(Core.Config.Get('LoadingMsg'), Core.Config.Get('LoadingMsg'));

        // Modernize fields
        Core.UI.InputFields.Activate($('#SplitSelection'));

        Core.AJAX.FunctionCall(
            Core.Config.Get('CGIHandle'),
            Data,
            function (HTML) {
                var URL;

                // if the waiting dialog was cancelled, do not show the search
                //  dialog as well
                if (!$('.Dialog:visible').length) {
                    return;
                }

                // open the modal dialog
                Core.UI.Dialog.ShowContentDialog(HTML, Core.Language.Translate("Split"), '20%', 'Center', true);

                // show or hide the process selection
                $('#SplitSelection').unbind('change.SplitSelection').bind('change.SplitSelection', function() {

                    if ($('#SplitSelection').val() == 'ProcessTicket') {
                        $('#ProcessSelectionLabel').fadeIn();
                        $('#ProcessSelection').fadeIn();

                        // Modernize fields
                        Core.UI.InputFields.Activate();
                    }
                    else {
                        $('#ProcessSelectionLabel').fadeOut();
                        $('#ProcessSelection').fadeOut();
                    }
                });


                // check if it is needed to submit the process id as an additional parameter
                $('#SplitSubmit').off('click').on('click', function() {

                    // only add the parameter, if we split into a process ticket
                    if ($('#SplitSelection').val() == 'ProcessTicket') {

                        // append a hidden field to the form with the selected process id
                        $('<input/>')
                            .attr('type', 'hidden')
                            .attr('name', 'ProcessEntityID')
                            .attr('value', $('#ProcessEntityID').val())
                            .appendTo($('#AgentSplitSelection'));
                    }

                    if(Core.UI.Popup !== undefined && Core.UI.Popup.CurrentIsPopupWindow()) {
                        URL = Core.Config.Get('Baselink') + $('#AgentSplitSelection').serialize();
                        Core.UI.Popup.ExecuteInParentWindow(function(WindowObject) {
                            WindowObject.Core.UI.Popup.FirePopupEvent('URL', {
                                URL: URL
                            });
                        });
                        Core.UI.Popup.ClosePopup();
                    }
                    else {
                        $('#AgentSplitSelection').submit();
                    }
                });

            }, 'html'
        );
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.TicketSplit || {}));
