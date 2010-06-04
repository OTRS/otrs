// --
// Core.UI.Datepicker.js - Datepicker
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.UI.Datepicker.js,v 1.1 2010-06-04 11:19:31 mn Exp $
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
 * @exports TargetNS as Core.Datepicker
 * @description
 *      This namespace contains the datepicker functions
 */
Core.UI.Datepicker = (function (TargetNS) {
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
}(Core.UI.Datepicker || {}));