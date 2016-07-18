// --
// Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.Customer = Core.Customer || {};

/**
 * @namespace Core.Customer.TicketMessage
 * @memberof Core.Customer
 * @author OTRS AG
 * @description
 *      This namespace contains module functions for CustomerTicketMessage.
 */
Core.Customer.TicketMessage = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Customer.TicketMessage
     * @function
     * @description
     *      This function initializes module functionality.
     */
    TargetNS.Init = function(){

        var $Form,
            FieldID,
            DynamicFieldNames = Core.Config.Get('DynamicFieldNames');

        // bind event to Type field
        $('#TypeID').on('change', function () {
            Core.AJAX.FormUpdate($('#NewCustomerTicket'), 'AJAXUpdate', 'TypeID', ['Dest', 'PriorityID', 'ServiceID', 'SLAID'].concat(DynamicFieldNames));
        });

        // bind event to Dest field (Queue)
        $('#Dest').on('change', function () {
            Core.AJAX.FormUpdate($('#NewCustomerTicket'), 'AJAXUpdate', 'Dest', ['TypeID', 'PriorityID', 'ServiceID', 'SLAID'].concat(DynamicFieldNames));
        });

        // bind event to Service field
        $('#ServiceID').on('change', function () {
            Core.AJAX.FormUpdate($('#NewCustomerTicket'), 'AJAXUpdate', 'ServiceID', ['TypeID', 'Dest', 'PriorityID', 'SLAID'].concat(DynamicFieldNames));
        });

        // bind event to SLA field
        $('#SLAID').on('change', function () {
            Core.AJAX.FormUpdate($('#NewCustomerTicket'), 'AJAXUpdate', 'SLAID', ['TypeID', 'Dest', 'ServiceID', 'PriorityID', 'SignKeyID', 'CryptKeyID'].concat(DynamicFieldNames));
        });

        // bind event to Priority field
        $('#PriorityID').on('change', function () {
            Core.AJAX.FormUpdate($('#NewCustomerTicket'), 'AJAXUpdate', 'PriorityID', ['TypeID', 'Dest', 'ServiceID', 'SLAID'].concat(DynamicFieldNames));
        });

        // choose attachment
        $('#Attachment').on('change', function () {
            $Form = $('#Attachment').closest('form');
            Core.Form.Validate.DisableValidation($Form);
            $Form.find('#AttachmentUpload').val('1').end().submit();
        });

        // delete attachment
        $('button[id*=AttachmentDeleteButton]').on('click', function () {
            $Form = $(this).closest('form');
            FieldID = $(this).attr('id').split('AttachmentDeleteButton')[1];
            $('#AttachmentDelete' + FieldID).val(1);
            Core.Form.Validate.DisableValidation($Form);
            $Form.trigger('submit');
        });

    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Customer.TicketMessage || {}));
