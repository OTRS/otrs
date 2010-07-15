// --
// Core.Agent.TicketZoom.js - provides the special module functions for TicketZoom
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.Agent.TicketZoom.js,v 1.4 2010-07-15 14:21:19 mn Exp $
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
 * @exports TargetNS as Core.Agent.TicketZoom
 * @description
 *      This namespace contains the special module functions for TicketZoom.
 */
Core.Agent.TicketZoom = (function (TargetNS) {
    /**
     * @function
     * @param {jQueryObject} $Iframe The iframe which should be auto-heighted
     * @return nothing
     *      This function initializes the special module functions
     */
    TargetNS.IframeAutoHeight = function ($Iframe) {
        if (isJQueryObject($Iframe)) {
            var NewHeight = $Iframe.get(0).contentWindow.document.body.scrollHeight;
            if (!NewHeight || isNaN(NewHeight)) {
                NewHeight = Core.Config.Get('Ticket::Frontend::HTMLArticleHeightDefault');
            }
            else {
                if (NewHeight > Core.Config.Get('Ticket::Frontend::HTMLArticleHeightMax')) {
                    NewHeight = Core.Config.Get('Ticket::Frontend::HTMLArticleHeightMax');
                }
            }
            $Iframe.height(NewHeight + 'px');
        }
    };

    /**
     * @function
     * @return nothing
     *      This function initializes the special module functions
     */
    TargetNS.Init = function () {
        var $THead = $('#FixedTable thead'),
            $TBody = $('#FixedTable tbody');

        Core.UI.Resizable.Init($("#ArticleTableBody"));
        Core.UI.InitTableHead($THead, $TBody);

        $(window).resize(function () {
            Core.UI.AdjustTableHead($THead, $TBody);
        });

        Core.UI.Dialog.RegisterAttachmentDialog($('.TableSmall tbody td a.Attachment'));

        Core.UI.Table.Sort.Init($('#FixedTable'));
    };

    return TargetNS;
}(Core.Agent.TicketZoom || {}));