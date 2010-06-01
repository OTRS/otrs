// --
// OTRS.Config.UnitTest.js - UnitTests
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.Config.UnitTest.js,v 1.2 2010-06-01 08:31:45 mn Exp $
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

            OTRS.Config.Set('RichText.Test', ConfigTest);
            same(OTRS.Config.Get('RichText.Test'), ConfigTest);

            OTRS.Config.Set('RichText.Test2', ConfigTest);
            same(OTRS.Config.Get('RichText.Test2'), ConfigTest);
        });

        test('OTRS.Config.AddConfig()', function(){
            expect(3);

            var ConfigTest = {
                Width:  600,
                Height: 400,
                Name: 'Test'
            };
            OTRS.Config.AddConfig(ConfigTest, 'RichText');
            same(OTRS.Config.Get('RichText'), ConfigTest);

            OTRS.Config.AddConfig(ConfigTest, 'RichText.Details');
            same(OTRS.Config.Get('RichText.Details'), ConfigTest);

            var ConfigTest = '{"Width":"600","Height":"400","Name":"Test"}';

            OTRS.Config.AddConfig(ConfigTest,'RichText.JSONStuff');
            same(OTRS.Config.Get('RichText.JSONStuff'), ConfigTest);
        });
    };

    return Namespace;
}(OTRS.Config || {}));