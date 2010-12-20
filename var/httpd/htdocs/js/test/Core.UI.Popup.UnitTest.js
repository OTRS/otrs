// --
// Core.UI.Accessibility.UnitTest.js - UnitTests
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.UI.Popup.UnitTest.js,v 1.1 2010-12-20 09:22:03 mg Exp $
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
                    'Default': "dependent=yes,height=700,left=100,top=100,location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,toolbar=no,width=1000"
            };

            same(Core.UI.Popup.ProfileList(), ExpectedProfiles, 'Default profile list');

            ExpectedProfiles['CustomLarge'] = "dependent=yes,height=700,left=100,top=100,location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,toolbar=no,width=1000";

            Core.UI.Popup.ProfileAdd('CustomLarge', ExpectedProfiles['CustomLarge']);

            same(Core.UI.Popup.ProfileList(), ExpectedProfiles, 'Modified profile list');
        });
    };

    return Namespace;
}(Core.UI.Popup || {}));