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
 * @namespace Core.Installer
 * @memberof Core
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for Installer.
 */
Core.Installer = (function (TargetNS) {
    /**
     * @name CheckDBData
     * @memberof Core.Installer
     * @function
     * @description
     *      This function check the values for the database configuration.
     */
    TargetNS.CheckDBData = function () {
        $('input[name=Subaction]').val('CheckRequirements');
        var Data = Core.AJAX.SerializeForm( $('#FormDB') );
        Data += 'CheckMode=DB;';
        Core.AJAX.FunctionCall(Core.Config.Get('Baselink'), Data, CheckDBDataCallback );
        $('input[name=Subaction]').val('DBCreate');
    };


    /**
     * @private
     * @name CheckDBDataCallback
     * @memberof Core.Installer
     * @function
     * @param {Object} json - The server response JSON object.
     * @description
     *      This function displays the results for the database credentials.
     */
    function CheckDBDataCallback(json) {
        if (parseInt(json['Successful']) < 1) {
            $('#FormDBResultMessage').html(json['Message']);
            $('#FormDBResultComment').html(json['Comment']);
            $('fieldset.ErrorMsg').show();
            $('fieldset.Success').hide();
        }
        else {
            $('#ButtonCheckDB').closest('.Field').hide();
            $('#FormDBSubmit').removeAttr('disabled').removeClass('Disabled');
            $('fieldset.ErrorMsg, fieldset.CheckDB').hide();
            $('fieldset.HideMe, div.HideMe, fieldset.Success').show();
        }
    };

    /**
     * @name SelectOutboundMailType
     * @memberof Core.Installer
     * @function
     * @param {Object} obj - The form object that holds the value that makes fields visible or hidden.
     * @description
     *      This function is used to enable or disable some mail configuration fields.
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
     * @name CheckSMTPAuth
     * @memberof Core.Installer
     * @function
     * @param {Object} obj
     * @description
     *      This function checks the SMTP configuration.
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
     * @name SkipMailConfig
     * @memberof Core.Installer
     * @function
     * @description
     *      This function skips the mail configuration.
     */
    TargetNS.SkipMailConfig = function () {
        $('input[name=Skip]').val('1');
        $('input[name=Subaction]').val('Finish');
        $('form').submit();
    };

    /**
     * @name CheckMailConfig
     * @memberof Core.Installer
     * @function
     * @description
     *      This function checks the mail configuration.
     */
    TargetNS.CheckMailConfig = function () {
        $('input[name=Skip]').val('0');
        // Check mail data via AJAX
        $('input[name=Subaction]').val('CheckRequirements');
        var Data = Core.AJAX.SerializeForm( $('#FormMail') );
        Data += 'CheckMode=Mail;';
        Core.AJAX.FunctionCall(Core.Config.Get('Baselink'), Data, CheckMailConfigCallback );
    };

    /**
     * @private
     * @name CheckMailConfigCallback
     * @memberof Core.Installer
     * @function
     * @param {Object} json - The server response JSON object.
     * @description
     *      This function shows the mail configuration check result.
     */
    function CheckMailConfigCallback(json) {
        if (parseInt(json['Successful']) == 1) {
            alert(Core.Config.Get('Installer.CheckMailLabelOne'));
            $('fieldset.errormsg').hide();
            $('input[name=Subaction]').val('Finish');
            $('form').submit();
        }
        else {
            $('#FormMailResultMessage').html(json['Message']);
            $('fieldset.ErrorMsg').show();
            alert(Core.Config.Get('Installer.CheckMailLabelTwo'));
        }
    };

    return TargetNS;
}(Core.Installer || {}));
