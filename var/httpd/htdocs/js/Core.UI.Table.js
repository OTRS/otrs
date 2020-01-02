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

/**
 * @namespace Core.UI.Table
 * @memberof Core.UI
 * @author OTRS AG
 * @description
 *      This namespace contains table specific functions.
 */
Core.UI.Table = (function (TargetNS) {
    /**
     * @name InitTableFilter
     * @memberof Core.UI.Table
     * @function
     * @param {jQueryObject} $FilterInput - Filter input element.
     * @param {jQueryObject} $Container - Table or list to be filtered.
     * @param {Number|String} ColumnNumber - Only search in thsi special column of the table (counting starts with 0).
     * @param {Boolean} HideEmptyContainers - hide containers of type .WidgetSimple which don't contain any search results.
     * @description
     *      This function initializes a filter input field which can be used to
     *      dynamically filter a table or a list with the class TableLike (e.g. in the admin area overviews).
     */
    TargetNS.InitTableFilter = function ($FilterInput, $Container, ColumnNumber, HideEmptyContainers) {
        var Timeout;

        $FilterInput.wrap('<span class="TableFilterContainer" />');

        $FilterInput.off('keydown.FilterInput').on('keydown.FilterInput', function () {

            window.clearTimeout(Timeout);
            Timeout = window.setTimeout(function () {

                var FilterText = ($FilterInput.val() || '').toLowerCase(),

                // Get table rows again in case something has changed since page has loaded.
                $Rows = $Container.find('tbody tr:not(.FilterMessage), li:not(.Header):not(.FilterMessage)'),
                $Elements = $Rows.closest('tr, li');

                 // Only search in one special column of the table.
                if (typeof ColumnNumber === 'string' || typeof ColumnNumber === 'number') {
                    $Rows = $Rows.find('td:eq(' + ColumnNumber + ')');
                }

                /**
                 * @private
                 * @name CheckText
                 * @memberof Core.UI.Table.InitTableFilter
                 * @function
                 * @returns {Boolean} True if text was found, false otherwise.
                 * @param {jQueryObject} $Element - Element that will be checked.
                 * @param {String} Filter - The current filter text.
                 * @description
                 *      Check if a text exist inside an element.
                 */
                function CheckText($Element, Filter) {
                    var Text;

                    Text = $Element.text();
                    if (Text && Text.toLowerCase().indexOf(Filter) > -1){
                        return true;
                    }

                    if ($Element.is('li, td')) {
                        Text = $Element.attr('title');
                        if (Text && Text.toLowerCase().indexOf(Filter) > -1) {
                            return true;
                        }
                    }
                    else {
                        $Element.find('td').each(function () {
                            Text = $(this).attr('title');
                            if (Text && Text.toLowerCase().indexOf(Filter) > -1) {
                                return true;
                            }
                        });
                    }

                    return false;
                }

                if (FilterText.length) {

                    if (!$FilterInput.next('.FilterRemove').length) {
                        $FilterInput.after('<a href="#" class="FilterRemove"><i class="fa fa-times"></i></a>').next('.FilterRemove').attr('title', Core.Language.Translate('Remove the filter')).off('click.RemoveFilter').on('click.RemoveFilter', function() {
                            $(this).prev('input').val('').trigger('keydown').focus();
                        }).fadeIn();
                    }

                    $Elements.hide();
                    $Rows.each(function () {
                        if (CheckText($(this), FilterText)) {
                            $(this).closest('tr, li').show();
                        }
                    });
                }
                else {
                    $FilterInput.next('.FilterRemove').fadeOut(function() {
                        $(this).remove();
                    });
                    $Elements.show();
                    $('#SelectAllrw').removeClass('Disabled');
                    $('table th input:not([name="rw"]:visible)').prop('disabled', false);

                    // Disable top row if all rw elements are checked.
                    if($('input[type="checkbox"][name="rw"]').length !== 0 &&
                        $('input[type="checkbox"][name="rw"]').not('#SelectAllrw').filter(':checked').length ===
                        $('input[type="checkbox"][name="rw"]').not('#SelectAllrw').length){
                        $('table th input:not([name="rw"]:visible)').prop('disabled', true);
                        $('#SelectAllrw').addClass('Disabled');
                    }
                }

                // Handle containers correctly.
                $Container.each(function() {
                    var $Widget = $(this).closest('.WidgetSimple'),
                        IsCollapsed = $Widget.hasClass('Collapsed');

                    $Widget.show();
                    if (IsCollapsed) {
                        // Expand widget for a moment.
                        $Widget.addClass("Expanded").removeClass("Collapsed");
                    }

                    if ($(this).find('tbody tr:visible:not(.FilterMessage), li:visible:not(.Header):not(.FilterMessage)').length) {
                        $(this).find('.FilterMessage').hide();

                        if (HideEmptyContainers) {
                            $(this).closest('.WidgetSimple').show();
                        }
                    }
                    else {
                        $(this).find('.FilterMessage').show();
                        if (HideEmptyContainers) {
                            $(this).closest('.WidgetSimple').hide();
                        }
                    }

                    if (IsCollapsed) {
                        // Collapse widget, just like it was before.
                        $Widget.addClass("Collapsed").removeClass("Expanded");
                    }
                });

                if (!$Container.filter(':visible').length
                    && !$Container.closest(".WidgetSimple:visible").length) {
                    $('.FilterMessageWidget').show();
                }
                else {
                    $('.FilterMessageWidget').hide();
                }

                Core.App.Publish('Event.UI.Table.InitTableFilter.Change', [$FilterInput, $Container, ColumnNumber]);

            }, 100);
        });

        // Prevent submit when the Return key was pressed
        $FilterInput.off('keypress.FilterInput').on('keypress.FilterInput', function (Event) {
            if ((Event.charCode || Event.keyCode) === 13) {
                Event.preventDefault();
            }
        });
    };

    return TargetNS;
}(Core.UI.Table || {}));
