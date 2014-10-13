// --
// Core.UI.Table.Sort.js - table sorting functions
// Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.UI = Core.UI || {};
Core.UI.Table = Core.UI.Table || {};

/**
 * @namespace
 * @exports TargetNS as Core.UI.TableSort
 * @description
 *      This namespace contains all functions for client side table sorting
 */
Core.UI.Table.Sort = (function (TargetNS) {


    /**
     * @function
     * @description
     *      Custom text extractor. It will look if an hidden field with the class
     *      'SortData' is in the table cell and return its contents.
     * @param {jQueryObject or DOM object} $Node
     *      Current node of which the sorting data should be extracted
     * @return {String} Extracted text.
     */
    function CustomTextExtractor($Node) {
        return $($Node).find('.SortData').val() || '';
    }

    /**
     * @function
     * @description
     *      This function initializes the table sorting.
     *      If you have cells with special content like dates, you can
     *      put a hidden field with the class 'SortData' in them which contains
     *      a sortable text representation like an ISO date. This will then be
     *      used for the sorting.
     * @param {jQueryObject} $Table The table element which should be sorted
     * @param {Function} Finished A optional function, called after the sorting
     * @return nothing
     */
    TargetNS.Init = function ($Table, Finished) {
        if (isJQueryObject($Table)) {
            var $SortableColumns = $Table.find('th.Sortable'),
                $InitialSorting = $SortableColumns.filter('.InitialSorting'),
                SortOrder,
                Headers = {},
                InitialSort = [],
                ColumnCount = 0;

            // Only start, if there are columns that allow sorting
            if ($SortableColumns.length) {
                // Get all columns which should not be sorted
                $Table.find('th').each(function () {
                    if (!$(this).hasClass('Sortable')) {
                        Headers[ColumnCount] = { sorter: false };
                    }
                    ColumnCount++;
                });

                //Get the column, which should be sorted initially (can be only one)
                if ($InitialSorting.length === 1) {
                    SortOrder = $InitialSorting.hasClass('Descending') ? '1' : '0';
                    // Initially sort the specified column ascending (0) or descending (1)
                    InitialSort = [[$InitialSorting.index(), SortOrder]];
                }

                $Table.tablesorter({
                    headers: Headers,
                    sortList: InitialSort,
                    textExtraction: CustomTextExtractor
                });

                if ($.isFunction(Finished)) {
                    $Table.bind('sortEnd', Finished);
                }
            }
        }
    };

    return TargetNS;
}(Core.UI.Table.Sort || {}));