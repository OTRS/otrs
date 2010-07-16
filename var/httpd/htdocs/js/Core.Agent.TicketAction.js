// --
// Core.Agent.TicketAction.js - provides functions for all ticket action popups
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.Agent.TicketAction.js,v 1.3 2010-07-16 15:43:44 cg Exp $
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
    function OpenSpellChecker() {
        var SpellCheckIFrame = '<iframe class="TextOption SpellCheck" src="' + Core.Config.Get('CGIHandle') + '?Action=AgentSpelling;Field=RichText;Body=' + $('#RichText').val() + '"></iframe>';
        Core.UI.Dialog.ShowContentDialog(SpellCheckIFrame, '', '10px', 'Center', true);
    }

    function OpenAdressBook() {
        var AdressBookIFrame = '<iframe class="TextOption" src="' + Core.Config.Get('CGIHandle') + '?Action=AgentBook;To=' + $('#CustomerAutoComplete').val() + ';Cc=' + $('#Cc').val() + ';Bcc=' + $('#Bcc').val() + '"></iframe>';
        Core.UI.Dialog.ShowContentDialog(AdressBookIFrame, '', '10px', 'Center', true);
    }

    function OpenCustomerDialog() {
        var CustomerIFrame = '<iframe class="TextOption Customer" src="' + Core.Config.Get('CGIHandle') + '?Action=AdminCustomerUser;Nav=None;Subject=;What="></iframe>';
        Core.UI.Dialog.ShowContentDialog(CustomerIFrame, '', '10px', 'Center', true);
    }

    function AddMailAdress($Link) {
        var $Element = $('#' + $Link.attr('rel')),
            NewValue = $Element.val();
        if (NewValue.length) {
            NewValue = NewValue + ', ';
        }
        NewValue = NewValue + Core.Data.Get($Link.closest('tr'), 'Email');
        $Element.val(NewValue);
    }

    function UpdateCustomer(Customer) {
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

        // Register event for adressbook dialog
        $('#OptionAdressBook').bind('click', function (Event) {
            OpenAdressBook();
            return false;
        });

        // Register event for customer dialog
        $('#OptionCustomer').bind('click', function (Event) {
            OpenCustomerDialog();
            return false;
        });
    };

    TargetNS.InitAdressBook = function () {
        // Register event for copying mail adress to input field
        $('#SearchResult a').bind('click', function (Event) {
            AddMailAdress($(this));
            return false;
        });

        // Register Apply button event
        $('#Apply').bind('click', function (Event) {
            // Update ticket action popup fields
            var $To = $('#CustomerAutoComplete', parent.document),
                $Cc = $('#Cc', parent.document),
                $Bcc = $('#Bcc', parent.document);

            $To.val($('#To').val());
            $Cc.val($('#Cc').val());
            $Bcc.val($('#Bcc').val());

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
    }

    TargetNS.InitSpellCheck = function () {
        // Register onchange event for dropdown and input field to change the radiobutton
        $('#SpellCheck select, #SpellCheck input:text').bind('change', function (Event) {
            var $Row = $(this).closest('tr'),
                RowCount = parseInt($Row.attr('id').replace(/Row/, ''), 10);
            $Row.find('input:radio[id=ChangeWord' + RowCount + ']').attr('checked', 'checked');
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
    }

    TargetNS.InitCustomer = function () {
        $('#CustomerTable a').bind('click', function (Event) {
            var Customer = $(this).text();
            UpdateCustomer(Customer);
        });
    }

    return TargetNS;
}(Core.Agent.TicketAction || {}));
