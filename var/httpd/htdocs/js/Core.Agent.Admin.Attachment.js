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
 * @namespace Core.Agent.Admin.Attachment
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module function for Attachment module.
 */
 Core.Agent.Admin.Attachment = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Admin.Attachment
     * @function
     * @description
     *      This function initializes the table filter.
     */
    TargetNS.Init = function () {
        Core.UI.Table.InitTableFilter($("#FilterAttachments"), $("#Attachments"));

        // delete attachment
        TargetNS.InitAttachmentDelete();
    };

    /**
     * @name AttachmentDelete
     * @memberof Core.Agent.Admin.Attachment
     * @function
     * @description
     *      This function deletes attachment on buton click.
     */
    TargetNS.InitAttachmentDelete = function () {
        $('.AttachmentDelete').on('click', function () {
            var $AttachmentDeleteElement = $(this);

            Core.UI.Dialog.ShowContentDialog(
                $('#DeleteAttachmentDialogContainer'),
                Core.Language.Translate('Delete this Attachment'),
                '240px',
                'Center',
                true,
                [
                    {
                        Class: 'Primary',
                        Label: Core.Language.Translate("Confirm"),
                        Function: function() {
                            $('.Dialog .InnerContent .Center').text(Core.Language.Translate("Deleting attachment..."));
                            $('.Dialog .Content .ContentFooter').remove();

                            Core.AJAX.FunctionCall(
                                Core.Config.Get('Baselink') + 'Action=AdminAttachment;Subaction=Delete',
                                { ID: $AttachmentDeleteElement.data('id') },
                                function(Reponse) {
                                    var DialogText = Core.Language.Translate("There was an error deleting the attachment. Please check the logs for more information.");
                                    if (parseInt(Reponse, 10) > 0) {
                                        $('#AttachmentID_' + parseInt(Reponse, 10)).fadeOut(function() {
                                            $(this).remove();
                                        });
                                        DialogText = Core.Language.Translate("Attachment was deleted successfully.");
                                    }
                                    $('.Dialog .InnerContent .Center').text(DialogText);
                                    window.setTimeout(function() {
                                        Core.UI.Dialog.CloseDialog($('.Dialog:visible'));
                                    }, 1000);
                                }
                            );
                        }
                    },
                    {
                        Label: Core.Language.Translate("Cancel"),
                        Function: function () {
                            Core.UI.Dialog.CloseDialog($('#DeleteAttachmentDialog'));
                        }
                    }
                ]
            );
            return false;
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
 }(Core.Agent.Admin.Attachment || {}));
