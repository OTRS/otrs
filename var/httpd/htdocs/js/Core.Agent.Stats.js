// --
// Core.Agent.Stats.js - provides the special module functions for AgentStats
// Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};

/**
 * @namespace
 * @exports TargetNS as Core.Agent.Stats
 * @description
 *      This namespace contains the special module functions for the Dashboard.
 */
Core.Agent.Stats = (function (TargetNS) {

    /**
     * @function
     * @return nothing
     * @description
     *      Activates the graph size menu if a GD element is selected.
     */
    TargetNS.FormatGraphSizeRelation = function () {
        var $Format = $('#Format'),
            Flag = false,
            Reg = /^GD::/;

        // find out if a GD element is used
        $.each($Format.children('option:selected'), function () {
            if (Reg.test($(this).val()) === true) {
                Flag = true;
            }
        });

        // activate or deactivate the Graphsize menu
        if (Flag) {
            $('#GraphSize').removeAttr('disabled');
        }
        else {
            $('#GraphSize').attr('disabled', 'disabled');
        }
    };

    /**
     * @function
     * @return nothing
     *      Selects a checbox by name
     * @param {Object} The name of the radio button to be selected
     */
    TargetNS.SelectCheckbox = function (Name) {
        $('input:checkbox[name=' + Name + ']').prop('checked', true);
    };

    /**
     * @function
     * @return nothing
     *      Selects a radio button by name and value
     * @param {Value} The value attribute of the radio button to be selected
     * @param {Object} The name of the radio button to be selected
     */

    TargetNS.SelectRadiobutton = function (Value, Name) {
        $('input:radio[name=' + Name + '][value=' + Value + ']').prop('checked', true);
    };

    return TargetNS;
}(Core.Agent.Stats || {}));
