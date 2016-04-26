// --
// Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};

Core.Language = (function (Namespace) {
    Namespace.RunUnitTests = function(){

        var TranslationData = {
            'yes':                          'ja',
            'no':                           'nein',
            'This is %s':                   'Das ist %s',
            'Complex %s with %s arguments': 'Komplexer %s mit %s Argumenten'
        },
        LanguageMetaData = {
            'DateFormat':           '%D.%M.%Y %T',
            'DateFormatLong':       '%T - %D.%M.%Y',
            'DateFormatShort':      '%D.%M.%Y',
            'DateInputFormat':      '%D.%M.%Y',
            'DateInputFormatLong':  '%D.%M.%Y - %T'
        };

        QUnit.module('Core.Language');

        QUnit.test('Translations', function(){
            Core.Language.Load(LanguageMetaData, TranslationData);
            equal(Core.Language.Translate('yes'), 'ja');
            equal(Core.Language.Translate('no'), 'nein');
            equal(Core.Language.Translate('This is %s', 'OTRS'), 'Das ist OTRS');
            equal(Core.Language.Translate('This is %s', 'yes'), 'Das ist yes');
            equal(Core.Language.Translate('Complex %s with %s arguments', 'Text', 'vielen'), 'Komplexer Text mit vielen Argumenten');
        });
    };

    return Namespace;
}(Core.Language || {}));
