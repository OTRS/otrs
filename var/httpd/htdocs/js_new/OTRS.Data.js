// --
// OTRS.Data.js - provides functions for setting and getting data (objects) to DOM elements
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.Data.js,v 1.1 2010-04-12 21:40:42 mn Exp $
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
 *      Provides functions for setting and getting data (objects) to DOM elements
 */
OTRS.Data = (function (Namespace) {

    /**
     * @function
     * @description
     *      Save object data to an element
     * @param {String} Element Element selector string (jQuery selector) or a jquery object
     * @param {String} Name The name of the object, which can be referenced to get the data again (-> the variable name)
     * @param {Object} Object The javascript data you want to save (any type of javascript object)
     */
    Namespace.Set = function (Element, Name, Object) {
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
    }

    /**
     * @function
     * @description
     *      Retrieve data from dom element
     * @param {String} Element Element selector string (jQuery selector) or a jquery object
     * @param {String} Name The name of the object, which can be referenced to get the data again (-> the variable name)
     * @return {Object} The stored data or an empty object on failure
     */
    Namespace.Get = function (Element, Name) {
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
    }

    return Namespace;
}(OTRS.Data || {}));