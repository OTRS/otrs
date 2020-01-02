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

Core.UI.Accessibility = (function (Namespace) {
    Namespace.RunUnitTests = function(){
        QUnit.module('Core.UI.Accessibility');
        QUnit.test('Core.UI.Accessibility.Init()', function(Assert){

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

            Assert.expect(8);

            Assert.equal($('.ARIARoleBanner')
                .attr('role'), 'banner', 'Role banner');
            Assert.equal($('.ARIARoleNavigation')
                .attr('role'), 'navigation', 'Role navigation');
            Assert.equal($('.ARIARoleSearch')
                .attr('role'), 'search', 'Role search');
            Assert.equal($('.ARIARoleMain')
                .attr('role'), 'main', 'Role main');
            Assert.equal($('.ARIARoleContentinfo')
                .attr('role'), 'contentinfo', 'Role contentinfo');
            Assert.equal($('.ARIAHasPopup')
                .attr('aria-haspopup'), 'true', 'HasPopup attribute');
            Assert.equal($('.Validate_Required')
                .attr('aria-required'), 'true', 'ARIA required attribute');
            Assert.equal($('.Validate_DependingRequiredAND')
                .attr('aria-required'), 'true', 'ARIA required attribute');


            /*
             * Cleanup div container and contents
             */
            $('#OTRS_UI_Accessibility_UnitTest').remove();
        });
    };

    return Namespace;
}(Core.UI.Accessibility || {}));
