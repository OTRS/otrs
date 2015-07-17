// --
// Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};

/**
 * @namespace Core.Agent.SortedTree
 * @memberof Core.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains the SortedTree functions.
 */
Core.Agent.SortedTree = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.SortedTree
     * @function
     * @param {jQueryObject} $Element - The jQuery object of an input structure which should get SortedTree functionality.
     * @param {jQueryObject} $Form - The jQuery object of the form that should commit collected data
     * @param {jQueryObject} $TargetElement - The jQuery object of the element that should contain the parsed data.
     * @param {JSONData} JSONData - json data for initial display
     * @description
     *      This function initializes the SortedTree on the defined elements.
     */
    TargetNS.Init = function ($Element, $Form, $TargetElement, JSONData) {

        /**
         * @private
         * @name AddElement
         * @memberof Core.Agent.SortedTree.Init
         * @function
         * @param {JSONData} Data - parsed json data for initial display
         * @param {jQueryObject} $TargetObj - The jQuery object for data insertion.
         * @description
         *      Fill the container with passed JSON data.
         */
        function AddElement(Data, $TargetObj) {
            var $ElementObj,
                $NewTargetObj;

            $.each(Data, function(Key, Value) {
                $ElementObj = $('.ElementTemplate').clone();
                if (Array.isArray(Value) && Value.length) {
                    $NewTargetObj = $('.SortableList').find('li:not(.ElementTemplate)').last();
                    if (!$NewTargetObj.children('ul').length) {
                        $NewTargetObj.append('<ul />');
                    }
                    AddElement(Value, $NewTargetObj.children('ul'));
                }
                else {
                    $ElementObj
                        .removeClass('ElementTemplate')
                        .find('input')
                        .val(Value);
                    $ElementObj.appendTo($TargetObj);
                }
            });
        }

        /**
         * @private
         * @name CollectElements
         * @memberof Core.Agent.SortedTree.Init
         * @function
         * @returns {Array} false, if no sorting elements exist.
         * @param {jQueryObject} $TargetObj - The jQuery object for element collection.
         * @description
         *      Fill the container with passed JSON data.
         */
        function CollectElements($TargetObj) {
            var Target = [];
            $TargetObj.children('li:not(.ElementTemplate)').each(function() {
                Target.push($(this).find('input').val());
                if ($(this).children('ul').length && $(this).children('ul').find('li').length) {
                    Target.push(CollectElements($(this).children('ul').first()));
                }
            });
            if (Target.length) {
                return Target;
            }
            else {
                return false;
            }
        }

        // Remove elements on click
        $Element.on('click.RemoveElement', 'strong', function() {

            // elements which have children can't be removed
            if ($(this).parent().next('ul').length) {
                alert("This element has children elements and can currently not be removed.");
//                alert([% Translate("This element has children elements and can currently not be removed.") | JSON %]);
                return false;
            }

            // if the current element is the last one on the current level, remove the entire list container,
            // otherwise only remove this list element
            if (!$(this).closest('ul').hasClass('SortableList') && $(this).closest('ul').find('li').length === 1) {
                $(this).closest('ul').fadeOut(function() {
                    $(this).remove();
                });
            }
            else {
                $(this).closest('li').fadeOut(function() {
                    $(this).remove();
                });
            }
        });

        // add new sub elements on click
        $Element.on('click.AddSubElement', '.Icon.Add', function() {

            var $ElementObj = $('.ElementTemplate').clone(),
                $TargetObj = $(this).closest('li');

            $ElementObj.removeClass('ElementTemplate');
            if (!$TargetObj.children('ul').length) {
                $TargetObj.append('<ul />');
                $TargetObj.children('ul').sortable();
            }
            $ElementObj.appendTo($TargetObj.children('ul'));
            $(this).closest('li').find('ul li:last-child').find('input').focus().select();
        });

        // select text on focus of an input element
        $Element.on('focus.SelectText', 'input.Element', function() {
            $(this).select();
        });

        // blur focused text on enter
        $Element.on('keydown.BlurText', 'input.Element', function(Event) {
            if (Event.keyCode === 13) {
                $(this).blur();
            }
        });

        // remove empty newly added elements
        $Element.on('blur.RemoveElement', 'input.Element', function() {
            if (!$(this).val()) {
                $(this).next('strong').trigger('click');
            }
        });

        // add new elements using the form
        $Element.next().find('button').on('click.AddElement', function() {
            var $InputElement = $(this).parent().find('input'),
                Input = $InputElement.val(),
                $ElementObj;

            if (Input) {
                $ElementObj = $('.ElementTemplate').clone();
                $ElementObj
                    .removeClass('ElementTemplate')
                    .find('input')
                    .val(Input)
                    .addClass(Input);
                $ElementObj.appendTo($Element);
                $InputElement.val('');
            }

            return false;
        });

        // generate JSON data
        $Form.on('submit.GenerateJSON', function() {
            var Items = CollectElements($Element),
                Value = '';

            if (Items) {
                Value = Core.JSON.Stringify(Items);
            }

            $TargetElement.val(Value);
        });

        // Initially fill the container with passed JSON data.
        AddElement(Core.JSON.Parse(JSONData), $Element);

        // make existing items sortable
        $Element.sortable();
        $Element.find('li ul').sortable();
    };

    return TargetNS;
}(Core.Agent.SortedTree || {}));
