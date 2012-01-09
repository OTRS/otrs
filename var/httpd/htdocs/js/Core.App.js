// --
// Core.App.js - provides the application functions
// Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
// --
// $Id: Core.App.js,v 1.6 2012-01-09 11:44:55 mg Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};

/**
 * @namespace
 * @exports TargetNS as Core.App
 * @description
 *      This namespace contains the config options and functions.
 */
Core.App = (function (TargetNS) {

    if (!Core.Debug.CheckDependency('Core.App', 'Core.Exception', 'Core.Exception')) {
        return;
    }

    if (!Core.Debug.CheckDependency('Core.App', 'Core.Config', 'Core.Config')) {
        return;
    }

    /**
     * @function
     * @private
     * @param {Object} Data The data that should be converted
     * @return {string} query string of the data
     * @description Converts a given hash into a query string
     */
    function SerializeData(Data) {
        var QueryString = '';
        $.each(Data, function (Key, Value) {
            QueryString += encodeURIComponent(Key) + '=' + encodeURIComponent(Value) + ';';
        });
        return QueryString;
    }

    /**
     * @function
     * @private
     * @return {Object} Hash with session data, if needed
     * @description Collects session data in a hash if available
     */
    TargetNS.GetSessionInformation = function () {
        var Data = {};
        if (!Core.Config.Get('SessionIDCookie')) {
            Data[Core.Config.Get('SessionName')] = Core.Config.Get('SessionID');
            Data[Core.Config.Get('CustomerPanelSessionName')] = Core.Config.Get('SessionID');
        }
        Data['ChallengeToken'] = Core.Config.Get('ChallengeToken');
        return Data;
    };

    /**
     * @function
     *      This functions callback is executed if all elements and files of this page are loaded
     * @param {Function} Callback The callback function to be executed
     * @return nothing
     */
    TargetNS.Ready = function (Callback) {
        if ($.isFunction(Callback)) {
            $(document).ready(function () {
                var Trace;
                try {
                    Callback();
                }
                catch (Error) {
                    Trace = printStackTrace({e: Error, guess: true}).join('\n');
                    Core.Exception.HandleFinalError(Error, Trace);
                }
            });
        }
        else {
            Core.Exception.ShowError('No function parameter given in Core.App.Ready', 'TypeError');
        }
    };

    /**
     * @function
     *  Performs an internal redirect based on the given data parameters.
     *  If needed, session information like SessionID and ChallengeToken are appended.
     * @param {Object} Data The query data (like: {Action: 'MyAction', Subaction: 'Add'})
     * @return nothing, performs redirect
     */
    TargetNS.InternalRedirect = function (Data) {
        var URL;
        URL = Core.Config.Get('Baselink') + SerializeData(Data);
        URL += SerializeData(TargetNS.GetSessionInformation());
        window.location.href = URL;
    };

    return TargetNS;
}(Core.App || {}));