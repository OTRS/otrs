// --
// Core.UI.Resizable.js - Resizable
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.UI.Resizable.js,v 1.1 2010-07-13 09:46:41 mg Exp $
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
     * @return nothing
     */
    TargetNS.Init = function ($Element) {
        var ScrollerHeight = 140;

        if (isJQueryObject($Element) && $Element.length) {
            if (($Element.find("table").height() + 10) < ScrollerHeight) {
                $Element.find('.Scroller').height($Element.find("table").height() + 10);
            }

            $Element.resizable({
                handles: {
                    s: $Element.find('.Handle a')
                },
                minHeight: 60,
                maxHeight: $Element.find("table").height() + 40,
                resize: function    (event, ui) {
                    $Element.find("div.Scroller").height((ui.size.height - 38) + 'px').width(ui.size.width + 'px');
                }
            });
        }
    };

    return TargetNS;
}(Core.UI.Resizable || {}));