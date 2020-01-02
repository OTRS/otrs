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

/**
 * @namespace Core.Agent.TicketFormDraft
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the ticket FormDraft functionality.
 */
Core.Agent.TicketFormDraft = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.TicketFormDraft
     * @function
     * @description
     *       Initialize module functionality
     */
    TargetNS.Init = function () {

        // Bind click event to FormDraftUpdate button.
        $("#FormDraftUpdate").on("click", function() {
            var $Form = $(this).closest('form'),
                Data;

            Core.Form.Validate.DisableValidation($Form);
            $('#FormDraftAction').val('Update');

            // add a loader icon to the update button
            Core.Form.DisableForm($Form);
            $(this).find('span i').hide().after('<i class="fa fa-spinner fa-spin" />');

            // wait 300ms to make sure the hidden textarea of any richtext editors has been
            // updated properly (which takes 250ms by definition, see Core.UI.RichTextEditor.js)
            window.setTimeout(function() {
                Data = Core.AJAX.SerializeForm($Form);
                Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {
                    if (Response.Success == 0) {
                        alert(Response.ErrorMessage);
                        $(this).find('span i.fa-spinner').remove();
                        Core.Form.EnableForm($Form);
                    }
                    else {
                        Core.UI.Dialog.CloseDialog($(".Dialog"));
                        Core.UI.Popup.ClosePopup();
                    }
                });
            }, 300);

            return false;
        });

        // Bind click event to FormDraftSave button.
        $("#FormDraftSave").on("click", function() {
            var $Form = $(this).closest('form'),
                DialogTemplate = Core.Template.Render('Agent/FormDraftAddDialog', {});

            Core.Form.Validate.DisableValidation($Form);

            Core.UI.Dialog.ShowContentDialog($(DialogTemplate), Core.Language.Translate('Add new draft'), '150px', 'Center', true);

            $("button#SaveFormDraft").off("click").on("click", function() {
                var Data;

                $('#FormDraftAction').val('Add');

                // Update hidden input field on the form with value from the Dialog.
                $('input[name="FormDraftTitle"]').val($('input#FormDraftTitle').val());
                $(".Dialog:visible .AJAXLoader").show();

                // wait 300ms to make sure the hidden textarea of any richtext editors has been
                // updated properly (which takes 250ms by definition, see Core.UI.RichTextEditor.js)
                window.setTimeout(function() {

                    Data = Core.AJAX.SerializeForm($Form);

                    // Mark article as seen in backend
                    Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {
                        if (Response.Success == 0) {
                            $(".Dialog:visible .AJAXLoader").hide();
                            alert(Response.ErrorMessage);
                            $('#FormDraftAction').val('');
                        }
                        else {
                            Core.UI.Dialog.CloseDialog($(".Dialog"));
                            Core.UI.Popup.ExecuteInParentWindow(function (ParentWindow) {
                                ParentWindow.Core.UI.Popup.FirePopupEvent('Reload');
                            });

                            Core.UI.Popup.ClosePopup();
                        }
                    });
                }, 300);
            });

            $("button.CloseDialog").off("click").on("click", function() {
                Core.UI.Dialog.CloseDialog($(".Dialog"));
            });
            return false;
        });

        $('a.FormDraftDelete').on('click', function() {
            var $Link = $(this),
                DialogTemplate = Core.Template.Render('Agent/TicketZoom/FormDraftDeleteDialog', {
                    Title: $Link.data("title"),
            });

            Core.UI.Dialog.ShowContentDialog($(DialogTemplate), Core.Language.Translate('Delete draft'), '150px', 'Center', true);

            $("button#DeleteConfirm").off("click").on("click", function() {
                var $AJAXLoader = $Link.closest(".AJAXLoader");

                $AJAXLoader.show();
                Core.UI.Dialog.CloseDialog($(".Dialog"));

                Core.AJAX.FunctionCall($Link.attr('href'), {}, function (Response) {
                    if (Response.Success == 1) {
                        $Link.closest("tr").remove();

                        if($('#FormDraftTable tbody tr').length == 0) {
                            $('#FormDraftTable').replaceWith(
                                Core.Language.Translate("There are no more drafts available.")
                            );
                        }
                    }
                    else if(Response.Error) {
                        alert(Response.Error);
                        $AJAXLoader.hide();
                    }
                    else {
                        alert(Core.Language.Translate("It was not possible to delete this draft."));
                        $AJAXLoader.hide();
                    }
                });
            });

            $("button.CloseDialog").off("click").on("click", function() {
                Core.UI.Dialog.CloseDialog($(".Dialog"));
            });

            return false;
        });


        // click event for whole table row
        $('.MasterAction').off('click').on('click', function (Event) {
            var $MasterActionLink = $(this).find('.MasterActionLink');

            // only act if the link was not clicked directly
            if (Event.target !== $MasterActionLink.get(0)) {
                Core.UI.Popup.OpenPopup($MasterActionLink.attr('href'));

                return false;
            }
        });

    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.TicketFormDraft || {}));
