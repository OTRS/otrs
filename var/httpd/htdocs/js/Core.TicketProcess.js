// --
// Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};

/**
 * @namespace Core.TicketProcess
 * @memberof Core
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for TicketProcesses in Agent and Customer interface.
 */
Core.TicketProcess = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.TicketProcess
     * @function
     * @description
     *      This function binds event on different fields to trigger AJAX form update on the other fields.
     */
    TargetNS.Init = function () {

        // Bind event on Type field
        if (typeof Core.Config.Get('TypeFieldsToUpdate') !== 'undefined') {
            $('#TypeID').on('change', function () {
                Core.AJAX.FormUpdate($(this).parents('form'), 'AJAXUpdate', 'TypeID' , Core.Config.Get('TypeFieldsToUpdate'));
            });
        }

        // Bind event on State field
        if (typeof Core.Config.Get('StateFieldsToUpdate') !== 'undefined') {
            $('#StateID').on('change', function () {
                Core.AJAX.FormUpdate($(this).parents('form'), 'AJAXUpdate', 'StateID' , Core.Config.Get('StateFieldsToUpdate'));
            });
        }

        // Bind event on SLA field
        if (typeof Core.Config.Get('SLAFieldsToUpdate') !== 'undefined') {
            $('#SLAID').on('change', function () {
                Core.AJAX.FormUpdate($(this).parents('form'), 'AJAXUpdate', 'SLAID' , Core.Config.Get('SLAFieldsToUpdate'));
            });
        }

        // Bind event on Service field
        if (typeof Core.Config.Get('ServiceFieldsToUpdate') !== 'undefined') {
            $('#ServiceID').on('change', function () {
                Core.AJAX.FormUpdate($(this).parents('form'), 'AJAXUpdate', 'ServiceID' , Core.Config.Get('ServiceFieldsToUpdate'));
            });
        }
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.TicketProcess || {}));
