// --
// Core.UI.Accessibility.UnitTest.js - UnitTests
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.JSON.UnitTest.js,v 1.1 2010-06-17 22:33:36 cg Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};

Core.JSON = (function (Namespace) {
    Namespace.RunUnitTests = function(){
        module('Core.JSON');
        test('Core.JSON.Parse()', function(){

            expect(3);

            /*
             * Run the tests
             */
            var ValueTwo = "abcd";
            var jsonString = '{"ItemOne":1234,"ItemTwo":"' + ValueTwo + '","ItemThree":true,"ItemFour":false}';
            var JsonObject = Core.JSON.Parse(jsonString);
            var JsonReturn = Core.JSON.Stringify(JsonObject);

            equals(jsonString, JsonReturn, 'okay');
            equals(JsonObject.ItemOne, '1234', 'okay');
            equals(JsonObject.ItemTwo, ValueTwo, 'okay');

        });
    };

    return Namespace;
}(Core.JSON || {}));