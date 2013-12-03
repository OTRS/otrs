// --
// Core.UI.Popup.UnitTest.js - UnitTests
// Copyright (C) 2001-2012 OTRS AG, http://otrs.org/\n";
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};
Core.UI = Core.UI || {};

Core.UI.Popup = (function (Namespace) {
    Namespace.RunUnitTests = function(){

        module('Core.UI.Popup');

        test('PopupProfiles', 2, function(){

            var ExpectedProfiles = {
                'Default': {
                    WindowURLParams: "dependent=yes,location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,toolbar=no",
                    Left:            100,
                    Top:             100,
                    Width:           1000,
                    Height:          700
                }
            };

            deepEqual(Core.UI.Popup.ProfileList(), ExpectedProfiles, 'Default profile list');

            ExpectedProfiles['CustomLarge'] = "dependent=yes,height=700,left=100,top=100,location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,toolbar=no,width=1000";

            Core.UI.Popup.ProfileAdd('CustomLarge', ExpectedProfiles['CustomLarge']);

            deepEqual(Core.UI.Popup.ProfileList(), ExpectedProfiles, 'Modified profile list');
        });
    };

    return Namespace;
}(Core.UI.Popup || {}));
