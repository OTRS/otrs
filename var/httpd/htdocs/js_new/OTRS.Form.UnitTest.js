// --
// OTRS.UI.Accessibility.UnitTest.js - UnitTests
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.Form.UnitTest.js,v 1.1 2010-05-17 14:04:54 mg Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};

OTRS.Form = (function (Namespace) {
    Namespace.RunUnitTests = function(){
        module('OTRS.Form');
        test('OTRS.Form.Init()', function(){

            expect(2);

            /*
             * Create a div containter for the tests
             */
            var $TestDiv = $('<div id="OTRS_Form_UnitTest"></div>');
            $TestDiv.append('<textarea class="Wrap_physical"></textarea>');
            $TestDiv.append('<textarea class="Wrap_hard"></textarea>');
            $('body').append($TestDiv);

            /*
             * Run the tests
             */
            OTRS.Form.Init();

            equals($('.Wrap_physical')
                .attr('wrap'), 'physical', 'wrap="physical"');
            equals($('.Wrap_hard')
                .attr('wrap'), 'hard', 'wrap="hard"');

            /*
             * Cleanup div container and contents
             */
            $('#OTRS_Form_UnitTest').remove();
        });
    };

    return Namespace;
}(OTRS.Form || {}));