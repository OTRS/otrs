// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

/*global Clipboard */

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};
Core.Agent.Admin = Core.Agent.Admin || {};
Core.Agent.Admin.AppointmentCalendar = Core.Agent.AppointmentCalendar || {};

/**
 * @namespace Core.Agent.Admin.AppointmentCalendar.Manage
 * @memberof Core.Agent.AppointmentCalendar
 * @author OTRS AG
 * @description
 *      This namespace contains the appointment calendar management functions.
 */
Core.Agent.Admin.AppointmentCalendar.Manage = (function (TargetNS) {

    var RuleCount = 0;

    /**
     * @name InitTicketAppointments
     * @memberof Core.Agent.Admin.AppointmentCalendar.Manage
     * @param {Integer} InitialRuleCount - From which rule the count should start (optional)
     * @description
     *      Initialize the ticket appointment fields behavior.
     */
    TargetNS.InitTicketAppointments = function (InitialRuleCount) {
        var $AddRuleObj = $('#AddRuleButton'),
            TemplateHTML = Core.Template.Render('Agent/AppointmentCalendar/TicketAppointmentRule', {
                'TicketAppointments': Core.Config.Get('TicketAppointments')
            });

        if (InitialRuleCount) {
            RuleCount = parseInt(InitialRuleCount, 10);
        }

        $AddRuleObj.off('click.AppointmentCalendar').on('click.AppointmentCalendar', function () {
            var RuleID = ++RuleCount,
                $RuleObj = $(TemplateHTML),
                $ContainerObj = $AddRuleObj.parents('fieldset');

            $RuleObj

                // Rule number
                .find('.RuleNumber')
                .text(RuleID)
                .end()

                // Start date field and label
                .find('#StartDate')
                .attr('id', 'StartDate_' + RuleID)
                .attr('name', 'StartDate_' + RuleID)
                .parent()
                .prev('label')
                .attr('for', 'StartDate_' + RuleID)
                .end()
                .end()
                .end()

                // End date field and label
                .find('#EndDate')
                .attr('id', 'EndDate_' + RuleID)
                .attr('name', 'EndDate_' + RuleID)
                .parent()
                .prev('label')
                .attr('for', 'EndDate_' + RuleID)
                .end()
                .end()
                .end()

                // Queues field, label and error
                .find('#QueueID')
                .attr('id', 'QueueID_' + RuleID)
                .attr('name', 'QueueID_' + RuleID)
                .end()
                .find('label[for="QueueID"]')
                .attr('for', 'QueueID_' + RuleID)
                .end()
                .find('#QueueIDError')
                .attr('id', 'QueueID_' + RuleID + 'Error')
                .end()

                .insertBefore($ContainerObj);

            Core.UI.InputFields.Activate($RuleObj);

            // Initialize rule buttons
            TargetNS.InitTicketAppointmentRule(RuleID, $RuleObj);

            return false;
        });
    }

    /**
     * @name InitTicketAppointmentRule
     * @memberof Core.Agent.Admin.AppointmentCalendar.Manage
     * @param {Integer} RuleID - ID of the rule (1, 2, 3...)
     * @param {jQueryObject} $RuleObj - Rule object
     * @description
     *      Initialize the ticket appointment rule buttons behavior.
     */
    TargetNS.InitTicketAppointmentRule = function (RuleID, $RuleObj) {
        var $RemoveObj = $RuleObj.find('legend .RemoveButton'),
            $RemoveParamObj = $RuleObj.find('.Field > .RemoveButton'),
            $AddParamObj = $RuleObj.find('.AddButton'),
            $ParamObj = $RuleObj.find('.SearchParams'),
            $TicketAppointments = Core.Config.Get('TicketAppointments'),
            TemplateHTML = Core.Template.Render('Agent/AppointmentCalendar/TicketAppointmentSearchParam', {
                'SearchParamUser': $TicketAppointments.SearchParamUser
            });

        $ParamObj.val($ParamObj.find('option:enabled').first().attr('value'));

        $RemoveObj.off('click.AppointmentCalendar').on('click.AppointmentCalendar', function () {
            $RuleObj.remove();
            UpdateRuleCount();

            return false;
        });

        $RemoveParamObj.off('click.AppointmentCalendar').on('click.AppointmentCalendar', function () {
            var $SearchParamObj = $(this).parent(),
                ParamName = $SearchParamObj.find('.SearchParam').data('param');

            $SearchParamObj.remove();
            $ParamObj.find('option[value="' + ParamName + '"]')
                .prop('disabled', false)
                .end()
                .val($ParamObj.find('option:enabled').first().attr('value'))
                .trigger('redraw.InputField');

            return false;
        });

        $AddParamObj.off('click.AppointmentCalendar').on('click.AppointmentCalendar', function () {
            var $SearchParamObj = $(TemplateHTML),
                $SearchParamContainerObj = $RuleObj.find('.SearchParamsContainer'),
                $RemoveParamObj = $SearchParamObj.find('.RemoveButton'),
                ParamName = $ParamObj.val();

            if (!ParamName) {
                return false;
            }

            $ParamObj.find('option[value="' + ParamName + '"]')
                .prop('disabled', true)
                .end()
                .val($ParamObj.find('option:enabled').first().attr('value'))
                .trigger('redraw.InputField');

            // Label
            $SearchParamObj
                .find('label')
                .attr('for', 'SearchParam_' + RuleID + '_' + ParamName)
                .find('span')
                .after(' ' + $ParamObj.find('option[value="' + ParamName + '"]').text() + ':');

            // OwnerIDs and ResponsibleIDs are multi-select fields.
            if (ParamName === 'OwnerIDs' || ParamName === 'ResponsibleIDs') {
                $SearchParamObj
                    .find('select')
                    .attr('id', 'SearchParam_' + RuleID + '_' + ParamName)
                    .attr('name', 'SearchParam_' + RuleID + '_' + ParamName)
                    .end()
                    .find('#SearchParamError')
                    .attr('id', 'SearchParam_' + RuleID + '_' + ParamName + 'Error')
                    .end()
                    .find('input')
                    .remove();
            }

            // Input field and error message
            else {
                $SearchParamObj
                    .find('input')
                    .attr('id', 'SearchParam_' + RuleID + '_' + ParamName)
                    .attr('name', 'SearchParam_' + RuleID + '_' + ParamName)
                    .end()
                    .find('#SearchParamError')
                    .attr('id', 'SearchParam_' + RuleID + '_' + ParamName + 'Error')
                    .end()
                    .find('select')
                    .remove();
            }

            $SearchParamObj.appendTo($SearchParamContainerObj);
            Core.UI.InputFields.Activate($SearchParamContainerObj);

            $RemoveParamObj.off('click.AppointmentCalendar').on('click.AppointmentCalendar', function () {
                $SearchParamObj.remove();
                $ParamObj.find('option[value="' + ParamName + '"]')
                    .prop('disabled', false)
                    .end()
                    .val($ParamObj.find('option:enabled').first().attr('value'))
                    .trigger('redraw.InputField');

                return false;
            });

            return false;
        });
    }

    function UpdateRuleCount() {
        var $RuleNumberObj = $('.RuleNumber:visible');

        $RuleNumberObj.each(function (Index, Element) {
            $(Element).text(Index + 1);
        });

        RuleCount = $RuleNumberObj.length;
    }

    /**
     * @name Init
     * @memberof Core.Agent.AppointmentCalendar
     * @description
     *      Initializes the calendar management screen.
     */
    TargetNS.Init = function () {
        var ClipboardJS;

        if (
            Core.Config.Get('Subaction') == 'New'
            || Core.Config.Get('Subaction') == 'StoreNew'
            || Core.Config.Get('Subaction') == 'Edit'
            || Core.Config.Get('Subaction') == 'Update'
            )
        {
            // Initialize ticket appointment behavior.
            TargetNS.InitTicketAppointments(Core.Config.Get('CalendarRuleCount'));

            // Initialize existing ticket appointment rules.
            $.each(Core.Config.Get('RuleIDs'), function (Index, RuleID) {
                TargetNS.InitTicketAppointmentRule(RuleID, $('#Rule_' + Core.App.EscapeSelector(RuleID)));
            });

            // Initialize color picker.
            $('input#Color').spectrum({
                color: Core.Config.Get('CalendarColor'),
                containerClassName: 'ColorPaletteContainer',
                hideAfterPaletteSelect: true,
                preferredFormat: 'hex',
                replacerClassName: 'ColorPaletteButton',
                showInput: true,
                showPalette: true,
                showPaletteOnly: true,
                showSelectionPalette: false,
                togglePaletteOnly: true,
                togglePaletteMoreText: Core.Language.Translate('More'),
                togglePaletteLessText: Core.Language.Translate('Less'),
                chooseText: Core.Language.Translate('Confirm'),
                cancelText: Core.Language.Translate('Cancel'),
                palette: Core.Config.Get('CalendarColorPalette')
            });

            return;
        }

        ClipboardJS = new Clipboard('.CopyToClipboard');

        Core.UI.Table.InitTableFilter($('#FilterCalendars'), $('#Calendars'));

        ClipboardJS.on('success', function (Event) {
            $(Event.trigger).hide()
                .fadeIn();
            Event.clearSelection();
        });

        ClipboardJS.on('error', function(Event) {
            Core.Form.ErrorTooltips.InitTooltip($(Event.trigger), Core.Language.Translate('Press Ctrl+C (Cmd+C) to copy to clipboard'));
            $(Event.trigger).focus();
        });

        // Click event for whole table row.
        $('.CalendarMasterAction').off('click').on('click', function (Event) {

            // Only act if the link was not clicked on Export, Download or URL button.
            if ($(Event.target).prop('tagName') === 'TD' || $(Event.target).prop('tagName') === 'SPAN') {
                window.location = $(this).find('.CalendarMasterActionLink').attr('href');
                return false;
            }
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.AppointmentCalendar.Manage || {}));
