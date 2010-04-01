// --
// OTRS.UI.Toolbar.js - provides functions for the header toolbar
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.UI.Toolbar.js,v 1.1 2010-04-01 13:13:34 mn Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};
OTRS.UI = OTRS.UI || {};

/**
 * @namespace
 * @description
 *      navigation toolbar
 */
OTRS.UI.Toolbar = (function (Namespace) {

    /**
     * @function
     * @description
     *      This function registers the click event for a toolbar widget.
     * @param {String} EventType The event type (click, change, ...)
     * @param {String} ElementID The ID of the toolbar element (normally a link) on which the event is triggered
     * @param {Function} EventFunction The function which should be executed on event (gets Parameter Event)
     */
    Namespace.RegisterEvent = function (EventType, ElementID, EventFunction) {
        var $Element = $('#' + ElementID);
        if ($Element.length && $.isFunction(EventFunction)) {
            $Element.bind(EventType, EventFunction);
        }
    }
    return Namespace;
}(OTRS.UI.Toolbar || {}));