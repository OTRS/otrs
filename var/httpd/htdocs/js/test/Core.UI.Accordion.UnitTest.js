// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var Core = Core || {};
Core.Form = Core.Form || {};

Core.UI.Accordion = (function (Namespace) {
    Namespace.RunUnitTests = function(){
        QUnit.module('Core.UI.Accordion');
        QUnit.test('Core.UI.Accordion.Init()', function(Assert){

            /*
             * Create a form container for the tests
             */
            var $TestForm = $('<form id="TestForm"></form>'),
                Done = Assert.async(2);

            $TestForm.append('<ul id="AccordionTest"><li class="AccordionElement Active"><h2><a href="#" class="AsBlock">AccordionOne</a></h2><div class="Content"><input type="text" id="ObjectOne"/></div></li><li class="AccordionElement "><h2><a href="#" class="AsBlock">AccordionTwo</a></h2></li></ul>');
            $('body').append($TestForm);

            /*
             * Run the tests
             */
            Assert.expect(12);

            Core.UI.Accordion.Init($('ul#AccordionTest'), 'li.AccordionElement h2 a', 'div.Content');

            // Test initial class Active and style on Accordian elements
            Assert.equal($('ul#AccordionTest').find('li:eq(0)').hasClass('Active'), true, 'First Accordion element class Active on load is found');
            Assert.equal($('ul#AccordionTest').find('li:eq(1)').hasClass('Active'), false, 'Second Accordion element class Active on load is not found');
            Assert.notOk($('.Content').attr('style'), 'Accordion content has no style attribute on load');

            // Click on first Accordion, nothing should change
            $('ul#AccordionTest').find('li:eq(0)').find('h2 a').click();
            Assert.equal($('ul#AccordionTest').find('li:eq(0)').hasClass('Active'), true, 'First Accordion element class Active on first Accordion click is found');
            Assert.equal($('ul#AccordionTest').find('li:eq(1)').hasClass('Active'), false, 'Second Accordion element class Active on first Accordion click is not found');
            Assert.notOk($('.Content').attr('style'), 'First Accordion content has no style attribute on first Accordion click');

            // Click on second Accordion, first Accordion will hide content
            $('ul#AccordionTest').find('li:eq(1)').find('h2 a').click();

            // Wait for Accordion to finish with animation
            setTimeout(function() {
                Assert.equal($('ul#AccordionTest').find('li:eq(0)').hasClass('Active'), false, 'First Accordion element class Active on second Accordion click is not found');
                Assert.equal($('ul#AccordionTest').find('li:eq(1)').hasClass('Active'), true, 'Second Accordion element class Active on second Accordion click is found');
                Assert.ok($('.Content').not('visible'), 'First Accordion content is not visible on second Accordion click');

                // Click on first Accordion, content will be visible again
                $('ul#AccordionTest').find('li:eq(0)').find('h2 a').click();
                setTimeout(function() {
                    Assert.equal($('ul#AccordionTest').find('li:eq(0)').hasClass('Active'), true, 'First Accordion element class Active on first Accordion click is found');
                    Assert.equal($('ul#AccordionTest').find('li:eq(1)').hasClass('Active'), false, 'Second Accordion element class Active on first Accordion click is not found');
                    Assert.ok($('.Content').is(':visible'), 'First Accordion content is visible on first Accordion click');

                    /*
                     * Cleanup div container and contents
                     */
                    $('#TestForm').remove();

                    Done();
                }, 1000);

                Done();
            }, 1000);
        });

    };

    return Namespace;
}(Core.UI.Accordion || {}));
