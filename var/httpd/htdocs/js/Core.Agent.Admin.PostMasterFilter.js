// --
// Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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

        InitSelectableOptions("MatchHeader");
        InitSelectableOptions("SetHeader");
    };

    function InitSelectableOptions(IDPrefix) {
        // set data-old attribute
        $(".FilterFields select[id^='" + IDPrefix + "']").each(function() {
            var SelectedValue = $(this).val();

            $(this).attr("data-old", SelectedValue);

            // disable option on other selects
            $(".FilterFields select[id^='" + IDPrefix + "']:not([id='" + $(this).attr("id") + "'])").each(function() {
                $(this).find("option[value='" + SelectedValue + "']").attr('disabled','disabled');
            });
        });

        $(".FilterFields select[id^='" + IDPrefix + "']").on("change", function() {
            var SelectedValue = $(this).val(),
                OldValue = $(this).attr("data-old");

            // disable option on other selects
            $(".FilterFields select[id^='" + IDPrefix + "']:not([id='" + $(this).attr("id") + "'])").each(function() {
                $(this).find("option[value='" + SelectedValue + "']").attr('disabled','disabled');
            });

            // enable old value for all selects
            if (OldValue != "") {
                $(".FilterFields select[id^='" + IDPrefix + "'] option[value='" + OldValue + "']").removeAttr("disabled");
            }

            // Update old value
            $(this).attr("data-old", $(this).val());

            // initialize all modern input fields
            $(".FilterFields select.Modernize[id^='" + IDPrefix + "']").trigger('redraw.InputField');
        });
    }

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
                        Class: 'CallForAction Primary',
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
                        Class: 'CallForAction',
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
