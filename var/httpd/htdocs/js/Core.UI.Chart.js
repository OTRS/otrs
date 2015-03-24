// --
// Core.UI.Chart.js - provides the Chart functions
// Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.UI = Core.UI || {};

/**
 * @namespace Core.UI.Chart
 * @memberof Core.UI
 * @author OTRS AG
 * @description
 *      Chart drawing.
 */
Core.UI.Chart = (function (TargetNS) {

    if (!Core.Debug.CheckDependency('Core.UI.Chart', '$.plot', 'jQuery Flot API')) {
        return;
    }

    /**
     * @private
     * @name Charts
     * @memberof Core.UI.Chart
     * @member {Object}
     * @description
     *      Object of all charts.
     */
    var Charts = {},

    /**
     * @private
     * @name PageCoordinates
     * @memberof Core.UI.Chart
     * @member {Array}
     * @description
     *      Coordinates of the mouse to handle tooltips.
     */
        PageCoordinates = [],

    /**
     * @private
     * @name ChartCoordinates
     * @memberof Core.UI.Chart
     * @member {Array}
     * @description
     *      Coordinates of the latest chart.
     */
        ChartCoordinates = [],

    /**
     * @private
     * @name TooltipCoordinatesDelta
     * @memberof Core.UI.Chart
     * @member {Number}
     * @description
     *      Delta for checking mouse positions.
     */
        TooltipCoordinatesDelta = 10,

    /**
     * @private
     * @name ChartTooltipTimeout
     * @memberof Core.UI.Chart
     * @member {Object}
     * @description
     *      Timeout object.
     */
        ChartTooltipTimeout,

    /**
     * @private
     * @name TooltipTimeout
     * @memberof Core.UI.Chart
     * @member {Number}
     * @description
     *      Timeout to check mouse position for tooltip again.
     */
        TooltipTimeout = 500,

    /**
     * @private
     * @name PreviousPoint
     * @memberof Core.UI.Chart
     * @member {Number}
     * @description
     *      PreviousPoint.
     */
        PreviousPoint = null;

    /**
     * @private
     * @name RemoveChartTooltip
     * @memberof Core.UI.Chart
     * @function
     * @description
     *      Remove chart tooltip only when mouse is moved away.
     */
    function RemoveChartTooltip() {
        if (
            PageCoordinates[0] > ChartCoordinates[0] - TooltipCoordinatesDelta &&
            PageCoordinates[0] < ChartCoordinates[0] + TooltipCoordinatesDelta &&
            PageCoordinates[1] > ChartCoordinates[1] - TooltipCoordinatesDelta &&
            PageCoordinates[1] < ChartCoordinates[1] + TooltipCoordinatesDelta
           ) {
            window.clearTimeout(ChartTooltipTimeout);
            ChartTooltipTimeout = window.setTimeout(function () {
                RemoveChartTooltip();
            }, TooltipTimeout);
        }
        else {
            $("#ChartTooltip").remove();
            ChartCoordinates = null;
            PreviousPoint = null;
        }
    }

    /**
     * @private
     * @name ShowTooltip
     * @memberof Core.UI.Chart
     * @function
     * @param {String} PosX - The horizontal coordinate.
     * @param {String} PosY - The vertical coordinate.
     * @param {String} Content - The type of a window, e.g. 'Action'.
     * @description
     *      This function adds a tooltip to the window and show it.
     */
    function ShowTooltip(PosX, PosY, Content) {
        var Top = PosY + 5,
            Left = PosX + 5,
            WindowWidth = $(window).width(),
            WindowHeight = $(window).height();

        //check if x,y are at the right end of the window
        if (PosX > (WindowWidth - 100)) {
            Left = PosX - 100;
        }

        if (PosY > (WindowHeight - 100)) {
            Top = PosY - 20;
        }

        $('<div id="ChartTooltip">' + Content + '</div>').css({
            top: Top,
            left: Left
        }).appendTo("body").fadeIn(200);
    }

    /**
     * @name StartMouseTracking
     * @memberof Core.UI.Chart
     * @function
     * @description
     *      This function starts the mouse tracking movement, in the page.
     */
    TargetNS.StartMouseTracking = function () {
        $(document).bind('mousemove.Chart', function (Event) {
            PageCoordinates = [ Event.pageX, Event.pageY ];
        });
    };

    /**
     * @name StopMouseTracking
     * @memberof Core.UI.Chart
     * @function
     * @description
     *      This function terminates the mouse tracking movement, in the page.
     */
    TargetNS.StopMouseTracking = function () {
        $(document).unbind('mousemove.Chart');
    };

    /**
     * @name DrawLineChart
     * @memberof Core.UI.Chart
     * @function
     * @param {String} ChartName
     * @param {Object} ChartData
     * @param {Object} TicksXAxis
     * @param {Object} TicksYAxis
     * @description
     *      This function draws a line chart.
     */
    TargetNS.DrawLineChart = function (ChartName, ChartData, TicksXAxis, TicksYAxis) {
        var Options = {
                colors: ["#ffc515", "#1a89ba", "#2eb200", "#ff4f15"],
                series: {
                    lines: {
                        show: true,
                        lineWidth: 2
                    },
                    points: {
                        show: true,
                        radius: 1,
                        lineWidth: 2,
                        fill: false
                    }
                },
                grid: {
                    clickable: false,
                    color: "#999",
                    borderWidth: 0,
                    markingsLineWidth: 1,
                    hoverable: true
                },
                legend: {
                    show: false
                },
                xaxis: {
                    ticks: TicksXAxis
                },
                yaxis: {
                    min: 0,
                    tickDecimals: 0,
                    ticks: TicksYAxis
                }
            },
            $Element = $('#' + ChartName);

        if (typeof window.CanvasRenderingContext2D === 'undefined' && typeof window.G_vmlCanvasManager === 'undefined') {
            Core.Exception.Throw("IE support for charts not loaded!", 'InternalError');
        }

        if ($Element.length) {
            Charts[ChartName] = $.plot($Element, ChartData, Options);

            TargetNS.StopMouseTracking();
            TargetNS.StartMouseTracking();

            $Element.unbind('plothover').bind('plothover', function (Event, Pos, Item) {
                var PosX, PosY;
                if (Item) {
                    ChartCoordinates = [ Item.pageX, Item.pageY ];
                    if (!PreviousPoint || PreviousPoint[0] !== Item.datapoint[0] || PreviousPoint[1] !== Item.datapoint[1]) {
                        PreviousPoint = Item.datapoint;

                        window.clearTimeout(ChartTooltipTimeout);
                        $("#ChartTooltip").remove();
                        PosX = Item.datapoint[0];
                        PosY = Item.datapoint[1];

                        ShowTooltip(Item.pageX, Item.pageY,
                            Item.series.label + " " + Charts[ChartName].getAxes().xaxis.ticks[PosX].label + ": " + PosY);

                        // set timeout to remove tooltip
                        ChartTooltipTimeout = window.setTimeout(function () {
                            RemoveChartTooltip();
                        }, TooltipTimeout);
                    }
                    else if (PreviousPoint[0] === Item.datapoint[0] && PreviousPoint[1] === Item.datapoint[1]) {
                        window.clearTimeout(ChartTooltipTimeout);
                        ChartTooltipTimeout = window.setTimeout(function () {
                            RemoveChartTooltip();
                        }, TooltipTimeout);
                    }
                }
            });
        }
    };

    return TargetNS;
}(Core.UI.Chart || {}));