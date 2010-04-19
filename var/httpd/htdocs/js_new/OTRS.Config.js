// --
// OTRS.Config.js - provides the JS config
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.Config.js,v 1.4 2010-04-19 16:36:29 mg Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};

/**
 * @namespace
 * @exports TargetNS as OTRS.Config
 * @description
 *      This namespace contains the config options and functions.
 */
OTRS.Config = (function (TargetNS) {
    var Config = {},
        ConfigPrefix = 'Config';

    /**
     * @function
     *      Sets a single option value
     * @param {String} Key The name of the config option (also combined ones like Richtext.Width)
     * @param {Object} Value The value of the option. Can be every kind of javascript variable type.
     * @return nothing
     */
    TargetNS.Set = function (Key, Value) {
        var Keys = Key.split('.'),
            KeyToken,
            ConfigLevel = Config,
            Count = 0;

        for (KeyToken in Keys) {
            if (Keys.hasOwnProperty(KeyToken)) {
                if (Keys.length === Count + 1) {
                    ConfigLevel[ConfigPrefix + Keys[KeyToken]] = Value;
                }
                else if (typeof ConfigLevel[ConfigPrefix + Keys[KeyToken]] === 'undefined') {
                    ConfigLevel[ConfigPrefix + Keys[KeyToken]] = {};
                    ConfigLevel = ConfigLevel[ConfigPrefix + Keys[KeyToken]];
                }
                else {
                    ConfigLevel = ConfigLevel[ConfigPrefix + Keys[KeyToken]];
                }
                Count++;
            }
        }
    };

    /**
     * @function
     *      Gets a single option value
     * @param {String} Key The name of the config option (also combined ones like Richtext.Width)
     * @return {Object} The value of the option. Can be every kind of javascript variable type.
     */
    TargetNS.Get = function (Key) {
        var Keys = Key.split('.'),
            KeyToken,
            ConfigLevel = Config,
            Count = 0;

        for (KeyToken in Keys) {
            if (Keys.hasOwnProperty(KeyToken)) {
                if (Keys.length === Count + 1) {
                    return ConfigLevel[ConfigPrefix + Keys[KeyToken]];
                }
                else {
                    ConfigLevel = ConfigLevel[ConfigPrefix + Keys[KeyToken]];
                }
                Count++;
            }
        }
    };

    /**
     * @function
     * @return nothing
     *      This function includes the given data into the config hash
     * @param {String} Key The key in the config where the data structure is saved to
     * @param {JSONString or Object} Data The config data to include as a JSON string or a javascript object
     */
    TargetNS.AddConfig = function (Key, Data) {
        var ConfigOptions,
            Keys = Key.split('.'),
            KeyToken,
            ConfigLevel = Config,
            Count = 0;

        if (typeof Data === 'String') {
            ConfigOptions = OTRS.JSON.Parse(Data);
        }
        else {
            ConfigOptions = Data;
        }

        for (KeyToken in Keys) {
            if (Keys.hasOwnProperty(KeyToken)) {
                if (Keys.length === Count + 1) {
                    ConfigLevel[ConfigPrefix + Keys[KeyToken]] = Data;
                }
                else if (typeof ConfigLevel[ConfigPrefix + Keys[KeyToken]] === 'undefined') {
                    ConfigLevel[ConfigPrefix + Keys[KeyToken]] = {};
                    ConfigLevel = ConfigLevel[ConfigPrefix + Keys[KeyToken]];
                }
                else {
                    ConfigLevel = ConfigLevel[ConfigPrefix + Keys[KeyToken]];
                }
                Count++;
            }
        }
    };

    /*
     * Different config options, that are provided from start
     */

    /**
     * @field
     * @description This variable contains a hash of blacklisted browsers and there recognition functions.
     * Each function returns true, if the browsers is detected
     */
    TargetNS.AddConfig('BrowserBlackList', {
        'Microsoft Internet Explorer 5.5': function () {
            return ($.browser.msie && $.browser.version === '5.5');
        },
        'Microsoft Internet Explorer 6': function () {
            return ($.browser.msie && $.browser.version === '6.0');
        },
        'Konqueror (without WebKit engine)': function () {
            return ($.browser.webkit && navigator.vendor === 'KDE');
        },
        'Netscape, old Mozilla, old Firefox': function () {
            var BrowserVersion,
                BrowserDetected = false;
            if ($.browser.mozilla) {
                BrowserVersion = $.browser.version.split('.');
                if (parseInt(BrowserVersion[0], 10) < 1 || parseInt(BrowserVersion[1], 10) < 8 || parseInt(BrowserVersion[2], 10) < 1) {
                    BrowserDetected = true;
                }
            }
            return BrowserDetected;
        }
    });

    return TargetNS;
}(OTRS.Config || {}));