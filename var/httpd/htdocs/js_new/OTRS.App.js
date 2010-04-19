// --
// OTRS.App.js - provides the application functions
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.App.js,v 1.3 2010-04-19 16:36:29 mg Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};

/**
 * @namespace
 * @exports TargetNS as OTRS.App
 * @description
 *      This namespace contains the config options and functions.
 */
OTRS.App = (function (TargetNS) {
    /**
     * @function
     * @return nothing
     *      This function initializes the application and executes the needed functions
     */
    TargetNS.Init = function () {
        OTRS.UI.Navigation.Init();
        OTRS.UI.Tables.InitCSSPseudoClasses();
        OTRS.UI.InitWidgetActionToggle();
        OTRS.UI.InitMessageBoxClose();
        OTRS.UI.ProcessTagAttributeClasses();
        OTRS.Forms.Validate.Init();
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
}(OTRS.App || {}));