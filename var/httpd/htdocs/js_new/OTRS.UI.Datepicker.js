// --
// OTRS.UI.Datepicker.js - Datepicker
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.UI.Datepicker.js,v 1.5 2010-05-07 13:33:29 mn Exp $
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
 * @exports TargetNS as OTRS.Datepicker
 * @description
 *      This namespace contains the datepicker functions
 */
OTRS.UI.Datepicker = (function (TargetNS) {
    /**
     * @function
     * @description
     *      This function initializes the datepicker on the defined elements.
     * @param {jQueryObject} $Element The jQuery object with the elements, which get the datepicker.
     * @param {Object} Options An optional option hash.
     * @return nothing
     */
    TargetNS.InitDatepicker = function ($Element, Options) {
        if (!isJQueryObject($Element)) {
            return false;
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

        $Element.datepicker(Options);

        // do not show the datepicker container div.
        $('#ui-datepicker-div').hide();
    };

    return TargetNS;
}(OTRS.UI.Datepicker || {}));