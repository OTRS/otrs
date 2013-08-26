// --
// Core.JSON.UnitTest.js - UnitTests
// Copyright (C) 2001-2012 OTRS AG, http://otrs.org/\n";
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

            expect(16);

            /*
             * Run the tests
             */
            var ValueTwo = "abcd";
            var StringOne = '{"ItemOne":1234,"ItemTwo":"' + ValueTwo + '","ItemThree":true,"ItemFour":false}';
            var ObjectOne = Core.JSON.Parse(StringOne);
            var ReturnOne = Core.JSON.Stringify(ObjectOne);

            equal(StringOne, ReturnOne, 'okay');
            equal(ObjectOne.ItemOne, '1234', 'okay');
            equal(ObjectOne.ItemTwo, ValueTwo, 'okay');


            /* Round 2*/
            var ObjectTwo =
            { "Consulting" : [
                                { "Address"     : "535 Joseph Roberts Av.",
                                  "Employees"   : 12,
                                  "LastUpdate"  : '06/12/2010' }
                              ],
              "Sales"       : [
                                { "Address"     : "789 Second St.",
                                  "Employees"   : 8,
                                  "LastUpdate"  : '06/12/2010' }
                              ]
            };
            var ReturnTwo   = Core.JSON.Stringify(ObjectTwo);
            var ObjectThree = Core.JSON.Parse(ReturnTwo);
            var ReturnThree = Core.JSON.Stringify(ObjectThree);

            equal(ObjectTwo.Consulting[0].Address, ObjectThree.Consulting[0].Address, 'okay');
            equal(ObjectTwo.Sales[0].LastUpdate, ObjectThree.Sales[0].LastUpdate, 'okay');
            equal(ReturnTwo, ReturnThree, 'okay');
            var ResultCompare1 = Core.Data.CompareObject(ObjectTwo, ObjectThree);
            equal(ResultCompare1, true, 'okay');

            // Delete a element and compare
            ObjectTwo.Sales[0].LastUpdate = '10/12/2010';
            var ResultCompare2 = Core.Data.CompareObject(ObjectTwo, ObjectThree);
            notEqual(ResultCompare2, true, 'okay');

            var ReturnDiferent = Core.JSON.Stringify(ObjectTwo);
            notEqual(ReturnTwo, ReturnDiferent, 'okay');


            /* Round 3*/
            var ObjectFour =
            {
                "CompanyOne" :
                    [{ "Areas" :
                        [{ "Marketing" :
                            [{ "Address"     : "23 Albert Einstein St.",
                               "Employees"   : 7,
                               "LastUpdate"  : '10/03/2008'
                            }],
                           "Sales" :
                            [{ "Address"     : "1555 London St.",
                               "Employees"   : 30,
                               "LastUpdate"  : '20/10/2009'
                            }]
                        }]
                    }]
             };

            var ObjectFive = {};
            var StringCompanyTwo =
                '{"Design":[{"Address":"777 Beach Av.","Employees":20,"LastUpdate":"25/02/2010"}],' +
                 '"Development":[{"Address":"1 Sunset St.","Employees":300,"LastUpdate":"24/06/2010"}]}';
            var ObjectSix = Core.JSON.Parse(StringCompanyTwo);
            ObjectFive.Areas = ObjectSix;

            ObjectFour.CompanyTwo = ObjectFive;
            ObjectFour.CompanyThree = {};
            ObjectFour.CompanyThree.Areas = ObjectTwo;

            var ReturnCompanyTwo   = Core.JSON.Stringify(ObjectFive.Areas);
            equal(StringCompanyTwo, ReturnCompanyTwo, 'okay');
            var ResultCompare3 = Core.Data.CompareObject(ObjectFour.CompanyTwo.Areas, ObjectSix);
            equal(ResultCompare3, true, 'okay');

            var ReturnCompanyTwoAreas   = Core.JSON.Stringify(ObjectFour.CompanyTwo.Areas);
            equal(ReturnCompanyTwoAreas, StringCompanyTwo, 'okay');


            var ResultCompare4 = Core.Data.CompareObject(ObjectFour.CompanyTwo, ObjectFour.CompanyThree);
            notEqual(ResultCompare4, true, 'okay');

            var ReturnFour      = Core.JSON.Stringify(ObjectFour);
            var ObjectFourParse = Core.JSON.Parse(ReturnFour);
            var ResultCompare5  = Core.Data.CompareObject(ObjectFourParse, ObjectFour);
            equal(ResultCompare5, true, 'okay');


            /* Round 4*/
            var ObjectSeven          = {};
            ObjectSeven.one      = ObjectFour;
            ObjectSeven.two      = ObjectFourParse;
            ObjectSeven.three    = ObjectFive;
            ObjectSeven.four     = ObjectSix;
            var ReturnSeven      = Core.JSON.Stringify(ObjectSeven);
            var ObjectSevenParse = Core.JSON.Parse(ReturnSeven);
            var ResultCompare6   = Core.Data.CompareObject(ObjectSeven, ObjectSevenParse);
            equal(ResultCompare6, true, 'okay');

            ObjectSeven.five     = ObjectTwo;
            var ResultCompare7   = Core.Data.CompareObject(ObjectSevenParse, ObjectSeven);
            notEqual(ResultCompare7, true, 'okay');

        });
    };

    return Namespace;
}(Core.JSON || {}));
