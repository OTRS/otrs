// --
// Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.UI = Core.UI || {};

/**
 * @namespace Core.UI.InputFields
 * @memberof Core.UI
 * @author OTRS AG
 * @description
 *      Unified input fields.
 */
Core.UI.InputFields = (function (TargetNS) {

    /**
     * @private
     * @name Config
     * @memberof Core.UI.InputFields
     * @member {Object}
     * @description
     *      Configuration object.
    */
    var Config = {
        InputFieldPadding: 3,
        SelectionBoxOffsetLeft: 5,
        SelectionBoxOffsetRight: 5,
        MaxAutocompleteResults: 20,
        ErrorClass: 'Error',
        ServerErrorClass: 'ServerError',
        FadeDuration: 150,
        SelectionNotAvailable: ' -',
        ResizeEvent: 'onorientationchange' in window ? 'orientationchange' : 'resize',
        ResizeTimeout: 0
    };

    /**
     * @name Activate
     * @memberof Core.UI.InputFields
     * @param {jQueryObject} [$Context] - jQuery object for context (optional)
     * @description
     *      Activate the feature on all applicable fields in supplied context.
     */
    TargetNS.Activate = function ($Context) {

        // Initialize select fields on all applicable fields
        TargetNS.InitSelect($('select.Modernize', $Context));

        // Initialize autocomplete fields on all applicable fields
        TargetNS.InitAutocomplete($('input.Modernize', $Context));
    };

    /**
     * @name Deactivate
     * @memberof Core.UI.InputFields
     * @param {jQueryObject} [$Context] - jQuery object for context (optional)
     * @description
     *      Deactivate the feature on all applicable fields in supplied context
     *      and restore original fields.
     */
    TargetNS.Deactivate = function ($Context) {

        // Restore select fields
        $('select.Modernize', $Context).each(function (Index, SelectObj) {
            var $SelectObj = $(SelectObj),
                $SearchObj = $('#' + $SelectObj.data('modernized')),
                $ShowTreeObj = $SelectObj.next('.ShowTreeSelection');

            if ($SelectObj.data('modernized')) {
                $SearchObj.parents('.InputField_Container')
                    .blur()
                    .remove();
                $SelectObj.show();
                $ShowTreeObj.show();
            }
        });

        // Restore autocomplete fields
        $('input.Modernize', $Context).each(function (Index, AutocompleteObj) {
            var $AutocompleteObj = $(AutocompleteObj);

            $AutocompleteObj.blur()
                .removeAttr('autocomplete')
                .off('focus.InputField')
                .off('keyup.InputField')
                .off('blur.InputField')
                .off('keydown');
        });
    };

    /**
     * @private
     * @name InitCallback
     * @memberof Core.UI.InputFields
     * @function
     * @description
     *      Initialization callback function.
     */
    function InitCallback() {

        // Check SysConfig
        if (Core.Config.Get('InputFieldsActivated') === 1) {

            // Activate the feature
            TargetNS.Activate();
        }
    }

    /**
     * @name Init
     * @memberof Core.UI.InputFields
     * @function
     * @description
     *      This function initializes all input field types.
     */
    TargetNS.Init = function () {
        InitCallback();
        Core.App.Subscribe('Event.UI.ToggleWidget', InitCallback);
    };

    /**
     * @private
     * @name CheckAvailability
     * @memberof Core.UI.InputFields
     * @param {jQueryObject} $SelectObj - Original select field
     * @param {jQueryObject} $SearchObj - Search input field
     * @description
     *      Checks if there are available options for selection in the supplied field
     *      and disabled the field if that is not the case.
     */
    function CheckAvailability($SelectObj, $SearchObj) {

        // Check if there are only empty and disabled options
        if ($SelectObj.find('option')
                .not("[value='']")
                .not("[value='-||']")
                .not('[disabled]')
                .length === 0
            )
        {

            // Disable the field, add the tooltip and dash string
            $SearchObj.attr('disabled', 'disabled')
                .data('disabled', true)
                .attr('title', Core.Config.Get('InputFieldsNotAvailable'))
                .val(Config.SelectionNotAvailable);
        }
        else {

            // Enable the field, remove the tooltip and dash string
            $SearchObj.removeAttr('disabled')
                .removeData('disabled')
                .removeAttr('title')
                .val('');
        }
    }

    /**
     * @private
     * @name ShowSelectionBoxes
     * @memberof Core.UI.InputFields
     * @param {jQueryObject} $SelectObj - Original select field
     * @param {JQueryObject} $InputContainerObj - Container for associated input field
     * @description
     *      Creates and displays selection boxes in available width,
     *      and lists number of additional selected values.
     */
    function ShowSelectionBoxes($SelectObj, $InputContainerObj) {
        var Selection,
            SelectionLength,
            i = 0,
            OffsetLeft = 0,
            OffsetRight = Config.SelectionBoxOffsetRight,
            MoreBox = false,
            Multiple = ($SelectObj.attr('multiple') !== '' && $SelectObj.attr('multiple') !== undefined) ? true : false,
            PossibleNone = false,
            SelectionString = Core.Config.Get('InputFieldsSelection'),
            MoreString = Core.Config.Get('InputFieldsMore'),
            MaxWidth,
            $TempMoreObj;

        // Remove any existing boxes in supplied container
        $InputContainerObj.find('.InputField_Selection').remove();
        $InputContainerObj.find('.InputField_More').remove();

        $SelectObj.find('option').each(function (Index, Option) {
            if ($(Option).attr('value') === '' || $(Option).attr('value') === '||-') {
                PossibleNone = true;
                return true;
            }
        });

        // Check if we have a selection at all
        if ($SelectObj.val()) {

            // Maximum available width for boxes
            MaxWidth = $InputContainerObj.find('.InputField_Search').width();

            // Check which kind of selection we are dealing with
            if ($.isArray($SelectObj.val())) {
                Selection = $.unique($SelectObj.val());
                SelectionLength = Selection.length;
            } else {
                Selection = [ $SelectObj.val() ];
                SelectionLength = 1;
            }

            // Calculate width for hypothetical more string
            if (SelectionLength > 1) {
                $TempMoreObj = $('<div />').hide()
                    .addClass('InputField_More')
                    .text(MoreString.replace(/%s/, '##'))
                    .appendTo($InputContainerObj);

                // Save place for string
                MaxWidth -= $TempMoreObj.outerWidth();

                // Remove temporary more string
                $TempMoreObj.remove();
            }

            // Iterate through all selected values
            $.each(Selection, function (Index, Value) {
                var $SelectionObj,
                    Text,
                    $TextObj,
                    $RemoveObj;

                // Skip empty value
                if (Value === '' || Value === '||-') {
                    return true;
                }

                // Selection box container
                $SelectionObj = $('<div />').appendTo($InputContainerObj);
                $SelectionObj.addClass('InputField_Selection')
                    .data('value', Value);

                // Textual representation of selected value
                Text = $SelectObj.find('option[value="' + Value + '"]').first().text().trim();
                $TextObj = $('<div />').appendTo($SelectionObj);
                $TextObj.addClass('Text')
                    .text(Text)
                    .off('click.InputField').on('click.InputField', function () {
                        $InputContainerObj.find('.InputField_Search')
                            .trigger('focus');
                    });

                // Remove button
                if (PossibleNone || Multiple) {
                    $RemoveObj = $('<div />').appendTo($SelectionObj);
                    $RemoveObj.addClass('Remove')
                        .append(
                            $('<a />').attr('href', '#')
                                .attr('title', Core.Config.Get('InputFieldsRemoveSelection'))
                                .text('x')
                                .attr('role', 'button')
                                .attr('aria-label', Core.Config.Get('InputFieldsRemoveSelection') + ': ' + Text)
                                .off('click.InputField').on('click.InputField', function () {
                                    var HasEmptyElement = $SelectObj.find('option[value=""]').length === 0 ? false : true,
                                        SelectedValue = $(this).parents('.InputField_Selection')
                                            .data('value');
                                    Selection.splice(Selection.indexOf(SelectedValue), 1);
                                    if (HasEmptyElement && Selection.length === 0) {
                                        $SelectObj.val('');
                                    }
                                    else {
                                        $SelectObj.val(Selection);
                                    }
                                    ShowSelectionBoxes($SelectObj, $InputContainerObj);
                                    setTimeout(function () {
                                        $SelectObj.trigger('change');
                                        Core.Form.Validate.ValidateElement($SelectObj);
                                    }, 50);
                                    return false;
                                })
                        );
                }

                // Indent first box from the left
                if (OffsetLeft === 0) {
                    OffsetLeft = Config.SelectionBoxOffsetLeft;
                }

                // Check if we exceed available width of the container
                if (OffsetLeft + $SelectionObj.outerWidth() < MaxWidth) {

                    // Offset the box and show it
                    if ($('body').hasClass('RTL')) {
                        $SelectionObj.css('right', OffsetLeft + 'px')
                            .show();
                    }
                    else {
                        $SelectionObj.css('left', OffsetLeft + 'px')
                            .show();
                    }

                } else {

                    // Check if we already displayed more box
                    if (!MoreBox) {
                        $SelectionObj.after(
                            $('<div />').addClass('InputField_More')
                            .css(($('body').hasClass('RTL') ? 'right' : 'left'), OffsetLeft + 'px')
                            .text(
                                (i > 0) ?
                                    MoreString.replace(/%s/, SelectionLength - i) :
                                    SelectionString.replace(/%s/, SelectionLength)
                            )
                            .on('click.InputField', function () {
                                $InputContainerObj.find('.InputField_Search')
                                    .trigger('focus');
                            })
                        );
                        MoreBox = true;
                    }

                    // Remove superfluous box
                    $SelectionObj.remove();

                    // Break each loop
                    return false;
                }

                // Increment the offset with the width of box and right margin
                OffsetLeft += $SelectionObj.outerWidth() + OffsetRight;

                i++;
            });

        }

    }

    /**
     * @private
     * @name HideSelectList
     * @memberof Core.UI.InputFields
     * @param {jQueryObject} $SelectObj - Original select field
     * @param {JQueryObject} $InputContainerObj - Container for associated input field
     * @param {JQueryObject} $SearchObj - Search input field
     * @param {JQueryObject} $ListContainerObj - List container
     * @param {JQueryObject} $TreeContainerObj - Container for jsTree list
     * @description
     *      Remove complete jsTree list and action buttons.
     */
    function HideSelectList($SelectObj, $InputContainerObj, $SearchObj, $ListContainerObj, $TreeContainerObj) {

        // Remove jsTree if it exists
        if ($ListContainerObj && $TreeContainerObj) {
            $ListContainerObj.fadeOut(Config.FadeDuration, function () {
                $TreeContainerObj.find('.jstree')
                    .jstree('destroy')
                    .remove();
                $(this).remove();
            });
            $InputContainerObj.find('.InputField_ClearSearch')
                .remove();
            $SearchObj.removeAttr('aria-expanded');
        }

        // Clear search field
        if ($SearchObj.val() !== Config.SelectionNotAvailable && !$SearchObj.attr('disabled')) {
            $SearchObj.val('');
        }

        // Show selection boxes
        ShowSelectionBoxes($SelectObj, $InputContainerObj);

        // Trigger change event on original field (see bug#11419)
        if ($SelectObj.data('changed')) {
            $SelectObj.removeData('changed');
            setTimeout(function () {
                $SelectObj.trigger('change');
                Core.Form.Validate.ValidateElement($SelectObj);
            }, 50);
        }
    }

    /**
     * @private
     * @name RegisterActionEvent
     * @memberof Core.UI.InputFields
     * @param {jQueryObject} $TreeObj - Tree view object
     * @param {jQueryObject} $ActionObj - Action link object
     * @param {String} ActionType - Type of the action
     * @description
     *      Register click handler for supplied action.
     */
    function RegisterActionEvent($TreeObj, $ActionObj, ActionType) {

        switch (ActionType) {

            case 'SelectAll':
                $ActionObj.off('click.InputField').on('click.InputField', function () {

                    // Make sure subtrees of all nodes are expanded
                    $TreeObj.jstree('open_all');

                    // Select all nodes
                    $TreeObj.find('li')
                        .not('.jstree-clicked,.Disabled')
                        .each(function () {
                            $TreeObj.jstree('select_node', this);
                        });

                    return false;

                // Prevent clicks on action to steal focus from search field
                }).on('mousedown.InputField', function () {
                    return false;
                });
                break;

            case 'SelectAll_Search':
                $ActionObj.off('click.InputField').on('click.InputField', function () {

                    // Select only matched values
                    $TreeObj.find('li:visible .jstree-search')
                        .not('.jstree-clicked,.Disabled')
                        .each(function () {
                            $TreeObj.jstree('select_node', this);
                        });
                });
                break;

            case 'ClearAll':
                $ActionObj.off('click.InputField').on('click.InputField', function () {

                    // Clear selection
                    $TreeObj.jstree('deselect_node', $TreeObj.jstree('get_selected'));

                    return false;

                // Prevent clicks on action to steal focus from search field
                }).on('mousedown.InputField', function () {
                    return false;
                });
                break;

            case 'ClearAll_Search':
                $ActionObj.off('click.InputField').on('click.InputField', function () {

                    // Deselect only matched values
                    var SelectedNodesIDs = $TreeObj.jstree('get_selected');
                    $.each(SelectedNodesIDs, function () {
                        var $Node = $('#' + this);
                        if ($Node.is(':visible')) {
                            $TreeObj.jstree('deselect_node', this);
                        }
                    });
                });
                break;

            case 'Confirm':
                $ActionObj.off('click.InputField').on('click.InputField', function () {

                    // Hide the list
                    $TreeObj.blur();

                    return false;

                });
                break;
        }
    }

    /**
     * @private
     * @name ApplyFilter
     * @memberof Core.UI.InputFields
     * @param {jQueryObject} $SelectObj - Select object
     * @param {jQueryObject} $ToolbarContainerObj - Container for toolbar actions
     * @description
     *      Apply active filter on select field.
     */
    function ApplyFilter($SelectObj, $ToolbarContainerObj) {
        var Selection,
            FilterIndex;

        // Save selection
        if ($SelectObj.val()) {

            // Check which kind of selection we are dealing with
            if ($.isArray($SelectObj.val())) {
                Selection = $SelectObj.val();
            } else {
                Selection = [ $SelectObj.val() ];
            }

            $SelectObj.data('selection', Selection);
        }

        $SelectObj.empty();

        if ($SelectObj.data('filtered') && $SelectObj.data('filtered') !== '0') {
            FilterIndex = parseInt($SelectObj.data('filtered'), 10) - 1;

            // Insert filtered data
            $.each($SelectObj.data('filters').Filters[FilterIndex].Data, function (Index, Option) {
                var $OptionObj = $('<option />');
                $OptionObj.attr('value', Option.Key)
                    .text(Option.Value);
                if (Option.Disabled) {
                    $OptionObj.attr('disabled', true);
                }
                if (Option.Selected) {
                    $OptionObj.attr('selected', true);
                }
                $SelectObj.append($OptionObj);
            });

            // Add class
            if ($ToolbarContainerObj) {
                if (
                    !$ToolbarContainerObj.find('.InputField_Filters')
                        .hasClass('Active')
                    )
                {
                    $ToolbarContainerObj.find('.InputField_Filters')
                        .addClass('Active')
                        .prepend('<i class="fa fa-filter" /> ');
                }
            }
        }
        else {

            // Remove class
            if ($ToolbarContainerObj) {
                $ToolbarContainerObj.find('.InputField_Filters')
                    .removeClass('Active')
                    .find('.fa.fa-filter')
                    .remove();
            }

            // Restore original data
            $SelectObj.append($SelectObj.data('original'));
        }

        // Restore selection
        if ($SelectObj.data('selection')) {
            $SelectObj.val($SelectObj.data('selection'));
            $SelectObj.removeData('selection');
        }
    }

    /**
     * @private
     * @name RegisterFilterEvent
     * @memberof Core.UI.InputFields
     * @param {jQueryObject} $SelectObj - Select object
     * @param {jQueryObject} $InputContainerObj - Container object for associated input field
     * @param {jQueryObject} $ToolbarContainerObj - Container for toolbar actions
     * @param {jQueryObject} $FilterObj - Filter object
     * @param {String} ActionType - Type of the action
     * @description
     *      Register click handler for supplied action.
     */
    function RegisterFilterEvent($SelectObj, $InputContainerObj, $ToolbarContainerObj, $FilterObj, ActionType) {
        var $SearchObj;

        switch (ActionType) {

            case 'ShowFilters':
                $FilterObj.off('click.InputField').on('click.InputField', function () {
                    var $FiltersListObj = $ToolbarContainerObj.find('.InputField_FiltersList');

                    // Hide filter list
                    if ($FiltersListObj.is(':visible')) {
                        $FiltersListObj.hide();
                    }

                    // Show filter list
                    else {
                        $FiltersListObj.show();
                    }

                    return false;

                // Prevent clicks on action to steal focus from search field
                }).on('mousedown.InputField', function () {
                    return false;
                });
                break;

            case 'Filter':
                $FilterObj.off('click.InputField').on('click.InputField', function () {

                    // Allow selection of only one filter
                    $FilterObj.siblings('input').each(function (Index, Filter) {
                        if ($(Filter).attr('id') !== $FilterObj.attr('id')) {
                            $(Filter).attr('checked', false);
                        }
                    });
                })

                // Handle checkbox change
                .off('change.InputField').on('change.InputField', function () {

                    // Set filter
                    if (this.checked) {
                        $SelectObj.data('filtered', $FilterObj.data('index'));
                    }

                    // Clear filter
                    else {
                        $SelectObj.data('filtered', '0');
                    }

                    // Apply filter
                    ApplyFilter($SelectObj, $ToolbarContainerObj);

                    // Refresh the field and get focus
                    $SearchObj = $('#' + $SelectObj.data('modernized'));
                    $SearchObj.width($SelectObj.outerWidth())
                        .trigger('blur');
                    CheckAvailability($SelectObj, $SearchObj);
                    setTimeout(function () {
                        $SearchObj.focus();
                    }, 50);
                })

                // Prevent clicks on action to steal focus from search field
                .on('mousedown.InputField', function () {
                    return false;
                });
                break;
        }
    }

    /**
     * @private
     * @name FocusNextElement
     * @memberof Core.UI.InputFields
     * @param {jQueryObject} $Element - Form element
     * @description
     *      Focus next element in form.
     */
    function FocusNextElement($Element) {

        // Get all tabbable and visible elements in the same form
        var $TabbableElements = $Element.closest('form')
            .find(':tabbable:visible');

        // Advance index for one element and trigger focus
        setTimeout(function () {
            $TabbableElements.eq($TabbableElements.index($Element) + 1)
                .focus();
        }, 50);
    }

    /**
     * @name InitSelect
     * @memberof Core.UI.InputFields
     * @function
     * @returns {Boolean} Returns true if successfull, false otherwise
     * @param {jQueryObject} $SelectFields - Fields to initialize.
     * @description
     *      This function initializes select input fields, based on supplied CSS selector.
     */
    TargetNS.InitSelect = function ($SelectFields) {

        // Give up if no select fields are found
        if (!$SelectFields.length) {
            return false;
        }

        // Iterate over all found fields
        $SelectFields.each(function (Index, SelectObj) {

            // Global variables
            var $ToolbarContainerObj,
                $InputContainerObj,
                $TreeContainerObj,
                $ListContainerObj,
                $ContainerObj,
                $ToolbarObj,
                $SearchObj,
                $SelectObj,
                $LabelObj,
                Multiple,
                TreeView,
                Focused,
                TabFocus,
                SearchID,
                SkipFocus,
                Searching,
                Filterable,
                SelectWidth,
                $FiltersObj,
                $ShowTreeObj,
                $FiltersListObj;

            // Only initialize new elements if original field is valid and visible
            if ($(SelectObj).is(':visible')) {

                // Initialize variables
                $SelectObj = $(SelectObj);
                Multiple = ($SelectObj.attr('multiple') !== '' && $SelectObj.attr('multiple') !== undefined) ? true : false;
                Filterable = ($SelectObj.data('filters') !== '' && $SelectObj.data('filters') !== undefined) ? true : false;
                TreeView = false;
                SkipFocus = false;
                TabFocus = false;
                Searching = false;
                Focused = null;

                // Get width now, since we will hide the element
                SelectWidth = $SelectObj.outerWidth();

                // Hide original field
                $SelectObj.hide();

                // Check to see if tree view should be displayed
                $ShowTreeObj = $SelectObj.next('.ShowTreeSelection');
                if ($ShowTreeObj.length) {
                    $ShowTreeObj.hide();
                    TreeView = true;
                }

                // Create main container
                $ContainerObj = $('<div />').insertBefore($SelectObj);
                $ContainerObj.addClass('InputField_Container')
                    .attr('tabindex', '-1');

                // Container for input field
                $InputContainerObj = $('<div />').appendTo($ContainerObj);
                $InputContainerObj.addClass('InputField_InputContainer');

                // Deduce ID of original field
                SearchID = $SelectObj.attr('id');

                // If invalid, create generic one
                if (!SearchID) {
                    SearchID = Core.UI.GetID($SelectObj);
                }

                // Make ID unique
                SearchID += '_Search';

                // Flag the element as modernized
                $SelectObj.data('modernized', SearchID);

                // Create new input field to substitute original one
                $SearchObj = $('<input />').appendTo($InputContainerObj);
                $SearchObj.attr('id', SearchID)
                    .addClass('InputField_Search')
                    .attr('type', 'text')
                    .attr('role', 'search')
                    .attr('autocomplete', 'off');

                // Set width of search field to that of the select field
                $SearchObj.width(SelectWidth);

                // Subscribe on window resize event
                Core.App.Subscribe('Event.UI.InputFields.Resize', function() {

                    // Set width of search field to that of the select field
                    $SearchObj.blur().hide();
                    SelectWidth = $SelectObj.show().outerWidth();
                    $SelectObj.hide();
                    $SearchObj.width(SelectWidth).show();
                });

                // Handle clicks on related label
                if ($SelectObj.attr('id')) {
                    $LabelObj = $('label[for="' + $SelectObj.attr('id') + '"]');
                    $LabelObj.on('click.InputField', function () {
                        $SearchObj.focus();
                    });
                }

                // Check error classes
                if ($SelectObj.hasClass(Config.ErrorClass)) {
                    $SearchObj.addClass(Config.ErrorClass);
                }
                if ($SelectObj.hasClass(Config.ServerErrorClass)) {
                    $SearchObj.addClass(Config.ServerErrorClass);
                }

                if (Filterable) {

                    // Preserve original data
                    $SelectObj.data('original', $SelectObj.children());

                    // Apply active filter
                    if (
                        $SelectObj.data('filtered')
                        && $SelectObj.data('filtered') !== '0'
                        )
                    {
                        ApplyFilter($SelectObj, $ToolbarContainerObj);
                    }
                }

                // Show selection boxes
                ShowSelectionBoxes($SelectObj, $InputContainerObj);

                // Disable field if no selection available
                CheckAvailability($SelectObj, $SearchObj);

                // Handle form disabling
                Core.App.Subscribe('Event.Form.DisableForm', function ($Form) {
                    if ($Form.find($SearchObj).attr('readonly')) {
                        $SearchObj.attr('disabled', 'disabled');
                    }
                });

                // Handle form enabling
                Core.App.Subscribe('Event.Form.EnableForm', function ($Form) {
                    if (
                        !$Form.find($SearchObj).attr('readonly')
                        && !$SearchObj.data('disabled')
                       )
                    {
                        $SearchObj.removeAttr('disabled');
                    }
                });

                // Register handler for on focus event
                $SearchObj.off('focus.InputField')
                    .on('focus.InputField', function () {

                    var TreeID,
                        $TreeObj,
                        SelectedID,
                        Elements,
                        SelectedNodes,
                        $ClearAllObj,
                        $SelectAllObj,
                        $ConfirmObj;

                    // Show error tooltip if needed
                    if ($SelectObj.attr('id')) {
                        if ($SelectObj.hasClass(Config.ErrorClass)) {
                            Core.Form.ErrorTooltips.ShowTooltip(
                                $SearchObj, $('#' + $SelectObj.attr('id') + Config.ErrorClass).html(), 'TongueTop'
                            );
                        }
                        if ($SelectObj.hasClass(Config.ServerErrorClass)) {
                            Core.Form.ErrorTooltips.ShowTooltip(
                                $SearchObj, $('#' + $SelectObj.attr('id') + Config.ServerErrorClass).html(), 'TongueTop'
                            );
                        }
                    }

                    // Focus tracking
                    Focused = this;
                    SkipFocus = false;

                    // Do nothing if already expanded
                    if ($SearchObj.attr('aria-expanded')) {
                        return false;
                    }

                    // Set ARIA flag if expanded
                    $SearchObj.attr('aria-expanded', true);

                    // Remove any existing selection boxes in container
                    $InputContainerObj.find('.InputField_Selection').remove();
                    $InputContainerObj.find('.InputField_More').remove();

                    // Create list container
                    $ListContainerObj = $('<div />').insertAfter($InputContainerObj);
                    $ListContainerObj.addClass('InputField_ListContainer')
                        .attr('tabindex', '-1');

                    // Create container for jsTree code
                    $TreeContainerObj = $('<div />').appendTo($ListContainerObj);
                    $TreeContainerObj.addClass('InputField_TreeContainer')
                        .attr('tabindex', '-1');

                    // Calculate width for tree container
                    $TreeContainerObj.width($SearchObj.width()
                        + Config.InputFieldPadding * 2
                    );

                    // Deduce ID of original field
                    TreeID = $SelectObj.attr('id');

                    // If invalid, create generic one
                    if (!TreeID) {
                        TreeID = Core.UI.GetID($SelectObj);
                    }

                    // Make ID unique
                    TreeID += '_Select';

                    // jsTree init
                    $TreeObj = $('<div id="' + TreeID + '"><ul></ul></div>');
                    SelectedID = $SelectObj.val();
                    Elements = {};
                    SelectedNodes = [];

                    // Generate JSON structure based on select field options
                    // Sort the list by default if tree view is active
                    Elements = Core.UI.TreeSelection.BuildElementsArray($SelectObj, TreeView);

                    // Force no tree view if structure has only root level
                    if (Elements.HighestLevel === 0) {
                        TreeView = false;
                    }

                    // Initialize jsTree
                    /* eslint-disable camelcase */
                    $TreeObj.jstree({
                        core: {
                            animation: 70,
                            data: Elements,
                            multiple: Multiple,
                            expand_selected_onload: true,
                            check_callback: true,
                            themes: {
                                name: 'InputField',
                                variant: (TreeView) ? 'Tree' : 'NoTree',
                                icons: false,
                                dots: false,
                                url: false
                            }
                        },
                        search: {
                            show_only_matches: true,
                            show_only_matches_children: true
                        },
                        plugins: [ 'multiselect', 'search', 'wholerow' ]
                    })

                    // Handle focus event for tree item
                    .on('focus.jstree', '.jstree-anchor', function () {
                        if (!SkipFocus) {
                            Focused = this;
                        } else {
                            SkipFocus = false;
                        }
                    })

                    // Handle focus event for tree list
                    .on('focus.jstree', function () {
                        if (!SkipFocus) {
                            Focused = this;
                        } else {
                            SkipFocus = false;
                        }

                        // Focus first available tree item
                        if (TabFocus) {
                            $($TreeObj.find('a.jstree-anchor:visible')
                                .not('.jstree-disabled')
                                .get(0)
                            ).trigger('focus.jstree');
                            TabFocus = false;
                        }
                    })

                    // Handle blur event for tree item
                    .on('blur.jstree', '.jstree-anchor', function () {
                        Focused = null;

                        setTimeout(function () {
                            if (!Focused) {
                                HideSelectList($SelectObj, $InputContainerObj, $SearchObj, $ListContainerObj, $TreeContainerObj);
                            }
                        }, 50);
                    })

                    // Handle blur event for tree list
                    .on('blur.jstree', function () {
                        Focused = null;

                        setTimeout(function () {
                            if (!Focused) {
                                HideSelectList($SelectObj, $InputContainerObj, $SearchObj, $ListContainerObj, $TreeContainerObj);
                            }
                        }, 50);
                    })

                    // Handle node selection in tree list
                    // Skip eslint check on next line for unused vars (it's actually event)
                    .on('select_node.jstree', function (Node, Selected, Event) {  //eslint-disable-line no-unused-vars
                        var $SelectedNode = $('#' + Selected.node.id),
                            SelectedNodesIDs;

                        // Do not select disabled nodes
                        if ($SelectedNode.hasClass('Disabled') || !$SelectedNode.is(':visible')) {
                            $TreeObj.jstree('deselect_node', Selected.node);
                        }

                        // Reset selected nodes list
                        SelectedNodes = [];

                        // Get selected nodes
                        SelectedNodesIDs = $TreeObj.jstree('get_selected');
                        $.each(SelectedNodesIDs, function () {
                            var $Node = $('#' + this);
                            SelectedNodes.push($Node.data('id'));
                        });

                        // Set selected nodes as selected in initial select box
                        // (which is hidden but is still used for the action)
                        $SelectObj.val(SelectedNodes);

                        // If single select, lose the focus and hide the list
                        if (!Multiple) {
                            SkipFocus = true;
                            $TreeObj.blur();
                        }

                        // Delay triggering change event on original field (see bug#11419)
                        $SelectObj.data('changed', true);
                    })

                    // Handle node deselection in tree list
                    .on('deselect_node.jstree', function (Node, Selected) {

                        var SelectedNodesIDs,
                            HasEmptyElement = $SelectObj.find('option[value=""]').length === 0 ? false : true;

                        if (Multiple) {

                            // Reset selected nodes list
                            SelectedNodes = [];

                            // Get selected nodes
                            SelectedNodesIDs = $TreeObj.jstree('get_selected');
                            $.each(SelectedNodesIDs, function () {
                                var $Node = $('#' + this);
                                SelectedNodes.push($Node.data('id'));
                            });

                            // Set selected nodes as selected in initial select box
                            // (which is hidden but is still used for the action)
                            if (HasEmptyElement && SelectedNodes.length === 0) {
                                $SelectObj.val('');
                            }
                            else {
                                $SelectObj.val(SelectedNodes);
                            }

                            // Delay triggering change event on original field (see bug#11419)
                            $SelectObj.data('changed', true);
                        } else {
                            $TreeObj.jstree('select_node', Selected.node);
                        }
                    })

                    // Handle double clicks on node rows in tree list
                    .on('dblclick.jstree', '.jstree-wholerow', function (Event) {

                        var Node;

                        // Expand node if we are in tree view
                        if (TreeView) {
                            Node = $(Event.target).closest('li');
                            $TreeObj.jstree('toggle_node', Node);
                        }
                    })

                    // Keydown handler for tree list
                    .keydown(function (Event) {

                        var $HoveredNode;

                        switch (Event.which) {

                            // Enter
                            case $.ui.keyCode.ENTER:
                                Event.preventDefault();
                                if (!Multiple) {
                                    FocusNextElement($SearchObj);
                                }
                                break;

                            // Escape
                            case $.ui.keyCode.ESCAPE:
                                Event.preventDefault();
                                $TreeObj.blur();
                                break;

                            // Space
                            case $.ui.keyCode.SPACE:
                                Event.preventDefault();
                                $HoveredNode = $TreeObj.find('.jstree-hovered');
                                if ($HoveredNode.hasClass('jstree-clicked')) {
                                    $TreeObj.jstree('deselect_node', $HoveredNode.get(0));
                                }
                                else {
                                    if (!Multiple) {
                                        $TreeObj.jstree('deselect_all');
                                    }
                                    $TreeObj.jstree('select_node', $HoveredNode.get(0));
                                }
                                break;

                            // Ctrl (Cmd) + A
                            case 65:
                                if (Event.ctrlKey || Event.metaKey) {
                                    Event.preventDefault();
                                    $ListContainerObj.find('.InputField_SelectAll')
                                        .click();
                                }
                                break;

                            // Ctrl (Cmd) + D
                            case 68:
                                if (Event.ctrlKey || Event.metaKey) {
                                    Event.preventDefault();
                                    $ListContainerObj.find('.InputField_ClearAll')
                                        .click();
                                }
                                break;

                            // Ctrl (Cmd) + F
                            case 70:
                                if (Event.ctrlKey || Event.metaKey) {
                                    Event.preventDefault();
                                    $ListContainerObj.find('.InputField_Filters')
                                        .click();
                                }
                                break;
                        }

                    })

                    // Initialize existing selection
                    .on('loaded.jstree', function () {
                        if (SelectedID) {
                            if (typeof SelectedID === 'object') {
                                $.each(SelectedID, function (NodeIndex, Data) {
                                    $TreeObj.jstree('select_node', $TreeObj.find('li[data-id="' + Data + '"]'));
                                });
                            }
                            else {
                                $TreeObj.jstree('select_node', $TreeObj.find('li[data-id="' + SelectedID + '"]'));
                            }
                        }
                    });

                    // Prevent loss of focus when using scrollbar
                    $TreeContainerObj.on('focus.InputField', function () {
                        if (!SkipFocus) {
                            Focused = this;
                        } else {
                            SkipFocus = false;
                        }
                    }).on('blur.jstree', function () {
                        Focused = null;

                        setTimeout(function () {
                            if (!Focused) {
                                HideSelectList($SelectObj, $InputContainerObj, $SearchObj, $ListContainerObj, $TreeContainerObj);
                            }
                        }, 50);
                    });

                    // Append tree code to the container and show it
                    $TreeObj
                        .appendTo($TreeContainerObj)
                        .show();

                    $ToolbarContainerObj = $('<div />').appendTo($ListContainerObj);
                    $ToolbarContainerObj.addClass('InputField_ToolbarContainer')
                        .attr('tabindex', '-1')
                        .width($TreeContainerObj.width());

                    $ToolbarObj = $('<ul />').appendTo($ToolbarContainerObj)
                        .attr('tabindex', '-1')
                        .on('focus.InputField', function () {
                            if (!SkipFocus) {
                                Focused = this;
                            } else {
                                SkipFocus = false;
                            }
                        }).on('blur.InputField', function () {
                            Focused = null;

                            setTimeout(function () {
                                if (!Focused) {
                                    HideSelectList($SelectObj, $InputContainerObj, $SearchObj, $ListContainerObj, $TreeContainerObj);
                                }
                            }, 50);
                        });

                    if (Multiple) {

                        // Select all action selects all values in tree
                        $SelectAllObj = $('<a />').addClass('InputField_SelectAll')
                            .attr('href', '#')
                            .attr('role', 'button')
                            .attr('tabindex', '-1')
                            .text(Core.Config.Get('InputFieldsSelectAll'))
                            .attr('aria-label', Core.Config.Get('InputFieldsSelectAll'))
                            .appendTo($ToolbarObj)
                            .wrap('<li />');
                        RegisterActionEvent($TreeObj, $SelectAllObj, 'SelectAll');

                        // Clear all action deselects all selected values in tree
                        $ClearAllObj = $('<a />').addClass('InputField_ClearAll')
                            .attr('href', '#')
                            .attr('role', 'button')
                            .attr('tabindex', '-1')
                            .text(Core.Config.Get('InputFieldsClearAll'))
                            .attr('aria-label', Core.Config.Get('InputFieldsClearAll'))
                            .appendTo($ToolbarObj)
                            .wrap('<li />');
                        RegisterActionEvent($TreeObj, $ClearAllObj, 'ClearAll');
                    }

                    if (Filterable) {

                        // Filters action button
                        $FiltersObj = $('<a />').addClass('InputField_Filters')
                            .attr('href', '#')
                            .attr('role', 'button')
                            .attr('tabindex', '-1')
                            .text(Core.Config.Get('InputFieldsFilters'))
                            .attr('aria-label', Core.Config.Get('InputFieldsFilters'))
                            .appendTo($ToolbarObj)
                            .wrap('<li />');
                        RegisterFilterEvent($SelectObj, $InputContainerObj, $ToolbarContainerObj, $FiltersObj, 'ShowFilters');

                        if (!$SelectObj.data('filtered')) {
                            $SelectObj.data('filtered', '0');
                        } else if ($SelectObj.data('filtered') !== '0') {
                            $FiltersObj.addClass('Active')
                                .prepend('<i class="fa fa-filter" /> ');
                        }

                        // Filters list
                        $FiltersListObj = $('<div />').appendTo($ToolbarContainerObj);
                        $FiltersListObj.addClass('InputField_FiltersList')
                            .attr('tabindex', '-1');

                        // Hide the filters list if no parameter is supplied
                        if (
                            !$SelectObj.data('expand-filters')
                            && $SelectObj.data('expand-filters') !== '0'
                            )
                        {
                            $FiltersListObj.hide();
                        }

                        // Filters checkboxes
                        $.each($SelectObj.data('filters').Filters, function (FilterIndex, Filter) {
                            var $FilterObj = $('<input />').appendTo($FiltersListObj),
                                $SpanObj = $('<span />').appendTo($FiltersListObj);
                            $FilterObj.attr('type', 'checkbox')
                                .attr('tabindex', '-1')
                                .data('index', FilterIndex + 1);
                            if (
                                $SelectObj.data('filtered')
                                && parseInt($SelectObj.data('filtered'), 10) === FilterIndex + 1
                                )
                            {
                                $FilterObj.attr('checked', true);
                            }
                            if (
                                Filter.Data.length === 1
                                && (Filter.Data[0].Key === '' || Filter.Data[0].Key === '||-')
                                )
                            {
                                $FilterObj.attr('disabled', true);
                            }
                            Core.UI.GetID($FilterObj);
                            $SpanObj.text(Filter.Name);
                            $SpanObj.on('click', function () {
                                $FilterObj.click();
                            });
                            $('<br />').appendTo($FiltersListObj);
                            RegisterFilterEvent($SelectObj, $InputContainerObj, $ToolbarContainerObj, $FilterObj, 'Filter');
                        });

                    }

                    if (Multiple) {

                        // Confirm action exits the field
                        $ConfirmObj = $('<a />').addClass('InputField_Confirm')
                            .attr('href', '#')
                            .attr('role', 'button')
                            .attr('tabindex', '-1')
                            .text(Core.Config.Get('InputFieldsConfirm'))
                            .attr('aria-label', Core.Config.Get('InputFieldsConfirm'))
                            .appendTo($ToolbarObj)
                            .prepend('<i class="fa fa-check-square-o" /> ')
                            .wrap('<li />');
                        RegisterActionEvent($TreeObj, $ConfirmObj, 'Confirm');
                    }

                    if ($ToolbarObj.children().length === 0) {
                        $ToolbarContainerObj.hide();
                    }

                    // Set up jsTree search function for input search field
                    $SearchObj.off('keyup.InputField').on('keyup.InputField', function () {

                        var SearchValue = $SearchObj.val().trim(),
                            NoMatchNodeJSON,
                            $ClearSearchObj;

                        // Abandon search if empty string
                        if (SearchValue === '') {
                            $TreeObj.jstree('delete_node', $TreeObj.find('.jstree-no-match'));
                            $TreeObj.jstree('clear_search');
                            Searching = false;
                            $SearchObj.siblings('.InputField_ClearSearch')
                                .remove();

                            if (Multiple) {

                                // Reset select all and clear all functions to original behavior
                                $SelectAllObj.off('click.InputField').on('click.InputField', function () {

                                    // Make sure subtrees of all nodes are expanded
                                    $TreeObj.jstree('open_all');

                                    // Select all nodes
                                    $TreeObj.find('li')
                                        .not('.jstree-clicked,.Disabled')
                                        .each(function () {
                                            $TreeObj.jstree('select_node', this);
                                        });

                                    return false;
                                });
                                $ClearAllObj.off('click.InputField').on('click.InputField', function () {

                                    // Clear selection
                                    $TreeObj.jstree('deselect_node', $TreeObj.jstree('get_selected'));

                                    return false;
                                });

                            }
                            return false;
                        }

                        // Remove no match entry if existing from previous search
                        $TreeObj.jstree('delete_node', $TreeObj.find('.jstree-no-match'));

                        // Start jsTree search
                        $TreeObj.jstree('search', SearchValue);
                        Searching = true;

                        if (Multiple) {

                            // Change select all action to select only matched values
                            RegisterActionEvent($TreeObj, $SelectAllObj, 'SelectAll_Search');

                            // Change clear all action to deselect only matched values
                            RegisterActionEvent($TreeObj, $ClearAllObj, 'ClearAll_Search');

                        }

                        // No match
                        if ($TreeObj.find('.jstree-search').length === 0) {

                            // Add no match node
                            NoMatchNodeJSON = {
                                text: Core.Config.Get('InputFieldsNoMatchMsg'),
                                state: {
                                    disabled: true
                                },
                                'li_attr': {
                                    class: 'Disabled jstree-no-match'
                                }
                            };
                            $TreeObj.jstree('create_node', $TreeObj, NoMatchNodeJSON);

                            // Hide all other nodes
                            $TreeObj.find('li:visible')
                                .not('.jstree-no-match')
                                .hide();
                        }

                        // Check if we are searching for something
                        if ($SearchObj.siblings('.InputField_ClearSearch').length === 0) {

                            // Clear search action stops search
                            $ClearSearchObj = $('<a />').insertAfter($SearchObj);
                            $ClearSearchObj.addClass('InputField_Action InputField_ClearSearch')
                                .attr('href', '#')
                                .attr('title', Core.Config.Get('InputFieldsClearSearch'))
                                .css(($('body').hasClass('RTL') ? 'left' : 'right'), Config.SelectionBoxOffsetRight + 'px')
                                .append($('<i />').addClass('fa fa-times-circle'))
                                .attr('role', 'button')
                                .attr('tabindex', '-1')
                                .attr('aria-label', Core.Config.Get('InputFieldsClearSearch'))
                                .off('click.InputField').on('click.InputField', function () {

                                    // Reset the search field
                                    $SearchObj.val('');

                                    // Clear search from jsTree and remove no match node
                                    $TreeObj.jstree('delete_node', $TreeObj.find('.jstree-no-match'));
                                    $TreeObj.jstree('clear_search');
                                    Searching = false;

                                    if (Multiple) {

                                        // Reset select all and clear all functions to original behavior
                                        RegisterActionEvent($TreeObj, $SelectAllObj, 'SelectAll');
                                        RegisterActionEvent($TreeObj, $ClearAllObj, 'ClearAll');

                                    }

                                    // Remove the action icon
                                    $(this).remove();

                                    return false;

                                // Prevent clicks on action to steal focus from search field
                                }).on('mousedown.InputField', function () {
                                    return false;
                            });
                        }

                    });

                    // Show list container
                    $ListContainerObj.fadeIn(Config.FadeDuration, function () {

                        // Scroll into view if in dialog
                        if ($ListContainerObj.parents('.Dialog').length > 0) {
                            this.scrollIntoView(false);
                        }
                    });
                })

                // Out of focus handler removes complete jsTree and action buttons
                .off('blur.InputField').on('blur.InputField', function () {
                    Focused = null;
                    setTimeout(function () {
                        if (!Focused) {
                            HideSelectList($SelectObj, $InputContainerObj, $SearchObj, $ListContainerObj, $TreeContainerObj);
                        }
                    }, 50);
                    Core.Form.ErrorTooltips.HideTooltip();
                })

                // Keydown handler provides keyboard shortcuts for navigating the tree
                .keydown(function (Event) {

                    var $TreeObj = $TreeContainerObj.find('.jstree');

                    switch (Event.which) {

                        // Tab
                        case $.ui.keyCode.TAB:
                            if (!Event.shiftKey) {
                                TabFocus = true;
                            }
                            break;

                        // Escape
                        case $.ui.keyCode.ESCAPE:
                            Event.preventDefault();
                            $SearchObj.blur();
                            break;

                        // ArrowDown
                        case $.ui.keyCode.DOWN:
                            Event.preventDefault();
                            $($TreeObj.find('a.jstree-anchor:visible')
                                .not('.jstree-disabled')
                                .get(0)
                            ).trigger('focus.jstree');
                            break;

                        // Ctrl (Cmd) + A
                        case 65:
                            if (Event.ctrlKey || Event.metaKey) {
                                if (!Searching) {
                                    Event.preventDefault();
                                    $ListContainerObj.find('.InputField_SelectAll')
                                        .click();
                                }
                            }
                            break;

                        // Ctrl (Cmd) + D
                        case 68:
                            if (Event.ctrlKey || Event.metaKey) {
                                Event.preventDefault();
                                $ListContainerObj.find('.InputField_ClearAll')
                                    .click();
                            }
                            break;

                        // Ctrl (Cmd) + F
                        case 70:
                            if (Event.ctrlKey || Event.metaKey) {
                                Event.preventDefault();
                                $ListContainerObj.find('.InputField_Filters')
                                    .click();
                            }
                            break;
                    }

                });

                // Handle custom redraw event on original select field
                // to update values when changed via AJAX calls
                $SelectObj.off('redraw.InputField').on('redraw.InputField', function () {
                    if (Filterable) {
                        $SelectObj.data('original', $SelectObj.children());
                        ApplyFilter($SelectObj, $ToolbarContainerObj, true);
                    }
                    CheckAvailability($SelectObj, $SearchObj);
                    $SearchObj.width($SelectObj.outerWidth())
                        .trigger('blur');
                })

                // Handle custom error event on original select field
                // to add error classes to search field if needed
                .off('error.InputField').on('error.InputField', function () {
                    if ($SelectObj.hasClass(Config.ErrorClass)) {
                        $SearchObj.addClass(Config.ErrorClass);
                    }
                    else {
                        $SearchObj.removeClass(Config.ErrorClass);
                    }
                    if ($SelectObj.hasClass(Config.ServerErrorClass)) {
                        $SearchObj.addClass(Config.ServerErrorClass);
                    }
                    else {
                        $SearchObj.removeClass(Config.ServerErrorClass);
                    }
                });

            }
        });

        return true;

    };

    /**
     * @name IsEnabled
     * @memberof Core.UI.InputFields
     * @function
     * @returns {String} ID of the Search field
     * @param {jQueryObject} $Element - The jQuery object of the element that is being tested.
     * @description
     *      This function check if Input Field is initialized for the supplied element,
     *      and returns corresponding ID of the Search field.
     */
    TargetNS.IsEnabled = function ($Element) {
        return $Element.data('modernized');
    };

    /**
     * @private
     * @name HideAutocompleteList
     * @memberof Core.UI.InputFields
     * @param {jQueryObject} $AutocompleteObj - Original input field
     * @param {JQueryObject} $TreeContainerObj - Container for jsTree list
     * @description
     *      Remove complete jsTree list and associated attributes.
     */
    function HideAutocompleteList($AutocompleteObj, $TreeContainerObj) {

        // Remove jsTree if it exists
        if ($TreeContainerObj) {
            $TreeContainerObj.fadeOut(Config.FadeDuration, function () {
                $(this).find('.jstree')
                    .jstree('destroy')
                    .remove();
                $(this).remove();
            });

            // Stop the old request if it's already running
            if ($AutocompleteObj.data('AutocompleteXHR')) {
                $AutocompleteObj.data('AutocompleteXHR').abort();
                $AutocompleteObj.removeData('AutocompleteXHR');
            }

            // Remove attributes and loading animation
            $AutocompleteObj.removeAttr('aria-expanded')
                .removeAttr('aria-autocomplete')
                .removeAttr('aria-activedescendant')
                .removeClass('InputField_Loading');
        }
    }

    /**
     * @name InitAutocomplete
     * @memberof Core.UI.InputFields
     * @function
     * @returns {Boolean} Returns true if successful, false otherwise
     * @param {jQueryObject} $AutocompleteFields - Fields to initialize.
     * @description
     *      This function initializes autocomplete input fields, based on supplied CSS selector.
     */
    TargetNS.InitAutocomplete = function ($AutocompleteFields) {

        // Give up if no select fields are found
        if (!$AutocompleteFields.length) {
            return false;
        }

        // Iterate over all found fields
        $AutocompleteFields.each(function (Index, AutocompleteObj) {

            // Few global vars
            var $AutocompleteObj = $(AutocompleteObj),
                $TreeContainerObj,
                $TreeObj,
                SkipFocus = false,
                TabFocus = false,
                Focused = null;

            // Prevent browser from displaying their own autocomplete control
            $AutocompleteObj.attr('autocomplete', 'off');

            // Register handler for on focus event
            $AutocompleteObj.off('focus.InputField')
                .on('focus.InputField', function () {

                // Focus tracking
                Focused = this;
                SkipFocus = false;
            })

            // Register handler for on keyup event
            .off('keyup.InputField').on('keyup.InputField', function () {

                var SearchValue = $AutocompleteObj.val().trim(),
                    TreeID;

                // Focus tracking
                Focused = this;
                SkipFocus = false;

                // Abandon search if empty string
                if (SearchValue === '') {
                    Focused = null;
                    setTimeout(function () {
                        if (!Focused) {
                            HideAutocompleteList($AutocompleteObj, $TreeContainerObj);
                        }
                    }, 50);
                    return false;
                }

                // Check if we are in expanded mode
                if (!$AutocompleteObj.attr('aria-expanded')) {

                    // Set ARIA flag if expanded
                    $AutocompleteObj.attr('aria-expanded', true);

                    // Create container for jsTree code
                    $TreeContainerObj = $('<div />').insertAfter($AutocompleteObj);
                    $TreeContainerObj.addClass('InputField_TreeContainer')
                        .attr('tabindex', '-1');

                    // Calculate width for tree container
                    $TreeContainerObj.width($AutocompleteObj.width()
                        + Config.InputFieldPadding * 2
                    );

                    // Deduce ID of original field
                    TreeID = $AutocompleteObj.attr('id');

                    // If invalid, create generic one
                    if (!TreeID) {
                        TreeID = Core.UI.GetID($AutocompleteObj);
                    }

                    // Make ID unique
                    TreeID += '_Autocomplete';

                    // jsTree init
                    $TreeObj = $('<div id="' + TreeID + '"><ul></ul></div>');

                    // Initialize jsTree
                    /* eslint-disable camelcase */
                    $TreeObj.jstree({
                        core: {
                            animation: 70,
                            data: function (obj, callback) {
                                var URL = Core.Config.Get('Baselink'),
                                    Data = {
                                        Action: $AutocompleteObj.data('action'),
                                        Subaction: $AutocompleteObj.data('subaction'),
                                        Term: $AutocompleteObj.val().trim(),
                                        MaxResults: Config.MaxAutocompleteResults
                                    };

                                // Stop the old request if it's already running
                                if ($AutocompleteObj.data('AutocompleteXHR')) {
                                    $AutocompleteObj.data('AutocompleteXHR').abort();
                                    $AutocompleteObj.removeData('AutocompleteXHR');
                                }

                                // Show loading animation
                                else {
                                    $AutocompleteObj.addClass('InputField_Loading');
                                }

                                // Start AJAX request to get data
                                $AutocompleteObj.data('AutocompleteXHR', Core.AJAX.FunctionCall(URL, Data, function (Result) {

                                    var Elements = [];

                                    $AutocompleteObj.removeData('AutocompleteXHR');

                                    // Populate elements array
                                    $.each(Result, function () {
                                        Elements.push({
                                            text: this.Label || this.Value,
                                            'li_attr': {
                                                'data-value': this.Value
                                            }
                                        });
                                    });

                                    // Populate list only if we have results
                                    if (Elements.length > 0) {
                                        callback.call(this, Elements);

                                        $AutocompleteObj.attr('aria-autocomplete', 'list')
                                            .attr('aria-activedescendant', '#' + TreeID);
                                    }

                                    // Otherwise, hide the list
                                    else {
                                        Focused = null;
                                        HideAutocompleteList($AutocompleteObj, $TreeContainerObj);
                                    }

                                }));
                            },
                            check_callback: true,
                            themes: {
                                name: 'InputField',
                                variant: 'NoTree',
                                icons: false,
                                dots: false,
                                url: false
                            }
                        },
                        plugins: [ 'wholerow' ]
                    })

                    // Handle focus event for tree item
                    .on('focus.jstree', '.jstree-anchor', function () {
                        if (!SkipFocus) {
                            Focused = this;
                        } else {
                            SkipFocus = false;
                        }
                    })

                    // Handle focus event for tree list
                    .on('focus.jstree', function () {
                        if (!SkipFocus) {
                            Focused = this;
                        } else {
                            SkipFocus = false;
                        }

                        // Focus first available tree item
                        if (TabFocus) {
                            $($TreeObj.find('a.jstree-anchor:visible')
                                .not('.jstree-disabled')
                                .get(0)
                            ).trigger('focus.jstree');
                            TabFocus = false;
                        }
                    })

                    // Handle blur event for tree item
                    .on('blur.jstree', '.jstree-anchor', function () {
                        Focused = null;

                        setTimeout(function () {
                            if (!Focused) {
                                HideAutocompleteList($AutocompleteObj, $TreeContainerObj);
                            }
                        }, 50);
                    })

                    // Handle blur event for tree list
                    .on('blur.jstree', function () {
                        Focused = null;

                        setTimeout(function () {
                            if (!Focused) {
                                HideAutocompleteList($AutocompleteObj, $TreeContainerObj);
                            }
                        }, 50);
                    })

                    // Handle node selection in tree list
                    // Skip eslint check on next line for unused vars (it's actually event)
                    .on('select_node.jstree', function (Node, Selected, Event) { //eslint-disable-line no-unused-vars

                        // Use chosen value and hide the list
                        $AutocompleteObj.val(Selected.node.li_attr["data-value"]);
                        SkipFocus = true;
                        $TreeObj.blur();
                    })

                    // Keydown handler for tree list
                    .keydown(function (Event) {

                        var $HoveredNode;

                        switch (Event.which) {

                            // Escape
                            case $.ui.keyCode.ESCAPE:
                                Event.preventDefault();
                                $TreeObj.blur();
                                break;

                            // Space
                            case $.ui.keyCode.SPACE:
                                Event.preventDefault();
                                $HoveredNode = $TreeObj.find('.jstree-hovered');
                                $TreeObj.jstree('select_node', $HoveredNode.get(0));
                                break;
                        }

                    })

                    // Remove loading animation when refresh call completes
                    .on('refresh.jstree', function () {
                        $AutocompleteObj.removeClass('InputField_Loading');
                    })

                    // Show tree list container and remove loading animation
                    .on('loaded.jstree', function () {
                        $TreeContainerObj.fadeIn(Config.FadeDuration, function () {
                            $AutocompleteObj.removeClass('InputField_Loading');
                        });
                    });

                    // Append tree code to the containerx
                    $TreeObj.appendTo($TreeContainerObj);
                }
                else {

                    // Refresh jsTree
                    $TreeObj.jstree('refresh', true);
                }

            })

            // Out of focus handler removes complete jsTree and action buttons
            .off('blur.InputField').on('blur.InputField', function () {
                Focused = null;
                setTimeout(function () {
                    if (!Focused) {
                        HideAutocompleteList($AutocompleteObj, $TreeContainerObj);
                    }
                }, 50);
            })

            // Keydown handler provides keyboard shortcuts for navigating the tree
            .keydown(function (Event) {

                switch (Event.which) {

                    // Tab
                    case $.ui.keyCode.TAB:
                        TabFocus = true;
                        break;

                    // Escape
                    case $.ui.keyCode.ESCAPE:
                        Event.preventDefault();
                        $AutocompleteObj.blur();
                        break;

                    // ArrowDown
                    case $.ui.keyCode.DOWN:
                        Event.preventDefault();
                        $($TreeObj.find('a.jstree-anchor:visible')
                            .not('.jstree-disabled')
                            .get(0)
                        ).trigger('focus.jstree');
                        break;
                }

            });

        });

        return true;

    };

    // jsTree plugin for multi selection without modifier key
    // Skip ESLint check below for no camelcase property, we are overriding an existing one!
    $.jstree.defaults.multiselect = {};
    $.jstree.plugins.multiselect = function (options, parent) {
        this.activate_node = function (obj, e) { //eslint-disable-line camelcase
            e.ctrlKey = true;
            parent.activate_node.call(this, obj, e);
        };
    };

    // Handle window resize event
    $(window).on(Config.ResizeEvent + '.InputField', function () {
        clearTimeout(Config.ResizeTimeout);
        Config.ResizeTimeout = setTimeout(function () {
            Core.App.Publish('Event.UI.InputFields.Resize');
        }, 100);
    });

    return TargetNS;
}(Core.UI.InputFields || {}));
