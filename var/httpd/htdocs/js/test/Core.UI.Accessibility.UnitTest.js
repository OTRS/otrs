// --
// Core.UI.Accessibility.UnitTest.js - UnitTests
// Copyright (C) 2001-2012 OTRS AG, http://otrs.org/\n";
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};
Core.UI = Core.UI || {};

Core.UI.Accessibility = (function (Namespace) {
    Namespace.RunUnitTests = function(){
        module('Core.UI.Accessibility');
        test('Core.UI.Accessibility.Init()', function(){

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
            $TestDiv.append('<input type="text" class="Validate_Required" />');
            $TestDiv.append('<input type="text" class="Validate_DependingRequiredAND" />');
            $('body').append($TestDiv);

            /*
             * Run the tests
             */
            Core.UI.Accessibility.Init();

            equal($('.ARIARoleBanner')
                .attr('role'), 'banner', 'Role banner');
            equal($('.ARIARoleNavigation')
                .attr('role'), 'navigation', 'Role navigation');
            equal($('.ARIARoleSearch')
                .attr('role'), 'search', 'Role search');
            equal($('.ARIARoleMain')
                .attr('role'), 'main', 'Role main');
            equal($('.ARIARoleContentinfo')
                .attr('role'), 'contentinfo', 'Role contentinfo');
            equal($('.ARIAHasPopup')
                .attr('aria-haspopup'), 'true', 'HasPopup attribute');
            equal($('.Validate_Required')
                .attr('aria-required'), 'true', 'ARIA required attribute');
            equal($('.Validate_DependingRequiredAND')
                .attr('aria-required'), 'true', 'ARIA required attribute');


            /*
             * Cleanup div container and contents
             */
            $('#OTRS_UI_Accessibility_UnitTest').remove();
        });
    };

    return Namespace;
}(Core.UI.Accessibility || {}));
