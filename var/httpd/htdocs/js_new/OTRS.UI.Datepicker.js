// --
// OTRS.UI.Datepicker.js - Datepicker
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.UI.Datepicker.js,v 1.3 2010-04-16 21:48:16 mn Exp $
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
 *      This namespace contains the datepicker functions
 */
OTRS.UI.Datepicker = (function (Namespace) {
    /**
     * @function
     * @description
     *      This function initializes the datepicker on the defined elements.
     * @param {String} Selector The jQuery selector with the elements, which get the datepicker.
     * @param {Object} Options An optional option hash.
     * @return nothing
     */
    Namespace.InitDatepicker = function (Selector, Options) {
        if (!$(Selector).length) {
            return;
        }

        // Define standard options hash
        Options = Options || {
            beforeShowDay: function (Date) {
                if (Date.getYear() === 110 && Date.getMonth() === 9 && Date.getDate() === 27) {
                    return [true, 'Highlight', 'Birthday of Martin Edenhofer'];
                }
                else {
                    return [true, ''];
                }
            },
            showOn: 'both'
        };

        $(Selector).datepicker(Options);

        // do not show the datepicker container div.
        $('#ui-datepicker-div').hide();
    };

    return Namespace;
}(OTRS.UI.Datepicker || {}));