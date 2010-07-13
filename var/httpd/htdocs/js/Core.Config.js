// --
// Core.Config.js - provides the JS config
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.Config.js,v 1.1 2010-07-13 09:46:41 mg Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};

/**
 * @namespace
 * @exports TargetNS as Core.Config
 * @description
 *      This namespace contains the config options and functions.
 */
Core.Config = (function (TargetNS) {
    var Config = {},
        ConfigPrefix = 'Config';

    if (!Core.Debug.CheckDependency('Core.Config', 'Core.Data', 'Core.Data')) {
        return;
    }
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
     * @param {Object} Data The config data to include as a javascript object
     * @param {String} Key The key in the config where the data structure is saved to. If undefined, the Data is added to the root of the hash.
     */
    TargetNS.AddConfig = function (Data, Key) {
        var ConfigOptions,
            Keys,
            KeyToken,
            ConfigLevel = Config,
            Count = 0;

        /* Because objects in javascript are called-by-reference, the given data object is just a reference.
         * Saving this to the config hash would only save the reference to the original object.
         * If this original object is changed (or if the object is changed in the config hash) it would also
         * "change" the other references.
         * We have to *really* copy the object, to be sure to have no reference to the given parameter object.
         */
        ConfigOptions = Core.Data.CopyObject(Data);

        if (typeof Key === 'undefined') {
            $.each(Data, function (Key, Value) {
                ConfigLevel[ConfigPrefix + Key] = Value;
            });
        }
        else {
            Keys = Key.split('.');
            for (KeyToken in Keys) {
                if (Keys.length === Count + 1) {
                    ConfigLevel[ConfigPrefix + Keys[KeyToken]] = ConfigOptions;
                }
                else {
                    if (typeof ConfigLevel[ConfigPrefix + Keys[KeyToken]] === 'undefined') {
                        ConfigLevel = ConfigLevel[ConfigPrefix + Keys[KeyToken]];
                    }
                    else {
                        ConfigLevel = ConfigLevel[ConfigPrefix + Keys[KeyToken]];
                    }
                    Count++;
                }
            }
        }
    };

    /*
     * Different config options, that are provided from start
     */

    /**
     * @field
     * @description This variable contains a hash of blacklisted browsers and their recognition functions.
     * Each function returns true, if the browsers is detected
     */
    TargetNS.AddConfig({
        'Microsoft Internet Explorer 5.5': function () {
            return ($.browser.msie && $.browser.version === '5.5');
        },
        'Microsoft Internet Explorer 6': function () {
            return ($.browser.msie && $.browser.version === '6.0');
        },
        'Konqueror (without WebKit engine)': function () {
            return ($.browser.webkit && navigator.vendor === 'KDE');
        },
        // all Netscape, Mozilla, Firefox before Gecko Version 1.9 (Firefox 3)
        'Netscape, old Mozilla, old Firefox': function () {
            var BrowserVersion,
                BrowserDetected = false;
            if ($.browser.mozilla) {
                BrowserVersion = $.browser.version.split('.');
                if (parseInt(BrowserVersion[0], 10) < 1 || (parseInt(BrowserVersion[0], 10) === 1 && parseInt(BrowserVersion[1], 10) < 9)) {
                    BrowserDetected = true;
                }
            }
            return BrowserDetected;
        }
    }, 'BrowserBlackList');

    return TargetNS;
}(Core.Config || {}));