// --
// Core.UI.Resizable.js - Resizable
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.UI.Resizable.js,v 1.2 2010-08-11 15:23:23 martin Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.UI = Core.UI || {};

/**
 * @namespace
 * @exports TargetNS as Core.UI.Resizable
 * @description
 *      Contains the code for resizable elements.
 */
Core.UI.Resizable = (function (TargetNS) {
    /**
     * @function
     * @description
     *      This function initializes the resizability of the given element
     * @param {jQueryObject} $Element jQuery object of the element, which should be resizable
     * @param {jQueryObject} ScrollerHeight The default height of the resizable object
     * @param {jQueryObject} Callback The callback if resizable has changed
     * @return nothing
     */
    TargetNS.Init = function ($Element, ScrollerHeight, Callback) {
        if (!ScrollerHeight) {
            ScrollerHeight = 140;
        }

        if (isJQueryObject($Element) && $Element.length) {
            if (($Element.find('table').height() + 10) < ScrollerHeight) {
                $Element.find('.Scroller').height($Element.find('table').height() + 10);
            }
            else {
                $Element.find('.Scroller').height(ScrollerHeight);
            }

            $Element.resizable({
                handles: {
                    s: $Element.find('.Handle a')
                },
                minHeight: 60,
                maxHeight: $Element.find('table').height() + 40,
                resize: function    (event, ui) {
                    var Height, Width;
                    Height = ui.size.height - 38;
                    Width = ui.size.width;
                    $Element.find('div.Scroller').height(Height + 'px').width(Width + 'px');

                    // execute callback
                    if ($.isFunction(Callback)) {
                        Callback(event, ui, Height, Width);
                    }
                    else {
                        Core.Exception.Throw('Invalid callback method: ' + Callback.toString(), 'CommunicationError');
                    }
                }
            });
        }
    };

    return TargetNS;
}(Core.UI.Resizable || {}));
