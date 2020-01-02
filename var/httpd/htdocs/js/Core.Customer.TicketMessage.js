// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
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
            DynamicFieldNames = Core.Config.Get('DynamicFieldNames'),
            Fields = ['TypeID', 'Dest', 'PriorityID', 'ServiceID', 'SLAID'],
            ModifiedFields;

        // Bind events to specific fields
        $.each(Fields, function(Index, Value) {
            ModifiedFields = Core.Data.CopyObject(Fields).concat(DynamicFieldNames);
            ModifiedFields.splice(Index, 1);

            FieldUpdate(Value, ModifiedFields);
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

   /**
     * @private
     * @name FieldUpdate
     * @memberof Core.Customer.TicketMessage.Init
     * @function
     * @param {String} Value - FieldID
     * @param {Array} ModifiedFields - Fields
     * @description
     *      Create on change event handler
     */
    function FieldUpdate (Value, ModifiedFields) {
        $('#' + Value).on('change', function () {
            Core.AJAX.FormUpdate($('#NewCustomerTicket'), 'AJAXUpdate', Value, ModifiedFields);
        });
    }

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Customer.TicketMessage || {}));
