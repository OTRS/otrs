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
 * @namespace Core.Agent.Admin.MailAccount
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for MailAccount module.
 */
 Core.Agent.Admin.MailAccount = (function (TargetNS) {

    /**
     * @name MailAccountDelete
     * @memberof Core.Agent.Admin.MailAccount
     * @function
     * @description
     *      Bind event on mail account delete button.
     */
    TargetNS.MailAccountDelete = function() {
        $('.MailAccountDelete').on('click', function () {
            var MailAccountDelete = $(this);

            Core.UI.Dialog.ShowContentDialog(
                $('#DeleteMailAccountDialogContainer'),
                Core.Language.Translate('Delete this Mail Account'),
                '240px',
                'Center',
                true,
                [
                    {
                        Class: 'Primary',
                        Label: Core.Language.Translate("Confirm"),
                        Function: function() {
                            $('.Dialog .InnerContent .Center').text(Core.Language.Translate("Deleting the mail account and its data. This may take a while..."));
                            $('.Dialog .Content .ContentFooter').remove();

                            Core.AJAX.FunctionCall(
                                Core.Config.Get('Baselink'),
                                MailAccountDelete.data('query-string'),
                                function() {
                                   Core.App.InternalRedirect({
                                       Action: 'AdminMailAccount'
                                   });
                                }
                            );
                        }
                    },
                    {
                        Label: Core.Language.Translate("Cancel"),
                        Function: function () {
                            Core.UI.Dialog.CloseDialog($('#DeleteMailAccountDialog'));
                        }
                    }
                ]
            );
            return false;
        });
    };

    /*
    * @name Init
    * @memberof Core.Agent.Admin.MailAccount
    * @function
    * @description
    *      This function registers onchange events for showing IMAP Folder and Queue field
    */
    TargetNS.Init = function () {

        // Show IMAP Folder selection only for IMAP backends
        $('select#TypeAdd, select#Type').on('change', function(){
            if (/IMAP/.test($(this).val())) {
                $('.Row_IMAPFolder').show();
            }
            else {
                $('.Row_IMAPFolder').hide();
            }
        }).trigger('change');

        // Show Queue field only if Dispatch By Queue is selected
        $('select#DispatchingBy').on('change', function(){
            if (/Queue/.test($(this).val())) {
                $('.Row_Queue').show();
                Core.UI.InputFields.Activate();
            }
            else {
                $('.Row_Queue').hide();
            }
        }).trigger('change');

        Core.UI.Table.InitTableFilter($("#FilterMailAccounts"), $("#MailAccounts"));

        TargetNS.MailAccountDelete();
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.MailAccount || {}));
