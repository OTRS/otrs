// --
// OTRS.UI.Accessibility.UnitTest.js - UnitTests
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.UI.Accessibility.UnitTest.js,v 1.2 2010-03-29 09:58:14 mn Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};
OTRS.UI = OTRS.UI || {};
OTRS.UI.Accessibility = OTRS.UI.Accessibility || {};

OTRS.UI.Accessibility = (function (Namespace) {
    Namespace.RunUnitTests = function(){
        module('OTRS.UI.Accessibility');
        test('OTRS.UI.Accessibility.Init()', function(){

            expect(8);

            /*
             * Create a div containter for the tests
             */
            var $TestDiv = $('<div id="OTRS_UI_Accessibility_UnitTest"></div>');
            $TestDiv.append('<div class="ARIARoleBanner"></div>');
            $TestDiv.append('<div class="ARIARoleNavigation"></div>');
            $TestDiv.append('<div class="ARIARoleSearch"></div>');
            $TestDiv.append('<div class="ARIARoleMain"></div>');
            $TestDiv.append('<div class="ARIARoleContentinfo"></div>');
            $TestDiv.append('<div class="ARIAHasPopup"></div>');
            $TestDiv.append('<input type="text" class="OTRS_Validate_Required" />');
            $TestDiv.append('<input type="text" class="OTRS_Validate_DependingRequired" />');
            $('body').append($TestDiv);

            /*
             * Run the tests
             */
            OTRS.UI.Accessibility.Init();

            equals($('.ARIARoleBanner')
                .attr('role'), 'banner', 'Role banner');
            equals($('.ARIARoleNavigation')
                .attr('role'), 'navigation', 'Role navigation');
            equals($('.ARIARoleSearch')
                .attr('role'), 'search', 'Role search');
            equals($('.ARIARoleMain')
                .attr('role'), 'main', 'Role main');
            equals($('.ARIARoleContentinfo')
                .attr('role'), 'contentinfo', 'Role contentinfo');
            equals($('.ARIAHasPopup')
                .attr('aria-haspopup'), 'true', 'HasPopup attribute');
            equals($('.OTRS_Validate_Required')
                .attr('aria-required'), 'true', 'ARIA required attribute');
            equals($('.OTRS_Validate_DependingRequired')
                .attr('aria-required'), 'true', 'ARIA required attribute');


            /*
             * Cleanup div container and contents
             */
            $('#OTRS_UI_Accessibility_UnitTest').remove();
        });
    };

    return Namespace;
}(OTRS.UI.Accessibility || {}));