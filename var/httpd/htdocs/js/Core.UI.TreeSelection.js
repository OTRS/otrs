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
 * @namespace Core.UI.TreeSelection
 * @memberof Core.UI
 * @author OTRS AG
 * @description
 *      Tree Selection for Queue, Service, etc. with JSTree.
 */
Core.UI.TreeSelection = (function (TargetNS) {

    /**
     * @private
     * @name GetChildren
     * @memberof Core.UI.TreeSelection
     * @function
     * @returns {Object|Boolean} Returns elements object or false if no children available.
     * @param {Object} Elements
     * @param {String} Index
     * @param {Object} Data
     * @description
     *      Gets all children of a(sub)tree.
     */
    function GetChildren(Elements, Index, Data) {
        $.each(Elements, function(InnerIndex, InnerData) {
            if (typeof InnerData !== 'object') {
                return false;
            }
            if (InnerData.ID === Data.ChildOf) {
                Elements[InnerIndex].children.push(Data);
                delete Elements[Index];
            }
        });

        return Elements;
    }

    /**
     * @private
     * @name CollectElements
     * @memberof Core.UI.TreeSelection
     * @function
     * @returns {Object|Boolean} Returns elements object or false on error.
     * @param {Object} Elements
     * @param {Number} Level
     * @description
     *      Collect all elements of a tree.
     */
    function CollectElements(Elements, Level) {
        $.each(Elements, function(Index, Data) {
            if (typeof Data !== 'object') {
                return false;
            }
            if (Data.Level === Level) {
                if (Level > 0) {
                    Elements = GetChildren(Elements, Index, Data);
                }
            }
        });

        return Elements;
    }

    /**
     * @name BuildElementsArray
     * @memberof Core.UI.TreeSelection
     * @function
     * @returns {Object} Returns an object which is suitable for passing to JSTree in order to build a tree selection.
     * @param {jQueryObject} $Element - The select element which contains the data.
     * @param {Boolean} Sort - Whether to sort the elements alphabetically (optional, default: true)
     * @description
     *      This function receives a select element which was built
     *      with TreeView => 1 (= intended elements) and builds a
     *      javascript object from it which contains all the elements
     *      and their children.
     */
    TargetNS.BuildElementsArray = function($Element, Sort) {
        var Elements = [],
            Level,
            HighestLevel = 0;

        if (typeof Sort === 'undefined') {
            Sort = true;
        }

        $Element.find('option').each(function() {

            // Get number of trailing spaces in service name to
            // distinguish the level (2 spaces = 1 level)
            var ElementID = $(this).attr('value'),
                ElementDisabled = $(this).is(':disabled'),
                ElementName = Core.App.EscapeHTML($(this).text()),
                ElementSelected = $(this).is(':selected'),
                ElementNameTrim = ElementName.replace(/(^[\xA0]+)/g, ''),
                CurrentLevel = (ElementName.length - ElementNameTrim.length) / 2,
                ChildOf = 0,
                ElementIndex = 0,
                CurrentElement;

            // Skip entry if no ID (should only occur for the leading empty element, '-')
            // also skip entries which only contain '------------' as visible text (e.g. in AgentLinkObject)
            if (!ElementID || ElementID === "||-" || (ElementDisabled && ElementName.match(/^-+$/))) {
                return true;
            }

            // Determine whether this element is a child of a preceding element
            // therefore, take the last element we have added to our elements
            // array and compare if to the current element
            if (Elements.length && CurrentLevel > 0) {

                // If the current level is bigger than the last known level,
                // we're dealing with a child element of the last element
                if (CurrentLevel > Elements[Elements.length - 1].Level) {
                    ChildOf = Elements[Elements.length - 1].ID;
                }

                // If both levels equal each other, we have a sibling and can
                // re-use the parent (= the ChildOf value) of the last element
                else if (CurrentLevel === Elements[Elements.length - 1].Level) {
                    ChildOf = Elements[Elements.length - 1].ChildOf;
                }

                // In other cases, we have an element of a lower level but not
                // of the first level, so we walk through all yet saved elements
                // (bottom up) and find the next element with a lower level
                else {
                    for (ElementIndex = Elements.length; ElementIndex >= 0; ElementIndex--) {
                        if (CurrentLevel > Elements[ElementIndex - 1].Level) {
                            ChildOf = Elements[ElementIndex - 1].ID;
                            break;
                        }
                    }
                }
            }

            // In case of disabled elements, the ID is always "-", which causes duplications.
            // Therefore, we assign a random ID to avoid conflicts.
            ElementID = (ElementID === '-') ? Math.floor((Math.random() * 100000) + 1) : ElementID;

            // Collect data of current service and add it to elements array
            /*eslint-disable camelcase */
            CurrentElement = {
                ID: ElementID,
                Name: ElementNameTrim,
                Level: CurrentLevel,
                ChildOf: ChildOf,
                children: [],
                text: ElementNameTrim,
                state: {
                    selected: ElementSelected
                },
                li_attr: {
                    'data-id': ElementID,
                    'class': (ElementDisabled) ? 'Disabled' : ''
                }
            };
            /*eslint-enable camelcase */
            Elements.push(CurrentElement);

            if (CurrentLevel > HighestLevel) {
                HighestLevel = CurrentLevel;
            }
        });

        if (Sort) {
            Elements.sort(function(a, b) {
                if (a.Level - b.Level === 0) {
                    return (a.Name.localeCompare(b.Name));
                }
                else {
                    return (a.Level - b.Level);
                }
            });
        }

        // Go through all levels and collect the elements and their children
        for (Level = HighestLevel; Level >= 0; Level--) {
            Elements = CollectElements(Elements, Level);
        }

        Elements.HighestLevel = HighestLevel;

        return Elements;
    };

    /**
     * @name ShowTreeSelection
     * @memberof Core.UI.TreeSelection
     * @function
     * @returns {Boolean} Returns false on error.
     * @param {jQueryObject} $TriggerObj - Object for which the event was triggered.
     * @description
     *      Open the tree view selection dialog.
     */
    TargetNS.ShowTreeSelection = function($TriggerObj) {

        var $TreeObj = $('<div id="JSTree"><ul></ul></div>'),
            $SelectObj = $TriggerObj.prevAll('select'),
            SelectSize = $SelectObj.attr('size'),
            Multiple = ($SelectObj.attr('multiple') !== '' && $SelectObj.attr('multiple') !== undefined) ? true : false,
            ElementCount = $SelectObj.find('option').length,
            DialogTitle = $SelectObj.parent().prev('label').clone().children().remove().end().text(),
            Elements = {},
            InDialog = false,
            StyleSheetURL,
            $SelectedNodesObj,
            SelectedNodes = [],
            $CurrentFocusedObj;

        if (!$SelectObj) {
            return false;
        }

        // Determine if we are in a dialog
        if ($SelectObj.closest('.Dialog').length) {
            InDialog = true;
        }

        if (InDialog && $TriggerObj.hasClass('TreeSelectionVisible')) {
            $TriggerObj
                .removeClass('TreeSelectionVisible')
                .prev('.jstree')
                .jstree('destroy')
                .remove();
            $SelectObj.show();
            return false;
        }

        if (!DialogTitle) {
            DialogTitle = $SelectObj.prev('label').text();
        }

        DialogTitle = $.trim(DialogTitle);
        DialogTitle = DialogTitle.substr(0, DialogTitle.length - 1);
        DialogTitle = DialogTitle.replace(/^\*\s+/, '');

        // Check if there are elements to select from
        if (ElementCount === 1 && $SelectObj.find('option').text() === '-') {
            alert(Core.Config.Get('NoElementsToSelectFromMsg'));
            return false;
        }

        Elements = Core.UI.TreeSelection.BuildElementsArray($SelectObj);

        // Set StyleSheetURL in order to correctly load the CSS for treeview
        StyleSheetURL = Core.Config.Get('WebPath') + 'skins/Agent/default/css/thirdparty/jstree-theme/default/style.css';

        /*eslint-disable camelcase */
        $TreeObj.jstree({
            core: {
                animation: 70,
                data: Elements,
                multiple: ((SelectSize && Multiple) || Multiple) ? true : false,
                expand_selected_onload: true,
                themes: {
                    theme: 'default',
                    icons: false,
                    responsive: true,
                    variant: 'small',
                    url: StyleSheetURL
                }
            },
            search: {
                show_only_matches: true,
                show_only_matches_children: true
            },
            plugins: [ 'search' ]
        })
        /*eslint-enable camelcase */
        .bind('select_node.jstree', function (node, selected, event) {
            var $Node = $('#' + selected.node.id);
            if ($Node.hasClass('Disabled') || !$Node.is(':visible')) {
                $TreeObj.jstree('deselect_node', selected.node);
            }
            $TreeObj.jstree('toggle_node', selected.node);

            // If we are already in a dialog, we don't use the submit
            // button for the tree selection, so we need to apply the changes 'live'
            if (InDialog) {

                // Reset selected nodes list
                SelectedNodes = [];

                // Get selected nodes
                $SelectedNodesObj = $TreeObj.jstree('get_selected');
                $SelectedNodesObj.each(function() {
                    SelectedNodes.push($Node.attr('data-id'));
                });

                // Set selected nodes as selected in initial select box
                // (which is hidden but is still used for the action)
                $SelectObj.val(SelectedNodes);
            }

            // If the node has really been selected (not initially by the code, but by using keyboard or mouse)
            // we need to check if we can now select the submit button
            if ((event && event.type !== undefined) && !InDialog && !Multiple) {
                $TreeObj.next('#SubmitTree').focus();
            }

        })
        .bind('deselect_node.jstree', function (node, selected) {
            var $Node = $('#' + selected.node.id);

            // If we are already in a dialog, we don't use the submit
            // button for the tree selection, so we need to apply the changes 'live'
            if (InDialog) {

                // Reset selected nodes list
                SelectedNodes = [];

                // Get selected nodes
                $SelectedNodesObj = $TreeObj.jstree("get_selected");
                $SelectedNodesObj.each(function() {
                    SelectedNodes.push($Node.attr('data-id'));
                });

                // Set selected nodes as selected in initial select box
                // (which is hidden but is still used for the action)
                $SelectObj.val(SelectedNodes);
            }
        });

        // If we are not already in a dialog, open up one
        // which contains the tree selection; otherwise just
        // hide the select element and show the tree selection
        if (!InDialog) {

            Core.UI.Dialog.ShowContentDialog('<div class="OverlayTreeSelector" id="TreeContainer"></div>', DialogTitle, '20%', 'Center', true);
            $('#TreeContainer')
                .prepend($TreeObj)
                .prepend('<div id="TreeSearch"><input type="text" id="TreeSearchInput" placeholder="' + Core.Config.Get('SearchMsg') + '..." /><span title="' + Core.Config.Get('DeleteMsg') + '">x</span></div>')
                .append('<input type="button" id="SubmitTree" class="Primary" title="' + Core.Config.Get('ApplyButtonText') + '" value="' + Core.Config.Get('ApplyButtonText') + '" />');
        }
        else {
            $TreeObj
                .addClass('Hidden InOverlay')
                .insertAfter($SelectObj)
                .show();
            $SelectObj.hide();
            $TriggerObj.addClass('TreeSelectionVisible');
        }

        // Get the element which is currently being focused and set the focus to the search field
        $CurrentFocusedObj = document.activeElement;
        $('#TreeSearch').find('input').focus();

        $('#TreeSearch').find('input').bind('keyup', function() {
            $TreeObj.jstree('search', $(this).val());

            // Make sure sub-trees of matched nodes are expanded
            $('.jstree-search')
                .parent()
                .removeClass('jstree-open')
                .addClass('jstree-closed')
                .find('ins').click(function() {
                    $(this).nextAll('ul').find('li').show();
                });
        });

        $('#TreeSearch').find('span').bind('click', function() {
            $(this).prev('input').val('');
            $TreeObj.jstree('clear_search');
        });

        $('#TreeContainer').find('input#SubmitTree').bind('click', function() {
            var SelectedObj = $TreeObj.jstree('get_selected', true),
                $Node;
            if (typeof SelectedObj === 'object' && SelectedObj[0]) {
                if (SelectedObj.length > 1) {

                    $(SelectedObj).each(function() {
                        var $SelectedNode = $('#' + this.id);
                        SelectedNodes.push($SelectedNode.attr('data-id'));
                    });
                    $SelectObj
                        .val(SelectedNodes)
                        .trigger('change');
                }
                else {
                    $Node = $('#' + SelectedObj[0].id);
                    if ($Node.attr('data-id') !== $SelectObj.val()) {
                        $SelectObj
                            .val($Node.attr('data-id'))
                            .trigger('change');
                    }
                }
            }
            else {
                $SelectObj
                    .val('')
                    .trigger('change');
            }
            Core.UI.Dialog.CloseDialog($('.Dialog'));
        });

        // When the dialog is closed, give the last focused element the focus again
        Core.App.Subscribe('Event.UI.Dialog.CloseDialog.Close', function(Dialog) {
            if ($(Dialog).find('#TreeContainer').length && !$(Dialog).find('#SearchForm').length) {
                $CurrentFocusedObj.focus();
            }
        });
    };

    /**
     * @name InitTreeSelection
     * @memberof Core.UI.TreeSelection
     * @function
     * @description
     *      To bind click event no tree selection icons next to select boxes.
     */
    TargetNS.InitTreeSelection = function() {
        $('.Field, fieldset').off('click.ShowTreeSelection').on('click.ShowTreeSelection', '.ShowTreeSelection', function () {
            Core.UI.TreeSelection.ShowTreeSelection($(this));
            return false;
        });
    };

    /**
     * @name InitDynamicFieldTreeViewRestore
     * @memberof Core.UI.TreeSelection
     * @function
     * @description
     *      Initially display dynamic fields with TreeMode = 1 correctly.
     */
    TargetNS.InitDynamicFieldTreeViewRestore = function() {
        $('.DynamicFieldWithTreeView').each(function() {
            var Data = [];
            $(this).find('option').each(function() {
                Data.push([
                    $(this).attr('value'),
                    $(this).text(),
                    $(this).prop('selected'),
                    $(this).prop('disabled')
                ]);
            });
            Core.UI.TreeSelection.RestoreDynamicFieldTreeView($(this), Data, 1);
        });
    };

    /**
     * @name RestoreDynamicFieldTreeView
     * @memberof Core.UI.TreeSelection
     * @function
     * @returns {Boolean} False on error.
     * @param {jQueryObject} $FieldObj
     * @param {Array} Data
     * @param {Boolean} CheckClass
     * @param {Number} AJAXUpdate
     * @description
     *      Restores tree view (intended values) for dynamic fields.
     */
    TargetNS.RestoreDynamicFieldTreeView = function($FieldObj, Data, CheckClass, AJAXUpdate) {

        var Key,
            Value,
            Selected,
            SelectedAttr,
            Disabled,
            DisabledAttr,
            SelectData = [],
            NeededSpaces,
            Spaces,
            i;

        if (CheckClass && $FieldObj.hasClass('TreeViewRestored')) {
            return false;
        }

        $FieldObj.find('option').remove();

        $.each(Data, function(index, OptionData) {

            Key = OptionData[0] || '';
            Value = OptionData[1] || '';
            Spaces = '';
            NeededSpaces = 0;
            Selected = OptionData[2] || false;
            Disabled = OptionData[3] || false;

            if (AJAXUpdate === 1) {
                Selected = OptionData[3];
                Disabled = OptionData[4];
            }

            if (Key.match(/::/g)) {
                NeededSpaces = Key.match(/::/g).length;
            }

            if (NeededSpaces > 0) {
                NeededSpaces = NeededSpaces * 2;
                for (i = 0; i < NeededSpaces; i++) {
                    Spaces = '&nbsp;' + Spaces;
                }
            }
            Value = Spaces + Value;

            SelectedAttr = '';
            if (Selected) {
                SelectedAttr = ' selected="selected"';
            }

            DisabledAttr = '';
            if (Disabled) {
                DisabledAttr = ' disabled="disabled"';
            }

            SelectData.push({
                'Key': Key,
                'Value': Value,
                'SelectedAttr': SelectedAttr,
                'DisabledAttr': DisabledAttr
            });
        });

        SelectData.sort(function(a, b) {

            var KeyA = a.Key.toLowerCase(),
                KeyB = b.Key.toLowerCase();

            if (KeyA < KeyB) {
               return -1;
            }
            if (KeyA > KeyB) {
               return 1;
            }
            return 0;
        });

        $.each(SelectData, function(index, SelectedData) {
            $FieldObj.append('<option value="' + SelectedData.Key + '"' + SelectedData.SelectedAttr + SelectedData.DisabledAttr + '>' + SelectedData.Value + '</option>');
        });

        $FieldObj.addClass('TreeViewRestored');
    };

    return TargetNS;
}(Core.UI.TreeSelection || {}));
