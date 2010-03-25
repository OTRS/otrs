// --
// OTRS.UI.Navigation.js - provides JS code for navigation
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.UI.Navigation.js,v 1.1 2010-03-25 15:04:37 mg Exp $
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
OTRS.UI.Navigation = (function () {


    /*
     * private variables for navigation
     */
   var NavigationTimer = {},
       NavigationDuration= 500;

   return {

        /**
         * @function
         * @return nothing
         *      This function initializes the main navigation
         */
        Init: function () {
            function CreateSubnavCloseTimeout($Element, TimeoutFunction) {
                NavigationTimer[$Element.attr('id')] = setTimeout(TimeoutFunction, NavigationDuration);
            }

            function ClearSubnavCloseTimeout($Element) {
                if (typeof NavigationTimer[$Element.attr('id')] !== 'undefined') {
                    clearTimeout(NavigationTimer[$Element.attr('id')]);
                }
            }

            $('#Navigation li.HasSubNavigation')
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
                    var $Element = $(this);
                    if ($Element.hasClass('Active')){
                        $Element.removeClass('Active').attr('aria-expanded', false);
                    }
                    else {
                        $Element.addClass('Active').attr('aria-expanded', true)
                            .siblings().removeClass('Active');
                        // If Timeout is set for this nav element, clear it
                        ClearSubnavCloseTimeout($Element);
                    }
                    Event.preventDefault();
                    return false;
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
        }
    };
}());