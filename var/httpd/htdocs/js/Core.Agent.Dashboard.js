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
                var URL = Core.Config.Get('Baselink') + Core.AJAX.SerializeForm($Form);
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

    return TargetNS;
}(Core.Agent.Dashboard || {}));
