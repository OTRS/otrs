// --
// Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.App = Core.App || {};

Core.App.Responsive = (function (Namespace) {
    Namespace.RunUnitTests = function(){

        QUnit.module('Core.App.Responsive');

        QUnit.test('IsSmallerOrEqual', function(Assert){
            Assert.expect(4);

            Assert.ok(Core.App.Responsive.IsSmallerOrEqual('ScreenL', 'ScreenXL'));
            Assert.ok(Core.App.Responsive.IsSmallerOrEqual('ScreenXS', 'ScreenL'));
            Assert.ok(Core.App.Responsive.IsSmallerOrEqual('ScreenM', 'ScreenM'));
            Assert.ok(!Core.App.Responsive.IsSmallerOrEqual('ScreenL', 'ScreenM'));
        });
    };

    return Namespace;
}(Core.App.Responsive || {}));
