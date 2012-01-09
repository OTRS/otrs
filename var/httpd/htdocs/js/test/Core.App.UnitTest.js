// --
// Core.App.UnitTest.js - UnitTests
// Copyright (C) 2001-2012 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.App.UnitTest.js,v 1.1 2012-01-09 11:44:55 mg Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};
Core.App = Core.App || {};

Core.App = (function (Namespace) {
    Namespace.RunUnitTests = function(){
        module('Core.App');

        test('Core.App.GetSessionInformation()', function(){
            expect(2);

            Core.Config.Set('SessionName', 'CSID');
            Core.Config.Set('SessionID', '1234');
            Core.Config.Set('CustomerPanelSessionName', 'CPanelSID');
            Core.Config.Set('ChallengeToken', 'C123');

            same(Core.App.GetSessionInformation(), {
                CSID: '1234',
                CPanelSID: '1234',
                ChallengeToken: 'C123'
            });

            Core.Config.Set('SessionIDCookie', true);
            same(Core.App.GetSessionInformation(), {
                ChallengeToken: 'C123'
            });
        });
    };

    return Namespace;
}(Core.App || {}));