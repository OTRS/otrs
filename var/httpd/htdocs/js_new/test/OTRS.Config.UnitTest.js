// --
// OTRS.Config.UnitTest.js - UnitTests
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.Config.UnitTest.js,v 1.1 2010-05-31 09:09:34 mg Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};
OTRS.Config = OTRS.Config || {};

OTRS.Config = (function (Namespace) {
    Namespace.RunUnitTests = function(){
        module('OTRS.Config');
        test('OTRS.Config.Get()', function(){
            expect(3);

            var ConfigTest = 'Test value';
            OTRS.Config.Set('Test', ConfigTest);
            same(OTRS.Config.Get('Test'), ConfigTest);

            OTRS.Config.Set('Richttext.Test', ConfigTest);
            same(OTRS.Config.Get('Richttext.Test'), ConfigTest);

            OTRS.Config.Set('Richttext.Test2', ConfigTest);
            same(OTRS.Config.Get('Richttext.Test2'), ConfigTest);
        });

        test('OTRS.Config.AddConfig()', function(){
            expect(3);

            var ConfigTest = {
                Width:  600,
                Height: 400,
                Name: 'Test'
            };
            OTRS.Config.AddConfig(ConfigTest, 'RichText');
            same(OTRS.Config.Get('Richtext'), ConfigTest);

            OTRS.Config.AddConfig(ConfigTest, 'Richtext.Details');
            same(OTRS.Config.Get('Richtext.Details'), ConfigTest);

            var ConfigTest = '{"Width":"600","Height":"400","Name":"Test"}';

            OTRS.Config.AddConfig(ConfigTest,'Richtext.JSONStuff');
            same(OTRS.Config.Get('Richtext.JSONStuff'), ConfigTest);
        });
    };

    return Namespace;
}(OTRS.Config || {}));