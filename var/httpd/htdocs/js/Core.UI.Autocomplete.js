// --
// Core.UI.Autocomplete.js - Autocomplete functions
// Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.UI = Core.UI || {};

/**
 * @namespace
 * @exports TargetNS as Core.UI.Autocomplete
 * @description
 *      This namespace contains autocomplete specific functions.
 */
Core.UI.Autocomplete = (function (TargetNS) {
    var ConfigFallback = {
            AutoCompleteActive: 1,
            MinQueryLength: 2,
            QueryDelay: 100,
            MaxResultsDisplayed: 20
        },
        ConfigElements = ['AutoCompleteActive', 'MinQueryLength', 'QueryDelay', 'MaxResultsDisplayed', 'ButtonText'],
        Config = {};

    function InitConfig(Type, Options) {
        var TypeConfig = Core.Config.Get('Autocomplete');

        $.each(ConfigElements, function (ConfigKey, ConfigElement) {
            // Option, Type, Fallback
            if (Options && typeof Options[ConfigElement] !== 'undefined') {
                Config[ConfigElement] = Options[ConfigElement];
            }
            else if (Type && TypeConfig[Type]) {
                Config[ConfigElement] = TypeConfig[Type][ConfigElement];
            }
            else {
                Config[ConfigElement] = ConfigFallback[ConfigElement];
            }
        });

        // if button should be shown, set minlength to an unreachable value
        if (!Config.AutoCompleteActive) {
            Config.MinQueryLength = 500;
        }

        return Config;
    }

    TargetNS.GetConfig = function(Key) {
        return Config[Key];
    };

    /**
     * @function
     * @description
     *      This function initializes autocomplete on an input element.
     * @param {jQueryObject} $Element which gets autocomplete infos.
     * @param {Function} SourceFunction defines the source data for the autocomplete
     *              Two params: Request and Response
     *                      Request: the data provided by the autocomplete (e.g. the entered text)
     *                      Response: the function defined by the autocomplete to call with the selected data
     * @param {Function} SelectFunction is executed, if an entry is selected
     *              Two params: Event and UI
     *                      Event: the original browser event object
     *                      UI: the data given from the UI (e.g. UI.item is the selected autocomplete list item)
     * @param {String} Type of autocompletion, e.g. "CustomerSearch" etc.
     * @param {Object} Options object data with autocomplete plugin options
     * @return nothing
     */
    TargetNS.Init = function ($Element, SourceFunction, SelectFunction, Type, Options) {
        var Config;

        // Only start autocompletion, if $Element is valid element
        if (!isJQueryObject($Element) || !$Element.length) {
            return;
        }

        Config = InitConfig(Type, Options);

        $Element.autocomplete({
            minLength: Config.MinQueryLength,
            delay: Config.QueryDelay,
            open: function() {
                // force a higher z-index than the overlay/dialog
                $Element.autocomplete('widget').addClass('ui-overlay-autocomplete');
                return false;
            },
            source: function (Request, Response) {
                // if an old ajax request is already running, stop the old request and start the new one
                if ($Element.data('AutoCompleteXHR')) {
                    $Element.data('AutoCompleteXHR').abort();
                    $Element.removeData('AutoCompleteXHR');
                    // run the response function to hide the request animation
                    Response({});
                }

                if (SourceFunction) {
                    SourceFunction(Request, Response);
                }

                /*
                 * Your SourceFunction must return an array of the data you collected.
                 * Every array element is an object with the following keys:
                 * label: the string displayed in the suggestion menu
                 * value: the string to be inserted in the input field
                 * You can add more keys, if you want to transport data to the select function
                 * all keys will be available there via the UI.item object.
                 *
                 * If you use an ajax function inside your source, make sure to
                 * save the XHRObject in a data-value, to control the xhr automatically:
                 * $Element.data('AutoCompleteXHR', YourCallHere());
                 * This makes sure, that we can abort old ajax request, if new searches are triggered.
                 *
                 * The input value can be found in Request.term. Don't forget to send the MaxResult config
                 * to the server in your ajax request.
                 */
            },
            select: function (Event, UI) {
                if (SelectFunction) {
                    SelectFunction(Event, UI);
                }

                Event.preventDefault();
                return false;
            }
        });

        if (!Config.AutoCompleteActive) {
            $Element.after('<button id="' + Core.App.EscapeSelector($Element.attr('id')) + 'Search" type="button">' + Config.ButtonText + '</button>');
            $('#' + Core.App.EscapeSelector($Element.attr('id')) + 'Search').click(function () {
                $Element.autocomplete("option", "minLength", 0);
                $Element.autocomplete("search");
                $Element.autocomplete("option", "minLength", 500);
            });
        }
    };

    return TargetNS;
}(Core.UI.Autocomplete || {}));
