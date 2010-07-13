// --
// Core.UI.Accessibility.UnitTest.js - UnitTests
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.Form.UnitTest.js,v 1.1 2010-07-13 09:46:45 mg Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};

Core.Form = (function (Namespace) {
    Namespace.RunUnitTests = function(){
        module('Core.Form');
        test('Core.Form.Init()', function(){

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
            Core.Form.Init();

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
}(Core.Form || {}));