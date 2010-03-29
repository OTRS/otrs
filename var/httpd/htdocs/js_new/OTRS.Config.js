// --
// OTRS.Config.js - provides the JS config
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.Config.js,v 1.1 2010-03-29 14:09:31 mn Exp $
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
OTRS.Config = (function (Namespace) {
    /**
     * @function
     * @return nothing
     *      This function includes the given data into the config hash
     * @param {JSONString} JSONString The config data to include as a JSON string
     */
    Namespace.AddConfig = function (JSONString) {
        var ConfigOptions = OTRS.JSON.Parse(JSONString);
        // Add all new config options (and overwrite existing!), except one that is named like this function (and would overwrite it)
        $.each(ConfigOptions, function(Key, Value) {
            if (Key !== 'AddConfig') {
                Namespace[Key] = Value;
            }
        });
    };

    /*
     * Different config options, that are provided from start
     */

    /**
     * @field
     * @description This variable contains a hash of blacklisted browsers and there recognition functions.
     * Each function returns true, if the browsers is detected
     */
    Namespace.BrowserBlackList = {
        'Microsoft Internet Explorer 5.5': function() {
            return ($.browser.msie && $.browser.version === '5.5');
        },
        'Microsoft Internet Explorer 6': function() {
            return ($.browser.msie && $.browser.version === '6.0');
        },
        'Konqueror (without WebKit engine)': function() {
            return ($.browser.webkit && navigator.vendor === 'KDE');
        },
        'Netscape, old Mozilla, old Firefox': function() {
            var BrowserVersion,
                BrowserDetected = false;
            if ($.browser.mozilla) {
                BrowserVersion = $.browser.version.split('.');
                if (parseInt(BrowserVersion[0], 10) < 1 || parseInt(BrowserVersion[1], 10) < 8 || parseInt(BrowserVersion[2], 10) < 1) {
                    BrowserDetected = true;;
                }
            }
            return BrowserDetected;
        }
    };

    return Namespace;
}(OTRS.Config || {}));