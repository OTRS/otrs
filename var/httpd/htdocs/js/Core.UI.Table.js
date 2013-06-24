// --
// Core.UI.Table.js - Table specific functions
// Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.UI = Core.UI || {};

/**
 * @namespace
 * @exports TargetNS as Core.UI.Table
 * @description
 *      This namespace contains table specific functions.
 */
Core.UI.Table = (function (TargetNS) {
    /**
     * @function
     * @description
     *      This function sets some default classes on table rows and cells because
     *      CSS 2.1 does not contain the needed functionality yet.
     *      Every second <tr> will get the class "Even", and every last <tr>, <th> and <td>
     *      will receive the class "Last".
     *      This function also applies the specific classes to list elements of the
     *      type "tablelike".
     * @param {jQueryObject} Context to operate in (e.g. a specific table).
     *      If not provided, this function will work on all tables.
     * @return nothing
     */
    TargetNS.InitCSSPseudoClasses = function ($Context) {
        var SelectorCount = 0;
        if (typeof $Context === 'undefined' || (isJQueryObject($Context) && $Context.length)) {
            // comma-separated selectors have performance issues, so we add the different selectors after each other
            $('tr.Even', $Context)
                .add('tr.Last', $Context)
                .add('th.Last', $Context)
                .add('td.Last', $Context)
                .add('li.Even', $Context)
                .add('li.Last', $Context)
                .removeClass('Even Last');

            // nth-child selector has heavy performance problems on big tables or lists
            // Because these CSS classes are only used on IE8, we skip these for big tables and lists
            SelectorCount = $('tr', $Context).length + $('li:not(.Header)', $Context).length;
            if (SelectorCount < 200) {
                $('tr:nth-child(even)', $Context)
                .add('li:not(.Header):nth-child(even)', $Context)
                .addClass('Even');
            }

            // comma-seperated selectors have performance issues, so we add the different selectors after each other
            $('tr:last-child', $Context).addClass('Last');
            $('th:last-child', $Context).addClass('Last');
            $('td:last-child', $Context).addClass('Last');
            $('li:last-child', $Context).addClass('Last');
        }
    };

    /**
     * @function
     * @description
     *      This function initializes a filter input field which can be used to
     *      dynamically filter a table or a list with the class TableLike (e.g. in the admin area overviews).
     * @param {jQueryObject} $FilterInput Filter input element
     * @param {jQueryObject} $Container Table or list to be filtered
     * @return nothing
     */
    TargetNS.InitTableFilter = function ($FilterInput, $Container, ColumnNumber) {
        var Timeout,
            $Rows = $Container.find('tbody tr:not(.FilterMessage), li:not(.Header):not(.FilterMessage)'),
            $Elements = $Rows.closest('tr, li');

        // Only search in one special column of the table
        if (typeof ColumnNumber === 'string' || typeof ColumnNumber === 'number') {
            $Rows = $Rows.find('td:eq(' + ColumnNumber + ')');
        }

        $FilterInput.unbind('keydown.FilterInput').bind('keydown.FilterInput', function () {

            window.clearTimeout(Timeout);
            Timeout = window.setTimeout(function () {

                /**
                 * @function
                 * @private
                 * @param {jQueryObject} Element that will be checked
                 * @param {String} FilterText The current filter text
                 * @return A true value
                 * @description Ckeck if a text exist inside an element
                 */
                function CheckText($Element, FilterText) {
                    var Text;

                    Text = $Element.text();
                    if (Text && Text.toLowerCase().indexOf(FilterText) > -1){
                        return true;
                    }

                    if ($Element.is('li, td')) {
                        Text = $Element.attr('title');
                        if (Text && Text.toLowerCase().indexOf(FilterText) > -1) {
                            return true;
                        }
                    }
                    else {
                        $Element.find('td').each(function () {
                            Text = $(this).attr('title');
                            if (Text && Text.toLowerCase().indexOf(FilterText) > -1) {
                                return true;
                            }
                        });
                    }

                    return false;
                }

                var FilterText = ($FilterInput.val() || '').toLowerCase();
                if (FilterText.length) {
                    $Elements.hide();
                    $Rows.each(function () {
                        if (CheckText($(this), FilterText)) {
                            $(this).closest('tr, li').show();
                        }
                    });
                }
                else {
                    $Elements.show();
                }

                if ($Rows.filter(':visible').length) {
                    $Container.find('.FilterMessage').hide();
                }
                else {
                    $Container.find('.FilterMessage').show();
                }

            }, 100);
        });

        // Prevent submit when the Return key was pressed
        $FilterInput.unbind('keypress.FilterInput').bind('keypress.FilterInput', function (Event) {
            if ((Event.charCode || Event.keyCode) === 13) {
                Event.preventDefault();
            }
        });
    };

    return TargetNS;
}(Core.UI.Table || {}));