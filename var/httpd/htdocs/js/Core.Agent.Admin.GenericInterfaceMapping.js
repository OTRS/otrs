// --
// Core.Agent.Admin.GenericInterfaceMapping.js - provides the special module functions for the GenericInterface mapping.
// Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
// --
// $Id: Core.Agent.Admin.GenericInterfaceMapping.js,v 1.1 2011-06-25 18:19:35 cr Exp $
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
 * @exports TargetNS as Core.Agent.Admin.GenericInterfaceMappingSimple
 * @description
 *      This namespace contains the special module functions for the GenericInterface Mapping module.
 */
Core.Agent.Admin.GenericInterfaceMapping= (function (TargetNS) {

    /**
     * @function
     * @param {Object} Params, initialization and internationalization parameters.
     * @return nothing
     *      This function initialize correctly all other function according to the local language
     */
    TargetNS.Init = function (Params) {
        TargetNS.WebserviceID = parseInt(Params.WebserviceID, 10);
        TargetNS.Localization = Params.Localization;
    };

    /**
     * @function
     * @param {string} IDSelector ID object of the clicked element.
     * @return nothing
     *      This function shows a confirmation dialog with 2 buttons
     */
    TargetNS.ShowDeleteDialog = function(IDSelector){

        Core.UI.Dialog.ShowContentDialog(
            $('#DeleteDialogContainer'),
            TargetNS.Localization.DeleteKeyMappingtMsg,
            '240px',
            'Center',
            true,
            [
               {
                   Label: TargetNS.Localization.DeleteMsg,
                   Function: function () {
                       $('#' + IDSelector).closest('.WidgetKey').remove();
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
    };

    return TargetNS;
}(Core.Agent.Admin.GenericInterfaceMapping || {}));