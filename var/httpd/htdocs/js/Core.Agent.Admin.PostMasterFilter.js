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
 * @namespace Core.Agent.Admin.PostMasterFilter
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special function for PostMasterFilter module.
 */
 Core.Agent.Admin.PostMasterFilter = (function (TargetNS) {

    /*
    * @name Init
    * @memberof Core.Agent.Admin.PostMasterFilter
    * @function
    * @description
    *      This function initializes table filter.
    */
    TargetNS.Init = function () {

        Core.UI.Table.InitTableFilter($('#FilterPostMasterFilters'), $('#PostMasterFilters'));

        // delete postmaster filter
        TargetNS.InitPostMasterFilterDelete();

        // check all negate labels and add a marker color if negate is enabled
        $('.FilterFields label.Negate input').each(function() {
            if ($(this).is(':checked')) {
                $(this).closest('label').addClass('Checked');
            }
            else {
                $(this).closest('label').removeClass('Checked');
            }
        });

        $('.FilterFields label.Negate input').on('click', function() {
            if ($(this).is(':checked')) {
                $(this).closest('label').addClass('Checked');
            }
            else {
                $(this).closest('label').removeClass('Checked');
            }
        });

    };

    /**
     * @name PostMasterFilterDelete
     * @memberof Core.Agent.Admin.PostMasterFilter
     * @function
     * @description
     *      This function deletes postmaster filter on buton click.
     */
    TargetNS.InitPostMasterFilterDelete = function () {
        $('.PostMasterFilterDelete').on('click', function () {
            var $PostMasterFilterDelete = $(this);

            Core.UI.Dialog.ShowContentDialog(
                $('#DeletePostMasterFilterDialogContainer'),
                Core.Language.Translate('Delete this PostMasterFilter'),
                '240px',
                'Center',
                true,
                [
                    {
                        Class: 'Primary',
                        Label: Core.Language.Translate("Confirm"),
                        Function: function() {
                            $('.Dialog .InnerContent .Center').text(Core.Language.Translate("Deleting the postmaster filter and its data. This may take a while..."));
                            $('.Dialog .Content .ContentFooter').remove();

                            Core.AJAX.FunctionCall(
                                Core.Config.Get('Baselink'),
                                $PostMasterFilterDelete.data('query-string'),
                                function() {
                                   Core.App.InternalRedirect({
                                       Action: 'AdminPostMasterFilter'
                                   });
                                }
                            );
                        }
                    },
                    {
                        Label: Core.Language.Translate("Cancel"),
                        Function: function () {
                            Core.UI.Dialog.CloseDialog($('#DeletePostMasterFilterDialog'));
                        }
                    }
                ]
            );
            return false;
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.PostMasterFilter || {}));
