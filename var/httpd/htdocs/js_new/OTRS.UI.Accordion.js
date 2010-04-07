// --
// OTRS.UI.js - provides all UI functions
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.UI.Accordion.js,v 1.3 2010-04-07 14:12:42 mn Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};
OTRS.UI = OTRS.UI || {};

/**
 * @namespace
 * @description
 *      This namespace contains the Accordion code
 */
OTRS.UI.Accordion = (function (Namespace) {
    var AccordionAnimationRunning = false;

    /**
     * @function
     * @description
     *      This function checks, if an accordion animation is currently running
     * @return boolean
     */
    Namespace.AnimationIsRunning = function () {
        return AccordionAnimationRunning;
    }

    /**
     * @function
     * @description
     *      This function indicates that an accordion animation is now running
     * @return nothing
     */
    Namespace.StartAnimation = function () {
        AccordionAnimationRunning = true;
    }

    /**
     * @function
     * @description
     *      This function indicates that all accordion animations have stopped now
     * @return nothing
     */
    Namespace.StopAnimation = function () {
        AccordionAnimationRunning = false;
    }

    /**
     * @function
     * @description
     *      This function initializes the accordion effect on the specified list
     * @param {jQueryObject} $Element the parent list element (ul) for the accordion
     * @param {String} LinkSelector The selector for the link, on which an element is opened/closed
     * @param {String} ContentSelector The selector for the content, which is shown or hide
     * @return nothing
     */
    Namespace.Init = function ($Element, LinkSelector, ContentSelector) {
        // If no accordion element is found, stop
        if (typeof $Element === 'undefined' || $Element.length === 0)
            return false;

        var $LinkSelectors = $Element.find(LinkSelector);

        // Stop, if no link selector is found
        if ($LinkSelectors.length === 0) return false;

        // Bind click function to link selector elements
        $LinkSelectors.click(function() {
            var $ListElement = $(this).closest('li'),
                $AllListElements;

            // if clicked element is already active, do nothing
            if ($ListElement.hasClass('Active')) return false;

            // if another accordion animation is currently running, so nothing
            if (Namespace.AnimationIsRunning()) return false;

            Namespace.StartAnimation();

            $AllListElements = $ListElement.parent('ul').find('li');
            $ActiveListElement = $AllListElements.filter('.Active');

            $AllListElements.find('div.Content div').css('overflow', 'hidden');

            $ActiveListElement.find(ContentSelector).add($ListElement.find(ContentSelector)).slideToggle("slow", function() {
                $AllListElements.find('div.Content div').css('overflow', 'scroll');
                $(this).closest('li').toggleClass('Active');
                Namespace.StopAnimation();
            });

            // always return false, because otherwise the url in the clicked link would be loaded
            return false;
        });
    };

   return Namespace;
}(OTRS.UI.Accordion || {}));