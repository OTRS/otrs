// --
// Core.Agent.CustomerSearch.js - provides the special module functions for the customer search
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.Agent.CustomerSearch.js,v 1.1 2010-06-09 09:27:45 mn Exp $
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
    }

    function ReplaceOverviewControlLinks () {
        var $ControlLinks = $('#CustomerTickets ul.OverviewZoom li a');
        $ControlLinks.each(function() {
            Core.UI.RegisterEvent('click', $(this), function (Event) {
                var Link = $(this).attr('href'),
                    Data = {};

                // Extract parameters from URL
                // ?? needed ??

                Core.AJAX.FunctionCall(Link, Data, function(Response) {
                    // show customer tickets
                    if ($('#CustomerTickets').length) {
                        $('#CustomerTickets').html(Response.CustomerTicketsHTMLString);
                        ReplaceOverviewControlLinks();
                    }
                });
                return false;
            });
        });
    }

    function GetCustomerInfo(CustomerUserID) {
        var Data = {
            Action: 'AgentCustomerSearch',
            Subaction: 'CustomerInfo',
            CustomerUserID: CustomerUserID || 1
        };
        Core.AJAX.FunctionCall(Core.Config.Get('Baselink'), Data, function(Response) {
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
                // TODO: Korrekter Formname
                Core.AJAX.FormUpdate($('form'), 'AJAXUpdate', 'ServiceID', ['Dest', 'SelectedCustomerUser', 'NextStateID', 'PriorityID', 'ServiceID', 'SLAID', 'OwnerAll', 'ResponsibleAll', 'TicketFreeText1', 'TicketFreeText2', 'TicketFreeText3', 'TicketFreeText4', 'TicketFreeText5', 'TicketFreeText6', 'TicketFreeText7', 'TicketFreeText8', 'TicketFreeText9', 'TicketFreeText10', 'TicketFreeText11', 'TicketFreeText12', 'TicketFreeText13', 'TicketFreeText14', 'TicketFreeText15', 'TicketFreeText16'], ['NewUserID', 'NewResponsibleID', 'NextStateID', 'PriorityID', 'ServiceID', 'SLAID', 'TicketFreeText1', 'TicketFreeText2', 'TicketFreeText3', 'TicketFreeText4', 'TicketFreeText5', 'TicketFreeText6', 'TicketFreeText7', 'TicketFreeText8', 'TicketFreeText9', 'TicketFreeText10', 'TicketFreeText11', 'TicketFreeText12', 'TicketFreeText13', 'TicketFreeText14', 'TicketFreeText15', 'TicketFreeText16']);
            }
        });
    }

    function GetCustomerTickets(CustomerUserID, CustomerID) {
        // check if customer tickets should be shown
        if (isNaN(parseInt(Core.Config.Get('Autocomplete.ShowCustomerTickets')))) {
            return;
        }

        var Data = {
            Action: 'AgentCustomerSearch',
            Subaction: 'CustomerTickets',
            CustomerUserID: CustomerUserID,
            CustomerID: CustomerID
        };
        Core.AJAX.FunctionCall(Core.Config.Get('Baselink'), Data, function(Response) {
            // show customer tickets
            if ($('#CustomerTickets').length) {
                $('#CustomerTickets').html(Response.CustomerTicketsHTMLString);
                ReplaceOverviewControlLinks();
            }
        });
    }

    /**
     * @function
     * @return nothing
     *      This function initializes the special module functions
     */
    TargetNS.Init = function($Element) {
        // get customer tickets for AgentTicketCustomer
        if (Core.Config.Get('Action') === 'AgentTicketCustomer') {
            GetCustomerTickets($('#CustomerUserID').val(), $('#CustomerID').val());
        }

        // get customer tickets for AgentTicketPhone and AgentTicketEmail
        if (Core.Config.Get('Action') === 'AgentTicketEmail' || Core.Config.Get('Action') === 'AgentTicketPhone') {
            GetCustomerTickets($('#SelectedCustomerUser').val());
        }

        // just save the initial state of the customer info
        if ($('#CustomerInfo').length) {
            BackupData.CustomerInfo = $('#CustomerInfo .Content').html();
        }

        if (isJQueryObject($Element)) {
            $Element.autocomplete({
                minLength: Core.Config.Get('Autocomplete.MinQueryLength'),
                delay: Core.Config.Get('Autocomplete.QueryDelay'),
                source: function(Request, Response){
                    var URL = Core.Config.Get('Baselink'), Data = {
                        Action: 'AgentCustomerSearch',
                        Term: Request.term,
                        MaxResults: Core.Config.Get('Autocomplete.MaxResultsDisplayed')
                    };
                    Core.AJAX.FunctionCall(URL, Data, function(Result){
                        var Data = [];
                        $.each(Result, function(){
                            Data.push({
                                label: this.CustomerValue + " (" + this.CustomerKey + ")",
                                value: this.CustomerValuePlain
                            });
                        });
                        Response(Data);
                    });
                },
                select: function(Event, UI){
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
            $Element.blur(function() {
                var FieldValue = $(this).val();
                if (FieldValue != BackupData.CustomerEmail && FieldValue != BackupData.CustomerKey) {
                    $('#SelectedCustomerUser').val('');
                    $('#CustomerUserID').val('');
                    $('#CustomerID').val('');
                    $('#CustomerUserOption').val('');
                    $('#CustomerTickets').empty();
                    $('#ShowCustomerID').html('');

                    // show customer info table
                    $('#CustomerInfo .Content').html(BackupData.CustomerInfo);
                }
            });
        }






/*
        var URL = Core.Config.Get('Baselink');
        $("#myAutoCompleteInput").autocomplete(sURL, {
            delay:          $QData{"queryDelay"},
            extraParams:    {
                                Action: 'AgentCustomerSearch'
                            },
            max:            $QData{"maxResultsDisplayed"},
            minChars:       $QData{"minQueryLength"},
            formatItem:     function(Row) {
                                var CustomerKey = Row[0];
                                var CustomerValue = Row[1];
                                var SearchOutput = CustomerValue + " (" + CustomerKey + ")";
                                // adjust width of result container, only when dynamic width is enabled
                                if ( parseInt('$Config{"Ticket::Frontend::CustomerSearchAutoComplete::DynamicWidth"}') ) {
                                    var DummyElement = $('<div id="DummyElement" style="visibility:hidden"><span>' + SearchOutput + '</span></div>').appendTo('body');
                                    var ResultWidth = DummyElement.find('span').width();
                                    DummyElement.remove();

                                    var ContainerWidth = $('div.ac_results').width();
                                    if ( ResultWidth > ContainerWidth) {
                                       $("#myAutoCompleteInput").setOptions( { width: ResultWidth } );
                                    }
                                }
                                return SearchOutput;
                            },
            formatResult:   function(Data) {
                                var CustomerValuePlain = Data[2];
                                return CustomerValuePlain;
                            }
        });
        $("#myAutoCompleteInput").result(function(event, data, formatted) {
            var CustomerKey = data[0];
            CustomerKeyBackup = data[0];
            CustomerEmailBackup = data[2];

            // set hidden field SelectedCustomerUser
            if (document.compose.SelectedCustomerUser) {
                document.compose.SelectedCustomerUser.value = CustomerKey;
            }

            // needed for AgentTicketCustomer.pm
            if (document.compose.CustomerUserID) {
                document.compose.CustomerUserID.value = CustomerKey;

                // set hidden field 'CustomerUserOption'
                var input = document.createElement('input');
                input.setAttribute("type", "hidden");
                input.setAttribute("name", "CustomerUserOption");
                input.value = CustomerKey;
                document.compose.appendChild(input);
            }

            // get customer tickets
            GetCustomerTickets(CustomerKey);

            // get customer data for customer info table
            GetCustomerInfo(CustomerKey);
        });

        $("#myAutoCompleteInput").blur(function() {
            var FieldValue = $('#myAutoCompleteInput').val();
            if (FieldValue != CustomerEmailBackup && FieldValue != CustomerKeyBackup) {
                if (document.compose.SelectedCustomerUser) {
                    document.compose.SelectedCustomerUser.value = '';
                }
                if (document.compose.CustomerUserID) {
                    document.compose.CustomerUserID.value = '';
                }
                if (document.compose.CustomerID) {
                    document.compose.CustomerID.value = '';
                }
                if (document.compose.CustomerUserOption) {
                    document.compose.CustomerUserOption.value = '';
                }

                $('#CustomerTickets').empty();

                if ( document.getElementById('ShowCustomerID') ) {
                    document.getElementById('ShowCustomerID').innerHTML = '';
                }

                // show customer info table
                if ( document.getElementById('CustomerTable') ) {
                    document.getElementById('CustomerTable').innerHTML = CustomerInfoBackup;
                }
            }
        });
*/
    }

    return TargetNS;
}(Core.Agent.CustomerSearch || {}));