// --
// Core.Agent.js - provides the application functions
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.Agent.js,v 1.4 2010-07-19 12:03:34 mn Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};

/**
 * @namespace
 * @exports TargetNS as Core.Agent
 * @description
 *      This namespace contains the config options and functions.
 */
Core.Agent = (function (TargetNS) {
    if (!Core.Debug.CheckDependency('Core.Agent', 'Core.UI', 'Core.UI')) {
        return;
    }
    if (!Core.Debug.CheckDependency('Core.Agent', 'Core.UI.IE7Fixes', 'Core.UI.IE7Fixes')) {
        return;
    }
    if (!Core.Debug.CheckDependency('Core.Agent', 'Core.Form', 'Core.Form')) {
        return;
    }
    if (!Core.Debug.CheckDependency('Core.Agent', 'Core.Form.Validate', 'Core.Form.Validate')) {
        return;
    }
    if (!Core.Debug.CheckDependency('Core.Agent', 'Core.UI.Accessibility', 'Core.UI.Accessibility')) {
        return;
    }

    /**
     * @function
     * @return nothing
     *      This function initializes the main navigation
     */
    function InitNavigation() {
        /*
         * private variables for navigation
         */
        var NavigationTimer = {},
            NavigationDuration = 500;

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

        /*
         * Register event for global search
         *
         */
        $('#GlobalSearchNav').bind('click', function (Event) {
            Core.Agent.Search.OpenSearchDialog();
            return false;
        });
    }
    /**
     * @function
     * @return nothing
     *      This function initializes the application and executes the needed functions
     */
    TargetNS.Init = function () {
        InitNavigation();
        Core.UI.Table.InitCSSPseudoClasses();
        Core.UI.InitWidgetActionToggle();
        Core.UI.InitMessageBoxClose();
        Core.UI.ProcessTagAttributeClasses();
        Core.Form.Init();
        Core.Form.Validate.Init();
        // late execution of accessibility code
        Core.UI.Accessibility.Init();
        // init IE7 compat code (will only run on IE7)
        Core.UI.IE7Fixes.InitIE7InputFocus('Focus');
        Core.UI.IE7Fixes.InitIE7InputReadonly('Readonly');

        // do the popup stuff
        $(window).bind('beforeunload.Popup', function () {
            return Core.UI.Popup.CheckPopupsOnUnload();
        });
        $(window).bind('unload.Popup', function () {
            Core.UI.Popup.ClosePopupsOnUnload();
        });
        Core.UI.Popup.RegisterPopupEvent();

        // if this window is a popup itself, register another function
        if (window.opener !== null) {
            Core.UI.Popup.InitRegisterPopupAtParentWindow();
            $('.CancelClosePopup').bind('click', function () {
                window.close();
            });
            $('.UndoClosePopup').bind('click', function () {
                var RedirectURL = $(this).attr('href');
                window.opener.Core.UI.Popup.FirePopupEvent('URL', { URL: RedirectURL });
                window.close();
            });
        }
    };

    return TargetNS;
}(Core.Agent || {}));
