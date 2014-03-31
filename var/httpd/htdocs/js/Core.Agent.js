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
    if (!Core.Debug.CheckDependency('Core.Agent', 'Core.UI.TreeSelection', 'Core.UI.TreeSelection')) {
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
            NavigationDuration = 500,
            InitialNavigationContainerHeight = $('#NavigationContainer').css('height'),
            NavigationResizeTimeout;

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

                    // Resize the container in order to display subitems
                    // Due to the needed overflow: hidden property of the
                    // container, they would be hidden otherwise
                    $('#NavigationContainer').css('height', '500px');
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
                    $('#NavigationContainer').css('height', InitialNavigationContainerHeight);
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
                    $('#NavigationContainer').css('height', '300px');

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

        TargetNS.ResizeNavigationBar();
        $(window).resize(function() {
            window.clearTimeout(NavigationResizeTimeout);
            NavigationResizeTimeout = window.setTimeout(function () {
                TargetNS.ResizeNavigationBar(true);
            }, 400);
        });
    }

    function NavigationBarShowSlideButton(Direction, Difference) {

        var Opposites = (Direction === 'Right') ? 'Left' : 'Right',
            NewPosition,
            HideButton = false,
            Delay = 150;

        if (!$('#NavigationContainer').find('.NavigationBarNavigate' + Direction).length) {

            $('#NavigationContainer')
                .append('<a href="#" class="Hidden NavigationBarNavigate' + Direction + '"><i class="fa fa-chevron-' + Direction.toLowerCase() + '"></i></a>')
                .find('.NavigationBarNavigate' + Direction)
                .delay(Delay)
                .fadeIn()
                .bind('click', function() {
                    if (Direction === 'Right') {

                        // calculate new scroll position
                        NewPosition = (parseInt($('#Navigation').css('left'), 10) * -1) + parseInt($('#NavigationContainer').width(), 10);
                        if (NewPosition >= (parseInt($('#Navigation').width(), 10) - parseInt($('#NavigationContainer').width(), 10))) {
                            NewPosition = parseInt($('#Navigation').width(), 10) - parseInt($('#NavigationContainer').width(), 10);
                            HideButton = true;
                        }

                        $('#Navigation')
                            .animate({
                                'left': NewPosition * -1
                            }, 'fast', function() {

                                if (HideButton) {
                                    $('#NavigationContainer')
                                        .find('.NavigationBarNavigate' + Direction)
                                        .fadeOut(Delay, function() {
                                            $(this).remove();
                                        });
                                }
                                NavigationBarShowSlideButton(Opposites, Difference);
                            });
                    }
                    else {

                        // calculate new scroll position
                        NewPosition = (parseInt($('#Navigation').css('left'), 10) * -1) - parseInt($('#NavigationContainer').width(), 10);
                        if (NewPosition <= 0) {
                            NewPosition = 0;
                            HideButton = true;
                        }

                        $('#Navigation')
                            .animate({
                                'left': NewPosition * -1
                            }, 'fast', function() {
                                if (HideButton) {
                                    $('#NavigationContainer')
                                        .find('.NavigationBarNavigate' + Direction)
                                        .fadeOut(Delay, function() {
                                            $(this).remove();
                                        });
                                }
                                NavigationBarShowSlideButton(Opposites, Difference);
                            });
                    }

                    return false;
                });
        }

    }

    function ToolBarIsAside() {

        // the following needs to be the case if the Toolbar is next to the
        // navigation bar instead of on top of it:
        // (1) 'left' is > than 'right' (RTL = opposite)
        //      Note: IE8 will show NaN instead of a number for 'auto'
        // (2) 'top' of #NavigationContainer is smaller than the height of the #ToolBar
        //      which would typically mean there is not enough space on top of #NavigationContainer
        //      to display the ToolBar.
        if ( ( !$('body').hasClass('RTL') &&
            ( parseInt($('#ToolBar').css('left'), 10) > parseInt($('#ToolBar').css('right'), 10) || isNaN(parseInt($('#ToolBar').css('left'), 10)) ) &&
            parseInt($('#NavigationContainer').css('top'), 10) < parseInt($('#ToolBar').height(), 10) ) ||
            ($('body').hasClass('RTL') &&
            ( parseInt($('#ToolBar').css('left'), 10) < parseInt($('#ToolBar').css('right'), 10) || isNaN(parseInt($('#ToolBar').css('right'), 10)) ) &&
            parseInt($('#NavigationContainer').css('top'), 10) < parseInt($('#ToolBar').height(), 10) ) ) {
            return true;
        }
        return false;
    }

    /**
     * @function
     * @return nothing
     *      This function checks if the navigation bar needs to be resized and equipped
     *      with slider navigation buttons. This can only happen if there are too many
     *      navigation icons.
     */
    TargetNS.ResizeNavigationBar = function (RealResizeEvent) {

        var NavigationBarWidth = 0,
            Difference,
            NewContainerWidth;

        // set the original width (from css) of #NavigationContainer to have it available later
        if (!$('#NavigationContainer').attr('data-original-width')) {
            $('#NavigationContainer').attr('data-original-width', parseInt(parseInt($('#NavigationContainer').css('width'), 10) / $('body').width() * 100, 10) + '%');
        }

        // on resizing we set the position back to left to be sure
        // to have everything displayed correctly
        $('#Navigation').css('left', '0px');
        $('.NavigationBarNavigateLeft').remove();

        // when we have the toolbar being displayed next to the navigation, we need to leave some space for it
        if ( ToolBarIsAside() && ( !$('#NavigationContainer').hasClass('IsResized') || RealResizeEvent ) ) {

            // reset back to original width to avoid making it smaller and smaller
            $('#NavigationContainer').css('width', $('#NavigationContainer').attr('data-original-width'));

            NewContainerWidth = $('#NavigationContainer').width() - $('#ToolBar').width() - parseInt($('#ToolBar').css('right'), 10);
            if ($('body').hasClass('RTL')) {
                NewContainerWidth = $('#NavigationContainer').width() - $('#ToolBar').width() - parseInt($('#ToolBar').css('left'), 10);
            }
            $('#NavigationContainer')
                .css('width', NewContainerWidth)
                .addClass('IsResized');
        }

        $('#Navigation > li').each(function() {
            NavigationBarWidth += parseInt($(this).outerWidth(true), 10);
        });
        $('#Navigation').css('width', (NavigationBarWidth + 2) + 'px');

        if (NavigationBarWidth > $('#NavigationContainer').outerWidth()) {
            NavigationBarShowSlideButton('Right', parseInt($('#NavigationContainer').outerWidth(true) - NavigationBarWidth, 10));
        }
        else if (NavigationBarWidth < $('#NavigationContainer').outerWidth(true)) {
            $('.NavigationBarNavigateRight, .NavigationBarNavigateLeft').remove();

            if ($('body').hasClass('RTL')) {
                $('#Navigation').css({
                    'left': 'auto',
                    'right': '0px'
                });
            }
            else {
                $('#Navigation').css({
                    'left': '0px',
                    'right': 'auto'
                });
            }
        }
    };


    /**
     * @function
     * @return nothing
     *      This function initializes the application and executes the needed functions
     */
    TargetNS.Init = function () {
        InitNavigation();
        Core.Exception.Init();
        Core.UI.Table.InitCSSPseudoClasses();
        Core.UI.InitWidgetActionToggle();
        Core.UI.InitMessageBoxClose();
        Core.Form.Validate.Init();
        Core.UI.Popup.Init();
        Core.UI.TreeSelection.InitTreeSelection();
        Core.UI.TreeSelection.InitDynamicFieldTreeViewRestore();
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
