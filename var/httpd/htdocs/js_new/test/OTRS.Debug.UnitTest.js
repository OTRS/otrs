// --
// OTRS.Debug.UnitTest.js - UnitTests
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.Debug.UnitTest.js,v 1.1 2010-05-31 09:09:34 mg Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};
OTRS.Debug = OTRS.Debug || {};

OTRS.Debug = (function (Namespace) {
    Namespace.RunUnitTests = function(){
        module('OTRS.Debug');
        test('OTRS.Debug.CheckDependency()', function(){

            OTRS.Debug.DummyFunction = function(){};

            expect(4);

            equals(
                OTRS.Debug.CheckDependency('OTRS.Debug.RunUnitTests', 'OTRS.Debug.DummyFunction', 'existing_function', true),
                true
            );

            equals(
                OTRS.Debug.CheckDependency('OTRS.Debug.RunUnitTests', 'OTRS.Debug.DummyFunction2', 'existing_function', true),
                false
            );

            equals(
                OTRS.Debug.CheckDependency('OTRS.Debug.RunUnitTests', 'OTRS.Debug2.DummyFunction2', 'existing_function', true),
                false
                );

            equals(
                OTRS.Debug.CheckDependency('OTRS.Debug.RunUnitTests', 'nonexisting_function', 'nonexisting_function', true),
                false
            );

            delete OTRS.Debug.DummyFunction;
        });
    };

    return Namespace;
}(OTRS.Debug || {}));