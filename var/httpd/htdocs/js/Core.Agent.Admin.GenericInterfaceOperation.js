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
 * @namespace Core.Agent.Admin.GenericInterfaceOperation
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the GenericInterface debugger module.
 */
Core.Agent.Admin.GenericInterfaceOperation = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Admin.GenericInterfaceOperation
     * @function
     * @param {Object} Params - Initialization and internationalization parameters.
     * @description
     *      This function initialize the module.
     */
    TargetNS.Init = function (Params) {
        TargetNS.WebserviceID = parseInt(Params.WebserviceID, 10);
        TargetNS.Operation = Params.Operation;
        TargetNS.Action = Params.Action;
        TargetNS.Localization = Params.Localization;

        $('#MappingInboundConfigureButton').on('click', function() {
            TargetNS.Redirect('MappingInbound');
        });

        $('#MappingOutboundConfigureButton').on('click', function() {
            TargetNS.Redirect('MappingOutbound');
        });
    };

    /**
     * @name ShowDeleteDialog
     * @memberof Core.Agent.Admin.GenericInterfaceOperation
     * @function
     * @param {Object} Event - The browser event object, e.g. of the clicked DOM element.
     * @description
     *      Shows a confirmation dialog to delete the operation.
     */
    TargetNS.ShowDeleteDialog = function(Event){
        Core.UI.Dialog.ShowContentDialog(
            $('#DeleteDialogContainer'),
            TargetNS.Localization.DeleteOperationMsg,
            '240px',
            'Center',
            true,
            [
               {
                   Label: TargetNS.Localization.CancelMsg,
                   Class: 'Primary',
                   Function: function () {
                       Core.UI.Dialog.CloseDialog($('#DeleteDialog'));
                   }
               },
               {
                   Label: TargetNS.Localization.DeleteMsg,
                   Function: function () {
                       var Data = {
                            Action: TargetNS.Action,
                            Subaction: 'DeleteAction',
                            WebserviceID: TargetNS.WebserviceID,
                            Operation: TargetNS.Operation
                        };

                        Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {
                            if (!Response || !Response.Success) {
                                alert(TargetNS.Localization.CommunicationErrorMsg);
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
     * @name Redirect
     * @memberof Core.Agent.Admin.GenericInterfaceOperation
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
                Operation: TargetNS.Operation,
                Direction: ConfigKey
            });
        }
    };

    return TargetNS;
}(Core.Agent.Admin.GenericInterfaceOperation || {}));
