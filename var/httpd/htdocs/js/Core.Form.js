// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var Core = Core || {};

/**
 * @namespace Core.Form
 * @memberof Core
 * @author OTRS AG
 * @description
 *      This namespace contains all form functions.
 */
Core.Form = (function (TargetNS) {

    var FormModified = false;

    /*
     * check dependencies first
     */
    if (!Core.Debug.CheckDependency('Core.Form', 'Core.Data', 'Core.Data')) {
        return false;
    }

    /*
     * Find checked rw inputs and disable their row, and add class 'Disabled'.
     */
    $('input[type="checkbox"][name="rw"]').each(function () {
        if($(this).attr('checked') === 'checked'){
            $(this).parent().siblings().children().prop('checked', true).prop('disabled', true);
            $(this).addClass('Disabled');
        }
    });

    /*
     * Disable top row if all rw elements are checked.
     */
    if($('input[type="checkbox"][name="rw"]').length !== 0 &&
        $('input[type="checkbox"][name="rw"]').not('#SelectAllrw').filter(':checked').length ===
        $('input[type="checkbox"][name="rw"]').not('#SelectAllrw').length){
        $('table th input:not([name="rw"]:visible)').prop('disabled', true);
        $('#SelectAllrw').addClass('Disabled');
    }

    /**
    * @name Init
    * @memberof Core.Form
    * @function
    * @description
    *      This function initializes module functionality.
    */
    TargetNS.Init = function () {

        $("form input, select, textarea").on('change', FormModifiedSet);
    }

    /**
     * @name IsFormModified
     * @memberof Core.Form
     * @function
     * @returns {boolean} True if there was modification.
     * @description
     *      Checks if any element in any form on the screen has been modified.
     */
    TargetNS.IsFormModified = function () {
        return FormModified;
    }

    /**
     * @name DisableForm
     * @memberof Core.Form
     * @function
     * @param {jQueryObject} $Form - All elements of this form will be disabled.
     * @description
     *      This function disables all elements of the given form. If no form given, it disables all form elements on the site.
     */
    TargetNS.DisableForm = function ($Form) {
        // If no form is given, disable all form elements on the complete site
        if (!isJQueryObject($Form)) {
            $Form = $('body');
        }

        // save action data to the given element
        if (!$Form.hasClass('AlreadyDisabled')) {
            $.each($Form.find("input:not([type='hidden']), textarea, select, button"), function () {
                var ReadonlyValue = $(this).attr('readonly'),
                    TagnameValue = $(this).prop('tagName'),
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

            Core.App.Publish('Event.Form.DisableForm', [$Form]);
        }

    };

    /**
     * @name EnableForm
     * @memberof Core.Form
     * @function
     * @param {jQueryObject} $Form - All elements of this form will be enabled.
     * @description
     *      This function enables all elements of the given form. If no form given, it enables all form elements on the site.
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

        $.each($Form.find("input:not([type='hidden']), textarea, select, button"), function () {
            var TagnameValue = $(this).prop('tagName'),
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

        Core.App.Publish('Event.Form.EnableForm', [$Form]);
    };

    /**
     * @name SelectAllCheckboxes
     * @memberof Core.Form
     * @function
     * @param {jQueryObject} $ClickedBox - The clicked checkbox in the DOM.
     * @param {jQueryObject} $SelectAllCheckbox - The object with the SelectAll checkbox.
     * @description
     *      This function selects or deselects all checkboxes given by the ElementName.
     */
    TargetNS.SelectAllCheckboxes = function ($ClickedBox, $SelectAllCheckbox) {
        var ElementName, SelectAllID, $Elements,
            Status, CountCheckboxes, CountSelectedCheckboxes,RWMasterSwitch, RowInputs, HeadElements, CheckAll;

        if (isJQueryObject($ClickedBox, $SelectAllCheckbox)) {
            ElementName = $ClickedBox.attr('name');
            SelectAllID = $SelectAllCheckbox.attr('id');
            $Elements = $('input[type="checkbox"][name="' + Core.App.EscapeSelector(ElementName) + '"]').filter('[id!="' + Core.App.EscapeSelector(SelectAllID) + '"]:visible');
            Status = $ClickedBox.prop('checked');
            RWMasterSwitch = $('#SelectAllrw');
            HeadElements = $('table th input:not([name="rw"]:visible)');
            CheckAll = $('input[type="checkbox"]:visible');

            if(ElementName === 'rw'){

                if($ClickedBox.attr('id') === 'SelectAllrw'){

                    if(RWMasterSwitch.hasClass('Disabled')){
                        CheckAll.prop('disabled', false);
                        RWMasterSwitch.removeClass('Disabled');
                        $Elements.prop('checked', false).removeClass('Disabled');
                        return;
                    } else {
                        CheckAll.prop('checked', true);
                        $('input[type="checkbox"]:visible:not([name="rw"])').not(RWMasterSwitch).prop('disabled', true);
                        $Elements.addClass('Disabled');
                        RWMasterSwitch.addClass('Disabled');
                        return;
                    }

                } else {
                    RWMasterSwitch.removeClass('Disabled');
                    HeadElements.prop('disabled', false);

                    if($ClickedBox.hasClass('Disabled')){
                        $ClickedBox.parent().siblings().children().prop('disabled', false);
                        $ClickedBox.removeClass('Disabled');
                    }else{
                        RowInputs = $ClickedBox.parent().siblings().children('input');
                        RowInputs.each(function(){
                            if(!$(this)[0].checked){
                                $(this).trigger('click');
                            }
                            $(this).prop('checked', true).prop('disabled', true);
                        })
                        $ClickedBox.addClass('Disabled');
                    }
                }
            }

            if ($ClickedBox.attr('id') && $ClickedBox.attr('id') === SelectAllID) {

                // If $Elements are disabled don't remove check.
                if (!$Elements.filter(':enabled').length) {
                    $ClickedBox.prop('checked', true);
                    return;
                }
                $Elements.not(":disabled").prop('checked', Status).triggerHandler('click');
            }
            else {
                CountCheckboxes = $Elements.length;
                CountSelectedCheckboxes = $Elements.filter(':checked').length;
                if (CountCheckboxes === CountSelectedCheckboxes) {
                    $SelectAllCheckbox.prop('checked', true);
                    if(ElementName === 'rw'){
                        CheckAll.prop('checked', true).not(RWMasterSwitch);
                        RWMasterSwitch.addClass('Disabled');
                        HeadElements.prop('disabled', true);
                    }
                }
                else {
                    $SelectAllCheckbox.prop('checked', false);
                }
            }
        }
    };

    /**
     * @name InitSelectAllCheckboxes
     * @memberof Core.Form
     * @function
     * @param {jQueryObject} $Checkboxes - The jquery object with all dependent checkboxes.
     * @param {jQueryObject} $SelectAllCheckbox - The object with the SelectAll checkbox.
     * @description
     *      This function marks the "SelectAll checkbox" as checked if all depending checkboxes are already marked checked.
     *      Adds PubSub event to control handling of checkboxes, if a filter is used.
     */
    TargetNS.InitSelectAllCheckboxes = function ($Checkboxes, $SelectAllCheckbox) {
        if (isJQueryObject($Checkboxes, $SelectAllCheckbox)) {
            // Mark SelectAll checkbox if all depending checkboxes are already marked on initialization
            if ($Checkboxes.filter(':checked').length && ($Checkboxes.filter('[id!="' + Core.App.EscapeSelector($SelectAllCheckbox.attr('id')) + '"]').length === $Checkboxes.filter(':checked').length)) {
                $SelectAllCheckbox.prop('checked', true);
            }

            // Adjust  checkbox selection, if filter is used/changed
            Core.App.Subscribe('Event.UI.Table.InitTableFilter.Change', function ($FilterInput, $Container) {

                var CountCheckboxesVisible = $Checkboxes.filter('[id!="' + Core.App.EscapeSelector($SelectAllCheckbox.attr('id')) + '"]:visible');

                // Only continue, if the filter event is associated with the container we are working in
                if (!$.contains($Container[0], $SelectAllCheckbox[0])) {
                    return;
                }

                if (CountCheckboxesVisible.length && (CountCheckboxesVisible.filter(':checked').length === CountCheckboxesVisible.length)) {
                    $SelectAllCheckbox.prop('checked', true);
                }
                else {
                    $SelectAllCheckbox.prop('checked', false);
                }
            });
        }
    };

    function FormModifiedSet() {
        FormModified = true;

        // Once there was any modification, do not check it any more.
        $("form input, select, textarea").off('change', FormModified);
    }

    /**
     * This makes all forms submittable by using Ctrl+Enter inside textareas.
     * On macOS you can use Command+Enter instead.
     * Does NOT work if Frontend::RichText is enabled!
     */
    $('body').on('keydown', 'textarea', function (Event) {
        if ((Event.ctrlKey || Event.metaKey) && Event.keyCode == 13) {
            // We need to click() instead of submit(), since click() has
            // a few useful event handlers tied to it, like validation.
            $(this.form).find(':submit').first().click();
        }
    });

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Form || {}));
