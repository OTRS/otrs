// --
// Core.Data.js - provides functions for setting and getting data (objects) to DOM elements
// Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};

/**
 * @namespace
 * @exports TargetNS as Core.Data
 * @description
 *      Provides functions for setting and getting data (objects) to DOM elements
 */
Core.Data = (function (TargetNS) {

    /**
     * @function
     * @description
     *      Save object data to an element
     * @param {jQueryObject} $Element jquery object
     * @param {String} Name The name of the object, which can be referenced to get the data again (-> the variable name)
     * @param {Object} Object The javascript data you want to save (any type of javascript object)
     */
    TargetNS.Set = function ($Element, Name, Object) {
        if (isJQueryObject($Element)) {
            $Element.data(Name, Object);
        }
    };

    /**
     * @function
     * @description
     *      Retrieve data from dom element
     * @param {jQueryObject} $Element jquery object
     * @param {String} Name The name of the object, which can be referenced to get the data again (-> the variable name)
     * @return {Object} The stored data or an empty object on failure
     */
    TargetNS.Get = function ($Element, Name) {
        var Object;
        if (isJQueryObject($Element)) {
            Object = $Element.data(Name);
            if (typeof Object === 'undefined' || Object === null) {
                return {};
            }
            else {
                return Object;
            }
        }
        return {};
    };

    /**
     * @function
     * @description
     *      This function compares 2 JSONObjects
     * @param {ObjectA} ObjectOne JSONObject The object which should be compared
     * @param {ObjectB} ObjectTwo JSONObject The object which should be compared
     * @return {Boolean} True or False Value
     */
    TargetNS.CompareObject = function (ObjectOne, ObjectTwo) {
        var Key;

        if (!ObjectOne || !ObjectTwo) {
            return false;
        }
        if (typeof(ObjectOne) !== 'object' || typeof(ObjectTwo) !== 'object') {
            return false;
        }

        if (ObjectOne.constructor !== ObjectTwo.constructor) {
            return false;
        }

        for (Key in ObjectOne) {
            if ((typeof(ObjectOne[Key]) === 'object') &&
                (typeof(ObjectTwo[Key]) === 'object')) {
                if (!Core.Data.CompareObject(ObjectOne[Key], ObjectTwo[Key])) {
                    return false;
                }
            }
            else {
                if (ObjectOne[Key] !== ObjectTwo[Key]) {
                    return false;
                }
            }
        }

        for (Key in ObjectTwo) {
            if ((typeof(ObjectTwo[Key]) === 'object') &&
                (typeof(ObjectOne[Key]) === 'object')) {
                if (!Core.Data.CompareObject(ObjectTwo[Key], ObjectOne[Key])) {
                    return false;
                }
            }
            else {
                if (ObjectTwo[Key] !== ObjectOne[Key]) {
                    return false;
                }
            }
        }

        return true;
    };

    /**
     * @function
     * @description
     *      This function creates a copy of an object
     * @param {Object}  Data The object which should be copied
     * @return {Object} The new object
     */
    TargetNS.CopyObject = function (Data) {
        var Key = '',
            TempObject;
        if (!Data || typeof(Data) !== 'object') {
            return Data;
        }

        TempObject = new Data.constructor();
        for (Key in Data) {
            if (Data.hasOwnProperty(Key)) {
                TempObject[Key] = Core.Data.CopyObject(Data[Key]);
            }
        }
        return TempObject;
    };

    return TargetNS;
}(Core.Data || {}));
