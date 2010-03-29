// --
// OTRS.UI.Datepicker.js - Datepicker
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.UI.Datepicker.js,v 1.2 2010-03-29 09:58:14 mn Exp $
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
        if (!$(Selector).length) return;

        // Define standard options hash
        Options = Options || {
            beforeShowDay: function(date) {
                if (date.getYear() === 110 && date.getMonth() === 9 && date.getDate() === 27) {
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