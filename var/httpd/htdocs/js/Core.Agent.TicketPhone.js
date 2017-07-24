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
 * @namespace Core.Agent.TicketPhone
 * @memberof Core.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains special module functions for TicketPhone.
 */
Core.Agent.TicketPhone = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.TicketPhone
     * @function
     * @description
     *      This function initializes the module functionality.
     */
    TargetNS.Init = function () {

        var $Form,
            FieldID,
            DynamicFieldNames = Core.Config.Get('DynamicFieldNames'),
            FromExternalCustomerName = Core.Config.Get('FromExternalCustomerName'),
            FromExternalCustomerEmail = Core.Config.Get('FromExternalCustomerEmail'),
            Fields = ['TypeID', 'Dest', 'NewUserID', 'NewResponsibleID', 'NextStateID', 'PriorityID', 'ServiceID', 'SLAID'],
            ModifiedFields;

        // Bind event to customer radio button.
        $('.CustomerTicketRadio').on('change', function () {
            var CustomerKey;
            if ($(this).prop('checked')){

                CustomerKey = $('#CustomerKey_' +$(this).val()).val();
                // get customer tickets
                Core.Agent.CustomerSearch.ReloadCustomerInfo(CustomerKey);
            }
            return false;
        });

        // Bind event to customer remove button.
        $('.CustomerTicketRemove').on('click', function () {
            Core.Agent.CustomerSearch.RemoveCustomerTicket($(this));
            return false;
        });

        // Add ticket customer from external source.
        if (typeof FromExternalCustomerEmail !== 'undefined' &&
            typeof FromExternalCustomerName !== 'undefined') {
                Core.Agent.CustomerSearch.AddTicketCustomer('FromCustomer', FromExternalCustomerEmail, FromExternalCustomerName, true);
        }

        // Bind events to specific fields
        $.each(Fields, function(Index, Value) {
            ModifiedFields = Core.Data.CopyObject(Fields).concat(DynamicFieldNames);
            ModifiedFields.splice(Index, 1);

            FieldUpdate(Value, ModifiedFields);
        });

        // Bind event to OwnerSelection get all button.
        $('#OwnerSelectionGetAll').on('click', function () {
            $('#OwnerAll').val('1');
            Core.AJAX.FormUpdate($('#NewPhoneTicket'), 'AJAXUpdate', 'OwnerAll', ['NewUserID'], function() {
                $('#NewUserID').focus();
            });
            return false;
        });

        // Bind event to ResponsibleSelection get all button.
        $('#ResponsibleSelectionGetAll').on('click', function () {
            $('#ResponsibleAll').val('1');
            Core.AJAX.FormUpdate($('#NewPhoneTicket'), 'AJAXUpdate', 'ResponsibleAll', ['NewResponsibleID'], function() {
                $('#NewResponsibleID').focus();
            });
            return false;
        });

        // Bind event to StandardTemplate field.
        $('#StandardTemplateID').on('change', function () {
            Core.Agent.TicketAction.ConfirmTemplateOverwrite('RichText', $(this), function () {
                Core.AJAX.FormUpdate($('#NewPhoneTicket'), 'AJAXUpdate', 'StandardTemplateID', ['RichTextField']);
            });
            return false;
        });

        // Bind event to AttachmentDelete button.
        $('button[id*=AttachmentDeleteButton]').on('click', function () {
            $Form = $(this).closest('form');
            FieldID = $(this).attr('id').split('AttachmentDeleteButton')[1];
            $('#AttachmentDelete' + FieldID).val(1);
            Core.Form.Validate.DisableValidation($Form);
            $Form.trigger('submit');
        });

        // Initialize the ticket action popup.
        Core.Agent.TicketAction.Init();
    };

    /**
     * @private
     * @name FieldUpdate
     * @memberof Core.Agent.TicketPhone.Init
     * @function
     * @param {String} Value - FieldID
     * @param {Array} ModifiedFields - Fields
     * @description
     *      Create on change event handler
     */
    function FieldUpdate (Value, ModifiedFields) {
        $('#' + Value).on('change', function () {
            Core.AJAX.FormUpdate($('#NewPhoneTicket'), 'AJAXUpdate', Value, ModifiedFields);
        });
    }

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.TicketPhone || {}));
