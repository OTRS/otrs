// --
// Core.Customer.Search.js - provides search functionality for customer frontend
// Copyright (C) 2001-2013 OTRS AG, http://otrs.org/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.Customer = Core.Customer || {};

/**
 * @namespace
 * @exports TargetNS as Core.Customer.Search
 * @description
 *      This namespace contains the search functionality for customer frontend.
 */
Core.Customer.Search = (function (TargetNS) {

    /**
     * @function
     * @return nothing
     *      This function initializes the application and executes the needed functions
     */
    TargetNS.Init = function () {

        // register submit of search
        $('#Submit').bind('click', function () {

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
            RelevantElementIDs = [
                'From',
                'To',
                'Cc',
                'Subject',
                'Body'
            ],
            StopWordCheckData;

        $.each( RelevantElementIDs, function (Index, ElementID) {
            var $Element = $('#' + ElementID);

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
            Action: 'CustomerTicketSearch',
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
}(Core.Customer.Search || {}));
