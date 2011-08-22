// --
// Core.Agent.Admin.DynamicField.js - provides the special module functions for the Dynamic Fields.
// Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
// --
// $Id: Core.Agent.Admin.DynamicField.js,v 1.7 2011-08-22 20:41:30 cr Exp $
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
 * @exports TargetNS as Core.Agent.Admin.DynamicField
 * @description
 *      This namespace contains the special module functions for the .DynamicField module.
 */
Core.Agent.Admin.DynamicField = (function (TargetNS) {

    TargetNS.Redirect = function( FieldType, ObjectType ) {
        var DynamicFieldsConfig, Action, URL;

        // get configuration
        DynamicFieldsConfig = Core.Config.Get('DynamicFields');

        // get action
        Action = DynamicFieldsConfig[ FieldType ];

        // redirect to correct url
        URL = Core.Config.Get('Baselink') + 'Action=' + Action + ';Subaction=Add' + ';ObjectType=' + ObjectType + ';FieldType=' + FieldType;
        Core.UI.Popup.OpenPopup(URL, 'Action');
    };

    TargetNS.ValidationInit = function() {

        Core.Form.Validate.AddRule("Validate_LowercaseNumbers", {
            Validate_LowercaseNumbers: true
        });
        Core.Form.Validate.AddMethod("Validate_LowercaseNumbers", function (Value, Element) {
            return ( /^[a-z0-9]+$/.test(Value));
        }, "");

        Core.Form.Validate.AddRule("Validate_PositiveNegativeNumbers", {
            Validate_PositiveNegativeNumbers: true
        });
        Core.Form.Validate.AddMethod("Validate_PositiveNegativeNumbers", function (Value, Element) {
            return ( /^-?[0-9]+$/.test(Value));
        }, "");

    };

    return TargetNS;
}(Core.Agent.Admin.DynamicField || {}));
