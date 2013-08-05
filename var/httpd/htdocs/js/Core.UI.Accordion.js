// --
// Core.UI.js - provides all UI functions
// Copyright (C) 2001-2013 OTRS AG, http://otrs.org/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.UI = Core.UI || {};

/**
 * @namespace
 * @exports TargetNS as Core.UI.Accordion
 * @description
 *      This namespace contains the Accordion code
 */
Core.UI.Accordion = (function (TargetNS) {
    var AccordionAnimationRunning = false;

    /**
     * @function
     * @description
     *      This function checks, if an accordion animation is currently running
     * @return boolean
     */
    TargetNS.AnimationIsRunning = function () {
        return AccordionAnimationRunning;
    };

    /**
     * @function
     * @description
     *      This function indicates that an accordion animation is now running
     * @return nothing
     */
    TargetNS.StartAnimation = function () {
        AccordionAnimationRunning = true;
    };

    /**
     * @function
     * @description
     *      This function indicates that all accordion animations have stopped now
     * @return nothing
     */
    TargetNS.StopAnimation = function () {
        AccordionAnimationRunning = false;
    };

    TargetNS.ContentSelector = undefined;

    /**
     * @function
     * @description
     *      This function initializes the accordion effect on the specified list
     * @param {jQueryObject} $Element the parent list element (ul) for the accordion
     * @param {String} LinkSelector The selector for the link, on which an element is opened/closed
     * @param {String} ContentSelector The selector for the content, which is shown or hidden
     * @return nothing
     */
    TargetNS.Init = function ($Element, LinkSelector, ContentSelector) {
        // If no accordion element is found, stop
        if (!isJQueryObject($Element) || $Element.length === 0) {
            return false;
        }

        var $LinkSelectors = $Element.find(LinkSelector);

        // Stop, if no link selector is found
        if ($LinkSelectors.length === 0) {
            return false;
        }

        TargetNS.ContentSelector = ContentSelector;

        // Bind click function to link selector elements
        $LinkSelectors.click(function () {
            var $ListElement = $(this).closest('li');

            TargetNS.OpenElement($ListElement, true);

            // always return false, because otherwise the url in the clicked link would be loaded
            return false;
        });
    };

    TargetNS.OpenElement = function ($ListElement, WithAnimation) {
        var $AllListElements,
            $ActiveListElement;

        // if clicked element is already active, do nothing
        if ($ListElement.hasClass('Active')) {
            return false;
        }

        // if another accordion animation is currently running, do nothing
        if (TargetNS.AnimationIsRunning()) {
            return false;
        }

        $AllListElements = $ListElement.parent('ul').find('li');
        $ActiveListElement = $AllListElements.filter('.Active');

        if (WithAnimation) {
            TargetNS.StartAnimation();

            $AllListElements.find('div.Content div').css('overflow', 'hidden');

            $AllListElements.find('div.Content div').each(function () {
                $(this).data('overflow', $(this).css('overflow'));
                $(this).css('overflow', 'hidden');
            });

            $ActiveListElement.find(TargetNS.ContentSelector).add($ListElement.find(TargetNS.ContentSelector)).slideToggle("slow", function () {
                $AllListElements.find('div.Content div').each(function () {
                    $(this).css('overflow', $(this).data('overflow'));
                });
                $ListElement.addClass('Active');
                $ActiveListElement.removeClass('Active');
                TargetNS.StopAnimation();
            });
        }
        else {
            $ActiveListElement.find(TargetNS.ContentSelector).add($ListElement.find(TargetNS.ContentSelector)).toggle();
            $ListElement.addClass('Active');
            $ActiveListElement.removeClass('Active');
        }
    };

    return TargetNS;
}(Core.UI.Accordion || {}));