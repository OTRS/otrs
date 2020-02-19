// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};

Core.Agent.AppointmentCalendar = (function (Namespace) {
    Namespace.RunUnitTests = function(){

        QUnit.module('Core.Agent.AppointmentCalendar');

        QUnit.test('CollapseValues in AppointmentCalendar Edit', function(Assert){

            var ExpectedTeamValues = 'T1<br>T2<br><a href="#" class="DialogTooltipLink">' + Core.Language.Translate('+%s more', 5) + '</a>',
            ExpectedResourceValues = 'A1<br>A2<br><a href="#" class="DialogTooltipLink">'
            + Core.Language.Translate('+%s more', 3) + '</a>';

            $('<fieldset class="TableLike">' +
            '<legend><span>Resource</span></legend>' +
            '<label for="TeamID">Team:</label>'+
            '<div class="Field">'+

               ' <p id="TeamID" class="ReadOnlyValue">T1<br>T2<br>T3<br>T4<br>T5<br>T6<br></p>'+
            '</div>'+
            '<div class="Clear"></div>'+
            '<label for="ResourceID">Agent:</label>'+
           ' <div class="Field">'+
                '<p id="ResourceID" class="ReadOnlyValue">A1<br>A2<br>A3<br>A4<br></p>'+
            '</div>'+
       ' </fieldset>').appendTo('body');



            Assert.expect(2);

            Core.Agent.AppointmentCalendar.TeamInit($('#TeamID'), $('#ResourceID'), $('label[for="TeamID"] + div.Field p.ReadOnlyValue'), $('label[for="ResourceID"] + div.Field p.ReadOnlyValue'));

            Assert.deepEqual($('#TeamID').html(), ExpectedTeamValues, 'CollapseTeamValues');
            Assert.deepEqual($('#ResourceID').html(), ExpectedResourceValues, 'CollapseResourceValues');


        });
    };

    return Namespace;
}(Core.Agent.AppointmentCalendar || {}));
