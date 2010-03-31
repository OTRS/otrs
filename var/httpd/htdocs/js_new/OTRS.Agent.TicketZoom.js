// --
// OTRS.Agent.TicketZoom.js - provides the special module functions for TicketZoom
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.Agent.TicketZoom.js,v 1.1 2010-03-31 08:09:46 mn Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};
OTRS.Agent = OTRS.Agent || {};

/**
 * @namespace
 * @description
 *      This namespace contains the special module functions for TicketZoom.
 */
OTRS.Agent.TicketZoom = (function (Namespace) {
    /**
     * @function
     * @return nothing
     *      This function initializes the special module functions
     */
    Namespace.Init = function () {
        OTRS.UI.Resizable.Init(".ArticleTableBody");
        OTRS.UI.AdjustTableHead($('.ActionRow table thead'), $('.ArticleTableBody table tbody'));

        $(window).resize(function() {
            OTRS.UI.AdjustTableHead($('.ActionRow table thead'), $('.ArticleTableBody table tbody'));
        });

        OTRS.UI.Dialog.RegisterAttachmentDialog($('.TableSmall tbody td span.Attachment'), 'ExampleDialogContent');
    };

    return Namespace;
}(OTRS.Agent.TicketZoom || {}));