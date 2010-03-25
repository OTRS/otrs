// --
// OTRS.JavaScriptEnhancements.UnitTest.js - UnitTests
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.JavaScriptEnhancements.UnitTest.js,v 1.1 2010-03-25 15:04:37 mg Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};

OTRS.JavaScriptEnhancements = {};
OTRS.JavaScriptEnhancements.RunUnitTests = function(){

    module('OTRS.JavaScriptEnhancements');

    test('String.trim()', function(){
        expect(4);

        equals(' some string\n    test\r\n\t '.trim(), 'some string\n    test', '');
        equals('   '.trim(), '');
        equals(''.trim(), '');
        equals('Test String'.trim(), 'Test String');
    });
};