// --
// OTRS.Agent.TicketZoom.js - provides the special module functions for TicketZoom
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};
OTRS.Agent = OTRS.Agent || {};
OTRS.Agent.App = OTRS.Agent.App || {};

/**
 * @namespace
 * @exports TargetNS as OTRS.App.Agent.Login
 * @description
 *      This namespace contains the special module functions for TicketZoom.
 */
OTRS.Agent.App.Login = (function (TargetNS) {
    /**
     * @function
     * @return nothing
     *      This function initializes the special module functions
     */
    TargetNS.Init = function(){
        // Browser is too old
        if (!OTRS.Debug.BrowserCheck()) {
            $('#LoginBox').hide();
            $('#OldBrowser').show();
            return;
        }

        // enable login form
        OTRS.Form.EnableForm($('#LoginBox form, #PasswordBox form'));

        // set focus
        if ($('#User').val() && $('#User').val().length) {
            $('#Password').focus();
        }
        else {
            $('#User').focus();
        }

        // enable link actions to switch login <> password request
        $('#LostPassword, #BackToLogin').click(function(){
            $('#LoginBox, #PasswordBox').toggle();
            return false;
        });

        // save TimeOffset data for OTRS
        Now = new Date();
        $('#TimeOffset').val(Now.getTimezoneOffset());
    }

    return TargetNS;
}(OTRS.Agent.App.Login || {}));