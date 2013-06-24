// --
// Core.UI.Resizable.js - Resizable
// Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
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

    var ScrollerMinHeight = 92,
        HandleHeight = 9;

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
        var CurrentTableHeight,
            InitScroller = true;

        // also catch NaN or undefined values for ScrollerHeight, but pass 0
        //      to Math.max in these cases, otherwise it may cause an exception
        ScrollerHeight = Math.max(ScrollerHeight || 0, ScrollerMinHeight);

        if (isJQueryObject($Element) && $Element.length) {
            CurrentTableHeight = $Element.find('table').height();

            // If the scroller is not needed (because only few elements shown in table)
            // than also do not initialize the scroller event and hide the scroller handle

            // Table is smaller than minheight
            if ((CurrentTableHeight) <= ScrollerMinHeight) {
                $Element.find('.Scroller').height(CurrentTableHeight);
                InitScroller = false;
            }
            // Table is bigger than minheight but smaller than the saved scrollerheight
            // Scroller still should be enabled
            else if ((CurrentTableHeight) < ScrollerHeight) {
                $Element.find('.Scroller').height(CurrentTableHeight);
            }
            // Table is bigger than minheight and saved height of scroller
            // Scroller still should be enabled
            else {
                $Element.find('.Scroller').height(ScrollerHeight);
            }

            if (InitScroller) {
                $Element.resizable({
                    handles: {
                        s: $Element.find('.Handle a')
                    },
                    minHeight: ScrollerMinHeight + HandleHeight,
                    maxHeight: $Element.find('table').height() + HandleHeight,
                    resize: function (Event, UI) {
                        var Height, Width;
                        Height = UI.size.height - HandleHeight;
                        Width = UI.size.width;
                        $Element.find('div.Scroller').height(Height + 'px').width(Width + 'px');

                        if ($.isFunction(Callback)) {
                            Callback(Event, UI, Height, Width);
                        }
                    }
                });
            }
            else {
                // No event initialization
                // Additionally, the scroller handle is hidden
                $('div.Handle').hide();
                $Element.find('.Scroller').css('margin-bottom', '1px');
            }
        }
    };

    return TargetNS;
}(Core.UI.Resizable || {}));
