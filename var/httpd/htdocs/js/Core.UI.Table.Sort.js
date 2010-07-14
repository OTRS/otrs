// --
// Core.UI.Table.Sort.js - table sorting functions
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.UI.Table.Sort.js,v 1.1 2010-07-14 10:09:47 mn Exp $
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
     *      This function initializes the table sorting.
     * @param {jQueryObject} $Table The table element which should be sorted
     * @return nothing
     */
    TargetNS.Init = function ($Table) {
        if (isJQueryObject($Table)) {
            var $SortableColumns = $Table.find('th.Sortable'),
                $InitialSorting = $SortableColumns.filter('.InitialSorting'),
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
                    // Initially sort the specified column ascending
                    InitialSort = [[$InitialSorting.index(), 0]];
                }

                $Table.tablesorter({
                    headers: Headers,
                    sortList: InitialSort
                });
            }
        }
    };

    return TargetNS;
}(Core.UI.Table.Sort || {}));