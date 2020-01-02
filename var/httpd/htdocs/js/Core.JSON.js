// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var Core = Core || {};

/**
 * @namespace Core.JSON
 * @memberof Core
 * @author OTRS AG
 * @description
 *      Contains the code for the JSON functions.
 */
Core.JSON = (function (TargetNS) {

    // Some old browsers (e.g. IE7) don't have native JSON support. Such browsers will
    // let you see a javascript error message instead of the 'old browser' warning box.
    // Therefore we do the dependency check silent in this case.
    if (!Core.Debug.CheckDependency('Core.JSON', 'JSON.parse', 'JSON parser', true)) {
        return false;
    }

    /**
     * @name Parse
     * @memberof Core.JSON
     * @function
     * @returns {Object} The parsed JSON object.
     * @param {String} JSONString - The string which should be parsed.
     * @description
     *      This function parses a JSON String.
     */
    TargetNS.Parse = function (JSONString) {
        var JSONObject;

        if (typeof JSONString !== 'string' && typeof JSONString !== 'undefined') {
            return JSONString;
        }

        try {
            JSONObject = JSON.parse(JSONString);
        }
        catch (e) {
            JSONObject = {};
        }

        return JSONObject;
    };

    /**
     * @name Stringify
     * @memberof Core.JSON
     * @function
     * @returns {String} The stringified JSON object.
     * @param {Object} JSONObject - The object which should be stringified.
     * @description
     *      This function stringifies a given JavaScript object.
     */
    TargetNS.Stringify = function (JSONObject) {
        var JSONString;

        try {
            JSONString = JSON.stringify(JSONObject);
        }
        catch (e) {
            JSONString = "";
        }

        return JSONString;
    };

    return TargetNS;
}(Core.JSON || {}));
