// --
// Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};

Core.Data = (function (Namespace) {
    Namespace.RunUnitTests = function(){
        module('Core.Data');
        test('Core.Data.Set()', function(){

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

            expect(5);

            Sign = 'Save This Information';
            ObjectOne = $('#ElementOne');
            ObjectTwo = $('#ElementTwo');

            ResultOneEmpty = Core.Data.Get(ObjectOne, 'One');
            deepEqual(ResultOneEmpty, {}, 'information not yet stored');

            NonexistingResult = Core.Data.Get($('#nonexisting_selector'), 'One');
            deepEqual(NonexistingResult, {}, 'nonexisting element');

            Core.Data.Set(ObjectOne, 'One', Sign);
            Core.Data.Set(ObjectTwo, 'Two', Sign);

            ResultOne = Core.Data.Get(ObjectOne, 'One');
            ResultTwo = Core.Data.Get(ObjectTwo, 'Two');

            equal(ResultOne, Sign, 'okay');
            equal(ResultTwo, Sign, 'okay');
            equal(ResultOne, ResultTwo, 'okay');

             /*
             * Cleanup div container and contents
             */
            $('#Container').remove();
        });
    };

    return Namespace;
}(Core.Data || {}));
