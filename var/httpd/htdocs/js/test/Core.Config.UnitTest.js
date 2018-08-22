// --
// Copyright (C) 2001-2018 OTRS AG, https://otrs.com/\n";
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var OTRS = OTRS || {};
Core.Config = Core.Config || {};

Core.Config = (function (Namespace) {
    Namespace.RunUnitTests = function(){
        module('Core.Config');
        test('Core.Config.Get()', function(){
            expect(6);

            var ConfigTest = 'Test value';
            Core.Config.Set('Test', ConfigTest);
            same(Core.Config.Get('Test'), ConfigTest);

            Core.Config.Set('RichText.Test', ConfigTest);
            same(Core.Config.Get('RichText.Test'), ConfigTest);

            Core.Config.Set('RichText.Test2', ConfigTest);
            same(Core.Config.Get('RichText.Test2'), ConfigTest);

            same(Core.Config.Get('non.existing.dummy.ns'), undefined);

            same(Core.Config.Get('EasyName', 42), 42, "Test for default value");

            same(Core.Config.Get('non.existing.dummy.ns', 'DefaultValueTest'), 'DefaultValueTest', "Test for default value 2");
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
