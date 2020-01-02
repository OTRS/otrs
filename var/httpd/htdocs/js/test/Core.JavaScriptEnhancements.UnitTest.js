// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/\n";
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var OTRS = OTRS || {};

Core.JavaScriptEnhancements = {};
Core.JavaScriptEnhancements.RunUnitTests = function(){

    module('Core.JavaScriptEnhancements');

    test('isJQueryObject()', function(){
        expect(6);

        equals(isJQueryObject($([])), true, 'empty jQuery object');
        equals(isJQueryObject($('body')), true, 'simple jQuery object');
        equals(isJQueryObject({}), false, 'plain object');
        equals(isJQueryObject(undefined), false, 'undefined');
        equals(isJQueryObject($([]), $([])), true, 'multiple');
        equals(isJQueryObject($([]), $([]), {}), false, 'multiple, one plain object');
    });
};
