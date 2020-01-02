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
Core.Agent.Admin = Core.Agent.Admin || {};

/**
 * @namespace Core.Agent.Admin.SMIME
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module function for SMIME module.
 */
 Core.Agent.Admin.SMIME = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Admin.SMIME
     * @function
     * @description
     *      This function initializes the special module functions
     */
    TargetNS.Init = function () {

        // Initialize SMIME table filter
        Core.UI.Table.InitTableFilter($('#FilterSMIME'), $('#SMIME'));

        // Open pop up window
        $('a.CertificateRead').off('click').on('click', function () {
            Core.UI.Popup.OpenPopup($(this).attr('href'), 'CertificateRead');
            return false;
        });

        // Initialize SMIME certificate fitler
        Core.UI.Table.InitTableFilter($('#FilterSMIMECerts'), $('#AvailableCerts'));

        // Bind click function to remove button
        $('#SMIME a.TrashCan').on('click', function () {
            if (window.confirm(Core.Language.Translate('Do you really want to delete this certificate?'))) {
                return true;
            }
            return false;
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
 }(Core.Agent.Admin.SMIME || {}));
