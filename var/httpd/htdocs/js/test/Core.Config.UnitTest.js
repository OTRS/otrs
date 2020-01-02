// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var Core = Core || {};
Core.Config = Core.Config || {};

Core.Config = (function (Namespace) {
    Namespace.RunUnitTests = function(){
        QUnit.module('Core.Config');
        QUnit.test('Core.Config.Get()', function(Assert){
            var ConfigTest = 'Test value';

            Assert.expect(6);

            Core.Config.Set('Test', ConfigTest);
            Assert.deepEqual(Core.Config.Get('Test'), ConfigTest);

            Core.Config.Set('RichText.Test', ConfigTest);
            Assert.deepEqual(Core.Config.Get('RichText.Test'), ConfigTest);

            Core.Config.Set('RichText.Test2', ConfigTest);
            Assert.deepEqual(Core.Config.Get('RichText.Test2'), ConfigTest);

            Assert.deepEqual(Core.Config.Get('non.existing.dummy.ns'), undefined);

            Assert.deepEqual(Core.Config.Get('EasyName', 42), 42, "Test for default value");

            Assert.deepEqual(Core.Config.Get('non.existing.dummy.ns', 'DefaultValueTest'), 'DefaultValueTest', "Test for default value 2");
        });

        QUnit.test('Core.Config.AddConfig()', function(Assert){

            var ConfigTest = {
                Width: 600,
                Height: 400,
                Name: 'Test'
            };

            Assert.expect(3);

            Core.Config.AddConfig(ConfigTest, 'RichText');
            Assert.deepEqual(Core.Config.Get('RichText'), ConfigTest);

            Core.Config.AddConfig(ConfigTest, 'RichText.Details');
            Assert.deepEqual(Core.Config.Get('RichText.Details'), ConfigTest);

            ConfigTest = '{"Width":"600","Height":"400","Name":"Test"}';

            Core.Config.AddConfig(ConfigTest, 'RichText.JSONStuff');
            Assert.deepEqual(Core.Config.Get('RichText.JSONStuff'), ConfigTest);
        });
    };

    return Namespace;
}(Core.Config || {}));
