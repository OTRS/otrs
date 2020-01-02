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

Core.UI.Table = (function (Namespace) {
    Namespace.RunUnitTests = function(){

        QUnit.module('Core.UI.Table');

        QUnit.test('Core.UI.Table.InitTableFilter()', function(Assert){

            var $TestForm,
                $RowOne = {name:'FirstRow', validity:'valid'},
                $RowTwo = {name:'SecondRow', validity:'invalid'},
                Done = Assert.async(3);

            /*
            * Create a form with table and filter
            */
            $TestForm = $('<form id="TestForm"></form>');
            $TestForm.append('<div class="Content"><table class="DataTable" id="QunitTable"><thead><tr><th>Name</th><th>Validity</th></tr></thead><tbody><tr><td>' + $RowOne.name + '</td><td>' + $RowOne.validity + '</td></tr><tr><td>' + $RowTwo.name + '</td><td>' + $RowTwo.validity + '</td></tr><tr class="FilterMessage Hidden"><td colspan="4">No matches found</td></tr></tbody></table></div>');
            $TestForm.append('<div class="Content"><input type="text" id="QunitFilter"></div>')

            $('body').append($TestForm);

            Assert.expect(11);

            // Initialize table filter for test table
            Core.UI.Table.InitTableFilter($('#QunitFilter'), $('#QunitTable'));

            // Verify all table row's are visible without filter
            Assert.equal($('tbody tr:eq(0)').css('display'), 'table-row', 'First Row is shown in table');
            Assert.equal($('tbody tr:eq(1)').css('display'), 'table-row', 'Second Row is shown in table');

            // Input filter value so only first row is visible
            $('#QunitFilter').val($RowOne.name);
            $('#QunitFilter').trigger($.Event("keydown"));

            // Wait for filter trigger
            setTimeout(function() {

                // Verify only first table row is visible with filter
                Assert.equal($('tbody tr:eq(0)').css('display'), 'table-row', 'First Row is shown in table with "FirstRow" filter string');
                Assert.equal($('tbody tr:eq(1)').css('display'), 'none', 'Second Row is hidden in table with "FirstRow" filter string');
                Assert.equal($('.FilterMessage').css('display'), 'none', 'Result FilterMessage is hidden in table with "FirstRow" filter string');

                // Input filter value so only second row is visible
                $('#QunitFilter').val($RowTwo.validity);
                $('#QunitFilter').trigger($.Event("keydown"));

                // Wait for filter trigger
                setTimeout(function() {

                    // Verify only second table row is visible with filter
                    Assert.equal($('tbody tr:eq(0)').css('display'), 'none', 'First Row is hidden in table with "invalid" filter string');
                    Assert.equal($('tbody tr:eq(1)').css('display'), 'table-row', 'Second Row is shown in table with "invalid" filter string');
                    Assert.equal($('.FilterMessage').css('display'), 'none', 'Result FilterMessage is hidden in table with "invalid" filter string');

                    // Input wrong filter value
                    $('#QunitFilter').val('rewqeweqtrq');
                    $('#QunitFilter').trigger($.Event("keydown"));

                    // Wait for filter trigger
                    setTimeout(function() {

                        // Verify no data is visible, FilterMessage is visible
                        Assert.equal($('tbody tr:eq(0)').css('display'), 'none', 'First Row is hidden in table with wrong filter string');
                        Assert.equal($('tbody tr:eq(1)').css('display'), 'none', 'Second Row is hidden in table with wrong filter string');
                        Assert.equal($('.FilterMessage').css('display'), 'table-row', 'Result FilterMessage is shown with wrong filter string');

                        // Cleanup div container and contents
                        $('#TestForm').remove();

                        Done();
                    }, 300);

                    Done();
                }, 300);

                Done();
            }, 300);

        });
    };

    return Namespace;
}(Core.UI.Table || {}));
