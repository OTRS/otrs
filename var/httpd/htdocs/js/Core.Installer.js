// --
// Core.Installer.js - provides the special module functions for Installer
// Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};

/**
 * @namespace
 * @exports TargetNS as Core.Installer
 * @description
 *      This namespace contains the special module functions for Installer.
 */
Core.Installer = (function (TargetNS) {
/*
InstallerDBStart
*/
    /**
     * @function
     * @return nothing
     *      This function check the values for the database configuration
     */
    TargetNS.CheckDBData = function () {
        $('input[name=Subaction]').val('CheckRequirements');
        var Data = Core.AJAX.SerializeForm( $('#FormDB') );
        Data += 'CheckMode=DB;';
        Core.AJAX.FunctionCall(Core.Config.Get('Baselink'), Data, CheckDBDataCallback );
        $('input[name=Subaction]').val('DBCreate');
    };


    /**
     * @function
     * @return nothing
     *      This function displays the results for the database credentials
     */
    function CheckDBDataCallback(json) {
        if (parseInt(json['Successful']) < 1) {
            $('#FormDBResultMessage').html(json['Message']);
            $('#FormDBResultComment').html(json['Comment']);
            $('fieldset.ErrorMsg').show();
        }
        else {
            $('#ButtonCheckDB').hide();
            $('#FormDBSubmit').removeAttr('disabled');
            $('fieldset.ErrorMsg, fieldset.CheckDB').hide();
            $('fieldset.HideMe, div.HideMe').show();
        }
    };

    /**
     * @function
     * @description
     *      This function is used to enable or disable some mail configuration fields.
     * @param {Object} obj The form object that holds the value that makes fields visible or hidden
     * @return nothing
     */
    TargetNS.SelectOutboundMailType = function (obj) {
        var value = $(obj).val();
        if (value != "sendmail") {
            $('#InfoSMTP').show();
        }
        else {
            $('#InfoSMTP, #InfoSMTPAuth').hide().find('input[name=SMTPAuth]').prop('checked', false);
        }

        // Change default port
        $('#OutboundMailDefaultPorts').val( $('#OutboundMailType').val() );
        $('#SMTPPort').val( $('#OutboundMailDefaultPorts :selected').text() );
    };

    /**
     * @function
     * @return nothing
     *      This function checks the SMTP configuration
     */
    TargetNS.CheckSMTPAuth = function (obj) {
        if ($(obj).is(':checked')) {
            $('#InfoSMTPAuth').show().find('input').removeAttr('disabled');
        }
        else {
            $('#InfoSMTPAuth input').attr('disabled', 'disabled').val("");
            $('#InfoSMTPAuth').hide();
        }
    };

    /**
     * @function
     * @return nothing
     *      This function skips the mail configuration
     */
    TargetNS.SkipMailConfig = function () {
        $('input[name=Skip]').val('1');
        $('form').submit();
    };

    /**
     * @function
     * @return nothing
     *      This function check the mail configuration
     */
    TargetNS.CheckMailConfig = function () {
        $('input[name=Skip]').val('0');
        // Check mail data via AJAX
        $('input[name=Subaction]').val('CheckRequirements');
        var Data = Core.AJAX.SerializeForm( $('#FormMail') );
        Data += 'CheckMode=Mail;';
        Core.AJAX.FunctionCall(Core.Config.Get('Baselink'), Data, CheckMailConfigCallback );
        $('input[name=Subaction]').val('Registration');
    };

    /**
     * @function
     * @private
     * @return nothing
     * @description This function shows the mail configuration check result
     */
    function CheckMailConfigCallback(json) {
        if (parseInt(json['Successful']) == 1) {
            alert(Core.Config.Get('Installer.CheckMailLabelOne'));
            $('fieldset.errormsg').hide();
            $('form').submit();
        }
        else {
            $('#FormMailResultMessage').html(json['Message']);
            $('fieldset.ErrorMsg').show();
            alert(Core.Config.Get('Installer.CheckMailLabelTwo'));
        }
    };

    /**
     * @function
     * @return nothing
     *      This function skips the registration
     */
    TargetNS.SkipRegistration = function () {
        $('input[name=Skip]').val('1');
        $('form').submit();
    };

    return TargetNS;
}(Core.Installer || {}));
