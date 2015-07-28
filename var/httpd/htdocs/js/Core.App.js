// --
// Core.App.js - provides the application functions
// Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
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
     * @exports TargetNS.BrowserCheck as Core.App.BrowserCheck
     * @function
     * @param {String} Interface The interface we are in (Agent or Customer)
     * @description
     *      Checks if the used browser is not on the OTRS browser blacklist
     *      of the agent interface.
     * @return true if the used browser is *not* on the black list.
     */
    TargetNS.BrowserCheck = function (Interface) {
        var AppropriateBrowser = true,
            BrowserBlackList = Core.Config.Get('BrowserBlackList::' + Interface);
        if (typeof BrowserBlackList !== 'undefined') {
            $.each(BrowserBlackList, function (Key, Value) {
                if ($.isFunction(Value)) {
                    if (Value()) {
                        AppropriateBrowser = false;
                    }
                }
            });
            return AppropriateBrowser;
        }
        alert('Error: Browser Check failed!');
    };

    /**
     * @exports TargetNS.BrowserCheckIECompatibilityMode as Core.App.BrowserCheckIECompatibilityMode
     * @function
     * @description
     *      Checks if the used browser is IE in Compatibility Mode.
     *      IE11 in Compatibility Mode is not recognized.
     * @return true if the used browser is IE in Compatibility Mode.
     */
    TargetNS.BrowserCheckIECompatibilityMode = function  () {
        var IE7 = ($.browser.msie && $.browser.version === '7.0');

        // if not IE7, we cannot be in compatibilty mode
        if (!IE7) {
            return false;
        }

        // IE8,9,10,11 in Compatibility Mode will claim to be IE7.
        // See also http://msdn.microsoft.com/en-us/library/ms537503%28v=VS.85%29.aspx
        if (
                navigator &&
                navigator.userAgent &&
                (
                    navigator.userAgent.match(/Trident\/4.0/) ||
                    navigator.userAgent.match(/Trident\/5.0/) ||
                    navigator.userAgent.match(/Trident\/6.0/) ||
                    navigator.userAgent.match(/Trident\/7.0/)
                )
            ) {

            return true;
        }

        // if IE7 but no Trident 4-7 is found, we are in a real IE7
        return false;
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
