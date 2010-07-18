// --
// Core.Form.js - provides functions for form handling
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.Form.js,v 1.4 2010-07-18 20:58:37 cg Exp $
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
            
        // save action data to the given element        
        if (!$Form.hasClass("AlreadyDisabled")) {
            $.each($Form.find("input:not([type='hidden']), textarea, select, button"), function(key, value) { 
                var readonlyValue = $(this).attr('readonly');
                var tagnameValue  = $(this).attr('tagName');
                var disabledValue = $(this).attr('disabled');
                
                if (tagnameValue == "BUTTON") {
                    if (disabledValue == true) {
                        Core.Data.Set( $(this), 'oldDisabledStatus', 'disabled' );
                    }
                }
                else {
                    if (readonlyValue == true) {
                        Core.Data.Set( $(this), 'oldReadonlyStatus', 'readonly' );
                    }
                }
            });

        $Form
            .find("input:not([type='hidden']), textarea, select")
            .attr('readonly', 'readonly')
            // trigger custom "readonly" event for Core.UI.IE7Fixes
            .trigger('readonly')
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
            // trigger custom "readonly" event for Core.UI.IE7Fixes
            .trigger('readonly')
            .end()
            .find('button')
            .removeAttr('disabled');
            
        $.each($Form.find("input:not([type='hidden']), textarea, select, button"), function(key, value) {
            var tagnameValue  = $(this).attr('tagName');
            var readonlyValue = Core.Data.Get($(this), 'oldReadonlyStatus');
            var disabledValue = Core.Data.Get($(this), 'oldDisabledStatus');
            
            if (tagnameValue == "BUTTON") {
                if (disabledValue == 'disabled') {
                    $(this).attr('disabled', 'disabled');
                }
            }
            else {
                if (readonlyValue == 'readonly') {
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