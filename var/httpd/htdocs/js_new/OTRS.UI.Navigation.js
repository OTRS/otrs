// --
// OTRS.UI.Navigation.js - provides JS code for navigation
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.UI.Navigation.js,v 1.5 2010-04-19 16:36:29 mg Exp $
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
 * @exports TargetNS as OTRS.UI.Navigation
 * @description
 *      This namespace contains the main navigation related JS code.
 */
OTRS.UI.Navigation = (function (TargetNS) {
    /*
     * private variables for navigation
     */
    var NavigationTimer = {},
        NavigationDuration = 500;

    /**
     * @function
     * @return nothing
     *      This function initializes the main navigation
     */
    TargetNS.Init = function () {
        function CreateSubnavCloseTimeout($Element, TimeoutFunction) {
            NavigationTimer[$Element.attr('id')] = setTimeout(TimeoutFunction, NavigationDuration);
        }

        function ClearSubnavCloseTimeout($Element) {
            if (typeof NavigationTimer[$Element.attr('id')] !== 'undefined') {
                clearTimeout(NavigationTimer[$Element.attr('id')]);
            }
        }

        $('#Navigation > li')
            .filter(function () {
                return $('ul', this).length;
            })
            .bind('mouseenter', function () {
                var $Element = $(this);
                if ($Element.parent().attr('id') !== 'Navigation') {
                    $Element.addClass('Active').attr('aria-expanded', true)
                        .siblings().removeClass('Active');
                }

                // If Timeout is set for this nav element, clear it
                ClearSubnavCloseTimeout($Element);
            })
            .bind('mouseleave', function () {
                var $Element = $(this);
                if (!$Element.hasClass('Active')) {
                    return;
                }

                // Set Timeout for closing nav
                CreateSubnavCloseTimeout($Element, function () {
                    $Element.removeClass('Active').attr('aria-expanded', false);

                });
            })
            .bind('click', function (Event) {
                var $Element = $(this),
                    $Target = $(Event.target);
                if ($Element.hasClass('Active')) {
                    $Element.removeClass('Active').attr('aria-expanded', false);
                }
                else {
                    $Element.addClass('Active').attr('aria-expanded', true)
                        .siblings().removeClass('Active');
                    // If Timeout is set for this nav element, clear it
                    ClearSubnavCloseTimeout($Element);
                }
                // If element has subnavigation, prevent the link
                if ($Target.closest('li').find('div').length) {
                    Event.preventDefault();
                    return false;
                }
            })
            /*
             * Accessibility support code
             *      Initialize each <li> with subnavigation with aria-controls and
             *      aria expanded to indicate what will be opened by that element.
             */
            .each(function () {
                var $Li = $(this),
                    ARIAControlsID = $Li.children('div').children('div.Shadow').children('ul').attr('id');

                if (ARIAControlsID && ARIAControlsID.length) {
                    $Li.attr('aria-controls', ARIAControlsID).attr('aria-expanded', false);
                }
            });

        /*
         * The navigation elements don't have a class "ARIAHasPopup" which automatically generates the aria-haspopup attribute,
         * because of some code limitation while generating the nav data.
         * Therefore, the aria-haspopup attribute for the navigation is generated manually.
         */
        $('#Navigation li').filter(function () {
            return $('ul', this).length;
        }).attr('aria-haspopup', 'true');
    };
    return TargetNS;
}(OTRS.UI.Navigation || {}));