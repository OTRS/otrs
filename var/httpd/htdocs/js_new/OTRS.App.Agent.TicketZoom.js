// --
// OTRS.Agent.TicketZoom.js - provides the special module functions for TicketZoom
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.App.Agent.TicketZoom.js,v 1.1 2010-04-19 16:36:29 mg Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};
OTRS.App = OTRS.App || {};
OTRS.App.Agent = OTRS.App.Agent || {};

/**
 * @namespace
 * @exports TargetNS as OTRS.Debug
 * @description
 *      This namespace contains the special module functions for TicketZoom.
 */
OTRS.App.Agent.TicketZoom = (function (TargetNS) {
    /**
     * @function
     * @return nothing
     *      This function initializes the special module functions
     */
    TargetNS.Init = function () {
        OTRS.UI.Resizable.Init(".ArticleTableBody");
        OTRS.UI.AdjustTableHead($('.ActionRow table thead'), $('.ArticleTableBody table tbody'));

        $(window).resize(function() {
            OTRS.UI.AdjustTableHead($('.ActionRow table thead'), $('.ArticleTableBody table tbody'));
        });

        OTRS.UI.Dialog.RegisterAttachmentDialog($('.TableSmall tbody td a.Attachment'));
    };

    return TargetNS;
}(OTRS.Agent.TicketZoom || {}));