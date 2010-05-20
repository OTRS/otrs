// --
// OTRS.Agent.TicketZoom.js - provides the special module functions for TicketZoom
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.Agent.App.TicketZoom.js,v 1.2 2010-05-20 11:13:14 mg Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};
OTRS.Agent = OTRS.Agent || {};
OTRS.Agent.App = OTRS.Agent.App || {};

/**
 * @namespace
 * @exports TargetNS as OTRS.Agent.App.Ticketzoom
 * @description
 *      This namespace contains the special module functions for TicketZoom.
 */
OTRS.Agent.App.TicketZoom = (function (TargetNS) {
    /**
     * @function
     * @return nothing
     *      This function initializes the special module functions
     */
    TargetNS.Init = function () {
        OTRS.UI.Resizable.Init(".ArticleTableBody");
        OTRS.UI.AdjustTableHead($('.ActionRow table thead'), $('.ArticleTableBody table tbody'));

        $(window).resize(function () {
            OTRS.UI.AdjustTableHead($('.ActionRow table thead'), $('.ArticleTableBody table tbody'));
        });

        OTRS.UI.Dialog.RegisterAttachmentDialog($('.TableSmall tbody td a.Attachment'));
    };

    return TargetNS;
}(OTRS.Agent.App.TicketZoom || {}));