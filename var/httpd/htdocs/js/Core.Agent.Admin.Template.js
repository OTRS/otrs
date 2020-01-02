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
 * @namespace Core.Agent.Admin.Template
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special function for AdminTemplate module.
 */
 Core.Agent.Admin.Template = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Admin.Template
     * @function
     * @description
     *      This function initializes the table filter.
     */
    TargetNS.Init = function () {
        Core.UI.Table.InitTableFilter($('#Filter'), $('#Templates'));

        // delete template
        TargetNS.InitTemplateDelete();
    };

    /**
     * @name TemplateDelete
     * @memberof Core.Agent.Admin.Template
     * @function
     * @description
     *      This function deletes template on buton click.
     */
    TargetNS.InitTemplateDelete = function () {
        $('.TemplateDelete').on('click', function () {
            var TemplateDelete = $(this);

            Core.UI.Dialog.ShowContentDialog(
                $('#DeleteTemplateDialogContainer'),
                Core.Language.Translate('Delete this Template'),
                '240px',
                'Center',
                true,
                [
                    {
                        Class: 'Primary',
                        Label: Core.Language.Translate("Confirm"),
                        Function: function() {
                            $('.Dialog .InnerContent .Center').text(Core.Language.Translate("Deleting the template and its data. This may take a while..."));
                            $('.Dialog .Content .ContentFooter').remove();

                            Core.AJAX.FunctionCall(
                                Core.Config.Get('Baselink'),
                                TemplateDelete.data('query-string'),
                                function() {
                                   Core.App.InternalRedirect({
                                       Action: 'AdminTemplate'
                                   });
                                }
                            );
                        }
                    },
                    {
                        Label: Core.Language.Translate("Cancel"),
                        Function: function () {
                            Core.UI.Dialog.CloseDialog($('#DeleteTemplateDialog'));
                        }
                    }
                ]
            );
            return false;
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
 }(Core.Agent.Admin.Template || {}));
