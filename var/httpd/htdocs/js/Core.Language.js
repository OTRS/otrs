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
 * @namespace Core.Language
 * @memberof Core
 * @author OTRS AG
 * @description
 *      Provides functions for translating strings in JavaScript functions.
 */
Core.Language = (function (TargetNS) {

    var MetaData = {}, //eslint-disable-line no-unused-vars
        Translations = {};

    /**
     * @name Load
     * @memberof Core.Language
     * @function
     * @param {Object} LanguageMetaData - The language meta data, like date format strings.
     * @param {Object} TranslationData  - The language data hash, the key is the original string, the value its translation.
     * @description
     *      Load translation data for the specified language for later use.
     */
    TargetNS.Load = function (LanguageMetaData, TranslationData) {
        if (typeof LanguageMetaData !== 'object' || typeof TranslationData !== 'object') {
            return;
        }

        MetaData     = LanguageMetaData;
        Translations = TranslationData;
    };

    /**
     * @name Translate
     * @memberof Core.Language
     * @function
     * @param {String} TranslateString - String to translate.
     * @param {...String} [Parameter] - Multiple parameters that replace %s in TranslateString.
     * @return {String} The translated string.
     * @description
     *      Translate the given string.
     */
    TargetNS.Translate = function (TranslateString) {
        var Translated = "",
            Args;

        if (typeof TranslateString === 'undefined') {
            return "";
        }

        // Get translated string
        Translated = Translations[TranslateString];

        // If no translation available, take original string
        if (!Translated || !Translated.length) {
            Translated = TranslateString;
        }

        // if there are no further parameter, translation is ready and can be returned
        if (arguments.length <= 1) {
            return Translated;
        }

        // otherwise, we replace all %s with the arguments given
        // replace only replaces the first occurance, save to use in a loop
        for (Args = 1; Args < arguments.length; Args++) {
            Translated = Translated.replace('%s', arguments[Args]);
        }

        return Translated;
    };

    /**
     * @name DecimalSeparatorGet
     * @memberof Core.Language
     * @function
     * @return {String} Decimal separator for current language
     * @description
     *      Returns decimal separator for selected language.
     */
    TargetNS.DecimalSeparatorGet = function () {
        return MetaData.DecimalSeparator;
    };

    return TargetNS;
}(Core.Language || {}));
