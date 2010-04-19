// --
// OTRS.JSON.js - Resizable
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.JSON.js,v 1.3 2010-04-19 16:36:29 mg Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};

/**
 * @namespace
 * @exports TargetNS as OTRS.JSON
 * @description
 *      Contains the code for the JSON functions.
 */
OTRS.JSON = (function (TargetNS) {

    if (!OTRS.Debug.CheckDependency('OTRS.JSON', 'JSON.parse', 'JSON parser')) {
        return;
    }

    /**
     * @function
     * @description
     *      This function parses a JSON String
     * @param {String} JSONString The string which should be parsed
     * @return {Object} The parsed JSON object
     */
    TargetNS.Parse = function (JSONString) {
        var JSONObject;

        try {
            JSONObject = JSON.parse(JSONString);
        }
        catch (e) {
            JSONObject = {};
        }

        return JSONObject;
    };

    /**
     * @function
     * @description
     *      This function stringifies a given JavaScript object
     * @param {Object} JSONObject The object which should be stringified
     * @return {String} The stringified JSON object
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
}(OTRS.JSON || {}));