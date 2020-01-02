// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var Core = Core || {};
Core.UI = Core.UI || {};
Core.UI.Table = Core.UI.Table || {};

/**
 * @namespace Core.UI.Table.Sort
 * @memberof Core.UI.Table
 * @author OTRS AG
 * @description
 *      This namespace contains all functions for client side table sorting.
 */
Core.UI.Table.Sort = (function (TargetNS) {

    /**
     * @private
     * @name CustomTextExtractor
     * @memberof Core.UI.Table.Sort
     * @function
     * @returns {String} Extracted text.
     * @param {DOMObject} $Node - Current node of which the sorting data should be extracted.
     * @description
     *      Custom text extractor. It will look if an hidden field with the class
     *      'SortData' is in the table cell and return its contents.
     */
    function CustomTextExtractor($Node) {
        return $($Node).find('.SortData').val() || '';
    }

    /**
     * @name Init
     * @memberof Core.UI.Table.Sort
     * @function
     * @param {jQueryObject} $Table - The table element which should be sorted.
     * @param {Function} Finished  - An optional function, called after the sorting.
     * @description
     *      This function initializes the table sorting.
     *      If you have cells with special content like dates, you can
     *      put a hidden field with the class 'SortData' in them which contains
     *      a sortable text representation like an ISO date. This will then be
     *      used for the sorting.
     */
    TargetNS.Init = function ($Table, Finished) {
        var $SortableColumns,
            $InitialSorting,
            SortOrder,
            Headers = {},
            InitialSort = [],
            ColumnCount = 0;

        if (isJQueryObject($Table)) {
            $SortableColumns = $Table.find('th.Sortable');
            $InitialSorting = $SortableColumns.filter('.InitialSorting');

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
                    textExtraction: CustomTextExtractor,
                    language: {
                      sortAsc      : Core.Language.Translate('Ascending sort applied, '),
                      sortDesc     : Core.Language.Translate('Descending sort applied, '),
                      sortNone     : Core.Language.Translate('No sort applied, '),
                      sortDisabled : Core.Language.Translate('sorting is disabled'),
                      nextAsc      : Core.Language.Translate('activate to apply an ascending sort'),
                      nextDesc     : Core.Language.Translate('activate to apply a descending sort'),
                      nextNone     : Core.Language.Translate('activate to remove the sort')
                    }
                });

                if ($.isFunction(Finished)) {
                    $Table.on('sortEnd', Finished);
                }
            }
        }
    };

    return TargetNS;
}(Core.UI.Table.Sort || {}));
