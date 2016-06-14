// --
// Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};

/**
 * @namespace Core.Agent.Book
 * @memberof Core.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for AgentBook module.
 */
 Core.Agent.Book = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Book
     * @function
     * @description
     *      This function initializes click events in Address book.
     */
    TargetNS.Init = function () {
        var AddressBook = Core.Config.Get('AddressBook'),
            AddressBookCount;

        // initialize the necessary stuff for address book
        Core.Agent.TicketAction.InitAddressBook();

        if (AddressBook) {
            for (AddressBookCount in AddressBook) {
                Core.Data.Set($('#Row' + AddressBookCount), 'Email', AddressBook[AddressBookCount]);
            }
        }
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
 }(Core.Agent.Book || {}));
