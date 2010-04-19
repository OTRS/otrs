// --
// OTRS.Forms.js - provides functions for form handling
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.Forms.js,v 1.3 2010-04-19 16:36:29 mg Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};

/**
 * @namespace
 * @exports TargetNS as OTRS.Forms
 * @description
 *      This namespace contains all form functions.
 */
OTRS.Forms = (function (TargetNS) {
    /**
     * @function
     * @param {jQueryObject} $Form All elements of this form will be disabled
     * @description
     *      This function disables all elements of the given form. If no form given, it disables all form elements on the site.
     * @return nothing
     */
    TargetNS.DisableForm = function ($Form) {
        // If no form is given, disable all form elements on the complete site
        if (typeof $Form === 'undefined') {
            $Form = $('body');
        }

        $Form
            .find("input:not([type='hidden']), textarea, select")
            .attr('readonly', 'readonly')
            .end()
            .find('button')
            .attr('disabled', 'disabled');
    };

    /**
     * @function
     * @param {jQueryObject} $Form All elements of this form will be enabled
     * @description
     *      This function enables all elements of the given form. If no form given, it enables all form elements on the site.
     * @return nothing
     */
    TargetNS.EnableForm = function ($Form) {
        // If no form is given, enable all form elements on the complete site
        if (typeof $Form === 'undefined') {
            $Form = $('body');
        }

        $Form
            .find("input:not([type=hidden]), textarea, select")
            .removeAttr('readonly')
            .end()
            .find('button')
            .removeAttr('disabled');
    };
    return TargetNS;
}(OTRS.Forms || {}));