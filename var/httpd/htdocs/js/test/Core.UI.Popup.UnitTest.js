// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var Core = Core || {};
Core.UI = Core.UI || {};

Core.UI.Popup = (function (Namespace) {
    Namespace.RunUnitTests = function(){

        QUnit.module('Core.UI.Popup');

        QUnit.test('PopupProfiles', function(Assert){

            var ExpectedProfiles = {
                'Default': {
                    WindowURLParams: "dependent=yes,location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,toolbar=no",
                    Left: 100,
                    Top: 100,
                    Width: 1040,
                    Height: 700
                }
            };

            Assert.expect(2);

            Assert.deepEqual(Core.UI.Popup.ProfileList(), ExpectedProfiles, 'Default profile list');

            ExpectedProfiles.CustomLarge = "dependent=yes,height=700,left=100,top=100,location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,toolbar=no,width=1000";

            Core.UI.Popup.ProfileAdd('CustomLarge', ExpectedProfiles.CustomLarge);

            Assert.deepEqual(Core.UI.Popup.ProfileList(), ExpectedProfiles, 'Modified profile list');
        });
    };

    return Namespace;
}(Core.UI.Popup || {}));
