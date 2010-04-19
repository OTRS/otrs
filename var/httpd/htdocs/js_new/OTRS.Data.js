// --
// OTRS.Data.js - provides functions for setting and getting data (objects) to DOM elements
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.Data.js,v 1.3 2010-04-19 16:36:29 mg Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};

/**
 * @namespace
 * @exports TargetNS as OTRS.Data
 * @description
 *      Provides functions for setting and getting data (objects) to DOM elements
 */
OTRS.Data = (function (TargetNS) {

    /**
     * @function
     * @description
     *      Save object data to an element
     * @param {String} Element Element selector string (jQuery selector) or a jquery object
     * @param {String} Name The name of the object, which can be referenced to get the data again (-> the variable name)
     * @param {Object} Object The javascript data you want to save (any type of javascript object)
     */
    TargetNS.Set = function (Element, Name, Object) {
        var $Element;
        //Check, if it is an selector string or an jquery object
        if (typeof Element === 'String')
        {
            $Element = $(Element);
        }
        else if (Element instanceof jQuery)
        {
            $Element = Element;
        }

        $Element.data(Name, Object);
    };

    /**
     * @function
     * @description
     *      Retrieve data from dom element
     * @param {String} Element Element selector string (jQuery selector) or a jquery object
     * @param {String} Name The name of the object, which can be referenced to get the data again (-> the variable name)
     * @return {Object} The stored data or an empty object on failure
     */
    TargetNS.Get = function (Element, Name) {
        var $Element,
            Object;
        //Check, if it is an selector string or an jquery object
        if (typeof Element === 'String')
        {
            $Element = $(Element);
        }
        else if (Element instanceof jQuery)
        {
            $Element = Element;
        }

        Object = $Element.data(Name);
        if (typeof Object === 'undefined')
        {
            return {};
        }
        else
        {
            return Object;
        }
    };

    return TargetNS;
}(OTRS.Data || {}));