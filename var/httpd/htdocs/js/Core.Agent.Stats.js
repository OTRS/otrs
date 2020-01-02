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

/**
 * @namespace Core.Agent.Stats
 * @memberof Core.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the statistic module.
 */
Core.Agent.Stats = (function (TargetNS) {

    /**
     * @name FormatGraphSizeRelation
     * @memberof Core.Agent.Stats
     * @function
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
     * @name SelectCheckbox
     * @memberof Core.Agent.Stats
     * @function
     * @param {String} Name - The name of the radio button to be selected.
     * @description
     *      Activate given checkbox.
     */
    TargetNS.SelectCheckbox = function (Name) {
        $('input[type="checkbox"][name=' + Name + ']').prop('checked', true);
    };

    /**
     * @name SelectRadiobutton
     * @memberof Core.Agent.Stats
     * @function
     * @param {String} Value - The value attribute of the radio button to be selected.
     * @param {String} Name - The name of the radio button to be selected.
     * @description
     *      Selects a radio button by name and value.
     */
    TargetNS.SelectRadiobutton = function (Value, Name) {
        $('input[type="radio"][name=' + Name + '][value=' + Value + ']').prop('checked', true);
    };

    return TargetNS;
}(Core.Agent.Stats || {}));
