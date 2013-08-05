// --
// Core.Agent.CustomerSearch.js - provides the special module functions for the customer search
// Copyright (C) 2001-2013 OTRS AG, http://otrs.org/
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
 * @exports TargetNS as Core.Agent.CustomerSearch
 * @description
 *      This namespace contains the special module functions for the customer search.
 */
Core.Agent.CustomerSearch = (function (TargetNS) {
    var BackupData = {
        CustomerInfo: '',
        CustomerEmail: '',
        CustomerKey: ''
    };

    /**
     * @function
     * @private
     * @return nothing
     *      This function get customer data for customer info table
     */
    function GetCustomerInfo(CustomerUserID) {
        var Data = {
            Action: 'AgentCustomerSearch',
            Subaction: 'CustomerInfo',
            CustomerUserID: CustomerUserID || 1
        };
        Core.AJAX.FunctionCall(Core.Config.Get('Baselink'), Data, function (Response) {
            // set CustomerID
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
                Core.AJAX.FormUpdate($('#CustomerID').closest('form'), 'AJAXUpdate', 'ServiceID', ['Dest', 'SelectedCustomerUser', 'NextStateID', 'PriorityID', 'ServiceID', 'SLAID', 'CryptKeyID', 'OwnerAll', 'ResponsibleAll', 'TicketFreeText1', 'TicketFreeText2', 'TicketFreeText3', 'TicketFreeText4', 'TicketFreeText5', 'TicketFreeText6', 'TicketFreeText7', 'TicketFreeText8', 'TicketFreeText9', 'TicketFreeText10', 'TicketFreeText11', 'TicketFreeText12', 'TicketFreeText13', 'TicketFreeText14', 'TicketFreeText15', 'TicketFreeText16']);
            }
            if (Core.Config.Get('Action') === 'AgentTicketProcess'){
                // reset service
                $('#ServiceID').attr('selectedIndex', 0);
                // update services (trigger ServiceID change event)
                Core.AJAX.FormUpdate($('#CustomerID').closest('form'), 'AJAXUpdate', 'ServiceID', Core.Config.Get('ProcessManagement.UpdatableFields') );
            }
        });
    }

    /**
     * @function
     * @private
     * @return nothing
     *      This function get customer tickets
     */
    function GetCustomerTickets(CustomerUserID, CustomerID) {
        // check if customer tickets should be shown
        if (!parseInt(Core.Config.Get('CustomerSearch.ShowCustomerTickets'), 10)) {
            return;
        }

        var Data = {
            Action: 'AgentCustomerSearch',
            Subaction: 'CustomerTickets',
            CustomerUserID: CustomerUserID,
            CustomerID: CustomerID
        };

        /**
         * @function
         * @private
         * @return nothing
         *      This function replace and show customer ticket links
         */
        function ReplaceCustomerTicketLinks() {
            var ResizeTimeoutWindow;

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
                    }
                });
                return false;
            });

            // Init accordion of overview article preview
            Core.UI.Accordion.Init($('.Preview > ul'), 'li h3 a', '.HiddenBlock');

            // Init table functions
            if ($('#TicketList table').length) {
                Core.UI.Table.InitCSSPseudoClasses();
            }

            if ( Core.Config.Get('Action') === 'AgentTicketCustomer' ) {
                $('a.MasterActionLink').bind('click', function () {
                    window.opener.Core.UI.Popup.FirePopupEvent('URL', { URL: this.href });
                    window.close();
                    return false;
                });
            }
            return false;
        }

        Core.AJAX.FunctionCall(Core.Config.Get('Baselink'), Data, function (Response) {
            // show customer tickets
            if ($('#CustomerTickets').length) {
                $('#CustomerTickets').html(Response.CustomerTicketsHTMLString);
                ReplaceCustomerTicketLinks();
            }
        });
    }

    /**
     * @function
     *      In AgentTicketPhone, this checks if more than one entry is allowed
     *      in the customer list and blocks/unblocks the autocomplete field as needed.
     * @return nothing
     */
    function CheckPhoneCustomerCountLimit() {

        // Only operate in AgentTicketPhone
        if ( Core.Config.Get('Action') !== 'AgentTicketPhone' ) {
            return;
        }

        // Check if multiple from entries are allowed
        if ( Core.Config.Get('Ticket::Frontend::AgentTicketPhone::AllowMultipleFrom') === "1") {
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
     * @function
     * @param {jQueryObject} $Element The jQuery object of the input field with autocomplete
     * @return nothing
     *      This function initializes the special module functions
     */
    TargetNS.Init = function ($Element) {
        // get customer tickets for AgentTicketCustomer
        if (Core.Config.Get('Action') === 'AgentTicketCustomer') {
            GetCustomerTickets($('#CustomerAutoComplete').val(), $('#CustomerID').val());
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
            $Element.unbind('keyup.Validate').bind('keyup.Validate', function () {
               var Value = $Element.val();
               if ($Element.hasClass('ServerError') && Value.length) {
                   $('#OTRS_UI_Tooltips_ErrorTooltip').hide();
               }
            });

            Core.UI.Autocomplete.Init($Element, function (Request, Response) {
                var URL = Core.Config.Get('Baselink'),
                    Data = {
                        Action: 'AgentCustomerSearch',
                        Term: Request.term,
                        MaxResults: Core.UI.Autocomplete.GetConfig('MaxResultsDisplayed')
                    };

                $Element.data('AutoCompleteXHR', Core.AJAX.FunctionCall(URL, Data, function (Result) {
                    var Data = [];
                    $Element.removeData('AutoCompleteXHR');
                    $.each(Result, function () {
                        Data.push({
                            label: this.CustomerValue + " (" + this.CustomerKey + ")",
                            // customer list representation (see CustomerUserListFields from Defaults.pm)
                            value: this.CustomerValue,
                            // customer user id
                            key: this.CustomerKey
                        });
                    });
                    Response(Data);
                }));
            }, function (Event, UI) {
                var CustomerKey = UI.item.key,
                    CustomerValue = UI.item.value;

                BackupData.CustomerKey = CustomerKey;
                BackupData.CustomerEmail = CustomerValue;

                if (Core.Config.Get('Action') === 'AgentBook') {
                    $('#' + $(this).attr('id')).val(CustomerValue);
                    return false;
                }

                $Element.val(CustomerValue);

                if (Core.Config.Get('Action') === 'AgentTicketEmail' || Core.Config.Get('Action') === 'AgentTicketCompose' || Core.Config.Get('Action') === 'AgentTicketForward') {
                    $Element.val('');
                }

                if (Core.Config.Get('Action') !== 'AgentTicketPhone' && Core.Config.Get('Action') !== 'AgentTicketEmail' && Core.Config.Get('Action') !== 'AgentTicketCompose' && Core.Config.Get('Action') !== 'AgentTicketForward') {
                    // set hidden field SelectedCustomerUser
                    $('#SelectedCustomerUser').val(CustomerKey);

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
                    console.log($(this));
                    TargetNS.AddTicketCustomer($Element.attr('id'), CustomerValue, CustomerKey);
                }
            }, 'CustomerSearch');

            if (Core.Config.Get('Action') !== 'AgentTicketPhone' && Core.Config.Get('Action') !== 'AgentTicketEmail' && Core.Config.Get('Action') !== 'AgentTicketCompose' && Core.Config.Get('Action') !== 'AgentTicketForward') {
                $Element.blur(function () {
                    var FieldValue = $(this).val();
                    if (FieldValue !== BackupData.CustomerEmail && FieldValue !== BackupData.CustomerKey) {
                        $('#SelectedCustomerUser').val('');
                        $('#CustomerUserID').val('');
                        $('#CustomerID').val('');
                        $('#CustomerUserOption').val('');
                        $('#ShowCustomerID').html('');

                        // reset customer info table
                        $('#CustomerInfo .Content').html(BackupData.CustomerInfo);

                        if (Core.Config.Get('Action') === 'AgentTicketProcess'){
                            // update services (trigger ServiceID change event)
                            Core.AJAX.FormUpdate($('#CustomerID').closest('form'), 'AJAXUpdate', 'ServiceID', Core.Config.Get('ProcessManagement.UpdatableFields') );
                        }
                    }
                });
            }
            else {
                // initializes the customer fields
                TargetNS.InitCustomerField();
            }
        }

        // On unload remove old selected data. If the page is reloaded (with F5) this data stays in the field and invokes an ajax request otherwise
        $(window).bind('unload', function () {
           $('#SelectedCustomerUser').val('');
        });

        CheckPhoneCustomerCountLimit();
    };


    /**
     * @function
     * @param {String} CustomerValue The readable customer identifier.
     * @param {String} Customerkey on system.
     * @param {String} SetAsTicketCustomer set this customer as main ticket customer.
     * @return nothing
     *      This function add a new ticket customer
     */
    TargetNS.AddTicketCustomer = function (Field, CustomerValue, CustomerKey, SetAsTicketCustomer) {

        if (CustomerValue === '') {
            return false;
        }

        // clone customer entry
        var $Clone = $('.CustomerTicketTemplate' + Field).clone(),
            CustomerTicketCounter = $('#CustomerTicketCounter' + Field).val(),
            TicketCustomerIDs = 0,
            IsDuplicated = false,
            Suffix;

        // check for duplicated entries
        $('[class*=CustomerTicketText]').each(function(index) {
            if ( $(this).val() === CustomerValue ) {
                IsDuplicated = true;
            }
        });
        if (IsDuplicated) {
            TargetNS.ShowDuplicatedDialog(Field);
            return false;
        }

        // get number of how much customer ticket are present
        TicketCustomerIDs = $('.CustomerContainer input:radio').length;

        // increment customer counter
        CustomerTicketCounter ++;

        // set sufix
        Suffix = '_' + CustomerTicketCounter;

        // remove unnecessary classes
        $Clone.removeClass('Hidden CustomerTicketTemplate' + Field);

        // copy values and change ids and names
        $Clone.find(':input').each(function(){
            var ID = $(this).attr('id');
            $(this).attr('id', ID + Suffix);
            $(this).val(CustomerValue);
            if ( ID !== 'CustomerSelected' ) {
                $(this).attr('name', ID + Suffix);
            }

            // add event handler to radio button
            if( $(this).hasClass('CustomerTicketRadio') ) {

                if (TicketCustomerIDs === 0) {
                    $(this).prop('checked', true);
                }

                // set counter as value
                $(this).val(CustomerTicketCounter);

                // bind change function to radio button to select customer
                $(this).bind('change', function () {
                    // remove row
                    if ( $(this).prop('checked') ){

                        TargetNS.ReloadCustomerInfo(CustomerKey);
                    }
                    return false;
                });
            }

            // set customer key if present
            if( $(this).hasClass('CustomerKey') ) {
                $(this).val(CustomerKey);
            }

            // add event handler to remove button
            if( $(this).hasClass('Remove') ) {

                // bind click function to remove button
                $(this).bind('click', function () {
                    // remove row
                    TargetNS.RemoveCustomerTicket( $(this) );
                    return false;
                });
                // set button value
                $(this).val(CustomerValue);
            }

        });
        // show container
        $('#TicketCustomerContent' + Field ).parent().removeClass('Hidden');
        // append to container
        $('#TicketCustomerContent' + Field ).append($Clone);

        // set new value for CustomerTicketCounter
        $('#CustomerTicketCounter' + Field).val(CustomerTicketCounter);
        if ( ( CustomerKey !== '' && TicketCustomerIDs === 0 && ( Field === 'ToCustomer' || Field === 'FromCustomer' ) ) || SetAsTicketCustomer ) {
            if (SetAsTicketCustomer) {
                $('#CustomerSelected_' + CustomerTicketCounter).prop('checked', true).trigger('change');
            }
            else {
                $('.CustomerContainer input:radio:first').prop('checked', true).trigger('change');
            }
        }

        // return value to search field
        $('#' + Field).val('').focus();

        CheckPhoneCustomerCountLimit();

        // reload Crypt options on AgentTicketEMail, AgentTicketCompose and AgentTicketForward
        if ((Core.Config.Get('Action') === 'AgentTicketEmail' || Core.Config.Get('Action') === 'AgentTicketCompose' || Core.Config.Get('Action') === 'AgentTicketForward') && $('#CryptKeyID').length) {
            Core.AJAX.FormUpdate( $('#' + Field).closest('form'), 'AJAXUpdate', '', ['CryptKeyID']);
        }
        return false;
    };

    /**
     * @function
     * @param {jQueryObject} JQuery object used to as base to delete it's parent.
     * @return nothing
     *      This function removes a customer ticket entry
     */
    TargetNS.RemoveCustomerTicket = function (Object) {
        var TicketCustomerIDs = 0,
        TicketCustomerIDsCounter = 0,
        ObjectoToCheck,
        $Field = Object.closest('.Field'),
        $Form;

        if (Core.Config.Get('Action') === 'AgentTicketEmail' || Core.Config.Get('Action') === 'AgentTicketCompose' || Core.Config.Get('Action') === 'AgentTicketForward') {
            $Form = Object.closest('form');
        }
        Object.parent().remove();
        TicketCustomerIDs = $('.CustomerContainer input:radio').length;
        if (TicketCustomerIDs === 0) {
            TargetNS.ResetCustomerInfo();
        }

        // reload Crypt options on AgentTicketEMail, AgentTicketCompose and AgentTicketForward
        if ((Core.Config.Get('Action') === 'AgentTicketEmail' || Core.Config.Get('Action') === 'AgentTicketCompose' || Core.Config.Get('Action') === 'AgentTicketForward') && $('#CryptKeyID').length) {
            Core.AJAX.FormUpdate($Form, 'AJAXUpdate', '', ['CryptKeyID']);
        }

        if( !$('.CustomerContainer input:radio').is(':checked') ){
            //set the first one as checked
            $('.CustomerContainer input:radio:first').prop('checked', true).trigger('change');
        }

        if ($Field.find('.CustomerTicketText:visible').length === 0) {
            $Field.addClass('Hidden');
        }

        CheckPhoneCustomerCountLimit();
    };

    /**
     * @function
     * @return nothing
     *      This function clear all selected customer info
     */
    TargetNS.ResetCustomerInfo = function () {

            $('#SelectedCustomerUser').val('');
            $('#CustomerUserID').val('');
            $('#CustomerID').val('');
            $('#CustomerUserOption').val('');
            $('#ShowCustomerID').html('');

            // reset customer info table
            $('#CustomerInfo .Content').html('none');
    };

    /**
     * @function
     * @param {String} Customerkey on system.
     * @return nothing
     *      This function reloads info for selected customer
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
     * @function
     * @return nothing
     *      This function initializes the customer fields
     */
    TargetNS.InitCustomerField = function () {

        // loop over the field with CustomerAutoComplete class
        $('.CustomerAutoComplete').each(function(index) {
            var ObjectId = $(this).attr('id');

            $('#' + ObjectId).bind('change', function () {

                if ( !$('#' + ObjectId).val() || $('#' + ObjectId).val() === '') {
                    return false;
                }

                // If the autocomplete popup window is visible, delay this change event.
                // It might be caused by clicking with the mouse into the autocomplete list.
                // Wait until it is closed to be sure that we don't add a customer twice.

                if ( $(this).autocomplete("widget").is(':visible') ) {
                    window.setTimeout(function(){
                        $('#' + ObjectId).trigger('change');
                    }, 200);
                    return false;
                }

                Core.Agent.CustomerSearch.AddTicketCustomer( ObjectId, $('#' + ObjectId).val() );
                return false;
            });

            $('#' + ObjectId).bind('keypress', function (e) {
                if (e.which === 13){
                    Core.Agent.CustomerSearch.AddTicketCustomer( ObjectId, $('#' + ObjectId).val() );
                    return false;
                }
            });
        });
    };

    /**
     * @function
     * @param {string} Field ID object of the element should receive the focus on close event.
     * @return nothing
     *      This function shows an alert dialog for duplicated entries.
     */
    TargetNS.ShowDuplicatedDialog = function(Field){
        Core.UI.Dialog.ShowAlert(
            Core.Config.Get('Duplicated.TitleText'),
            Core.Config.Get('Duplicated.ContentText') + ' ' + Core.Config.Get('Duplicated.RemoveText'),
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
