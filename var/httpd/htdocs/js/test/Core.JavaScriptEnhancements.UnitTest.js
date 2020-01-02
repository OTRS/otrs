// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var Core = Core || {};

Core.JavaScriptEnhancements = {};
Core.JavaScriptEnhancements.RunUnitTests = function(){

    QUnit.module('Core.JavaScriptEnhancements');

    QUnit.test('isJQueryObject()', function(Assert){
        Assert.expect(6);

        Assert.equal(isJQueryObject($([])), true, 'empty jQuery object');
        Assert.equal(isJQueryObject($('body')), true, 'simple jQuery object');
        Assert.equal(isJQueryObject({}), false, 'plain object');
        Assert.equal(isJQueryObject(undefined), false, 'undefined');
        Assert.equal(isJQueryObject($([]), $([])), true, 'multiple');
        Assert.equal(isJQueryObject($([]), $([]), {}), false, 'multiple, one plain object');
    });
};
