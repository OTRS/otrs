// --
// OTRS.App.js - provides the application functions
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.App.js,v 1.12 2010-05-31 13:04:05 mn Exp $
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

    if (!OTRS.Debug.CheckDependency('OTRS.App', 'OTRS.Exception', 'OTRS.Exception')) {
        return;
    }

    /**
     * @function
     *      This functions callback is executed if all elements and files of this page are loaded
     * @param {Function} Callback The callback function to be executed
     * @return nothing
     */
    TargetNS.Ready = function (Callback) {
        if ($.isFunction(Callback)) {
            $(document).ready(function () {
                try {
                    Callback();
                }
                catch (Error) {
                    OTRS.Exception.HandleError(Error);
                }
            });
        }
        else {
            OTRS.Exception.ShowError('No function parameter given in OTRS.App.Ready', 'TypeError');
        }
    };

    return TargetNS;
}(OTRS.App || {}));