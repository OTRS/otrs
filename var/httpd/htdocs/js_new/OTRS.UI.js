// --
// OTRS.UI.js - provides all UI functions
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.UI.js,v 1.15 2010-06-02 14:17:52 mn Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

/**
 * @namespace
 * @description
 *      This is the global OTRS namespace
 */
var OTRS = OTRS || {};

/**
 * @namespace
 * @exports TargetNS as OTRS.UI
 * @description
 *      This namespace contains all UI functions
 */
OTRS.UI = (function (TargetNS) {

    var IDGeneratorCount = 0;

    /**
     * @function
     * @description
     *      This function is used for the adjustment of the table head of OverviewSmall
     * @param {jQueryObject} $THead the thead thats th's should be adjusted
     * @param {jQueryObject} $TBody the tbody
     * @return nothing
     */
    TargetNS.AdjustTableHead = function ($THead, $TBody) {
        function CalculateColumnDimensions($TableHeadElement, $TableBodyElement) {
            var TableHeadWidth,
                TableHeadPadding,
                TableBodyWidth,
                TableBodyPadding;

            TableHeadWidth = $TableHeadElement.width();
            TableHeadPadding = parseInt($TableHeadElement.css('padding-left'), 10) + parseInt($TableHeadElement.css('padding-right'), 10);

            TableBodyWidth = $TableBodyElement.width();
            TableBodyPadding = parseInt($TableBodyElement.css('padding-left'), 10) + parseInt($TableBodyElement.css('padding-right'), 10);

            return {
                HeadWidth:      TableHeadWidth,
                HeadPadding:    TableHeadPadding,
                BodyWidth:      TableBodyWidth,
                BodyPadding:    TableBodyPadding
            };
        }

        var $TableHead = $THead.find('tr th'),
            $TableHeadElement,
            $TableBody = $TBody.find('tr:first td'),
            $TableBodyElement,
            $OverviewHeaderSmall = $THead.closest('.OverviewHeaderSmall'),
            $ActionRow = $THead.closest('.ActionRow'),
            TableOriginalWidth,
            Dimensions = {},
            ColumnNewWidth,
            Adjustment = {},
            I;

        // Restore original width of table parents (after resizing of window)
        if ($TBody.closest('div.Scroller').length) {
            $TBody.closest('div.Scroller').width('auto').parents('div:first').width('auto');
        }

        // Calculate the width of the table frame
        TableOriginalWidth = $TBody.closest('table').width();
        // Set table head to same width
        $THead.parents('table').width(TableOriginalWidth + 'px');

        // First round: adjust obvious differences
        for (I = 0; I < $TableBody.size(); I++) {
            $TableHeadElement = $TableHead.eq(I);
            $TableBodyElement = $TableBody.eq(I);

            // Skip column, if column has class "Fixed"
            if (!($TableHeadElement.hasClass('Fixed') || $TableBodyElement.hasClass('Fixed'))) {
                // Calculate the column dimensions
                Dimensions = CalculateColumnDimensions($TableHeadElement, $TableBodyElement);

                // The width of the new Head column
                ColumnNewWidth = Dimensions.BodyWidth + Dimensions.BodyPadding - Dimensions.HeadPadding;
                $TableHeadElement.width(ColumnNewWidth + 'px');

                // If now the head column is bigger than the body column, there's more text in the header than in the body
                // and we have to adjust the body columns
                // so calculate again!
                Dimensions = CalculateColumnDimensions($TableHeadElement, $TableBodyElement);

                // If header column is larger, save new body column width in array for later adjustment
                if ((Dimensions.HeadWidth + Dimensions.HeadPadding) > (Dimensions.BodyWidth + Dimensions.BodyPadding)) {
                    ColumnNewWidth = Dimensions.HeadWidth + Dimensions.HeadPadding - Dimensions.BodyPadding;
                    Adjustment[I] = ColumnNewWidth;
                }
            }
        }

        // Second round: Adjust the body columns as calculated before
        for (I = 0; I < $TableBody.size(); I++) {
            if (Adjustment[I]) {
                $TableBody.eq(I).width(Adjustment[I] + 'px');
            }
        }
    };

    /**
     * @function
     * @description
     *      This function makes the control div static if it hits the top
     * @param {jQueryObject} $Control the control div
     * @return nothing
     */
    TargetNS.StaticTableControl = function ($Control) {
        var Offset = $Control.offset().top,
            Height = $Control.height();

        $(window).scroll(function (event) {
            var y = $(this).scrollTop(),
                Height = $Control.height();

            // TODO: Cache the class and css changes

            if (y >= Offset) {
                $Control.addClass('Fixed');
                $Control.nextAll('.Overview:first').css('margin-top', Height);
            }
            else {
                $Control.removeClass('Fixed');
                $Control.nextAll('.Overview:first').css('margin-top', 0);
            }
        });
    };

    /**
     * @function
     * @description
     *      This function initializes the toggle mechanism for all widgets with a WidgetAction toggle icon
     * @return nothing
     */
    TargetNS.InitWidgetActionToggle = function () {
        $(".WidgetAction.Toggle > a")
            .each(function () {
                var $WidgetElement = $(this).closest("div.Header").parent('div');
                    ContentDivID = TargetNS.GetID($WidgetElement.children('.Content'));
                $(this)
                    .attr('aria-controls', ContentDivID)
                    .attr('aria-expanded', $WidgetElement.hasClass('Expanded'));
            })
            .unbind('click.WidgetToggle')
            .bind('click.WidgetToggle', function () {
                var $WidgetElement = $(this).closest("div.Header").parent('div'),
                    Animate = $WidgetElement.hasClass('Animate');

                if (Animate && OTRS.Config.Get('AnimationEnabled')) {
                    $WidgetElement.find('.Content').slideToggle("slow");
                }

                $WidgetElement
                    .toggleClass('Collapsed')
                    .toggleClass('Expanded')
                    .end()
                    .end()
                    .attr('aria-expanded', $(this).closest("div.Header").parent('div').hasClass('Expanded'));
                return false;
            });
    };

    /**
     * @function
     * @description
     *      This function initializes the close buttons for the message boxes that show server messages
     * @return nothing
     */
    TargetNS.InitMessageBoxClose = function () {
        $(".MessageBox > a.Close")
            .unbind('click.MessageBoxClose')
            .bind('click.MessageBoxClose', function (Event) {
                $(this).parent().remove();
                Event.preventDefault();
            });
    };

    /**
     * @function
     * @description
     *      This function adds special not valid attributes to HTML via javascript
     * @return nothing
     */
    TargetNS.ProcessTagAttributeClasses = function () {
        $('.AutocompleteOff')
            .attr('autocomplete', 'off');
    };

    /**
     * @function
     * @description
     *      Returns the ID of the Element and creates one for it if nessessary.
     * @param {jQueryObject} Element
     * @return {String} ID
     */
    TargetNS.GetID = function ($Element) {
        var ID = $Element.attr('id');
        if (!ID) {
            $Element.attr('id', ID = 'OTRS_UI_AutogeneratedID_' + IDGeneratorCount++);
            // Debug this
            OTRS.Debug.Log('Auto-generated required ID ' + ID + ' for element', $Element);
        }
        return ID;
    };

    /**
     * @function
     * @description
     *      This function is the wrapper for registering an event on an HTML element.
     * @param {String} EventType The event type (click, change, ...)
     * @param {jQueryObject} $Element the element(s) on which the event is triggered
     * @param {Function} EventFunction The function which should be executed on event (gets Parameter Event)
     */
    TargetNS.RegisterEvent = function (EventType, $Element, EventFunction) {
        if (isJQueryObject($Element) && $Element.length && $.isFunction(EventFunction)) {
            $Element.bind(EventType, EventFunction);
        }
    };

    /**
     * @function
     * @description
     *      This function is the wrapper for registering an live event on an HTML element.
     * @param {String} EventType The event type (click, change, ...)
     * @param {jQueryObject} $Element the element(s) on which the event is triggered
     * @param {Function} EventFunction The function which should be executed on event (gets Parameter Event)
     */
    TargetNS.RegisterLiveEvent = function (EventType, $Element, EventFunction) {
        if (isJQueryObject($Element) && $Element.length && $.isFunction(EventFunction)) {
            $Element.live(EventType, EventFunction);
        }
    };

    /**
     * @function
     * @description
     *      This functions toggles two Containers with a nice slide effect.
     * @param {jQueryObject} $Element1 First container element
     * @param {jQueryObject} $Element1 Second container element
     */
    TargetNS.ToggleTwoContainer = function ($Element1, $Element2) {
        if (isJQueryObject($Element1, $Element2) && $Element1.length && $Element2.length) {
            $Element1.slideToggle('fast', function () {
                $Element2.slideToggle('fast');
            });
        }
    };

    TargetNS.RegisterToggleTwoContainer = function ($ClickedElement, $Element1, $Element2) {
        if (isJQueryObject($ClickedElement) && $ClickedElement.length) {
            $ClickedElement.click(function () {
                TargetNS.ToggleTwoContainer($Element1, $Element2);
                return false;
            });
        }
    };

    return TargetNS;
}(OTRS.UI || {}));