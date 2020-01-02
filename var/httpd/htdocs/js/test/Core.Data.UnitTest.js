// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var Core = Core || {};

Core.Data = (function (Namespace) {
    Namespace.RunUnitTests = function(){
        QUnit.module('Core.Data');
        QUnit.test('Core.Data.Set()', function(Assert){

            /*
             * Create a div containter for the tests
             */
            var Sign, ObjectOne, ObjectTwo, ResultOneEmpty, NonexistingResult,
                ResultOne, ResultTwo,
                ObjectThree, ObjectFour, ResultCompare,
                $TestDiv = $('<div id="Container"></div>');
            $TestDiv.append('<span id="ElementOne"></span>');
            $TestDiv.append('<span id="ElementTwo"></span>');
            $('body').append($TestDiv);

            /*
             * Run the tests
             */

            Assert.expect(9);

            Sign = 'Save This Information';
            ObjectOne = $('#ElementOne');
            ObjectTwo = $('#ElementTwo');

            ResultOneEmpty = Core.Data.Get(ObjectOne, 'One');
            Assert.deepEqual(ResultOneEmpty, {}, 'information not yet stored');

            NonexistingResult = Core.Data.Get($('#nonexisting_selector'), 'One');
            Assert.deepEqual(NonexistingResult, {}, 'nonexisting element');

            Core.Data.Set(ObjectOne, 'One', Sign);
            Core.Data.Set(ObjectTwo, 'Two', Sign);

            ResultOne = Core.Data.Get(ObjectOne, 'One');
            ResultTwo = Core.Data.Get(ObjectTwo, 'Two');

            Assert.equal(ResultOne, Sign, 'okay');
            Assert.equal(ResultTwo, Sign, 'okay');
            Assert.equal(ResultOne, ResultTwo, 'okay');

            /* test CopyObject and CompareObject functions */
            ObjectThree = {
                "ItemOne": "abcd"
            };

            ObjectFour = Core.Data.CopyObject(ObjectThree);
            Assert.deepEqual(ObjectThree, ObjectFour, 'okay');

            ResultCompare = Core.Data.CompareObject(ObjectThree, ObjectFour);
            Assert.equal(ResultCompare, true, 'okay');

            ObjectThree.ItemTwo = "1234";
            Assert.notDeepEqual(ObjectThree, ObjectFour, 'okay');

            ResultCompare = Core.Data.CompareObject(ObjectThree, ObjectFour);
            Assert.equal(ResultCompare, false, 'okay');

             /*
             * Cleanup div container and contents
             */
            $('#Container').remove();
        });
    };

    return Namespace;
}(Core.Data || {}));
