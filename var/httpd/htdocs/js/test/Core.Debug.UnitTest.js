// --
// Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
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
        module('Core.Debug');
        test('Core.Debug.CheckDependency()', function(){

            Core.Debug.DummyFunction = function(){};

            expect(4);

            equal(
                Core.Debug.CheckDependency('Core.Debug.RunUnitTests', 'Core.Debug.DummyFunction', 'existing_function', true),
                true
            );

            equal(
                Core.Debug.CheckDependency('Core.Debug.RunUnitTests', 'Core.Debug.DummyFunction2', 'existing_function', true),
                false
            );

            equal(
                Core.Debug.CheckDependency('Core.Debug.RunUnitTests', 'Core.Debug2.DummyFunction2', 'existing_function', true),
                false
                );

            equal(
                Core.Debug.CheckDependency('Core.Debug.RunUnitTests', 'nonexisting_function', 'nonexisting_function', true),
                false
            );

            delete Core.Debug.DummyFunction;
        });
    };

    return Namespace;
}(Core.Debug || {}));
