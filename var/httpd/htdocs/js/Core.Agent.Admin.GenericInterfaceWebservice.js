// --
// Core.Agent.Admin.GenericInterfaceWebservice.js - provides the special module functions for the GenericInterface webservice.
// Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
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
 * @namespace
 * @exports TargetNS as Core.Agent.Admin.GenericInterfaceWebservice
 * @description
 *      This namespace contains the special module functions for the GenericInterface webservice module.
 */
Core.Agent.Admin.GenericInterfaceWebservice = (function (TargetNS) {

    /**
     * @variable
     * @private
     *     This variable stores the parameters that are passed from the DTL and contain all the data that the dialog needs.
     */
    var DialogData = [];

    TargetNS.HideElements = function(){
        $('button.HideActionOnChange').parent().hide();
        $('.HideOnChange').hide();
        $('.HideLinkOnChange').contents().unwrap();
    };

    TargetNS.Init = function (Params) {
        TargetNS.WebserviceID = parseInt(Params.WebserviceID, 10);
        TargetNS.Localization = Params.Localization;
        if (Params.Action === "Add") {
            TargetNS.HideElements();
        }

        $('#DeleteButton').bind('click', TargetNS.ShowDeleteDialog);
        $('#CloneButton').bind('click', TargetNS.ShowCloneDialog);
        $('#ImportButton').bind('click', TargetNS.ShowImportDialog);

        $('#ProviderTransportProperties').bind('click', function() {
            TargetNS.Redirect('Webservice.Transport', 'ProviderTransportList', {CommunicationType: 'Provider'});
        });

        $('#RequesterTransportProperties').bind('click', function() {
            TargetNS.Redirect('Webservice.Transport', 'RequesterTransportList', {CommunicationType: 'Requester'});
        });

        $('#OperationList').bind('change', function() {
            TargetNS.Redirect('Webservice.Operation', 'OperationList', {OperationType: $(this).val()});
        });

        $('#InvokerList').bind('change', function() {
            TargetNS.Redirect('Webservice.Invoker', 'InvokerList', {InvokerType: $(this).val()});
        });

        $('.HideTrigger').bind('change', function(){
            TargetNS.HideElements();
        });

    };

    TargetNS.ShowDeleteDialog = function(Event){
        Core.UI.Dialog.ShowContentDialog(
            $('#DeleteDialogContainer'),
            TargetNS.Localization.DeleteWebserviceMsg,
            '240px',
            'Center',
            true,
            [
                {
                     Label: TargetNS.Localization.CancelMsg,
                     Function: function () {
                         Core.UI.Dialog.CloseDialog($('#DeleteDialog'));
                     }
                },

                {
                     Label: TargetNS.Localization.DeleteMsg,
                     Function: function () {
                         var Data = {
                             Action: 'AdminGenericInterfaceWebservice',
                             Subaction: 'Delete',
                             WebserviceID: TargetNS.WebserviceID
                         };

                         Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {
                             if (!Response || !Response.Success) {
                                 alert(TargetNS.Localization.CommunicationErrorMsg);
                                 return;
                             }

                             Core.App.InternalRedirect({
                                 Action: Data.Action,
                                 DeletedWebservice: Response.DeletedWebservice
                             });
                         }, 'json');

                     }
                }
            ]
        );

        Event.stopPropagation();
    };

    TargetNS.ShowCloneDialog = function(Event){

        var CurrentDate, CloneName;

        Core.UI.Dialog.ShowContentDialog(
            $('#CloneDialogContainer'),
            TargetNS.Localization.CloneWebserviceMsg,
            '240px',
            'Center',
            true
        );

        // init validation
        // Currently we have not a function to initialize the validation on a single form
        Core.Form.Validate.Init();

        // get current system time to define suggested the name of the cloned webservice
        CurrentDate = new Date();
        CloneName = $('#Name').val() + "-" +CurrentDate.getTime();

        // set the suggested name
        $('.CloneName').val( CloneName );

        // bind button actions
        $('#CancelCloneButtonAction').bind('click', function() {
            Core.UI.Dialog.CloseDialog($('#CloneDialog'));
        });

        $('#CloneButtonAction').bind('click', function() {
            $('#CloneForm').submit();
        });

        Event.stopPropagation();
    };

    TargetNS.ShowImportDialog = function(Event){

        Core.UI.Dialog.ShowContentDialog(
            $('#ImportDialogContainer'),
            TargetNS.Localization.ImportWebserviceMsg,
            '240px',
            'Center',
            true
        );

        // init validation
        // Currently we have not a function to initialize the validation on a single form
        Core.Form.Validate.Init();

        $('#CancelImportButtonAction').bind('click', function() {
            Core.UI.Dialog.CloseDialog($('#ImportDialog'));
        });

        $('#ImportButtonAction').bind('click', function() {
            $('#ImportForm').submit();
        });

        Event.stopPropagation();
    };

    TargetNS.Redirect = function( ConfigKey, DataSource, Data ) {
        var WebserviceConfigPart, Action, ConfigElement;

        // get configuration
        WebserviceConfigPart = Core.Config.Get(ConfigKey);

        // get the Config Element name, if none it will have "null" value
        ConfigElement = $('#' + DataSource).val();

        // check is config element is a valid scring
        if ( ConfigElement !== null ) {

            // get action
            Action = WebserviceConfigPart[ ConfigElement ];

            $.extend(Data, {
                Action: Action,
                Subaction: 'Add',
                WebserviceID: TargetNS.WebserviceID
            });

            // redirect to correct url
            Core.App.InternalRedirect(Data);
        }
    };


    /**
     * @function
     * @param {EventObject} event object of the clicked element.
     * @return nothing
     *      This function shows a confirmation dialog with 2 buttons
     */
    TargetNS.ShowDeleteActionDialog = function(Event){
        var LocalDialogData, ActionType, DialogTitle;

        // get global saved DialogData for this function
        LocalDialogData = DialogData[$(Event.target).attr('id')];
        if ($(Event.target).hasClass('DeleteOperation')) {
            ActionType = 'Operation';
            DialogTitle = TargetNS.Localization.DeleteOperationMsg;
        }
        else {
            ActionType = 'Invoker';
            DialogTitle = TargetNS.Localization.DeleteInvokerMsg;
        }

        Core.UI.Dialog.ShowContentDialog(
            $('#Delete'+ ActionType + 'DialogContainer'),
            DialogTitle,
            '240px',
            'Center',
            true,
            [
               {
                   Label: TargetNS.Localization.CancelMsg,
                   Class: 'Primary',
                   Function: function () {
                       Core.UI.Dialog.CloseDialog($('#Delete' + ActionType + 'Dialog'));
                   }
               },
               {
                   Label: TargetNS.Localization.DeleteMsg,
                   Function: function () {
                       var Data = {
                            Action: 'AdminGenericInterfaceWebservice',
                            Subaction: 'DeleteAction',
                            WebserviceID: TargetNS.WebserviceID,
                            ActionType: LocalDialogData.ActionType,
                            ActionName: LocalDialogData.ActionName
                        };
                        Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {
                            if (!Response || !Response.Success) {
                                alert(TargetNS.Localization.CommunicationErrorMsg);
                                return;
                            }

                            Core.App.InternalRedirect({
                                Action: Data.Action,
                                Subaction: 'Change',
                                WebserviceID: TargetNS.WebserviceID
                            });

                        }, 'json');

                       Core.UI.Dialog.CloseDialog($('#Delete' + ActionType + 'Dialog'));
                   }
               }
           ]
        );

        Event.stopPropagation();
        Event.preventDefault();
    };

    /**
     * @function
     * @param {Object} Data a control structure that contains the jQueryObjectID,
     * jQueryObjectSelector the ActionType and the ActionName.
     * @return nothing
     *      This function binds a "trash can" link from the action table to the
     *      function that opens a dialog to delete the action
     */
    TargetNS.BindDeleteActionDialog = function (Data) {
        DialogData[Data.ElementID] = Data;

        // binding a click event to the defined element
        $(DialogData[Data.ElementID].ElementSelector).bind('click', TargetNS.ShowDeleteActionDialog);
    };

    return TargetNS;
}(Core.Agent.Admin.GenericInterfaceWebservice || {}));
