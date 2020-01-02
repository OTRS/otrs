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

Core.UI.Dialog = (function (Namespace) {
    Namespace.RunUnitTests = function(){

        QUnit.module('Core.UI.Dialog');

        QUnit.test('Core.UI.Dialog.ShowDialog()', function(Assert){

            // define variables
            var Tests = [
                {
                    // modal - true
                    Params: {
                        Modal: true,
                        Title: 'Test Title',
                        HTML: '<div style="padding: 15px; line-height: 150%; width: 200px;">Test1234457890</div>',
                        PositionTop: '10px',
                        PositionLeft: 'Center',
                        CloseOnEscape: true,
                        CloseOnClickOutside: true,
                        Buttons: [
                            {
                                Type: 'Close',
                                Label: Core.Language.Translate("Close this dialog"),
                                Function: function() {
                                    Core.UI.Dialog.CloseDialog($('.Dialog:visible'));
                                    return false;
                                }
                            }
                        ]
                    },
                    Expected: {
                        Modal: {
                            Value: true,
                            Message: 'Modal class exists'
                        }
                    }
                },
                {
                    // modal - false
                    Params: {
                        Modal: false,
                        Title: 'Test Title',
                        HTML: '<div style="padding: 15px; line-height: 150%; width: 550px;">Test1234457890</div>',
                        PositionTop: '100px',
                        PositionLeft: 'Center',
                        CloseOnEscape: false,
                        CloseOnClickOutside: false,
                        Buttons: [
                            {
                                Type: 'Close',
                                Label: Core.Language.Translate("Close this dialog"),
                                Function: function() {
                                    Core.UI.Dialog.CloseDialog($('.Dialog:visible'));
                                    return false;
                                }
                            }
                        ]
                    },
                    Expected: {
                        Modal: {
                            Value: false,
                            Message: 'Modal class does not exist'
                        }
                    }
                }
            ];

            Assert.expect(Tests.length * 2);

            // run tests
            $.each(Tests, function(Index, Value) {
                Core.UI.Dialog.ShowDialog(Value.Params);
                Assert.equal($('.Dialog').hasClass('Modal'), Value.Expected.Modal.Value, Value.Expected.Modal.Message);
                Core.UI.Dialog.CloseDialog($('.Dialog'));
                Assert.equal($('.Dialog').length, 0, 'Dialog is closed');
            });


        });
    };

    return Namespace;
}(Core.UI.Dialog || {}));
