// --
// Core.Config.UnitTest.js - UnitTests
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.Config.UnitTest.js,v 1.1 2010-06-07 08:51:10 mg Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};
Core.Config = Core.Config || {};

Core.Config = (function (Namespace) {
    Namespace.RunUnitTests = function(){
        module('Core.Config');
        test('Core.Config.Get()', function(){
            expect(3);

            var ConfigTest = 'Test value';
            Core.Config.Set('Test', ConfigTest);
            same(Core.Config.Get('Test'), ConfigTest);

            Core.Config.Set('RichText.Test', ConfigTest);
            same(Core.Config.Get('RichText.Test'), ConfigTest);

            Core.Config.Set('RichText.Test2', ConfigTest);
            same(Core.Config.Get('RichText.Test2'), ConfigTest);
        });

        test('Core.Config.AddConfig()', function(){
            expect(3);

            var ConfigTest = {
                Width:  600,
                Height: 400,
                Name: 'Test'
            };
            Core.Config.AddConfig(ConfigTest, 'RichText');
            same(Core.Config.Get('RichText'), ConfigTest);

            Core.Config.AddConfig(ConfigTest, 'RichText.Details');
            same(Core.Config.Get('RichText.Details'), ConfigTest);

            var ConfigTest = '{"Width":"600","Height":"400","Name":"Test"}';

            Core.Config.AddConfig(ConfigTest,'RichText.JSONStuff');
            same(Core.Config.Get('RichText.JSONStuff'), ConfigTest);
        });
    };

    return Namespace;
}(Core.Config || {}));