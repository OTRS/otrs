// --
// Core.App.js - provides the application functions
// Copyright (C) 2001-2013 OTRS AG, http://otrs.org/
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
        Data.ChallengeToken = Core.Config.Get('ChallengeToken');
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

    /**
     * @function
     *  Escapes the special characters (. :) in the given jQuery Selector
     *  jQ does not allow the usage of dot or colon in ID or class names
     * @param {String} Selector The original selector (e.g. ID, class, etc.)
     * @return {String} The escaped selector
     */
    TargetNS.EscapeSelector = function (Selector) {
        return Selector.replace(/(#|:|\.|\[|\])/g,'\\$1');
    };

    /**
     * @function
     *  Publish some data on a named topic
     * @param {String} Topic The channel to publish on
     * @param {Array} Args  The data to publish.
     *                      Each array item is converted into an ordered
     *                      arguments on the subscribed functions.
     */
    TargetNS.Publish = function (Topic, Args) {
        $.publish(Topic, Args);
    };

    /**
     * @function
     *  Register a callback on a named topic
     * @param {String} Topic The channel to subscribe to
     * @param {Function} Callback  The handler event.
     *                             Anytime something is published on a
     *                             subscribed channel, the callback will be called with the
     *                             published array as ordered arguments.
     * @return {Array} A handle which can be used to unsubscribe this particular subscription
     */
    TargetNS.Subscribe = function (Topic, Callback) {
        return $.subscribe(Topic, Callback);
    };

    /**
     * @function
     *  Disconnect a subscribed function for a topic
     * @param {Array} Handle The return value from a $.subscribe call
     */
    TargetNS.Unsubscribe = function (Handle) {
        $.unsubscribe(Handle);
    };

    return TargetNS;
}(Core.App || {}));
