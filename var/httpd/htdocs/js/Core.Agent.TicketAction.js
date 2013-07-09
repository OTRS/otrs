// --
// Core.Agent.TicketAction.js - provides functions for all ticket action popups
// Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};

/**
 * @namespace
 * @exports TargetNS as Core.Agent.TicketAction
 * @description
 *      This namespace contains functions for all ticket action popups.
 */
Core.Agent.TicketAction = (function (TargetNS) {

    /**
     * @function
     * @private
     * @param {Object} Data The data that should be converted
     * @return {string} query string of the data
     * @description Converts a given hash into a query string
     */
    function SerializeData(Data) {
        var QueryString = '';
        $.each(Data, function (Key, Value) {
            QueryString += ';' + encodeURIComponent(Key) + '=' + encodeURIComponent(Value);
        });
        return QueryString;
    }

    /**
     * @function
     * @private
     * @return nothing
     * @description Open the spellchecker screen
     */
    function OpenSpellChecker() {
        var SpellCheckIFrame, SpellCheckIFrameURL;
        SpellCheckIFrameURL = Core.Config.Get('CGIHandle') + '?Action=AgentSpelling;Field=RichText;Body=' + encodeURIComponent($('#RichText').val());
        SpellCheckIFrameURL += SerializeData(Core.App.GetSessionInformation());
        SpellCheckIFrame = '<iframe class="TextOption SpellCheck" src="' + SpellCheckIFrameURL + '"></iframe>';
        Core.UI.Dialog.ShowContentDialog(SpellCheckIFrame, '', '10px', 'Center', true);
    }

    /**
     * @function
     * @private
     * @return nothing
     * @description Open the AddressBook screen
     */
    function OpenAddressBook() {
        var AddressBookIFrameURL, AddressBookIFrame;
        AddressBookIFrameURL = Core.Config.Get('CGIHandle') +
            '?Action=AgentBook;ToCustomer=' + encodeURIComponent($('#CustomerAutoComplete, #ToCustomer').val()) +
            ';CcCustomer=' + encodeURIComponent($('#Cc, #CcCustomer').val()) +
            ';BccCustomer=' + encodeURIComponent($('#Bcc, #BccCustomer').val());
        AddressBookIFrameURL += SerializeData(Core.App.GetSessionInformation());
        AddressBookIFrame = '<iframe class="TextOption" src="' + AddressBookIFrameURL + '"></iframe>';
        Core.UI.Dialog.ShowContentDialog(AddressBookIFrame, '', '10px', 'Center', true);
    }

    /**
     * @function
     * @private
     * @return nothing
     * @description Open the CustomerDialog screen
     */
    function OpenCustomerDialog() {
        var CustomerIFrameURL, CustomerIFrame;

        CustomerIFrameURL = Core.Config.Get('CGIHandle') + '?Action=AdminCustomerUser;Nav=None;Subject=;What=';
        CustomerIFrameURL += SerializeData(Core.App.GetSessionInformation());

        CustomerIFrame = '<iframe class="TextOption Customer" src="' + CustomerIFrameURL + '"></iframe>';
        Core.UI.Dialog.ShowContentDialog(CustomerIFrame, '', '10px', 'Center', true);
    }

    /**
     * @function
     * @private
     * @param {Object} $Link Element link type that will receive the new email adrress in his value attribute
     * @return nothing
     * @description Open the spellchecker screen
     */
    function AddMailAddress($Link) {
        var $Element = $('#' + $Link.attr('rel')),
            NewValue = $Element.val();
        if (NewValue.length) {
            NewValue = NewValue + ', ';
        }
        NewValue = NewValue + Core.Data.Get($Link.closest('tr'), 'Email');
        $Element.val(NewValue);
    }

    /**
     * @function
     * @private
     * @description Mark the primary customer
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
     * @function
     * @description
     *      This function initializes the ticket action popups
     * @return nothing
     */
    TargetNS.Init = function () {

        // Register event for spell checker dialog
        $('#OptionSpellCheck').bind('click', function (Event) {
            OpenSpellChecker();
            return false;
        });

        // Register event for addressbook dialog
        $('#OptionAddressBook').bind('click', function (Event) {
            OpenAddressBook();
            return false;
        });

        // Register event for customer dialog
        $('#OptionCustomer').bind('click', function (Event) {
            OpenCustomerDialog();
            return false;
        });

        // Subscribe to the reloading of the CustomerInfo box to
        // specially mark the primary customer
        MarkPrimaryCustomer();
        Core.App.Subscribe('Event.Agent.CustomerSearch.GetCustomerInfo.Callback', function() {
            MarkPrimaryCustomer();
        });
    };

    /**
     * @function
     * @return nothing
     *      This function initializes the necessary stuff for address book link in TicketAction screens
     */
    TargetNS.InitAddressBook = function () {
        // Register event for copying mail address to input field
        $('#SearchResult a').bind('click', function (Event) {
            AddMailAddress($(this));
            return false;
        });

        // Register Apply button event
        $('#Apply').bind('click', function (Event) {
            // Update ticket action popup fields
            var $To, $Cc, $Bcc;

            // Because we are in an iframe, we need to call the parent frames javascript function
            // with a jQuery object which is in the parent frames context

            // check if the multi selection feature is present
            if ($('#CustomerAutoComplete', parent.document).length) {
                // no multi select (AgentTicketForward)
                $To = $('#CustomerAutoComplete', parent.document);
                $Cc = $('#Cc', parent.document);
                $Bcc = $('#Bcc', parent.document);

                $To.val($('#ToCustomer').val());
                $Cc.val($('#CcCustomer').val());
                $Bcc.val($('#BccCustomer').val());
            }
            else {
                // multi select is present
                $To = $('#ToCustomer', parent.document);
                $Cc = $('#CcCustomer', parent.document);
                $Bcc = $('#BccCustomer', parent.document);

                $.each($('#ToCustomer').val().split(/, ?/), function(Index, Value){
                    $To.val(Value);
                    parent.Core.Agent.CustomerSearch.AddTicketCustomer( 'ToCustomer', Value );
                });

                $.each($('#CcCustomer').val().split(/, ?/), function(Index, Value){
                    $Cc.val(Value);
                    parent.Core.Agent.CustomerSearch.AddTicketCustomer( 'CcCustomer', Value );
                });

                $.each($('#BccCustomer').val().split(/, ?/), function(Index, Value){
                    $Bcc.val(Value);
                    parent.Core.Agent.CustomerSearch.AddTicketCustomer( 'BccCustomer', Value );
                });
            }

            parent.Core.UI.Dialog.CloseDialog($('.Dialog', parent.document));
        });

        // Register Cancel button event
        $('#Cancel').bind('click', function (Event) {
            // Because we are in an iframe, we need to call the parent frames javascript function
            // with a jQuery object which is in the parent frames context
            parent.Core.UI.Dialog.CloseDialog($('.Dialog', parent.document));
        });
    };

    /**
     * @function
     * @return nothing
     *      This function initializes the necessary stuff for spell check link  in TicketAction screens
     */
    TargetNS.InitSpellCheck = function () {
        // Register onchange event for dropdown and input field to change the radiobutton
        $('#SpellCheck select, #SpellCheck input:text').bind('change', function (Event) {
            var $Row = $(this).closest('tr'),
                RowCount = parseInt($Row.attr('id').replace(/Row/, ''), 10);
            $Row.find('input:radio[id=ChangeWord' + RowCount + ']').prop('checked', true);
        });

        // Register Apply button event
        $('#Apply').bind('click', function (Event) {
            // Update ticket action popup fields
            var FieldName = $('#Field').val(),
                $Body = $('#' + FieldName, parent.document);

            $Body.val($('#Body').val());

            // Because we are in an iframe, we need to call the parent frames javascript function
            // with a jQuery object which is in the parent frames context
            parent.Core.UI.Dialog.CloseDialog($('.Dialog', parent.document));
        });

        // Register Cancel button event
        $('#Cancel').bind('click', function (Event) {
            // Because we are in an iframe, we need to call the parent frames javascript function
            // with a jQuery object which is in the parent frames context
            parent.Core.UI.Dialog.CloseDialog($('.Dialog', parent.document));
        });
    };

    /**
     * @function
     * @param
     *      {String} Customer The customer that was selected in the customer popup window
     * @return nothing
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
     * @function
     * @return nothing
     *      Selects a radio button by name and value
     * @param {Value} The value attribute of the radio button to be selected
     * @param {Object} The name of the radio button to be selected
     */
    TargetNS.SelectRadioButton = function (Value, Name) {
        $('input:radio[name=' + Name + '][value=' + Value + ']').prop('checked', true);
    };

    return TargetNS;
}(Core.Agent.TicketAction || {}));
