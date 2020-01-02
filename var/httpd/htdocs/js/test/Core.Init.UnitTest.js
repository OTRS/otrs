// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var Core = Core || {};
Core.Init = Core.Init || {};

Core.Init = (function (Namespace) {
    Namespace.RunUnitTests = function(){
        QUnit.module('Core.Init');

        QUnit.test('Register and init namespaces', function (Assert) {
            Core.Init.Teststring = "";

            Assert.expect(3);

            Core.UnitTest1 = (function (TargetNS) {
                TargetNS.Init = function () {
                    Core.Init.Teststring += "1";
                };
                Core.Init.RegisterNamespace(TargetNS, 'APP_GLOBAL');
                return TargetNS;
            }(Core.UnitTest1 || {}));

            // testing sorting
            Core.UnitTest2 = (function (TargetNS) {
                TargetNS.Init = function () {
                    Core.Init.Teststring += "2";
                };
                Core.Init.RegisterNamespace(TargetNS, 'APP_GLOBAL');
                return TargetNS;
            }(Core.UnitTest2 || {}));

            Core.UnitTest3 = (function (TargetNS) {
                TargetNS.Init = function () {
                    Core.Init.Teststring += "3";
                };
                Core.Init.RegisterNamespace(TargetNS, 'APP_GLOBAL');
                return TargetNS;
            }(Core.UnitTest3 || {}));

            Core.UnitTest4 = (function (TargetNS) {
                TargetNS.Init = function () {
                    Core.Init.Teststring += "4";
                };
                Core.Init.RegisterNamespace(TargetNS, 'FINISH');
                return TargetNS;
            }(Core.UnitTest4 || {}));

            Core.UnitTest5 = (function (TargetNS) {
                TargetNS.Init = function () {
                    Core.Init.Teststring += "5";
                };
                Core.Init.RegisterNamespace(TargetNS, 'FINISH');
                return TargetNS;
            }(Core.UnitTest5 || {}));

            // empty call does nothing
            Core.Init.ExecuteInit();
            Assert.equal(Core.Init.Teststring, "");

            // calling first block
            Core.Init.ExecuteInit('APP_GLOBAL');
            Assert.equal(Core.Init.Teststring, "123");

            // calling second block
            Core.Init.ExecuteInit('FINISH');
            Assert.equal(Core.Init.Teststring, "12345");
        });
    };

    return Namespace;
}(Core.Init || {}));
