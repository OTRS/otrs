// --
// OTRS.Agent.js - provides the application functions
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.Agent.js,v 1.1 2010-05-19 09:28:23 mg Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};

/**
 * @namespace
 * @exports TargetNS as OTRS.Agent
 * @description
 *      This namespace contains the config options and functions.
 */
OTRS.Agent = (function (TargetNS) {

    if (!OTRS.Debug.CheckDependency('OTRS.Agent', 'OTRS.UI', 'OTRS.UI')) {
        return;
    }
    if (!OTRS.Debug.CheckDependency('OTRS.Agent', 'OTRS.UI.Navigation', 'OTRS.UI.Navigation')) {
        return;
    }
    if (!OTRS.Debug.CheckDependency('OTRS.Agent', 'OTRS.Form', 'OTRS.Form')) {
        return;
    }
    if (!OTRS.Debug.CheckDependency('OTRS.Agent', 'OTRS.Form.Validate', 'OTRS.Form.Validate')) {
        return;
    }
    if (!OTRS.Debug.CheckDependency('OTRS.Agent', 'OTRS.UI.Accessibility', 'OTRS.UI.Accessibility')) {
        return;
    }

    /**
     * @function
     * @return nothing
     *      This function initializes the application and executes the needed functions
     */
    TargetNS.Init = function () {
        OTRS.UI.Navigation.Init();
        OTRS.UI.Table.InitCSSPseudoClasses();
        OTRS.UI.InitWidgetActionToggle();
        OTRS.UI.InitMessageBoxClose();
        OTRS.UI.ProcessTagAttributeClasses();
        OTRS.Form.Init();
        OTRS.Form.Validate.Init();
        // late execution of accessibility code
        OTRS.UI.Accessibility.Init();
    };

    /**
     * @function
     * @return nothing
     *      This function initializes the needed compatibility functions for IE7
     */
    TargetNS.InitIE7 = function () {
        OTRS.UI.IE7Fixes.InitIE7InputFocus('Focus');
        OTRS.UI.IE7Fixes.InitIE7InputReadonly('Readonly');
    };

    return TargetNS;
}(OTRS.Agent || {}));