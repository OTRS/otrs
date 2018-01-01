// --
// Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.Debug = Core.Debug || {};

Core.Debug = (function (Namespace) {
    Namespace.RunUnitTests = function(){
        QUnit.module('Core.Debug');
        QUnit.test('Core.Debug.CheckDependency()', function(Assert){

            Core.Debug.DummyFunction = function(){};

            Assert.expect(4);

            Assert.equal(
                Core.Debug.CheckDependency('Core.Debug.RunUnitTests', 'Core.Debug.DummyFunction', 'existing_function', true),
                true
            );

            Assert.equal(
                Core.Debug.CheckDependency('Core.Debug.RunUnitTests', 'Core.Debug.DummyFunction2', 'existing_function', true),
                false
            );

            Assert.equal(
                Core.Debug.CheckDependency('Core.Debug.RunUnitTests', 'Core.Debug2.DummyFunction2', 'existing_function', true),
                false
                );

            Assert.equal(
                Core.Debug.CheckDependency('Core.Debug.RunUnitTests', 'nonexisting_function', 'nonexisting_function', true),
                false
            );

            delete Core.Debug.DummyFunction;
        });
    };

    return Namespace;
}(Core.Debug || {}));
