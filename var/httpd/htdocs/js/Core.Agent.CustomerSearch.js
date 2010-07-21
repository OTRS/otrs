// --
// Core.Agent.CustomerSearch.js - provides the special module functions for the customer search
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.Agent.CustomerSearch.js,v 1.5 2010-07-21 06:04:33 cg Exp $
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
                Core.AJAX.FormUpdate($('#CustomerID').closest('form'), 'AJAXUpdate', 'ServiceID', ['Dest', 'SelectedCustomerUser', 'NextStateID', 'PriorityID', 'ServiceID', 'SLAID', 'OwnerAll', 'ResponsibleAll', 'TicketFreeText1', 'TicketFreeText2', 'TicketFreeText3', 'TicketFreeText4', 'TicketFreeText5', 'TicketFreeText6', 'TicketFreeText7', 'TicketFreeText8', 'TicketFreeText9', 'TicketFreeText10', 'TicketFreeText11', 'TicketFreeText12', 'TicketFreeText13', 'TicketFreeText14', 'TicketFreeText15', 'TicketFreeText16'], ['NewUserID', 'NewResponsibleID', 'NextStateID', 'PriorityID', 'ServiceID', 'SLAID', 'TicketFreeText1', 'TicketFreeText2', 'TicketFreeText3', 'TicketFreeText4', 'TicketFreeText5', 'TicketFreeText6', 'TicketFreeText7', 'TicketFreeText8', 'TicketFreeText9', 'TicketFreeText10', 'TicketFreeText11', 'TicketFreeText12', 'TicketFreeText13', 'TicketFreeText14', 'TicketFreeText15', 'TicketFreeText16']);
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
        if (isNaN(parseInt(Core.Config.Get('Autocomplete.ShowCustomerTickets'), 10))) {
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
            $('#CustomerTickets').find('.OverviewZoom a, .Pagination a').click(function () {
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
            GetCustomerTickets($('#CustomerUserID').val(), $('#CustomerID').val());
        }

        // get customer tickets for AgentTicketPhone and AgentTicketEmail
        if (Core.Config.Get('Action') === 'AgentTicketEmail' || Core.Config.Get('Action') === 'AgentTicketPhone') {
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
                                value: this.CustomerValuePlain
                            });
                        });
                        Response(Data);
                    });
                },
                select: function (Event, UI) {
                    var CustomerKey = UI.item.label.replace(/.*\((.*)\)$/, '$1');
                    BackupData.CustomerKey = CustomerKey;
                    BackupData.CustomerEmail = UI.item.value;

                    $Element.val(UI.item.value);

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

                    return false;
                }
            });
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
            if (!ActiveAutoComplete) {
                $Element.after('<button id="' + $Element.attr('id') + 'Search" type="button">' + Core.Config.Get('Autocomplete.SearchButtonText') + '</button>');
                $('#' + $Element.attr('id') + 'Search').click(function () {
                    $Element.autocomplete("option", "minLength", 0);
                    $Element.autocomplete("search");
                    $Element.autocomplete("option", "minLength", 500);
                });
            }
        }
    };

    return TargetNS;
}(Core.Agent.CustomerSearch || {}));