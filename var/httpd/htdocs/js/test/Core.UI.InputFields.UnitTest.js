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

Core.UI.InputFields = (function (Namespace) {
    Namespace.RunUnitTests = function(){

        var $TestForm;

        module('Core.UI.InputFields');

        Core.Config.AddConfig({
            InputFieldsActivated: 1,
            InputFieldsNotAvailable: 'Not available',
            InputFieldsNoMatchMsg: 'No matches found',
            InputFieldsSelectAll: 'Select all',
            InputFieldsClearAll: 'Clear all',
            InputFieldsClearSearch: 'Clear search',
            InputFieldsRemoveSelection: 'Remove selection',
            InputFieldsMore: 'and %s more...',
            InputFieldsFilters: 'Filters',
            InputFieldsConfirm: 'Confirm'
        });

        /*
        * Create a form with few sample fields for the tests
        */
        $TestForm = $('<form id="TestForm" style="visibility: hidden;"></form>');
        $TestForm.append('<div class="Field"><select class="Validate_Required Modernize" id="MultipleSelect" multiple="multiple" name="MultipleSelect"><option value="">-</option><option value="1">Entry 1</option><option value="2">Entry 2</option><option value="-" disabled="disabled">Entry 3</option><option value="4">Entry 4</option><option value="-" disabled="disabled">Entry 5</option><option value="6">Entry 6</option></select></div>');
        $TestForm.append('<div class="Field"><select class="Validate_Required Modernize" id="SingleSelect" name="SingleSelect"><option value="">-</option><option value="1">Entry 1</option><option value="2">Entry 2</option><option value="-" disabled="disabled">Entry 3</option><option value="4">Entry 4</option><option value="-" disabled="disabled">Entry 5</option><option value="6">Entry 6</option></select></div>');
        $TestForm.append('<div class="Field"><select class="Modernize" id="UnavailableSelect" name="UnavailableSelect"><option value="">-</option><option value="Disabled" disabled="disabled">Disabled entry</option></select></div>');
        $('body').append($TestForm);

        /*
        * Initialize all fields in form
        */
        test('Initialize fields', function (Assert) {

            Assert.expect(6);

            Core.UI.InputFields.Activate('*');

            $.each($('#TestForm').find('select.Modernize'), function (Index, Element) {

                var $SelectObj = $(Element);

                Assert.equal(Core.UI.InputFields.IsEnabled($SelectObj), true, 'Check if field is initialized (#' + (Index + 1) + ')');
                Assert.equal($('#' + $SelectObj.data('modernized')).length, 1, 'Check if search field exists (#' + (Index + 1) + ')');
            });
        });

        /*
        * Expand, make selection and close multiselect field
        */
        test('Check multiselect field', function (Assert) {

            var $SelectObj = $('#MultipleSelect'),
                $SearchObj = $('#' + $SelectObj.data('modernized')),
                $InputContainerObj = $SelectObj.prev(),
                $Nodes,
                Selection = ['1', '2', '4'],
                OptionNumber = $SelectObj.find('option').not("[value='']").length,
                SelectableOptionNumber = $SelectObj.find('option').not('[value=""],[disabled="disabled"]').length,
                ListNumber,
                ExpandSubscription,
                CloseSubscription,
                Done1 = Assert.async(),
                Done2 = Assert.async();

            Assert.expect(5);

            // Trigger focus handler
            $SearchObj.triggerHandler('focus.InputField');

            // Wait for the event to finish
            ExpandSubscription = Core.App.Subscribe('Event.UI.InputFields.Expanded', function () {
                Core.App.Unsubscribe(ExpandSubscription);

                $Nodes = $InputContainerObj.find('ul.jstree-container-ul li.jstree-node');
                ListNumber = $Nodes.length;
                Assert.equal(ListNumber, OptionNumber, 'Check if number of options matches');

                $.each(Selection, function (Index, Value) {
                    $Nodes.filter('[data-id="' + Value + '"]').find('.jstree-anchor').click();
                });
                Assert.deepEqual($SelectObj.val(), Selection, 'Check if selection matches');

                $InputContainerObj.find('.InputField_ClearAll').click();
                Assert.deepEqual($SelectObj.val(), [ "" ], 'Check if selection has been cleared');

                $InputContainerObj.find('.InputField_SelectAll').click();
                Assert.deepEqual($SelectObj.val().length, SelectableOptionNumber, 'Check if everything has been selected');

                Done1();
            });

            // Trigger blur handler
            $SearchObj.triggerHandler('blur.InputField');

            // Wait for the event to finish
            CloseSubscription = Core.App.Subscribe('Event.UI.InputFields.Closed', function () {
                Core.App.Unsubscribe(CloseSubscription);

                Assert.equal($InputContainerObj.find('.InputField_ListContainer').length, 0, 'Check if list has been removed from DOM');

                Done2();
            });
        });

        /*
        * Expand, make selection, close and deselect single select field
        */
        test('Check single select field', function (Assert) {

            var $SelectObj = $('#SingleSelect'),
                $SearchObj = $('#' + $SelectObj.data('modernized')),
                Selection = "6",
                $Nodes,
                OptionNumber = $SelectObj.find('option').not("[value='']").length,
                $InputContainerObj = $SelectObj.prev(),
                ListNumber,
                ExpandSubscription,
                CloseSubscription,
                Done1 = Assert.async(),
                Done2 = Assert.async();

            Assert.expect(4);

            // Trigger focus handler
            $SearchObj.triggerHandler('focus.InputField');

            // Wait for the event to finish
            ExpandSubscription = Core.App.Subscribe('Event.UI.InputFields.Expanded', function () {
                Core.App.Unsubscribe(ExpandSubscription);

                $Nodes = $InputContainerObj.find('ul.jstree-container-ul li.jstree-node');
                ListNumber = $Nodes.length;
                Assert.equal(ListNumber, OptionNumber, 'Check if number of options matches');

                $Nodes.filter('[data-id="' + Selection + '"]').find('.jstree-anchor').click();
                Assert.deepEqual($SelectObj.val(), Selection, 'Check if selection matches');

                Done1();
            });

            // Trigger blur handler
            $SearchObj.triggerHandler('blur.InputField');

            // Wait for the event to finish
            CloseSubscription = Core.App.Subscribe('Event.UI.InputFields.Closed', function () {
                Core.App.Unsubscribe(CloseSubscription);

                Assert.equal($InputContainerObj.find('.InputField_ListContainer').length, 0, 'Check if list has been removed from DOM');

                $InputContainerObj.find('.InputField_Selection .Remove a').click();
                Assert.equal($SelectObj.val(), '', 'Check if empty selection matches');

                Done2();
            });
        });

        /*
        * Check disabled field
        */
        test('Check unavailable field', function (Assert) {

            var $SelectObj = $('#UnavailableSelect'),
                $SearchObj = $('#' + $SelectObj.data('modernized'));

            Assert.expect(2);

            Assert.equal($SearchObj.attr('disabled'), 'disabled', 'Check if field is disabled');
            Assert.equal($SearchObj.attr('title'), Core.Config.Get('InputFieldsNotAvailable'), 'Check if field has appropriate title');
        });

        /*
        * Turn off Expand, make selection and close multiselect field
        */
        test('Revert fields', function (Assert) {

            Assert.expect(3);

            Core.UI.InputFields.Deactivate('*');

            $.each($('#TestForm').find('select.Modernize'), function (Index, Element) {

                var $SelectObj = $(Element);

                Assert.equal(Core.UI.InputFields.IsEnabled($SelectObj), false, 'Check if field has been reverted (#' + (Index + 1) + ')');
            });
        });

        /*
        * Remove test elements from the page
        */
        QUnit.done(function () { //eslint-disable-line no-undef
           $('#TestForm').remove();
        });
    };

    return Namespace;
}(Core.UI.InputFields || {}));
