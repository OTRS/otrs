// --
// Core.UI.Accessibility.js - accessibility functions
// Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
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
 * @exports TargetNS as Core.UI.Accessibility
 * @description
 *      This namespace contains all accessibility related functions
 */
Core.UI.Accessibility = (function (TargetNS) {
    /**
     * @function
     * @description
     *      This function initializes the W3C ARIA role attributes for the
     *      different parts of the page. It is not inside the HTML because
     *      these attributes are not part of the XHTML standard.
     * @return nothing
     */
    TargetNS.Init = function () {
        /* set W3C ARIA role attributes for screenreaders */
        $('.ARIARoleBanner')
            .attr('role', 'banner');
        $('.ARIARoleNavigation')
            .attr('role', 'navigation');
        $('.ARIARoleSearch')
            .attr('role', 'search');
        $('.ARIARoleContentinfo')
            .attr('role', 'contentinfo');
        $('.ARIARoleMain')
            .attr('role', 'main');
        $('.ARIAHasPopup')
            .attr('aria-haspopup', 'true');
        $('.Validate_Required, .Validate_DependingRequiredAND, .Validate_DependingRequiredOR')
            .attr('aria-required', 'true');

        TargetNS.AccessibleNavigation();
    };

    /**
     * @function
     * @description
     *      This function enables keyboard navigation for the
     *      css-based submenus in the main navigation.
     * @return nothing
     */
    TargetNS.AccessibleNavigation = function() {

        $('#Navigation > ul > li a').bind('focus', function() {
            $(this)
                .next('ul')
                .addClass('Expanded');
        });

        $('#Navigation > ul > li > ul').bind('mouseleave', function() {
            $(this).removeClass('Expanded');
        });

        $('#Navigation > ul > li > ul li a').bind('focus', function() {
            $(this)
                .closest('ul')
                .addClass('Expanded');
        });

        $('#Navigation > ul > li > ul li:last-child').prev('li').find('a').bind('focusout', function() {
            $(this)
                .closest('ul')
                .removeClass('Expanded');
        });
    };


    /**
     * @function
     * @description
     *      This function receives a text to be spoken to users
     *      using a screenreader. This is achieved by creating an
     *      element with the aria landmark role "alert" causing it
     *      to be read immediately.
     * @param {String} Text
     *      Text to be spoken to the user, may not contain markup.
     * @return nothing
     */
    TargetNS.AudibleAlert = function (Text) {
        var AlertMessageID = 'Accessibility_AlertMessage';

        // remove possibly pre-existing alert message
        $('#' + AlertMessageID).remove();

        // add new alert message
        $('body').append('<div role="alert" id="' + AlertMessageID + '" class="ARIAAlertMessage">' + Text + '</div>');

    };

    return TargetNS;
}(Core.UI.Accessibility || {}));