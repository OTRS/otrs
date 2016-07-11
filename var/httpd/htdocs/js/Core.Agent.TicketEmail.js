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
 * @namespace Core.Agent.TicketEmail
 * @memberof Core.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains special module functions for TicketEmail.
 */
Core.Agent.TicketEmail = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.TicketEmail
     * @function
     * @description
     *      This function initializes the module functionality.
     */
    TargetNS.Init = function () {

        var SignatureURL,
            CustomerKey,
            $Form,
            FieldID,
            DynamicFieldNames = Core.Config.Get('DynamicFieldNames'),
            DataEmail = Core.Config.Get('DataEmail'),
            DataCustomer = Core.Config.Get('DataCustomer');

        // change type
        $('#TypeID').on('change', function () {
            Core.AJAX.FormUpdate($('#NewEmailTicket'), 'AJAXUpdate', 'TypeID', ['Dest', 'NewUserID', 'NewResponsibleID', 'NextStateID', 'PriorityID', 'ServiceID', 'SLAID', 'SignKeyID', 'CryptKeyID', 'To', 'Cc', 'Bcc', 'StandardTemplateID'].concat(DynamicFieldNames));
        });

        // change queue
        $('#Dest').on('change', function () {
            Core.AJAX.FormUpdate($('#NewEmailTicket'), 'AJAXUpdate', 'Dest', ['TypeID', 'Signature', 'NewUserID', 'NewResponsibleID', 'NextStateID', 'PriorityID', 'ServiceID', 'SLAID', 'SignKeyID', 'CryptKeyID', 'To', 'Cc', 'Bcc', 'StandardTemplateID'].concat(DynamicFieldNames));

            SignatureURL = Core.Config.Get('Baselink') + 'Action=' + Core.Config.Get('Action') + ';Subaction=Signature;Dest=' + $(this).val();
            if (!Core.Config.Get('SessionIDCookie')) {
                SignatureURL += ';' + Core.Config.Get('SessionName') + '=' + Core.Config.Get('SessionID');
            }
            $('#Signature').attr('src', SignatureURL);
        });

        // change service
        $('#ServiceID').on('change', function () {
            Core.AJAX.FormUpdate($('#NewEmailTicket'), 'AJAXUpdate', 'ServiceID', ['TypeID', 'Dest', 'NewUserID', 'NewResponsibleID', 'NextStateID', 'PriorityID', 'SLAID', 'SignKeyID', 'CryptKeyID', 'To', 'Cc', 'Bcc', 'StandardTemplateID'].concat(DynamicFieldNames));
        });

        // change SLA
        $('#SLAID').on('change', function () {
            Core.AJAX.FormUpdate($('#NewEmailTicket'), 'AJAXUpdate', 'SLAID', ['TypeID', 'Dest', 'NewUserID', 'NewResponsibleID', 'ServiceID', 'NextStateID', 'PriorityID', 'SignKeyID', 'CryptKeyID', 'To', 'Cc', 'Bcc', 'StandardTemplateID'].concat(DynamicFieldNames));
        });

        // change owner
        $('#NewUserID').on('change', function () {
            Core.AJAX.FormUpdate($('#NewEmailTicket'), 'AJAXUpdate', 'NewUserID', ['TypeID', 'Dest', 'NewResponsibleID', 'NextStateID', 'PriorityID', 'ServiceID', 'SLAID', 'SignKeyID', 'CryptKeyID', 'To', 'Cc', 'Bcc', 'StandardTemplateID'].concat(DynamicFieldNames));
        });

        // get all owners
        $('#OwnerSelectionGetAll').on('click', function () {
            $('#OwnerAll').val('1');
            Core.AJAX.FormUpdate($('#NewEmailTicket'), 'AJAXUpdate', 'OwnerAll', ['NewUserID'], function() {
                $('#NewUserID').focus();
            });
            return false;
        });

        // change responsible
        $('#NewResponsibleID').on('change', function () {
            Core.AJAX.FormUpdate($('#NewEmailTicket'), 'AJAXUpdate', 'NewResponsibleID', ['TypeID', 'Dest', 'NewUserID', 'NextStateID', 'PriorityID', 'ServiceID', 'SLAID', 'SignKeyID', 'CryptKeyID', 'To', 'Cc', 'Bcc', 'StandardTemplateID'].concat(DynamicFieldNames));
        });

        // get all responsibles
        $('#ResponsibleSelectionGetAll').on('click', function () {
            $('#ResponsibleAll').val('1');
            Core.AJAX.FormUpdate($('#NewEmailTicket'), 'AJAXUpdate', 'ResponsibleAll', ['NewResponsibleID'], function() {
                $('#NewResponsibleID').focus();
            });
            return false;
        });

        // change next state
        $('#NextStateID').on('change', function () {
            Core.AJAX.FormUpdate($('#NewEmailTicket'), 'AJAXUpdate', 'NextStateID', ['TypeID', 'Dest', 'NewUserID','NewResponsibleID', 'PriorityID', 'ServiceID', 'SLAID', 'SignKeyID', 'CryptKeyID', 'To', 'Cc', 'Bcc', 'StandardTemplateID'].concat(DynamicFieldNames));
        });

        // change priority
        $('#PriorityID').on('change', function () {
            Core.AJAX.FormUpdate($('#NewEmailTicket'), 'AJAXUpdate', 'PriorityID', ['TypeID', 'Dest', 'NewUserID','NewResponsibleID', 'NextStateID', 'ServiceID', 'SLAID', 'SignKeyID', 'CryptKeyID', 'To', 'Cc', 'Bcc', 'StandardTemplateID'].concat(DynamicFieldNames));
        });

        // change standard template
        $('#StandardTemplateID').on('change', function () {
            Core.Agent.TicketAction.ConfirmTemplateOverwrite('RichText', $(this), function () {
                Core.AJAX.FormUpdate($('#NewEmailTicket'), 'AJAXUpdate', 'StandardTemplateID', ['RichTextField']);
            });
            return false;
        });

        // change customer user radio button
        $('.CustomerTicketRadio').on('change', function () {
            if ($(this).prop('checked')){
                CustomerKey = $('#CustomerKey_' + $(this).val()).val();
                // get customer tickets
                Core.Agent.CustomerSearch.ReloadCustomerInfo(CustomerKey);
            }
            return false;
        });

        // remove customer user
        $('.CustomerTicketRemove').on('click', function () {
            Core.Agent.CustomerSearch.RemoveCustomerTicket($(this));
            return false;
        });

        // choose attachment
        $('#FileUpload').on('change', function () {
            $Form = $('#FileUpload').closest('form');
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

        // add a new ticket customer user
        if (typeof DataEmail !== 'undefined' && typeof DataCustomer !== 'undefined') {
            Core.Agent.CustomerSearch.AddTicketCustomer('ToCustomer', DataEmail, DataCustomer, true);
        }
        // initialize the ticket action popup
        Core.Agent.TicketAction.Init();

    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.TicketEmail || {}));
