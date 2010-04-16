// --
// OTRS.JavaScriptEnhancements.js - provides functions for validating form inputs
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.JavaScriptEnhancements.js,v 1.3 2010-04-16 21:48:16 mn Exp $
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

}());