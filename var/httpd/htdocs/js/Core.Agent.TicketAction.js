// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};

/**
 * @namespace Core.Agent.TicketAction
 * @memberof Core.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains functions for all ticket action popups.
 */
Core.Agent.TicketAction = (function (TargetNS) {

    /**
     * @private
     * @name SerializeData
     * @memberof Core.Agent.TicketAction
     * @function
     * @returns {String} A query string based on the given hash.
     * @param {Object} Data - The data that should be serialized
     * @description
     *      Converts a given hash into a query string.
     */
    function SerializeData(Data) {
        var QueryString = '';
        $.each(Data, function (Key, Value) {
            QueryString += ';' + encodeURIComponent(Key) + '=' + encodeURIComponent(Value);
        });
        return QueryString;
    }

    /**
     * @private
     * @name OpenCustomerUserAddressBook
     * @memberof Core.Agent.TicketAction
     * @function
     * @param {String} RecipientField - The recipient field name to add the selected recipients in the correct field.
     * @param {String} RecipientFieldLabel - The recipient field label for the output in the address book screen.
     * @param {String} RecipientType - The recipient type for the diffrent screens.
     * @description
     *      Open the AgentCustomerUserAddressBook screen.
     */
    function OpenCustomerUserAddressBook(RecipientField, RecipientFieldLabel, RecipientType) {
        var CustomerUserAddressBookIFrameURL, CustomerUserAddressBookIFrame;

        CustomerUserAddressBookIFrameURL = Core.Config.Get('CGIHandle') + '?Action=AgentCustomerUserAddressBook;RecipientField=' + RecipientField + ';RecipientFieldLabel=' + RecipientFieldLabel + ';RecipientType=' + RecipientType;
        CustomerUserAddressBookIFrameURL += SerializeData(Core.App.GetSessionInformation());

        CustomerUserAddressBookIFrame = '<iframe class="TextOption CustomerUserAddressBook" src="' + CustomerUserAddressBookIFrameURL + '"></iframe>';
        Core.UI.Dialog.ShowContentDialog(CustomerUserAddressBookIFrame, '', '10px', 'Center', true);
    }

    /**
     * @private
     * @name OpenCustomerDialog
     * @memberof Core.Agent.TicketAction
     * @function
     * @description
     *      Open the CustomerDialog screen.
     */
    function OpenCustomerDialog() {
        var CustomerIFrameURL, CustomerIFrame;

        CustomerIFrameURL = Core.Config.Get('CGIHandle') + '?Action=AdminCustomerUser;Nav=None;Subject=;What=';
        CustomerIFrameURL += SerializeData(Core.App.GetSessionInformation());

        CustomerIFrame = '<iframe class="TextOption Customer" src="' + CustomerIFrameURL + '"></iframe>';
        Core.UI.Dialog.ShowContentDialog(CustomerIFrame, '', '10px', 'Center', true);
    }

    /**
     * @private
     * @name OpenCustomerIDSelection
     * @memberof Core.Agent.TicketAction
     * @function
     * @description
     *      Open the CustomerIDSelectionDialog screen.
     */
    function OpenCustomerIDSelection() {
        var Data = {
            Action: 'AgentCustomerSearch',
            Subaction: 'AssignedCustomerIDs',
            CustomerUserID: $('#SelectedCustomerUser').val(),
        };

        $('#SelectionCustomerIDAssigned').empty();

        Core.AJAX.FunctionCall(Core.Config.Get('Baselink'), Data, function (Response) {
            $.each(Response, function(Index, CustomerID) {
                var CustomerIDOption = new Option(CustomerID, CustomerID);

                // Overwrite option text, because of wrong html quoting of text content.
                // (This is needed for IE.)
                CustomerIDOption.innerHTML = CustomerID;
                $('#SelectionCustomerIDAssigned').append(CustomerIDOption);
            });

            if (!$('#SelectionCustomerIDAssigned > option').length) {
                $('#TemplateSelectionCustomerID fieldset:last').addClass('Hidden');
            }
            else {
                $('#TemplateSelectionCustomerID fieldset:last').removeClass('Hidden');
            }

            Core.UI.Dialog.ShowContentDialog($('#TemplateSelectionCustomerID'), Core.Language.Translate('Select a customer ID to assign to this ticket'), '10px', 'Center', true);

            Core.Agent.CustomerSearch.InitSimple($('#SelectionCustomerIDAll'));

            $('#SelectionCustomerIDAssigned').val($('#CustomerID').val()).trigger('redraw.InputField').trigger('change');

            $('#SelectionCustomerIDAll').on('select.Autocomplete', function() {
                CloseCustomerIDSelection($(this).val());
            });

            $('#SelectionCustomerIDAssigned').on('change', function() {
                CloseCustomerIDSelection($(this).val());
            });
        });
    }

    /**
     * @private
     * @name CloseCustomerIDSelection
     * @memberof Core.Agent.TicketAction
     * @function
     * @param {String} CustomerID - The selected customer ID value.
     * @description
     *      Close the customer ID selection dialog.
     */
    function CloseCustomerIDSelection(CustomerID) {
        $('#CustomerID').val(CustomerID);
        $('#ShowCustomerID').html(CustomerID);

        Core.UI.Dialog.CloseDialog($('.Dialog'));
    }

    /**
     * @private
     * @name MarkPrimaryCustomer
     * @memberof Core.Agent.TicketAction
     * @function
     * @description
     *      Mark the primary customer.
     */
    function MarkPrimaryCustomer() {
        $('.CustomerContainer').children('div').each(function() {
            var $InputObj = $(this).find('.CustomerTicketText'),
                $RadioObj = $(this).find('.CustomerTicketRadio');

            if ($RadioObj.prop('checked')) {
                $InputObj.addClass('MainCustomer');
            }
            else {
                $InputObj.removeClass('MainCustomer');
            }
        });
    }

    /**
     * @name Init
     * @memberof Core.Agent.TicketAction
     * @function
     * @description
     *      This function initializes the ticket action popups.
     */
    TargetNS.Init = function () {

        $('.OptionCustomerUserAddressBook').on('click', function () {
            OpenCustomerUserAddressBook($(this).data('recipient-field'), $(this).data('recipient-field-label'), $(this).data('recipient-type'));
            return false;
        });

        // Register event for customer dialog
        $('#OptionCustomer').on('click', function () {
            OpenCustomerDialog();
            return false;
        });

        // Register the event for customer id selection dialog.
        $('#SelectionCustomerID').on('click', function () {
            OpenCustomerIDSelection();
            return false;
        });

        // Deactivate the fields in the template.
        Core.UI.InputFields.Deactivate($('#TemplateSelectionCustomerID'));

        // Subscribe to the reloading of the CustomerInfo box to
        // specially mark the primary customer
        MarkPrimaryCustomer();
        Core.App.Subscribe('Event.Agent.CustomerSearch.GetCustomerInfo.Callback', function() {
            MarkPrimaryCustomer();
        });

        // Prevent form submit, if To, CC or Bcc are not correctly saved yet
        // see http://bugs.otrs.org/show_bug.cgi?id=10022 for details
        $('#submitRichText').on('click', function (Event) {
            var ToCustomer = $('#ToCustomer').val() || '',
                CcCustomer = $('#CcCustomer').val() || '',
                BccCustomer = $('#BccCustomer').val() || '',
                // only for AgentTicketPhone
                FromCustomer = $('#FromCustomer').val() || '';

            if (ToCustomer.length || CcCustomer.length || BccCustomer.length || FromCustomer.length) {
                window.setTimeout(function () {
                    $('#submitRichText').trigger('click');
                }, 100);
                Event.preventDefault();
                Event.stopPropagation();
                return false;
            }
        });

        // Subscribe to ToggleWidget event to handle special behaviour in ticket action screens
        Core.App.Subscribe('Event.UI.ToggleWidget', function ($WidgetElement) {
            if ($WidgetElement.attr('id') !== 'WidgetArticle') {
                return;
            }

            // If widget is being expanded, activate checkbox to create article.
            if ($WidgetElement.hasClass('Expanded')) {
                $('#CreateArticle').prop('checked', true);
            }
        });
    };

    /**
     * @name UpdateCustomer
     * @memberof Core.Agent.TicketAction
     * @function
     * @param {String} Customer - The customer that was selected in the customer popup window.
     * @description
     *      In some screens, the customer management dialog can be used as a borrowed view
     *      (iframe in a dialog). This function is used to take over the currently selected
     *      customer into the main window, closing the dialog.
     */
    TargetNS.UpdateCustomer = function (Customer) {
        var $UpdateForm = $('form[name=compose]', parent.document);
        $UpdateForm
            .find('#ExpandCustomerName').val('2')
            .end()
            .find('#PreSelectedCustomerUser').val(Customer)
            .end()
            .submit();

        // Because we are in an iframe, we need to call the parent frames javascript function
        // with a jQuery object which is in the parent frames context
        parent.Core.UI.Dialog.CloseDialog($('.Dialog', parent.document));
    };

    /**
     * @name SelectRadioButton
     * @memberof Core.Agent.TicketAction
     * @function
     * @param {String} Value - The value attribute of the radio button to be selected.
     * @param {String} Name - The name of the radio button to be selected.
     * @description
     *      Selects a radio button by name and value.
     */
    TargetNS.SelectRadioButton = function (Value, Name) {
        $('input[type="radio"][name=' + Name + '][value=' + Value + ']').prop('checked', true);
    };

    /**
     * @name ConfirmTemplateOverwrite
     * @memberof Core.Agent.TicketAction
     * @function
     * @param {String} FieldName - The ID of the content field (textarea or RTE). ID without selector (#).
     * @param {jQueryObject} $TemplateSelect - Selector of the dropdown element for the template selection.
     * @param {Function} Callback - Callback function to execute if overwriting is confirmed.
     * @description
     *      After a template was selected, this function lets the user confirm that all already existing content
     *      in the textarea or RTE will be overwritten with the template content.
     */
    TargetNS.ConfirmTemplateOverwrite = function (FieldName, $TemplateSelect, Callback) {
        var Content = '',
            LastValue = $TemplateSelect.data('LastValue') || '';

        // Fallback for non-richtext content
        Content = $('#' + FieldName).val();

        // get RTE content
        if (typeof CKEDITOR !== 'undefined' && CKEDITOR.instances[FieldName]) {
            Content = CKEDITOR.instances[FieldName].getData();
        }

        // if content already exists let user confirm to really overwrite that content with a template
        if (
            Content.length &&
            !window.confirm(Core.Language.Translate('Setting a template will overwrite any text or attachment.') + ' ' + Core.Language.Translate('Do you really want to continue?')))
            {
                // if user cancels confirmation, reset template selection
                $TemplateSelect.val(LastValue).trigger('redraw');

        }
        else if ($.isFunction(Callback)) {
            Callback();
            $TemplateSelect.data('LastValue', $TemplateSelect.val());
        }
    }

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.TicketAction || {}));
