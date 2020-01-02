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
 * @namespace Core.Agent.TicketCompose
 * @memberof Core.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for TicketCompose.
 */
Core.Agent.TicketCompose = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.TicketCompose
     * @function
     * @description
     *      This function initializes .
     */
    TargetNS.Init = function () {

        var ArticleComposeOptions = Core.Config.Get('ArticleComposeOptions'),
            EmailAddressesTo = Core.Config.Get('EmailAddressesTo'),
            EmailAddressesCc = Core.Config.Get('EmailAddressesCc');

        // remove customer user
        $('.CustomerTicketRemove').on('click', function () {
            Core.Agent.CustomerSearch.RemoveCustomerTicket($(this));
            return false;
        });

        // change next ticket state
        $('#StateID').on('change', function () {
            Core.AJAX.FormUpdate($('#ComposeTicket'), 'AJAXUpdate', 'StateID', Core.Config.Get('DynamicFieldNames'));
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

        // change article compose options
        if (typeof ArticleComposeOptions !== 'undefined') {
            $.each(ArticleComposeOptions, function (Key, Value) {
                $('#'+Value.Name).on('change', function () {
                    Core.AJAX.FormUpdate($('#ComposeTicket'), 'AJAXUpdate', Value.Name, Value.Fields);
                });
            });
        }
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.TicketCompose || {}));
