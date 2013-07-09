// --
// Core.UI.TreeSelection.js - Tree selection for select elements
// Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
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
 * @exports TargetNS as Core.UI.TreeSelection
 * @description
 *      Tree Selection for Queue, Service, etc. with JSTree
 */
Core.UI.TreeSelection = (function (TargetNS) {

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
     * @function
     * @description
     *      This function receives a select element which was built
     *      with TreeView => 1 (= intended elements) and builds a
     *      javascript object from it which contains all the elements
     *      and their children.
     * @param {jQueryObject} $Element
     *      The select element which contains the data
     * @return
     *      Returns an object which is suitable for passing to JSTree in order
     *      to build a tree selection.
     */
    function BuildElementsArray($Element) {

        var Elements = [],
            Level,
            HighestLevel = 0;

        $Element.find('option').each(function() {

            // get number of trailing spaces in service name to
            // distinguish the level (2 spaces = 1 level)
            var ElementID       = $(this).attr('value'),
                ElementDisabled = $(this).is(':disabled'),
                ElementName     = $(this).text(),
                ElementNameTrim = ElementName.replace(/(^[\xA0]+)/g, ''),
                CurrentLevel    = (ElementName.length - ElementNameTrim.length) / 2,
                ChildOf = 0,
                ElementIndex = 0,
                CurrentElement;

            // skip entry if no ID (should only occur for the leading empty element, '-')
            // also skip entries which only contain '------------' as visible text (e.g. in AgentLinkObject)
            if ( !ElementID || ElementID === "||-" || ( ElementDisabled && ElementName.match(/^-+$/) ) ) {
                return true;
            }

            // determine wether this element is a child of a preceding element
            // therefore, take the last element we have added to our elements
            // array and compare if to the current element
            if ( Elements.length && CurrentLevel > 0 ) {

                // if the current level is bigger than the last known level,
                // we're dealing with a child element of the last element
                if ( CurrentLevel > Elements[Elements.length - 1].Level ) {
                    ChildOf = Elements[Elements.length - 1].ID;
                }

                // if both levels equal eachother, we have a sibling and can
                // re-use the parent (= the ChildOf value) of the last element
                else if ( CurrentLevel === Elements[Elements.length - 1].Level ) {
                    ChildOf = Elements[Elements.length - 1].ChildOf;
                }

                // in other cases, we have an element of a lower level but not
                // of the first level, so we walk through all yet saved elements
                // (bottom up) and find the next element with a lower level
                else {
                    for ( ElementIndex = Elements.length; ElementIndex >= 0; ElementIndex-- ) {
                        if ( CurrentLevel > Elements[ElementIndex - 1].Level ) {
                            ChildOf = Elements[ElementIndex - 1].ID;
                            break;
                        }
                    }
                }
            }

            // collect data of current service and add it to elements array
            CurrentElement = {
                ID:       ElementID,
                Name:     ElementNameTrim,
                Level:    CurrentLevel,
                ChildOf:  ChildOf,
                children: [],
                data:     ElementNameTrim,
                attr: {
                    'data-id': ElementID,
                    'class' : (ElementDisabled) ? 'Disabled' : ''
                }
            };
            Elements.push(CurrentElement);

            if (CurrentLevel > HighestLevel) {
                HighestLevel = CurrentLevel;
            }
        });

        Elements.sort(function(a, b) {
            return (a.Level - b.Level);
        });

        // go through all levels and collect the elements and their children
        for (Level = HighestLevel; Level >= 0; Level--) {
            Elements = CollectElements(Elements, Level);
        }

        return Elements;
    }

      /**
     * @function
     * @private
     * @return nothing
     * @description Open the tree view selection dialog
     */
    TargetNS.ShowTreeSelection = function($TriggerObj) {

        var $TreeObj       = $('<div id="JSTree"><ul></ul></div>'),
            $SelectObj     = $TriggerObj.prevAll('select'),
            SelectSize     = $SelectObj.attr('size'),
            SelectedID     = $SelectObj.val(),
            Multiple       = ($SelectObj.attr('multiple') !== '' && $SelectObj.attr('multiple') !== undefined) ? true : false,
            ElementCount   = $SelectObj.find('option').length,
            DialogTitle    = $SelectObj.parent().prev('label').text(),
            Elements       = {},
            InDialog       = false,
            $SelectedNodesObj,
            SelectedNodes = [],
            $CurrentTreeObj;

        if (!$SelectObj) {
            return false;
        }

        // determine if we are in a dialog
        if ($SelectObj.closest('.Dialog').length) {
            InDialog = true;
        }

        if (!DialogTitle) {
            DialogTitle = $SelectObj.prev('label').text();
        }

        DialogTitle = $.trim(DialogTitle);
        DialogTitle = DialogTitle.substr(0, DialogTitle.length - 1);
        DialogTitle = DialogTitle.replace(/^\*\s+/, '');

        // check if there are elements to select from
        if (ElementCount === 1 && $SelectObj.find('option').text() === '-') {
            alert(Core.Config.Get('NoElementsToSelectFromMsg'));
            return false;
        }

        Elements = BuildElementsArray($SelectObj);

        $TreeObj.jstree({
            "core": {
                "animation" : 70
            },
            "ui": {
                "select_multiple_modifier" : ((SelectSize && Multiple) || Multiple) ? 'on' : 'ctrl',
                "select_limit" : ((SelectSize && Multiple) || Multiple) ? -1 : 1
            },
            "search": {
                "show_only_matches" : true
            },
            "json_data" : {
                "data" : Elements
            },
            "themes" : {
                "theme" : "default",
                "icons" : false
            },
            "plugins" : [ "themes", "json_data", "ui", "hotkeys", "search" ]
        })
        .bind("select_node.jstree", function (event, data) {
            if (data.rslt.obj.hasClass('Disabled')) {
                $TreeObj.jstree("deselect_node", data.rslt.obj);
            }
            $TreeObj.jstree("toggle_node", data.rslt.obj);

            // if we are already in a dialog, we don't use the submit
            // button for the tree selection, so we need to apply the changes 'live'
            if (InDialog) {

                // reset selected nodes list
                SelectedNodes = [];

                // get selected nodes
                $SelectedNodesObj = $TreeObj.jstree("get_selected");
                $SelectedNodesObj.each(function() {
                    SelectedNodes.push($(this).attr('data-id'));
                });

                // set selected nodes as selected in initial select box
                // (which is hidden but is still used for the action)
                $SelectObj.val(SelectedNodes);
            }
        })
        .bind("deselect_node.jstree", function (event, data) {

            // if we are already in a dialog, we don't use the submit
            // button for the tree selection, so we need to apply the changes 'live'
            if (InDialog) {

                // reset selected nodes list
                SelectedNodes = [];

                // get selected nodes
                $SelectedNodesObj = $TreeObj.jstree("get_selected");
                $SelectedNodesObj.each(function() {
                    SelectedNodes.push($(this).attr('data-id'));
                });

                // set selected nodes as selected in initial select box
                // (which is hidden but is still used for the action)
                $SelectObj.val(SelectedNodes);
            }
        })
        .bind("loaded.jstree", function (event, data) {

            if (SelectedID) {
                if (typeof SelectedID === 'object') {
                    $.each(SelectedID, function(Index, Data) {
                        $TreeObj.jstree("select_node", $TreeObj.find('li[data-id="' + Data + '"]'));
                    });
                }
                else {
                    $TreeObj.jstree("select_node", $TreeObj.find('li[data-id="' + SelectedID + '"]'));
                }
            }
        });

        // If we are not already in a dialog, open up one
        // which contains the tree selection; otherwise just
        // hide the select element and show the tree selection
        if (!InDialog) {

            Core.UI.Dialog.ShowContentDialog('<div class="OverlayTreeSelector" id="TreeContainer"></div>', DialogTitle, '20%', 'Center', true);
            $('#TreeContainer')
                .prepend($TreeObj)
                .prepend('<div id="TreeSearch"><input type="text" id="TreeSearch" placeholder="' + Core.Config.Get('SearchMsg') + '..." /><span>x</span></div>')
                .append('<input type="button" id="SubmitTree" value="' + Core.Config.Get('ApplyButtonText') + '" />');
        }
        else {
            $TreeObj
                .addClass('Hidden InOverlay')
                .insertAfter($SelectObj)
                .show();
            $SelectObj.hide();
            $TriggerObj.hide();
        }

        $('#TreeSearch').find('input').bind('keyup', function() {
            $TreeObj.jstree("search", $(this).val());
        });

        $('#TreeSearch').find('span').bind('click', function() {
            $(this).prev('input').val('');
            $TreeObj.jstree("clear_search");
        });

        $('#TreeContainer').find('input#SubmitTree').bind('click', function() {
            var $SelectedObj = $TreeObj.jstree("get_selected");
            if (typeof $SelectedObj === 'object' && $SelectedObj.attr('data-id')) {
                if ($SelectedObj.length > 1) {

                    $SelectedObj.each(function() {
                        SelectedNodes.push($(this).attr('data-id'));
                    });
                    $SelectObj
                        .val(SelectedNodes)
                        .trigger('change');
                }
                else {
                    if ($SelectedObj.attr('data-id') !== $SelectObj.val()) {
                        $SelectObj
                            .val($SelectedObj.attr('data-id'))
                            .trigger('change');
                    }
                }
            }
            Core.UI.Dialog.CloseDialog($('.Dialog'));
        });
    };

    /**
     * @function
     * @private
     * @return nothing
     * @description to bind click event no tree selection icons next to select boxes
     */
    TargetNS.InitTreeSelection = function() {
        $('.Field, fieldset').off('click.ShowTreeSelection').on('click.ShowTreeSelection', '.ShowTreeSelection', function (Event) {
            Core.UI.TreeSelection.ShowTreeSelection($(this));
            return false;
        });
    };

    /**
     * @function
     * @private
     * @return nothing
     * @description Initially display dynamic fields with TreeMode = 1 correctly
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
     * @function
     * @private
     * @return nothing
     * @description Restores tree view (intended values) for dynamic fields
     */
    TargetNS.RestoreDynamicFieldTreeView = function($FieldObj, Data, CheckClass, AJAXUpdate) {

        var Key,
            Value,
            Selected,
            SelectedAttr,
            Disabled,
            DisabledAttr,
            SelectData = [],
            LastElement,
            NeededSpaces,
            Spaces,
            i;

        if (CheckClass && $FieldObj.hasClass('TreeViewRestored')) {
            return false;
        }

        $FieldObj.find('option').remove();

        $.each(Data, function(index, OptionData) {

            Key       = OptionData[0] || '';
            Value     = OptionData[1] || '';
            Spaces    = '';
            NeededSpaces = 0;
            Selected  = OptionData[2] || false;
            Disabled  = OptionData[3] || false;

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
                'Key'          : Key,
                'Value'        : Value,
                'SelectedAttr' : SelectedAttr,
                'DisabledAttr' : DisabledAttr
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

        $.each(SelectData, function(index, Data) {
            $FieldObj.append('<option value="' + Data.Key + '"' + Data.SelectedAttr + Data.DisabledAttr + '>' + Data.Value + '</option>');
        });

        $FieldObj.addClass('TreeViewRestored');
    };


    return TargetNS;
}(Core.UI.TreeSelection || {}));
