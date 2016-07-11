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
            FromExternalCustomerEmail = Core.Config.Get('FromExternalCustomerEmail');

        // Bind event to customer radio button.
        $('.CustomerTicketRadio').bind('change', function () {
            var CustomerKey;
            if ($(this).prop('checked')){

                CustomerKey = $('#CustomerKey_' +$(this).val()).val();
                // get customer tickets
                Core.Agent.CustomerSearch.ReloadCustomerInfo(CustomerKey);
            }
            return false;
        });

        // Bind event to customer remove button.
        $('.CustomerTicketRemove').bind('click', function () {
            Core.Agent.CustomerSearch.RemoveCustomerTicket($(this));
            return false;
        });

        // Add ticket customer from external source.
        if (typeof FromExternalCustomerEmail !== 'undefined' &&
            typeof FromExternalCustomerName !== 'undefined') {
                Core.Agent.CustomerSearch.AddTicketCustomer('FromCustomer', FromExternalCustomerEmail, FromExternalCustomerName, true);
        }

        // Bind event to Type field.
        $('#TypeID').bind('change', function () {
            Core.AJAX.FormUpdate($('#NewPhoneTicket'), 'AJAXUpdate', 'TypeID',
                ['Dest', 'NewUserID', 'NewResponsibleID', 'NextStateID', 'PriorityID', 'ServiceID', 'SLAID', 'SignKeyID', 'CryptKeyID', 'StandardTemplateID'].concat(DynamicFieldNames));
        });

        // Bind even to Dest field.
        $('#Dest').bind('change', function () {
            Core.AJAX.FormUpdate($('#NewPhoneTicket'), 'AJAXUpdate', 'Dest',
                ['TypeID', 'NewUserID', 'NewResponsibleID', 'NextStateID', 'PriorityID', 'ServiceID', 'SLAID', 'SignKeyID', 'CryptKeyID', 'StandardTemplateID'].concat(DynamicFieldNames));
        });

        // Bind event to Service field.
        $('#ServiceID').bind('change', function () {
            Core.AJAX.FormUpdate($('#NewPhoneTicket'), 'AJAXUpdate', 'ServiceID',
                ['TypeID', 'Dest', 'NewUserID', 'NewResponsibleID', 'NextStateID', 'PriorityID', 'SLAID', 'SignKeyID', 'CryptKeyID', 'StandardTemplateID'].concat(DynamicFieldNames));
        });

        // Bind event to SLA field.
        $('#SLAID').bind('change', function () {
            Core.AJAX.FormUpdate($('#NewPhoneTicket'), 'AJAXUpdate', 'SLAID',
                ['TypeID', 'Dest', 'NewUserID', 'NewResponsibleID', 'ServiceID', 'NextStateID', 'PriorityID', 'SignKeyID', 'CryptKeyID', 'StandardTemplateID'].concat(DynamicFieldNames));
        });

        // Bind event to OwnerSelection get all button.
        $('#OwnerSelectionGetAll').bind('click', function () {
            $('#OwnerAll').val('1');
            Core.AJAX.FormUpdate($('#NewPhoneTicket'), 'AJAXUpdate', 'OwnerAll', ['NewUserID'], function() {
                $('#NewUserID').focus();
            });
            return false;
        });

        // Bind event to NewUser field
        $('#NewUserID').bind('change', function () {
            Core.AJAX.FormUpdate($('#NewPhoneTicket'), 'AJAXUpdate', 'NewUserID',
                ['TypeID', 'Dest', 'NewResponsibleID', 'NextStateID', 'PriorityID', 'ServiceID', 'SLAID', 'SignKeyID', 'CryptKeyID', 'StandardTemplateID'].concat(DynamicFieldNames));
        });

        // Bind event to ResponsibleSelection get all button.
        $('#ResponsibleSelectionGetAll').bind('click', function () {
            $('#ResponsibleAll').val('1');
            Core.AJAX.FormUpdate($('#NewPhoneTicket'), 'AJAXUpdate', 'ResponsibleAll', ['NewResponsibleID'], function() {
                $('#NewResponsibleID').focus();
            });
            return false;
        });

        // Bind event to Responsible field
        $('#NewResponsibleID').bind('change', function () {
            Core.AJAX.FormUpdate($('#NewPhoneTicket'), 'AJAXUpdate', 'NewResponsibleID',
                ['TypeID', 'Dest', 'NewUserID', 'NextStateID', 'PriorityID', 'ServiceID', 'SLAID', 'SignKeyID', 'CryptKeyID', 'StandardTemplateID'].concat(DynamicFieldNames));
        });

        // Bind event to StandardTemplate field.
        $('#StandardTemplateID').bind('change', function () {
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

        // Bind event to FileUpload button.
        $('#FileUpload').on('change', function () {
            $Form = $('#FileUpload').closest('form');
            Core.Form.Validate.DisableValidation($Form);
            $Form.find('#AttachmentUpload').val('1').end().submit();
        });

        // Bind event to State field.
        $('#NextStateID').bind('change', function () {
            Core.AJAX.FormUpdate($('#NewPhoneTicket'), 'AJAXUpdate', 'NextStateID',
                ['TypeID', 'Dest', 'NewUserID','NewResponsibleID', 'PriorityID', 'ServiceID', 'SLAID', 'SignKeyID', 'CryptKeyID', 'StandardTemplateID'].concat(DynamicFieldNames));
        });

        // Bind event to Priority field.
        $('#PriorityID').bind('change', function () {
            Core.AJAX.FormUpdate($('#NewPhoneTicket'), 'AJAXUpdate', 'PriorityID',
                ['TypeID', 'Dest', 'NewUserID','NewResponsibleID', 'NextStateID', 'ServiceID', 'SLAID', 'SignKeyID', 'CryptKeyID', 'StandardTemplateID'].concat(DynamicFieldNames));
        });

        // Initialize the ticket action popup.
        Core.Agent.TicketAction.Init();
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.TicketPhone || {}));
