// --
// Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};

/**
 * @namespace Core.Agent.Statistics
 * @memberof Core.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the Statistics module.
 */
Core.Agent.Statistics = (function (TargetNS) {

    /**
     * @name InitAddScreen
     * @memberof Core.Agent.Statistics
     * @function
     * @description
     *      Initialize the add screen. Contains basically some logic to react on which
     *      of the big select buttons the agent uses. Afterwards, the specification widget
     *      is being loaded according to the clicked button.
     */
    TargetNS.InitAddScreen = function () {

        $('.BigButtons a').bind('click', function () {
            var $Link = $(this);

            if ($Link.hasClass('Disabled')) {
                return false;
            }

            $('.BigButtons a').removeClass('Active');
            $Link.addClass('Active');

            $('#GeneralSpecifications').fadeIn(function() {
                var URL = Core.Config.Get('Baselink'),
                    Data = {
                        Action: 'AgentStatistics',
                        Subaction: 'GeneralSpecificationsWidgetAJAX',
                        StatisticPreselection: $Link.data('statistic-preselection')
                    };

                $('#GeneralSpecifications .Content').addClass('Center').html('<span class="AJAXLoader"></span>');
                $('#SaveWidget').hide();

                Core.AJAX.FunctionCall(URL, Data, function(Response) {
                    $('#GeneralSpecifications .Content').removeClass('Center').html(Response);
                    Core.UI.InputFields.Activate($('#GeneralSpecifications .Content'));
                    $('#SaveWidget').show();
                }, 'html');
            });

            return false;
        });
    };

    TargetNS.ElementAdd = function(ConfigurationType, ElementName) {
        var $ContainerElement = $('#' + ConfigurationType + 'Container'),
            $FormFieldsElement = $('#' + ConfigurationType + 'FormFields'),
            $ContainerElementClone = $ContainerElement.find('.Element' + Core.App.EscapeSelector(ElementName)).clone();

        $ContainerElementClone.find("*[id]").each(function() {
            $(this).attr("id", $(this).attr("id") + "_selected");
        });
        $ContainerElementClone.appendTo($FormFieldsElement);
    };

    function InitEditDialog() {
        $('button.EditXAxis, button.EditYAxis, button.EditRestrictions').on('click', function() {
            var ConfigurationType = $(this).data('configuration-type'),
                ConfigurationLimit = $(this).data('configuration-limit'),
                DialogTitle = $(this).data('dialog-title'),
                $ContainerElement = $('#' + ConfigurationType + 'Container'),
                $FormFieldsElement = $('#' + ConfigurationType + 'FormFields'),
                $CloneFormFieldsElement;

            function RebuildEditDialogAddSelection() {
                $('#EditDialog .Add select').empty().append('<option>-</option>');
                $.each($ContainerElement.find('.Element'), function() {
                    var $Element = $(this),
                        ElementName = $Element.data('element');

                    if ($('#EditDialog .Fields .Element' + Core.App.EscapeSelector(ElementName)).length) {
                        return;
                    }

                    $($.parseHTML('<option></option>')).val(ElementName)
                        .text($Element.find('> legend > span').text().replace(/:\s*$/, ''))
                        .appendTo('#EditDialog .Add select');
                });
            }

            function EditDialogAdd(ElementName) {
                var $ElementClone = $ContainerElement.find('.Element' + Core.App.EscapeSelector(ElementName)).clone();

                // Remove the postfix from the IDs to get the real ids for the fields.
                $ElementClone.find("*[id]").each(function() {
                    $(this).attr("id", $(this).attr("id").replace(/_orig/, ''));
                });
                $ElementClone.appendTo($('#EditDialog .Fields'));

                if (ConfigurationLimit && $('#EditDialog .Fields .Element').length >= ConfigurationLimit) {
                    $('#EditDialog .Add').hide();
                }
                RebuildEditDialogAddSelection();
                Core.UI.InputFields.Activate($('#EditDialog .Fields'));
            }

            function EditDialogDelete(ElementName) {
                $('#EditDialog .Fields .Element' + Core.App.EscapeSelector(ElementName)).remove();
                $('#EditDialog .Add').show();
                RebuildEditDialogAddSelection();
            }

            function EditDialogSave() {
                $FormFieldsElement.empty();
                $('#EditDialog .Fields').children().appendTo($FormFieldsElement);
                Core.UI.Dialog.CloseDialog($('.Dialog'));
                $('form.StatsEditForm').submit();
            }

            function EditDialogCancel() {
                Core.UI.Dialog.CloseDialog($('.Dialog'));
            }

            Core.UI.Dialog.ShowContentDialog(
                '<div id="EditDialog"></div>',
                DialogTitle,
                100,
                'Center',
                true,
                [
                    { Label: Core.Config.Get('Translation.Save'), Class: 'Primary', Type: '', Function: EditDialogSave },
                    { Label: Core.Config.Get('Translation.Cancel'), Class: '', Type: 'Close', Function: EditDialogCancel }
                ],
                true
            );
            $('#EditDialogTemplate').children().clone().appendTo('#EditDialog');

            if ($FormFieldsElement.children().length) {
                $CloneFormFieldsElement = $FormFieldsElement.children().clone()
                $CloneFormFieldsElement.find("*[id]").each(function() {
                    $(this).attr("id", $(this).attr("id").replace(/_selected/, ''));
                });
                $CloneFormFieldsElement.appendTo('#EditDialog .Fields');
                Core.UI.InputFields.Activate($('#EditDialog .Fields'));
                if (ConfigurationLimit && $('#EditDialog .Fields .Element').length >= ConfigurationLimit) {
                    $('#EditDialog .Add').hide();
                }
            }
            else {
                $('#EditDialog .Add').show();
            }
            RebuildEditDialogAddSelection();

            $('#EditDialog .Add select').on('change', function(){
                EditDialogAdd($(this).val());
            });

            $('#EditDialog .Fields').on('click', '.RemoveButton', function(){
                EditDialogDelete($(this).parents('.Element').data('element'));
                return false;
            });

            // Selection helpers for time fields
            $('#EditDialog .Fields .ElementBlockTime .Field select').on('change', function() {
                $(this).parent('.Field').prev('label').find('input:radio').prop('checked', true);
            });

            Core.UI.TreeSelection.InitTreeSelection();

            // Datepickers don't work if added dynamically atm, so hide for now.
            $('a.DatepickerIcon').hide();

            return false;
        });
    }

    /**
     * @name InitEditScreen
     * @memberof Core.Agent.Statistics
     * @function
     * @description
     *      Initialize the edit screen.
     */
    TargetNS.InitEditScreen = function () {

        // Set a postfix to the ids in the hidden container,
        //  because the fields will be cloned in the overlay.
        $('#XAxisContainer, #YAxisContainer, #RestrictionsContainer').find("*[id]").each(function() {
            $(this).attr("id", $(this).attr("id") + "_orig");
        });

        InitEditDialog();
    };

    return TargetNS;
}(Core.Agent.Statistics || {}));
