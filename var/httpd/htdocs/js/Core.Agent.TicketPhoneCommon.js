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
 * @namespace Core.Agent.TicketPhoneCommon
 * @memberof Core.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains special module functions for TicketPhoneCommon.
 */
Core.Agent.TicketPhoneCommon = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.TicketPhoneCommon
     * @function
     * @description
     *      This function initializes the module functionality.
     */
    TargetNS.Init = function () {

        var $Form,
            FieldID,
            UpdateFields = Core.Config.Get('DynamicFieldNames');

        // Bind event to StandardTemplate field.
        $('#StandardTemplateID').on('change', function () {
            var $TemplateSelect = $(this);
            Core.Agent.TicketAction.ConfirmTemplateOverwrite('RichText', $TemplateSelect, function () {
                Core.AJAX.FormUpdate($TemplateSelect.closest('form'), 'AJAXUpdate', 'StandardTemplateID', ['RichTextField']);
            });
            return false;
        });

        // Bind event to State field.
        $('#NextStateID').on('change', function () {
            UpdateFields.push('StandardTemplateID');
            Core.AJAX.FormUpdate($(this).parents('form'), 'AJAXUpdate', 'NextStateID', UpdateFields);
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

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.TicketPhoneCommon || {}));
