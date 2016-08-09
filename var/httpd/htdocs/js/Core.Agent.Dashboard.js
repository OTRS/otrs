// --
// Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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
     * @name InitCustomerIDAutocomplete
     * @memberof Core.Agent.Dashboard
     * @function
     * @param {jQueryObject} $Input - Input element to add auto complete to.
     * @description
     *      Initialize autocompletion for CustomerID.
     */
    TargetNS.InitCustomerIDAutocomplete = function ($Input) {
        $Input.autocomplete({
            minLength: Core.Config.Get('CustomerIDAutocomplete.MinQueryLength'),
            delay: Core.Config.Get('CustomerIDAutocomplete.QueryDelay'),
            open: function() {
                // force a higher z-index than the overlay/dialog
                $(this).autocomplete('widget').addClass('ui-overlay-autocomplete');
                return false;
            },
            source: function (Request, Response) {
                var URL = Core.Config.Get('Baselink'), Data = {
                    Action: 'AgentCustomerInformationCenterSearch',
                    Subaction: 'SearchCustomerID',
                    IncludeUnknownTicketCustomers: parseInt(Core.Config.Get('IncludeUnknownTicketCustomers'), 10),
                    Term: Request.term,
                    MaxResults: Core.Config.Get('CustomerIDAutocomplete.MaxResultsDisplayed')
                };

                // if an old ajax request is already running, stop the old request and start the new one
                if ($Input.data('AutoCompleteXHR')) {
                    $Input.data('AutoCompleteXHR').abort();
                    $Input.removeData('AutoCompleteXHR');
                    // run the response function to hide the request animation
                    Response({});
                }

                $Input.data('AutoCompleteXHR', Core.AJAX.FunctionCall(URL, Data, function (Result) {
                    var ValueData = [];
                    $Input.removeData('AutoCompleteXHR');
                    $.each(Result, function () {
                        ValueData.push({
                            label: this.Label + ' (' + this.Value + ')',
                            value: this.Value
                        });
                    });
                    Response(ValueData);
                }));
            },
            select: function (Event, UI) {
                $(Event.target)
                    .parent()
                    .find('select')
                    .append('<option value="' + UI.item.value + '">SelectedItem</option>')
                    .val(UI.item.value)
                    .trigger('change');
            }
        });
    };

    /**
     * @name InitCustomerUserAutocomplete
     * @memberof Core.Agent.Dashboard
     * @function
     * @param {jQueryObject} $Input - Input element to add auto complete to.
     * @description
     *      Initialize autocompletion for CustomerUser.
     */
    TargetNS.InitCustomerUserAutocomplete = function ($Input) {
        $Input.autocomplete({
            minLength: Core.Config.Get('CustomerUserAutocomplete.MinQueryLength'),
            delay: Core.Config.Get('CustomerUserAutocomplete.QueryDelay'),
            open: function() {
                // force a higher z-index than the overlay/dialog
                $(this).autocomplete('widget').addClass('ui-overlay-autocomplete');
                return false;
            },
            source: function (Request, Response) {
                var URL = Core.Config.Get('Baselink'), Data = {
                    Action: 'AgentCustomerSearch',
                    IncludeUnknownTicketCustomers: parseInt(Core.Config.Get('IncludeUnknownTicketCustomers'), 10),
                    Term: Request.term,
                    MaxResults: Core.Config.Get('CustomerUserAutocomplete.MaxResultsDisplayed')
                };

                // if an old ajax request is already running, stop the old request and start the new one
                if ($Input.data('AutoCompleteXHR')) {
                    $Input.data('AutoCompleteXHR').abort();
                    $Input.removeData('AutoCompleteXHR');
                    // run the response function to hide the request animation
                    Response({});
                }

                $Input.data('AutoCompleteXHR', Core.AJAX.FunctionCall(URL, Data, function (Result) {
                    var ValueData = [];
                    $Input.removeData('AutoCompleteXHR');
                    $.each(Result, function () {
                        ValueData.push({
                            label: this.CustomerValue + " (" + this.CustomerKey + ")",
                            value: this.CustomerValue,
                            key: this.CustomerKey
                        });
                    });
                    Response(ValueData);
                }));
            },
            select: function (Event, UI) {
                $(Event.target)
                    .parent()
                    .find('select')
                    .append('<option value="' + UI.item.key + '">SelectedItem</option>')
                    .val(UI.item.key)
                    .trigger('change');
            }
        });
    };

    /**
     * @name InitUserAutocomplete
     * @memberof Core.Agent.Dashboard
     * @function
     * @param {jQueryObject} $Input - Input element to add auto complete to.
     * @param {String} Subaction - Subaction to execute, "SearchCustomerID" or "SearchCustomerUser".
     * @description
     *      Initialize autocompletion for User.
     */
    TargetNS.InitUserAutocomplete = function ($Input, Subaction) {
        $Input.autocomplete({
            minLength: Core.Config.Get('UserAutocomplete.MinQueryLength'),
            delay: Core.Config.Get('UserAutocomplete.QueryDelay'),
            open: function() {
                // force a higher z-index than the overlay/dialog
                $(this).autocomplete('widget').addClass('ui-overlay-autocomplete');
                return false;
            },
            source: function (Request, Response) {
                var URL = Core.Config.Get('Baselink'), Data = {
                    Action: 'AgentUserSearch',
                    Subaction: Subaction,
                    Term: Request.term,
                    MaxResults: Core.Config.Get('UserAutocomplete.MaxResultsDisplayed')
                };

                // if an old ajax request is already running, stop the old request and start the new one
                if ($Input.data('AutoCompleteXHR')) {
                    $Input.data('AutoCompleteXHR').abort();
                    $Input.removeData('AutoCompleteXHR');
                    // run the response function to hide the request animation
                    Response({});
                }

                $Input.data('AutoCompleteXHR', Core.AJAX.FunctionCall(URL, Data, function (Result) {
                    var ValueData = [];
                    $Input.removeData('AutoCompleteXHR');
                    $.each(Result, function () {
                        ValueData.push({
                            label: this.UserValue + " (" + this.UserKey + ")",
                            value: this.UserValue,
                            key: this.UserKey
                        });
                    });
                    Response(ValueData);
                }));
            },
            select: function (Event, UI) {
                $(Event.target)
                    .parent()
                    .find('select')
                    .append('<option value="' + UI.item.key + '">SelectedItem</option>')
                    .val(UI.item.key)
                    .trigger('change');
            }
        });
    };

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
        var StatsData,
            DashboardStats = Core.Config.Get('DashboardStatsIDs');

        // initializes dashboards stats widget functionality
        $.each(DashboardStats, function (Index, Value) {
            StatsData = Core.Config.Get('StatsData' + Value);
            if (typeof StatsData !== 'undefined') {
                TargetNS.InitStatsWidget(StatsData);
            }
        });

        // initializes events ticket calendar
        EventsTicketCalendarInitialization();

        // Initializes events customer user list
        InitCustomerUserList();

        // Disable drag and drop of dashboard widgets on mobile / touch devices
        // to prevent accidentally moved widgets while tabbing/swiping
        if (!Core.App.Responsive.IsTouchDevice()) {
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
        }

        $('.SettingsWidget').find('label').each(function() {
            if ($(this).find('input').prop('checked')) {
                $(this).addClass('Checked');
            }
            $(this).bind('click', function() {
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

        $Container.find('select, input').bind('change', function() {
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

        // Bind event on create chat request button
        $('a.CreateChatRequest').bind('click', function() {
            var $Dialog = $('#DashboardUserOnlineChatStartDialog').clone();

            $Dialog.find('input[name=ChatStartUserID]').val($(this).data('user-id'));
            $Dialog.find('input[name=ChatStartUserType]').val($(this).data('user-type'));
            $Dialog.find('input[name=ChatStartUserFullname]').val($(this).data('user-fullname'));

            Core.UI.Dialog.ShowContentDialog($Dialog.html(), Core.Language.Translate('Start chat'), '100px', 'Center', true);

            // Only enable button if there is a message
            $('.Dialog textarea[name="ChatStartFirstMessage"]').on('keyup', function(){
                $('.Dialog button').prop('disabled', $(this).val().length ? false : true);
            });

            $('.Dialog form').on('submit', function(){
                if (!$('.Dialog textarea[name=ChatStartFirstMessage]').val().length) {
                    return false;
                }
                // Close after submit
                window.setTimeout(function(){
                    Core.UI.Dialog.CloseDialog($('.Dialog'));
                }, 1);
            });

            return false;
        });

        if (typeof Core.Config.Get('CustomerUserListRefresh') !== 'undefined') {
            CustomerUserRefresh = Core.Config.Get('CustomerUserListRefresh');

            Core.Config.Set('RefreshSeconds_' + CustomerUserRefresh.NameHTML, parseInt(CustomerUserRefresh.RefreshTime, 10) || 0);
            if (Core.Config.Get('RefreshSeconds_' + CustomerUserRefresh.NameHTML)) {
                Core.Config.Set('Timer_' + CustomerUserRefresh.NameHTML, window.setTimeout(function() {

                    // get active filter
                    var Filter = $('#Dashboard' + Core.App.EscapeSelector(CustomerUserRefresh.Name) + '-box').find('.Tab.Actions li.Selected a').attr('data-filter');
                    $('#Dashboard' + Core.App.EscapeSelector(CustomerUserRefresh.Name) + '-box').addClass('Loading');
                    Core.AJAX.ContentUpdate($('#Dashboard' + Core.App.EscapeSelector(CustomerUserRefresh.Name)), Core.Config.Get('Baselink') + 'Action=' + Core.Config.Get('Action') + ';Subaction=Element;Name=' + CustomerUserRefresh.Name + ';Filter=' + Filter + ';CustomerID=' + CustomerUserRefresh.CustomerID, function () {
                        $('#Dashboard' + Core.App.EscapeSelector(CustomerUserRefresh.Name) + '-box').removeClass('Loading');
                    });
                    clearTimeout(Core.Config.Get('Timer_' + CustomerUserRefresh.NameHTML));
                }, Core.Config.Get('RefreshSeconds_' + CustomerUserRefresh.NameHTML) * 1000));
            }
        }
    }

    /**
     * @name InitStatsWidget
     * @memberof Core.Agent.Dashboard
     * @param {Object} StatsData - Hash with different config options.
     * @function
     * @description
     *      Initializes the stats dashboard widget functionality.
     */
     TargetNS.InitStatsWidget = function (StatsData) {
        (function(){
            var Timeout = 500;
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
                        PreferencesData: StatsData.Preferences,
                        Duration: 250
                    }
                );
            }, Timeout);

        }());

        $('#DownloadSVG' + Core.App.EscapeSelector(StatsData.Name)).on('click', function() {
            this.href = Core.UI.AdvancedChart.ConvertSVGtoBase64($('#GraphWidgetContainer' + Core.App.EscapeSelector(StatsData.Name)));
        });
        $('#DownloadPNG' + Core.App.EscapeSelector(StatsData.Name)).on('click', function() {
            this.href = Core.UI.AdvancedChart.ConvertSVGtoPNG($('#GraphWidgetContainer' + Core.App.EscapeSelector(StatsData.Name)));
        });

        $('#GraphWidgetLink' + Core.App.EscapeSelector(StatsData.Name)).prependTo($('#GraphWidget' + Core.App.EscapeSelector(StatsData.Name)).closest('.WidgetSimple').find('.ActionMenu'));
        $('#GraphWidgetLink' + Core.App.EscapeSelector(StatsData.Name)).find('a.TriggerTooltip').bind('click', function(){
            $(this).next('.WidgetTooltip').toggleClass('Hidden');
            return false;
        });
        $('#GraphWidgetLink' + Core.App.EscapeSelector(StatsData.Name)).find('.WidgetTooltip').find('a').bind('click', function(){
            $(this).closest('.WidgetTooltip').addClass('Hidden');
        });
        $('#GraphWidgetLink' + Core.App.EscapeSelector(StatsData.Name)).closest('.Header').bind('mouseleave.WidgetTooltip', function(){
            $('#GraphWidgetLink' + Core.App.EscapeSelector(StatsData.Name)).find('.WidgetTooltip').addClass('Hidden');
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Dashboard || {}));
