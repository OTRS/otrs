// --
// OTRS.UI.IE7Fixes.js - provides IE7 specific functions
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.UI.IE7Fixes.js,v 1.1 2010-03-25 15:04:37 mg Exp $
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
 *      This namespace contains IE7 specific functions for browser bugfixes
 */
OTRS.UI.IE7Fixes = (function () {
   return {
        /**
         * @function
         * @description
         *      This function implements the focus effects for IE7.
         * @param {String} FocusClass The name of the classes which will be added for focus effect.
         * @return nothing
         */
        InitIE7InputFocus: function (FocusClass) {
            // Exit function, if browser is not IE7
            if (!($.browser.msie && $.browser.version == "7.0"))
                return;

            // If hover class is not given, set it to default
            if (!FocusClass) FocusClass = "Focus";

            // Define mouse events for adding and removing hover class
            $('input[type=text], input[type=password], textarea')
                .live("focusin", function(e) {
                    $(this).addClass(FocusClass);
                })
                .live("focusout", function(e) {
                    $(this).removeClass(FocusClass);
                });
        },
        /**
         * @function
         * @description
         *      This function implements readonly field styling for IE6.
         * @param {String} ReadonlyClass The name of the class which will be added for styling readonly input fields.
         * @return nothing
         */
        InitIE7InputReadonly: function (ReadonlyClass) {
            // Exit function, if browser is not IE6
            if (!($.browser.msie && $.browser.version == "7.0"))
                return;

            // If style class is not given, set it to default
            if (!ReadonlyClass) ReadonlyClass = 'Readonly';

            // Add ReadonlyClass for readonly inputs
            $('input[type=text][readonly=true], input[type=password][readonly=true], textarea[readonly=true]')
                .addClass(ReadonlyClass);
        }

    };
}());