// --
// Core.Installer.js - provides the special module functions for Installer
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.Installer.js,v 1.3 2010-06-23 20:46:46 mp Exp $
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
        $('input[name=Subaction]').val('DB');
    };


    /**
     * @function
     * @return nothing
     *      This function display the results for the check on the database
     */
    function CheckDBDataCallback(json) {
        if (parseInt(json['Successful']) < 1) {
            $('#FormDBResultMessage').html(json['Message']);
            $('#FormDBResultComment').html(json['Comment']);
            $('fieldset.ErrorMsg').show();
        }
        else {
            alert(Core.Config.Get('Installer.CheckDBDataLabel'));
            $('#FormDBSubmit').attr('disabled', false);
            $('fieldset.ErrorMsg, fieldset.CheckDB').hide();
            $('fieldset.HideMe, div.HideMe').show();
        }
    };


/*
InstallerConfigureMail
*/
    
    TargetNS.SelectOutboundMailType = function (obj) {
        var value = $(obj).val();
        if (value == "smtp") {
            $('.infosmtp').show();
        }
        else {
            $('.infosmtp, .infosmtpauth').hide().find('input[name=SMTPAuth]').removeAttr('checked');
        }
    };
    
    /**
     * @function
     * @return nothing
     *      This function check for the SMTP configuration
     */
    TargetNS.CheckSMTPAuth = function (obj) {
        if ($(obj).is(':checked')) {
            $('.infosmtpauth').show().find('input').removeAttr('disabled');
        }
        else {
            $('.infosmtpauth input').attr('disabled', 'disabled').val("");
            $('.infosmtpauth').hide();
        }
    };
    
    /**
     * @function
     * @return nothing
     *      This function skip check the mail configuration
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
        $('input[name=Subaction]').val('Finish');
    };

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
    return TargetNS;
}(Core.Installer || {}));