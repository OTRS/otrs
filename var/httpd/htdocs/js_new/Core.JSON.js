// --
// Core.JSON.js - Resizable
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.JSON.js,v 1.2 2010-06-24 07:08:40 cg Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};

/**
 * @namespace
 * @exports TargetNS as Core.JSON
 * @description
 *      Contains the code for the JSON functions.
 */
Core.JSON = (function (TargetNS) {

    if (!Core.Debug.CheckDependency('Core.JSON', 'JSON.parse', 'JSON parser')) {
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


    /**
     * @function
     * @description
     *      This function compare 2 JSONObjects
     * @param {ObjectA} JSONObject The object which should be compared
     * @param {ObjectB} JSONObject The object which should be compared
     * @return {Boolean} True or False Value
     */
    TargetNS.CompareObject = function (JSONObjectOne, JSONObjectTwo) {
            var Counter;
            var Result  = true;
            
            if (JSONObjectOne == null || typeof(JSONObjectOne) !== 'object' ||
                JSONObjectTwo == null || typeof(JSONObjectTwo) !== 'object') {
                return false;
            }
            
            if ( JSONObjectOne.constructor !== JSONObjectTwo.constructor) {
                return false;
            }
            
            for (var Key in JSONObjectOne) {
                if ( (typeof(JSONObjectOne[Key]) == 'object' ) &&
                     (typeof(JSONObjectTwo[Key]) == 'object' )  )  {
                    if ( !Core.JSON.CompareObject(JSONObjectOne[Key], JSONObjectTwo[Key]) ){
                        Result  = false;
                        break;
                    }
                } else
                    {
                        if ( JSONObjectOne[Key] !== JSONObjectTwo[Key] ){
                            Result  = false;
                            break;
                        }
                    }
            }

            for (var Key in JSONObjectTwo) {
                if ( (typeof(JSONObjectTwo[Key]) == 'object' ) &&
                     (typeof(JSONObjectOne[Key]) == 'object' )  )  {
                    if ( !Core.JSON.CompareObject(JSONObjectTwo[Key], JSONObjectOne[Key]) ){
                        Result  = false;
                        break;
                    }
                } else
                    {
                        if ( JSONObjectTwo[Key] !== JSONObjectOne[Key] ){
                            Result  = false;
                            break;
                        }
                    }
            }
            
            return Result;
        };

    return TargetNS;
}(Core.JSON || {}));