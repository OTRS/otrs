// --
// OTRS.UI.Chart.js - provides the Chart functions
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.UI.Chart.js,v 1.6 2010-06-02 10:43:06 mn Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};
OTRS.UI = OTRS.UI || {};

/**
 * @namespace
 * @exports TargetNS as OTRS.UI.Chart
 * @description
 *      Chart drawing
 * @requires
 *      jquery-flot
 */
OTRS.UI.Chart = (function (TargetNS) {

    if (!OTRS.Debug.CheckDependency('OTRS.UI.Chart', '$.plot', 'jQuery Flot API')) {
        return;
    }

    var Charts = {},
        PageCoordinates = [],
        ChartCoordinates = [],
        TooltipCoordinatesDelta = 10,
        ChartTooltipTimeout,
        TooltipTimeout = 500,
        PreviousPoint = null;

    function RemoveChartTooltip() {
        // remove chart tooltip only when mouse is moved away
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

    TargetNS.StartMouseTracking = function () {
        $(document).bind('mousemove.Chart', function (Event) {
            PageCoordinates = [ Event.pageX, Event.pageY ];
        });
    };

    TargetNS.StopMouseTracking = function () {
        $(document).unbind('mousemove.Chart');
    };

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
            OTRS.Exception.Throw("IE support for charts not loaded!", 'InternalError');
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
}(OTRS.UI.Chart || {}));