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
 * @namespace Core.Agent.CustomerSearch
 * @memberof Core.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the customer search.
 */
Core.Agent.CustomerSearch = (function (TargetNS) {
    /**
     * @private
     * @name BackupData
     * @memberof Core.Agent.CustomerSearch
     * @member {Object}
     * @description
     *      Saves Customer data for later restore.
     */
    var BackupData = {
            CustomerInfo: '',
            CustomerEmail: '',
            CustomerKey: ''
        },
    /**
     * @private
     * @name CustomerFieldChangeRunCount
     * @memberof Core.Agent.CustomerSearch
     * @member {Object}
     * @description
     *      Needed for the change event of customer fields, if ActiveAutoComplete is false (disabled).
     */
        CustomerFieldChangeRunCount = {};

    /**
     * @private
     * @name DeactivateSelectionCustomerID
     * @memberof Core.Agent.CustomerSearch
     * @function
     * @description
     *      Disable the selection for the customer ID, if needed.
     */
    function DeactivateSelectionCustomerID () {
        if($('#TemplateSelectionCustomerID').length) {
            $('#SelectionCustomerID').prop('disabled', true)
            $('#SelectionCustomerID').prop('title', Core.Language.Translate('First select a customer user, then select a customer ID to assign to this ticket.'));
            $('#SelectionCustomerID').addClass('Disabled');
        }
    }

    /**
     * @private
     * @name ActivateSelectionCustomerID
     * @memberof Core.Agent.CustomerSearch
     * @function
     * @param {String} Value - The value attribute of the radio button to be selected.
     * @param {String} Name - The name of the radio button to be selected.
     * @description
     *      Activate the customer ID selection button, if .
     */
    function ActivateSelectionCustomerID () {
        if ($('#TemplateSelectionCustomerID').length && $('#SelectionCustomerID').hasClass('Disabled')) {
            $('#SelectionCustomerID').prop('disabled', false)
            $('#SelectionCustomerID').prop('title', Core.Language.Translate('Select a customer ID to assign to this ticket.'));
            $('#SelectionCustomerID').removeClass('Disabled');
        }
    }

    /**
     * @private
     * @name GetCustomerInfo
     * @memberof Core.Agent.CustomerSearch
     * @function
     * @param {String} CustomerUserID
     * @description
     *      This function gets customer data for customer info table.
     */
    function GetCustomerInfo(CustomerUserID) {
        var Data = {
                Action: 'AgentCustomerSearch',
                Subaction: 'CustomerInfo',
                CustomerUserID: CustomerUserID
            },
            SignatureURL;
        Core.AJAX.FunctionCall(Core.Config.Get('Baselink'), Data, function (Response) {

            $('#CustomerID').val(Response.CustomerID);
            $('#ShowCustomerID').html(Response.CustomerID);

            // Publish information for subscribers
            Core.App.Publish('Event.Agent.CustomerSearch.GetCustomerInfo.Callback', [Response.CustomerID]);

            // show customer info
            $('#CustomerInfo .Content').html(Response.CustomerTableHTMLString);

            // only execute this part, if in AgentTicketEmail or AgentTicketPhone
            if (Core.Config.Get('Action') === 'AgentTicketEmail' || Core.Config.Get('Action') === 'AgentTicketPhone') {
                // reset service
                $('#ServiceID').attr('selectedIndex', 0);
                // update services (trigger ServiceID change event)
                Core.AJAX.FormUpdate($('#CustomerID').closest('form'), 'AJAXUpdate', 'ServiceID', ['Dest', 'SelectedCustomerUser', 'Signature', 'NextStateID', 'PriorityID', 'ServiceID', 'SLAID', 'CryptKeyID', 'OwnerAll', 'ResponsibleAll', 'TicketFreeText1', 'TicketFreeText2', 'TicketFreeText3', 'TicketFreeText4', 'TicketFreeText5', 'TicketFreeText6', 'TicketFreeText7', 'TicketFreeText8', 'TicketFreeText9', 'TicketFreeText10', 'TicketFreeText11', 'TicketFreeText12', 'TicketFreeText13', 'TicketFreeText14', 'TicketFreeText15', 'TicketFreeText16']);

                // Update signature if needed.
                if ($('#Dest').val() !== '') {
                    SignatureURL = Core.Config.Get('Baselink') + 'Action=' + Core.Config.Get('Action') + ';Subaction=Signature;Dest=' + $('#Dest').val() + ';SelectedCustomerUser=' + $('#SelectedCustomerUser').val();
                    if (!Core.Config.Get('SessionIDCookie')) {
                        SignatureURL += ';' + Core.Config.Get('SessionName') + '=' + Core.Config.Get('SessionID');
                    }
                    $('#Signature').attr('src', SignatureURL);
                }
            }
            if (Core.Config.Get('Action') === 'AgentTicketProcess' &&
                typeof Core.Config.Get('CustomerFieldsToUpdate') !== 'undefined'){
                // reset service
                $('#ServiceID').attr('selectedIndex', 0);
                // update services (trigger ServiceID change event)
                Core.AJAX.FormUpdate($('#CustomerID').closest('form'), 'AJAXUpdate', 'ServiceID', Core.Config.Get('CustomerFieldsToUpdate'));
            }
        });
    }

    /**
     * @private
     * @name GetCustomerTickets
     * @memberof Core.Agent.CustomerSearch
     * @function
     * @param {String} CustomerUserID
     * @param {String} CustomerID
     * @description
     *      This function gets customer tickets.
     */
    function GetCustomerTickets(CustomerUserID, CustomerID) {

        var Data = {
            Action: 'AgentCustomerSearch',
            Subaction: 'CustomerTickets',
            CustomerUserID: CustomerUserID,
            CustomerID: CustomerID
        };

        // check if customer tickets should be shown
        if (typeof Core.Config.Get('CustomerSearch') !== 'undefined' && !parseInt(Core.Config.Get('CustomerSearch').ShowCustomerTickets, 10)) {
            return;
        }

        /**
         * @private
         * @name CustomerHistoryEvents
         * @memberof Core.Agent.CustomerSearch.GetCustomerTickets
         * @function
         * @description
         *      This function creates events for Customer History overview table.
         */
        function CustomerHistoryEvents() {
            $('select[name=ResponseID]').on('change', function () {
                var URL;
                if ($(this).val() > 0) {
                    URL = Core.Config.Get('Baselink') + $(this).parents().serialize();
                    Core.UI.Popup.OpenPopup(URL, 'TicketAction');

                    // Reset the select box so that it can be used again from the same window.
                    $(this).val('0');
                }
            });
            $('select[name=ResponseID]').on('click', function (Event) {
                Event.stopPropagation();
                return false;
            });

            $('#CustomerTickets .MasterAction').on('click', function (Event) {
                var $MasterActionLink = $(this).find('a.MasterActionLink');

                // Prevent MasterAction on Modernize input fields.
                if ($(Event.target).hasClass('InputField_Search')) {
                    return true;
                }

                // Event must be done in the parent window because AgentTicketCustomer is in popup.
                if (Core.Config.Get('Action') === 'AgentTicketCustomer') {
                    Core.UI.Popup.ExecuteInParentWindow(function(WindowObject) {
                        WindowObject.Core.UI.Popup.FirePopupEvent('URL', { URL: $MasterActionLink.attr('href') });
                    });
                    Core.UI.Popup.ClosePopup();
                    return false;
                }
                else {

                    // Only act if the link was not clicked directly.
                    if (Event.target !== $MasterActionLink.get(0)) {
                        window.location = $MasterActionLink.attr('href');
                        return false;
                    }
                }
            });

            $("#SortBy").off('change').on('change', function () {
                var SortedData,
                    Selection = $(this).val().split('|');

                if (Selection.length === 2) {

                    // Show sorted customer tickets.
                    SortedData = {
                        Action: 'AgentCustomerSearch',
                        Subaction: 'CustomerTickets',
                        CustomerUserID: CustomerUserID,
                        CustomerID: CustomerID,
                        SortBy: Selection[0],
                        OrderBy: Selection[1]
                    };
                    Core.AJAX.FunctionCall(Core.Config.Get('Baselink'), SortedData, function (Response) {
                        if ($('#CustomerTickets').length) {
                            $('#CustomerTickets').html(Response.CustomerTicketsHTMLString);
                            ReplaceCustomerTicketLinks();
                        }
                    });
                }
            });

            // Activate Modernize fields.
            Core.UI.InputFields.Activate();
            Core.App.Subscribe('Event.UI.Accordion.OpenElement', function($Element) {
                Core.UI.InputFields.Activate($Element);
            });
        }

        /**
         * @private
         * @name ReplaceCustomerTicketLinks
         * @memberof Core.Agent.CustomerSearch.GetCustomerTickets
         * @function
         * @returns {Boolean} Returns false.
         * @description
         *      This function replaces and shows customer ticket links.
         */
        function ReplaceCustomerTicketLinks() {
            $('#CustomerTickets').find('.AriaRoleMain').removeAttr('role').removeClass('AriaRoleMain');

            // Replace overview mode links (S, M, L view), pagination links with AJAX
            $('#CustomerTickets').find('.OverviewZoom a, .Pagination a, .TableSmall th a').click(function () {
                // Cut out BaseURL and query string from the URL
                var Link = $(this).attr('href'),
                    URLComponents;

                URLComponents = Link.split('?', 2);

                Core.AJAX.FunctionCall(URLComponents[0], URLComponents[1], function (Response) {
                    // show customer tickets
                    if ($('#CustomerTickets').length) {
                        $('#CustomerTickets').html(Response.CustomerTicketsHTMLString);
                        ReplaceCustomerTicketLinks();

                        $('#CustomerTickets a.SplitSelection').off('click').on('click', function() {
                            Core.Agent.TicketSplit.OpenSplitSelection($(this).attr('href'));
                            return false;
                        });
                    }
                });
                return false;
            });

            // Init accordion of overview article preview
            Core.UI.Accordion.Init($('.Preview > ul'), 'li h3 a', '.HiddenBlock');

            // Events for Customer History table - AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer screens.
            if (
                Core.Config.Get('Action') === 'AgentTicketPhone' ||
                Core.Config.Get('Action') === 'AgentTicketEmail' ||
                Core.Config.Get('Action') === 'AgentTicketCustomer' ||
                Core.Config.Get('Action') === 'AgentChatAppend'
                )
            {
                CustomerHistoryEvents();
            }

            return false;
        }

        Core.AJAX.FunctionCall(Core.Config.Get('Baselink'), Data, function (Response) {
            // show customer tickets
            if ($('#CustomerTickets').length) {
                $('#CustomerTickets').html(Response.CustomerTicketsHTMLString);
                ReplaceCustomerTicketLinks();

                // click event for opening popup
                $('#CustomerTickets a.AsPopup').off('click').on('click', function () {
                    Core.UI.Popup.OpenPopup($(this).attr('href'), 'Action');
                    return false;
                });

                $('#CustomerTickets a.SplitSelection').off('click').on('click', function() {
                    Core.Agent.TicketSplit.OpenSplitSelection($(this).attr('href'));
                    return false;
                });
            }
        });
    }

    /**
     * @private
     * @name CheckPhoneCustomerCountLimit
     * @memberof Core.Agent.CustomerSearch
     * @function
     * @description
     *      In AgentTicketPhone, this checks if more than one entry is allowed
     *      in the customer list and blocks/unblocks the autocomplete field as needed.
     */
    function CheckPhoneCustomerCountLimit() {

        // Only operate in AgentTicketPhone
        if (Core.Config.Get('Action') !== 'AgentTicketPhone') {
            return;
        }

        // Check if multiple from entries are allowed
        if (parseInt(Core.Config.Get('CustomerSearch').AllowMultipleFrom, 10)) {
            return;
        }

        if ($('#TicketCustomerContentFromCustomer input.CustomerTicketText').length > 0) {
            $('#FromCustomer').val('').prop('disabled', true).prop('readonly', true);
            $('#Dest').trigger('focus');
        }
        else {
            $('#FromCustomer').val('').prop('disabled', false).prop('readonly', false);
        }
    }

    /**
     * @private
     * @name InitSimple
     * @memberof Core.Agent.CustomerSearch
     * @function
     * @param {jQueryObject} $Element - The jQuery object of the input field with autocomplete.
     * @description
     *      Initializes the module.
     */
    TargetNS.InitSimple = function ($Element) {
        var CustomerSearchType = $Element.data('customer-search-type');

        if (CustomerSearchType) {
            Core.UI.Autocomplete.Init($Element, function (Request, Response) {
                    var URL = Core.Config.Get('Baselink'), Data = {
                        Action: 'AgentCustomerSearch',
                        Subaction: 'Search' + CustomerSearchType,
                        Term: Request.term,
                        MaxResults: Core.UI.Autocomplete.GetConfig('MaxResultsDisplayed')
                    };

                    $Element.data('AutoCompleteXHR', Core.AJAX.FunctionCall(URL, Data, function (Result) {
                        var ValueData = [];
                        $Element.removeData('AutoCompleteXHR');
                        $.each(Result, function () {
                            ValueData.push({
                                label: this.Label + (CustomerSearchType == 'CustomerUser' ? ' (' + this.Value + ')' : ''),
                                value: this.Value
                            });
                        });
                        Response(ValueData);
                    }));
            }, function (Event, UI) {
                $Element.val(UI.item.value).trigger('select.Autocomplete');

                Event.preventDefault();
                Event.stopPropagation();

                return false;
            }, 'CustomerSearch');
        }
    }

    /**
     * @private
     * @name Init
     * @memberof Core.Agent.CustomerSearch
     * @function
     * @param {jQueryObject} $Element - The jQuery object of the input field with autocomplete.
     * @description
     *      Initializes the module.
     */
    TargetNS.Init = function ($Element) {
        var AutocompleteFocus = false;

        // get customer tickets for AgentTicketCustomer
        if (Core.Config.Get('Action') === 'AgentTicketCustomer') {
            GetCustomerTickets($('#CustomerAutoComplete').val(), $('#CustomerID').val());

            $Element.blur(function () {
                if ($Element.val() === '') {
                    TargetNS.ResetCustomerInfo();
                    DeactivateSelectionCustomerID();
                    $('#CustomerTickets').empty();
                }
            });
        }

        // Enable free selection or input of CustomerID field on AgentTicketProcess and AgentTicketCustomer.
        if ((Core.Config.Get('Action') === 'AgentTicketProcess'
            && !Core.Config.Get('Ticket::Frontend::AgentTicketProcess::CustomerIDReadOnly'))
            ||
            (Core.Config.Get('Action') === 'AgentTicketCustomer'
            && !Core.Config.Get('Ticket::Frontend::AgentTicketCustomer::CustomerIDReadOnly'))
            ) {
            $('#CustomerAutoComplete').on('blur keyup' , function() {
                if($('#CustomerAutoComplete').val()) {
                    ActivateSelectionCustomerID();
                }
                else {
                    DeactivateSelectionCustomerID();
                }
            });
        }

        // get customer tickets for AgentTicketPhone and AgentTicketEmail
        if ((Core.Config.Get('Action') === 'AgentTicketEmail' || Core.Config.Get('Action') === 'AgentTicketPhone') && $('#SelectedCustomerUser').val() !== '') {
            GetCustomerTickets($('#SelectedCustomerUser').val());
        }

        // just save the initial state of the customer info
        if ($('#CustomerInfo').length) {
            BackupData.CustomerInfo = $('#CustomerInfo .Content').html();
        }

        if (isJQueryObject($Element)) {
            // Hide tooltip in autocomplete field, if user already typed something to prevent the autocomplete list
            // to be hidden under the tooltip. (Only needed for serverside errors)
            $Element.off('keyup.Validate').on('keyup.Validate', function () {
               var Value = $Element.val();
               if ($Element.hasClass('ServerError') && Value.length) {
                   $('#OTRS_UI_Tooltips_ErrorTooltip').hide();
               }
            });

            Core.App.Subscribe('Event.CustomerUserAddressBook.AddTicketCustomer.Callback.' + $Element.attr('id'), function(UserLogin, CustomerTicketText) {
                $Element.val(CustomerTicketText);
                TargetNS.AddTicketCustomer($Element.attr('id'), CustomerTicketText, UserLogin);
            });

            Core.UI.Autocomplete.Init($Element, function (Request, Response) {
                var URL = Core.Config.Get('Baselink'),
                    Data = {
                        Action: 'AgentCustomerSearch',
                        Term: Request.term,
                        MaxResults: Core.UI.Autocomplete.GetConfig('MaxResultsDisplayed')
                    };

                $Element.data('AutoCompleteXHR', Core.AJAX.FunctionCall(URL, Data, function (Result) {
                    var ValueData = [];
                    $Element.removeData('AutoCompleteXHR');
                    $.each(Result, function () {
                        ValueData.push({
                            label: this.Label + " (" + this.Value + ")",
                            // customer list representation (see CustomerUserListFields from Defaults.pm)
                            value: this.Label,
                            // customer user id
                            key: this.Value
                        });
                    });
                    Response(ValueData);
                }));
            }, function (Event, UI) {
                var CustomerKey = UI.item.key,
                    CustomerValue = UI.item.value;

                BackupData.CustomerKey = CustomerKey;
                BackupData.CustomerEmail = CustomerValue;

                $Element.val(CustomerValue);

                if (
                    Core.Config.Get('Action') === 'AgentTicketEmail'
                    || Core.Config.Get('Action') === 'AgentTicketCompose'
                    || Core.Config.Get('Action') === 'AgentTicketForward'
                    || Core.Config.Get('Action') === 'AgentTicketEmailOutbound'
                    || Core.Config.Get('Action') === 'AgentTicketEmailResend'
                    )
                {
                    $Element.val('');
                }

                if (
                    Core.Config.Get('Action') !== 'AgentTicketPhone'
                    && Core.Config.Get('Action') !== 'AgentTicketEmail'
                    && Core.Config.Get('Action') !== 'AgentTicketCompose'
                    && Core.Config.Get('Action') !== 'AgentTicketForward'
                    && Core.Config.Get('Action') !== 'AgentTicketEmailOutbound'
                    && Core.Config.Get('Action') !== 'AgentTicketEmailResend'
                    )
                {
                    // set hidden field SelectedCustomerUser
                    $('#SelectedCustomerUser').val(CustomerKey);

                    ActivateSelectionCustomerID();

                    // needed for AgentTicketCustomer.pm
                    if ($('#CustomerUserID').length) {
                        $('#CustomerUserID').val(CustomerKey);
                        if ($('#CustomerUserOption').length) {
                            $('#CustomerUserOption').val(CustomerKey);
                        }
                        else {
                            $('<input type="hidden" name="CustomerUserOption" id="CustomerUserOption">').val(CustomerKey).appendTo($Element.closest('form'));
                        }
                    }

                    // get customer tickets
                    GetCustomerTickets(CustomerKey);

                    // get customer data for customer info table
                    GetCustomerInfo(CustomerKey);
                }
                else {
                    TargetNS.AddTicketCustomer($(Event.target).attr('id'), CustomerValue, CustomerKey);
                }
            }, 'CustomerSearch');

            // Remember if autocomplete item was focused (by keyboard navigation or mouse).
            $Element.on('autocompletefocus', function() {
                AutocompleteFocus = true;
            });

            if (typeof $Element.data("ui-autocomplete") === 'object') {

                // Remember if the autocomplete widget is left by mouse.
                $($Element.data("ui-autocomplete").menu.element).on('mouseleave', function() {
                    AutocompleteFocus = false;
                });

                // Remember if the autocomplete widget is left by keyboard navigation.
                // This is done by override the _move method because there is no opposite event of autocompletefocus.
                $Element.data("ui-autocomplete")._move = function(direction, event) {

                    if (!this.menu.element.is(":visible")) {
                        this.search(null, event);
                        return;
                    }

                    if (this.menu.isFirstItem() && /^previous/.test(direction) ||
                        this.menu.isLastItem() && /^next/.test(direction)
                    ) {
                        this._value(this.term);

                        // Trigger mouseleave for removing selection of autocomplete widget.
                        $(this.menu.element).trigger('mouseleave');

                        AutocompleteFocus = false;
                        return;
                    }

                    this.menu[ direction ](event);
                };
            }

            // If autocomplete was focused, but then closed by a blur, clear the search field since this value was
            //   never explicitly confirmed. Do this also when user decides to click outside the autocomplete list,
            //   which causes the list to close. Please see bug#13537 for more information.
            $Element.on('autocompleteclose', function(Event) {
                if (
                    AutocompleteFocus
                    && (
                        Event.originalEvent === undefined
                        || (
                            Event.originalEvent
                            && Event.originalEvent.type == 'blur'
                        )
                    )
                    )
                {
                    $Element.val('');
                }

                AutocompleteFocus = false;
            });

            if (
                Core.Config.Get('Action') !== 'AgentTicketPhone'
                && Core.Config.Get('Action') !== 'AgentTicketEmail'
                && Core.Config.Get('Action') !== 'AgentTicketCompose'
                && Core.Config.Get('Action') !== 'AgentTicketForward'
                && Core.Config.Get('Action') !== 'AgentTicketEmailOutbound'
                && Core.Config.Get('Action') !== 'AgentTicketEmailResend'
                )
            {
                $Element.blur(function () {
                    var FieldValue = $(this).val();
                    if (FieldValue !== BackupData.CustomerEmail && FieldValue !== BackupData.CustomerKey) {
                        $('#SelectedCustomerUser').val('');
                        $('#CustomerUserID').val('');
                        $('#CustomerUserOption').val('');
                        $('#ShowCustomerID').html('');

                        // Restore customer info table.
                        if (Core.Config.Get('Action') !== 'AgentTicketCustomer') {
                            $('#CustomerInfo .Content').html(BackupData.CustomerInfo);
                            $('#CustomerID').val('');
                        }

                        if (Core.Config.Get('Action') === 'AgentTicketProcess' && typeof Core.Config.Get('CustomerFieldsToUpdate') !== 'undefined') {
                            // update services (trigger ServiceID change event)
                            Core.AJAX.FormUpdate($('#CustomerID').closest('form'), 'AJAXUpdate', 'ServiceID', Core.Config.Get('CustomerFieldsToUpdate'));
                        }
                    }
                });
            }
            else {
                // Initializes the customer field.
                TargetNS.InitCustomerField($Element);
            }
        }

        // On unload remove old selected data. If the page is reloaded (with F5) this data
        // stays in the field and invokes an ajax request otherwise. We need to use beforeunload
        // here instead of unload because the URL of the window does not change on reload which
        // doesn't trigger pagehide.
        $(window).on('beforeunload.CustomerSearch', function () {
            $('#SelectedCustomerUser').val('');
            return; // return nothing to suppress the confirmation message
        });

        CheckPhoneCustomerCountLimit();
    };

    function htmlDecode(Text){
        return Text.replace(/&amp;/g, '&');
    }

    /**
     * @name AddTicketCustomer
     * @memberof Core.Agent.CustomerSearch
     * @function
     * @returns {Boolean} Returns false.
     * @param {String} Field
     * @param {String} CustomerValue - The readable customer identifier.
     * @param {String} CustomerKey - Customer key on system.
     * @param {String} SetAsTicketCustomer -  Set this customer as main ticket customer.
     * @description
     *      This function adds a new ticket customer
     */
    TargetNS.AddTicketCustomer = function (Field, CustomerValue, CustomerKey, SetAsTicketCustomer) {

        var $Clone = $('.CustomerTicketTemplate' + Field).clone(),
            CustomerTicketCounter = $('#CustomerTicketCounter' + Field).val(),
            TicketCustomerIDs = 0,
            IsDuplicated = false,
            IsFocused = ($(document.activeElement).attr('id') == Field),
            Suffix;

        if (typeof CustomerKey !== 'undefined') {
            CustomerKey = htmlDecode(CustomerKey);
        }

        if (CustomerValue === '') {
            return false;
        }

        // check for duplicated entries
        $('[class*=CustomerTicketText]').each(function() {
            if ($(this).val() === CustomerValue) {
                IsDuplicated = true;
            }
        });
        if (IsDuplicated) {
            TargetNS.ShowDuplicatedDialog(Field);
            return false;
        }

        // get number of how much customer ticket are present
        TicketCustomerIDs = $('.CustomerContainer input[type="radio"]').length;

        // increment customer counter
        CustomerTicketCounter++;

        // set sufix
        Suffix = '_' + CustomerTicketCounter;

        // remove unnecessary classes
        $Clone.removeClass('Hidden CustomerTicketTemplate' + Field);

        // copy values and change ids and names
        $Clone.find(':input, a').each(function(){
            var ID = $(this).attr('id');
            $(this).attr('id', ID + Suffix);
            $(this).val(CustomerValue);
            if (ID !== 'CustomerSelected') {
                $(this).attr('name', ID + Suffix);
            }

            // add event handler to radio button
            if($(this).hasClass('CustomerTicketRadio')) {

                if (TicketCustomerIDs === 0) {
                    $(this).prop('checked', true);
                }

                // set counter as value
                $(this).val(CustomerTicketCounter);

                // bind change function to radio button to select customer
                $(this).on('change', function () {
                    // remove row
                    if ($(this).prop('checked')){
                        TargetNS.ReloadCustomerInfo(CustomerKey);
                    }
                    return false;
                });
            }

            // set customer key if present
            if($(this).hasClass('CustomerKey')) {
                $(this).val(CustomerKey);
            }

            // add event handler to remove button
            if($(this).hasClass('RemoveButton')) {

                // bind click function to remove button
                $(this).on('click', function () {
                    // remove row
                    TargetNS.RemoveCustomerTicket($(this));

                    // clear CustomerHistory table if there are no selected customer users
                    if ($('#TicketCustomerContent' + Field + ' .CustomerTicketRadio').length === 0) {
                        $('#CustomerTickets').empty();
                    }
                    return false;
                });
                // set button value
                $(this).val(CustomerValue);
            }

        });
        // show container
        $('#TicketCustomerContent' + Field).parent().removeClass('Hidden');
        // append to container
        $('#TicketCustomerContent' + Field).append($Clone);

        // set new value for CustomerTicketCounter
        $('#CustomerTicketCounter' + Field).val(CustomerTicketCounter);
        if ((CustomerKey !== '' && TicketCustomerIDs === 0 && (Field === 'ToCustomer' || Field === 'FromCustomer')) || SetAsTicketCustomer) {
            if (SetAsTicketCustomer) {
                $('#CustomerSelected_' + CustomerTicketCounter).prop('checked', true).trigger('change');
            }
            else {
                $('.CustomerContainer input[type="radio"]:first').prop('checked', true).trigger('change');
            }
        }

        // Return the value to the search field.
        $('#' + Field).val('');

        // Re-focus the field, but only if it was previously focused.
        if (IsFocused) {
            $('#' + Field).focus();
        }

        CheckPhoneCustomerCountLimit();

        // Reload Crypt options on specific screens.
        if (
            (
                Core.Config.Get('Action') === 'AgentTicketEmail'
                || Core.Config.Get('Action') === 'AgentTicketCompose'
                || Core.Config.Get('Action') === 'AgentTicketForward'
                || Core.Config.Get('Action') === 'AgentTicketEmailOutbound'
                || Core.Config.Get('Action') === 'AgentTicketEmailResend'
            )
            && $('#CryptKeyID').length
            )
        {
            Core.AJAX.FormUpdate($('#' + Field).closest('form'), 'AJAXUpdate', '', ['CryptKeyID']);
        }

        // now that we know that at least one customer has been added,
        // we can remove eventual errors from the customer field
        $('#FromCustomer, #ToCustomer')
            .removeClass('Error ServerError')
            .closest('.Field')
            .prev('label')
            .removeClass('LabelError');
        Core.Form.ErrorTooltips.HideTooltip();

        ActivateSelectionCustomerID();

        return false;
    };

    /**
     * @name RemoveCustomerTicket
     * @memberof Core.Agent.CustomerSearch
     * @function
     * @param {jQueryObject} Object - JQuery object used as base to delete it's parent.
     * @description
     *      This function removes a customer ticket entry.
     */
    TargetNS.RemoveCustomerTicket = function (Object) {
        var TicketCustomerIDs = 0,
        $Field = Object.closest('.Field'),
        $Form;

        if (
            Core.Config.Get('Action') === 'AgentTicketEmail'
            || Core.Config.Get('Action') === 'AgentTicketCompose'
            || Core.Config.Get('Action') === 'AgentTicketForward'
            || Core.Config.Get('Action') === 'AgentTicketEmailOutbound'
            || Core.Config.Get('Action') === 'AgentTicketEmailResend'
            )
        {
            $Form = Object.closest('form');
        }
        Object.parent().remove();
        TicketCustomerIDs = $('.CustomerContainer input[type="radio"]').length;
        if (TicketCustomerIDs === 0) {
            TargetNS.ResetCustomerInfo();
        }

        // Reload Crypt options on specific screens.
        if (
            (
                Core.Config.Get('Action') === 'AgentTicketEmail'
                || Core.Config.Get('Action') === 'AgentTicketCompose'
                || Core.Config.Get('Action') === 'AgentTicketForward'
                || Core.Config.Get('Action') === 'AgentTicketEmailOutbound'
                || Core.Config.Get('Action') === 'AgentTicketEmailResend'
            )
            && $('#CryptKeyID').length
            )
        {
            Core.AJAX.FormUpdate($Form, 'AJAXUpdate', '', ['CryptKeyID']);
        }

        if(!$('.CustomerContainer input[type="radio"]').is(':checked')){
            //set the first one as checked
            $('.CustomerContainer input[type="radio"]:first').prop('checked', true).trigger('change');
        }

        if ($Field.find('.CustomerTicketText:visible').length === 0) {
            $Field.addClass('Hidden');

            DeactivateSelectionCustomerID();
        }

        CheckPhoneCustomerCountLimit();
    };

    /**
     * @name ResetCustomerInfo
     * @memberof Core.Agent.CustomerSearch
     * @function
     * @description
     *      This function clears all selected customer info.
     */
    TargetNS.ResetCustomerInfo = function () {
            $('#SelectedCustomerUser').val('');
            $('#CustomerUserID').val('');
            $('#CustomerID').val('');
            $('#CustomerUserOption').val('');
            $('#ShowCustomerID').html('');

            // reset customer info table
            $('#CustomerInfo .Content').html(Core.Language.Translate('none'));
    };

    /**
     * @name ReloadCustomerInfo
     * @memberof Core.Agent.CustomerSearch
     * @function
     * @param {String} CustomerKey
     * @description
     *      This function reloads info for selected customer.
     */
    TargetNS.ReloadCustomerInfo = function (CustomerKey) {

        // get customer tickets
        GetCustomerTickets(CustomerKey);

        // get customer data for customer info table
        GetCustomerInfo(CustomerKey);

        // set hidden field SelectedCustomerUser
        $('#SelectedCustomerUser').val(CustomerKey);
    };

    /**
     * @name InitCustomerField
     * @memberof Core.Agent.CustomerSearch
     * @function
     * @param {String} $Element - JQuery object.
     * @description
     *      This function initializes the customer fields.
     */
    TargetNS.InitCustomerField = function ($Element) {
        var ObjectId = $Element.attr('id');

        $('#' + ObjectId).on('change', function () {

            if (!$('#' + ObjectId).val() || $('#' + ObjectId).val() === '') {
                return false;
            }

            // if autocompletion is disabled and only avaible via the click
            // of a button next to the input field, we cannot handle this
            // change event the normal way.
            if (!Core.UI.Autocomplete.GetConfig('ActiveAutoComplete')) {
                // we wait some time after this event to check, if the search button
                // for this field was pressed. If so, no action is needed
                // If the change event was fired without clicking the search button,
                // probably the user clicked out of the field.
                // This should also add the customer (the enetered value) to the list

                if (typeof CustomerFieldChangeRunCount[ObjectId] === 'undefined') {
                    CustomerFieldChangeRunCount[ObjectId] = 1;
                }
                else {
                    CustomerFieldChangeRunCount[ObjectId]++;
                }

                if (Core.UI.Autocomplete.SearchButtonClicked[ObjectId]) {
                    delete CustomerFieldChangeRunCount[ObjectId];
                    delete Core.UI.Autocomplete.SearchButtonClicked[ObjectId];
                    return false;
                }
                else {
                    if (CustomerFieldChangeRunCount[ObjectId] === 1) {
                        window.setTimeout(function () {
                            $('#' + ObjectId).trigger('change');
                        }, 200);
                        return false;
                    }
                    delete CustomerFieldChangeRunCount[ObjectId];
                }
            }


            // If the autocomplete popup window is visible, delay this change event.
            // It might be caused by clicking with the mouse into the autocomplete list.
            // Wait until it is closed to be sure that we don't add a customer twice.

            if ($Element.autocomplete("widget").is(':visible')) {
                window.setTimeout(function(){
                    $('#' + ObjectId).trigger('change');
                }, 200);
                return false;
            }

            Core.Agent.CustomerSearch.AddTicketCustomer(ObjectId, $('#' + ObjectId).val());
            return false;
        });

        $('#' + ObjectId).on('keypress', function (e) {
            if (e.which === 13){
                Core.Agent.CustomerSearch.AddTicketCustomer(ObjectId, $('#' + ObjectId).val());
                return false;
            }
        });
    };

    /**
     * @name ShowDuplicatedDialog
     * @memberof Core.Agent.CustomerSearch
     * @function
     * @param {String} Field - ID object of the element should receive the focus on close event.
     * @description
     *      This function shows an alert dialog for duplicated entries.
     */
    TargetNS.ShowDuplicatedDialog = function(Field){
        Core.UI.Dialog.ShowAlert(
            Core.Language.Translate('Duplicated entry'),
            Core.Language.Translate('This address already exists on the address list.') + ' ' + Core.Language.Translate('It is going to be deleted from the field, please try again.'),
            function () {
                Core.UI.Dialog.CloseDialog($('.Alert'));
                $('#' + Field).val('');
                $('#' + Field).focus();
                return false;
            }
        );
    };

    return TargetNS;
}(Core.Agent.CustomerSearch || {}));
