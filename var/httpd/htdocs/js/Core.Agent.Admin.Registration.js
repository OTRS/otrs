// --
// Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};
Core.Agent.Admin = Core.Agent.Admin || {};

/**
 * @namespace Core.Agent.Admin.Registration
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module function for AdminRegistration.
 */
 Core.Agent.Admin.Registration = (function (TargetNS) {

    /*
    * @name Init
    * @memberof Core.Agent.Admin.Registration
    * @function
    * @description
    *      This function initializes modal dialogs and also textarea selecting.
    */
    TargetNS.Init = function () {

        $('#RegistrationMoreInfo').on('click', function() {
            Core.UI.Dialog.ShowDialog({
                Modal: true,
                Title: Core.Language.Translate('System Registration'),
                HTML: $('#QADialog').html(),
                PositionTop: '70px',
                PositionLeft: 'Center',
                CloseOnEscape: true,
                CloseOnClickOutside: true
            });
            return false;
        });

        $('#RegistrationDataProtection').on('click', function() {
            Core.UI.Dialog.ShowDialog({
                Modal: true,
                Title: Core.Language.Translate('Data Protection'),
                HTML: $('#DPDialog').html(),
                PositionTop: '10px',
                PositionLeft: 'Center',
                CloseOnEscape: true,
                CloseOnClickOutside: true
            });
            return false;
        });

        $('textarea.SupportData').on('focus', function() {
            $(this).select();
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.Registration || {}));
