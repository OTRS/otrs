// --
// OTRS.App.js - provides the application functions
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.App.js,v 1.2 2010-04-15 18:29:28 mn Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};

/**
 * @namespace
 * @description
 *      This namespace contains the config options and functions.
 */
OTRS.App = (function (Namespace) {
    /**
     * @function
     * @return nothing
     *      This function initializes the application and executes the needed functions
     */
    Namespace.Init = function () {
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
    Namespace.InitIE7 = function () {
        OTRS.UI.IE7Fixes.InitIE7InputFocus('Focus');
        OTRS.UI.IE7Fixes.InitIE7InputReadonly('Readonly');
    };

    return Namespace;
}(OTRS.App || {}));