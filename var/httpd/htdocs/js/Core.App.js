// --
// Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --
// nofilter(TidyAll::Plugin::OTRS::JavaScript::UnloadEvent)

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
     * @name BindWindowUnloadEvent
     * @memberof Core.App
     * @function
     * @param {String} Namespace - Namespace for which the event should be bound.
     * @param {Function} CallbackFunction - Function which should be executed once the event is fired.
     * @description
     *      Binds a crossbrowser compatible unload event to the window object
     */
    TargetNS.BindWindowUnloadEvent = function (Namespace, CallbackFunction) {

        if (!$.isFunction(CallbackFunction)) {
            return;
        }

        // we need a special handling for all IE's before 11, because these
        // don't know the pagehide event but support the non-standard
        // unload event.
        if ($.browser.msie && parseInt($.browser.version, 10) < 11) {
            $(window).on('unload.' + Namespace, function () {
                CallbackFunction();
            });
        }
        else {
            $(window).on('pagehide.' + Namespace, function () {
                CallbackFunction();
            });
        }
    };

    /**
     * @name UnbindWindowUnloadEvent
     * @memberof Core.App
     * @function
     * @param {String} Namespace - Namespace for which the event should be removed.
     * @description
     *      Unbinds a crossbrowser compatible unload event to the window object
     */
    TargetNS.UnbindWindowUnloadEvent = function (Namespace) {
        $(window).off('unload.' + Namespace);
        $(window).off('pagehide.' + Namespace);
    };

    /**
     * @name GetSessionInformation
     * @memberof Core.App
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
     * @name EscapeSelector
     * @memberof Core.App
     * @function
     * @returns {String} The escaped selector.
     * @param {String} Selector - The original selector (e.g. ID, class, etc.).
     * @description
     *      Escapes the special characters (. :) in the given jQuery Selector
     *      jQ does not allow the usage of dot or colon in ID or class names
     *      An overview of special characters that should be quoted can be found here:
     *      https://api.jquery.com/category/selectors/
     */
    TargetNS.EscapeSelector = function (Selector) {
        if (Selector && Selector.length) {
            return Selector.replace(/(#|:|\.|\[|\]|@|!|"|\$|%|&|<|=|>|'|\(|\)|\*|\+|,|\?|\/|\;|\\|\^|{|}|`|\||~)/g, '\\$1');
        }
        return '';
    };

    /**
     * @name EscapeHTML
     * @memberof Core.App
     * @function
     * @returns {String} The escaped string.
     * @param {String} StringToEscape - The string which is supposed to be escaped.
     * @description
     *      Escapes the special HTML characters ( < > & ) in supplied string to their
     *      corresponding entities.
     */
    TargetNS.EscapeHTML = function (StringToEscape) {
        var HTMLEntities = {
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;'
        };

        if (!StringToEscape) {
            return false;
        }

        return StringToEscape.replace(/[&<>"]/g, function(Entity) {
            return HTMLEntities[Entity] || Entity;
        });
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
