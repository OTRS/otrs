// --
// Core.Data.js - provides functions for setting and getting data (objects) to DOM elements
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.Data.js,v 1.1 2010-06-04 11:19:31 mn Exp $
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
            if (typeof Object === 'undefined') {
                return {};
            }
            else {
                return Object;
            }
        }
    };

    return TargetNS;
}(Core.Data || {}));