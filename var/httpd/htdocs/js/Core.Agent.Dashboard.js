// --
// Core.Agent.Dashboard.js - provides the special module functions for the dashboard
// Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --
/*global d3, nv, Chart */

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
            editable: false,
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
     *      Initializes an nvd3 chart with the data from the statistic
     * @param {SVGElement} selector of the SVG element to use
     * @param {RawData}    Raw JSON data as generated by Stats::StatsRun()
     */
    TargetNS.InitStatsChart = function(SVGElement, RawData) {

        var Title = RawData.shift(),
            Headings = RawData.shift(),
            ResultData = [],
            ValueFormat = 'd', // y axis format is by default "integer"
            Colors = [ '#EC9073', '#6BAD54', '#E2F626', '#0F22E4', '#1FE362', '#C5F566', '#8D23A8', '#78A7FC', '#DFC01B', '#43B261', '#53758D', '#C1AE45', '#6CD13D', '#E0CA0E', '#652188', '#3EBB34', '#8F53EA', '#956669', '#34A0FB', '#F50178', '#AB766A', '#BEA029', '#ABE124', '#A68477', '#F7D084', '#93F0A5', '#B54667', '#F12D25', '#1DBA13', '#21AF23', '#3B62C0', '#876CDC', '#3DE6A0', '#CCD77F', '#B91583', '#8CFFFB', '#073641', '#38E1E9', '#1A5F2D', '#ED603F', '#3BB3AA', '#FA2216', '#34E25C', '#B6716A', '#E5845B', '#497FC2', '#ABCCEE', '#222047', '#DFE514', '#FFA84F', '#388B85', '#D21AEF', '#811A26', '#206057', '#557FDB', '#F148CC', '#DAFF4E', '#FCF072', '#792DA8', '#50DC0B', '#8FDC7A', '#954958', '#74575C', '#AC5CAF', '#4FF2BF', '#E4FC17', '#6ADB42', '#4B693B', '#5D7BA1', '#BF1B1C', '#A00AC1', '#13CEE0', '#02C7C0', '#21EAD8', '#C87D39', '#AEAB86', '#DA9998', '#AAB717', '#8496E6', '#FAE782', '#120BD9', '#1A3B4C', '#3F7E68', '#6FCF6B', '#5564DE', '#6E07AD', '#0C847C', '#1BB8A2', '#101DF8', '#85DE9B', '#D0AD74', '#B803D8', '#0E3C7E', '#E8E05E', '#8E36DD', '#2ADC85', '#13E17B', '#A8AE41', '#C3AA40', '#9CFD3C', '#A5782F', '#E33C5B', '#8F33D8', '#59BF4F', '#FECFB0', '#B553D8', '#2CB590', '#01045E', '#CA78AC', '#8AA596', '#54BB79', '#3A5E0E', '#F10F55', '#D205AA', '#234D8D', '#3D2F8A', '#9B4F95', '#E96E9C', '#47E4C9', '#FFC3D4', '#11231A', '#DA529F', '#789D72', '#AB9906', '#205F33', '#444685', '#05067A', '#6E2FC9', '#165AF5', '#026619', '#96EEC6', '#4DB433', '#E9219F', '#AA5F55', '#558BCA', '#56034C', '#A896DD', '#9C7CD0', '#B8B170', '#7D6F92', '#9E8A2D', '#7D6134', '#ED069E', '#74625E', '#3DC9C5', '#C64507', '#274987', '#D74EEE', '#C53379', '#1A6E42', '#308859', '#F70419', '#BE10CF', '#E841CC', '#AD60CB', '#30BB80', '#5886C9' ],
            Color,
            Counter = 0;

        $.each(RawData, function(DataIndex, DataElement) {
            // Ignore sum row
            if (DataElement[0] === 'Sum') {
                return;
            }

            var ResultLine = {
                key: DataElement[0],
                color: Colors[Counter % Colors.length],
                values: []
            };

            $.each(Headings, function(HeadingIndex, HeadingElement){
                var Value;
                // First element is x axis label
                if (HeadingIndex === 0){
                    return;
                }
                // Ignore sum col
                if (HeadingElement === 'Sum') {
                    return;
                }

                Value = parseFloat( DataElement[HeadingIndex] );

                if ( isNaN(Value) ) {
                    return;
                }

                // Check if value is a floating point number and not an integer
                if (Value % 1) {
                    ValueFormat = ',1f'; // Set y axis format to float
                }

                // nv d3 does not work correcly with non numeric values
                ResultLine.values.push({
                    x: HeadingElement,
                    y: Value
                });
            });
            ResultData.push(ResultLine);
            Counter++;
        });

        // production mode
        nv.dev = false;

        nv.addGraph(function() {

            var Chart = nv.models.multiBarChart();

            // don't let nv/d3 exceptions block the rest of OTRS JavaScript
            try {

                Chart.margin({
                    top: 20,
                    right: 20,
                    bottom: 50,
                    left: 50
                });

                Chart.xAxis.axisLabel(Headings[0]);
                Chart.yAxis.axisLabel("Values").tickFormat(d3.format(ValueFormat));

                d3.select(SVGElement)
                    .datum(ResultData)
                    .transition()
                    .duration(500)
                    .call(Chart);

                nv.utils.windowResize(function() {
                    Chart.update();
                });
            }
            catch (Error) {
                Core.Debug.Log(Error);
            }

            return Chart;
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

        $Container.find('select, input').each(function() {
            $(this).bind('change', function() {
                CollectStatsData();
                ValidateTimeSettings();
            });
        });

        ValidateTimeSettings();
    };

    return TargetNS;
}(Core.Agent.Dashboard || {}));
