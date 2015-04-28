// --
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
 * @namespace Core.Agent.Login
 * @memberof Core.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the Login.
 */
Core.Agent.Login = (function (TargetNS) {
    /**
     * @name Init
     * @memberof Core.Agent.Login
     * @function
     * @param {Boolean} LoginFailed
     * @description
     *      This function initializes the special module functions.
     */
    TargetNS.Init = function (LoginFailed) {
        // Browser is too old
        if (!Core.Agent.SupportedBrowser) {
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

        // if in PreLogin mode, automatically submit form
        if ( $('#LoginBox').hasClass('PreLogin') ) {
            $('#LoginBox form').submit();
        }
    };

    return TargetNS;
}(Core.Agent.Login || {}));
