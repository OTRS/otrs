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
 * @namespace Core.Agent.TicketForward
 * @memberof Core.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains the TicketForward functions.
 */
Core.Agent.TicketForward = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.TicketForward
     * @function
     * @description
     *      This function initializes the functionality for the TicketForward screen.
     */
    TargetNS.Init = function () {

        var $Form,
            FieldID,
            DynamicFieldNames = Core.Config.Get('DynamicFieldNames');

        // remove a customer ticket entry
        $('.CustomerTicketRemove').on('click', function () {
            Core.Agent.CustomerSearch.RemoveCustomerTicket($(this));
            return false;
        });

        // delete attachment
        $('button[id*=AttachmentDeleteButton]').on('click', function () {
            $Form = $(this).closest('form');
            FieldID = $(this).attr('id').split('AttachmentDeleteButton')[1];
            $('#AttachmentDelete' + FieldID).val(1);
            Core.Form.Validate.DisableValidation($Form);
            $Form.trigger('submit');
        });

        // choose attachment
        $('#FileUpload').on('change', function () {
            $Form = $(this).closest('form');
            Core.Form.Validate.DisableValidation($Form);
            $Form.find('#AttachmentUpload').val('1').end().submit();
        });

        // update dynamic fields in form
        $('#ComposeStateID').on('change', function () {
            Core.AJAX.FormUpdate($('#Compose'), 'AJAXUpdate', 'ComposeStateID', DynamicFieldNames);
        });

        // initialize the ticket action popup
        Core.Agent.TicketAction.Init();

    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.TicketForward || {}));
