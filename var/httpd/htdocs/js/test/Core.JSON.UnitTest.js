// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var Core = Core || {};

Core.JSON = (function (Namespace) {
    Namespace.RunUnitTests = function(){
        QUnit.module('Core.JSON');
        QUnit.test('Core.JSON.Parse()', function(Assert){

            var ValueTwo, StringOne, ObjectOne, ObjectTwo, ObjectThree, ObjectFour, ObjectFive, ObjectSix, ObjectSeven,
                ReturnOne, ReturnTwo, ReturnThree, ReturnFour, ReturnSeven, StringCompanyTwo, ReturnCompanyTwo,
                ResultCompare1, ResultCompare2, ResultCompare3, ResultCompare4, ResultCompare5, ResultCompare6, ResultCompare7,
                ReturnDiferent, ReturnCompanyTwoAreas, ObjectFourParse, ObjectSevenParse;

            /*
             * Run the tests
             */
            ValueTwo = "abcd";
            StringOne = '{"ItemOne":1234,"ItemTwo":"' + ValueTwo + '","ItemThree":true,"ItemFour":false}';
            ObjectOne = Core.JSON.Parse(StringOne);
            ReturnOne = Core.JSON.Stringify(ObjectOne);

            Assert.expect(20);

            Assert.equal(StringOne, ReturnOne, 'okay');
            Assert.equal(ObjectOne.ItemOne, '1234', 'okay');
            Assert.equal(ObjectOne.ItemTwo, ValueTwo, 'okay');


            /* Round 2*/
            ObjectTwo =
            { "Consulting": [
                                { "Address": "535 Joseph Roberts Av.",
                                  "Employees": 12,
                                  "LastUpdate": '06/12/2010' }
                              ],
              "Sales": [
                                { "Address": "789 Second St.",
                                  "Employees": 8,
                                  "LastUpdate": '06/12/2010' }
                              ]
            };
            ReturnTwo = Core.JSON.Stringify(ObjectTwo);
            ObjectThree = Core.JSON.Parse(ReturnTwo);
            ReturnThree = Core.JSON.Stringify(ObjectThree);

            Assert.equal(ObjectTwo.Consulting[0].Address, ObjectThree.Consulting[0].Address, 'okay');
            Assert.equal(ObjectTwo.Sales[0].LastUpdate, ObjectThree.Sales[0].LastUpdate, 'okay');
            Assert.equal(ReturnTwo, ReturnThree, 'okay');
            ResultCompare1 = Core.Data.CompareObject(ObjectTwo, ObjectThree);
            Assert.equal(ResultCompare1, true, 'okay');

            // Delete a element and compare
            ObjectTwo.Sales[0].LastUpdate = '10/12/2010';
            ResultCompare2 = Core.Data.CompareObject(ObjectTwo, ObjectThree);
            Assert.notEqual(ResultCompare2, true, 'okay');

            ReturnDiferent = Core.JSON.Stringify(ObjectTwo);
            Assert.notEqual(ReturnTwo, ReturnDiferent, 'okay');


            /* Round 3*/
            ObjectFour =
            {
                "CompanyOne":
                    [{ "Areas":
                        [{ "Marketing":
                            [{ "Address": "23 Albert Einstein St.",
                               "Employees": 7,
                               "LastUpdate": '10/03/2008'
                            }],
                           "Sales":
                            [{ "Address": "1555 London St.",
                               "Employees": 30,
                               "LastUpdate": '20/10/2009'
                            }]
                        }]
                    }]
             };

            ObjectFive = {};
            StringCompanyTwo =
                '{"Design":[{"Address":"777 Beach Av.","Employees":20,"LastUpdate":"25/02/2010"}],' +
                 '"Development":[{"Address":"1 Sunset St.","Employees":300,"LastUpdate":"24/06/2010"}]}';
            ObjectSix = Core.JSON.Parse(StringCompanyTwo);
            ObjectFive.Areas = ObjectSix;

            ObjectFour.CompanyTwo = ObjectFive;
            ObjectFour.CompanyThree = {};
            ObjectFour.CompanyThree.Areas = ObjectTwo;

            ReturnCompanyTwo = Core.JSON.Stringify(ObjectFive.Areas);
            Assert.equal(StringCompanyTwo, ReturnCompanyTwo, 'okay');
            ResultCompare3 = Core.Data.CompareObject(ObjectFour.CompanyTwo.Areas, ObjectSix);
            Assert.equal(ResultCompare3, true, 'okay');

            ReturnCompanyTwoAreas = Core.JSON.Stringify(ObjectFour.CompanyTwo.Areas);
            Assert.equal(ReturnCompanyTwoAreas, StringCompanyTwo, 'okay');


            ResultCompare4 = Core.Data.CompareObject(ObjectFour.CompanyTwo, ObjectFour.CompanyThree);
            Assert.notEqual(ResultCompare4, true, 'okay');

            ReturnFour = Core.JSON.Stringify(ObjectFour);
            ObjectFourParse = Core.JSON.Parse(ReturnFour);
            ResultCompare5 = Core.Data.CompareObject(ObjectFourParse, ObjectFour);
            Assert.equal(ResultCompare5, true, 'okay');


            /* Round 4*/
            ObjectSeven = {};
            ObjectSeven.one = ObjectFour;
            ObjectSeven.two = ObjectFourParse;
            ObjectSeven.three = ObjectFive;
            ObjectSeven.four = ObjectSix;
            ReturnSeven = Core.JSON.Stringify(ObjectSeven);
            ObjectSevenParse = Core.JSON.Parse(ReturnSeven);
            ResultCompare6 = Core.Data.CompareObject(ObjectSeven, ObjectSevenParse);
            Assert.equal(ResultCompare6, true, 'okay');

            ObjectSeven.five = ObjectTwo;
            ResultCompare7 = Core.Data.CompareObject(ObjectSevenParse, ObjectSeven);
            Assert.notEqual(ResultCompare7, true, 'okay');

            /* Round 5*/
            // test undefined value
            Assert.deepEqual(Core.JSON.Parse(undefined), {}, 'undefined is parsed to an empty object');
            // test parsing of non-strings
            Assert.deepEqual(Core.JSON.Parse({Key: 'Value'}), {Key: 'Value'}, 'objects are not parsed and returned unchanged');
            Assert.equal(Core.JSON.Parse(42), 42, 'numbers are not parsed and returned unchanged');
            // test string but not JSON
            Assert.deepEqual(Core.JSON.Parse('Live long and prosper!'), {}, 'Non-JSON strings are ignored and converted to an empty object');

        });
    };

    return Namespace;
}(Core.JSON || {}));
