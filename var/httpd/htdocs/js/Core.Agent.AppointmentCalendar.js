// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

/*global Clipboard */

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};

/**
 * @namespace Core.Agent.AppointmentCalendar
 * @memberof Core.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains the appointment calendar functions.
 */
Core.Agent.AppointmentCalendar = (function (TargetNS) {

    // Appointment days cache and ready flag
    var AppointmentDaysCache,
        AppointmentDaysCacheRefreshed = false,
        AJAXCounter = 0,
        CurrentView,
        CalendarSources = {};

    /**
     * @name Init
     * @memberof Core.Agent.AppointmentCalendar
     * @description
     *      Initializes the appointment calendar control.
     */
    TargetNS.Init = function () {
        var CalendarConfig = Core.Config.Get('CalendarConfig'),
            ResourceConfig,
            $CalendarObj = $('#calendar'),
            $DatepickerObj,
            ClipboardJS,
            CurrentAppointment = [];

        if (Core.Config.Get('Action') == 'AgentAppointmentAgendaOverview') {
            TargetNS.AgentAppointmentAgendaOverview();
            return;
        }

        if (!CalendarConfig) {
            return;
        }

        $DatepickerObj = $('<div />')
            .prop('id', 'Datepicker')
            .addClass('Hidden')
            .insertAfter($CalendarObj),

        ClipboardJS = new Clipboard('.CopyToClipboard');

        if (Core.Config.Get('TeamID')) {
            ResourceConfig = {
                url: Core.Config.Get('CGIHandle'),
                type: 'POST',
                data: {
                    ChallengeToken: $('#ChallengeToken').val(),
                    Action: 'AgentAppointmentTeamList',
                    Subaction: 'ListResources',
                    TeamID: Core.Config.Get('TeamID')
                }
            };
        }

        // Initialize calendar
        $CalendarObj.fullCalendar({
            header: {
                left: 'month,agendaWeek,agendaDay timelineMonth,timelineWeek,timelineDay',
                center: 'title',
                right: 'jump,today prev,next'
            },
            customButtons: {
                jump: {
                    text: Core.Language.Translate('Jump'),
                    click: function() {
                        ShowDatepicker($CalendarObj, $DatepickerObj, $(this));
                    }
                }
            },
            defaultView: Core.Config.Get('DefaultView'),
            allDayText: Core.Language.Translate('All-day'),
            isRTL: Core.Config.Get('IsRTLLanguage'),
            columnFormat: 'ddd, D MMM',
            timeFormat: 'HH:mm',
            slotLabelFormat: 'HH:mm',
            titleFormat: 'D MMM YYYY',
            weekNumbers: true,
            weekNumberTitle: '#',
            weekNumberCalculation: 'ISO',
            eventLimit: true,
            eventLimitText: Core.Language.Translate('more'),
            height: 600,
            editable: true,
            selectable: true,
            firstDay: Core.Config.Get('CalendarWeekDayStart'),
            monthNames: [
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
            monthNamesShort: [
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
                Core.Language.Translate('Sun'),
                Core.Language.Translate('Mon'),
                Core.Language.Translate('Tue'),
                Core.Language.Translate('Wed'),
                Core.Language.Translate('Thu'),
                Core.Language.Translate('Fri'),
                Core.Language.Translate('Sat')
            ],
            buttonText: {
                today: Core.Language.Translate('Today'),
                month: Core.Language.Translate('Month'),
                week: Core.Language.Translate('Week'),
                day: Core.Language.Translate('Day'),
                timelineMonth: Core.Language.Translate('Timeline Month'),
                timelineWeek: Core.Language.Translate('Timeline Week'),
                timelineDay: Core.Language.Translate('Timeline Day'),
                jump: Core.Language.Translate('Jump'),
                prevDatepicker: Core.Language.Translate('Previous'),
                nextDatepicker: Core.Language.Translate('Next')
            },
            schedulerLicenseKey: 'GPL-My-Project-Is-Open-Source',
            slotDuration: '00:30:00',
            forceEventDuration: true,
            nowIndicator: true,
            timezone: 'local',
            resourceAreaWidth: '21%',
            views: {
                month: {
                    titleFormat: 'MMMM YYYY',
                    columnFormat: 'dddd'
                },
                agendaDay: {
                    titleFormat: 'D MMM YYYY',
                    resources: false
                },
                timelineMonth: {
                    slotDuration: '24:00:00',
                    duration: {
                        months: 1
                    },
                    slotLabelFormat: [
                        'D'
                    ]
                },
                timelineWeek: {
                    slotDuration: '02:00:00',
                    duration: {
                        week: 1
                    },
                    slotLabelFormat: [
                        'ddd, D MMM',
                        'HH'
                    ]
                },
                timelineDay: {
                    slotDuration: '00:30:00',
                    duration: {
                        days: 1
                    },
                    slotLabelFormat: [
                        'ddd, D MMM',
                        'HH:mm'
                    ]
                }
            },
            loading: function(IsLoading) {
                if (IsLoading) {
                    $('.CalendarWidget').addClass('Loading');
                } else {
                    $('.CalendarWidget').removeClass('Loading');
                }
            },
            viewRender: function(View) {

                // Check if we are on a timeline view.
                if (View.name === 'timelineWeek' || View.name === 'timelineDay') {

                    // Add calendar week number to timeline view titles.
                    window.setTimeout(function () {
                        $CalendarObj.find('.fc-toolbar > div > h2').append(
                            $('<span />').addClass('fc-week-number')
                                .text(View.start.format(' #W'))
                        );
                    }, 0);

                    // Initialize restore settings button.
                    RestoreDefaultSettingsInit();
                }

                // Remember view selection
                if (CurrentView !== undefined && CurrentView !== View.name) {
                    Core.AJAX.FunctionCall(
                        Core.Config.Get('CGIHandle'),
                        {
                            ChallengeToken: $('#ChallengeToken').val(),
                            Action: 'AgentAppointmentEdit',
                            Subaction: 'UpdatePreferences',
                            OverviewScreen: Core.Config.Get('OverviewScreen') ? Core.Config.Get('OverviewScreen') : 'CalendarOverview',
                            DefaultView: View.name
                        },
                        function (Response) {
                            if (!Response.Success) {
                                Core.Debug.Log('Error updating user preferences!');
                            }
                        }
                    );
                }
                CurrentView = View.name;
            },
            select: function(Start, End, JSEvent, View, Resource) {
                var Data = {
                    Start: Start,
                    End: End,
                    JSEvent: JSEvent,
                    View: View,
                    Resource: Resource
                };
                TargetNS.OpenEditDialog(Data);
                $CalendarObj.fullCalendar('unselect');
            },
            eventClick: function(CalEvent, JSEvent) {
                var Data = {
                    Start: CalEvent.start,
                    End: CalEvent.end,
                    CalEvent: CalEvent
                };
                TargetNS.OpenEditDialog(Data);
                JSEvent.stopPropagation();
                return false;
            },
            eventDrop: function(CalEvent, Delta, RevertFunc) {
                var Data = {
                    CalEvent: CalEvent,
                    PreviousAppointment: CurrentAppointment,
                    Delta: Delta,
                    RevertFunc: RevertFunc
                };
                UpdateAppointment(Data);
            },
            eventResize: function(CalEvent, Delta, RevertFunc) {
                var Data = {
                    CalEvent: CalEvent,
                    PreviousAppointment: CurrentAppointment,
                    Delta: Delta,
                    RevertFunc: RevertFunc
                };
                UpdateAppointment(Data);
            },
            eventRender: function(CalEvent, $Element) {
                var $IconContainer,
                    $Icon;

                if (CalEvent.allDay
                    || CalEvent.recurring
                    || CalEvent.parentId
                    || CalEvent.notification
                    || CalEvent.ticketAppointmentType) {

                    // Create container and icon element
                    $IconContainer = $('<div />').addClass('Icons');
                    $Icon = $('<i />').addClass('fa');

                    // Mark appointment with appropriate icon(s)
                    if (CalEvent.allDay) {
                        $Icon.clone()
                            .addClass('fa-sun-o')
                            .appendTo($IconContainer);
                    }
                    if (CalEvent.recurring) {
                        $Icon.clone()
                            .addClass('fa-repeat')
                            .appendTo($IconContainer);
                    }
                    if (CalEvent.parentId) {
                        $Icon.clone()
                            .addClass('fa-link')
                            .appendTo($IconContainer);
                    }
                    if (CalEvent.notification) {
                        $Icon.clone()
                            .addClass('fa-bell')
                            .appendTo($IconContainer);
                    }
                    if (CalEvent.ticketAppointmentType) {
                        $Icon.clone()
                            .addClass('fa-char-' + Core.Config.Get('TicketAppointmentConfig')[CalEvent.ticketAppointmentType].Mark)
                            .appendTo($IconContainer);
                    }

                    // Prepend container to the appointment
                    $Element.find('.fc-content')
                        .prepend($IconContainer);
                }
            },
            eventResizeStart: function(CalEvent) {
                CurrentAppointment.start = CalEvent.start;
                CurrentAppointment.end = CalEvent.end;
            },
            eventDragStart: function(CalEvent) {
                CurrentAppointment.start = CalEvent.start;
                CurrentAppointment.end = CalEvent.end;
                CurrentAppointment.resourceIds = CalEvent.resourceIds;
            },
            eventMouseover: function(CalEvent, JSEvent) {
                var $TooltipObj,
                    PosX = 0,
                    PosY = 0,
                    TooltipHTML = Core.Template.Render('Agent/AppointmentCalendar/AppointmentTooltip', {
                        'PluginList': Core.Config.Get('PluginList'),
                        'CalEvent': CalEvent,
                        'TooltipTemplateResource': Core.Config.Get('TooltipTemplateResource') || 0,
                        'TicketAppointmentConfig': Core.Config.Get('TicketAppointmentConfig')
                    }),
                    DocumentVisibleLeft = $(document).scrollLeft() + $(window).width(),
                    DocumentVisibleTop = $(document).scrollTop() + $(window).height(),
                    LastXPosition,
                    LastYPosition;

                if (!JSEvent) {
                    JSEvent = window.event;
                }
                if (JSEvent.pageX || JSEvent.pageY) {
                    PosX = JSEvent.pageX;
                    PosY = JSEvent.pageY;
                } else if (JSEvent.clientX || JSEvent.clientY) {
                    PosX = JSEvent.clientX + document.body.scrollLeft + document.documentElement.scrollLeft;
                    PosY = JSEvent.clientY + document.body.scrollTop + document.documentElement.scrollTop;
                }

                // Increase positions so the tooltip do not overlap with mouse pointer
                PosX += 10;
                PosY += 10;

                if (TooltipHTML.length > 0) {

                    // Create tooltip object
                    $TooltipObj = $(TooltipHTML)
                        .offset({
                            top: PosY,
                            left: PosX
                        })
                        .appendTo('body');

                    // Re-calculate top position if needed
                    LastYPosition = PosY + $TooltipObj.height();
                    if (LastYPosition > DocumentVisibleTop) {
                        PosY = PosY - $TooltipObj.height();
                        $TooltipObj.css('top', PosY + 'px');
                    }

                    // Re-calculate left position if needed
                    LastXPosition = PosX + $TooltipObj.width();
                    if (LastXPosition > DocumentVisibleLeft) {
                        PosX = PosX - $TooltipObj.width() - 30;
                        $TooltipObj.css('left', PosX + 'px');
                    }

                    // Show the tooltip
                    $TooltipObj.fadeIn('fast');
                }
            },
            eventMouseout: function() {
                $('.AppointmentTooltip').fadeOut("fast").remove();
            },
            eventAfterAllRender: function () {

                // If the first day in timelineMonth view is not Saturday or Sunday, the first div.fc-bgevent should be removed.
                // There is a bug from fullcalendar and it can be solved here. See bug#14764.
                if (!$('.fc-timelineMonth-view .fc-slats td.fc-widget-content:eq(0)').hasClass('fc-sat')
                    && !$('.fc-timelineMonth-view .fc-slats td.fc-widget-content:eq(0)').hasClass('fc-sun')) {
                    $('.fc-timelineMonth-view .fc-bgevent-container .fc-bgevent:eq(0)').remove();
                }
            },
            events: Core.Config.Get('WorkingHoursConfig'),
            resources: ResourceConfig,
            resourceColumns: [
                {
                    labelText: Core.Language.Translate('Name'),
                    field: 'title'
                }
            ],
            resourceLabelText: Core.Language.Translate('Resources')
        });

        // Initialize datepicker
        $DatepickerObj.datepicker({
            showOn: 'button',
            buttonText: Core.Language.Translate('Jump'),
            constrainInput: true,
            prevText: Core.Language.Translate('Previous'),
            nextText: Core.Language.Translate('Next'),
            firstDay: Core.Config.Get('CalendarWeekDayStart'),
            showMonthAfterYear: 0,
            monthNames: [
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
            monthNamesShort: [
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
                Core.Language.Translate('Sun'),
                Core.Language.Translate('Mon'),
                Core.Language.Translate('Tue'),
                Core.Language.Translate('Wed'),
                Core.Language.Translate('Thu'),
                Core.Language.Translate('Fri'),
                Core.Language.Translate('Sat')
            ],
            dayNamesMin: [
                Core.Language.Translate('Su'),
                Core.Language.Translate('Mo'),
                Core.Language.Translate('Tu'),
                Core.Language.Translate('We'),
                Core.Language.Translate('Th'),
                Core.Language.Translate('Fr'),
                Core.Language.Translate('Sa')
            ],
            isRTL: Core.Config.Get('IsRTLLanguage'),
            onSelect: function(DateText) {
                $CalendarObj.fullCalendar('gotoDate', new Date(DateText));
                $('#DatepickerOverlay').remove();
                $DatepickerObj.hide();
            },
            beforeShowDay: function(DateObject) {
                if (AppointmentDaysCacheRefreshed) {
                    return CheckDate(DateObject);
                } else {
                    return [true];
                }
            },
            onChangeMonthYear: function(Year, Month) {
                AppointmentDays($DatepickerObj, Year, Month);
            }
        });

        $.each(CalendarConfig, function (Index, Calendar) {
            CalendarSources[Calendar.CalendarID] = {
                url: Core.Config.Get('CGIHandle'),
                type: 'POST',
                data: {
                    ChallengeToken: $("#ChallengeToken").val(),
                    Action: 'AgentAppointmentList',
                    Subaction: 'ListAppointments',
                    CalendarID: Calendar.CalendarID,
                    ResourceID: Core.Config.Get('ResourceID'),
                    TeamID: Core.Config.Get('TeamID')
                },
                color: Calendar.Color,
                textColor: Calendar.TextColor,
                borderColor: 'rgba(0, 0, 0, 0.2)',
                startParam: 'StartTime',
                endParam: 'EndTime',

                // Workaround for removeEventSource.
                googleCalendarId: Calendar.CalendarID,

                eventDataTransform: function(AppointmentData) {
                    var TicketAppointmentConfig = Core.Config.Get('TicketAppointmentConfig');

                    return {
                        id: AppointmentData.AppointmentID,
                        parentId: AppointmentData.ParentID,
                        start: AppointmentData.StartTime,
                        startDate: AppointmentData.StartDate,
                        end: AppointmentData.EndTime,
                        endDate: AppointmentData.EndDate,
                        title: AppointmentData.Title,
                        description: AppointmentData.Description,
                        location: AppointmentData.Location,
                        calendarId: AppointmentData.CalendarID,
                        allDay: parseInt(AppointmentData.AllDay, 10) ? true : false,
                        recurring: parseInt(AppointmentData.Recurring, 10) ? true : false,
                        teamIds: AppointmentData.TeamID,
                        teamNames: AppointmentData.TeamNames,
                        resourceIds: AppointmentData.ResourceID,
                        resourceNames: AppointmentData.ResourceNames,
                        pluginData: AppointmentData.PluginData,
                        calendarName: Calendar.CalendarName,
                        calendarColor: Calendar.Color,
                        notification: AppointmentData.NotificationDate.length ? true : false,
                        notificationDate: AppointmentData.NotificationDate,
                        ticketAppointmentType: AppointmentData.TicketAppointmentStartDate,
                        startEditable: typeof AppointmentData.TicketAppointmentStartDate === 'undefined' ? true :
                            typeof TicketAppointmentConfig[AppointmentData.TicketAppointmentStartDate].NoDrag !== 'undefined' ? false : true,
                        durationEditable: typeof AppointmentData.TicketAppointmentEndDate === 'undefined' ? true :
                            typeof TicketAppointmentConfig[AppointmentData.TicketAppointmentStartDate].NoDrag !== 'undefined' ? true : false
                    };
                }
            };
        });

        $('.CalendarSwitch input[type="checkbox"]').each(function () {
            CalendarSwitchInit($(this));
        });

        // Auto open appointment create screen.
        if (Core.Config.Get('AppointmentCreate')) {
            TargetNS.OpenEditDialog({
                Start: Core.Config.Get('AppointmentCreate').Start ? $.fullCalendar.moment(Core.Config.Get('AppointmentCreate').Start) : $.fullCalendar.moment().add(1, 'hours').startOf('hour'),
                End: Core.Config.Get('AppointmentCreate').End ? $.fullCalendar.moment(Core.Config.Get('AppointmentCreate').End) : $.fullCalendar.moment().add(2, 'hours').startOf('hour'),
                PluginKey: Core.Config.Get('AppointmentCreate').PluginKey ? Core.Config.Get('AppointmentCreate').PluginKey : null,
                Search: Core.Config.Get('AppointmentCreate').Search ? Core.Config.Get('AppointmentCreate').Search : null,
                ObjectID: Core.Config.Get('AppointmentCreate').ObjectID ? Core.Config.Get('AppointmentCreate').ObjectID : null
            });
        }

        // Auto open appointment edit screen
        else if (Core.Config.Get('AppointmentID')) {
            TargetNS.OpenEditDialog({ CalEvent: { id: Core.Config.Get('AppointmentID') } });
        }

        $('#AppointmentCreateButton')
            .off('click.AppointmentCalendar')
            .on('click.AppointmentCalendar', function () {
                TargetNS.OpenEditDialog({
                    Start: $.fullCalendar.moment().add(1, 'hours').startOf('hour'),
                    End: $.fullCalendar.moment().add(2, 'hours').startOf('hour')
                });

                return false;
            });

        CalendarSettingsInit();

        ResourceSettingsInit();

        $('#Team').on('change', function() {
            $('#ChangeTeamForm').submit();
        });

        Core.UI.Table.InitTableFilter($('#FilterCalendars'), $('#Calendars'));

        ClipboardJS.on('success', function (Event) {
            $(Event.trigger).hide()
                .fadeIn();
            Event.clearSelection();
        });

        ClipboardJS.on('error', function(Event) {
            Core.Form.ErrorTooltips.InitTooltip($(Event.trigger), Core.Language.Translate('Press Ctrl+C (Cmd+C) to copy to clipboard'));
            $(Event.trigger).focus();
        });
    };

    /**
     * @private
     * @name ShowDatepicker
     * @memberof Core.Agent.AppointmentCalendar
     * @param {jQueryObject} $CalendarObj - Calendar control object.
     * @param {jQueryObject} $DatepickerObj - Datepicker control object.
     * @param {jQueryObject} $JumpButton - Datepicker button object.
     * @description
     *      Show date picker control.
     */
    function ShowDatepicker($CalendarObj, $DatepickerObj, $JumpButton) {
        var CurrentDate = $CalendarObj.fullCalendar('getDate'),
            Year = CurrentDate.format('YYYY'),
            Month = CurrentDate.format('M');

        $('<div />').prop('id', 'DatepickerOverlay')
            .appendTo($('body'))
            .on('click.AppointmentCalendar', function () {
                $(this).remove();
                $DatepickerObj.hide();
            });

        AppointmentDays($DatepickerObj, Year, Month);

        $DatepickerObj.datepicker('setDate', CurrentDate.toDate())
            .css({
                left: parseInt($JumpButton.offset().left - $DatepickerObj.outerWidth() + $JumpButton.outerWidth(), 10),
                top: parseInt($JumpButton.offset().top - $DatepickerObj.outerHeight() + $JumpButton.outerHeight(), 10)
            }).fadeIn('fast');
    }

    /**
     * @private
     * @name CheckDate
     * @memberof Core.Agent.AppointmentCalendar
     * @function
     * @param {DateObject} DateObject - A JS date object to check.
     * @returns {Array} First element is always true, second element contains the name of a CSS
     *                  class, third element a description for the date.
     * @description
     *      Check if date has an appointment.
     */
    function CheckDate(DateObject) {
        var DateMoment = $.fullCalendar.moment(DateObject),
            DayAppointments = AppointmentDaysCache[DateMoment.format('YYYY-MM-DD')],
            DayClass = DayAppointments ? 'Highlight' : '',
            DayDescription = DayAppointments ? DayAppointments.toString() : '';

        return [true, DayClass, DayDescription];
    }

    /**
     * @private
     * @name AppointmentDays
     * @memberof Core.Agent.AppointmentCalendar
     * @param {jQueryObject} $DatepickerObj - Datepicker control object.
     * @param {Integer} Year - Selected year.
     * @param {Integer} Month - Selected month (1-12).
     * @description
     *      Caches the list of appointment days for later use.
     */
    function AppointmentDays($DatepickerObj, Year, Month) {
        var StartTime = $.fullCalendar.moment(Year + '-' + Month, 'YYYY-M').startOf('month'),
            EndTime = $.fullCalendar.moment(Year + '-' + Month, 'YYYY-M').add(1, 'months').startOf('month'),
            Data = {
                ChallengeToken: $('#ChallengeToken').val(),
                Action: 'AgentAppointmentList',
                Subaction: 'AppointmentDays',
                StartTime: StartTime.format('YYYY-MM-DD'),
                EndTime: EndTime.format('YYYY-MM-DD')
            };

        $DatepickerObj.addClass('AJAXLoading');
        AppointmentDaysCacheRefreshed = false;

        Core.AJAX.FunctionCall(
            Core.Config.Get('CGIHandle'),
            Data,
            function (Response) {
                if (Response) {
                    AppointmentDaysCache = Response;
                    AppointmentDaysCacheRefreshed = true;
                    $DatepickerObj.removeClass('AJAXLoading');

                    // Refresh the date picker because this call is asynchronous
                    $DatepickerObj.datepicker('refresh');
                }
            }
        );
    }

    /**
     * @public
     * @name ShowWaitingDialog
     * @memberof Core.Agent.AppointmentCalendar
     * @description
     *      Shows waiting dialog.
     */
    TargetNS.ShowWaitingDialog = function () {
        Core.UI.Dialog.ShowContentDialog('<div class="Spacing Center"><span class="AJAXLoader" title="' + Core.Language.Translate('Loading...') + '"></span></div>', Core.Language.Translate('Loading...'), '10px', 'Center', true);
    }

    /**
     * @public
     * @name OpenEditDialog
     * @memberof Core.Agent.AppointmentCalendar
     * @param {Object} AppointmentData - Hash with appointment data.
     * @param {Moment} AppointmentData.Start - Moment object with start date/time.
     * @param {Moment} AppointmentData.End - Moment object with end date/time.
     * @param {Object} AppointmentData.CalEvent - Calendar event object (FullCalendar).
     * @param {Object} AppointmentData.Resource - Calendar resource object (FullCalendar).
     * @description
     *      This method opens the appointment dialog after selecting a time period or an appointment.
     */
    TargetNS.OpenEditDialog = function (AppointmentData) {
        var Data = {
            ChallengeToken: $('#ChallengeToken').val(),
            Action: 'AgentAppointmentEdit',
            Subaction: 'EditMask',
            AppointmentID: AppointmentData.CalEvent ? AppointmentData.CalEvent.id : null,
            StartYear: !AppointmentData.CalEvent ? AppointmentData.Start.year() : null,
            StartMonth: !AppointmentData.CalEvent ? AppointmentData.Start.month() + 1 : null,
            StartDay: !AppointmentData.CalEvent ? AppointmentData.Start.date() : null,
            StartHour: !AppointmentData.CalEvent ? AppointmentData.Start.hour() : null,
            StartMinute: !AppointmentData.CalEvent ? AppointmentData.Start.minute() : null,
            EndYear: !AppointmentData.CalEvent ? AppointmentData.End.year() : null,
            EndMonth: !AppointmentData.CalEvent ? AppointmentData.End.month() + 1 : null,
            EndDay: !AppointmentData.CalEvent ? AppointmentData.End.date() : null,
            EndHour: !AppointmentData.CalEvent ? AppointmentData.End.hour() : null,
            EndMinute: !AppointmentData.CalEvent ? AppointmentData.End.minute() : null,
            AllDay: !AppointmentData.CalEvent ? (AppointmentData.End.hasTime() ? '0' : '1') : null,
            TeamID: AppointmentData.Resource ? [ AppointmentData.Resource.TeamID ] : null,
            ResourceID: AppointmentData.Resource ? [ AppointmentData.Resource.id ] : null,
            PluginKey: AppointmentData.PluginKey ? AppointmentData.PluginKey : null,
            Search: AppointmentData.Search ? AppointmentData.Search : null,
            ObjectID: AppointmentData.ObjectID ? AppointmentData.ObjectID : null
        };

        // Make end time for all day appointments inclusive
        if (Data.AllDay && Data.AllDay === '1') {
            AppointmentData.End.subtract(1, 'day');
            Data.EndYear = AppointmentData.End.year();
            Data.EndMonth = AppointmentData.End.month() + 1;
            Data.EndDay = AppointmentData.End.date();
            Data.EndHour = AppointmentData.End.hour();
            Data.EndMinute = AppointmentData.End.minute();
        }

        function EditDialog() {
            TargetNS.ShowWaitingDialog();
            Core.AJAX.FunctionCall(
                Core.Config.Get('CGIHandle'),
                Data,
                function (HTML) {
                    Core.UI.Dialog.ShowContentDialog(HTML, Core.Language.Translate('Appointment'), '10px', 'Center', true, undefined, true);
                    Core.UI.InputFields.Activate($('.Dialog:visible'));

                    TargetNS.AgentAppointmentEdit();
                }, 'html'
            );
        }

        // Repeating event
        if (AppointmentData.CalEvent && AppointmentData.CalEvent.parentId) {
            Core.UI.Dialog.ShowDialog({
                Title: Core.Language.Translate('This is a repeating appointment'),
                HTML: Core.Language.Translate('Would you like to edit just this occurrence or all occurrences?'),
                Modal: true,
                CloseOnClickOutside: true,
                CloseOnEscape: true,
                PositionTop: '20%',
                PositionLeft: 'Center',
                Buttons: [
                    {
                        Label: Core.Language.Translate('All occurrences'),
                        Class: 'Primary CallForAction',
                        Function: function() {
                            Data.AppointmentID = AppointmentData.CalEvent.parentId;
                            EditDialog();
                        }
                    },
                    {
                        Label: Core.Language.Translate('Just this occurrence'),
                        Class: 'CallForAction',
                        Function: EditDialog
                    },
                    {
                        Type: 'Close',
                        Label: Core.Language.Translate('Close this dialog')
                    }
                ]
            });
        } else {
            EditDialog();
        }
    }

    /**
     * @private
     * @name UpdateAppointment
     * @memberof Core.Agent.AppointmentCalendar
     * @param {Object} AppointmentData - Hash with appointment data.
     * @param {Object} AppointmentData.CalEvent - Calendar event object (FullCalendar).
     * @description
     *      This method updates the appointment with supplied data.
     */
    function UpdateAppointment(AppointmentData) {
        var Data = {
            ChallengeToken: $('#ChallengeToken').val(),
            Action: 'AgentAppointmentEdit',
            Subaction: 'EditAppointment',
            AppointmentID: AppointmentData.CalEvent.id,
            StartYear: AppointmentData.CalEvent.start.year(),
            StartMonth: AppointmentData.CalEvent.start.month() + 1,
            StartDay: AppointmentData.CalEvent.start.date(),
            StartHour: AppointmentData.CalEvent.start.hour(),
            StartMinute: AppointmentData.CalEvent.start.minute(),
            EndYear: AppointmentData.CalEvent.end.year(),
            EndMonth: AppointmentData.CalEvent.end.month() + 1,
            EndDay: AppointmentData.CalEvent.end.date(),
            EndHour: AppointmentData.CalEvent.end.hour(),
            EndMinute: AppointmentData.CalEvent.end.minute(),
            AllDay: AppointmentData.CalEvent.end.hasTime() ? '0' : '1',
            Recurring: AppointmentData.CalEvent.recurring ? '1' : '0',
            TeamID: AppointmentData.CalEvent.teamIds ? AppointmentData.CalEvent.teamIds : undefined,
            ResourceID: AppointmentData.CalEvent.resourceIds ? AppointmentData.CalEvent.resourceIds :
                AppointmentData.CalEvent.resourceId ? [ AppointmentData.CalEvent.resourceId ] : undefined
        };

        // Assigned resource didn't change
        if (
            AppointmentData.CalEvent.resourceId
            && AppointmentData.PreviousAppointment.resourceIds
            && $.inArray(
                AppointmentData.CalEvent.resourceId,
                AppointmentData.PreviousAppointment.resourceIds
            ) !== -1
        ) {
            Data.ResourceID = AppointmentData.PreviousAppointment.resourceIds;
        }

        function Update() {
            Core.UI.Dialog.CloseDialog($('.Dialog:visible'));
            Core.AJAX.FunctionCall(
                Core.Config.Get('CGIHandle'),
                Data,
                function (Response) {
                    if (Response.Success) {
                        $('#calendar').fullCalendar('refetchEvents');
                    } else {
                        AppointmentData.RevertFunc();
                    }

                    // Close the dialog
                    Core.UI.Dialog.CloseDialog($('.Dialog:visible'));
                }
            );
        }

        // Make end time for all day appointments inclusive
        if (AppointmentData.CalEvent.allDay) {
            AppointmentData.CalEvent.end.subtract(1, 'day');
            Data.EndYear = AppointmentData.CalEvent.end.year();
            Data.EndMonth = AppointmentData.CalEvent.end.month() + 1;
            Data.EndDay = AppointmentData.CalEvent.end.date();
            Data.EndHour = AppointmentData.CalEvent.end.hour();
            Data.EndMinute = AppointmentData.CalEvent.end.minute();
        }

        // Repeating event
        if (AppointmentData.CalEvent.parentId) {
            Core.UI.Dialog.ShowDialog({
                Title: Core.Language.Translate('This is a repeating appointment'),
                HTML: Core.Language.Translate('Would you like to edit just this occurrence or all occurrences?'),
                Modal: true,
                CloseOnClickOutside: true,
                CloseOnEscape: true,
                PositionTop: '20%',
                PositionLeft: 'Center',
                Buttons: [
                    {
                        Label: Core.Language.Translate('All occurrences'),
                        Class: 'Primary CallForAction',
                        Function: function() {
                            Data.AppointmentID = AppointmentData.CalEvent.parentId;
                            Data.Recurring = '1';
                            Data.UpdateDelta = AppointmentData.Delta.asSeconds();
                            if (
                                AppointmentData.CalEvent.start.diff(AppointmentData.PreviousAppointment.start, 'seconds')
                                === Data.UpdateDelta
                                &&
                                AppointmentData.CalEvent.end.diff(AppointmentData.PreviousAppointment.end, 'seconds')
                                === Data.UpdateDelta
                            ) {
                                Data.UpdateType = 'Both';
                            }
                            else if (
                                AppointmentData.PreviousAppointment.start.diff(AppointmentData.CalEvent.start, 'seconds')
                                === Data.UpdateDelta
                            ) {
                                Data.UpdateType = 'StartTime';
                                Data.UpdateDelta = Data.UpdateDelta * -1;
                            }
                            else if (
                                AppointmentData.CalEvent.end.diff(AppointmentData.PreviousAppointment.end, 'seconds')
                                === Data.UpdateDelta
                            ) {
                                Data.UpdateType = 'EndTime';
                            }
                            Update();
                        }
                    },
                    {
                        Label: Core.Language.Translate('Just this occurrence'),
                        Class: 'CallForAction',
                        Function: function() {
                            AppointmentData.CalEvent.parentId = null;
                            Update();
                        }
                    },
                    {
                        Type: 'Close',
                        Label: Core.Language.Translate('Close this dialog'),
                        Function: function() {
                            Core.UI.Dialog.CloseDialog($('.Dialog:visible'));
                            AppointmentData.RevertFunc();
                        }
                    }
                ]
            });
        } else {
            Update();
        }
    }

    /**
     * @private
     * @name CalendarSwitchInit
     * @memberof Core.Agent.AppointmentCalendar
     * @param {jQueryObject} $CalendarSwitch - calendar checkbox element.
     * @description
     *      This method initializes calendar checkbox behavior and loads multiple calendars to the
     *      FullCalendar control.
     */
    function CalendarSwitchInit($CalendarSwitch) {

        // Initialize enabled sources
        if ($CalendarSwitch.prop('checked')) {
            $('#calendar').fullCalendar('addEventSource', CalendarSources[$CalendarSwitch.data('id')]);
        }

        // Register change event handler
        $CalendarSwitch.off('change.AppointmentCalendar').on('change.AppointmentCalendar', function() {
            if ($('.CalendarSwitch input:checked').length > Core.Config.Get('CalendarLimit')) {
                $CalendarSwitch.prop('checked', false);
                Core.UI.Dialog.ShowAlert(Core.Language.Translate('Too many active calendars'), Core.Language.Translate('Please either turn some off first or increase the limit in configuration.'));
            } else {
                CalendarSwitchSource($CalendarSwitch);
            }
        });
    }

    /**
     * @private
     * @name CalendarSwitchSource
     * @memberof Core.Agent.AppointmentCalendar
     * @param {jQueryObject} $CalendarSwitch - calendar checkbox element.
     * @description
     *      This method enables/disables calendar source in FullCalendar control and stores
     *      selection to user preferences.
     */
    function CalendarSwitchSource($CalendarSwitch) {
        var CalendarSelection = [];

        // Show/hide the calendar appointments
        if ($CalendarSwitch.prop('checked')) {
            $('#calendar').fullCalendar('addEventSource', CalendarSources[$CalendarSwitch.data('id')]);
        } else {
            $('#calendar').fullCalendar('removeEventSource', CalendarSources[$CalendarSwitch.data('id')]);
        }

        // Get all checked calendars
        $.each($('.CalendarSwitch input:checked'), function (Index, Element) {
            CalendarSelection.push($(Element).data('id'));
        });

        // Store selection in user preferences
        Core.AJAX.FunctionCall(
            Core.Config.Get('CGIHandle'),
            {
                ChallengeToken: $('#ChallengeToken').val(),
                Action: 'AgentAppointmentEdit',
                Subaction: 'UpdatePreferences',
                OverviewScreen: Core.Config.Get('OverviewScreen') ? Core.Config.Get('OverviewScreen') : 'CalendarOverview',
                CalendarSelection: JSON.stringify(CalendarSelection)
            },
            function (Response) {
                if (!Response.Success) {
                    Core.Debug.Log('Error updating user preferences!');
                }
            }
        );
    }

    /**
     * @name LocationLinkInit
     * @memberof Core.Agent.AppointmentCalendar
     * @param {jQueryObject} $LocationObj - location field.
     * @param {jQueryObject} $LocationLinks - location links.
     * @description
     *      This method initializes location link behavior.
     */
    TargetNS.LocationLinkInit = function ($LocationObj, $LocationLinks) {
        var LocationValue = $LocationObj.val() || $LocationObj.text();

        $LocationLinks.each(function (Index, Element) {
            var $LinkObj = $(Element),
                BaseURL  = $LinkObj.data('baseUrl');

            // Update link URL and show it if location is set
            if (LocationValue.length > 0 && LocationValue !== '-') {
                $LinkObj.attr('href', BaseURL + encodeURIComponent(LocationValue))
                    .fadeIn('fast');
            }

            // Otherwise, hide the link
            else {
                $LinkObj.fadeOut('fast');
            }
        });

        // Register key up event handler
        $LocationObj.off('keyup.AppointmentCalendar').on('keyup.AppointmentCalendar', function() {
            TargetNS.LocationLinkInit($LocationObj, $LocationLinks);
        });
    }

    /**
     * @name AllDayInit
     * @memberof Core.Agent.AppointmentCalendar
     * @param {jQueryObject} $AllDay - all day checkbox element.
     * @description
     *      This method initializes all day checkbox behavior.
     */
    TargetNS.AllDayInit = function ($AllDay) {
        if ($('#StartMonth:disabled').length > 0) {
            return;
        }

        // Show/hide the start hour/minute and complete end time
        if ($AllDay.prop('checked')) {
            $('#StartHour,#StartMinute,#EndHour,#EndMinute').val('0')
                .prop('disabled', true)
                .prop('readonly', true);
        } else {
            $('#StartHour,#StartMinute,#EndHour,#EndMinute')
                .prop('disabled', false)
                .prop('readonly', false);
        }

        // Register change event handler
        $AllDay.off('change.AppointmentCalendar').on('change.AppointmentCalendar', function() {
            TargetNS.AllDayInit($AllDay);
        });
    }

    /**
     * @name RecurringInit
     * @memberof Core.Agent.AppointmentCalendar
     * @param {Object} Fields - Array with references to recurring fields.
     * @param {jQueryObject} Fields.$Recurring - field with recurring flag.
     * @param {jQueryObject} Fields.$RecurrenceType - drop down with recurrence type
     * @param {jQueryObject} Fields.$RecurrenceCustomType - Recurrence pattern
     * @param {jQueryObject} Fields.$RecurrenceCustomTypeStringDiv - Custom type drop-down
     * @param {jQueryObject} Fields.$RecurrenceIntervalText - interval text
     * @param {jQueryObject} Fields.$RecurrenceCustomWeeklyDiv - contains week days table
     * @param {jQueryObject} Fields.$RecurrenceCustomMonthlyDiv - contains month days table
     * @param {jQueryObject} Fields.$RecurrenceCustomYearlyDiv - contains months table
     * @param {jQueryObject} Fields.$RecurrenceLimitDiv - layer with recurrence limit fields.
     * @param {jQueryObject} Fields.$RecurrenceLimit - drop down with recurrence limit field.
     * @param {jQueryObject} Fields.$RecurrenceCountDiv - layer with reccurence count field.
     * @param {jQueryObject} Fields.$RecurrenceUntilDiv - layer with reccurence until fields.
     * @param {jQueryObject} Fields.$RecurrenceUntilDay - select field for reccurence until day.
     * @description
     *      This method initializes recurrence fields behavior.
     */
    TargetNS.RecurringInit = function (Fields) {

        function RecInit(Fields) {
            var Days = [],
                MonthDays = [],
                Months = [],
                Index;

            if ($('input#Days').length) {
                Days = $('input#Days').val().split(',');
            }
            if ($('input#MonthDays').length) {
                MonthDays = $('input#MonthDays').val().split(',');
            }
            if ($('input#MonthDays').length) {
                Months = $('input#Months').val().split(',');
            }

            for (Index = 0; Index < Days.length; Index++) {
                if (Days[Index] != "") {
                    $("#RecurrenceCustomWeeklyDiv button[value=" + Days[Index] + "]")
                        .addClass("fc-state-active");
                }
            }

            for (Index = 0; Index < MonthDays.length; Index++) {
                if (MonthDays[Index] != "") {
                    $("#RecurrenceCustomMonthlyDiv button[value=" + MonthDays[Index] + "]")
                        .addClass("fc-state-active");
                }
            }

            for (Index = 0; Index < Months.length; Index++) {
                if (Months[Index] != "") {
                    $("#RecurrenceCustomYearlyDiv button[value=" + Months[Index] + "]")
                        .addClass("fc-state-active");
                }
            }

            if (Fields.$RecurrenceType.val() == 0) {
                Fields.$Recurring.val(0);
                Fields.$RecurrenceCustomTypeStringDiv.hide();
                Fields.$RecurrenceCustomWeeklyDiv.hide();
                Fields.$RecurrenceCustomMonthlyDiv.hide();
                Fields.$RecurrenceCustomYearlyDiv.hide();

                Fields.$RecurrenceLimitDiv.hide();
                Fields.$RecurrenceCountDiv.hide();
                Fields.$RecurrenceUntilDiv.hide();

                // Skip validation of RecurrenceUntil fields
                Fields.$RecurrenceUntilDay.addClass('ValidationIgnore');
            }
            else if (Fields.$RecurrenceType.val() == 'Custom') {
                Fields.$Recurring.val(1);
                Fields.$RecurrenceCustomTypeStringDiv.show();

                if (Fields.$RecurrenceCustomType.val()=="CustomDaily") {
                    Fields.$RecurrenceCustomWeeklyDiv.hide();
                    Fields.$RecurrenceCustomMonthlyDiv.hide();
                    Fields.$RecurrenceCustomYearlyDiv.hide();
                    Fields.$RecurrenceIntervalText.find('span')
                        .hide()
                        .end()
                        .find('.TextDay')
                        .show();
                }
                else if (Fields.$RecurrenceCustomType.val()=="CustomWeekly") {
                    Fields.$RecurrenceCustomWeeklyDiv.show();

                    Fields.$RecurrenceCustomMonthlyDiv.hide();
                    Fields.$RecurrenceCustomYearlyDiv.hide();
                    Fields.$RecurrenceIntervalText.find('span')
                        .hide()
                        .end()
                        .find('.TextWeek')
                        .show();
                }
                else if (Fields.$RecurrenceCustomType.val()=="CustomMonthly") {
                    Fields.$RecurrenceCustomMonthlyDiv.show();

                    Fields.$RecurrenceCustomWeeklyDiv.hide();
                    Fields.$RecurrenceCustomYearlyDiv.hide();
                    Fields.$RecurrenceIntervalText.find('span')
                        .hide()
                        .end()
                        .find('.TextMonth')
                        .show();
                }
                else if (Fields.$RecurrenceCustomType.val()=="CustomYearly") {
                    Fields.$RecurrenceCustomYearlyDiv.show();

                    Fields.$RecurrenceCustomWeeklyDiv.hide();
                    Fields.$RecurrenceCustomMonthlyDiv.hide();
                    Fields.$RecurrenceIntervalText.find('span')
                        .hide()
                        .end()
                        .find('.TextYear')
                        .show();
                }

                Fields.$RecurrenceLimitDiv.show();
                Fields.$RecurrenceLimit.off('change.AppointmentCalendar').on('change.AppointmentCalendar', function() {
                    if ($(this).val() == 1) {
                        Fields.$RecurrenceCountDiv.hide();
                        Fields.$RecurrenceUntilDiv.show();

                        // Resume validation of RecurrenceUntil fields
                        Fields.$RecurrenceUntilDay.removeClass('ValidationIgnore');
                    } else {
                        Fields.$RecurrenceUntilDiv.hide();
                        Fields.$RecurrenceCountDiv.show();

                        // Skip validation of RecurrenceUntil fields
                        Fields.$RecurrenceUntilDay.addClass('ValidationIgnore');
                    }
                }).trigger('change.AppointmentCalendar');

                Core.UI.InputFields.Activate(Fields.$RecurrenceCustomTypeStringDiv);
                Core.UI.InputFields.Activate(Fields.$RecurrenceLimitDiv);
            }
            else {
                Fields.$Recurring.val(1);
                Fields.$RecurrenceLimitDiv.show();

                Fields.$RecurrenceCustomTypeStringDiv.hide();
                Fields.$RecurrenceCustomWeeklyDiv.hide();
                Fields.$RecurrenceCustomMonthlyDiv.hide();
                Fields.$RecurrenceCustomYearlyDiv.hide();

                Fields.$RecurrenceLimit.off('change.AppointmentCalendar').on('change.AppointmentCalendar', function() {
                    if ($(this).val() == 1) {
                        Fields.$RecurrenceCountDiv.hide();
                        Fields.$RecurrenceUntilDiv.show();

                        // Resume validation of RecurrenceUntil fields
                        Fields.$RecurrenceUntilDay.removeClass('ValidationIgnore');
                    } else {
                        Fields.$RecurrenceUntilDiv.hide();
                        Fields.$RecurrenceCountDiv.show();

                        // Skip validation of RecurrenceUntil fields
                        Fields.$RecurrenceUntilDay.addClass('ValidationIgnore');
                    }
                }).trigger('change.AppointmentCalendar');
                Core.UI.InputFields.Activate(Fields.$RecurrenceLimitDiv);
            }

            Fields.$RecurrenceCustomType.off('change.AppointmentCalendar').on('change.AppointmentCalendar', function() {
                TargetNS.RecurringInit(Fields);
            });
        }

        Fields.$RecurrenceType.off('change.AppointmentCalendar').on('change.AppointmentCalendar', function() {
            RecInit(Fields);
        }).trigger('change.AppointmentCalendar');
    }

    /**
     * @name NotificationInit
     * @memberof Core.Agent.AppointmentCalendar
     * @param {Object} Fields - Array with references to reminder fields.
     * @param {jQueryObject} Fields.$Notification - drop down with system notification selection.
     * @param {jQueryObject} Fields.$NotificationCustomStringDiv - custom selection of system notification date
     * @description
     *      This method initializes the reminder section behavior.
     */
    TargetNS.NotificationInit = function (Fields) {
        var NotificationCustomStringDiv = Fields.$NotificationCustomStringDiv.attr('id');

        if (Fields.$NotificationTemplate.val() !== 'Custom') {

            // hide the custom fields
            Fields.$NotificationCustomStringDiv.hide();
        }
        else {

            // custom field is needed
            Fields.$NotificationCustomStringDiv.show();

            // initialize modern fields on custom selection
            Core.UI.InputFields.InitSelect($('select.Modernize'));
        }

        // disable enable the different custom fields
        if (Fields.$NotificationCustomRelativeInput.prop('checked')) {

            // enable relative date fields
            Fields.$NotificationCustomRelativeInput.val(1);
            Fields.$NotificationCustomRelativeUnitCount.prop('disabled', false).prop('readonly', false);
            Fields.$NotificationCustomRelativeUnit.prop('disabled', false);
            Fields.$NotificationCustomRelativePointOfTime.prop('disabled', false);

            // disable the custom date time fields
            Fields.$NotificationCustomDateTimeInput.val('');
            Fields.$NotificationCustomDateTimeDay.prop('disabled', true);
            Fields.$NotificationCustomDateTimeMonth.prop('disabled', true);
            Fields.$NotificationCustomDateTimeYear.prop('disabled', true);
            Fields.$NotificationCustomDateTimeHour.prop('disabled', true);
            Fields.$NotificationCustomDateTimeMinute.prop('disabled', true);
        }
        else {

            // enable the custom date time input
            Fields.$NotificationCustomDateTimeInput.val(1);
            Fields.$NotificationCustomDateTimeInput.prop('checked', true);
            Fields.$NotificationCustomDateTimeDay.prop('disabled', false);
            Fields.$NotificationCustomDateTimeMonth.prop('disabled', false);
            Fields.$NotificationCustomDateTimeYear.prop('disabled', false);
            Fields.$NotificationCustomDateTimeHour.prop('disabled', false);
            Fields.$NotificationCustomDateTimeMinute.prop('disabled', false);

            // disable relative date fields
            Fields.$NotificationCustomRelativeInput.val('');
            Fields.$NotificationCustomRelativeInput.prop('checked', false);
            Fields.$NotificationCustomRelativeUnitCount.prop('disabled', true).prop('readonly', true);
            Fields.$NotificationCustomRelativeUnit.prop('disabled', true);
            Fields.$NotificationCustomRelativePointOfTime.prop('disabled', true);
        }

        // TODO: Workaround for InputFields bug in the framework (disabled attribute not checked after initialization)
        Core.UI.InputFields.Deactivate('#' + Core.App.EscapeSelector(NotificationCustomStringDiv));
        Core.UI.InputFields.Activate('#' + Core.App.EscapeSelector(NotificationCustomStringDiv));

        // Register change event handler
        Fields.$NotificationTemplate.off('change.AppointmentCalendar').on('change.AppointmentCalendar', function() {
            TargetNS.NotificationInit(Fields);
        });

        Fields.$NotificationCustomRelativeInput.off('change.AppointmentCalendar').on('change.AppointmentCalendar', function() {

            // handle radio buttons
            Fields.$NotificationCustomRelativeInput.prop('checked', true);
            Fields.$NotificationCustomDateTimeInput.prop('checked', false);

            // process changes
            TargetNS.NotificationInit(Fields);
        });

        Fields.$NotificationCustomDateTimeInput.off('change.AppointmentCalendar').on('change.AppointmentCalendar', function() {

            // handle radio buttons
            Fields.$NotificationCustomDateTimeInput.prop('checked', true);
            Fields.$NotificationCustomRelativeInput.prop('checked', false);

            // process changes
            TargetNS.NotificationInit(Fields);
        });
    }

    /**
     * @name TeamInit
     * @memberof Core.Agent.AppointmentCalendar
     * @param {jQueryObject} $TeamIDObj - field with list of teams.
     * @param {jQueryObject} $ResourceIDObj - field with list of resources.
     * @param {jQueryObject} $TeamValueObj - field with read only values for team.
     * @param {jQueryObject} $ResourceValueObj - field with read only values for resources.
     * @description
     *      This method initializes team fields behavior.
     */
    TargetNS.TeamInit = function ($TeamIDObj, $ResourceIDObj, $TeamValueObj, $ResourceValueObj) {
        $TeamIDObj.off('change.AppointmentCalendar').on('change.AppointmentCalendar', function () {
            var Data = {
                ChallengeToken: $('#ChallengeToken').val(),
                Action: 'AgentAppointmentEdit',
                Subaction: 'TeamUserList',
                TeamID: $TeamIDObj.val()
            };

            ToggleAJAXLoader($ResourceIDObj, true);

            Core.AJAX.FunctionCall(
                Core.Config.Get('CGIHandle'),
                Data,
                function (Response) {
                    var SelectedID = $ResourceIDObj.val();
                    if (Response.TeamUserList) {
                        $ResourceIDObj.empty();
                        $.each(Response.TeamUserList, function (Index, Value) {
                            var NewOption = new Option(Value, Index);

                            // Overwrite option text, because of wrong html quoting of text content.
                            // (This is needed for IE.)
                            NewOption.innerHTML = Core.App.EscapeHTML(Value);

                            // Restore selection
                            if (SelectedID && SelectedID.indexOf(Index) > -1) {
                                NewOption.selected = true;
                            }

                            $ResourceIDObj.append(NewOption);
                        });

                        // Trigger custom redraw event for InputFields
                        $ResourceIDObj.trigger('redraw.InputField');
                    }
                    ToggleAJAXLoader($ResourceIDObj, false);
                }
            );
        });

        function CollapseValues($ValueObj, Values) {
            $ValueObj.html('');
            $.each(Values, function (Index, Value) {
                var Count = Values.length,
                    TooltipIndex = $('.Dialog').css('z-index');

                if (Index < 2) {
                    $ValueObj.html($ValueObj.html() + Value + '<br>');
                } else {
                    Values.splice(-Count, 2);
                    $('<a />').attr('href', '#')
                        .addClass('DialogTooltipLink')
                        .text(Core.Language.Translate('+%s more', Count-2))
                        .off('click.AppointmentCalendar')
                        .on('click.AppointmentCalendar', function (Event) {
                            var $TooltipObj,
                                PosX = 0,
                                PosY = 0,
                                TooltipHTML = '<p>' + Values.join('<br>') + '</p>',
                                DocumentVisibleLeft = $(document).scrollLeft() + $(window).width(),
                                DocumentVisibleTop = $(document).scrollTop() + $(window).height(),
                                LastXPosition,
                                LastYPosition;

                            // Close existing tooltips
                            $('.DialogTooltip').remove();

                            if (Event.pageX || Event.pageY) {
                                PosX = Event.pageX;
                                PosY = Event.pageY;
                            } else if (Event.clientX || Event.clientY) {
                                PosX = Event.clientX + document.body.scrollLeft + document.documentElement.scrollLeft;
                                PosY = Event.clientY + document.body.scrollTop + document.documentElement.scrollTop;
                            }

                            // Increase positions so the tooltip do not overlap with mouse pointer
                            PosX += 10;
                            PosY += 5;

                            if (typeof TooltipIndex !== 'undefined') {
                                TooltipIndex = parseInt(TooltipIndex, 10) + 500;
                            }
                            else{
                                TooltipIndex = 4000;
                            }

                            // Create tooltip object
                            $TooltipObj = $('<div/>').addClass('AppointmentTooltip DialogTooltip Hidden')
                                .offset({
                                    top: PosY,
                                    left: PosX
                                })
                                .html(TooltipHTML)
                                .css('z-index', TooltipIndex)
                                .css('width', 'auto')
                                .off('click.AppointmentCalendar')
                                .on('click.AppointmentCalendar', function (Event) {
                                    Event.stopPropagation();
                                })
                                .appendTo('body');

                            // Re-calculate top position if needed
                            LastYPosition = PosY + $TooltipObj.height();
                            if (LastYPosition > DocumentVisibleTop) {
                                PosY = PosY - $TooltipObj.height();
                                $TooltipObj.css('top', PosY + 'px');
                            }

                            // Re-calculate left position if needed
                            LastXPosition = PosX + $TooltipObj.width();
                            if (LastXPosition > DocumentVisibleLeft) {
                                PosX = PosX - $TooltipObj.width() - 30;
                                $TooltipObj.css('left', PosX + 'px');
                            }

                            // Show the tooltip
                            $TooltipObj.fadeIn('fast');

                            // Close tooltip on any outside click
                            $(document).off('click.AppointmentCalendar')
                                .on('click.AppointmentCalendar', function (Event) {
                                    $('.Close').on('click', function(){
                                        $('.DialogTooltip').remove();
                                    });
                                    if (!$(Event.target).closest('.DialogTooltipLink').length) {
                                        $('.DialogTooltip').remove();
                                        $(document).off('click.AppointmentCalendar');
                                    }
                                });
                        })
                        .appendTo($ValueObj);
                    return false;
                }
            });
        }

        // Collapse read only values
        if ($TeamValueObj.length) {
            CollapseValues($TeamValueObj, $TeamValueObj.html().split('<br>'));
        }
        if ($ResourceValueObj.length) {
            CollapseValues($ResourceValueObj, $ResourceValueObj.html().split('<br>'));
        }
    }

    /**
     * @private
     * @name CalendarSettingsInit
     * @memberof Core.Agent.AppointmentCalendar
     * @description
     *      This method initializes calendar settings behavior.
     */
    function CalendarSettingsInit() {
        var $CalendarSettingsObj = $('#CalendarSettingsButton'),
            CalendarSettingsDialogHTML;

        if (!$CalendarSettingsObj.length) {
            return;
        }

        CalendarSettingsDialogHTML = Core.Template.Render('Agent/AppointmentCalendar/CalendarSettingsDialog', {
            'ShownAppointmentsStrg': Core.Config.Get('ShownAppointmentsStrg')
        });

        // Calendar settings button
        $CalendarSettingsObj.off('click.AppointmentCalendar').on('click.AppointmentCalendar', function (Event) {
            Core.UI.Dialog.ShowContentDialog(CalendarSettingsDialogHTML, Core.Language.Translate('Settings'), '10px', 'Center', true,
                [
                    {
                        Label: Core.Language.Translate('Save'),
                        Class: 'Primary',
                        Function: function () {
                            var $ShownAppointments = $('#ShownAppointments'),
                                Data = {
                                    ChallengeToken: $('#ChallengeToken').val(),
                                    Action: 'AgentAppointmentEdit',
                                    Subaction: 'UpdatePreferences',
                                    OverviewScreen: Core.Config.Get('OverviewScreen') ? Core.Config.Get('OverviewScreen') : 'CalendarOverview',
                                    ShownAppointments: $ShownAppointments.val()
                                };

                            Core.Agent.AppointmentCalendar.ShowWaitingDialog();

                            Core.AJAX.FunctionCall(
                                Core.Config.Get('CGIHandle'),
                                Data,
                                function (Response) {
                                    if (!Response.Success) {
                                        Core.Debug.Log('Error updating user preferences!');
                                    }
                                    window.location.href = Core.Config.Get('Baselink') + 'Action=AgentAppointment' + (Core.Config.Get('OverviewScreen') ? Core.Config.Get('OverviewScreen') : 'CalendarOverview');
                                }
                            );
                        }
                    }
                ], true);

            Event.preventDefault();
            Event.stopPropagation();

            return false;
        });

        // Show settings dialog immediately
        if (Core.Config.Get('CalendarSettingsShow')) {
            $CalendarSettingsObj.trigger('click.AppointmentCalendar');
        }
    }

    /**
     * @private
     * @name ResourceSettingsInit
     * @memberof Core.Agent.AppointmentCalendar
     * @description
     *      This method initializes resource settings behavior.
     */
    function ResourceSettingsInit() {
        var $ResourceSettingsObj = $('#ResourceSettingsButton'),
            ResourceSettingsDialogHTML;

        if (!$ResourceSettingsObj.length) {
            return;
        }

        ResourceSettingsDialogHTML = Core.Template.Render('Agent/AppointmentCalendar/ResourceSettingsDialog', Core.Config.Get('ShownResourceSettings'));

        // Resource settings button
        $ResourceSettingsObj.off('click.AppointmentCalendar').on('click.AppointmentCalendar', function (Event) {
            Core.UI.Dialog.ShowContentDialog(ResourceSettingsDialogHTML, Core.Language.Translate('Settings'), '10px', 'Center', true,
                [
                    {
                        Label: Core.Language.Translate('Save'),
                        Class: 'Primary',
                        Function: function () {
                            var $ListContainer = $('.AllocationListContainer').find('.AssignedFields'),
                                ShownResources = [],
                                Data = {
                                    ChallengeToken: $('#ChallengeToken').val(),
                                    Action: 'AgentAppointmentEdit',
                                    Subaction: 'UpdatePreferences',
                                    OverviewScreen: Core.Config.Get('OverviewScreen') ? Core.Config.Get('OverviewScreen') : 'ResourceOverview',
                                    TeamID: $('#Team').val()
                                };

                            if (isJQueryObject($ListContainer) && $ListContainer.length) {
                                $.each($ListContainer.find('li'), function() {
                                    ShownResources.push($(this).attr('data-fieldname'));
                                });
                            }
                            Data.ShownResources = JSON.stringify(ShownResources);

                            Core.Agent.AppointmentCalendar.ShowWaitingDialog();

                            Core.AJAX.FunctionCall(
                                Core.Config.Get('CGIHandle'),
                                Data,
                                function (Response) {
                                    if (!Response.Success) {
                                        Core.Debug.Log('Error updating user preferences!');
                                    }
                                    location.reload();
                                }
                            );
                        }
                    }
                ], true);

            Event.preventDefault();
            Event.stopPropagation();

            Core.Agent.TableFilters.SetAllocationList();

            return false;
        });

        // Initialize restore settings button.
        RestoreDefaultSettingsInit();
    }

    /**
     * @private
     * @name ResourceSettingsInit
     * @memberof Core.Agent.AppointmentCalendar
     * @description
     *      Adds restore default settings button (trash can) to view and initializes its behavior.
     */
    function RestoreDefaultSettingsInit() {
        var $RestoreSettingsObj;

        // Skip if button is not needed or we already have one.
        if (
            !Core.Config.Get('RestoreDefaultSettings')
            || $('#RestoreDefaultSettings').length > 0
            )
        {
            return;
        }

        // Create the button.
        $RestoreSettingsObj = $('<a />').attr('id', 'RestoreDefaultSettings')
            .attr('href', '#')
            .attr('title', Core.Language.Translate('Restore default settings'))
            .append($('<i />').addClass('fa fa-trash'));

        // Add it to the column header.
        $('tr.fc-super + tr .fc-cell-content').append($RestoreSettingsObj);

        // Register click handler.
        $RestoreSettingsObj.off('click.AppointmentCalendar').on('click.AppointmentCalendar', function (Event) {
            Core.AJAX.FunctionCall(
                Core.Config.Get('CGIHandle'),
                {
                    ChallengeToken: $('#ChallengeToken').val(),
                    Action: 'AgentAppointmentEdit',
                    Subaction: 'UpdatePreferences',
                    OverviewScreen: Core.Config.Get('OverviewScreen') ? Core.Config.Get('OverviewScreen') : 'ResourceOverview',
                    RestoreDefaultSettings: 'ShownResources',
                    TeamID: $('#Team').val()
                },
                function (Response) {
                    if (!Response.Success) {
                        Core.Debug.Log('Error updating user preferences!');
                    }
                    location.reload();
                }
            );

            Event.preventDefault();
            Event.stopPropagation();

            return false;
        });
    }

    /**
     * @private
     * @name ToggleAJAXLoader
     * @memberof Core.Agent.AppointmentCalendar
     * @function
     * @param {jQueryObject} $Element - Object reference of the field which is updated
     * @param {Boolean} Show - Show or hide the AJAX loader image
     * @description
     *      Shows and hides an ajax loader for every element which is updates via ajax.
     */
    function ToggleAJAXLoader($Element, Show) {
        var $Loader = $('#AJAXLoader' + $Element.attr('id')),
            LoaderHTML = '<span id="AJAXLoader' + $Element.attr('id') + '" class="AJAXLoader"></span>';

        // Element not present
        if (!$Element.length) {
            return;
        }

        // Show or hide the loader
        if (Show) {
            if (!$Loader.length) {
                $Element.after(LoaderHTML);
            } else {
                $Loader.show();
            }
        } else {
            if ($Loader.length) {
                $Loader.hide();
            }
        }
    }

    /**
     * @name PluginInit
     * @memberof Core.Agent.AppointmentCalendar
     * @param {jQueryObject} $PluginFields - fields with different plugin searches.
     * @description
     *      This method initializes plugin fields behavior.
     */
    TargetNS.PluginInit = function ($PluginFields) {

        function InitRemoveButtons() {
            $('.RemoveButton').off('click.AppointmentCalendar').on('click.AppointmentCalendar', function () {
                var $RemoveObj = $(this),
                    PluginKey = $RemoveObj.data('pluginKey'),
                    $PluginDataObj = $('#Plugin_' + Core.App.EscapeSelector(PluginKey)),
                    PluginData = JSON.parse($PluginDataObj.val()),
                    LinkID = $RemoveObj.data('linkId').toString(),
                    $Parent = $RemoveObj.parent();

                PluginData.splice(PluginData.indexOf(LinkID), 1);
                $PluginDataObj.val(JSON.stringify(PluginData));

                $Parent.remove();

                return false;
            });
        }

        function AddLink(PluginKey, PluginURL, LinkID, LinkName) {
            var $PluginContainerObj = $('#PluginContainer_' + Core.App.EscapeSelector(PluginKey)),
                $PluginDataObj = $('#Plugin_' + Core.App.EscapeSelector(PluginKey)),
                PluginData = JSON.parse($PluginDataObj.val()),
                $ExistingLinks = $PluginContainerObj.find('.Link_' + Core.App.EscapeSelector(LinkID)),
                $LinkContainerObj = $('<div />'),
                $URLObj = $('<a />'),
                $RemoveObj = $('<a />'),
                LinkURL = PluginURL.replace('%s', LinkID);

            if ($ExistingLinks.length > 0) {
                return;
            }

            PluginData.push(LinkID);
            $PluginDataObj.val(JSON.stringify(PluginData));

            $LinkContainerObj.addClass('Link_' + Core.App.EscapeSelector(LinkID));

            $URLObj.attr('href', LinkURL)
                .attr('target', '_blank')
                .text(LinkName)
                .appendTo($LinkContainerObj);

            $RemoveObj.attr('href', '#')
                .addClass('RemoveButton')
                .data('pluginKey', PluginKey)
                .data('linkId', LinkID)
                .append(
                    $('<i />').addClass('fa fa-minus-square-o')
                )
                .appendTo($LinkContainerObj);

            $LinkContainerObj.appendTo($PluginContainerObj);
            InitRemoveButtons();
        }

        $PluginFields.each(function () {
            var $Element = $(this),
                PluginKey = $Element.data('pluginKey'),
                PluginURL = $Element.data('pluginUrl');

            // Skip already initialized fields
            if ($Element.hasClass('ui-autocomplete-input')) {
                return true;
            }

            Core.UI.Autocomplete.Init($Element, function (Request, Response) {
                    var URL = Core.Config.Get('CGIHandle'),
                        CurrentAJAXNumber = ++AJAXCounter,
                        Data = {
                            ChallengeToken: $('#ChallengeToken').val(),
                            Action: 'AgentAppointmentPluginSearch',
                            PluginKey: PluginKey,
                            Term: Request.term + '*',
                            MaxResults: 20
                        };

                    $Element.data('AutoCompleteXHR', Core.AJAX.FunctionCall(URL, Data, function (Result) {
                        var Data = [];

                        // Check if the result is from the latest ajax request
                        if (AJAXCounter !== CurrentAJAXNumber) {
                            return false;
                        }

                        $.each(Result, function () {
                            Data.push({
                                label: this.Value,
                                key:  this.Key,
                                value: this.Value
                            });
                        });
                        Response(Data);
                    }));
            }, function (Event, UI) {
                Event.stopPropagation();
                $Element.val('').trigger('select.Autocomplete');
                AddLink(PluginKey, PluginURL, UI.item.key, UI.item.label);

                return false;
            }, PluginKey);
        });

        InitRemoveButtons();
    }

    /**
     * @name EditAppointment
     * @param {Object} Data - Hash with call and appointment data.
     * @param {Integer} Data.AppointmentID - Appointment ID.
     * @param {Integer} Data.Action - Edit action.
     * @param {Integer} Data.Subaction - Edit subaction.
     * @param {Integer} Data.Title - Appointment title.
     * @param {Integer} Data.Description - Appointment description.
     * @param {Integer} Data.Location - Appointment location.
     * @param {Integer} Data.StartYear - Appointment start year.
     * @param {Integer} Data.StartMonth - Appointment start month.
     * @param {Integer} Data.StartDay - Appointment start day.
     * @param {Integer} Data.StartHour - Appointment start hour.
     * @param {Integer} Data.StartMinute - Appointment start minute.
     * @param {Integer} Data.EndYear - Appointment end year.
     * @param {Integer} Data.EndMonth - Appointment end month.
     * @param {Integer} Data.EndDay - Appointment end day.
     * @param {Integer} Data.EndHour - Appointment end hour.
     * @param {Integer} Data.EndMinute - Appointment end minute.
     * @param {Integer} Data.AllDay - Is appointment an all-day appointment (0|1)?
     * @description
     *      This method submits an edit appointment call to the backend and refreshes the view.
      */
    TargetNS.EditAppointment = function (Data) {
        if (Core.Config.Get('Action') === 'AgentAppointmentAgendaOverview') {
            $('.OverviewControl').addClass('Loading');
        }

        Core.AJAX.FunctionCall(
            Core.Config.Get('CGIHandle'),
            Data,
            function (Response) {
                if (Response.Success) {
                    $('#calendar').fullCalendar('refetchEvents');

                    // Close the dialog
                    Core.UI.Dialog.CloseDialog($('.Dialog:visible'));

                    // Reload page if necessary
                    if (Core.Config.Get('Action') === 'AgentAppointmentAgendaOverview') {
                        window.location.reload();
                    }
                }
                else {
                    if (Response.Error) {
                        alert(Response.Error);
                    }
                }
            }
        );
    };

    /**
     * @name AgentAppointmentAgendaOverview
     * @memberof Core.Agent.AppointmentCalendar
     * @description
     *      This method initializes functionalities for AgentAppointmentAgentOverview screen.
     */
    TargetNS.AgentAppointmentAgendaOverview = function () {
        var Config = Core.Config.Get('AppointmentAgendaOverview');

        $('#AppointmentCreateButton').off('click').on('click', function () {
            Core.Agent.AppointmentCalendar.OpenEditDialog({
                Start: $.fullCalendar.moment(Config.Start).add(1, 'hours').startOf('hour'),
                End: $.fullCalendar.moment(Config.Start).add(2, 'hours').startOf('hour')
            });

            return false;
        });
        $('.MasterAction').bind('click', function () {
            var $MasterActionLink = $(this).find('.MasterActionLink'),
                AppointmentID = $MasterActionLink.data('appointmentId');

            Core.Agent.AppointmentCalendar.OpenEditDialog({
                CalEvent: {
                    id: AppointmentID
                }
            });

            return false;
        });
    }

    /**
     * @name AgentAppointmentAgendaOverview
     * @memberof Core.Agent.AppointmentCalendar
     * @description
     *      This method initializes functionalities for AgentAppointmentEdit screen.
     */
    TargetNS.AgentAppointmentEdit = function () {
        Core.Form.Validate.Init();
        TargetNS.LocationLinkInit($('#Location'), $('.LocationLink'));
        TargetNS.AllDayInit($('#AllDay'));
        TargetNS.RecurringInit({
            $Recurring: $('#Recurring'),
            $RecurrenceType: $('#RecurrenceType'),
            $RecurrenceCustomType: $('#RecurrenceCustomType'),
            $RecurrenceCustomTypeStringDiv: $('#RecurrenceCustomTypeStringDiv'),
            $RecurrenceIntervalText: $('#RecurrenceIntervalText'),
            $RecurrenceCustomWeeklyDiv: $('#RecurrenceCustomWeeklyDiv'),
            $RecurrenceCustomMonthlyDiv: $('#RecurrenceCustomMonthlyDiv'),
            $RecurrenceCustomYearlyDiv: $('#RecurrenceCustomYearlyDiv'),
            $RecurrenceLimitDiv: $('#RecurrenceLimitDiv'),
            $RecurrenceLimit: $('#RecurrenceLimit'),
            $RecurrenceUntilDiv: $('#RecurrenceUntilDiv'),
            $RecurrenceUntilDay: $('#RecurrenceUntilDay'),
            $RecurrenceCountDiv: $('#RecurrenceCountDiv')
        });
        TargetNS.NotificationInit({
            $NotificationTemplate: $('#NotificationTemplate'),
            $NotificationCustomStringDiv: $('#NotificationCustomStringDiv'),
            $NotificationCustomRelativeInput: $('#NotificationCustomRelativeInput'),
            $NotificationCustomRelativeUnitCount: $('#NotificationCustomRelativeUnitCount'),
            $NotificationCustomRelativeUnit: $('#NotificationCustomRelativeUnit'),
            $NotificationCustomRelativePointOfTime: $('#NotificationCustomRelativePointOfTime'),
            $NotificationCustomDateTimeInput: $('#NotificationCustomDateTimeInput'),
            $NotificationCustomDateTimeDay: $('#NotificationCustomDateTimeDay'),
            $NotificationCustomDateTimeMonth: $('#NotificationCustomDateTimeMonth'),
            $NotificationCustomDateTimeYear: $('#NotificationCustomDateTimeYear'),
            $NotificationCustomDateTimeHour: $('#NotificationCustomDateTimeHour'),
            $NotificationCustomDateTimeMinute: $('#NotificationCustomDateTimeMinute')
        });
        TargetNS.TeamInit($('#TeamID'), $('#ResourceID'), $('label[for="TeamID"] + div.Field p.ReadOnlyValue'), $('label[for="ResourceID"] + div.Field p.ReadOnlyValue'));

        if (Core.Config.Get('CalendarPermissionLevel') > 1) {
            TargetNS.PluginInit($('.PluginField'), $('#ChallengeToken').val());
        }

        Core.Form.Validate.SetSubmitFunction($('#EditAppointmentForm'), function (Form) {
            var Data = new Object(),
                Days = new Array(),
                MonthDays = new Array(),
                Months = new Array();

            // serialize days
            $("#RecurrenceCustomWeeklyDiv button.fc-state-active").each(function(){
                Days.push($(this).val());
            });
            $("input#Days").val(Days.join());

            // serialize month days
            $("#RecurrenceCustomMonthlyDiv button.fc-state-active").each(function(){
                MonthDays.push($(this).val());
            });
            $("input#MonthDays").val(MonthDays.join());

            // serialize months
            $("#RecurrenceCustomYearlyDiv button.fc-state-active").each(function(){
                Months.push($(this).val());
            });
            $("input#Months").val(Months.join());

            $(Form).find('input,textarea,select').each(function (Index, Element) {
                if (Element.type == 'checkbox') {
                    Data[Element.id] = $(Element).prop('checked') ? '1' : '0';
                } else {
                    Data[Element.id] = $(Element).val();
                }
            });

            TargetNS.ShowWaitingDialog();
            TargetNS.EditAppointment(Data);
        });

        $(".ButtonTable button").on("click", function() {
            $(this).toggleClass("fc-state-active");
        });

        // Duplicate appointment
        $('#EditFormCopy').on('click', function() {
            // Reset AppointmentID, remove Copy & Delete buttons
            $("#EditAppointmentForm input#AppointmentID").val("");
            $('#EditAppointmentForm').submit();
        });

        // Save the appointment
        $('#EditFormSubmit').on('click', function() {
            $('#EditAppointmentForm').submit();
        });

        // Delete the appointment
        if (Core.Config.Get('EditAppointmentID')) {
            $('#EditFormDelete').on('click', function() {
                if (window.confirm(Core.Language.Translate('Are you sure you want to delete this appointment? This operation cannot be undone.'))) {
                    Core.Agent.AppointmentCalendar.ShowWaitingDialog();
                    Core.Agent.AppointmentCalendar.EditAppointment({
                        AppointmentID: Core.Config.Get('EditAppointmentID'),
                        Action: 'AgentAppointmentEdit',
                        Subaction: 'DeleteAppointment'
                    });
                }
            });
        }

        // Edit parent appointment
        if (Core.Config.Get('EditParentID')) {
            $('#EditParent').on('click', function() {
                var Data = {
                    ChallengeToken: $("#ChallengeToken").val(),
                    Action: 'AgentAppointmentEdit',
                    Subaction: 'EditMask',
                    AppointmentID: Core.Config.Get('EditParentID')
                };

                Core.Agent.AppointmentCalendar.ShowWaitingDialog();
                Core.AJAX.FunctionCall(
                    Core.Config.Get('CGIHandle'),
                    Data,
                    function (HTML) {
                        Core.UI.Dialog.ShowContentDialog(HTML, Core.Language.Translate('Appointment'), '10px', 'Center', true, undefined, true);
                        Core.UI.InputFields.Activate($('.Dialog:visible'));
                        TargetNS.AgentAppointmentEdit();
                    }, 'html'
                );
            });
        }

        // Close the dialog
        $('#EditFormCancel').on('click', function() {
            Core.UI.Dialog.CloseDialog($('.Dialog:visible'));
        });

        // Initialize datepicker buttons.
        if (Core.Config.Get('CalendarPermissionLevel') > 2) {
            $.each(['Start', 'End', 'RecurrenceUntil', 'NotificationCustomDateTime'], function (Index, Prefix) {
                Core.UI.Datepicker.Init({
                    Day: $('#' + Core.App.EscapeSelector(Prefix) + 'Day'),
                    Month: $('#' + Core.App.EscapeSelector(Prefix) + 'Month'),
                    Year: $('#' + Core.App.EscapeSelector(Prefix) + 'Year'),
                    Hour: $('#' + Core.App.EscapeSelector(Prefix) + 'Hour'),
                    Minute: $('#' + Core.App.EscapeSelector(Prefix) + 'Minute'),
                    WeekDayStart: Core.Config.Get('CalendarWeekDayStart')
                });
            });
        }
    }

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.AppointmentCalendar || {}));
