// --
// Core.JavaScriptEnhancements.js - provides functions for validating form inputs
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.JavaScriptEnhancements.js,v 1.2 2010-07-07 08:17:39 mn Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

(function () {

    /*
     * Keep this regular expression as a static variable; it is used
     * in the String.trim function.
     */
    var WhitespaceCheck = /\s/;

    /**
     * @function
     * @description
     *      This function adds a trim() method to the JavaScript String Object.
     *
     *      It will remove whitespace from the beginning and end of a string.
     *      You can call it on any String object, including string literals.
     * @example
     *      var trimmed = ' a string  '.trim(); // trimmed will contain 'a string'
     * @return
     *      The trimmed string
     */
    String.prototype.trim = function () {
        var NonWhitespaceStartIndex = 0,
            NonWhitespaceEndIndex = this.length;
        while (WhitespaceCheck.test(this.charAt(NonWhitespaceStartIndex++))) {}
        while (WhitespaceCheck.test(this.charAt(--NonWhitespaceEndIndex))) {}
        return this.slice(--NonWhitespaceStartIndex, ++NonWhitespaceEndIndex);
    };

    /**
     * @function
     * @description
     *      This function checks if all given parameter objects are jQuery objects.
     * @return
     *      {boolean} Returns true if all parameter objects are jQuery objects
     */
    window.isJQueryObject = function () {
        var I;
        if (typeof jQuery === 'undefined') {
            return false;
        }
        for (I = 0; I < arguments.length; I++) {
            if (!(arguments[I] instanceof jQuery)) {
                return false;
            }
        }
        return true;
    };
}());