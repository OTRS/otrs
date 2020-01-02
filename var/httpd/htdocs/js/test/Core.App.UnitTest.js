// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var Core = Core || {};
Core.App = Core.App || {};

Core.App = (function (Namespace) {
    Namespace.RunUnitTests = function(){
        QUnit.module('Core.App');

        QUnit.test('Core.App.GetSessionInformation()', function(Assert){
            Assert.expect(2);

            Core.Config.Set('SessionName', 'CSID');
            Core.Config.Set('SessionID', '1234');
            Core.Config.Set('CustomerPanelSessionName', 'CPanelSID');
            Core.Config.Set('ChallengeToken', 'C123');

            Assert.deepEqual(Core.App.GetSessionInformation(), {
                CSID: '1234',
                CPanelSID: '1234',
                ChallengeToken: 'C123'
            });

            Core.Config.Set('SessionIDCookie', true);
            Assert.deepEqual(Core.App.GetSessionInformation(), {
                ChallengeToken: 'C123'
            });
        });

        QUnit.test('Core.App.EscapeSelector()', function (Assert) {
            var Selector = 'ConfigItemClass::Config::Hardware::MapTypeAdd::Attribute###SubItem',
                Id,
                Value;

            Assert.expect(13);
            Assert.equal(Core.App.EscapeSelector(Selector), 'ConfigItemClass\\:\\:Config\\:\\:Hardware\\:\\:MapTypeAdd\\:\\:Attribute\\#\\#\\#SubItem');
            Assert.equal(Core.App.EscapeSelector('ID-mit_anderen_Sonderzeichen'), 'ID-mit_anderen_Sonderzeichen');
            Assert.equal(Core.App.EscapeSelector('#:.[]@!"$'), '\\#\\:\\.\\[\\]\\@\\!\\"\\$');
            Assert.equal(Core.App.EscapeSelector('%&<=>'), '\\%\\&\\<\\=\\>');
            Assert.equal(Core.App.EscapeSelector("'"), "\\'");
            Assert.equal(Core.App.EscapeSelector('()*+,?/;'), '\\(\\)\\*\\+\\,\\?\\/\\;');
            Assert.equal(Core.App.EscapeSelector('\\'), '\\\\');
            Assert.equal(Core.App.EscapeSelector('^'), '\\^');
            Assert.equal(Core.App.EscapeSelector('{}'), '\\{\\}');
            Assert.equal(Core.App.EscapeSelector('`'), '\\`');
            Assert.equal(Core.App.EscapeSelector('|'), '\\|');
            Assert.equal(Core.App.EscapeSelector('~'), '\\~');

            $('<div id="testcase"><label for="Testcase::Element###SubItem">Elementlabeltext</label><input type="text" id="Testcase::Element###SubItem" value="5"/></div>').appendTo('body');
            Id = $('#testcase').find('input').attr('id');
            Value = $('#testcase').find('label[for=' + Core.App.EscapeSelector(Id) + ']').text();
            Assert.equal(Value, 'Elementlabeltext');
            $('#testcase').remove();
        });

        QUnit.test('Core.App.Publish()/Subscribe()', function (Assert) {
            var Counter = 0, Handle;

            Assert.expect(4);
            // Subscribe to channel
            Handle = Core.App.Subscribe('UNITTEST1', function () {
                Counter++;
            });

            // publish channel
            Core.App.Publish('UNITTEST1');

            Assert.equal(Counter, 1);

            // unsubscribe from channel
            Core.App.Unsubscribe(Handle);

            // publish again
            Core.App.Publish('UNITTEST1');

            // counter may not have changed
            Assert.equal(Counter, 1);

            Handle = Core.App.Subscribe('UNITTEST2', function (Count) {
                Counter = Count;
            });

            // publish with arguments
            Core.App.Publish('UNITTEST2', [5]);

            Assert.equal(Counter, 5);

            Core.App.Unsubscribe(Handle);

            Core.App.Publish('UNITTEST2', [10]);

            Assert.equal(Counter, 5);
        });

        QUnit.test('Register and init namespaces', function (Assert) {
            Core.App.Teststring = "";

            Assert.expect(3);

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
            Assert.equal(Core.App.Teststring, "");

            // calling first block
            Core.Init.ExecuteInit('APP_INIT');
            Assert.equal(Core.App.Teststring, "123");

            // calling second block
            Core.Init.ExecuteInit('APP_LATE_INIT');
            Assert.equal(Core.App.Teststring, "12345");
        });

        QUnit.test('Core.App.HumanReadableDataSize()', function(Assert){
            var LanguageMetaData;

            Assert.expect(18);

            // Test case: DecimalSeparator is '.'.
            LanguageMetaData = {
                'DecimalSeparator': '.'
            };

            Core.Language.Load(LanguageMetaData, {});
            Assert.equal(Core.App.HumanReadableDataSize(13), '13 B');
            Assert.equal(Core.App.HumanReadableDataSize(1024), '1 KB');
            Assert.equal(Core.App.HumanReadableDataSize(2500), '2.4 KB');
            Assert.equal(Core.App.HumanReadableDataSize(46137344), '44 MB');
            Assert.equal(Core.App.HumanReadableDataSize(58626123), '55.9 MB');
            Assert.equal(Core.App.HumanReadableDataSize(34359738368), '32 GB');
            Assert.equal(Core.App.HumanReadableDataSize(64508675518), '60.1 GB');
            Assert.equal(Core.App.HumanReadableDataSize(238594023227392), '217 TB');
            Assert.equal(Core.App.HumanReadableDataSize(498870572100000), '453.7 TB');

            // Test case: DecimalSeparator is ','.
            LanguageMetaData = {
                'DecimalSeparator': ','
            };
            Core.Language.Load(LanguageMetaData, {});
            Assert.equal(Core.App.HumanReadableDataSize(13), '13 B');
            Assert.equal(Core.App.HumanReadableDataSize(1024), '1 KB');
            Assert.equal(Core.App.HumanReadableDataSize(2500), '2,4 KB');
            Assert.equal(Core.App.HumanReadableDataSize(46137344), '44 MB');
            Assert.equal(Core.App.HumanReadableDataSize(58626123), '55,9 MB');
            Assert.equal(Core.App.HumanReadableDataSize(34359738368), '32 GB');
            Assert.equal(Core.App.HumanReadableDataSize(64508675518), '60,1 GB');
            Assert.equal(Core.App.HumanReadableDataSize(238594023227392), '217 TB');
            Assert.equal(Core.App.HumanReadableDataSize(498870572100000), '453,7 TB');
        });
    };

    return Namespace;
}(Core.App || {}));
