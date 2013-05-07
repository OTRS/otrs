// --
// Core.Agent.js - provides the application functions
// Copyright (C) 2001-2013 OTRS AG, http://otrs.org/
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
    if (!Core.Debug.CheckDependency('Core.Agent', 'Core.Form', 'Core.Form')) {
        return;
    }
    if (!Core.Debug.CheckDependency('Core.Agent', 'Core.Form.Validate', 'Core.Form.Validate')) {
        return;
    }
    if (!Core.Debug.CheckDependency('Core.Agent', 'Core.UI.Accessibility', 'Core.UI.Accessibility')) {
        return;
    }
    if (!Core.Debug.CheckDependency('Core.Agent', 'Core.AJAX', 'Core.AJAX')) {
        return;
    }

    /**
     * @function
     * @private
     * @return nothing
     *      This function initializes the main navigation
     */
    function InitNavigation() {
        /*
         * private variables for navigation
         */
        var NavigationTimer = {},
            NavigationDuration = 500;

        /**
         * @function
         * @private
         * @return nothing
         *      This function set Timeout for closing nav
         */
        function CreateSubnavCloseTimeout($Element, TimeoutFunction) {
            NavigationTimer[$Element.attr('id')] = setTimeout(TimeoutFunction, NavigationDuration);
        }

        /**
         * @function
         * @private
         * @return nothing
         *      This function clear Timeout for nav element
         */
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
                // special treatment for the first menu level: by default this opens submenus only via click,
                //  but the config setting "OpenMainMenuOnHover" also activates opening on hover for it.
                if ($Element.parent().attr('id') !== 'Navigation' || Core.Config.Get('OpenMainMenuOnHover')) {
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
                if ($Target.closest('li').find('ul').length) {
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
                    ARIAControlsID = $Li.children('ul').attr('id');

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
        Core.Exception.Init();
        Core.UI.Table.InitCSSPseudoClasses();
        Core.UI.Table.InitFixedHeader();
        Core.UI.InitWidgetActionToggle();
        Core.UI.InitMessageBoxClose();
        Core.Form.Validate.Init();
        Core.UI.Popup.Init();
        // late execution of accessibility code
        Core.UI.Accessibility.Init();
    };

    /**
     * @function
     * @description
     *      This function set and session and preferences setting at runtime
     * @param {jQueryObject} Key the name of the setting
     * @param {jQueryObject} Value the value of the setting
     * @return nothing
     */
    TargetNS.PreferencesUpdate = function (Key, Value) {
        var URL = Core.Config.Get('Baselink'),
            Data = {
                Action: 'AgentPreferences',
                Subaction: 'UpdateAJAX',
                Key: Key,
                Value: Value
            };
        // We need no callback here, but the called function needs one, so we send an "empty" function
        Core.AJAX.FunctionCall(URL, Data, $.noop);
        return true;
    };

    /**
     * @function
     * @return nothing
     *      This function reload the page if the session is over and a login form is showed in some part of the current screen.
     */
    TargetNS.CheckSessionExpiredAndReload = function () {
        if ($('#LoginBox').length) {
            location.reload();
        }
    };

    return TargetNS;
}(Core.Agent || {}));
