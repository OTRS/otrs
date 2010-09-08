// --
// Core.UI.Resizable.js - Resizable
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.UI.Resizable.js,v 1.5 2010-09-08 14:00:21 mg Exp $
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

    var ScrollerMinHeight = 84,
        HandleHeight = 9,
        TableHeaderHeight = 28;
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
        ScrollerHeight = Math.max(ScrollerHeight, ScrollerMinHeight);

        if (isJQueryObject($Element) && $Element.length) {
            if (($Element.find('table').height() + HandleHeight) < ScrollerHeight) {
                $Element.find('.Scroller').height($Element.find('table').height() + HandleHeight);
            }
            else {
                $Element.find('.Scroller').height(ScrollerHeight);
            }

            $Element.resizable({
                handles: {
                    s: $Element.find('.Handle a')
                },
                minHeight: ScrollerMinHeight + HandleHeight + TableHeaderHeight,
                maxHeight: $Element.find('table').height() + HandleHeight + TableHeaderHeight,
                resize: function (Event, UI) {
                    var Height, Width;
                    Height = UI.size.height - TableHeaderHeight - HandleHeight;
                    Width = UI.size.width;
                    $Element.find('div.Scroller').height(Height + 'px').width(Width + 'px');

                    if ($.isFunction(Callback)) {
                        Callback(Event, UI, Height, Width);
                    }
                }
            });
        }
    };

    return TargetNS;
}(Core.UI.Resizable || {}));
