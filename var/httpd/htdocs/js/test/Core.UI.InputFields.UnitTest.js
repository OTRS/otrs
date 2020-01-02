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

Core.UI.InputFields = (function (Namespace) {
    Namespace.RunUnitTests = function(){

        var $TestForm;

        QUnit.config.reorder = false;

        QUnit.module('Core.UI.InputFields');

        Core.Config.AddConfig({
            InputFieldsActivated: 1
        });

        /*
        * Create a form with few sample fields for the tests
        */
        $TestForm = $('<form id="TestForm" style="visibility: hidden;"></form>');
        $TestForm.append('<div class="Field"><select class="Validate_Required Modernize" id="MultipleSelect" multiple="multiple" name="MultipleSelect"><option value="">-</option><option value="1">Entry 1</option><option value="2">Entry 2</option><option value="-" disabled="disabled">Entry 3</option><option value="4">Entry 4</option><option value="-" disabled="disabled">Entry 5</option><option value="6">Entry 6</option></select></div>');
        $TestForm.append('<div class="Field"><select class="Validate_Required Modernize" id="Multiple&apos;Sel&quot;ect" multiple="multiple" name="MultipleSelect"><option value="">-</option><option value="1">Entry 1</option><option value="2">Entry 2</option><option value="-" disabled="disabled">Entry 3</option><option value="4">Entry 4</option><option value="-" disabled="disabled">Entry 5</option><option value="6">Entry 6</option></select></div>');
        $TestForm.append('<div class="Field"><select class="Validate_Required Modernize" id="SingleSelect" name="SingleSelect" data-tree="true"><option value="">-</option><option value="1">Entry 1</option><option value="2">Entry 2</option><option value="-" disabled="disabled">Entry 3</option><option value="4">Entry 4</option><option value="-" disabled="disabled">Entry 5</option><option value="6">Entry 6</option></select></div>');
        $TestForm.append('<div class="Field"><select class="Validate_Required Modernize" id="SingleSelect2" name="SingleSelect"><option value="">-</option><option value="1">Entry 1</option><option value="2">Entry 2</option><option value="-" disabled="disabled">Entry 3</option><option value="Test&quot;Value" selected>Entry 4</option><option value="-" disabled="disabled">Entry 5</option><option value="6">Entry 6</option></select></div>');
        $TestForm.append('<div class="Field"><select class="Validate_Required Modernize" id="SingleSelectQuoting" name="SingleSelectQuoting"><option value="">-</option><option value="1">Entry 1</option><option value="2">Entry 2</option><option value="you give &apos; love a &quot;bad&quot; name" selected>Bad entry</option><option value="6">Entry 6</option></select></div>');
        $('body').append($TestForm);

        /*
        * Initialize all fields in form
        */
        QUnit.test('Initialize fields', function (Assert) {

            Assert.expect(14);

            Core.UI.InputFields.Activate('*');

            $.each($('#TestForm').find('select.Modernize'), function (Index, Element) {

                var $SelectObj = $(Element);

                Assert.equal(Core.UI.InputFields.IsEnabled($SelectObj), true, 'Check if field is initialized (#' + (Index + 1) + ')');
                Assert.equal($('#' + Core.App.EscapeSelector($SelectObj.data('modernized'))).length, 1, 'Check if search field exists (#' + (Index + 1) + ')');
            });
        });

        $('#TestForm select.Modernize[multiple]').each(function () {
            var $Element = $(this);

            /*
            * Expand, make selection and close multiselect field
            */
            QUnit.test('Check multiselect field (expand)', function (Assert) {

                var $SelectObj = $Element,
                    $SearchObj = $('#' + Core.App.EscapeSelector($SelectObj.data('modernized'))),
                    $InputListContainerObj,
                    $Nodes,
                    Selection = ['1', '2', '4'],
                    OptionNumber = $SelectObj.find('option').not("[value='']").length,
                    SelectableOptionNumber = $SelectObj.find('option').not('[value=""],[disabled="disabled"]').length,
                    ListNumber,
                    ExpandSubscription,
                    Done1 = Assert.async();

                Assert.expect(4);

                // Define event subscription before the event itself - Wait for the event to finish
                ExpandSubscription = Core.App.Subscribe('Event.UI.InputFields.Expanded', function () {
                    Core.App.Unsubscribe(ExpandSubscription);

                    $InputListContainerObj = $('body > .InputField_ListContainer').first();

                    $Nodes = $InputListContainerObj.find('ul.jstree-container-ul li.jstree-node');
                    ListNumber = $Nodes.length;

                    Assert.equal(ListNumber, OptionNumber, 'Check if number of options matches');

                    $.each(Selection, function (Index, Value) {
                        $Nodes.filter('[data-id="' + Core.App.EscapeSelector(Value) + '"]').find('.jstree-anchor').click();
                    });

                    $SelectObj.triggerHandler('redraw.InputField');

                    Assert.deepEqual($SelectObj.val(), Selection, 'Check if selection matches');

                    $InputListContainerObj.find('.InputField_ClearAll').click();
                    Assert.deepEqual($SelectObj.val(), [ "" ], 'Check if selection has been cleared');

                    $InputListContainerObj.find('.InputField_SelectAll').click();
                    Assert.deepEqual($SelectObj.val().length, SelectableOptionNumber, 'Check if everything has been selected');

                    Done1();
                });

                // Trigger focus handler
                $SearchObj.triggerHandler('focus.InputField');
            });

            QUnit.test('Check multiselect field (close)', function (Assert) {

                var $SelectObj = $Element,
                    $SearchObj = $('#' + Core.App.EscapeSelector($SelectObj.data('modernized'))),
                    $InputContainerObj = $SelectObj.prev(),
                    CloseSubscription,
                    Done2 = Assert.async();

                Assert.expect(1);

                // Define event subscription before the event itself - Wait for the event to finish
                CloseSubscription = Core.App.Subscribe('Event.UI.InputFields.Closed', function () {
                    Core.App.Unsubscribe(CloseSubscription);

                    Assert.equal($InputContainerObj.find('.InputField_ListContainer').length, 0, 'Check if list has been removed from DOM');

                    Done2();
                });

                // Trigger blur handler
                $SearchObj.triggerHandler('blur.InputField');
                $('body').trigger('click');
            });
        });


        $('#TestForm select.Modernize:not([multiple])').each(function () {
            var $Element = $(this);

            /*
            * Expand, make selection, close and deselect single select field
            */
            QUnit.test('Check single select field (expand)', function (Assert) {

                var $SelectObj = $Element,
                    $SearchObj = $('#' + Core.App.EscapeSelector($SelectObj.data('modernized'))),
                    Selection = "6",
                    $Nodes,
                    OptionNumber = $SelectObj.find('option').not("[value='']").length,
                    $InputListContainerObj,
                    ListNumber,
                    ExpandSubscription,
                    Done1 = Assert.async();

                Assert.expect(2);

                // Define event subscription before the event itself - Wait for the event to finish
                ExpandSubscription = Core.App.Subscribe('Event.UI.InputFields.Expanded', function () {
                    Core.App.Unsubscribe(ExpandSubscription);

                    $InputListContainerObj = $('body > .InputField_ListContainer').first();

                    $Nodes = $InputListContainerObj.find('ul.jstree-container-ul li.jstree-node');
                    ListNumber = $Nodes.length;

                    Assert.equal(ListNumber, OptionNumber, 'Check if number of options matches');

                    $Nodes.filter('[data-id="' + Core.App.EscapeSelector(Selection) + '"]').find('.jstree-anchor').click();

                    $SelectObj.triggerHandler('redraw.InputField');
                    Assert.deepEqual($SelectObj.val(), Selection, 'Check if selection matches (' + Selection + ')');

                    Done1();
                });

                // Trigger focus handler
                $SearchObj.triggerHandler('focus.InputField');

            });

            QUnit.test('Check single select field (close)', function (Assert) {

                var $SelectObj = $Element,
                    $SearchObj = $('#' + Core.App.EscapeSelector($SelectObj.data('modernized'))),
                    $InputContainerObj = $SelectObj.prev(),
                    CloseSubscription,
                    Done2 = Assert.async();

                Assert.expect(2);

                // Define event subscription before the event itself - Wait for the event to finish
                CloseSubscription = Core.App.Subscribe('Event.UI.InputFields.Closed', function () {
                    Core.App.Unsubscribe(CloseSubscription);

                    Assert.equal($InputContainerObj.find('.InputField_ListContainer').length, 0, 'Check if list has been removed from DOM');

                    // Wait for everything to be closed and resettet
                    window.setTimeout(function () {
                        $InputContainerObj.find('.InputField_Selection .Remove a').click();
                        Assert.equal($SelectObj.val(), [], 'Check if empty selection matches');
                        Done2();
                    }, 100);
                });

                // Trigger blur handler
                $SearchObj.triggerHandler('blur.InputField');
                $('body').trigger('click');
            });
        });

        // Check if modified tree selection successfully expands (bug#12017)
        QUnit.test('Check field with tree selection (expand)', function (Assert) {
            var $SelectObj = $('#TestForm select#SingleSelect'),
                $SearchObj = $('#' + Core.App.EscapeSelector($SelectObj.data('modernized'))),
                $LeafOptions = $('<option value="11">&nbsp;&nbsp;Sub-entry 1</option><option value="12">&nbsp;&nbsp;Sub-entry 2</option><option value="13">&nbsp;&nbsp;Sub-entry 3</option>'),
                $Nodes,
                OptionNumber = $SelectObj.find('option').not("[value='']").length,
                OptionNumberTotal = $SelectObj.find('option').length,
                $InputListContainerObj,
                ListNumber,
                ExpandSubscription,
                Done1 = Assert.async();

            Assert.expect(2);

            // Append leaves
            $LeafOptions.insertAfter($SelectObj.find('option[value="1"]'));

            Assert.equal($SelectObj.find('option').length, OptionNumberTotal+$LeafOptions.length, 'Check if number of options has increased');

            // Define event subscription before the event itself - Wait for the event to finish
            ExpandSubscription = Core.App.Subscribe('Event.UI.InputFields.Expanded', function () {
                Core.App.Unsubscribe(ExpandSubscription);

                $InputListContainerObj = $('body > .InputField_ListContainer').first();

                $Nodes = $InputListContainerObj.find('ul.jstree-container-ul li.jstree-node');
                ListNumber = $Nodes.length;

                Assert.equal(ListNumber, OptionNumber, 'Check if number of options matches');

                Done1();
            });

            // Trigger focus handler
            $SearchObj.triggerHandler('focus.InputField');

        });

        QUnit.test('Check field with tree selection (close)', function (Assert) {

            var $SelectObj = $('#TestForm select#SingleSelect'),
                $SearchObj = $('#' + Core.App.EscapeSelector($SelectObj.data('modernized'))),
                $InputContainerObj = $SelectObj.prev(),
                CloseSubscription,
                Done2 = Assert.async();

            Assert.expect(2);

            // Define event subscription before the event itself - Wait for the event to finish
            CloseSubscription = Core.App.Subscribe('Event.UI.InputFields.Closed', function () {
                Core.App.Unsubscribe(CloseSubscription);

                Assert.equal($InputContainerObj.find('.InputField_ListContainer').length, 0, 'Check if list has been removed from DOM');

                // Wait for everything to be closed and resettet
                window.setTimeout(function () {
                    $InputContainerObj.find('.InputField_Selection .Remove a').click();
                    Assert.equal($SelectObj.val(), [], 'Check if empty selection matches');
                    Done2();
                }, 100);
            });

            // Trigger blur handler
            $SearchObj.triggerHandler('blur.InputField');
            $('body').trigger('click');
        });

        /*
        * Check disabled field
        */
        $TestForm.append('<div class="Field"><select class="Modernize" id="UnavailableSelect" name="UnavailableSelect"><option value="">-</option><option value="Disabled" disabled="disabled">Disabled entry</option></select></div>');

        // Also initialize new field
        Core.UI.InputFields.Activate('*');

        QUnit.test('Check unavailable field', function (Assert) {

            var $SelectObj = $('#UnavailableSelect'),
                $SearchObj = $('#' + $SelectObj.data('modernized'));

            Assert.expect(2);

            Assert.equal($SearchObj.attr('readonly'), 'readonly', 'Check if field is readonly');
            Assert.equal($SearchObj.attr('title'), Core.Language.Translate('Not available'), 'Check if field has appropriate title');
        });

        $TestForm.append('<div class="Field"><select class="Validate_Required Modernize" id="SingleSelectClear" name="SingleSelectClear"><option value="">-</option><option value="1" selected>Entry 1</option><option value="2">Entry 2</option><option value="-" disabled="disabled">Entry 3</option><option value="4">Entry 4</option><option value="-" disabled="disabled">Entry 5</option><option value="6">Entry 6</option></select></div>');

        // Also initialize new field
        Core.UI.InputFields.Activate('*');

        // check if field is cleared properly when the original select loses it's options
        QUnit.test('Check field clearance', function (Assert) {

            var $SelectObj = $('#SingleSelectClear'),
                $InputContainerObj = $SelectObj.prev();

            Assert.expect(2);

            Assert.equal($InputContainerObj.find('.InputField_Selection').find('.Text').text(), 'Entry 1', 'Check if initial selection is correct');

            // now remove the options from the original select and add an empty one
            $SelectObj.find('option').remove();
            $SelectObj.append('<option value="">-</option>');
            $SelectObj.triggerHandler('redraw.InputField');

            // the selected value should be gone now
            Assert.equal($InputContainerObj.find('.InputField_Selection').length, 0, 'Check if the field still has any selection');
        });

        /*
        * Turn off Expand, make selection and close multiselect field
        */
        QUnit.test('Revert fields', function (Assert) {

            Assert.expect(7);

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
