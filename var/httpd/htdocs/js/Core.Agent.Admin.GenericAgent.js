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
 * @namespace Core.Agent.Admin.GenericAgentEvent
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the GenericInterface job module.
 */
Core.Agent.Admin.GenericAgent = (function (TargetNS) {

    var RemoveButtonHTML = '<a href="#" title="'
        + Core.Language.Translate('Remove this dynamic field')
        + '" class="RemoveButton SpacingLeft"><i class="fa fa-minus-square-o"></i><span class="InvisibleText">'
        + Core.Language.Translate('Remove') + '</span></a>';

    /**
     * @private
     * @name AddSelectClearButton
     * @memberof Core.Agent.Admin.GenericAgentEvent
     * @function
     * @description
     *      Adds a button next to every select field to clear the selection.
     *      Only select fields with size > 1 are selected (no dropdowns).
     */
    function AddSelectClearButton() {
        var $SelectFields = $('select'),
            ModernizeActive = parseInt(Core.Config.Get('InputFieldsActivated'), 10);

        // Loop over all select fields available on the page
        $SelectFields.each(function () {
            var Size = parseInt($(this).attr('size'), 10),
                ModernizeField = $(this).hasClass('Modernize'),
                $SelectField = $(this),
                SelectID = this.id,
                Multiple = $(this).attr('multiple'),
                ButtonHTML = '<a href="#" title="' + Core.Language.Translate('Remove selection') + '" class="GenericAgentClearSelect" data-select="' + SelectID + '"><span>' + Core.Language.Translate('Remove selection') + '</span><i class="fa fa-undo"></i></a>';


            // Only handle fields without class Modernize when modernized is disabled
            if (ModernizeActive && ModernizeField) {
                return;
            }

            // Only handle select fields with a size > 1
            // DynamicFields return a Size of NaN,
            // they only need a clear button if they have the attribute multiple
            if ((isNaN(Size) && !Multiple) || Size <= 1) {
                return;
            }

            // If select field has a tree selection icon already,
            // we want to insert the new code after that element
            if ($SelectField.next('a.ShowTreeSelection').length) {
                $SelectField = $SelectField.next('a.ShowTreeSelection');
            }

            // insert button HTML
            $SelectField.after(ButtonHTML);
        });

        // Bind click event on newly inserted button
        // The name of the corresponding select field is saved in a data attribute
        $('.GenericAgentClearSelect').on('click.ClearSelect', function () {
            var SelectID = $(this).data('select'),
                $SelectField = $('#' + SelectID);

            if (!$SelectField.length) {
                return false;
            }

            // Clear field value
            // setting val('') is not enough since we have selects with an empty value that would be selected
            $SelectField[0].selectedIndex = -1;
            $(this).blur();

            return false;
        });
    }

    /**
     * @name Init
     * @memberof Core.Agent.Admin.GenericAgentEvent
     * @function
     * @description
     *      This function initialize correctly all other function according to the local language.
     */
    TargetNS.Init = function () {

        $('.DeleteEvent').on('click', function (Event) {
            TargetNS.ShowDeleteEventDialog(Event, $(this));
            return false;
        });

        $('#GenericAgentJobs a.TrashCan').on('click', function () {
            if (window.confirm(Core.Language.Translate('Do you really want to delete this generic agent job?'))) {
                return true;
            }
            return false;
        });

        $('#TicketEvent').on('change', function (){
            if ($('#EventType').val() !== null) {
                TargetNS.AddEvent($('#EventType').val());
            }
        });

        $('#ArticleEvent').on('change', function (){
            if ($('#EventType').val() !== null) {
                TargetNS.AddEvent($('#EventType').val());
            }
        });

        $('#EventType').on('change', function (){
            TargetNS.ToggleEventSelect($(this).val());
            Core.UI.InputFields.Activate($('.EventTypeName'));
        });
        TargetNS.ToggleEventSelect($('#EventType').val());

        Core.UI.Table.InitTableFilter($("#FilterGenericAgentJobs"), $("#GenericAgentJobs"));

        // Add select clear button
        AddSelectClearButton();

        $('#AddDynamicFields, #AddNewDynamicFields').on('change', function () {
            var Widget = $(this).closest('div.Field').data('widget');

            if (Widget === 'Select' || Widget === 'Update') {
                TargetNS.InsertDynamicField(Widget, $(this).val());
            }
        });

        // On page load, add remove button and init its click event.
        $('#SelectedDynamicFields, #SelectedNewDynamicFields').find('div.Field').each(function() {
            var AddFieldsID;

            if ($(this).closest('#SelectedDynamicFields').length) {
                AddFieldsID = 'AddDynamicFields';
            }
            else {
                AddFieldsID = 'AddNewDynamicFields';
            }

            $(this).append(RemoveButtonHTML);
            TargetNS.InitRemoveButtonEvent($(this).find('.RemoveButton'), AddFieldsID);
        });
    };

    /**
     * @name InsertDynamicField
     * @memberof Core.Agent.Admin.GenericAgentEvent
     * @function
     * @param {String} Widget - Widget where insert action occurs.
     * @param {String} Value - value selected from dropdown.
     * @description
     *      Initializes remove button click event.
     */
    TargetNS.InsertDynamicField = function (Widget, Value) {
        var Data,
            AddFieldsID,
            SelectedFieldsID,
            DynamicFieldsJS = Core.Config.Get('DynamicFieldsJS');

        if (!Value) {
            return;
        }

        Data = {
            Action: 'AdminGenericAgent',
            Subaction: 'AddDynamicField',
            DynamicFieldID: DynamicFieldsJS[Value].ID,
            SelectedValue: Value,
            Widget: Widget
        };

        if (Widget === 'Select') {
            Data.Type = DynamicFieldsJS[Value].Type
            AddFieldsID = 'AddDynamicFields';
            SelectedFieldsID = 'SelectedDynamicFields';
        }
        else if (Widget === 'Update') {
            AddFieldsID = 'AddNewDynamicFields';
            SelectedFieldsID = 'SelectedNewDynamicFields';
        }

        // Get field HTML by AJAX.
        Core.AJAX.FunctionCall(
            Core.Config.Get('CGIHandle'),
            Data,
            function (Response) {

                var FieldHTML = Response.Label + '<div class="Field" data-id="' + Response.ID + '">' + Response.Field + RemoveButtonHTML + '</div><div class="Clear"></div>';

                // Append field HTML from response to selected fields area.
                $('#' + SelectedFieldsID).append(FieldHTML);
                TargetNS.InitRemoveButtonEvent($('div.Field[data-id="' + Response.ID + '"]').find('.RemoveButton'), AddFieldsID);

                // Remove the field from add fields dropdown and redraw this dropdown.
                $('#' + AddFieldsID + ' option[value=' + Value + ']').remove();
                $('#' + AddFieldsID).val('').trigger('redraw.InputField').trigger('change');

                // Modernize field if there is select element.
                if ($('#' + Value).closest('div.Field').find('select.Modernize').length) {
                    Core.UI.InputFields.Activate($('#' + Value).closest('div.Field'));
                }

                // Register event for tree selection dialog
                $('.ShowTreeSelection').off('click').on('click', function () {
                    Core.UI.TreeSelection.ShowTreeSelection($(this));
                    return false;
                });

                // Trigger dynamic field event initialization (needed for specific fields from packages).
                Core.App.Publish('Event.DynamicField.Init', [Response.ID]);

                return false;

            }, 'json'
        );
    };

    /**
     * @name InitRemoveButtonEvent
     * @memberof Core.Agent.Admin.GenericAgentEvent
     * @function
     * @param {String} $Element - jQuery element with 'RemoveButton' class.
     * @param {String} AddFieldsID - ID of dropdown where dynamic field has to be added back.
     * @description
     *      Initializes remove button click event.
     */
    TargetNS.InitRemoveButtonEvent = function ($Element, AddFieldsID) {
        $Element.off('click').on('click', function(Event) {
            var Value = $(this).closest('div.Field').data('id'),
                Text  = Core.Config.Get('DynamicFieldsJS')[Value].Text,
                Options,
                OptionObjects = [];

            // Add dynamic field to add fields dropdown.
            $('#' + AddFieldsID).append('<option value=' + Value + '>' + Text + '</option>');

            // Sort options.
            Options = $('#' + AddFieldsID + ' option');
            OptionObjects = Options.map(function(_, Element) { return { Text: $(Element).text(), Value: Element.value }; }).get();
            OptionObjects.sort(function(Object1, Object2) { return Object1.Text > Object2.Text ? 1 : Object1.Text < Object2.Text ? -1 : 0; });
            Options.each(function(Index, Element) {
                Element.value = OptionObjects[Index].Value;
                $(Element).text(OptionObjects[Index].Text);
            });

            // Remove a label, div.Clear and div.Field elements from selected fields area.
            $(this).closest('div.Field').prev('label').remove();
            $(this).closest('div.Field').next('div.Clear').remove();
            $(this).closest('div.Field').remove();

            Event.stopPropagation();
            Event.preventDefault();
            return false;
        });
    };

    /**
     * @name ToggleEventSelect
     * @memberof Core.Agent.Admin.GenericAgentEvent
     * @function
     * @param {String} SelectedEventType - Event Type.
     * @description
     *      Toggles the event selection.
     */
    TargetNS.ToggleEventSelect = function (SelectedEventType) {
        $('.EventList').parent().hide();
        $('#' + SelectedEventType + 'Event').parent().show();
    };


    /**
     * @name AddEvent
     * @memberof Core.Agent.Admin.GenericAgentEvent
     * @function
     * @param {String} EventType - The type of event trigger to assign to a job i.e. ticket or article.
     * @description
     *      This function calls the AddEvent action on the server.
     */
    TargetNS.AddEvent = function (EventType) {

        var $Clone = $('.EventRowTemplate').clone(),
            EventName = $('#' + EventType + 'Event').val(),
            IsDuplicated = false;

        if (!EventName) {
            return;
        }

        // check for duplicated entries
        $('[class*=EventValue]').each(function() {
            if ($(this).val() === EventName) {
                IsDuplicated = true;
            }
        });
        if (IsDuplicated) {
            TargetNS.ShowDuplicatedDialog('EventName');
            return;
        }

        // add needed values
        $Clone.find('.EventType').html(EventType);
        $Clone.find('.EventName').html(EventName);
        $Clone.find('.EventValue').attr('name', 'EventValues').val(EventName);

        // bind delete function
        $Clone.find('#DeleteEvent').on('click', function (Event) {
            // remove row
            TargetNS.ShowDeleteEventDialog(Event, $(this));
            return false;
        });

        // remove unneeded classes
        $Clone.removeClass('Hidden EventRowTemplate');

        // append to container
        $('#EventsTable > tbody:last').append($Clone);

    };

    /**
     * @name ShowDeleteEventDialog
     * @memberof Core.Agent.Admin.GenericAgentEvent
     * @function
     * @param {EventObject} Event - Object of the clicked element.
     * @param {jQueryObject} Object
     * @description
     *      This function shows a confirmation dialog with 2 buttons.
     */
    TargetNS.ShowDeleteEventDialog = function(Event, Object){
        Core.UI.Dialog.ShowContentDialog(
            $('#DeleteEventDialogContainer'),
            Core.Language.Translate('Delete this Event Trigger'),
            '240px',
            'Center',
            true,
            [
               {
                   Label: Core.Language.Translate('Cancel'),
                   Class: 'Primary',
                   Function: function () {
                       Core.UI.Dialog.CloseDialog($('#DeleteEventDialog'));
                   }
               },
               {
                   Label: Core.Language.Translate('Delete'),
                   Function: function () {
                       Object.parents('tr:first').remove();
                       Core.UI.Dialog.CloseDialog($('#DeleteEventDialog'));
                   }
               }
           ]
        );

        Event.stopPropagation();
        Event.preventDefault();
    };

    /**
     * @name ShowDuplicatedDialog
     * @memberof Core.Agent.Admin.GenericAgentEvent
     * @function
     * @description
     *      This function shows an alert dialog for duplicated entries.
     */
    TargetNS.ShowDuplicatedDialog = function() {
        Core.UI.Dialog.ShowAlert(
            Core.Language.Translate('Duplicate event.'),
            Core.Language.Translate('This event is already attached to the job, Please use a different one.'),
            function () {
                Core.UI.Dialog.CloseDialog($('.Alert'));
                $('#EventType').focus();
                return false;
            }
        );
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.GenericAgent || {}));
