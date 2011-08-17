// --
// Core.Agent.Admin.DynamicField.js - provides the special module functions for the Dynamic Fields.
// Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
// --
// $Id: Core.Agent.Admin.DynamicField.js,v 1.1 2011-08-17 20:51:41 cr Exp $
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

    TargetNS.Redirect = function( Backend, Object ) {
        var DynamicFieldsConfig, Action, URL;

        // get configuration
        DynamicFieldsConfig = Core.Config.Get('DynamicFields.'+Object);

        // get action
        Action = DynamicFieldsConfig[ Backend ];

        // redirect to correct url
        window.location.href = Core.Config.Get('Baselink') + 'Action=' + Action + ';Subaction=Add' + ';Object=' + Object;
    };

    return TargetNS;
}(Core.Agent.Admin.DynamicField || {}));