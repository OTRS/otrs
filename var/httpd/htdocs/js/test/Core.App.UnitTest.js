// --
// Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
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
            var Selector = 'ConfigItemClass::Config::Hardware::MapTypeAdd::Attribute###SubItem',
                Id,
                Value;

            expect(13);
            equal(Core.App.EscapeSelector(Selector), 'ConfigItemClass\\:\\:Config\\:\\:Hardware\\:\\:MapTypeAdd\\:\\:Attribute\\#\\#\\#SubItem');
            equal(Core.App.EscapeSelector('ID-mit_anderen_Sonderzeichen'), 'ID-mit_anderen_Sonderzeichen');
            equal(Core.App.EscapeSelector('#:.\[\]@!"$'), '\\#\\:\\.\\[\\]\\@\\!\\"\\$');
            equal(Core.App.EscapeSelector('%&<=>'), '\\%\\&\\<\\=\\>');
            equal(Core.App.EscapeSelector("'"), "\\'");
            equal(Core.App.EscapeSelector('()*+,?/;'), '\\(\\)\\*\\+\\,\\?\\/\\;');
            equal(Core.App.EscapeSelector('\\'), '\\\\');
            equal(Core.App.EscapeSelector('^'), '\\^');
            equal(Core.App.EscapeSelector('{}'), '\\{\\}');
            equal(Core.App.EscapeSelector('`'), '\\`');
            equal(Core.App.EscapeSelector('|'), '\\|');
            equal(Core.App.EscapeSelector('~'), '\\~');

            $('<div id="testcase"><label for="Testcase::Element###SubItem">Elementlabeltext</label><input type="text" id="Testcase::Element###SubItem" value="5"/></div>').appendTo('body');
            Id = $('#testcase').find('input').attr('id');
            Value = $('#testcase').find('label[for=' + Core.App.EscapeSelector(Id) + ']').text();
            equal(Value, 'Elementlabeltext');
            $('#testcase').remove();
        });

        test('Core.App.Publish()/Subscribe()', function () {
            var Counter = 0, Handle;

            expect(4);
            // Subscribe to channel
            Handle = Core.App.Subscribe('UNITTEST1', function () {
                Counter++;
            });

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

        test('Register and init namespaces', function () {
            Core.App.Teststring = "";

            expect(3);

            Core.UnitTest1 = (function (TargetNS) {
                TargetNS.Init = function () {
                    Core.App.Teststring += "1";
                };
                Core.Init.RegisterNamespace(TargetNS, 'APP_INIT');
                return TargetNS;
            }(Core.UnitTest1 || {}));

            // testing sorting
            Core.UnitTest2 = (function (TargetNS) {
                TargetNS.Init = function () {
                    Core.App.Teststring += "2";
                };
                Core.Init.RegisterNamespace(TargetNS, 'APP_INIT');
                return TargetNS;
            }(Core.UnitTest2 || {}));

            Core.UnitTest3 = (function (TargetNS) {
                TargetNS.Init = function () {
                    Core.App.Teststring += "3";
                };
                Core.Init.RegisterNamespace(TargetNS, 'APP_INIT');
                return TargetNS;
            }(Core.UnitTest3 || {}));

            Core.UnitTest4 = (function (TargetNS) {
                TargetNS.Init = function () {
                    Core.App.Teststring += "4";
                };
                Core.Init.RegisterNamespace(TargetNS, 'APP_LATE_INIT');
                return TargetNS;
            }(Core.UnitTest4 || {}));

            Core.UnitTest5 = (function (TargetNS) {
                TargetNS.Init = function () {
                    Core.App.Teststring += "5";
                };
                Core.Init.RegisterNamespace(TargetNS, 'APP_LATE_INIT');
                return TargetNS;
            }(Core.UnitTest5 || {}));

            // empty call does nothing
            Core.Init.ExecuteInit();
            equal(Core.App.Teststring, "");

            // calling first block
            Core.Init.ExecuteInit('APP_INIT');
            equal(Core.App.Teststring, "123");

            // calling second block
            Core.Init.ExecuteInit('APP_LATE_INIT');
            equal(Core.App.Teststring, "12345");
        });
    };

    return Namespace;
}(Core.App || {}));
