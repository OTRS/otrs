// --
// OTRS.UI.Navigation.js - provides JS code for navigation
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.UI.Navigation.js,v 1.2 2010-03-29 09:58:13 mn Exp $
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
 *      This namespace contains the main navigation related JS code.
 */
OTRS.UI.Navigation = (function (Namespace) {
    /*
     * private variables for navigation
     */
   var NavigationTimer = {},
       NavigationDuration= 500;

    /**
     * @function
     * @return nothing
     *      This function initializes the main navigation
     */
    Namespace.Init = function () {
        function CreateSubnavCloseTimeout($Element, TimeoutFunction) {
            NavigationTimer[$Element.attr('id')] = setTimeout(TimeoutFunction, NavigationDuration);
        }

        function ClearSubnavCloseTimeout($Element) {
            if (typeof NavigationTimer[$Element.attr('id')] !== 'undefined') {
                clearTimeout(NavigationTimer[$Element.attr('id')]);
            }
        }

        $('#Navigation li.HasSubNavigation')
            .filter(function() {
                return $('ul', this).length;
            })
            .bind('mouseenter', function(){
                var $Element = $(this);
                if ($Element.parent().attr('id') !== 'Navigation') {
                    $Element.addClass('Active').attr('aria-expanded', true)
                        .siblings().removeClass('Active');
                }

                // If Timeout is set for this nav element, clear it
                ClearSubnavCloseTimeout($Element);
            })
            .bind('mouseleave', function(){
                var $Element = $(this);
                if (!$Element.hasClass('Active')) return;

                // Set Timeout for closing nav
                CreateSubnavCloseTimeout($Element, function() {
                    $Element.removeClass('Active').attr('aria-expanded', false);

                });
            })
            .bind('click', function(Event){
                var $Element = $(this),
                    $Target = $(Event.target);
                if ($Element.hasClass('Active')){
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
            .each(function(){
                var $Li = $(this);
                var ARIAControlsID = $Li.children('div').children('div.Shadow').children('ul').attr('id');

                if (ARIAControlsID && ARIAControlsID.length) {
                    $Li.attr('aria-controls', ARIAControlsID).attr('aria-expanded', false);
                }
            });
    };
    return Namespace;
}(OTRS.UI.Navigation || {}));