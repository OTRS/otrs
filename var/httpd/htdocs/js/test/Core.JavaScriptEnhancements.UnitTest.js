// --
// Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};

Core.JavaScriptEnhancements = {};
Core.JavaScriptEnhancements.RunUnitTests = function(){

    module('Core.JavaScriptEnhancements');

    test('isJQueryObject()', function(){
        expect(6);

        equal(isJQueryObject($([])), true, 'empty jQuery object');
        equal(isJQueryObject($('body')), true, 'simple jQuery object');
        equal(isJQueryObject({}), false, 'plain object');
        equal(isJQueryObject(undefined), false, 'undefined');
        equal(isJQueryObject($([]), $([])), true, 'multiple');
        equal(isJQueryObject($([]), $([]), {}), false, 'multiple, one plain object');
    });
};
