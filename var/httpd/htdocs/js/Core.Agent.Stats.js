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
        $('input[type="checkbox"][name=' + Name + ']').prop('checked', true);
    };

    /**
     * @function
     * @return nothing
     *      Selects a radio button by name and value
     * @param {Value} The value attribute of the radio button to be selected
     * @param {Object} The name of the radio button to be selected
     */

    TargetNS.SelectRadiobutton = function (Value, Name) {
        $('input[type="radio"][name=' + Name + '][value=' + Value + ']').prop('checked', true);
    };

    /**
     * @function
     * @return nothing
     * @description Inits stats restriction editing.
     */

    TargetNS.InitRestrictionEditing = function () {
        $('form[name="compose"] button[type="submit"]').on( 'click', function () {
            CheckSearchStringsForStopWords( function () {
                $('form[name="compose"]:first').submit();
            });

           return false;
        });
    };

    /**
     * @function
     * @private
     * @param {Function} Callback function to execute, if no stop words were found.
     * @return nothing
     * @description Checks if specific values of the search form contain stop words.
     *              If stop words are present, a warning will be displayed.
     *              If stop words are not present, the given callback will be executed.
     */
    function CheckSearchStringsForStopWords(Callback) {
        var SearchStrings = [],
            SearchStringsFound = 0,
            RelevantElementNames = [
                'From',
                'To',
                'Cc',
                'Subject',
                'Body'
            ],
            StopWordCheckData;

        $.each( RelevantElementNames, function (Index, ElementName) {
            var $Element = $('form[name="compose"] input[name="' + ElementName + '"]');

            if ($Element.length) {
                if ( $Element.val() && $Element.val() !== '' ) {
                    SearchStrings.push($Element.val());
                    SearchStringsFound = 1;
                }
            }
        });

        // Check if stop words are present.
        if (!SearchStringsFound) {
            Callback();
            return;
        }

        StopWordCheckData = {
            Action: 'AgentStats',
            Subaction: 'AJAXStopWordCheck',
            SearchStrings: SearchStrings
        };

        Core.AJAX.FunctionCall(
            Core.Config.Get('CGIHandle'),
            StopWordCheckData,
            function (Result) {
                if ( Result.FoundStopWords.length ) {
                    alert(Core.Config.Get('SearchStringsContainStopWordsMsg') + ' ' + Result.FoundStopWords);
                }
                else {
                    Callback();
                }
            }
        );
    }

    return TargetNS;
}(Core.Agent.Stats || {}));
