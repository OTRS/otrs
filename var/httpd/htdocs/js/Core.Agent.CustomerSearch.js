// --
// Core.Agent.CustomerSearch.js - provides the special module functions for the customer search
// Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
// --
// $Id: Core.Agent.CustomerSearch.js,v 1.21 2011-11-01 23:04:09 cg Exp $
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

            // show customer info
            $('#CustomerInfo .Content').html(Response.CustomerTableHTMLString);

            // only execute this part, if in AgentTicketEmail or AgentTicketPhone
            if (Core.Config.Get('Action') === 'AgentTicketEmail' || Core.Config.Get('Action') === 'AgentTicketPhone') {
                // reset service
                $('#ServiceID').attr('selectedIndex', 0);
                // update services (trigger ServiceID change event)
                Core.AJAX.FormUpdate($('#CustomerID').closest('form'), 'AJAXUpdate', 'ServiceID', ['Dest', 'SelectedCustomerUser', 'NextStateID', 'PriorityID', 'ServiceID', 'SLAID', 'CryptKeyID', 'OwnerAll', 'ResponsibleAll', 'TicketFreeText1', 'TicketFreeText2', 'TicketFreeText3', 'TicketFreeText4', 'TicketFreeText5', 'TicketFreeText6', 'TicketFreeText7', 'TicketFreeText8', 'TicketFreeText9', 'TicketFreeText10', 'TicketFreeText11', 'TicketFreeText12', 'TicketFreeText13', 'TicketFreeText14', 'TicketFreeText15', 'TicketFreeText16']);
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
        if (!parseInt(Core.Config.Get('Autocomplete.ShowCustomerTickets'), 10)) {
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
            if ($('#FixedTable').length) {
                Core.UI.InitTableHead($('#FixedTable thead'), $('#FixedTable tbody'));
                Core.UI.StaticTableControl($('#OverviewControl').add($('#OverviewBody')));
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
     * @param {jQueryObject} $Element The jQuery object of the input field with autocomplete
     * @param {Boolean} ActiveAutoComplete Set to false, if autocomplete should only be started by click on a button next to the input field
     * @return nothing
     *      This function initializes the special module functions
     */
    TargetNS.Init = function ($Element, ActiveAutoComplete) {
        // get customer tickets for AgentTicketCustomer
        if (Core.Config.Get('Action') === 'AgentTicketCustomer') {
            GetCustomerTickets($('#CustomerAutoComplete').val(), $('#CustomerID').val());
        }

        // get customer tickets for AgentTicketPhone and AgentTicketEmail
        if ((Core.Config.Get('Action') === 'AgentTicketEmail' || Core.Config.Get('Action') === 'AgentTicketPhone') && $('#SelectedCustomerUser').val() !== '') {
            GetCustomerTickets($('#SelectedCustomerUser').val());
        }

        if (typeof ActiveAutoComplete === 'undefined') {
            ActiveAutoComplete = true;
        }
        else {
            ActiveAutoComplete = !!ActiveAutoComplete;
        }

        // just save the initial state of the customer info
        if ($('#CustomerInfo').length) {
            BackupData.CustomerInfo = $('#CustomerInfo .Content').html();
        }

        if (isJQueryObject($Element)) {
            $Element.autocomplete({
                minLength: ActiveAutoComplete ? Core.Config.Get('Autocomplete.MinQueryLength') : 500,
                delay: Core.Config.Get('Autocomplete.QueryDelay'),
                source: function (Request, Response) {
                    var URL = Core.Config.Get('Baselink'), Data = {
                        Action: 'AgentCustomerSearch',
                        Term: Request.term,
                        MaxResults: Core.Config.Get('Autocomplete.MaxResultsDisplayed')
                    };
                    Core.AJAX.FunctionCall(URL, Data, function (Result) {
                        var Data = [];
                        $.each(Result, function () {
                            Data.push({
                                label: this.CustomerValue + " (" + this.CustomerKey + ")",
                                value: this.CustomerValue
                            });
                        });
                        Response(Data);
                    });
                },
                select: function (Event, UI) {
                    var CustomerKey = UI.item.label.replace(/.*\((.*)\)$/, '$1'),
                    CustomerValue = UI.item.value;
                    BackupData.CustomerKey = CustomerKey;
                    BackupData.CustomerEmail = UI.item.value;

                    $Element.val(UI.item.value);

                    if (Core.Config.Get('Action') === 'AgentTicketEmail' ) {
                        $Element.val('');
                    }

                    if (Core.Config.Get('Action') !== 'AgentTicketPhone' && Core.Config.Get('Action') !== 'AgentTicketEmail') {
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
                        TargetNS.AddTicketCustomer($(this).attr('id'), CustomerValue, CustomerKey);
                    }

                    Event.preventDefault();
                    return false;
                }
            });

            if (Core.Config.Get('Action') !== 'AgentTicketPhone' && Core.Config.Get('Action') !== 'AgentTicketEmail') {
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
                    }
                });
            }

            // Special treatment for the new ticket masks only
            if (Core.Config.Get('Action') === 'AgentTicketPhone' || Core.Config.Get('Action') === 'AgentTicketEmail') {

                // If the field was already prefilled, but a customer user could not be found on the server side,
                //  the auto complete should be fired to give the user a selection of possible matches to choose from.
                if (ActiveAutoComplete && $Element.val() && $Element.val().length && !$('#SelectedCustomerUser').val().length) {
                    $($Element).focus().autocomplete('search', $Element.val());
                }
            }

            if (!ActiveAutoComplete) {
                $Element.after('<button id="' + $Element.attr('id') + 'Search" type="button">' + Core.Config.Get('Autocomplete.SearchButtonText') + '</button>');
                $('#' + $Element.attr('id') + 'Search').click(function () {
                    $Element.autocomplete("option", "minLength", 0);
                    $Element.autocomplete("search");
                    $Element.autocomplete("option", "minLength", 500);
                });
            }
        }

        // On unload remove old selected data. If the page is reloaded (with F5) this data stays in the field and invokes an ajax request otherwise
        $(window).bind('unload', function () {
           $('#SelectedCustomerUser').val('');
        });
    };


    /**
     * @function
     * @param {String} CustomerValue The readable customer identifier.
     * @param {String} Customerkey on system.
     * @return nothing
     *      This function add a new ticket customer
     */
    TargetNS.AddTicketCustomer = function (Field, CustomerValue, CustomerKey) {

        if (CustomerValue === '') {
            return false;
        }

        // clone customer entry
        var $Clone = $('.CustomerTicketTemplate' + Field).clone(),
            CustomerTicketCounter = $('#CustomerTicketCounter' + Field).val(),
            TicketCustomerIDs = 0,
            Sufix;

        // get number of how much customer ticket are present
        TicketCustomerIDs = $('.CustomerContainer input:radio').length;

        // increment customer counter
        CustomerTicketCounter ++;

        // set sufix
        Sufix = '_' + CustomerTicketCounter;

        // remove unnecessary classes
        $Clone.removeClass('Hidden CustomerTicketTemplate' + Field);

        // copy values and change ids and names
        $Clone.find(':input').each(function(){
            var ID = $(this).attr('id');
            $(this).attr('id', ID + Sufix);
            $(this).val(CustomerValue);
            if ( ID !== 'CustomerSelected' ) {
                $(this).attr('name', ID + Sufix);
            }

            // add event handler to radio button
            if( $(this).hasClass('CustomerTicketRadio') ) {

                if (TicketCustomerIDs === 0) {
                    $(this).attr('checked', 'checked');
                }

                // set counter as value
                $(this).val(CustomerTicketCounter);

                // bind change function to radio button to select customer
                $(this).bind('change', function () {
                    // remove row
                    if ( $(this).attr('checked') ){

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
        if ( CustomerKey !== '' && TicketCustomerIDs === 0 && ( Field === 'ToCustomer' || Field === 'FromCustomer' ) ) {

            $('.CustomerContainer input:radio:first').attr('checked', 'checked').trigger('change');
        }

        // return value to search field
        $('#' + Field).val('').focus();
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
        ObjectoToCheck;

        Object.parent().remove();
        TicketCustomerIDs = $('.CustomerContainer input:radio').length;
        if (TicketCustomerIDs === 0) {
            TargetNS.ResetCustomerInfo();
        }

        if( !$('.CustomerContainer input:radio').is(':checked') ){
            //set the first one as checked
            $('.CustomerContainer input:radio:first').attr('checked', 'checked').trigger('change');
        }
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

    return TargetNS;
}(Core.Agent.CustomerSearch || {}));
