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
 * @namespace Core.Agent.TicketHistory
 * @memberof Core.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains the TicketHistory functions.
 */
Core.Agent.TicketHistory = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.TicketHistory
     * @function
     * @description
     *      This function initializes the functionality for the TicketHistory screen.
     */
    TargetNS.Init = function () {
        var $FilterHistory = $('#FilterHistory');

        // bind click event on ZoomView link
        $('a.LinkZoomView').on('click', function () {
            var that = this;
            Core.UI.Popup.ExecuteInParentWindow(function(WindowObject) {
                WindowObject.Core.UI.Popup.FirePopupEvent('URL', { URL: $(that).attr('href')});
            });
            Core.UI.Popup.ClosePopup();
        });

        $('#ExpandCollapseAll').off('click').on('click', function() {
            if ($(this).hasClass('Collapsed')) {
                $('.WidgetSimple:not(.HistoryActions)').removeClass('Collapsed').addClass('Expanded');
                $(this).removeClass('Collapsed');
            }
            else {
                $('.WidgetSimple:not(.HistoryActions)').removeClass('Expanded').addClass('Collapsed');
                $(this).addClass('Collapsed');
            }
            return false;
        });

        Core.UI.Table.InitTableFilter($FilterHistory, $('.DataTable'), undefined, true);

        // Focus filter
        $FilterHistory.trigger('keydown.FilterInput').focus();
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.TicketHistory || {}));
