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
 * @namespace Core.Agent.Admin.GenericInterfaceInvokerEvent
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the GenericInterface Invoker Events.
 */
Core.Agent.Admin.GenericInterfaceInvokerEvent= (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Admin.GenericInterfaceInvokerEvent
     * @function
     * @description
     *      Initializes the module functions.
     */
    TargetNS.Init = function () {

        TargetNS.InvokerEvent = Core.Config.Get('InvokerEvent');

        // Init addition of new conditions
        $('#ConditionAdd').on('click', function() {
            // get current parent index
            var CurrentParentIndex = parseInt($(this).prev('.WidgetSimple').first().attr('id').replace(/Condition\[/g, '').replace(/\]/g, ''), 10),
                // in case we add a whole new condition, the fieldindex must be 1
                LastKnownFieldIndex = 1,
                // get current index
                ConditionHTML = $('#ConditionContainer').html().replace(/_INDEX_/g, CurrentParentIndex + 1).replace(/_FIELDINDEX_/g, LastKnownFieldIndex);

            $($.parseHTML(ConditionHTML)).insertBefore($('#ConditionAdd'));
            Core.UI.InputFields.Init();
            return false;
        });

        $('#PresentConditionsContainer').delegate('.ParentWidget > .Header .RemoveButton', 'click', function() {
            if ($('#PresentConditionsContainer').find('.ConditionField').length > 1) {

                $(this).closest('.WidgetSimple').remove();
            }
            else {
                alert(Core.Language.Translate("Sorry, the only existing condition can't be removed."));
            }

            return false;
        });

        // Init addition of new fields within conditions
        $('#PresentConditionsContainer').off('click.AddField').on('click.AddField', '.FieldWidget .AddButton', function() {
            // get current parent index
            var CurrentParentIndex = $(this).closest('.ParentWidget').attr('id').replace(/Condition\[/g, '').replace(/\]/g, ''),
                // get the index for the newly to be added element
                // therefore, we search the preceding fieldset and the first
                // label in it to get its "for"-attribute which contains the index
                LastKnownFieldIndex = parseInt($(this).closest('.WidgetSimple').find('.Content').find('label').first().attr('for').replace(/ConditionFieldName\[\d+\]\[/, '').replace(/\]/, ''), 10),
                // add new field
                ConditionFieldHTML = $('#ConditionFieldContainer').html().replace(/_INDEX_/g, CurrentParentIndex).replace(/_FIELDINDEX_/g, LastKnownFieldIndex + 1);

            $($.parseHTML(ConditionFieldHTML)).insertAfter($(this).closest('.WidgetSimple').find('fieldset').last());
            Core.UI.InputFields.Init();
            return false;
        });

        // Init removal of fields within conditions
        $('#PresentConditionsContainer').off('click.RemoveField').on('click.RemoveField', '.FieldWidget .RemoveButton', function() {
            if ($(this).closest('.Content').find('fieldset').length > 1) {
                $(this).parent().closest('fieldset').remove();
            }
            else {
                alert(Core.Language.Translate("Sorry, the only existing field can't be removed."));
            }

            return false;
        });

        $('#Submit').bind('click', function() {
            $('#EventForm').submit();
            return false;
        });

        Core.Form.Validate.SetSubmitFunction($('#EventForm'), function (Form) {
            var ConditionConfig = TargetNS.GetConditionConfig($('#PresentConditionsContainer').find('.ConditionField'));
            $('input[name=ConditionConfig]').val(Core.JSON.Stringify(ConditionConfig));

            Form.submit();
        });

        $('.ClosePopup').bind("click", function () {
            $(window).unbind("beforeunload.PMPopup");
        });

        $('#DeleteButton').on('click', TargetNS.ShowDeleteDialog);
    };

   /**
     * @name GetConditionConfig
     * @memberof Core.Agent.Admin.GenericInterfaceInvokerEvent
     * @function
     * @returns {Object} Parsed conditions configuration.
     * @param {Object} $Conditions - Conditions configuration.
     * @description
     *      This function shows a confirmation dialog with 2 buttons.
     */
    TargetNS.GetConditionConfig = function ($Conditions) {
         var Conditions = {},
            ConditionKey;

        if (!$Conditions.length) {
            return {};
        }

        $Conditions.each(function() {

            // get condition key
            ConditionKey = $(this).closest('.WidgetSimple').attr('id').replace(/(Condition\[|\])/g, '');

            // use condition key as key for our list
            Conditions[ConditionKey] = {
                Type: $(this).find('.Field > select').val(),
                Fields: {}
            };

            // get all fields of the current condition
            $(this).find('.FieldWidget fieldset').each(function() {
                Conditions[ConditionKey].Fields[$(this).find('input').first().val()] = {
                    Type: $(this).find('select').val(),
                    Match: $(this).find('input').last().val()
                };
            });

        });

        return Conditions;
    };

    /**
     * @name ShowDeleteDialog
     * @memberof Core.Agent.Admin.GenericInterfaceWebserviceEvent
     * @function
     * @param {Object} Event - The browser event object, e.g. of the clicked DOM element.
     * @description
     *      Shows a confirmation dialog to delete all the conditions.
     */
    TargetNS.ShowDeleteDialog = function(Event){
        Core.UI.Dialog.ShowContentDialog(
            $('#DeleteDialogContainer'),
            Core.Language.Translate('Delete conditions'),
            '240px',
            'Center',
            true,
            [
                {
                     Label: Core.Language.Translate('Cancel'),
                     Function: function () {
                         Core.UI.Dialog.CloseDialog($('#DeleteDialog'));
                     }
                },

                {
                     Label: Core.Language.Translate('Delete'),
                     Function: function () {
                         var Data = {
                             Action: 'AdminGenericInterfaceInvokerEvent',
                             Subaction: 'Delete',
                             WebserviceID: TargetNS.InvokerEvent.WebserviceID,
                             Invoker: TargetNS.InvokerEvent.Invoker,
                             Event: TargetNS.InvokerEvent.Event
                         };

                         Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {
                             if (!Response || !Response.Success) {
                                 alert(Core.Language.Translate('An error occurred during communication.'));
                                 return;
                             }

                             Core.App.InternalRedirect({
                                 Action: TargetNS.InvokerEvent.InvokerTypeFrontendModule,
                                 Subaction: 'Change',
                                 Invoker: TargetNS.InvokerEvent.Invoker,
                                 WebserviceID: TargetNS.InvokerEvent.WebserviceID
                             });
                         }, 'json');

                     }
                }
            ]
        );

        Event.stopPropagation();
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.GenericInterfaceInvokerEvent || {}));
