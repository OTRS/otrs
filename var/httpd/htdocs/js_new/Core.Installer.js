// --
// Core.Installer.js - provides the special module functions for Installer
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.Installer.js,v 1.2 2010-06-23 15:48:16 cg Exp $
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

    Core.Config.Set('Installer.CheckDBDataLabel', 'Database check successful.');
    Core.Config.Set('Installer.CheckMailLabelOne', 'Mail check successful.');
    Core.Config.Set('Installer.CheckMailLabelTwo', 'Error in the mail settings. Please correct and try again.');
/*
InstallerDBStart
*/
    /**
     * @function
     * @return nothing
     *      This function initializes the special module functions
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
     *      This function initializes the special module functions
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
InstallerConfiguredMail
*/
    /**
     * @function
     * @return nothing
     *      This function initializes the special module functions
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
     *      This function initializes the special module functions
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

    TargetNS.SkipMailConfig = function () {
        $('input[name=Skip]').val('1');
        $('form').submit();
    };

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