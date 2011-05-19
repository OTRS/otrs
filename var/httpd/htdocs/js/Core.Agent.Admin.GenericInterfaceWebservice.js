// --
// Core.Agent.Admin.SysGenericInterfaceWebservice.js - provides the special module functions for the GenericInterface webservice.
// Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
// --
// $Id: Core.Agent.Admin.GenericInterfaceWebservice.js,v 1.5 2011-05-19 21:54:07 cr Exp $
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

    TargetNS.HideElements = function(){
        $('button.HideActionOnChange').parent().addClass('Hidden')
        $('.HideOnChange').addClass('Hidden');
        $('.DataTable').addClass('Hidden');
    }

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
            TargetNS.Redirect('Webservice.Transport', 'ProviderTransportList', 'Provider');
        });

        $('#RequesterTransportProperties').bind('click', function() {
            TargetNS.Redirect('Webservice.Transport', 'RequesterTransportList', 'Requester');
        });

        $('#OperationList').bind('change', function() {
            TargetNS.Redirect('Webservice.Operation', 'OperationList', 'Provider');
        });

        $('#InvokerList').bind('change', function() {
            TargetNS.Redirect('Webservice.Invoker', 'InvokerList', 'Requester');
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

                        }, 'json');

                        window.location.href = Core.Config.Get('Baselink') + 'Action=' + Data.Action;
                   }
               },
               {
                   Label: TargetNS.Localization.CancelMsg,
                   Function: function () {
                       Core.UI.Dialog.CloseDialog($('#DeleteDialog'));
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

    TargetNS.Redirect = function( ConfigKey, DataSource, CommunicationType ) {
        var WebserviceConfigPart, Action, ConfigElement;

        // get configuration
        WebserviceConfigPart = Core.Config.Get(ConfigKey);

        // get the Config Element name, if none it will have "null" value
        ConfigElement = $('#' + DataSource).val();

        // check is config element is a valid scring
        if ( ConfigElement !== null ) {

            // get action
            Action = WebserviceConfigPart[ ConfigElement ];

            // redirect to correct url
            window.location.href = Core.Config.Get('Baselink') + 'Action=' + Action + ';Subaction=Add;CommunicationType=' + CommunicationType + ';WebserviceID=' + TargetNS.WebserviceID;
        }
    };

    return TargetNS;
}(Core.Agent.Admin.GenericInterfaceWebservice || {}));