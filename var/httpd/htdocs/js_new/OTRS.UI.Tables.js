// --
// OTRS.UI.Tables.js - Table specific functions
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.UI.Tables.js,v 1.3 2010-04-14 20:03:38 mg Exp $
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
 * @description
 *      This namespace contains table specific functions.
 */
OTRS.UI.Tables = (function (Namespace) {
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
    Namespace.InitCSSPseudoClasses = function ($Context) {
        $('tr.Even, tr.Last, th.Last, td.Last, li.Even, li.Last', $Context)
            .removeClass('Even Last');

        $('tr:nth-child(even), li:not(.Header):nth-child(odd)', $Context)
            .addClass('Even');

        $('tr:last-child, th:last-child, td:last-child, li:last-child', $Context)
            .addClass('Last');
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
    Namespace.InitTableFilter = function ($FilterInput, $Container) {
        $FilterInput.unbind('keydown.FilterInput').bind('keydown.FilterInput', function(){
            window.setTimeout(function(){
                var FilterText = ($FilterInput.val() || '').toLowerCase();
                if (FilterText.length) {
                    $Container.find('tbody tr, li:not(.Header)').hide();
                    $Container.find('tbody tr, li:not(.Header)').each(function(){
                        if ($(this).text().toLowerCase().indexOf(FilterText) > -1){
                            $(this).show();
                        }
                    });
                }
                else {
                    $Container.find('tbody tr, li').show();
                }
            }, 0);
        });
    };
    return Namespace;
}(OTRS.UI.Tables || {}));