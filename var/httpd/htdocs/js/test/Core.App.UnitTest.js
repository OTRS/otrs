// --
// Core.App.UnitTest.js - UnitTests
// Copyright (C) 2001-2012 OTRS AG, http://otrs.org/\n";
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

            deepEqual(Core.App.GetSessionInformation(), {
                CSID: '1234',
                CPanelSID: '1234',
                ChallengeToken: 'C123'
            });

            Core.Config.Set('SessionIDCookie', true);
            deepEqual(Core.App.GetSessionInformation(), {
                ChallengeToken: 'C123'
            });
        });

        test('Core.App.EscapeSelector()', function () {
            expect(3);
            var Selector = 'ConfigItemClass::Config::Hardware::MapTypeAdd::Attribute###SubItem',
                Id,
                Value;

            equal(Core.App.EscapeSelector(Selector), 'ConfigItemClass\\:\\:Config\\:\\:Hardware\\:\\:MapTypeAdd\\:\\:Attribute\\#\\#\\#SubItem');
            equal(Core.App.EscapeSelector('ID-mit_anderen+Sonderzeichen'), 'ID-mit_anderen+Sonderzeichen');

            $('<div id="testcase"><label for="Testcase::Element###SubItem">Elementlabeltext</label><input type="text" id="Testcase::Element###SubItem" value="5"/></div>').appendTo('body');
            Id = $('#testcase').find('input').attr('id');
            Value = $('#testcase').find('label[for=' + Core.App.EscapeSelector(Id) + ']').text();
            equal(Value, 'Elementlabeltext');
            $('#testcase').remove();
        });

        test('Core.App.Publish()/Subscribe()', function () {
            expect(4);
            var Counter = 0, Handle;

            // Subscribe to channel
            Handle = Core.App.Subscribe('UNITTEST1', function () {
                Counter++;
            })

            // publish channel
            Core.App.Publish('UNITTEST1');

            equal(Counter, 1);

            // unsubscribe from channel
            Core.App.Unsubscribe(Handle);

            // publish again
            Core.App.Publish('UNITTEST1');

            // counter may not have changed
            equal(Counter, 1);

            Handle = Core.App.Subscribe('UNITTEST2', function (Count) {
                Counter = Count;
            });

            // publish with arguments
            Core.App.Publish('UNITTEST2', [5]);

            equal(Counter, 5);

            Core.App.Unsubscribe(Handle);

            Core.App.Publish('UNITTEST2', [10]);

            equal(Counter, 5);
        });
    };

    return Namespace;
}(Core.App || {}));
