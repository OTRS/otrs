// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
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
     * @private
     * @name CheckDBDataCallback
     * @memberof Core.Installer
     * @function
     * @param {Object} json - The server response JSON object.
     * @description
     *      This function displays the results for the database credentials.
     */
    function CheckDBDataCallback(json) {
        if (parseInt(json.Successful, 10) < 1) {
            $('#FormDBResultMessage').html(json.Message);
            $('#FormDBResultComment').html(json.Comment);
            $('fieldset.ErrorMsg').show();
            $('fieldset.Success').hide();
        }
        else {
            $('#ButtonCheckDB').closest('.Field').hide();
            $('#FormDBSubmit').removeAttr('disabled').removeClass('Disabled');
            $('fieldset.ErrorMsg, fieldset.CheckDB').hide();
            $('fieldset.HideMe, div.HideMe, fieldset.Success').show();
        }
    }

    /**
     * @name CheckDBData
     * @memberof Core.Installer
     * @function
     * @description
     *      This function check the values for the database configuration.
     */
    TargetNS.CheckDBData = function () {
        var Data;
        $('input[name=Subaction]').val('CheckRequirements');
        Data = Core.AJAX.SerializeForm($('#FormDB'));
        Data += 'CheckMode=DB;';
        Core.AJAX.FunctionCall(Core.Config.Get('Baselink'), Data, CheckDBDataCallback);
        $('input[name=Subaction]').val('DBCreate');
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
        if (value !== "sendmail") {
            $('#InfoSMTP').show();
        }
        else {
            $('#InfoSMTP, #InfoSMTPAuth').hide().find('input[name=SMTPAuth]').prop('checked', false);
        }

        // Change default port
        $('#OutboundMailDefaultPorts').val($('#OutboundMailType').val());
        $('#SMTPPort').val($('#OutboundMailDefaultPorts :selected').text());
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
     * @private
     * @name CheckMailConfigCallback
     * @memberof Core.Installer
     * @function
     * @param {Object} json - The server response JSON object.
     * @description
     *      This function shows the mail configuration check result.
     */
    function CheckMailConfigCallback(json) {
        if (parseInt(json.Successful, 10) === 1) {
            alert(Core.Language.Translate('Mail check successful.'));
            $('fieldset.errormsg').hide();
            $('input[name=Subaction]').val('Finish');
            $('form').submit();
        }
        else {
            $('#FormMailResultMessage').html(json.Message);
            $('fieldset.ErrorMsg').show();
            alert(Core.Language.Translate('Error in the mail settings. Please correct and try again.'));
        }
    }

    /**
     * @name CheckMailConfig
     * @memberof Core.Installer
     * @function
     * @description
     *      This function checks the mail configuration.
     */
    TargetNS.CheckMailConfig = function () {
        var Data;
        $('input[name=Skip]').val('0');
        // Check mail data via AJAX
        $('input[name=Subaction]').val('CheckRequirements');
        Data = Core.AJAX.SerializeForm($('#FormMail'));
        Data += 'CheckMode=Mail;';
        Core.AJAX.FunctionCall(Core.Config.Get('Baselink'), Data, CheckMailConfigCallback);
    };

    /**
     * @private
     * @name SelectDBType
     * @memberof Core.Installer
     * @function
     * @description
     *      This function allows CreateDB only if selected database is not Oracle.
     */
     function InitDatabaseSelection() {
        $('select#DBType').on('change', function(){
            if (/oracle/.test($(this).val())) {
                $("#DBInstallTypeUseDB").prop("checked", true);
                $("#DBInstallTypeUseDB").prop("disabled", "disabled");
                $("#DBInstallTypeCreateDB").prop("disabled", "disabled");
            }
            else {
                $("#DBInstallTypeUseDB").removeAttr("disabled");
                $("#DBInstallTypeCreateDB").removeAttr("disabled");
                $("#DBInstallTypeCreateDB").prop("checked", true);
            }
        }).trigger('change');
     }

     /**
     * @private
     * @name DBSettingsButtons
     * @memberof Core.Installer
     * @function
     * @description
     *      This function creates click events for Database Settings screen.
     */
     function InitDatabaseButtons() {

        // click event for checking values for the database configuration
        $('#ButtonCheckDB').on('click', TargetNS.CheckDBData);

        // click event for 'Back' button
        $('#ButtonBack').on('click', function() {
            parent.history.back();
        });
     }

     /**
     * @private
     * @name ConfigureMail
     * @memberof Core.Installer
     * @function
     * @description
     *      This function configures mail settings.
     */
     function InitMailButtons() {
        $('#ButtonCheckMail').on('click', TargetNS.CheckMailConfig);
        $('#ButtonSkipMail').on('click', function() {
            TargetNS.SkipMailConfig();
            return false;
        });
        $('#SMTPAuth').on('change', function () {
            TargetNS.CheckSMTPAuth($(this));
        });
        $('#OutboundMailType').on('change', function () {
            TargetNS.SelectOutboundMailType($(this));
        });
        $('#OutboundMailType').trigger('change');
     }

     /**
     * @private
     * @name LogFileFieldLocation
     * @memberof Core.Installer
     * @function
     * @description
     *      This function shows Log File Location field only if log module File is selected.
     */
     function InitLogModuleSelection() {
        $('select#LogModule').on('change', function(){
            if (/Kernel::System::Log::File/.test($(this).val())) {
                $('.Row_LogFile').show();
            }
            else {
                $('.Row_LogFile').hide();
            }
        }).trigger('change');
     }

    /**
     * @name Init
     * @memberof Core.Installer
     * @function
     * @description
     *      This function initializes JS functionality.
     */
    TargetNS.Init = function () {

        // show 'Next' button
        $('#InstallerContinueWithJS').show();

        // allows CreateDB only if selected database is not Oracle
        InitDatabaseSelection();

        // button click events for Database Settings screen
        InitDatabaseButtons();

        // configure mail screen
        InitMailButtons();

        // show Log File Location field (only if log module File is selected)
        InitLogModuleSelection();
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Installer || {}));
