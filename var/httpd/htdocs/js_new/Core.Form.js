// --
// Core.Form.js - provides functions for form handling
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.Form.js,v 1.2 2010-06-07 11:46:43 mg Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};

/**
 * @namespace
 * @exports TargetNS as Core.Form
 * @description
 *      This namespace contains all form functions.
 */
Core.Form = (function (TargetNS) {
    /**
     * @function
     * @description
     *      This function initializes the wrap attribute
     *      for use with textarea elements. It is not inside the HTML because
     *      these attributes are not part of the XHTML standard.
     * @return nothing
     */
    TargetNS.Init = function () {
        /* set wrap attribute to physical for browsers that need it */
        $('.Wrap_physical')
            .attr('wrap', 'physical');
        /* set wrap attribute to hard for browsers that need it */
        $('.Wrap_hard')
            .attr('wrap', 'hard');
    };

    /**
     * @function
     * @param {jQueryObject} $Form All elements of this form will be disabled
     * @description
     *      This function disables all elements of the given form. If no form given, it disables all form elements on the site.
     * @return nothing
     */
    TargetNS.DisableForm = function ($Form) {
        // If no form is given, disable all form elements on the complete site
        if (!isJQueryObject($Form)) {
            $Form = $('body');
        }

        $Form
            .find("input:not([type='hidden']), textarea, select")
            .attr('readonly', 'readonly')
            // trigger custom "readonly" event for Core.UI.IE7Fixes
            .trigger('readonly')
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
        if (!isJQueryObject($Form)) {
            $Form = $('body');
        }

        $Form
            .find("input:not([type=hidden]), textarea, select")
            .removeAttr('readonly')
            // trigger custom "readonly" event for Core.UI.IE7Fixes
            .trigger('readonly')
            .end()
            .find('button')
            .removeAttr('disabled');
    };

    /**
     * @function
     * @description
     *      This function selects or deselects all checkboxes given by the ElementName.
     * @param {jQueryObject} $ClickedBox The clicked checkbox in the DOM
     * @param {jQueryObject} $SelectAllCheckbox The object with the SelectAll checkbox
     * @return nothing
     */
    TargetNS.SelectAllCheckboxes = function ($ClickedBox, $SelectAllCheckbox) {
        if (isJQueryObject($ClickedBox, $SelectAllCheckbox)) {
            var ElementName = $ClickedBox.attr('name'),
                SelectAllID = $SelectAllCheckbox.attr('id'),
                $Elements = $('input:checkbox[name=' + ElementName + ']').filter('[id!=' + SelectAllID + ']'),
                Status = $ClickedBox.attr('checked'),
                CountCheckboxes,
                CountSelectedCheckboxes;
            if ($ClickedBox.attr('id') && $ClickedBox.attr('id') === SelectAllID) {
                $Elements.attr('checked', Status).triggerHandler('click');
            }
            else {
                CountCheckboxes = $Elements.length;
                CountSelectedCheckboxes = $Elements.filter(':checked').length;
                if (CountCheckboxes === CountSelectedCheckboxes) {
                    $SelectAllCheckbox.attr('checked', 'checked');
                }
                else {
                    $SelectAllCheckbox.removeAttr('checked');
                }
            }
        }
    };

    /**
     * @function
     * @description
     *      This function marks the "SelectAll checkbox" as checked if all depending checkboxes are already marked checked.
     * @param {jQueryObject} $Checkboxes The jquery object with all dependent checkboxes
     * @param {jQueryObject} $SelectAllCheckbox The object with the SelectAll checkbox
     * @return nothing
     */
    TargetNS.InitSelectAllCheckboxes = function ($Checkboxes, $SelectAllCheckbox) {
        if (isJQueryObject($Checkboxes, $SelectAllCheckbox)) {
            if ($Checkboxes.length === $Checkboxes.filter(':checked').length) {
                $SelectAllCheckbox.attr('checked', 'checked');
            }
        }
    };

    return TargetNS;
}(Core.Form || {}));