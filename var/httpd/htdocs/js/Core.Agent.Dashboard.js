// --
// Core.Agent.Dashboard.js - provides the special module functions for the dashboard
// Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};

/**
 * @namespace
 * @exports TargetNS as Core.Agent.Dashboard
 * @description
 *      This namespace contains the special module functions for the Dashboard.
 */
Core.Agent.Dashboard = (function (TargetNS) {

    /**
     * @function
     * @param {jQueryObject} $Input Input element to add auto complete to
     * @return nothing
     */
    TargetNS.InitCustomerIDAutocomplete = function ($Input) {
        $Input.autocomplete({
            minLength: Core.Config.Get('CustomerAutocomplete.MinQueryLength'),
            delay: Core.Config.Get('CustomerAutocomplete.QueryDelay'),
            open: function() {
                // force a higher z-index than the overlay/dialog
                $(this).autocomplete('widget').addClass('ui-overlay-autocomplete');
                return false;
            },
            source: function (Request, Response) {
                var URL = Core.Config.Get('Baselink'), Data = {
                    Action: 'AgentCustomerInformationCenterSearch',
                    Subaction: 'SearchCustomerID',
                    Term: Request.term,
                    MaxResults: Core.Config.Get('CustomerAutocomplete.MaxResultsDisplayed')
                };

                // if an old ajax request is already running, stop the old request and start the new one
                if ($Input.data('AutoCompleteXHR')) {
                    $Input.data('AutoCompleteXHR').abort();
                    $Input.removeData('AutoCompleteXHR');
                    // run the response function to hide the request animation
                    Response({});
                }

                $Input.data('AutoCompleteXHR', Core.AJAX.FunctionCall(URL, Data, function (Result) {
                    var Data = [];
                    $Input.removeData('AutoCompleteXHR');
                    $.each(Result, function () {
                        Data.push({
                            label: this.Label + ' (' + this.Value + ')',
                            value: this.Value
                        });
                    });
                    Response(Data);
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
     * @function
     * @param {jQueryObject} $Input Input element to add auto complete to
     * @param {String} Subaction Subaction to execute, "SearchCustomerID" or "SearchCustomerUser"
     * @return nothing
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
                    var Data = [];
                    $Input.removeData('AutoCompleteXHR');
                    $.each(Result, function () {
                        Data.push({
                            label: this.CustomerValue + " (" + this.CustomerKey + ")",
                            value: this.CustomerValue,
                            key: this.CustomerKey
                        });
                    });
                    Response(Data);
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
     * @function
     * @param {jQueryObject} $Input Input element to add auto complete to
     * @param {String} Subaction Subaction to execute, "SearchCustomerID" or "SearchCustomerUser"
     * @return nothing
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
                    var Data = [];
                    $Input.removeData('AutoCompleteXHR');
                    $.each(Result, function () {
                        Data.push({
                            label: this.UserValue + " (" + this.UserKey + ")",
                            value: this.UserValue,
                            key: this.UserKey
                        });
                    });
                    Response(Data);
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
     * @function
     * @return nothing
     *      This function initializes the special module functions
     */
    TargetNS.Init = function () {
        Core.UI.DnD.Sortable(
            $('.SidebarColumn'),
            {
                Handle: '.Header h2',
                Items: '.CanDrag',
                Placeholder: 'DropPlaceholder',
                Tolerance: 'pointer',
                Distance: 15,
                Opacity: 0.6,
                Update: function (event, ui) {
                    var url = 'Action=' + Core.Config.Get('Action') + ';Subaction=UpdatePosition;';
                    $('.CanDrag').each(
                        function (i) {
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
                Update: function (event, ui) {
                    var url = 'Action=' + Core.Config.Get('Action') + ';Subaction=UpdatePosition;';
                    $('.CanDrag').each(
                        function (i) {
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
            $(this).bind('click', function() {
                $(this).toggleClass('Checked', $(this).find('input').prop('checked'));
            });
        });

        Core.Agent.TableFilters.SetAllocationList();
    };

    /**
     * @function
     * @return nothing
     *      This function binds a click event on an html element to update the preferences of the given dahsboard widget
     * @param {jQueryObject} $ClickedElement The jQuery object of the element(s) that get the event listener
     * @param {string} ElementID The ID of the element whose content should be updated with the server answer
     * @param {jQueryObject} $Form The jQuery object of the form with the data for the server request
     */
    TargetNS.RegisterUpdatePreferences = function ($ClickedElement, ElementID, $Form) {
        if (isJQueryObject($ClickedElement) && $ClickedElement.length) {
            $ClickedElement.click(function () {
                var URL = Core.Config.Get('Baselink') + Core.AJAX.SerializeForm($Form),
                    ValidationErrors = false;

                // check for elements to validate
                $ClickedElement.closest('fieldset').find('.StatsSettingsBox').find('.TimeRelativeUnitGeneric').each(function() {
                    if (parseInt($(this).prev('select').val(), 10) * parseInt($(this).find('option:selected').attr('data-seconds'), 10) > parseInt($(this).closest('.Value').attr('data-max-seconds'), 10)) {
                        ValidationErrors = true;
                        $(this)
                            .add($(this).prev('select'))
                            .add($(this).closest('.Value'))
                            .addClass('Error');
                    }
                    else {
                        $(this)
                            .add($(this).prev('select'))
                            .add($(this).closest('.Value'))
                            .removeClass('Error');
                    }
                });

                if (ValidationErrors) {
                    window.alert(Core.Config.Get('ValidationErrorMsg'));
                    return false;
                }

                Core.AJAX.ContentUpdate($('#' + ElementID), URL, function () {
                    Core.UI.ToggleTwoContainer($('#' + ElementID + '-setting'), $('#' + ElementID));
                    Core.UI.Table.InitCSSPseudoClasses();
                });
                return false;
            });
        }
    };

    /**
     * @function
     * @param Params Hash with different config options:
     *               MonthNames: Array containing the localized strings for each month
     *               MonthNamesShort: Array containing the localized strings for each month on shorth format
     *               DayNames: Array containing the localized strings for each week day
     *               DayNamesShort: Array containing the localized strings for each week day on short format
     *               ButtonText: Array containing the localized strings for each week day on short format:
     *                  today: Localized string for the word "Today"
     *                  month: Localized string for the word "month"
     *                  week: Localized string for the word "week"
     *                  day: Localized string for the word "day"
     *              Events: Array of hashes including the data for each event
     * @return nothing
     * @description The main dialog function used for all different types of dialogs.
     */

    TargetNS.EventsTicketCalendarInit = function (Params) {
        var date = new Date(),
        d = date.getDate(),
        m = date.getMonth(),
        y = date.getFullYear(),
        jsEvent;

        $('#calendar').fullCalendar({
            header: {
                left: 'month,agendaWeek,agendaDay',
                center: 'title',
                right: 'prev,next today'
            },
            allDayText: Params.AllDayText,
            axisFormat: 'H(:mm)', // uppercase H for 24-hour clock
            editable: false,
            firstDay: Params.FirstDay,
            monthNames: Params.MonthNames,
            monthNamesShort: Params.MonthNamesShort,
            dayNames: Params.DayNames,
            dayNamesShort: Params.DayNamesShort,
            buttonText: Params.ButtonText,
            eventMouseover: function(calEvent, jsEvent, view) {
                var Layer, Styles, PosX, PosY, DocumentVisible, ContainerHeight,
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
                DocumentVisible  = VisibleScrollPosition + WindowHeight;

                ContainerHeight = $('#events-layer').height();
                LastYPosition = PosY + ContainerHeight;
                if ( LastYPosition > DocumentVisible ) {
                    PosY = PosY - (LastYPosition - DocumentVisible) - 10;
                    $('#events-layer').css('top', PosY+'px');
                }

                $('#events-layer').fadeIn("fast");
            },
            eventMouseout: function(calEvent, jsEvent, view) {
                $('#events-layer').fadeOut("fast");
                $('#events-layer').remove();
            },
            events: Params.Events
        });
    };

    /**
     * @function
     * @return nothing
     *      Initializes the configuration page for a stats dashboard widget
     */
    TargetNS.InitStatsConfiguration = function($Container) {

        // Initialize the time multiplicators for the time validation.
        $('.TimeRelativeUnitGeneric, .TimeScaleUnitGeneric', $Container).find('option').each(function() {
            var SecondsMapping = {
                'Year'   : 31536000,
                'Month'  : 2592000,
                'Week'   : 604800,
                'Day'    : 86400,
                'Hour'   : 3600,
                'Minute' : 60,
                'Second' : 1
            };

            $(this).attr('data-seconds', SecondsMapping[$(this).val()]);
        });

        // check for validity of relative time settings
        // each time setting has its own maximum value in data-max-seconds attribute on the .Value div.
        // if the combination of unit and count is higher than this value, the select boxes will be
        // colored with red and the submit button will be blocked.
        function ValidateTimeSettings() {

            $Container.find('.TimeRelativeUnitGeneric').each(function() {
                if (parseInt($(this).prev('select').val(), 10) * parseInt($(this).find('option:selected').attr('data-seconds'), 10) > parseInt($(this).closest('.Value').attr('data-max-seconds'), 10)) {

                    $(this)
                        .add($(this).prev('select'))
                        .add($(this).closest('.Value'))
                        .addClass('Error');
                }
                else {
                    $(this)
                        .add($(this).prev('select'))
                        .add($(this).closest('.Value'))
                        .removeClass('Error');
                }
            });

            $Container.find('.TimeScaleUnitGeneric').each(function() {
                if (parseInt($(this).prev('select').val(), 10) * parseInt($(this).find('option:selected').attr('data-seconds'), 10) < parseInt($(this).closest('.Value').attr('data-min-seconds'), 10)) {

                    $(this)
                        .add($(this).prev('select'))
                        .add($(this).closest('.Value'))
                        .addClass('Error');
                }
                else {
                    $(this)
                        .add($(this).prev('select'))
                        .add($(this).closest('.Value'))
                        .removeClass('Error');
                }
            });

            $Container.each(function() {
                if ($(this).find('.TimeRelativeUnitGeneric.Error, .TimeScaleUnitGeneric.Error').length) {
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

        // Serializes all configured settings to a hidden field with JSON
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

        // set chart type selection for dropdown
        $('#ChartType').val($('#ChartType').data('selected'));
    };

    return TargetNS;
}(Core.Agent.Dashboard || {}));
