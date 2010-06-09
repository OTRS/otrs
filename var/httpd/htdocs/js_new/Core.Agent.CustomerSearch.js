// --
// Core.Agent.CustomerSearch.js - provides the special module functions for the customer search
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.Agent.CustomerSearch.js,v 1.2 2010-06-09 10:58:37 mn Exp $
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
                Core.AJAX.FormUpdate($('#CustomerID').closest('form'), 'AJAXUpdate', 'ServiceID', ['Dest', 'SelectedCustomerUser', 'NextStateID', 'PriorityID', 'ServiceID', 'SLAID', 'OwnerAll', 'ResponsibleAll', 'TicketFreeText1', 'TicketFreeText2', 'TicketFreeText3', 'TicketFreeText4', 'TicketFreeText5', 'TicketFreeText6', 'TicketFreeText7', 'TicketFreeText8', 'TicketFreeText9', 'TicketFreeText10', 'TicketFreeText11', 'TicketFreeText12', 'TicketFreeText13', 'TicketFreeText14', 'TicketFreeText15', 'TicketFreeText16'], ['NewUserID', 'NewResponsibleID', 'NextStateID', 'PriorityID', 'ServiceID', 'SLAID', 'TicketFreeText1', 'TicketFreeText2', 'TicketFreeText3', 'TicketFreeText4', 'TicketFreeText5', 'TicketFreeText6', 'TicketFreeText7', 'TicketFreeText8', 'TicketFreeText9', 'TicketFreeText10', 'TicketFreeText11', 'TicketFreeText12', 'TicketFreeText13', 'TicketFreeText14', 'TicketFreeText15', 'TicketFreeText16']);
            }
        });
    }

    /**
     * @function
     * @return nothing
     *      This function initializes the special module functions
     */
    TargetNS.Init = function($Element) {
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
                    $('#ShowCustomerID').html('');

                    // reset customer info table
                    $('#CustomerInfo .Content').html(BackupData.CustomerInfo);
                }
            });
        }
    }

    return TargetNS;
}(Core.Agent.CustomerSearch || {}));