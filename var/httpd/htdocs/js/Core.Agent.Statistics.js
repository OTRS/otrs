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

        $('.ItemListGrid a').on('click', function () {
            var $Link = $(this);

            if ($Link.hasClass('Disabled')) {
                return false;
            }

            $('.ItemListGrid a').removeClass('Active');
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
            $(this).attr("id", $(this).attr("id").replace(/_orig/, '_selected'));
        });
        $ContainerElementClone.appendTo($FormFieldsElement);
    };

    /**
     * @name InitEditScreen
     * @memberof Core.Agent.Statistics
     * @function
     * @description
     *      Initialize the edit screen.
     */
    TargetNS.InitEditScreen = function() {
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

                $('.CustomerAutoCompleteSimple').each(function() {
                    Core.Agent.CustomerSearch.InitSimple($(this));
                });
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
                    { Label: Core.Language.Translate('Save'), Class: 'Primary', Type: '', Function: EditDialogSave },
                    { Label: Core.Language.Translate('Cancel'), Class: '', Type: 'Close', Function: EditDialogCancel }
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

                $('.CustomerAutoCompleteSimple').each(function() {
                    Core.Agent.CustomerSearch.InitSimple($(this));
                });

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

       $('.SwitchPreviewFormat').on('click', function() {
            var Format = $(this).data('format'),
                FormatCleaned = Format.replace('::', ''),
                StatsPreviewResult;

            StatsPreviewResult = Core.Data.CopyObject(Core.Config.Get('PreviewResult'));
            $('.SwitchPreviewFormat').removeClass('Active');
            $(this).addClass('Active');
            $('.PreviewContent:visible').hide();
            $('svg.PreviewContent').empty();
            $('#PreviewContent' + Core.App.EscapeSelector(FormatCleaned)).show();
            if (Format.match(/D3/)) {
                Core.UI.AdvancedChart.Init(
                    Format,
                    StatsPreviewResult,
                    'svg#PreviewContent' + Core.App.EscapeSelector(FormatCleaned),
                    {
                        HideLegend: true
                    }
                );
            }
            return false;
        });
        $('.SwitchPreviewFormat').first().trigger('click');
    }

    /**
     * @name Init
     * @memberof Core.Agent.Statistics
     * @function
     * @description
     *      This function initializes the module functionality.
     */
    TargetNS.Init = function () {
        var RestrictionElements,
            XAxisElements,
            YAxisElements,
            D3Data;

        // Set a postfix to the ids in the hidden container,
        //  because the fields will be cloned in the overlay.
        $('#XAxisContainer, #YAxisContainer, #RestrictionsContainer').find("*[id]").each(function() {
            $(this).attr("id", $(this).attr("id") + "_orig");
        });

        // Initialize the Add screen
        TargetNS.InitAddScreen();

        // Initialize the Edit screen
        TargetNS.InitEditScreen();

        // Bind event on delete stats button
        $('.StatDelete').on('click', function (Event) {
            var ConfirmText = '"' + $(this).data('stat-title') + '"\n\n' + Core.Language.Translate("Do you really want to delete this statistic?");
            if (!window.confirm(ConfirmText)) {
                Event.stopPropagation();
                Event.preventDefault();
                return false;
            }
        });

        // Bind event on start stats button
        $('#StartStatistic').on('click', function () {
            var Format = $('#Format').val(),
                $Form = $(this).parents('form');

            // Open both HTML and PDF output in a popup because PDF is shown inline
            if (Format === 'Print' || Format.match(/D3/)) {
                $Form.attr('target', '_blank');
            }
            else {
                $Form.removeAttr('target');
            }
        });

        // Bind save and finish button
        $('#SaveAndFinish').on('click', function(){
            $('#ReturnToStatisticOverview').val(1);
        });

        RestrictionElements = Core.Config.Get('RestrictionElements');
        if (typeof RestrictionElements !== 'undefined') {
            $.each(RestrictionElements, function() {
                TargetNS.ElementAdd('Restrictions', this);
            });
        }

        XAxisElements = Core.Config.Get('XAxisElements');
        if (typeof XAxisElements !== 'undefined') {
            $.each(XAxisElements, function() {
                TargetNS.ElementAdd('XAxis', this);
            });
        }

        YAxisElements = Core.Config.Get('YAxisElements');
        if (typeof YAxisElements !== 'undefined') {
            $.each(YAxisElements, function() {
                TargetNS.ElementAdd('YAxis', this);
            });
        }

        D3Data = Core.Config.Get('D3Data');
        if (typeof D3Data !== 'undefined') {
            Core.UI.AdvancedChart.Init(
                D3Data.Format,
                D3Data.RawData,
                'svg#ChartContent',
                {
                    Duration: 250
                }
            );
        }
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Statistics || {}));
