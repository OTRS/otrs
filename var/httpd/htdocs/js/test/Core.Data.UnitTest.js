// --
// Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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
                $TestDiv = $('<div id="Container"></div>');
            $TestDiv.append('<span id="ElementOne"></span>');
            $TestDiv.append('<span id="ElementTwo"></span>');
            $('body').append($TestDiv);

            /*
             * Run the tests
             */

            Assert.expect(5);

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

             /*
             * Cleanup div container and contents
             */
            $('#Container').remove();
        });
    };

    return Namespace;
}(Core.Data || {}));
