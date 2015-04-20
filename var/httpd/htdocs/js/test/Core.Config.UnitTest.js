// --
// Core.Config.UnitTest.js - UnitTests
// Copyright (C) 2001-2012 OTRS AG, http://otrs.org/\n";
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.Config = Core.Config || {};

Core.Config = (function (Namespace) {
    Namespace.RunUnitTests = function(){
        module('Core.Config');
        test('Core.Config.Get()', function(){
            expect(6);

            var ConfigTest = 'Test value';
            Core.Config.Set('Test', ConfigTest);
            deepEqual(Core.Config.Get('Test'), ConfigTest);

            Core.Config.Set('RichText.Test', ConfigTest);
            deepEqual(Core.Config.Get('RichText.Test'), ConfigTest);

            Core.Config.Set('RichText.Test2', ConfigTest);
            deepEqual(Core.Config.Get('RichText.Test2'), ConfigTest);

            deepEqual(Core.Config.Get('non.existing.dummy.ns'), undefined);

            deepEqual(Core.Config.Get('EasyName', 42), 42, "Test for default value");

            deepEqual(Core.Config.Get('non.existing.dummy.ns', 'DefaultValueTest'), 'DefaultValueTest', "Test for default value 2");
        });

        test('Core.Config.AddConfig()', function(){
            expect(3);

            var ConfigTest = {
                Width:  600,
                Height: 400,
                Name: 'Test'
            };
            Core.Config.AddConfig(ConfigTest, 'RichText');
            deepEqual(Core.Config.Get('RichText'), ConfigTest);

            Core.Config.AddConfig(ConfigTest, 'RichText.Details');
            deepEqual(Core.Config.Get('RichText.Details'), ConfigTest);

            ConfigTest = '{"Width":"600","Height":"400","Name":"Test"}';

            Core.Config.AddConfig(ConfigTest,'RichText.JSONStuff');
            deepEqual(Core.Config.Get('RichText.JSONStuff'), ConfigTest);
        });
    };

    return Namespace;
}(Core.Config || {}));
