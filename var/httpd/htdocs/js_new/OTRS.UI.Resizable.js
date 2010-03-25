// --
// OTRS.UI.Resizable.js - Resizable
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.UI.Resizable.js,v 1.1 2010-03-25 15:04:37 mg Exp $
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
 *      Contains the code for resizable elements.
 */
OTRS.UI.Resizable = (function () {

   return {

        /**
         * @function
         * @description
         *      This function initializes the resizability of the given element
         * @param {String} Selector jQuery selector of the element, which should be resizable
         * @return nothing
         */
        Init: function (Selector) {
            var $Selector = $(Selector);
            if ($Selector.length) {
                $Selector.resizable({
                    handles: {
                        s: $Selector.find('.Handle a')
                    },
                    minHeight: 50,
                    maxHeight: $Selector.find("table").height() + 10,
                    resize: function(event, ui) {
                        $Selector.find("div.Scroller").height((ui.size.height - 10) + 'px').width(ui.size.width + 'px');
                    }
                });
            }
        }
    };
}());