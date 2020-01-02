// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var Core = Core || {};

/**
 * @namespace Core
 * @author OTRS AG
 */

/**
 * @namespace Core.Agent
 * @memberof Core
 * @author OTRS AG
 * @description
 *      This namespace contains the config options and functions.
 */
Core.Agent = (function (TargetNS) {
    if (!Core.Debug.CheckDependency('Core.Agent', 'Core.UI', 'Core.UI')) {
        return false;
    }
    if (!Core.Debug.CheckDependency('Core.Agent', 'Core.Form', 'Core.Form')) {
        return false;
    }
    if (!Core.Debug.CheckDependency('Core.Agent', 'Core.Form.Validate', 'Core.Form.Validate')) {
        return false;
    }
    if (!Core.Debug.CheckDependency('Core.Agent', 'Core.UI.Accessibility', 'Core.UI.Accessibility')) {
        return false;
    }
    if (!Core.Debug.CheckDependency('Core.Agent', 'Core.UI.InputFields', 'Core.UI.InputFields')) {
        return false;
    }
    if (!Core.Debug.CheckDependency('Core.Agent', 'Core.UI.TreeSelection', 'Core.UI.TreeSelection')) {
        return false;
    }
    if (!Core.Debug.CheckDependency('Core.Agent', 'Core.AJAX', 'Core.AJAX')) {
        return false;
    }

    /**
     * @private
     * @name InitAvatarFlyout
     * @memberof Core.Agent
     * @function
     * @description
     *      This function initializes the flyout when the avatar on the top left is clicked.
     */
    function InitAvatarFlyout() {

        var Timeout,
            TimeoutDuration = 700;

        // init the avatar toggle
        $('#ToolBar .UserAvatar > a').off('click.UserAvatar').on('click.UserAvatar', function() {
            $(this).next('div').fadeToggle('fast');
            $(this).toggleClass('Active');
            return false;
        });

        $('#ToolBar .UserAvatar > div').off('mouseenter.UserAvatar').on('mouseenter.UserAvatar', function() {
            if (Timeout && $(this).css('opacity') == 1) {
                clearTimeout(Timeout);
            }
        });

        $('#ToolBar .UserAvatar > div').off('mouseleave.UserAvatar').on('mouseleave.UserAvatar', function() {
            Timeout = setTimeout(function() {
                $('#ToolBar .UserAvatar > div').fadeOut('fast');
                $('#ToolBar .UserAvatar > div').prev('a').removeClass('Active');
            }, TimeoutDuration);
        });
    }

    /**
     * @private
     * @name InitNavigation
     * @memberof Core.Agent
     * @function
     * @description
     *      This function initializes the main navigation.
     */
    function InitNavigation() {
        /*
         * private variables for navigation
         */
        var NavigationTimer = {},
            NavigationDuration = 500,
            NavigationHoverTimer = {},
            NavigationHoverDuration = 350,
            InitialNavigationContainerHeight = $('#NavigationContainer').css('height'),
            NavigationResizeTimeout;

        /**
         * @private
         * @name CreateSubnavCloseTimeout
         * @memberof Core.Agent.InitNavigation
         * @function
         * @param {jQueryObject} $Element
         * @param {Function} TimeoutFunction
         * @description
         *      This function sets the Timeout for closing a subnav.
         */
        function CreateSubnavCloseTimeout($Element, TimeoutFunction) {
            NavigationTimer[$Element.attr('id')] = setTimeout(TimeoutFunction, NavigationDuration);
        }

        /**
         * @private
         * @name ClearSubnavCloseTimeout
         * @memberof Core.Agent.InitNavigation
         * @function
         * @param {jQueryObject} $Element
         * @description
         *      This function clears the Timeout for a subnav.
         */
        function ClearSubnavCloseTimeout($Element) {
            if (typeof NavigationTimer[$Element.attr('id')] !== 'undefined') {
                clearTimeout(NavigationTimer[$Element.attr('id')]);
            }
        }

        /**
         * @private
         * @name CreateSubnavOpenTimeout
         * @memberof Core.Agent.InitNavigation
         * @function
         * @param {jQueryObject} $Element
         * @param {Function} TimeoutFunction
         * @description
         *      This function sets the Timeout for closing a subnav.
         */
        function CreateSubnavOpenTimeout($Element, TimeoutFunction) {
            NavigationHoverTimer[$Element.attr('id')] = setTimeout(TimeoutFunction, NavigationHoverDuration);
        }

        /**
         * @private
         * @name ClearSubnavOpenTimeout
         * @memberof Core.Agent.InitNavigation
         * @function
         * @param {jQueryObject} $Element
         * @description
         *      This function clears the Timeout for a subnav.
         */
        function ClearSubnavOpenTimeout($Element) {
            if (typeof NavigationHoverTimer[$Element.attr('id')] !== 'undefined') {
                clearTimeout(NavigationHoverTimer[$Element.attr('id')]);
            }
        }

        /**
         * @private
         * @name SetNavContainerHeight
         * @memberof Core.Agent.InitNavigation
         * @function
         * @param {jQueryObject} $ParentElement
         * @description
         *      This function sets the nav container height according to the required height of the currently expanded sub menu
         *      Due to the needed overflow: hidden property of the container, they would be hidden otherwise
         */
        function SetNavContainerHeight($ParentElement) {
            if ($ParentElement.find('ul').length) {
                $('#NavigationContainer').css('height', parseInt(InitialNavigationContainerHeight, 10) + parseInt($ParentElement.find('ul').outerHeight(), 10));
            }
        }

        TargetNS.ReorderNavigationItems(Core.Config.Get('NavbarOrderItems'));

        $('#Navigation > li')
            .addClass('CanDrag')
            .filter(function () {
                return $('ul', this).length;
            })
            .on('mouseenter', function () {
                var $Element = $(this);

                // clear close timeout on mouseenter, even if OpenMainMenuOnHover is not enabled
                // this makes sure, that leaving the subnav for a short time and coming back
                // will leave the subnav opened
                ClearSubnavCloseTimeout($Element);

                // special treatment for the first menu level: by default this opens submenus only via click,
                //  but the config setting "OpenMainMenuOnHover" also activates opening on hover for it.
                if ($('body').hasClass('Visible-ScreenXL') && !Core.App.Responsive.IsTouchDevice() && ($Element.parent().attr('id') !== 'Navigation' || parseInt(Core.Config.Get('OpenMainMenuOnHover'), 10))) {

                    // Set Timeout for opening nav
                    CreateSubnavOpenTimeout($Element, function () {
                        $Element.addClass('Active').attr('aria-expanded', true)
                            .siblings().removeClass('Active');

                        // resize the nav container
                        SetNavContainerHeight($Element);

                        // If Timeout is set for this nav element, clear it
                        ClearSubnavCloseTimeout($Element);
                    });
                }
            })
            .on('mouseleave', function () {

                var $Element = $(this);

                if ($('body').hasClass('Visible-ScreenXL')) {

                    // Clear Timeout for opening items on hover. Submenus should only be opened intentional,
                    // so if the user doesn't hover long enough, he probably doesn't want the submenu to be opened.
                    // If Timeout is set for this nav element, clear it
                    ClearSubnavOpenTimeout($Element);

                    if (!$Element.hasClass('Active')) {
                        return false;
                    }

                    // Set Timeout for closing nav
                    CreateSubnavCloseTimeout($Element, function () {
                        $Element.removeClass('Active').attr('aria-expanded', false);

                        // Remove z-index=5500.
                        $Element.parent().parent().removeClass('NavContainerZIndex');
                        if (!$('#Navigation > li.Active').length) {
                            $('#NavigationContainer').css('height', InitialNavigationContainerHeight);
                        }
                    });
                }
            })
            .on('click', function (Event) {

                var $Element = $(this),
                    $Target = $(Event.target);

                // if an onclick attribute is present, the attribute should win
                if ($Target.attr('onclick')) {
                    return false;
                }

                // if OpenMainMenuOnHover is enabled, clicking the item
                // should lead to the link as regular
                if ($('body').hasClass('Visible-ScreenXL') && !Core.App.Responsive.IsTouchDevice() && parseInt(Core.Config.Get('OpenMainMenuOnHover'), 10)) {
                    return true;
                }

                if (!parseInt(Core.Config.Get('OTRSBusinessIsInstalled'), 10) && $Target.hasClass('OTRSBusinessRequired')) {
                    return true;
                }

                // Workaround for Windows Phone IE
                // In Windows Phone IE the event does not bubble up like in other browsers
                // That means that a subnavigation in mobile mode is still collapsed/expanded,
                // although the link to the new page is clicked
                // we force the redirect with this workaround
                if (navigator && navigator.userAgent && navigator.userAgent.match(/Windows Phone/i) && $Target.closest('ul').attr('id') !== 'Navigation') {
                    window.location.href = $Target.closest('a').attr('href');
                    Event.stopPropagation();
                    Event.preventDefault();
                    return true;
                }

                if ($Element.hasClass('Active')) {
                    $Element.removeClass('Active').attr('aria-expanded', false);
                    // Remove z-index=5500.
                    $Element.parent().parent().removeClass('NavContainerZIndex');

                    if ($('body').hasClass('Visible-ScreenXL')) {
                        // restore initial container height
                        $('#NavigationContainer').css('height', InitialNavigationContainerHeight);
                    }
                }
                else {
                    $Element.addClass('Active').attr('aria-expanded', true)
                        .siblings().removeClass('Active');

                    if ($('body').hasClass('Visible-ScreenXL')) {

                        // resize the nav container
                        SetNavContainerHeight($Element);

                        // If Timeout is set for this nav element, clear it
                        ClearSubnavCloseTimeout($Element);

                        // Add z-index=5500.
                        $Element.parent().parent().addClass('NavContainerZIndex');
                    }
                }

                // If element has subnavigation, prevent the link
                if ($Target.closest('li').find('ul').length) {
                    Event.preventDefault();
                    Event.stopPropagation();
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

        // make the navigation items sortable (if enabled)
        if (parseInt(Core.Config.Get('MenuDragDropEnabled'), 10) === 1) {
            Core.App.Subscribe('Event.App.Responsive.ScreenXL', function () {
                $('#NavigationContainer').css('height', '35px');
                Core.UI.DnD.Sortable(
                    $('#Navigation'),
                    {
                        Items: 'li.CanDrag',
                        Tolerance: 'pointer',
                        Distance: 15,
                        Opacity: 0.6,
                        Helper: 'clone',
                        Axis: 'x',
                        Containment: $('#Navigation'),
                        Update: function () {

                            // collect navigation bar items
                            var Items = [];
                            $.each($('#Navigation').children('li'), function() {
                                Items.push($(this).attr('id'));
                            });

                            // save the new order to the users preferences
                            TargetNS.PreferencesUpdate('UserNavBarItemsOrder', Core.JSON.Stringify(Items), function() {
                                $('#Navigation').after('<i class="fa fa-check"></i>').next('.fa-check').css('left', $('#Navigation').outerWidth() + 10).delay(200).fadeIn(function() {
                                    $(this).delay(1500).fadeOut();
                                });
                            });

                            // make sure to re-size the nav container to its initial height after
                            // dragging is finished in case a sub menu was open when the user started dragging.
                            // remember to remove this setting on smaller screens (see SmallerOrEqualScreenL below)
                            $('#NavigationContainer').css('height', InitialNavigationContainerHeight);
                        }
                    }
                );
            });

            // disable sortable on smaller screens
            Core.App.Subscribe('Event.App.Responsive.SmallerOrEqualScreenL', function () {
                if ($('#Navigation').sortable("instance")) {
                    $('#Navigation').sortable("destroy");
                    $('#NavigationContainer').css('height', '100%');
                }
            });
        }

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
        $('#GlobalSearchNav, #GlobalSearchNavResponsive').on('click', function () {
            var SearchFrontend = Core.Config.Get('SearchFrontend');
            if (SearchFrontend) {
                try {
                    eval(SearchFrontend); //eslint-disable-line no-eval
                }
                catch(Error) {
                    $.noop(Error);
                }
            }
            else {
                Core.Agent.Search.OpenSearchDialog();
            }
            return false;
        });

        TargetNS.ResizeNavigationBar();
        $(window).resize(function() {
            // navigation resizing only possible in ScreenXL mode
            if (!$('body').hasClass('Visible-ScreenXL')) {
                return;
            }

            window.clearTimeout(NavigationResizeTimeout);
            NavigationResizeTimeout = window.setTimeout(function () {
                TargetNS.ResizeNavigationBar(true);
            }, 400);
        });
    }

    /**
     * @private
     * @name NavigationBarShowSlideButton
     * @memberof Core.Agent
     * @function
     * @param {String} Direction Right | Left
     * @param {Number} Difference
     * @description
     *      Show slide button, if navigation is wider than the screen.
     */
    function NavigationBarShowSlideButton(Direction, Difference) {

        var Opposites = (Direction === 'Right') ? 'Left' : 'Right',
            NewPosition,
            HideButton = false,
            Delay = 150;

        if (!$('#NavigationContainer').find('.NavigationBarNavigate' + Direction).length) {

            $('#NavigationContainer')
                .append('<a href="#" title="' + Core.Language.Translate('Slide the navigation bar') + '" class="Hidden NavigationBarNavigate' + Direction + '"><i class="fa fa-chevron-' + Direction.toLowerCase() + '"></i></a>')
                .find('.NavigationBarNavigate' + Direction)
                .delay(Delay)
                .fadeIn()
                .on('click', function() {
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

    /**
     * @private
     * @name InitSubmitAndContinue
     * @memberof Core.Agent
     * @function
     * @description
     *      This function initializes the SubmitAndContinue button.
     */
    function InitSubmitAndContinue() {

        // bind event on click for #SubmitAndContinue button
        $('#SubmitAndContinue').on('click', function() {
            $('#ContinueAfterSave').val(1);
            $('#Submit').click();
        });
    }

    /**
     * @name ReorderNavigationItems
     * @memberof Core.Agent
     * @function
     * @param {Array} NavbarCustomOrderItems
     * @description
     *      This function re-orders the navigation items based on the users preferences.
     */
    TargetNS.ReorderNavigationItems = function(NavbarCustomOrderItems) {

        var CurrentItems;

        if (NavbarCustomOrderItems && parseInt(Core.Config.Get('MenuDragDropEnabled'), 10) === 1) {

            NavbarCustomOrderItems = JSON.parse(NavbarCustomOrderItems);

            CurrentItems = $('#Navigation').children('li').get();
            CurrentItems.sort(function(a, b) {
                var IDA, IDB;

                IDA = $(a).attr('id');
                IDB = $(b).attr('id');

                if ($.inArray(IDA, NavbarCustomOrderItems) < $.inArray(IDB, NavbarCustomOrderItems)) {
                    return -1;
                }

                if ($.inArray(IDA, NavbarCustomOrderItems) > $.inArray(IDB, NavbarCustomOrderItems)) {
                    return 1;
                }

                return 0;
            });

            // append the reordered items
            $('#Navigation').empty().append(CurrentItems);
        }

        $('#Navigation').hide().css('visibility', 'visible').show();
    };

    /**
     * @private
     * @name ToolBarIsAside
     * @memberof Core.Agent
     * @function
     * @returns {Boolean} true, if toolbar is next to navigation bar, false otherwise.
     * @description
     *      Checks if the toolbar is next to the navigation bar.
     */
    function ToolBarIsAside() {

        // the following needs to be the case if the Toolbar is next to the
        // navigation bar instead of on top of it:
        // (1) 'left' is > than 'right' (RTL = opposite)
        //      Note: IE8 will show NaN instead of a number for 'auto'
        // (2) 'top' of #NavigationContainer is smaller than the height of the #ToolBar
        //      which would typically mean there is not enough space on top of #NavigationContainer
        //      to display the ToolBar.
        if ((!$('body').hasClass('RTL') &&
            (parseInt($('#ToolBar').css('left'), 10) > parseInt($('#ToolBar').css('right'), 10) || isNaN(parseInt($('#ToolBar').css('left'), 10))) &&
            parseInt($('#NavigationContainer').css('top'), 10) < parseInt($('#ToolBar').height(), 10)) ||
            ($('body').hasClass('RTL') &&
            (parseInt($('#ToolBar').css('left'), 10) < parseInt($('#ToolBar').css('right'), 10) || isNaN(parseInt($('#ToolBar').css('right'), 10))) &&
            parseInt($('#NavigationContainer').css('top'), 10) < parseInt($('#ToolBar').height(), 10))) {
            return true;
        }
        return false;
    }

    /**
     * @name ResizeNavigationBar
     * @memberof Core.Agent
     * @function
     * @param {Boolean} RealResizeEvent
     * @description
     *      This function checks if the navigation bar needs to be resized and equipped
     *      with slider navigation buttons. This can only happen if there are too many
     *      navigation icons.
     */
    TargetNS.ResizeNavigationBar = function (RealResizeEvent) {

        var NavigationBarWidth = 0,
            NewContainerWidth;

        // navigation resizing only possible in ScreenXL mode
        if (RealResizeEvent && !$('body').hasClass('Visible-ScreenXL')) {
            return;
        }

        // set the original width (from css) of #NavigationContainer to have it available later
        if (!$('#NavigationContainer').attr('data-original-width')) {
            $('#NavigationContainer').attr('data-original-width', parseInt(parseInt($('#NavigationContainer').css('width'), 10) / $('body').width() * 100, 10) + '%');
        }

        // on resizing we set the position back to left to be sure
        // to have everything displayed correctly
        $('#Navigation').css('left', '0px');
        $('.NavigationBarNavigateLeft').remove();

        // when we have the toolbar being displayed next to the navigation, we need to leave some space for it
        if (ToolBarIsAside() && (!$('#NavigationContainer').hasClass('IsResized') || RealResizeEvent)) {

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

        // we have to do an exact calculation here (with floating point numbers),
        // otherwise the results will be different across browsers.
        $('#Navigation > li').each(function() {
            NavigationBarWidth += $(this)[0].getBoundingClientRect().width
                + parseInt($(this).css('margin-left'), 10)
                + parseInt($(this).css('margin-right'), 10)
                + parseInt($(this).css('border-left-width'), 10)
                + parseInt($(this).css('border-right-width'), 10);
        });

        // Add additional pixel to calculated width, in order to prevent rounding problems in IE.
        //   Please see bug#12742 for more information.
        if ($.browser.msie || $.browser.trident) {
            NavigationBarWidth += 1;
        }

        $('#Navigation').css('width', Math.ceil(NavigationBarWidth));

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
     * @name SupportedBrowser
     * @memberof Core.Agent
     * @member {Boolean}
     * @description
     *     Indicates a supported browser.
     */
    TargetNS.SupportedBrowser = true;

    /**
     * @name IECompatibilityMode
     * @memberof Core.Agent
     * @member {Boolean}
     * @description
     *     IE Compatibility Mode is active.
     */
    TargetNS.IECompatibilityMode = false;

    /**
     * @name Init
     * @memberof Core.Agent
     * @function
     * @description
     *      This function initializes the application and executes the needed functions.
     */
    TargetNS.Init = function () {
        TargetNS.SupportedBrowser = Core.App.BrowserCheck('Agent');
        TargetNS.IECompatibilityMode = Core.App.BrowserCheckIECompatibilityMode();

        if (TargetNS.IECompatibilityMode) {
            TargetNS.SupportedBrowser = false;
            alert(Core.Language.Translate('Please turn off Compatibility Mode in Internet Explorer!'));
        }

        if (!TargetNS.SupportedBrowser) {
            alert(Core.Language.Translate('The browser you are using is too old.')
                + ' '
                + Core.Language.Translate('This software runs with a huge lists of browsers, please upgrade to one of these.')
                + ' '
                + Core.Language.Translate('Please see the documentation or ask your admin for further information.'));
        }

        Core.App.Responsive.CheckIfTouchDevice();

        InitNavigation();
        InitAvatarFlyout();
        InitSubmitAndContinue();

        // Initialize pagination
        TargetNS.InitPagination();

        // Initialize OTRSBusinessRequired dialog
        if (!parseInt(Core.Config.Get('OTRSBusinessIsInstalled'), 10)) {
            InitOTRSBusinessRequiredDialog();
        }

        // Initialize ticket in new window
        if (parseInt(Core.Config.Get('NewTicketInNewWindow'), 10)) {
            InitTicketInNewWindow();
        }
    };

    /**
     * @name PreferencesUpdate
     * @memberof Core.Agent
     * @function
     * @returns {Boolean} returns true.
     * @param {jQueryObject} Key - The name of the setting.
     * @param {jQueryObject} Value - The value of the setting.
     * @param {Function} SuccessCallback - Callback function to be executed on AJAX success (optional).
     * @description
     *      This function sets session and preferences setting at runtime.
     */
    TargetNS.PreferencesUpdate = function (Key, Value, SuccessCallback) {
        var URL = Core.Config.Get('Baselink'),
            Data = {
                Action: 'AgentPreferences',
                Subaction: 'UpdateAJAX',
                Key: Key,
                Value: Value
            };

        if (!$.isFunction(SuccessCallback)) {
            SuccessCallback = $.noop;
        }

        Core.AJAX.FunctionCall(URL, Data, SuccessCallback);
        return true;
    };

    /**
     * @name CheckSessionExpiredAndReload
     * @memberof Core.Agent
     * @function
     * @description
     *      This function reload the page if the session is over and a login form is showed in some part of the current screen.
     */
    TargetNS.CheckSessionExpiredAndReload = function () {
        if ($('#LoginBox').length) {
            location.reload();
        }
    };

    /**
     * @name InitPagination
     * @memberof Core.Agent
     * @function
     * @description
     *      This function initialize Pagination
     */
    TargetNS.InitPagination = function () {
        var WidgetContainers = Core.Config.Get('ContainerNames');

        // Initializes pagination event function on widgets that have pagination
        if (typeof WidgetContainers !== 'undefined') {
            $.each(WidgetContainers, function (Index, Value) {
                if (typeof Core.Config.Get('PaginationData' + Value.NameForm) !== 'undefined') {
                    PaginationEvent(Value);

                    // Subscribe to ContentUpdate event to initiate pagination event on updated widget
                    Core.App.Subscribe('Event.AJAX.ContentUpdate.Callback', function($WidgetElement) {
                        if (typeof $WidgetElement !== 'undefined' && $WidgetElement.search(Value.NameForm) !== parseInt('-1', 10)) {
                            PaginationEvent(Value);
                        }
                    });
                }
            });
        }
    };

    /**
     * @private
     * @name PaginationEvent
     * @memberof Core.Agent
     * @function
     * @param {Object} Params - Hash with container name
     * @description
     *      Initializes widget pagination events
     */
    function PaginationEvent (Params) {
        var ServerData = Core.Config.Get('PaginationData' + Params.NameForm),
            Pagination, PaginationData, $Container;

        if (typeof ServerData !== 'undefined') {
            $('.Pagination' + Params.NameForm).off('click.PaginationAJAX' + Params.NameForm).on('click.PaginationAJAX' + Params.NameForm, function () {
                Pagination = Core.Data.Get($(this), 'pagination-pagenumber');
                PaginationData = ServerData[Pagination];
                $Container = $(this).parents('.WidgetSimple');
                $Container.addClass('Loading');
                Core.AJAX.ContentUpdate($('#' + PaginationData.AjaxReplace), PaginationData.Baselink, function () {
                    $Container.removeClass('Loading');
                });
                return false;
            });
        }
    }

    /**
     * @private
     * @name InitOTRSBusinessRequiredDialog
     * @memberof Core.Agent
     * @function
     * @description
     *      Initialize OTRSBusiness upgrade dialog on all clicks coming from anchor with OTRSBusinessRequired class.
     */
    function InitOTRSBusinessRequiredDialog () {
        $('body').on('click', 'a.OTRSBusinessRequired', function() {
            TargetNS.ShowOTRSBusinessRequiredDialog();
            return false;
        });
    }

    /**
     * @name ShowOTRSBusinessRequiredDialog
     * @memberof Core.Agent
     * @function
     * @description
     *      This function shows OTRSBusiness upgrade dialog.
     */
    TargetNS.ShowOTRSBusinessRequiredDialog = function() {
        var OTRSBusinessLabel = '<strong>OTRS Business Solution</strong>™';

        Core.UI.Dialog.ShowContentDialog(
            '<div class="OTRSBusinessRequiredDialog">' + Core.Language.Translate('This feature is part of the %s. Please contact us at %s for an upgrade.', OTRSBusinessLabel, 'sales@otrs.com') + '<a class="Hidden" href="http://www.otrs.com/solutions/" target="_blank"><span></span></a></div>',
            '',
            '240px',
            'Center',
            true,
            [
                {
                    Label: Core.Language.Translate('Find out more'),
                    Class: 'Primary',
                    Function: function () {
                        $('.OTRSBusinessRequiredDialog').find('a span').trigger('click');
                    }
                }
            ]
        );
    };

    /**
     * @private
     * @name InitTicketInNewWindow
     * @memberof Core.Agent
     * @function
     * @description
     *      Initializes ticket in new window
     */
    function InitTicketInNewWindow () {
        $('#nav-Tickets-Newphoneticket a').attr('target', '_blank');
        $('#nav-Tickets-Newemailticket a').attr('target', '_blank');
        $('#nav-Tickets-Newprocessticket a').attr('target', '_blank');
        $('.PhoneTicket a').attr('target', '_blank');
        $('.EmailTicket a').attr('target', '_blank');
        $('.ProcessTicket a').attr('target', '_blank');
    }

    Core.Init.RegisterNamespace(TargetNS, 'APP_GLOBAL_EARLY');

    return TargetNS;
}(Core.Agent || {}));
