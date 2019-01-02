// --
// Copyright (C) 2001-2019 OTRS AG, https://otrs.com/\n";
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
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

        test('Core.App.EscapeSelector()', function () {
            expect(3);
            var Selector = 'ConfigItemClass::Config::Hardware::MapTypeAdd::Attribute',
                Id,
                Value;

            equal(Core.App.EscapeSelector(Selector), 'ConfigItemClass\\:\\:Config\\:\\:Hardware\\:\\:MapTypeAdd\\:\\:Attribute');
            equal(Core.App.EscapeSelector('ID-mit_anderen+Sonderzeichen'), 'ID-mit_anderen+Sonderzeichen');

            $('<div id="testcase"><label for="Testcase::Element">Elementlabeltext</label><input type="text" id="Testcase::Element" value="5"/></div>').appendTo('body');
            Id = $('#testcase').find('input').attr('id');
            Value = $('#testcase').find('label[for=' + Core.App.EscapeSelector(Id) + ']').text();
            equal(Value, 'Elementlabeltext');
            $('#testcase').remove();
        });
    };

    return Namespace;
}(Core.App || {}));
