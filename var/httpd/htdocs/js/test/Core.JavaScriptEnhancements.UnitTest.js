// --
// Core.JavaScriptEnhancements.UnitTest.js - UnitTests
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.JavaScriptEnhancements.UnitTest.js,v 1.1 2010-07-13 09:46:45 mg Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};

Core.JavaScriptEnhancements = {};
Core.JavaScriptEnhancements.RunUnitTests = function(){

    module('Core.JavaScriptEnhancements');

    test('String.trim()', function(){
        expect(4);

        equals(' some string\n    test\r\n\t '.trim(), 'some string\n    test', '');
        equals('   '.trim(), '');
        equals(''.trim(), '');
        equals('Test String'.trim(), 'Test String');
    });
};