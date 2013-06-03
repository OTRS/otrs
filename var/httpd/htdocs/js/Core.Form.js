// --
// Core.Form.js - provides functions for form handling
// Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
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

    /*
     * check dependencies first
     */
    if (!Core.Debug.CheckDependency('Core.Form', 'Core.Data', 'Core.Data')) {
        return;
    }

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

        // save action data to the given element
        if (!$Form.hasClass('AlreadyDisabled')) {
            $.each($Form.find("input:not([type='hidden']), textarea, select, button"), function (key, value) {
                var ReadonlyValue = $(this).attr('readonly'),
                    TagnameValue  = $(this).prop('tagName'),
                    DisabledValue = $(this).attr('disabled');

                if (TagnameValue === 'BUTTON') {
                    Core.Data.Set($(this), 'OldDisabledStatus', DisabledValue);
                }
                else {
                    Core.Data.Set($(this), 'OldReadonlyStatus', ReadonlyValue);
                }
            });

            $Form
                .find("input:not([type='hidden']), textarea, select")
                .attr('readonly', 'readonly')
                .end()
                .find('button')
                .attr('disabled', 'disabled');

            // Add a speaking class to the form on DisableForm
            $Form.addClass('AlreadyDisabled');
        }

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
            .end()
            .find('button')
            .removeAttr('disabled');

        $.each($Form.find("input:not([type='hidden']), textarea, select, button"), function (key, value) {
            var TagnameValue  = $(this).prop('tagName'),
                ReadonlyValue = Core.Data.Get($(this), 'OldReadonlyStatus'),
                DisabledValue = Core.Data.Get($(this), 'OldDisabledStatus');

            if (TagnameValue === 'BUTTON') {
                if (DisabledValue === 'disabled') {
                    $(this).attr('disabled', 'disabled');
                }
            }
            else {
                if (ReadonlyValue === 'readonly') {
                    $(this).attr('readonly', 'readonly');
                }
            }
        });

        // Remove the speaking class to the form on DisableForm
        $Form.removeClass('AlreadyDisabled');
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
                Status = $ClickedBox.prop('checked'),
                CountCheckboxes,
                CountSelectedCheckboxes;
            if ($ClickedBox.attr('id') && $ClickedBox.attr('id') === SelectAllID) {
                $Elements.prop('checked', Status).triggerHandler('click');
            }
            else {
                CountCheckboxes = $Elements.length;
                CountSelectedCheckboxes = $Elements.filter(':checked').length;
                if (CountCheckboxes === CountSelectedCheckboxes) {
                    $SelectAllCheckbox.prop('checked', true);
                }
                else {
                    $SelectAllCheckbox.prop('checked', false);
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
            if ($Checkboxes.filter('[id!=' + $SelectAllCheckbox.attr('id') + ']').length === $Checkboxes.filter(':checked').length) {
                $SelectAllCheckbox.prop('checked', true);
            }
        }
    };

    return TargetNS;
}(Core.Form || {}));
