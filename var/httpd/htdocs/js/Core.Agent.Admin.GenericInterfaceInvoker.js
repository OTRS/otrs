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
 * @namespace Core.Agent.Admin.GenericInterfaceInvoker
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the GenericInterface invoker module.
 */
Core.Agent.Admin.GenericInterfaceInvoker = (function (TargetNS) {

    /**
     * @private
     * @name DialogData
     * @memberof Core.Agent.Admin.GenericInterfaceInvoker
     * @member {Array}
     * @description
     *     This variable stores the parameters that are passed from the TT and contain all the data that the dialog needs.
     */
    var DialogData = [];

    /**
     * @name Init
     * @memberof Core.Agent.Admin.GenericInterfaceInvoker
     * @function
     * @description
     *      Initializes the module functions.
     */
    TargetNS.Init = function () {
        var Events = Core.Config.Get('Events'),
            $EventListParent = $('.EventList').parent(),
            ElementID, EventName, ElementSelector;

        TargetNS.WebserviceID = parseInt(Core.Config.Get('WebserviceID'), 10);
        TargetNS.Invoker = Core.Config.Get('Invoker');
        TargetNS.Action = Core.Config.Get('Action');

        $('#MappingOutboundConfigureButton').on('click', function() {
            TargetNS.Redirect('MappingOutbound');
        });

        $('#MappingInboundConfigureButton').on('click', function() {
            TargetNS.Redirect('MappingInbound');
        });

        $('.RegisterChange').on('change.RegisterChange keyup.RegisterChange', function () {
            $('.HideOnChange').hide();
            $('.ShowOnChange').show();
        });

        $('#DeleteButton').on('click', TargetNS.ShowDeleteDialog);

        $('#EventType').on('change', function (){
            Core.UI.InputFields.Deactivate($EventListParent);
            TargetNS.ToogleEventSelect($(this).val());
            Core.UI.InputFields.Activate($EventListParent);
        });

        $('#AddEvent').on('click', function (){
            TargetNS.AddEvent($('#EventType').val());
        });

        // Initialize event trigger fields.
        Core.UI.InputFields.Deactivate($EventListParent);
        TargetNS.ToogleEventSelect($('#EventType').val());
        Core.UI.InputFields.Activate($EventListParent);

        // Initialize delete action dialog event
        $.each(Events, function(){
            ElementID = 'DeleteEvent' + this;
            EventName = this;
            ElementSelector = '#DeleteEvent' + this;

            TargetNS.BindDeleteEventDialog({
                ElementID: ElementID,
                EventName: EventName,
                ElementSelector: ElementSelector
            });
        });
    };

    /**
     * @name ToogleEventSelect
     * @memberof Core.Agent.Admin.GenericInterfaceInvoker
     * @function
     * @param {String} SelectedEventType
     * @description
     *      Toggles the event list.
     */
    TargetNS.ToogleEventSelect = function (SelectedEventType) {
        $('.EventList').addClass('Hidden');
        $('#' + SelectedEventType + 'Event').removeClass('Hidden');
    };


    /**
     * @name AddEvent
     * @memberof Core.Agent.Admin.GenericInterfaceInvoker
     * @function
     * @param {String} EventType - The type of event trigger to assign to an invoker i.e ticket or article.
     * @description
     *      This function calls the AddEvent action on the server.
     */
    TargetNS.AddEvent = function (EventType) {
        var Data = {
                Action: TargetNS.Action,
                Subaction: 'AddEvent',
                NewEvent: $('#' + EventType + 'Event').val(),
                WebserviceID: TargetNS.WebserviceID,
                Invoker: TargetNS.Invoker,
                EventType: EventType
        };

        if (Data.NewEvent) {
            if ($('#Asynchronous').is(':checked')) {
                Data.Asynchronous = 1;
            }

            $('#AddEvent').prop('disabled', true);
            Core.App.InternalRedirect(Data);
        }
        else{
            Core.UI.Dialog.ShowDialog({
                Title: Core.Language.Translate("Add Event Trigger"),
                HTML: Core.Language.Translate("It is not possible to add a new event trigger because the event is not set."),
                Modal: true,
                CloseOnClickOutside: false,
                CloseOnEscape: false,
                PositionTop: '20%',
                PositionLeft: 'Center',
                Buttons: []
            });
        }

    };

    /**
     * @name ShowDeleteDialog
     * @memberof Core.Agent.Admin.GenericInterfaceInvoker
     * @function
     * @param {Object} Event - Event object of the clicked element.
     * @description
     *      This function shows a confirmation dialog with 2 buttons.
     */
    TargetNS.ShowDeleteDialog = function(Event){
        Core.UI.Dialog.ShowContentDialog(
            $('#DeleteDialogContainer'),
            Core.Language.Translate('Delete this Invoker'),
            '240px',
            'Center',
            true,
            [
               {
                   Label: Core.Language.Translate('Cancel'),
                   Class: 'Primary',
                   Function: function () {
                       Core.UI.Dialog.CloseDialog($('#DeleteDialog'));
                   }
               },
               {
                   Label: Core.Language.Translate('Delete'),
                   Function: function () {
                       var Data = {
                            Action: TargetNS.Action,
                            Subaction: 'DeleteAction',
                            WebserviceID: TargetNS.WebserviceID,
                            Invoker: TargetNS.Invoker
                        };

                        Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {
                            if (!Response || !Response.Success) {
                                alert(Core.Language.Translate('An error occurred during communication.'));
                                return;
                            }

                            Core.App.InternalRedirect({
                                Action: 'AdminGenericInterfaceWebservice',
                                Subaction: 'Change',
                                WebserviceID: TargetNS.WebserviceID
                            });

                        }, 'json');

                       Core.UI.Dialog.CloseDialog($('#DeleteDialog'));
                   }
               }
           ]
        );

        Event.stopPropagation();
    };

    /**
     * @name ShowDeleteEventDialog
     * @memberof Core.Agent.Admin.GenericInterfaceInvoker
     * @function
     * @param {Object} Event - Event object of the clicked element.
     * @description
     *      This function shows a confirmation dialog with 2 buttons.
     */
    TargetNS.ShowDeleteEventDialog = function(Event){
        var LocalDialogData;

        // get global saved DialogData for this function
        LocalDialogData = DialogData[$(this).attr('id')];
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
                       var Data = {
                            Action: TargetNS.Action,
                            Subaction: 'DeleteEvent',
                            WebserviceID: TargetNS.WebserviceID,
                            Invoker: TargetNS.Invoker,
                            EventName: LocalDialogData.EventName
                        };
                        Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {
                            if (!Response || !Response.Success) {
                                alert(Core.Language.Translate('An error occurred during communication.'));
                                return;
                            }

                            Core.App.InternalRedirect({
                                Action: Data.Action,
                                Subaction: 'Change',
                                Invoker: Data.Invoker,
                                WebserviceID: TargetNS.WebserviceID,
                                EventType: $('#EventType').val()
                            });

                        }, 'json');

                       Core.UI.Dialog.CloseDialog($('#DeleteEventDialog'));
                   }
               }
           ]
        );

        Event.stopPropagation();
        Event.preventDefault();
    };

    /**
     * @name BindDeleteEventDialog
     * @memberof Core.Agent.Admin.GenericInterfaceInvoker
     * @function
     * @param {Object} Data - A control structure that contains the jQueryObjectID, jQueryObjectSelector and the Invoker Event Trigger Name.
     * @description
     *      This function binds a "trash can" link from the invoker event triggers table to the
     *      function that opens a dialog to delete the event trigger.
     */
    TargetNS.BindDeleteEventDialog = function (Data) {
        DialogData[Data.ElementID] = Data;

        // binding a click event to the defined element
        $(DialogData[Data.ElementID].ElementSelector).on('click', TargetNS.ShowDeleteEventDialog);
    };

    /**
     * @name Redirect
     * @memberof Core.Agent.Admin.GenericInterfaceInvoker
     * @function
     * @param {String} ConfigKey
     * @description
     *      Redirects.
     */
    TargetNS.Redirect = function(ConfigKey) {
        var ConfigElement;

        // get the Config Element name, if none it will have "null" value
        ConfigElement = $('#' + ConfigKey + 'ConfigDialog').val();

        // check is config element is a valid scring
        if (ConfigElement !== null) {

            // redirect to correct url
            Core.App.InternalRedirect({
                Action: ConfigElement,
                Subaction: 'Change',
                WebserviceID: TargetNS.WebserviceID,
                Invoker: TargetNS.Invoker,
                Direction: ConfigKey
            });
        }
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.GenericInterfaceInvoker || {}));
