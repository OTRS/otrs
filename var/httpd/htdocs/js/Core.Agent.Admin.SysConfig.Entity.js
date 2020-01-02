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
Core.Agent.Admin.SysConfig = Core.Agent.Admin.SysConfig || {};

/**
 * @namespace Core.Agent.Admin.SysConfig.Entity
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module function for admin Entity (Queue, Priority, State, etc... ) screens.
 */
 Core.Agent.Admin.SysConfig.Entity = (function (TargetNS) {

    /*
    * @name Init
    * @memberof Core.Agent.Admin.SysConfig.Entity
    * @function
    * @description
    *      This function initializes filter.
    */
    TargetNS.Init = function () {


        Core.Form.Validate.SetSubmitFunction($('form#EntityUpdate'), function(Form) {

            // If entity is present in a SysConfig setting
            if ($('#OldName').length) {

                if (parseInt($('#ValidID').val(), 10) !== 1) {

                    // Set a different explanation per each case
                    $('#EntityInSetting p.FieldExplanation').text(Core.Language.Translate("It is not possible to set this entry to invalid. All affected configuration settings have to be changed beforehand."));
                    Core.UI.Dialog.ShowDialog({
                        Modal: true,
                        Title: Core.Language.Translate('Cannot proceed'),
                        HTML: $('#EntityInSetting').html(),
                        PositionTop: '15%',
                        PositionLeft: 'Center',
                        CloseOnEscape: false,
                        CloseOnClickOutside: false,
                        Buttons: [
                            {
                                Label: Core.Language.Translate('Update manually'),
                                Function: function () {
                                    UpdateManually();
                                },
                                Class: 'Primary CallForAction'
                            },
                            {
                                Label: Core.Language.Translate('Cancel'),
                                Function: function () {
                                    Core.UI.Dialog.CloseDialog($('.Dialog:visible'));
                                    Core.Form.EnableForm($('form#EntityUpdate'));
                                    $('#ValidID').focus();
                                    Core.UI.InputFields.Deactivate();
                                    Core.UI.InputFields.Activate();
                                },
                                Class: 'CallForAction'
                            },
                        ]
                    });
                }

                else if ($('#OldName').val() !== $('#Name').val()) {

                    // Set a different explanation per each case
                    $('#EntityInSetting p.FieldExplanation').text(Core.Language.Translate("You can either have the affected settings updated automatically to reflect the changes you just made or do it on your own by pressing 'update manually'."));
                    Core.UI.Dialog.ShowDialog({
                        Modal: true,
                        Title: Core.Language.Translate('Notice'),
                        HTML: $('#EntityInSetting').html(),
                        PositionTop: '15%',
                        PositionLeft: 'Center',
                        CloseOnEscape: false,
                        CloseOnClickOutside: false,
                        Buttons: [
                            {
                                Label: Core.Language.Translate('Save and update automatically'),
                                Function: function () {
                                    Core.UI.Dialog.CloseDialog($('.Dialog:visible'));
                                    $('#UpdateEntity').val(1);
                                    Form.submit();
                                },
                                Class: 'Primary CallForAction'
                            },
                            {
                                Label: Core.Language.Translate("Don't save, update manually"),
                                Function: function () {
                                    UpdateManually();
                                },
                                Class: 'Primary CallForAction'
                            },
                            {
                                Label: Core.Language.Translate('Cancel'),
                                Function: function () {
                                    Core.UI.Dialog.CloseDialog($('.Dialog:visible'));
                                    Core.Form.EnableForm($('form#EntityUpdate'));
                                    $('#Name').focus();
                                    Core.UI.InputFields.Deactivate();
                                    Core.UI.InputFields.Activate();
                                },
                                Class: 'CallForAction'
                            }
                        ]
                    });
                }
                else{
                    // Not changes on name or in valid field.
                    Form.submit();
                }

                // Just take actions from dialog buttons.
                $('a.Close').hide();
                return false;

            }
            else{
                // Normal case if entity not in a SysConfig setting.
                Form.submit();
            }

        });

        // disable form in case dirty settings
        if ($('#SysConfigDirty').val() && $('#SysConfigDirty').val().length) {

            Core.Form.DisableForm($("form#EntityUpdate"));

            Core.UI.Dialog.ShowAlert(
                Core.Language.Translate('Warning'),
                Core.Language.Translate("The item you're currently viewing is part of a not-yet-deployed configuration setting, which makes it impossible to edit it in its current state. Please wait until the setting has been deployed. If you're unsure what to do next, please contact your system administrator."),
                function () {
                    Core.UI.Dialog.CloseDialog($('.Alert'));
                    return false;
                }
            );
        }

    };

    /**
    * @private
    * @name UpdateManually
    * @memberof Core.Agent.Admin.SysConfig.Entity
    * @function
    * @description
    *      This function handles click on the Edit Manually link.
    */
    function UpdateManually() {
        var $InSysConfigSetting = $('#EntityInSetting li.InSysConfigSetting');

        // Create a form due using GET method have problems with characters like #.
        var $EntityForm = $('<form id="EntityForm"></form>');
        $EntityForm.attr('action', Core.Config.Get('CGIHandle'));
        $EntityForm.attr('method', 'post');
        $EntityForm.attr('enctype', 'multipart/form-data');
        $EntityForm.append('<input type="hidden" name="Action" value="AdminSystemConfiguration" />');
        $EntityForm.append('<input type="hidden" name="Subaction" value="ViewCustomGroup" />');
        $EntityForm.append('<input type="hidden" name="EntityType" value="' + Core.Config.Get('EntityType') + '" />');

        // Loop over all available settings.
        $InSysConfigSetting.each(function () {
            $EntityForm.append('<input type="hidden" name="Names" value="' + $(this).text() + '" />');
        });

        $('body').append($EntityForm);

        $('#EntityForm').submit();
    }

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.SysConfig.Entity || {}));
