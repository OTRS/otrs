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

        var UpdateFields = Core.Config.Get('DynamicFieldNames');

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
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.TicketPhoneCommon || {}));
