// --
// Core.Agent.TicketZoom.js - provides the special module functions for TicketZoom
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.Agent.TicketZoom.js,v 1.1 2010-07-13 09:46:41 mg Exp $
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
    };

    return TargetNS;
}(Core.Agent.TicketZoom || {}));