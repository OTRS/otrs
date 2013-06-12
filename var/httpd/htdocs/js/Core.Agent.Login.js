// --
// Core.Agent.Login.js - provides the special module functions for the login
// Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};

/**
 * @namespace
 * @exports TargetNS as Core.Agent.Login
 * @description
 *      This namespace contains the special module functions for TicketZoom.
 */
Core.Agent.Login = (function (TargetNS) {
    /**
     * @function
     * @return nothing
     *      This function initializes the special module functions
     */
    TargetNS.Init = function (LoginFailed) {
        // Browser is too old
        if (!Core.Debug.BrowserCheckAgent()) {
            $('#LoginBox').hide();
            $('#OldBrowser').show();
            return;
        }

        // enable login form
        Core.Form.EnableForm($('#LoginBox form, #PasswordBox form'));

        // set focus
        if ($('#User').val() && $('#User').val().length) {
            $('#Password').focus();
        }
        else {
            $('#User').focus();
        }

        // enable link actions to switch login <> password request
        $('#LostPassword, #BackToLogin').click(function () {
            $('#LoginBox, #PasswordBox').toggle();
            return false;
        });

        // save TimeOffset data for OTRS
        $('#TimeOffset').val((new Date()).getTimezoneOffset());

        // shake login box on authentication failure
        if (LoginFailed) {
            Core.UI.Shake($('#LoginBox'));
        }
    };

    return TargetNS;
}(Core.Agent.Login || {}));
