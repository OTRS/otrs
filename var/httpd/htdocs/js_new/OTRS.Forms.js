// --
// OTRS.Forms.js - provides functions for form handling
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.Forms.js,v 1.5 2010-04-30 09:30:09 mn Exp $
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

    /**
     * @function
     * @description
     *      This function selects or deselects all checkboxes given by the ElementName.
     * @param {DOMObject} ClickedBox The clicked checkbox in the DOM
     * @param {String} SelectAllElement The name of the SelectAll checkbox
     * @return nothing
     */
    TargetNS.SelectAllCheckboxes = function (ClickedBox, SelectAllElement) {
        var $ClickedBox = $(ClickedBox),
            ElementName = $ClickedBox.attr('name'),
            $Elements = $('input:checkbox[name=' + ElementName + ']').filter('[id!=' + SelectAllElement + ']'),
            Status = $ClickedBox.attr('checked'),
            CountCheckboxes,
            CountSelectedCheckboxes;
        if ($ClickedBox.attr('id') && $ClickedBox.attr('id') === SelectAllElement) {
            $Elements.attr('checked', Status).triggerHandler('click');
        }
        else {
            CountCheckboxes = $Elements.length;
            CountSelectedCheckboxes = $Elements.filter(':checked').length;
            if (CountCheckboxes === CountSelectedCheckboxes) {
                $('#' + SelectAllElement).attr('checked', 'checked');
            }
            else {
                $('#' + SelectAllElement).removeAttr('checked');
            }
        }
    };

    /**
     * @function
     * @description
     *      This function marks the "SelectAll checkbox" as checked if all depending checkboxes are already marked checked.
     * @param {String} CheckboxName The name attribute of the dependent checkboxes
     * @param {String} SelectAllID The ID of the SelectAll checkbox
     * @return nothing
     */
    TargetNS.InitSelectAllCheckboxes = function (CheckboxName, SelectAllID) {
        var Elements = $('table td input:checkbox[name=' + CheckboxName + ']');
        if (Elements.length === Elements.filter(':checked').length) {
            $('#' + SelectAllID).attr('checked', 'checked');
        }
    };

    return TargetNS;
}(OTRS.Forms || {}));