// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};

/**
 * @namespace Core.Agent.Dashboard
 * @memberof Core.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the Dashboard.
 */
Core.Agent.Dashboard = (function (TargetNS) {

    /**
     * @private
     * @name EventsTicketCalendarInitialization
     * @memberof Core.Agent.Dashboard
     * @function
     * @description
     *      This function gets data and initializes events ticket calendar.
     */
    function EventsTicketCalendarInitialization () {
        var Index,
            EventsTicketCalendar = Core.Config.Get('EventsTicketCalendar'),
            EventsParam,
            EventsParams = [],
            FirstDay = Core.Config.Get('FirstDay');

        for (Index in EventsTicketCalendar) {
            EventsParam = {};
            EventsParam.id = EventsTicketCalendar[Index].ID;
            EventsParam.title = EventsTicketCalendar[Index].Title;
            EventsParam.start = new Date (
                EventsTicketCalendar[Index].SYear,
                EventsTicketCalendar[Index].SMonth,
                EventsTicketCalendar[Index].SDay,
                EventsTicketCalendar[Index].SHour,
                EventsTicketCalendar[Index].SMinute,
                EventsTicketCalendar[Index].SSecond
            );
            EventsParam.end = new Date (
                EventsTicketCalendar[Index].EYear,
                EventsTicketCalendar[Index].EMonth,
                EventsTicketCalendar[Index].EDay,
                EventsTicketCalendar[Index].EHour,
                EventsTicketCalendar[Index].EMinute,
                EventsTicketCalendar[Index].ESecond
            );
            EventsParam.color = EventsTicketCalendar[Index].Color;
            EventsParam.url = EventsTicketCalendar[Index].Url;
            EventsParam.description =
                EventsTicketCalendar[Index].Title +
                "<br />" +
                EventsTicketCalendar[Index].QueueName +
                "<br />" +
                EventsTicketCalendar[Index].Description;
            EventsParam.allDay = false;

            EventsParams.push(EventsParam);
        }

        if (typeof EventsTicketCalendar !== 'undefined') {
            TargetNS.EventsTicketCalendarInit({
                FirstDay: FirstDay,
                Events: EventsParams
            });
        }
    }

    /**
     * @name Init
     * @memberof Core.Agent.Dashboard
     * @function
     * @description
     *      Initializes the dashboard module.
     */
    TargetNS.Init = function () {
        var WidgetContainers = Core.Config.Get('ContainerNames');

        // initializes dashboards stats widget functionality
        TargetNS.InitStatsWidget();

        // initializes events ticket calendar
        EventsTicketCalendarInitialization();

        // Initializes events customer user list
        InitCustomerUserList();

        // Initializes preferences and refresh events for widget containers
        // (if widgets are available)
        if (typeof WidgetContainers !== 'undefined') {
            $.each(WidgetContainers, function (Index, Value) {
                InitWidgetContainerPref(Value);
                InitWidgetContainerRefresh(Value.Name);
            });
        }

        // Initializes AppointmentCalendar widget functionality
        TargetNS.InitAppointmentCalendar();

        // Initializes events ticket queue overview
        InitTicketQueueOverview();

        // Initialize dashboard ticket stats
        InitDashboardTicketStats();

        // Initializes UserOnline widget functionality
        TargetNS.InitUserOnline();

        // Initializes dashboard ticket generic widgets functionality
        TargetNS.InitTicketGeneric();

        Core.UI.DnD.Sortable(
            $('.SidebarColumn'),
            {
                Handle: '.Header h2',
                Items: '.CanDrag',
                Placeholder: 'DropPlaceholder',
                Tolerance: 'pointer',
                Distance: 15,
                Opacity: 0.6,
                Update: function () {
                    var url = 'Action=' + Core.Config.Get('Action') + ';Subaction=UpdatePosition;';
                    $('.CanDrag').each(
                        function () {
                            url = url + ';Backend=' + $(this).attr('id');
                        }
                    );
                    Core.AJAX.FunctionCall(
                        Core.Config.Get('CGIHandle'),
                        url,
                        function () {}
                    );
                }
            }
        );

        Core.UI.DnD.Sortable(
            $('.ContentColumn'),
            {
                Handle: '.Header h2',
                Items: '.CanDrag',
                Placeholder: 'DropPlaceholder',
                Tolerance: 'pointer',
                Distance: 15,
                Opacity: 0.6,
                Update: function () {
                    var url = 'Action=' + Core.Config.Get('Action') + ';Subaction=UpdatePosition;';
                    $('.CanDrag').each(
                        function () {
                            url = url + ';Backend=' + $(this).attr('id');
                        }
                    );
                    Core.AJAX.FunctionCall(
                        Core.Config.Get('CGIHandle'),
                        url,
                        function () {}
                    );
                }
            }
        );

        $('.SettingsWidget').find('label').each(function() {
            if ($(this).find('input').prop('checked')) {
                $(this).addClass('Checked');
            }
            $(this).on('click', function() {
                $(this).toggleClass('Checked', $(this).find('input').prop('checked'));
            });
        });

        Core.Agent.TableFilters.SetAllocationList();

    };

    /**
     * @name RegisterUpdatePreferences
     * @memberof Core.Agent.Dashboard
     * @function
     * @param {jQueryObject} $ClickedElement - The jQuery object of the element(s) that get the event listener.
     * @param {string} ElementID - The ID of the element whose content should be updated with the server answer.
     * @param {jQueryObject} $Form - The jQuery object of the form with the data for the server request.
     * @description
     *      This function binds a click event on an html element to update the preferences of the given dahsboard widget
     */
    TargetNS.RegisterUpdatePreferences = function ($ClickedElement, ElementID, $Form) {
        if (isJQueryObject($ClickedElement) && $ClickedElement.length) {
            $ClickedElement.click(function () {
                var URL = Core.Config.Get('Baselink') + Core.AJAX.SerializeForm($Form),
                    InitContainer = Core.Config.Get('InitContainer' + ElementID),
                    ValidationErrors = false;

                // check for elements to validate
                $ClickedElement.closest('fieldset').find('.StatsSettingsBox').find('.TimeRelativeUnitView').each(function() {
                    var MaxXaxisAttributes = Core.Config.Get('StatsMaxXaxisAttributes') || 1000,
                    TimePeriod             = parseInt($(this).prev('select').prev('select').val(), 10) * parseInt($(this).find('option:selected').attr('data-seconds'), 10),
                    TimeUpcomingPeriod     = parseInt($(this).prev('select').val(), 10) * parseInt($(this).find('option:selected').attr('data-seconds'), 10),
                    $ScaleCount            = $(this).closest('.Value').prevAll('.Value').first().children('select').first(),
                    ScalePeriod            = parseInt($ScaleCount.val(), 10) * parseInt($ScaleCount.next('select').find('option:selected').attr('data-seconds'), 10)

                    if ((TimePeriod + TimeUpcomingPeriod) / ScalePeriod > MaxXaxisAttributes) {
                        $(this)
                            .add($(this).prev('select'))
                            .add($(this).prev('select').prev('select'))
                            .add($(this).closest('.Value'))
                            .addClass('Error');
                    }
                    else {
                        $(this)
                            .add($(this).prev('select'))
                            .add($(this).prev('select').prev('select'))
                            .add($(this).closest('.Value'))
                            .removeClass('Error');
                    }
                });

                if (ValidationErrors) {
                    window.alert(Core.Language.Translate('Please check the fields marked as red for valid inputs.'));
                    return false;
                }

                if (typeof InitContainer !== 'undefined') {
                    URL += ';SortBy=' + InitContainer.SortBy + ';OrderBy=' + InitContainer.OrderBy;
                }

                Core.AJAX.ContentUpdate($('#' + ElementID), URL, function () {
                    Core.UI.ToggleTwoContainer($('#' + ElementID + '-setting'), $('#' + ElementID));
                });
                return false;
            });
        }
    };

    /**
     * @name EventsTicketCalendarInit
     * @memberof Core.Agent.Dashboard
     * @function
     * @param {Object} Params - Hash with different config options.
     * @param {Array} Params.Events - Array of hashes including the data for each event.
     * @description
     *      Initializes the event ticket calendar.
     */
    TargetNS.EventsTicketCalendarInit = function (Params) {
        $('#calendar').fullCalendar({
            header: {
                left: 'month,agendaWeek,agendaDay',
                center: 'title',
                right: 'prev,next today'
            },
            allDayText: Core.Language.Translate('All-day'),
            axisFormat: 'H(:mm)', // uppercase H for 24-hour clock
            editable: false,
            firstDay: Params.FirstDay,
            monthNames: [
                Core.Language.Translate('Jan'),
                Core.Language.Translate('Feb'),
                Core.Language.Translate('Mar'),
                Core.Language.Translate('Apr'),
                Core.Language.Translate('May'),
                Core.Language.Translate('Jun'),
                Core.Language.Translate('Jul'),
                Core.Language.Translate('Aug'),
                Core.Language.Translate('Sep'),
                Core.Language.Translate('Oct'),
                Core.Language.Translate('Nov'),
                Core.Language.Translate('Dec')
            ],
            monthNamesShort: [
                Core.Language.Translate('January'),
                Core.Language.Translate('February'),
                Core.Language.Translate('March'),
                Core.Language.Translate('April'),
                Core.Language.Translate('May_long'),
                Core.Language.Translate('June'),
                Core.Language.Translate('July'),
                Core.Language.Translate('August'),
                Core.Language.Translate('September'),
                Core.Language.Translate('October'),
                Core.Language.Translate('November'),
                Core.Language.Translate('December')
            ],
            dayNames: [
                Core.Language.Translate('Sunday'),
                Core.Language.Translate('Monday'),
                Core.Language.Translate('Tuesday'),
                Core.Language.Translate('Wednesday'),
                Core.Language.Translate('Thursday'),
                Core.Language.Translate('Friday'),
                Core.Language.Translate('Saturday')
            ],
            dayNamesShort: [
                Core.Language.Translate('Su'),
                Core.Language.Translate('Mo'),
                Core.Language.Translate('Tu'),
                Core.Language.Translate('We'),
                Core.Language.Translate('Th'),
                Core.Language.Translate('Fr'),
                Core.Language.Translate('Sa')
            ],
            buttonText: {
                today: Core.Language.Translate('Today'),
                month: Core.Language.Translate('month'),
                week: Core.Language.Translate('week'),
                day: Core.Language.Translate('day')
            },
            eventMouseover: function(calEvent, jsEvent) {
                var Layer, PosX, PosY, DocumentVisible, ContainerHeight,
                    LastYPosition, VisibleScrollPosition, WindowHeight;

                // define PosX and PosY
                // should contain the mouse position relative to the document
                PosX = 0;
                PosY = 0;

                if (!jsEvent) {
                    jsEvent = window.event;
                }
                if (jsEvent.pageX || jsEvent.pageY) {

                    PosX = jsEvent.pageX;
                    PosY = jsEvent.pageY;
                }
                else if (jsEvent.clientX || jsEvent.clientY) {

                    PosX = jsEvent.clientX + document.body.scrollLeft + document.documentElement.scrollLeft;
                    PosY = jsEvent.clientY + document.body.scrollTop + document.documentElement.scrollTop;
                }

                // increase X position to don't be overlapped by mouse pointer
                PosX = PosX + 15;

                Layer =
                '<div id="events-layer" class="Hidden" style="position:absolute; top: ' + PosY + 'px; left:' + PosX + 'px; z-index: 999;"> ' +
                '    <div class="EventDetails">' +
                         $('#event-content-' + calEvent.id).html() +
                '    </div> ' +
                '</div> ';

                $(Layer).appendTo('body');

                // re-calculate Top position if needed
                VisibleScrollPosition = $(document).scrollTop();
                WindowHeight = $(window).height();
                DocumentVisible = VisibleScrollPosition + WindowHeight;

                ContainerHeight = $('#events-layer').height();
                LastYPosition = PosY + ContainerHeight;
                if (LastYPosition > DocumentVisible) {
                    PosY = PosY - (LastYPosition - DocumentVisible) - 10;
                    $('#events-layer').css('top', PosY + 'px');
                }

                $('#events-layer').fadeIn("fast");
            },
            eventMouseout: function() {
                $('#events-layer').fadeOut("fast");
                $('#events-layer').remove();
            },
            events: Params.Events
        });
    };

    /**
     * @name InitStatsConfiguration
     * @memberof Core.Agent.Dashboard
     * @function
     * @param {jQueryObject} $Container
     * @description
     *      Initializes the configuration page for a stats dashboard widget.
     */
    TargetNS.InitStatsConfiguration = function($Container) {
        // Initialize the time multiplicators for the time validation.
        $('.TimeRelativeUnitView, .TimeScaleView', $Container).find('option').each(function() {
            var SecondsMapping = {
                'Year': 31536000,
                'HalfYear': 15724800,
                'Quarter': 7862400,
                'Month': 2592000,
                'Week': 604800,
                'Day': 86400,
                'Hour': 3600,
                'Minute': 60,
                'Second': 1
            };

            $(this).attr('data-seconds', SecondsMapping[$(this).val()]);
        });


        /**
         * @private
         * @name ValidateTimeSettings
         * @memberof Core.Agent.Dashboard.InitStatsConfiguration
         * @function
         * @description
         *      Check for validity of relative time settings
         *      Each time setting has its own maximum value in data-max-seconds and data-upcoming-max-seconds attribute on the .Value div.
         *      If the combination of unit and count is higher than this value, the select boxes will be
         *      colored with red and the submit button will be blocked.
         */
        function ValidateTimeSettings() {

            $Container.find('.TimeRelativeUnitView').each(function() {
                var MaxXaxisAttributes = Core.Config.Get('StatsMaxXaxisAttributes') || 1000,
                TimePeriod             = parseInt($(this).prev('select').prev('select').val(), 10) * parseInt($(this).find('option:selected').attr('data-seconds'), 10),
                TimeUpcomingPeriod     = parseInt($(this).prev('select').val(), 10) * parseInt($(this).find('option:selected').attr('data-seconds'), 10),
                $ScaleCount            = $(this).closest('.Value').prevAll('.Value').first().children('select').first(),
                ScalePeriod            = parseInt($ScaleCount.val(), 10) * parseInt($ScaleCount.next('select').find('option:selected').attr('data-seconds'), 10)

                if ((TimePeriod + TimeUpcomingPeriod) / ScalePeriod > MaxXaxisAttributes) {
                    $(this)
                        .add($(this).prev('select'))
                        .add($(this).prev('select').prev('select'))
                        .add($(this).closest('.Value'))
                        .addClass('Error');
                }
                else {
                    $(this)
                        .add($(this).prev('select'))
                        .add($(this).prev('select').prev('select'))
                        .add($(this).closest('.Value'))
                        .removeClass('Error');
                }
            });

            $Container.find('.TimeScaleView').each(function() {
                if ($(this).find('option').length == 0) {
                    $(this).addClass('Error');
                }
                else {
                    $(this).removeClass('Error');
                }
            });

            $Container.each(function() {
                if ($(this).find('.TimeRelativeUnitView.Error').length || $(this).find('.TimeScaleView.Error').length) {
                    $(this)
                        .next('.Buttons')
                        .find('button:first-child')
                        .attr('disabled', true)
                        .addClass('Disabled');
                }
                else {
                    $(this)
                        .next('.Buttons')
                        .find('button:first-child')
                        .attr('disabled', false)
                        .removeClass('Disabled');
                }
            });
        }

        /**
         * @private
         * @name CollectStatsData
         * @memberof Core.Agent.Dashboard.InitStatsConfiguration
         * @function
         * @description
         *      Serializes all configured settings to a hidden field with JSON.
         */
        function CollectStatsData() {
            var Data = {};

            $Container.find('select, input').each(function() {
                Data[$(this).attr('name')] = $(this).val();
            });

            $Container.prev('.StatsSettingsJSON').val(Core.JSON.Stringify(Data));
        }

        $Container.find('select, input').on('change', function() {
            CollectStatsData();
            ValidateTimeSettings();
        });

        ValidateTimeSettings();
    };

    /**
     * @private
     * @name InitCustomerUserList
     * @memberof Core.Agent.Dashboard
     * @function
     * @description
     *      This function initialize customer user list functionality in AgentCustomerInformationCenter screen.
     */
    function InitCustomerUserList () {
        var CustomerUserRefresh;

        if (typeof Core.Config.Get('CustomerUserListRefresh') !== 'undefined') {
            CustomerUserRefresh = Core.Config.Get('CustomerUserListRefresh');

            Core.Config.Set('RefreshSeconds_' + CustomerUserRefresh.NameHTML, parseInt(CustomerUserRefresh.RefreshTime, 10) || 0);
            if (Core.Config.Get('RefreshSeconds_' + CustomerUserRefresh.NameHTML)) {
                Core.Config.Set('Timer_' + CustomerUserRefresh.NameHTML, window.setTimeout(function() {

                    // get active filter
                    var Filter = $('#Dashboard' + Core.App.EscapeSelector(CustomerUserRefresh.Name) + '-box').find('.Tab.Actions li.Selected a').attr('data-filter'),
                    AdditionalFilter = $('#Dashboard' + Core.App.EscapeSelector(CustomerUserRefresh.Name) + '-box').find('.Tab.Actions li.AdditionalFilter.Selected a').attr('data-filter');
                    $('#Dashboard' + Core.App.EscapeSelector(CustomerUserRefresh.Name) + '-box').addClass('Loading');
                    Core.AJAX.ContentUpdate($('#Dashboard' + Core.App.EscapeSelector(CustomerUserRefresh.Name)), Core.Config.Get('Baselink') + 'Action=' + Core.Config.Get('Action') + ';Subaction=Element;Name=' + CustomerUserRefresh.Name + ';AdditionalFilter=' + AdditionalFilter + ';Filter=' + Filter + ';CustomerID=' + CustomerUserRefresh.CustomerID, function () {
                        $('#Dashboard' + Core.App.EscapeSelector(CustomerUserRefresh.Name) + '-box').removeClass('Loading');
                    });
                    clearTimeout(Core.Config.Get('Timer_' + CustomerUserRefresh.NameHTML));
                }, Core.Config.Get('RefreshSeconds_' + CustomerUserRefresh.NameHTML) * 1000));
            }
        }
    }

    /**
     * @private
     * @name InitWidgetContainerRefresh
     * @memberof Core.Agent.Dashboard
     * @param {String} WidgetName - Name of the widget
     * @function
     * @description
     *      Initializes the event to refresh widget container.
     */
    function InitWidgetContainerRefresh (WidgetName) {
        var WidgetRefresh = Core.Config.Get('CanRefresh-' + WidgetName);
        if (typeof WidgetRefresh !== 'undefined') {
            $('#Dashboard' + Core.App.EscapeSelector(WidgetRefresh.Name) + '_toggle').on('click', function() {
                $('#Dashboard' + Core.App.EscapeSelector(WidgetRefresh.Name) + '-box').addClass('Loading');
                Core.AJAX.ContentUpdate($('#Dashboard' + Core.App.EscapeSelector(WidgetRefresh.Name)), Core.Config.Get('Baselink') + 'Action=' + Core.Config.Get('Action') +';Subaction=Element;Name=' + WidgetRefresh.Name, function () {
                    $('#Dashboard' + Core.App.EscapeSelector(WidgetRefresh.Name) + '-box').removeClass('Loading');
                });
                clearTimeout(Core.Config.Get('Timer_' + WidgetRefresh.NameHTML));
                return false;
            });
        }
    }

    /**
     * @name InitAppointmentCalendar
     * @memberof Core.Agent.Dashboard
     * @function
     * @description
     *      Initializes dashboard widget Appointment Calendar.
     */
    TargetNS.InitAppointmentCalendar = function() {
        var AppointmentCalendar = Core.Config.Get('AppointmentCalendar');

        // Initializes Appointment Calendar event functionality
        if (typeof AppointmentCalendar !== 'undefined') {
            AppointmentCalendarEvent(AppointmentCalendar);

            // Subscribe to ContentUpdate event to initiate events on Appointment Calendar widget update
            Core.App.Subscribe('Event.AJAX.ContentUpdate.Callback', function(WidgetHTML) {
                if (typeof WidgetHTML !== 'undefined' && WidgetHTML.search('DashboardAppointmentCalendar') !== parseInt('-1', 10)) {
                    AppointmentCalendarEvent(AppointmentCalendar);
                }
            });
        }
    };

    /**
     * @private
     * @name AppointmentCalendarEvent
     * @memberof Core.Agent.Dashboard
     * @function
     * @param {Object} AppointmentCalendar - Hash with container name, HTML name and refresh time
     * @description
     *      Initializes dashboard widget Appointment Calendar events.
     */
    function AppointmentCalendarEvent (AppointmentCalendar) {

        // Load filter for today.
        $('#Dashboard' + Core.App.EscapeSelector(AppointmentCalendar.Name) + 'Today').unbind('click').bind('click', function(){
            Core.AJAX.ContentUpdate($('#Dashboard' + Core.App.EscapeSelector(AppointmentCalendar.Name)), Core.Config.Get('Baselink') + 'Action=' + Core.Config.Get('Action') + ';Subaction=Element;Name=' + AppointmentCalendar.Name + ';Filter=Today', function () {
            });
            return false;
        });

        // Load filter for tomorrow.
        $('#Dashboard' + Core.App.EscapeSelector(AppointmentCalendar.Name) + 'Tomorrow').unbind('click').bind('click', function(){
            Core.AJAX.ContentUpdate($('#Dashboard' + Core.App.EscapeSelector(AppointmentCalendar.Name)), Core.Config.Get('Baselink') + 'Action=' + Core.Config.Get('Action') + ';Subaction=Element;Name=' + AppointmentCalendar.Name + ';Filter=Tomorrow', function () {
            });
            return false;
        });

        // Load filter for soon.
        $('#Dashboard' + Core.App.EscapeSelector(AppointmentCalendar.Name) + 'Soon').unbind('click').bind('click', function(){
            Core.AJAX.ContentUpdate($('#Dashboard' + Core.App.EscapeSelector(AppointmentCalendar.Name)), Core.Config.Get('Baselink') + 'Action=' + Core.Config.Get('Action') + ';Subaction=Element;Name=' + AppointmentCalendar.Name + ';Filter=Soon', function () {
            });
            return false;
        });

        // Initiate refresh event.
        Core.Config.Set('RefreshSeconds_' + AppointmentCalendar.NameHTML, parseInt(AppointmentCalendar.RefreshTime, 10) || 0);
        if (Core.Config.Get('RefreshSeconds_' + AppointmentCalendar.NameHTML)) {
            Core.Config.Set('Timer_' + AppointmentCalendar.NameHTML, window.setTimeout(
                function() {
                    $('#Dashboard' + Core.App.EscapeSelector(AppointmentCalendar.Name) + '-box').addClass('Loading');
                    Core.AJAX.ContentUpdate($('#Dashboard' + Core.App.EscapeSelector(AppointmentCalendar.Name)), Core.Config.Get('Baselink') + 'Action=' + Core.Config.Get('Action') + ';Subaction=Element;Name=' + AppointmentCalendar.Name, function () {
                        $('#Dashboard' + Core.App.EscapeSelector(AppointmentCalendar.Name) + '-box').removeClass('Loading');
                    });
                    clearTimeout(Core.Config.Get('Timer_' + AppointmentCalendar.NameHTML));
                },
                Core.Config.Get('RefreshSeconds_' + AppointmentCalendar.NameHTML) * 1000)
            );
        }
    }

    /**
     * @name InitUserOnline
     * @memberof Core.Agent.Dashboard
     * @function
     * @description
     *      Initializes User Online dashboard widget.
     */
    TargetNS.InitUserOnline = function() {
        var UserOnline = Core.Config.Get('UserOnline');

        // Initializes User Online event functionality
        if (typeof UserOnline !== 'undefined') {
            UserOnlineEvent(UserOnline);

            // Subscribe to ContentUpdate event to initiate events on User Online widget update
            Core.App.Subscribe('Event.AJAX.ContentUpdate.Callback', function(WidgetHTML) {
                if (typeof WidgetHTML !== 'undefined' && WidgetHTML.search('DashboardUserOnline') !== parseInt('-1', 10)) {
                    UserOnlineEvent(UserOnline);
                }
            });
        }
    };

    /**
     * @private
     * @name UserOnlineEvent
     * @memberof Core.Agent.Dashboard
     * @function
     * @param {Object} UserOnline - Hash with container name, HTML name and refresh time
     * @description
     *      Initializes dashboard widget User Online events
     */
    function UserOnlineEvent (UserOnline) {

        // Bind event on Agent filter
        $('#Dashboard' + Core.App.EscapeSelector(UserOnline.Name) + 'Agent').off('click').on('click', function(){
            Core.AJAX.ContentUpdate($('#Dashboard' + Core.App.EscapeSelector(UserOnline.Name)), Core.Config.Get('Baselink') + 'Action=' + Core.Config.Get('Action') + ';Subaction=Element;Name=' + UserOnline.Name + ';Filter=Agent', function () {
            });
            return false;
        });

        // Bind event on Customer filter
        $('#Dashboard' + Core.App.EscapeSelector(UserOnline.Name) + 'Customer').off('click').on('click', function(){
            Core.AJAX.ContentUpdate($('#Dashboard' + Core.App.EscapeSelector(UserOnline.Name)), Core.Config.Get('Baselink') + 'Action=' + Core.Config.Get('Action') + ';Subaction=Element;Name=' + UserOnline.Name + ';Filter=Customer', function () {
            });
            return false;
        });

        // Initiate refresh event
        Core.Config.Set('RefreshSeconds_' + UserOnline.NameHTML, parseInt(UserOnline.RefreshTime, 10) || 0);
        if (Core.Config.Get('RefreshSeconds_' + UserOnline.NameHTML)) {
            Core.Config.Set('Timer_' + UserOnline.NameHTML, window.setTimeout(
                function() {
                    $('#Dashboard' + Core.App.EscapeSelector(UserOnline.Name) + '-box').addClass('Loading');
                    Core.AJAX.ContentUpdate($('#Dashboard' + Core.App.EscapeSelector(UserOnline.Name)), Core.Config.Get('Baselink') + 'Action=' + Core.Config.Get('Action') + ';Subaction=Element;Name=' + UserOnline.Name, function () {
                        $('#Dashboard' + Core.App.EscapeSelector(UserOnline.Name) + '-box').removeClass('Loading');
                    });
                    clearTimeout(Core.Config.Get('Timer_' + UserOnline.NameHTML));
                },
                Core.Config.Get('RefreshSeconds_' + UserOnline.NameHTML) * 1000)
            );
        }
    }

    /**
     * @name InitStatsWidget
     * @memberof Core.Agent.Dashboard
     * @function
     * @description
     *      Initializes the stats dashboard widgets.
     */
    TargetNS.InitStatsWidget = function () {
        var StatsData,
            DashboardStats = Core.Config.Get('DashboardStatsIDs');

        // initializes dashboards stats widget functionality
        if (typeof DashboardStats !== 'undefined') {
            $.each(DashboardStats, function (Index, Value) {
                StatsWidget(Value);

                // Subscribe to ContentUpdate event to initiate stats widget event on updated widget
                Core.App.Subscribe('Event.AJAX.ContentUpdate.Callback', function($WidgetElement) {
                    StatsData = Core.Config.Get('StatsData' + Value);
                    if (typeof StatsData !== 'undefined' && typeof $WidgetElement !== 'undefined' && $WidgetElement.search(StatsData.Name) !== parseInt('-1', 10)) {
                        StatsWidget(Value);
                    }
                });
            });
        }
    };

    /**
     * @private
     * @name StatsWidget
     * @memberof Core.Agent.Dashboard
     * @param {Object} ID - StatID.
     * @function
     * @description
     *      Initializes each available stats dashboard widget functionality.
     */
    function StatsWidget (ID) {
        var StatsData = Core.Config.Get('StatsData' + ID),
            WidgetRefreshStat = Core.Config.Get('WidgetRefreshStat' + ID);

        if (typeof StatsData === 'undefined') {
            return;
        }

        (function(){
            var Timeout = 500;

            if (StatsData.StatResultData === null) {
                return;
            }

            // check if the container is already expanded, otherwise the graph
            // would have the wrong size after the widget settings have been saved
            // and the content is being reloaded using ajax.
            if ($('#GraphWidget' + Core.App.EscapeSelector(StatsData.Name)).parent().is(':visible')) {
                Timeout = 0;
            }

            window.setTimeout(function () {
                Core.UI.AdvancedChart.Init(
                    StatsData.Format,
                    Core.JSON.Parse(StatsData.StatResultData),
                    'svg.GraphWidget' + StatsData.Name,
                    {
                        PreferencesKey: 'GraphWidget' + StatsData.Name,
                        PreferencesData: Core.JSON.Parse(StatsData.Preferences),
                        Duration: 250
                    }
                );
            }, Timeout);

        }());



        $('#GraphWidgetLink' + Core.App.EscapeSelector(StatsData.Name)).prependTo($('#GraphWidget' + Core.App.EscapeSelector(StatsData.Name)).closest('.WidgetSimple').find('.ActionMenu'));
        $('#GraphWidgetLink' + Core.App.EscapeSelector(StatsData.Name)).find('a.TriggerTooltip').off('click').on('click', function(){
            $(this).next('.WidgetTooltip').toggleClass('Hidden');
            return false;
        });
        $('#GraphWidgetLink' + Core.App.EscapeSelector(StatsData.Name)).find('.WidgetTooltip').find('a').off('click').on('click', function(){
            $(this).closest('.WidgetTooltip').addClass('Hidden');
        });
        $('#GraphWidgetLink' + Core.App.EscapeSelector(StatsData.Name)).closest('.Header').on('mouseleave.WidgetTooltip', function(){
            $('#GraphWidgetLink' + Core.App.EscapeSelector(StatsData.Name)).find('.WidgetTooltip').addClass('Hidden');
        });

        $('#DownloadSVG' + Core.App.EscapeSelector(StatsData.Name)).off('click').on('click', function() {
            this.href = Core.UI.AdvancedChart.ConvertSVGtoBase64($('#GraphWidgetContainer' + Core.App.EscapeSelector(StatsData.Name)));
        });
        $('#DownloadPNG' + Core.App.EscapeSelector(StatsData.Name)).off('click').on('click', function() {
            this.href = Core.UI.AdvancedChart.ConvertSVGtoPNG($('#GraphWidgetContainer' + Core.App.EscapeSelector(StatsData.Name)));
        });

        Core.Config.Set('StatsMaxXaxisAttributes', parseInt(StatsData.MaxXaxisAttributes, 10));
        TargetNS.InitStatsConfiguration($('#StatsSettingsBox' + Core.App.EscapeSelector(StatsData.Name) + ''));

        if (typeof WidgetRefreshStat === 'undefined') {
            return;
        }

        // Initiate dashboard stat refresh event.
        Core.Config.Set('RefreshSeconds_' + WidgetRefreshStat.NameHTML, parseInt(WidgetRefreshStat.RefreshTime, 10) || 0);
        if (Core.Config.Get('RefreshSeconds_' + WidgetRefreshStat.NameHTML)) {
            Core.Config.Set('Timer_' + WidgetRefreshStat.NameHTML, window.setTimeout(
                function() {
                    $('#Dashboard' + Core.App.EscapeSelector(WidgetRefreshStat.Name) + '-box').addClass('Loading');
                    Core.AJAX.ContentUpdate($('#Dashboard' + Core.App.EscapeSelector(WidgetRefreshStat.Name)), Core.Config.Get('Baselink') + 'Action=' + Core.Config.Get('Action') + ';Subaction=Element;Name=' + WidgetRefreshStat.Name, function () {
                        $('#Dashboard' + Core.App.EscapeSelector(WidgetRefreshStat.Name) + '-box').removeClass('Loading');
                    });

                    clearTimeout(Core.Config.Get('Timer_' + WidgetRefreshStat.NameHTML));
                },
                Core.Config.Get('RefreshSeconds_' + WidgetRefreshStat.NameHTML) * 1000)
            );
        }
    }

    /**
     * @private
     * @name InitWidgetContainerPref
     * @memberof Core.Agent.Dashboard
     * @function
     * @param {Object} Params - Hash with container name, with and without ('-') to support IE
     * @description
     *      Initializes preferences for widget containers
     */
    function InitWidgetContainerPref (Params) {
        TargetNS.RegisterUpdatePreferences($('#Dashboard' + Core.App.EscapeSelector(Params.Name) + '_submit'), 'Dashboard' + Core.App.EscapeSelector(Params.Name),$('#Dashboard' + Core.App.EscapeSelector(Params.NameForm) + '_setting_form'));
        Core.UI.RegisterToggleTwoContainer($('#Dashboard' + Core.App.EscapeSelector(Params.Name) + '-toggle'), $('#Dashboard' + Core.App.EscapeSelector(Params.Name) + '-setting'), $('#Dashboard' + Core.App.EscapeSelector(Params.Name)));
        Core.UI.RegisterToggleTwoContainer($('#Dashboard' + Core.App.EscapeSelector(Params.Name) + '_cancel'), $('#Dashboard' + Core.App.EscapeSelector(Params.Name) + '-setting'), $('#Dashboard' + Core.App.EscapeSelector(Params.Name)));
    }

    /**
     * @private
     * @name InitTicketQueueOverview
     * @memberof Core.Agent.Dashboard
     * @function
     * @description
     *      This function initialize ticket queue overview in Dashboard screen.
     */
    function InitTicketQueueOverview () {
        var QueueOverview = Core.Config.Get('QueueOverview');

        if (typeof QueueOverview !== 'undefined') {
            Core.Config.Set('RefreshSeconds_' + QueueOverview.NameHTML, parseInt(QueueOverview.RefreshTime, 10) || 0);
            if (Core.Config.Get('RefreshSeconds_' + QueueOverview.NameHTML)) {
                Core.Config.Set('Timer_' + QueueOverview.NameHTML, window.setTimeout(function() {

                    $('#Dashboard' + Core.App.EscapeSelector(QueueOverview.Name) + '-box').addClass('Loading');
                    Core.AJAX.ContentUpdate($('#Dashboard' + Core.App.EscapeSelector(QueueOverview.Name)), Core.Config.Get('Baselink') + 'Action=' + Core.Config.Get('Action') + ';Subaction=Element;Name=' + QueueOverview.Name, function () {
                        $('#Dashboard' + Core.App.EscapeSelector(QueueOverview.Name) + '-box').removeClass('Loading');
                        InitTicketQueueOverview();
                    });
                    clearTimeout(Core.Config.Get('Timer_' + QueueOverview.NameHTML));
                }, Core.Config.Get('RefreshSeconds_' + QueueOverview.NameHTML) * 1000));
            }
        }
    }

    /**
     * @private
     * @name InitDashboardTicketStats
     * @memberof Core.Agent.Dashboard
     * @function
     * @description
     *      This function initialize dashboard ticket stats widget.
     */
    function InitDashboardTicketStats () {
        var Timeout = 500,
            DashboardTicketStats = Core.Config.Get('DashboardTicketStats');

        if (typeof DashboardTicketStats !== 'undefined') {

            window.setTimeout(function () {
                Core.UI.AdvancedChart.Init(
                    "D3::SimpleLineChart",
                    Core.JSON.Parse(DashboardTicketStats.ChartData),
                    'svg.GraphWidget' + DashboardTicketStats.Key,
                    {
                        Duration: 250,
                        ReduceXTicks: false
                    }
                );
            }, Timeout);
        }
    }

    /**
     * @name InitTicketGeneric
     * @memberof Core.Agent.Dashboard
     * @function
     * @description
     *      Initializes the dashboard ticket generic widget functionality.
     */
    TargetNS.InitTicketGeneric = function () {
        var Data = Core.Config.Get('ContainerNames');

        // initializes dashboards ticket generic events
        if (typeof Data !== 'undefined') {
            $.each(Data, function (Index, Value) {

                if (typeof Value !== 'undefined') {
                    TicketGenericEvent(Value);

                    // Subscribe to ContentUpdate event to initiate ticket generic events on widget update
                    Core.App.Subscribe('Event.AJAX.ContentUpdate.Callback', function($WidgetElement) {
                        if (typeof $WidgetElement !== 'undefined' && $WidgetElement.search(Value.Name) !== parseInt('-1', 10)) {
                            TicketGenericEvent(Value);
                        }
                    });
                }
            });
        }
    };

    /**
     * @private
     * @name TicketGenericEvent
     * @memberof Core.Agent.Dashboard
     * @param {Object} Value - Hash with different config options.
     * @function
     * @description
     *      Initializes dashboard ticket generic events.
     */
    function TicketGenericEvent (Value) {
        var HeaderMeta, TicketNumberColumn, HeaderColumn, HeaderColumnSortableData, HeaderColumnFilterSortData,
            HeaderColumnFilterData, WidgetRefreshData, WidgetContainer;

        HeaderMeta = Core.Config.Get('HeaderMeta' + Value.NameForm);
        if (typeof HeaderMeta !== 'undefined') {
            GenericHeaderMeta(HeaderMeta);
        }

        TicketNumberColumn = Core.Config.Get('TicketNumberColumn' + Value.NameForm);
        if (typeof TicketNumberColumn !== 'undefined') {
            GenericHeaderTicketNumberColumn(TicketNumberColumn);
        }

        HeaderColumn = Core.Config.Get('HeaderColumn' + Value.NameForm);
        if (typeof HeaderColumn !== 'undefined') {
            $.each(HeaderColumn, function (ColumnIndex, ColumnValue) {
                HeaderColumnFilterSortData = Core.Config.Get('ColumnFilterSort' + ColumnValue + Value.NameForm);
                if (typeof HeaderColumnFilterSortData !== 'undefined') {
                    GenericHeaderColumnFilterSort(HeaderColumnFilterSortData);
                }

                HeaderColumnSortableData = Core.Config.Get('ColumnSortable' + ColumnValue + Value.NameForm);
                if (typeof HeaderColumnSortableData !== 'undefined') {
                    GenericHeaderColumnSortable(HeaderColumnSortableData);
                }

                HeaderColumnFilterData = Core.Config.Get('ColumnFilter' + ColumnValue + Value.NameForm);
                if (typeof HeaderColumnFilterData !== 'undefined') {
                    GenericHeaderColumnFilter(HeaderColumnFilterData);
                }

                // initializes autocompletion for customer ID
                if (ColumnValue === 'CustomerID') {
                    Core.Agent.TableFilters.InitCustomerIDAutocomplete($(".CustomerIDAutoComplete"));
                }

                // initializes autocompletion for customer user
                if (ColumnValue === 'CustomerUserID') {
                    Core.Agent.TableFilters.InitCustomerUserAutocomplete($(".CustomerUserAutoComplete"));
                }

                // initializes autocompletion for user
                if (ColumnValue === 'Responsible' || ColumnValue === 'Owner') {
                    Core.Agent.TableFilters.InitUserAutocomplete($(".UserAutoComplete"));
                }
            });
        }

        ColumnSettings();

        $('.AutoColspan').each(function() {
            var ColspanCount = $(this).closest('table').find('th').length;
            $(this).attr('colspan', ColspanCount);
        });

        // Initialize refresh event for dashboard ticket widgets
        WidgetRefreshData = Core.Config.Get('WidgetRefresh' + Value.NameForm);
        if (typeof WidgetRefreshData !== 'undefined') {
            DashboardTicketWidgetRefresh(WidgetRefreshData);
        }

        // Initialize remove filter event
        WidgetContainer = Core.Config.Get('WidgetContainer' + Value.NameForm);
        if (typeof WidgetContainer !== 'undefined') {
            if (WidgetContainer.FilterActive) {
                DashboardTicketWidgetRemoveFilter(WidgetContainer);
            }
            else {
                $('#Dashboard' + Core.App.EscapeSelector(WidgetContainer.Name) + '-box').find('.RemoveFilters').remove();
            }
            DashboardTicketWidgetFilter(WidgetContainer);
        }

        // Reinitialize events for Customer Users table on update.
        // See bug#14737 for more details (https://bugs.otrs.org/show_bug.cgi?id=14737).
        if (!$.isEmptyObject(Core.Agent.SwitchToCustomerAction)) {
            Core.Agent.SwitchToCustomerAction.Init();
        }

        Core.UI.InitMasterAction();
    }

    /**
     * @private
     * @name GenericHeaderMeta
     * @memberof Core.Agent.Dashboard
     * @param {Object} HeaderMeta - Hash with different config options.
     * @function
     * @description
     *      Initializes the header meta event.
     */
    function GenericHeaderMeta (HeaderMeta) {

        $('#' + Core.App.EscapeSelector(HeaderMeta.HeaderColumnName) + 'FlagOverviewControl' + Core.App.EscapeSelector(HeaderMeta.Name)).off('click').on('click', function (Event) {
            var Filter, AdditionalFilter, LinkPage, ColumnFilterName, CustomerID, CustomerUserID;

            Filter           = $('#Filter' + Core.App.EscapeSelector(HeaderMeta.Name)).val() || 'All';
            AdditionalFilter = $('#AdditionalFilter' + Core.App.EscapeSelector(HeaderMeta.Name)).val() || '';
            LinkPage         = '';
            CustomerID       = $('input[name=CustomerID]').val() || '';
            CustomerUserID   = $('input[name=CustomerUserID]').val() || '';

            // get all column filters
            $('.ColumnFilter').each(function(){
                ColumnFilterName  = $(this).attr('name');

                // get all options of current column filter
                $(this).children().each(function() {
                    if ($(this).attr('value') && $(this).attr('selected')) {
                        LinkPage = LinkPage + ColumnFilterName + '=' + $(this).attr('value') + ';';
                    }
                });
            });

            $('#Dashboard' + Core.App.EscapeSelector(HeaderMeta.Name) + '-box').addClass('Loading');
            Core.AJAX.ContentUpdate($('#Dashboard' + Core.App.EscapeSelector(HeaderMeta.Name)), Core.Config.Get('Baselink') + 'Action=' + Core.Config.Get('Action') + ';Subaction=Element;Name=' + HeaderMeta.Name + ';AdditionalFilter=' + AdditionalFilter + ';Filter=' + Filter + ';' + LinkPage + ';CustomerID=' + CustomerID + ';CustomerUserID=' + CustomerUserID + ';SortBy=' + HeaderMeta.HeaderColumnName + ';OrderBy=' + HeaderMeta.OrderBy + ';SortingColumn=' + HeaderMeta.SortingColumn, function () {
                $('#Dashboard' + Core.App.EscapeSelector(HeaderMeta.Name) + '-box').removeClass('Loading');
            });
            Event.preventDefault();
            return false;
        });
    }

    /**
     * @private
     * @name GenericHeaderTicketNumberColumn
     * @memberof Core.Agent.Dashboard
     * @param {Object} TicketNumberColumn - Hash with different config options.
     * @function
     * @description
     *      Initializes the ticket number column event.
     */
    function GenericHeaderTicketNumberColumn (TicketNumberColumn) {

        $('#TicketNumberOverviewControl' + Core.App.EscapeSelector(TicketNumberColumn.Name)).off('click').on('click', function (Event) {
            var Filter, AdditionalFilter, LinkPage, ColumnFilterName, CustomerID, CustomerUserID;

            Filter           = $('#Filter' + Core.App.EscapeSelector(TicketNumberColumn.Name)).val() || 'All';
            AdditionalFilter = $('#AdditionalFilter' + Core.App.EscapeSelector(TicketNumberColumn.Name)).val() || '';
            LinkPage         = '';
            CustomerID       = $('input[name=CustomerID]').val() || '';
            CustomerUserID   = $('input[name=CustomerUserID]').val() || '';

            // get all column filters
            $('.ColumnFilter').each(function(){
                ColumnFilterName  = $(this).attr('name');

                // get all options of current column filter
                $(this).children().each(function() {
                    if ($(this).attr('value') && $(this).attr('selected')) {
                        LinkPage = LinkPage + ColumnFilterName + '=' + $(this).attr('value') + ';';
                    }
                });
            });

            $('#Dashboard' + Core.App.EscapeSelector(TicketNumberColumn.Name) + '-box').addClass('Loading');
            Core.AJAX.ContentUpdate($('#Dashboard' + Core.App.EscapeSelector(TicketNumberColumn.Name) + ''), Core.Config.Get('Baselink') + 'Action=' + Core.Config.Get('Action') + ';Subaction=Element;Name=' + TicketNumberColumn.Name + ';AdditionalFilter=' + AdditionalFilter + ';Filter=' + Filter + ';' + LinkPage + ';CustomerID=' + CustomerID + ';CustomerUserID=' + CustomerUserID + ';SortBy=TicketNumber;OrderBy=' + TicketNumberColumn.OrderBy + ';SortingColumn=' + TicketNumberColumn.SortingColumn, function () {
                $('#Dashboard' + Core.App.EscapeSelector(TicketNumberColumn.Name) + '-box').removeClass('Loading');
            });
            Event.preventDefault();
            return false;
        });
    }

    /**
     * @private
     * @name GenericHeaderColumnFilterSort
     * @memberof Core.Agent.Dashboard
     * @param {Object} ColumnFilterSort - Hash with different config options.
     * @function
     * @description
     *      Initializes the filterable and sortable column event.
     */
    function GenericHeaderColumnFilterSort (ColumnFilterSort) {
        var LinkPage, ColumnFilterName, Filter, AdditionalFilter, ColumnFilterID, CustomerID, CustomerUserID;

        $('#ColumnFilter' + Core.App.EscapeSelector(ColumnFilterSort.HeaderColumnName) + Core.App.EscapeSelector(ColumnFilterSort.Name)).off('change').on('change', function(){

            LinkPage         = '';
            Filter           = $('#Filter' + Core.App.EscapeSelector(ColumnFilterSort.Name)).val() || 'All';
            AdditionalFilter = $('#AdditionalFilter' + Core.App.EscapeSelector(ColumnFilterSort.Name)).val() || '';
            CustomerID       = $('input[name=CustomerID]').val() || '';
            CustomerUserID   = $('input[name=CustomerUserID]').val() || '';

            // set ColumnFilter value for current ColumnFilter
            ColumnFilterName = $(this).attr('name');
            LinkPage = LinkPage + ColumnFilterName + '=' + encodeURIComponent($(this).val()) + ';';

            // remember the current ColumnFilter ID
            ColumnFilterID = $(this).attr('ID');

            // get all column filters
            $('.ColumnFilter').each(function(){
                ColumnFilterName  = $(this).attr('name');

                // exclude current column filter, apparently the selected option is not set to
                // selected at this point and uses the old value
                if ($(this).attr('ID') !== ColumnFilterID) {

                    // get all options of current column filter
                    $(this).children().each(function() {
                        if ($(this).attr('value') && $(this).attr('selected')) {
                            LinkPage = LinkPage + ColumnFilterName + '=' + encodeURIComponent($(this).attr('value')) + ';';
                        }
                    });
                }
            });

            $('#Dashboard' + Core.App.EscapeSelector(ColumnFilterSort.Name) + '-box').addClass('Loading');
            Core.AJAX.ContentUpdate($('#Dashboard' + Core.App.EscapeSelector(ColumnFilterSort.Name)), Core.Config.Get('Baselink') + 'Action=' + Core.Config.Get('Action') + ';Subaction=Element;Name=' + ColumnFilterSort.Name + ';AdditionalFilter=' + AdditionalFilter + ';Filter=' + Filter + ';CustomerID=' + CustomerID + ';CustomerUserID=' + CustomerUserID + ';SortBy=' + ColumnFilterSort.SortBy + ';OrderBy=' + ColumnFilterSort.OrderBy + ';SortingColumn=' + ColumnFilterSort.SortingColumn + ';AddFilters=1;' + LinkPage, function () {
                $('#Dashboard' + Core.App.EscapeSelector(ColumnFilterSort.Name) + '-box').removeClass('Loading');
            });
            return false;
        });

        $('#' + Core.App.EscapeSelector(ColumnFilterSort.HeaderColumnName) + 'OverviewControl' + Core.App.EscapeSelector(ColumnFilterSort.Name)).off('click').on('click', function (Event) {

            LinkPage         = '';
            Filter           = $('#Filter' + Core.App.EscapeSelector(ColumnFilterSort.Name)).val() || 'All';
            AdditionalFilter = $('#AdditionalFilter' + Core.App.EscapeSelector(ColumnFilterSort.Name)).val() || '';
            CustomerID       = $('input[name=CustomerID]').val() || '';
            CustomerUserID   = $('input[name=CustomerUserID]').val() || '';

            // set ColumnFilter value for current ColumnFilter
            ColumnFilterName = $(this).attr('name');
            LinkPage = LinkPage + ColumnFilterName + '=' + encodeURIComponent($(this).val()) + ';';

            // remember the current ColumnFilter ID
            ColumnFilterID = $(this).attr('ID');

            // get all column filters
            $('.ColumnFilter').each(function(){
                ColumnFilterName  = $(this).attr('name');

                // exclude current column filter, apparently the selected option is not set to
                // selected at this point and uses the old value
                if ($(this).attr('ID') !== ColumnFilterID) {

                    // get all options of current column filter
                    $(this).children().each(function() {
                        if ($(this).attr('value') && $(this).attr('selected')) {
                            LinkPage = LinkPage + ColumnFilterName + '=' + encodeURIComponent($(this).attr('value')) + ';';
                        }
                    });
                }
            });

            $('#Dashboard' + Core.App.EscapeSelector(ColumnFilterSort.Name) + '-box').addClass('Loading');
            Core.AJAX.ContentUpdate($('#Dashboard' + Core.App.EscapeSelector(ColumnFilterSort.Name)), Core.Config.Get('Baselink') + 'Action=' + Core.Config.Get('Action') + ';Subaction=Element;Name=' + ColumnFilterSort.Name + ';AdditionalFilter=' + AdditionalFilter + ';Filter=' + Filter + ';CustomerID=' + CustomerID + ';CustomerUserID=' + CustomerUserID + ';SortBy=' + ColumnFilterSort.HeaderColumnName + ';OrderBy=' + ColumnFilterSort.OrderBy + ';SortingColumn=' + ColumnFilterSort.SortingColumn + ';' + LinkPage, function () {
                $('#Dashboard' + Core.App.EscapeSelector(ColumnFilterSort.Name) + '-box').removeClass('Loading');
            });
            Event.preventDefault();
            return false;
        });
    }

    /**
     * @private
     * @name GenericHeaderColumnSortable
     * @memberof Core.Agent.Dashboard
     * @param {Object} ColumnSortable - Hash with different config options.
     * @function
     * @description
     *      Initializes the sortable column event.
     */
    function GenericHeaderColumnSortable (ColumnSortable) {
        var LinkPage, ColumnFilterName, Filter, AdditionalFilter, ColumnFilterID, CustomerID, CustomerUserID;

        $('#' + Core.App.EscapeSelector(ColumnSortable.HeaderColumnName) + 'OverviewControl' + Core.App.EscapeSelector(ColumnSortable.Name)).off('click').on('click', function (Event) {

            LinkPage         = '';
            Filter           = $('#Filter' + Core.App.EscapeSelector(ColumnSortable.Name)).val() || 'All';
            AdditionalFilter = $('#AdditionalFilter' + Core.App.EscapeSelector(ColumnSortable.Name)).val() || '';
            CustomerID       = $('input[name=CustomerID]').val() || '';
            CustomerUserID   = $('input[name=CustomerUserID]').val() || '';

            // set ColumnFilter value for current ColumnFilter
            ColumnFilterName = $(this).attr('name');
            LinkPage = LinkPage + ColumnFilterName + '=' + $(this).val() + ';';

            // remember the current ColumnFilter ID
            ColumnFilterID = $(this).attr('ID');

            // get all column filters
            $('.ColumnFilter').each(function(){
                ColumnFilterName  = $(this).attr('name');

                // exclude current column filter, apparently the selected option is not set to
                // selected at this point and uses the old value
                if ($(this).attr('ID') !== ColumnFilterID) {

                    // get all options of current column filter
                    $(this).children().each(function() {
                        if ($(this).attr('value') && $(this).attr('selected')) {
                            LinkPage = LinkPage + ColumnFilterName + '=' + $(this).attr('value') + ';';
                        }
                    });
                }
            });

            $('#Dashboard' + Core.App.EscapeSelector(ColumnSortable.Name) + '-box').addClass('Loading');
            Core.AJAX.ContentUpdate($('#Dashboard' + Core.App.EscapeSelector(ColumnSortable.Name)), Core.Config.Get('Baselink') + 'Action=' + Core.Config.Get('Action') + ';Subaction=Element;Name=' + ColumnSortable.Name + ';AdditionalFilter=' + AdditionalFilter +  ';Filter=' + Filter + ';CustomerID=' + CustomerID + ';CustomerUserID=' + CustomerUserID + ';SortBy=' + ColumnSortable.HeaderColumnName + ';OrderBy=' + ColumnSortable.OrderBy + ';SortingColumn=' + ColumnSortable.SortingColumn + ';' + LinkPage, function () {
                $('#Dashboard' + Core.App.EscapeSelector(ColumnSortable.Name) + '-box').removeClass('Loading');
            });
            Event.preventDefault();
            return false;
        });
    }

    /**
     * @private
     * @name GenericHeaderColumnFilter
     * @memberof Core.Agent.Dashboard
     * @param {Object} ColumnFilter - Hash with different config options.
     * @function
     * @description
     *      Initializes the filterable column event.
     */
    function GenericHeaderColumnFilter (ColumnFilter) {
        $('#ColumnFilter' + Core.App.EscapeSelector(ColumnFilter.HeaderColumnName) + Core.App.EscapeSelector(ColumnFilter.Name)).off('change').on('change', function(){
            var LinkPage, ColumnFilterName, Filter, AdditionalFilter, ColumnFilterID, CustomerID, CustomerUserID;

            LinkPage         = '';
            Filter           = $('#Filter' + Core.App.EscapeSelector(ColumnFilter.Name)).val() || 'All';
            AdditionalFilter = $('#AdditionalFilter' + Core.App.EscapeSelector(ColumnFilter.Name)).val() || '';
            CustomerID       = $('input[name=CustomerID]').val() || '';
            CustomerUserID   = $('input[name=CustomerUserID]').val() || '';

            // set ColumnFilter value for current ColumnFilter
            ColumnFilterName = $(this).attr('name');
            LinkPage = LinkPage + ColumnFilterName + '=' + $(this).val() + ';';

            // remember the current ColumnFilter ID
            ColumnFilterID = $(this).attr('ID');

            // get all column filters
            $('.ColumnFilter').each(function(){
                ColumnFilterName  = $(this).attr('name');

                // exclude current column filter, apparently the selected option is not set to
                // selected at this point and uses the old value
                if ($(this).attr('ID') !== ColumnFilterID) {

                    // get all options of current column filter
                    $(this).children().each(function() {
                        if ($(this).attr('value') && $(this).attr('selected')) {
                            LinkPage = LinkPage + ColumnFilterName + '=' + $(this).attr('value') + ';';
                        }
                    });
                }
            });

            $('#Dashboard' + Core.App.EscapeSelector(ColumnFilter.Name) + '-box').addClass('Loading');
            Core.AJAX.ContentUpdate($('#Dashboard' + Core.App.EscapeSelector(ColumnFilter.Name)), Core.Config.Get('Baselink') + 'Action=' + Core.Config.Get('Action') + ';Subaction=Element;Name=' + ColumnFilter.Name + ';AdditionalFilter=' + AdditionalFilter + ';Filter=' + Filter + ';CustomerID=' + CustomerID + ';CustomerUserID=' + CustomerUserID + ';SortBy=' + ColumnFilter.SortBy + ';OrderBy=' + ColumnFilter.OrderBy + ';AddFilters=1;' + LinkPage, function () {
                $('#Dashboard' + Core.App.EscapeSelector(ColumnFilter.Name) + '-box').removeClass('Loading');
            });
            return false;
        });
    }

    /**
     * @private
     * @name ColumnSettings
     * @memberof Core.Agent.Dashboard
     * @function
     * @description
     *      Initializes the column settings event.
     */
    function ColumnSettings () {
        $('.DashboardHeader').off('click').on('click', '.ColumnSettingsTrigger', function() {

            var $TriggerObj = $(this),
                $ColumnSettingsContainer = $TriggerObj.next('.ColumnSettingsContainer'),
                FilterName;

            if ($TriggerObj.hasClass('Active')) {

                $TriggerObj
                    .next('.ColumnSettingsContainer')
                    .find('.ColumnSettingsBox')
                    .fadeOut('fast', function() {
                        $TriggerObj.removeClass('Active');
                    });
            }
            else {

                // slide up all open settings widgets
                $('.ColumnSettingsTrigger')
                    .next('.ColumnSettingsContainer')
                    .find('.ColumnSettingsBox')
                    .fadeOut('fast', function() {
                        $(this).parent().prev('.ColumnSettingsTrigger').removeClass('Active');
                    });

                // show THIS settings widget
                $ColumnSettingsContainer
                    .find('.ColumnSettingsBox')
                    .fadeIn('fast', function() {

                        $TriggerObj.addClass('Active');

                        // only show and use the delete filter icon in case of autocomplete fields
                        // because in regular dropdowns we have a different way to delete the filter
                        if ($TriggerObj.closest('th').hasClass('FilterActive') && $ColumnSettingsContainer.find('select.ColumnFilter').hasClass('Hidden')) {
                            $ColumnSettingsContainer
                                .find('.DeleteFilter')
                                .removeClass('Hidden')
                                .off()
                                .on('click', function() {
                                    $(this)
                                        .closest('.ColumnSettingsContainer')
                                        .find('select')
                                        .val('DeleteFilter')
                                        .trigger('change');

                                    return false;
                                });
                        }

                        // refresh filter dropdown
                        FilterName = $ColumnSettingsContainer
                            .find('select')
                            .attr('name');

                        if ($TriggerObj.closest('th').hasClass('CustomerID') || $TriggerObj.closest('th').hasClass('CustomerUserID') || $TriggerObj.closest('th').hasClass('Responsible') || $TriggerObj.closest('th').hasClass('Owner')) {

                            if (!$TriggerObj.parent().find('.SelectedValue').length) {
                                Core.AJAX.FormUpdate($TriggerObj.parents('form'), 'AJAXFilterUpdate', FilterName, [ FilterName ], function() {

                                    var AutoCompleteValue = $ColumnSettingsContainer
                                            .find('select')
                                            .val(),
                                        AutoCompleteText  = $ColumnSettingsContainer
                                            .find('select')
                                            .find('option:selected')
                                            .text();

                                    if (AutoCompleteValue !== 'DeleteFilter') {

                                        $ColumnSettingsContainer
                                            .find('select')
                                            .after('<span class="SelectedValue Hidden"><span title="' + AutoCompleteText + ' (' + AutoCompleteValue + ')">' + AutoCompleteText + ' (' + AutoCompleteValue + ')</span></span>');
                                    }
                                });
                            }
                        }
                        else {
                            Core.AJAX.FormUpdate($TriggerObj.parents('form'), 'AJAXFilterUpdate', FilterName, [ FilterName ]);
                        }
                });
            }
            return false;
        });
    }

    /**
     * @private
     * @name DashboardTicketWidgetRefresh
     * @memberof Core.Agent.Dashboard
     * @param {Object} WidgetRefreshData - Hash with different config options.
     * @function
     * @description
     *      Initializes the dashboard widget refresh event.
     */
    function DashboardTicketWidgetRefresh (WidgetRefreshData) {
        Core.Config.Set('RefreshSeconds_' + WidgetRefreshData.NameHTML, parseInt(WidgetRefreshData.RefreshTime, 10) || 0);
        if (Core.Config.Get('RefreshSeconds_' + WidgetRefreshData.NameHTML)) {
            Core.Config.Set('Timer_' + WidgetRefreshData.NameHTML, window.setTimeout(function() {

                // get active filter
                var Filter           = $('#Dashboard' + Core.App.EscapeSelector(WidgetRefreshData.Name) + '-box').find('.Tab.Actions li.Selected a').attr('data-filter'),
                    AdditionalFilter = $('#Dashboard' + Core.App.EscapeSelector(WidgetRefreshData.Name) + '-box').find('.Tab.Actions li.AdditionalFilter.Selected a').attr('data-filter') || '',
                    $OrderByObj      = $('#Dashboard' + Core.App.EscapeSelector(WidgetRefreshData.Name) + '-box').find('th.SortDescendingLarge, th.SortAscendingLarge'),
                    SortBy           = $OrderByObj.attr('data-column') || '',
                    OrderBy          = '';

                if ($OrderByObj && $OrderByObj.hasClass('SortDescendingLarge')) {
                    OrderBy = 'Down';
                }
                else if ($OrderByObj && $OrderByObj.hasClass('SortAscendingLarge')) {
                    OrderBy = 'Up';
                }

                $('#Dashboard' + Core.App.EscapeSelector(WidgetRefreshData.Name) + '-box').addClass('Loading');
                Core.AJAX.ContentUpdate($('#Dashboard' + Core.App.EscapeSelector(WidgetRefreshData.Name)), Core.Config.Get('Baselink') + 'Action=' + Core.Config.Get('Action') + ';Subaction=Element;Name=' + WidgetRefreshData.Name + ';AdditionalFilter=' + AdditionalFilter + ';Filter=' + Filter + ';CustomerID=' + WidgetRefreshData.CustomerID + ';CustomerUserID=' + WidgetRefreshData.CustomerUserID + ';SortBy=' + SortBy + ';OrderBy=' + OrderBy, function () {
                    $('#Dashboard' + Core.App.EscapeSelector(WidgetRefreshData.Name) + '-box').removeClass('Loading');
                });
                clearTimeout(Core.Config.Get('Timer_' + WidgetRefreshData.NameHTML));
            }, Core.Config.Get('RefreshSeconds_' + WidgetRefreshData.NameHTML) * 1000));
        }
    }

    /**
     * @private
     * @name DashboardTicketWidgetRemoveFilter
     * @memberof Core.Agent.Dashboard
     * @param {Object} WidgetRemoveFilter - Hash with different config options.
     * @function
     * @description
     *      Initializes the dashboard widget remove filter event.
     */
    function DashboardTicketWidgetRemoveFilter (WidgetRemoveFilter) {
        if (!$('#Dashboard' + Core.App.EscapeSelector(WidgetRemoveFilter.Name) + '-box').find('.ActionMenu').find('.RemoveFilters').length) {
            $('#Dashboard' + Core.App.EscapeSelector(WidgetRemoveFilter.Name) + '-box')
                .find('.ActionMenu')
                .prepend('<div class="WidgetAction RemoveFilters"><a href="#" id="Dashboard' + WidgetRemoveFilter.Name + '-remove-filters" title=' + Core.Language.Translate("Remove active filters for this widget.") + '"><i class="fa fa-trash-o"></i></a></div>')
                .find('.RemoveFilters')
                .on('click', function() {

                    // get active filter
                    var Filter = $('#Dashboard' + Core.App.EscapeSelector(WidgetRemoveFilter.Name) + '-box').find('.Tab.Actions li.Selected a').attr('data-filter'),
                    AdditionalFilter = $('#Dashboard' + Core.App.EscapeSelector(WidgetRemoveFilter.Name) + '-box').find('.Tab.Actions li.AdditionalFilter.Selected a').attr('data-filter') || '';
                    $('#Dashboard' + Core.App.EscapeSelector(WidgetRemoveFilter.Name) + '-box').addClass('Loading');
                    Core.AJAX.ContentUpdate($('#Dashboard' + Core.App.EscapeSelector(WidgetRemoveFilter.Name)), Core.Config.Get('Baselink') + 'Action=' + Core.Config.Get('Action') + ';Subaction=Element;Name=' + WidgetRemoveFilter.Name + ';AdditionalFilter=' + AdditionalFilter + ';Filter=' + Filter + ';CustomerID=' + WidgetRemoveFilter.CustomerID + ';CustomerUserID=' + WidgetRemoveFilter.CustomerUserID + ';RemoveFilters=1', function () {
                        $('#Dashboard' + Core.App.EscapeSelector(WidgetRemoveFilter.Name) + '-box').removeClass('Loading');
                        $('#Dashboard' + Core.App.EscapeSelector(WidgetRemoveFilter.Name) + '-box').find('.RemoveFilters').remove();
                    });
                    return false;
                });
        }
    }

    /**
     * @private
     * @name DashboardTicketWidgetFilter
     * @memberof Core.Agent.Dashboard
     * @param {Object} WidgetFilterData - Hash with different config options.
     * @function
     * @description
     *      Initializes the dashboard widget filter event.
     */
    function DashboardTicketWidgetFilter (WidgetFilterData) {
        $('#Dashboard' + Core.App.EscapeSelector(WidgetFilterData.Name) + '-box').find('.Tab.Actions li a').off('click').on('click', function() {
                var Filter, AdditionalFilter = '',
                CustomerID, CustomerUserID;

                if ($(this).parent().hasClass('AdditionalFilter')) {
                     Filter           = $(this).parent().siblings('li.Selected:not(.AdditionalFilter)').find('a').attr('data-filter');
                     AdditionalFilter = $(this).attr('data-filter');
                }
                else {
                     Filter           = $(this).attr('data-filter');
                     AdditionalFilter = $(this).parent().siblings('li.AdditionalFilter.Selected').find('a').attr('data-filter') || '';
                }

                CustomerID = $('input[name=CustomerID]').val() || '';
                CustomerUserID = $('input[name=CustomerUserID]').val() || '';

                $('#Dashboard' + Core.App.EscapeSelector(WidgetFilterData.Name) + '-box').addClass('Loading');
                Core.AJAX.ContentUpdate($('#Dashboard' + Core.App.EscapeSelector(WidgetFilterData.Name)), Core.Config.Get('Baselink') + 'Action=' + Core.Config.Get('Action') + ';Subaction=Element;Name=' + WidgetFilterData.Name + ';AdditionalFilter=' + AdditionalFilter + ';Filter=' + Filter + ';CustomerID=' + encodeURIComponent(CustomerID) + ';CustomerUserID=' + encodeURIComponent(CustomerUserID) + ';SortBy=' + WidgetFilterData.SortBy + ';OrderBy=' + WidgetFilterData.OrderBy + ';SortingColumn=' + WidgetFilterData.SortingColumn + ';TabAction=1', function () {
                    $('#Dashboard' + Core.App.EscapeSelector(WidgetFilterData.Name) + '-box').removeClass('Loading');
                });
                return false;
            });
    }

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Dashboard || {}));
