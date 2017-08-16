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

/**
 * @namespace Core.Agent.TicketEmailResend
 * @memberof Core.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for TicketEmailResend.
 */
Core.Agent.TicketEmailResend = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.TicketEmailResend
     * @function
     * @description
     *      This function initializes .
     */
    TargetNS.Init = function () {
        var ArticleComposeOptions = Core.Config.Get('ArticleComposeOptions'),
            EmailAddressesTo = Core.Config.Get('EmailAddressesTo'),
            EmailAddressesCc = Core.Config.Get('EmailAddressesCc'),
            EmailAddressesBcc = Core.Config.Get('EmailAddressesBcc');

        // Initialize the ticket action popup.
        Core.Agent.TicketAction.Init();

        // Remove customer user.
        $('.CustomerTicketRemove').on('click', function () {
            Core.Agent.CustomerSearch.RemoveCustomerTicket($(this));
            return false;
        });

        // add 'To' customer users
        if (typeof EmailAddressesTo !== 'undefined') {
            EmailAddressesTo.forEach(function(ToCustomer) {
                Core.Agent.CustomerSearch.AddTicketCustomer('ToCustomer', ToCustomer.CustomerTicketText, ToCustomer.CustomerKey);
            });
        }

        // add 'Cc' customer users
        if (typeof EmailAddressesCc !== 'undefined') {
            EmailAddressesCc.forEach(function(CcCustomer) {
                Core.Agent.CustomerSearch.AddTicketCustomer('CcCustomer', CcCustomer.CustomerTicketText, CcCustomer.CustomerKey);
            });
        }

        // add 'BCc' customer users
        if (typeof EmailAddressesCc !== 'undefined') {
            EmailAddressesBcc.forEach(function(BccCustomer) {
                Core.Agent.CustomerSearch.AddTicketCustomer('BccCustomer', BccCustomer.CustomerTicketText, BccCustomer.CustomerKey);
            });
        }

        // Change article compose options.
        if (typeof ArticleComposeOptions !== 'undefined') {
            $.each(ArticleComposeOptions, function (Key, Value) {
                $('#'+Value.Name).on('change', function () {
                    Core.AJAX.FormUpdate($('#NewEmailTicket'), 'AJAXUpdate', Value.Name, Value.Fields);
                });
            });
        }
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.TicketEmailResend || {}));
