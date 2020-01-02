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
Core.Agent.Statistics = Core.Agent.Statistics || {};

/**
 * @namespace Core.Agent.Statistics.ParamsWidget
 * @memberof Core.Agent.Statistics
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the Statistics module.
 */
Core.Agent.Statistics.ParamsWidget = (function (TargetNS) {

    /**
     * @name InitViewScreen
     * @memberof Core.Agent.Statistics
     * @function
     * @description
     *      Initialize the params view screen.
     */

TargetNS.Init = function() {
        var StatsParamData = Core.Config.Get('StatsParamData');

        if (typeof StatsParamData !== 'undefined') {
            $('#' + StatsParamData.XAxisTimeScaleElementID).on('change', function() {
                var TimeScaleYAxis = StatsParamData.TimeScaleYAxis,
                $TimeScaleElement = $('#' + StatsParamData.TimeScaleElementID),
                XAxisTimeScaleValue = $(this).val();

                // reset the current time scale dropdown for the y axis
                $TimeScaleElement.empty();

                if (XAxisTimeScaleValue in TimeScaleYAxis) {
                    $.each(TimeScaleYAxis[XAxisTimeScaleValue], function (Index, Item) {
                        var TimeScaleOption = new Option(Item.Value, Item.Key);

                        // Overwrite option text, because of wrong html quoting of text content.
                        // (This is needed for IE.)
                        TimeScaleOption.innerHTML = Item.Value;
                        $TimeScaleElement.append(TimeScaleOption).val(Item.Key).trigger('redraw.InputField').trigger('change');

                    });
                }
            });
        }

        if (typeof Core.Config.Get('StatsWidgetAJAX') !== 'undefined') {
            Core.UI.InputFields.Activate();
        }

        $('.DataShowMore').on('click', function() {
            if ($(this).find('.More').is(':visible')) {
                $(this)
                    .find('.More')
                    .hide()
                    .next('.Less')
                    .show()
                    .parent()
                    .prev('.DataFull')
                    .show()
                    .prev('.DataTruncated')
                    .hide()
            }
            else {
                $(this)
                    .find('.More')
                    .show()
                    .next('.Less')
                    .hide()
                    .parent()
                    .prev('.DataFull')
                    .hide()
                    .prev('.DataTruncated')
                    .show()
            }
            return false;
        });


        $('.CustomerAutoCompleteSimple').each(function() {
            Core.Agent.CustomerSearch.InitSimple($(this));
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Statistics.ParamsWidget || {}));
