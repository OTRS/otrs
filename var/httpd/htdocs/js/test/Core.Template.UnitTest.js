// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var Core = Core || {};

Core.Template = (function (Namespace) {
    Namespace.RunUnitTests = function(){
        QUnit.module('Core.Template');
        QUnit.test('Core.Template.Render()', function(Assert){

            var Templates = {
                'Basetemplate' : 'Basetemplate with {{one}}, {{two}}, {{three}}.',
                'Translation'  : 'Another template with {{"User" | Translate}}',
                'TranslationComplex' : 'Another template with {{"User with %s and %s" | Translate("1", "2")}}',
                'TranslationComplexWithData' : 'Another template with {{"User with %s and %s" | Translate(var_1, var_2)}}'
            };

            Core.Template.Init();

            // manually load the template
            Core.Template.Load(Templates);

            // load manually to check if the filter works correctly
            Core.Language.Load({}, {
                'User' : 'Benutzer',
                'User with %s and %s' : 'Benutzer mit %s und %s'
            });

            Assert.equal(Core.Template.Render('Basetemplate', { 'one' : '1', 'two' : '2', 'three' : '3' }), 'Basetemplate with 1, 2, 3.');
            Assert.equal(Core.Template.Render('Translation', {}), 'Another template with Benutzer');
            Assert.equal(Core.Template.Render('TranslationComplex', {}), 'Another template with Benutzer mit 1 und 2');
            Assert.equal(Core.Template.Render('TranslationComplexWithData', { 'var_1' : 'var_1_result', 'var_2' : 'var_2_result' }), 'Another template with Benutzer mit var_1_result und var_2_result');
        });
    };

    return Namespace;
}(Core.Template || {}));
