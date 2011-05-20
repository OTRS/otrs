// --
// Core.Agent.Admin.GenericInterfaceOperation.js - provides the special module functions for the GenericInterface debugger.
// Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
// --
// $Id: Core.Agent.Admin.GenericInterfaceOperation.js,v 1.2 2011-05-20 13:36:01 mg Exp $
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
 * @exports TargetNS as Core.Agent.Admin.GenericInterfaceOperation
 * @description
 *      This namespace contains the special module functions for the GenericInterface debugger module.
 */
Core.Agent.Admin.GenericInterfaceOperation = (function (TargetNS) {

    TargetNS.Init = function (Params) {
        TargetNS.WebserviceID = parseInt(Params.WebserviceID, 10);
        TargetNS.Operation    = Params.Operation;
        TargetNS.Localization = Params.Localization;
    };

    TargetNS.ShowDeleteDialog = function(Event){
        Core.UI.Dialog.ShowContentDialog(
            $('#DeleteDialogContainer'),
            TargetNS.Localization.DeleteOperationMsg,
            '240px',
            'Center',
            true,
            [
               {
                   Label: TargetNS.Localization.DeleteMsg,
                   Function: function () {
                       var Data = {
                            Action: 'AdminGenericInterfaceOperationDefault',
                            Subaction: 'DeleteAction',
                            WebserviceID: TargetNS.WebserviceID,
                            Operation: TargetNS.Operation
                        };

                        Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {
                            if (!Response || !Response.Success) {
                                alert(TargetNS.Localization.CommunicationErrorMsg);
                                return;
                            }

                            window.location.href =Core.Config.Get('Baselink') + 'Action=AdminGenericInterfaceWebservice;Subaction=Change;WebserviceID=' + TargetNS.WebserviceID;

                        }, 'json');

                       Core.UI.Dialog.CloseDialog($('#DeleteDialog'));
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

    return TargetNS;
}(Core.Agent.Admin.GenericInterfaceOperation || {}));