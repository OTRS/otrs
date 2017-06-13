// --
// Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};
Core.Agent.LinkObject = Core.Agent.LinkObject || {};

/**
 * @namespace Core.Agent.LinkObject.SearchForm
 * @memberof Core.Agent.LinkObject
 * @author OTRS AG
 * @description
 *      This namespace contains search form functions for LinkObject screen.
 */
Core.Agent.LinkObject.SearchForm = (function (TargetNS) {
    /**
     * @name Init
     * @memberof Core.Agent.LinkObject.SearchForm
     * @function
     * @description
     *      This function initializes the LinkObject search form.
     */
    TargetNS.Init = function () {

        var SearchValueFlag,
            TemporaryLink = Core.Config.Get('TemporaryLink'),
            Status;

        if (typeof TemporaryLink !== 'undefined' && parseInt(TemporaryLink, 10) === 1) {
            $('#LinkAddCloseLink, #LinkDeleteCloseLink').on('click', function () {
                Core.UI.Popup.ClosePopup();
                return false;
            });
        }

        $('#TargetIdentifier').on('change', function () {
            $('#SubmitSelect').addClass('gotclicked');
            $(this).closest('form').submit();
        });

        // Two submits in this form
        // if SubmitSelect or AddLinks button was clicked,
        // add "gotclicked" class to this button
        $('#SubmitSelect, #AddLinks').on('click.Submit', function () {
           $('#SubmitSelect').addClass('gotclicked');
        });

        $('#LinkSearchForm').submit(function () {

            // If SubmitSelect button was clicked,
            // "gotclicked" was added as class to the button
            // remove the class and do the search
            if ($('#SubmitSelect').hasClass('gotclicked')) {
                $('#SubmitSelect').removeClass('gotclicked');
                return true;
            }

            SearchValueFlag = false;
            $('#LinkSearchForm input, #LinkSearchForm select').each(function () {
                if ($(this).attr('name') && $(this).attr('name').match(/^SEARCH::/)) {
                    if ($(this).val() && $(this).val().length) {
                        SearchValueFlag = true;
                    }
                }
            });

            if (!SearchValueFlag) {
               alert(Core.Language.Translate("Please enter at least one search value or * to find anything."));
               return false;
            }
            else {
                Core.UI.Dialog.ShowWaitingDialog(undefined, Core.Language.Translate("Searching for linkable objects. This may take a while..."));
            }
        });

        // Make sure that (only!) from a popup window, links are always opened in a new tab of the main window.
        if (Core.UI.Popup.CurrentIsPopupWindow()) {
            $('a.LinkObjectLink').attr('target', '_blank');
        }

        // event for 'Select All' checkbox
        $('.SelectAll').on('click', function () {
            Status = $(this).prop('checked');
            $(this).closest('.WidgetSimple').find('table input[type=checkbox]').prop('checked', Status);
        });

        // event for checkboxes
        $('input[type="checkbox"][name="LinkTargetKeys"]').on('click', function () {
            Core.Form.SelectAllCheckboxes($(this), $(this).closest('.WidgetSimple').find('.SelectAll'));
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.LinkObject.SearchForm || {}));
