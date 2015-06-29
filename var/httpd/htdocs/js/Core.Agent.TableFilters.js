// --
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
 * @namespace Core.Agent.TableFilters
 * @memberof Core.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the table filters.
 */
Core.Agent.TableFilters = (function (TargetNS) {

    /*
     * check dependencies first
     */
    if (!Core.Debug.CheckDependency('Core.Agent.TableFilters', 'Core.UI.AllocationList', 'Core.UI.AllocationList')) {
        return false;
    }

    /**
     * @name InitCustomerIDAutocomplete
     * @memberof Core.Agent.TableFilters
     * @function
     * @param {jQueryObject} $Input - Input element to add auto complete to.
     * @description
     *      Initialize autocompletion for CustomerID.
     */
    TargetNS.InitCustomerIDAutocomplete = function ($Input) {
        $Input.autocomplete({
            minLength: Core.Config.Get('CustomerAutocomplete.MinQueryLength'),
            delay: Core.Config.Get('CustomerAutocomplete.QueryDelay'),
            open: function() {
                // force a higher z-index than the overlay/dialog
                $(this).autocomplete('widget').addClass('ui-overlay-autocomplete');
                return false;
            },
            source: function (Request, Response) {
                var URL = Core.Config.Get('Baselink'), Data = {
                    Action: 'AgentCustomerInformationCenterSearch',
                    Subaction: 'SearchCustomerID',
                    Term: Request.term,
                    MaxResults: Core.Config.Get('CustomerAutocomplete.MaxResultsDisplayed')
                };

                // if an old ajax request is already running, stop the old request and start the new one
                if ($Input.data('AutoCompleteXHR')) {
                    $Input.data('AutoCompleteXHR').abort();
                    $Input.removeData('AutoCompleteXHR');
                    // run the response function to hide the request animation
                    Response({});
                }

                $Input.data('AutoCompleteXHR', Core.AJAX.FunctionCall(URL, Data, function (Result) {
                    var ValueData = [];
                    $Input.removeData('AutoCompleteXHR');
                    $.each(Result, function () {
                        ValueData.push({
                            label: this.Label + ' (' + this.Value + ')',
                            value: this.Value
                        });
                    });
                    Response(ValueData);
                }));
            },
            select: function (Event, UI) {
                $(Event.target)
                    .parent()
                    .find('select')
                    .append('<option value="' + UI.item.value + '">SelectedItem</option>')
                    .val(UI.item.value)
                    .trigger('change');
            }
        });
    };

    /**
     * @name InitCustomerUserAutocomplete
     * @memberof Core.Agent.TableFilters
     * @function
     * @param {jQueryObject} $Input - Input element to add auto complete to.
     * @description
     *      Initialize autocompletion for Customer User.
     */
    TargetNS.InitCustomerUserAutocomplete = function ($Input) {
        $Input.autocomplete({
            minLength: Core.Config.Get('CustomerUserAutocomplete.MinQueryLength'),
            delay: Core.Config.Get('CustomerUserAutocomplete.QueryDelay'),
            open: function() {
                // force a higher z-index than the overlay/dialog
                $(this).autocomplete('widget').addClass('ui-overlay-autocomplete');
                return false;
            },
            source: function (Request, Response) {
                var URL = Core.Config.Get('Baselink'), Data = {
                    Action: 'AgentCustomerSearch',
                    Term: Request.term,
                    MaxResults: Core.Config.Get('CustomerUserAutocomplete.MaxResultsDisplayed')
                };

                // if an old ajax request is already running, stop the old request and start the new one
                if ($Input.data('AutoCompleteXHR')) {
                    $Input.data('AutoCompleteXHR').abort();
                    $Input.removeData('AutoCompleteXHR');
                    // run the response function to hide the request animation
                    Response({});
                }

                $Input.data('AutoCompleteXHR', Core.AJAX.FunctionCall(URL, Data, function (Result) {
                    var ValueData = [];
                    $Input.removeData('AutoCompleteXHR');
                    $.each(Result, function () {
                        ValueData.push({
                            label: this.CustomerValue + " (" + this.CustomerKey + ")",
                            value: this.CustomerValue,
                            key: this.CustomerKey
                        });
                    });
                    Response(ValueData);
                }));
            },
            select: function (Event, UI) {
                $(Event.target)
                    .parent()
                    .find('select')
                    .append('<option value="' + UI.item.key + '">SelectedItem</option>')
                    .val(UI.item.key)
                    .trigger('change');
            }
        });
    };

    /**
     * @name InitUserAutocomplete
     * @memberof Core.Agent.TableFilters
     * @function
     * @param {jQueryObject} $Input - Input element to add auto complete to.
     * @param {String} Subaction  - Subaction to execute, "SearchCustomerID" or "SearchCustomerUser"
     * @description
     *      Initialize autocompletion for User.
     */
    TargetNS.InitUserAutocomplete = function ($Input, Subaction) {
        $Input.autocomplete({
            minLength: Core.Config.Get('UserAutocomplete.MinQueryLength'),
            delay: Core.Config.Get('UserAutocomplete.QueryDelay'),
            open: function() {
                // force a higher z-index than the overlay/dialog
                $(this).autocomplete('widget').addClass('ui-overlay-autocomplete');
                return false;
            },
            source: function (Request, Response) {
                var URL = Core.Config.Get('Baselink'), Data = {
                    Action: 'AgentUserSearch',
                    Subaction: Subaction,
                    Term: Request.term,
                    MaxResults: Core.Config.Get('UserAutocomplete.MaxResultsDisplayed')
                };

                // if an old ajax request is already running, stop the old request and start the new one
                if ($Input.data('AutoCompleteXHR')) {
                    $Input.data('AutoCompleteXHR').abort();
                    $Input.removeData('AutoCompleteXHR');
                    // run the response function to hide the request animation
                    Response({});
                }

                $Input.data('AutoCompleteXHR', Core.AJAX.FunctionCall(URL, Data, function (Result) {
                    var ValueData = [];
                    $Input.removeData('AutoCompleteXHR');
                    $.each(Result, function () {
                        ValueData.push({
                            label: this.UserValue + " (" + this.UserKey + ")",
                            value: this.UserValue,
                            key: this.UserKey
                        });
                    });
                    Response(ValueData);
                }));
            },
            select: function (Event, UI) {
                $(Event.target)
                    .parent()
                    .find('select')
                    .append('<option value="' + UI.item.key + '">SelectedItem</option>')
                    .val(UI.item.key)
                    .trigger('change');
            }
        });
    };

    /**
     * @name Init
     * @memberof Core.Agent.TableFilters
     * @function
     * @description
     *      This function initializes the special module functions.
     */
    TargetNS.Init = function () {
            // Initiate allocation list
            TargetNS.SetAllocationList();
    };


    /**
     * @private
     * @name UpdateAllocationList
     * @memberof Core.Agent.TableFilters
     * @function
     * @param {Object} Event
     * @param {Object} UI - jQuery UI object
     * @description
     *      Update allocation list entries.
     */
    function UpdateAllocationList(Event, UI) {

        var $ContainerObj = $(UI.sender).closest('.AllocationListContainer'),
            Data = {},
            FieldName;

        if (Event.type === 'sortstop') {
            $ContainerObj = $(UI.item).closest('.AllocationListContainer');
        }

        Data.Columns = {};
        Data.Order = [];

        $ContainerObj.find('.AvailableFields').find('li').each(function() {
            FieldName = $(this).attr('data-fieldname');
            Data.Columns[FieldName] = 0;
        });

        $ContainerObj.find('.AssignedFields').find('li').each(function() {
            FieldName = $(this).attr('data-fieldname');
            Data.Columns[FieldName] = 1;
            Data.Order.push(FieldName);
        });
        $ContainerObj.closest('form').find('.ColumnsJSON').val(Core.JSON.Stringify(Data));
    }

    /**
     * @name SetAllocationList
     * @memberof Core.Agent.TableFilters
     * @function
     * @description
     *      Initialize allocation list.
     */
    TargetNS.SetAllocationList = function () {
        $('.AllocationListContainer').each(function() {

            var $ContainerObj = $(this),
                DataEnabledJSON = $ContainerObj.closest('form.WidgetSettingsForm').find('input.ColumnsEnabledJSON').val(),
                DataAvailableJSON = $ContainerObj.closest('form.WidgetSettingsForm').find('input.ColumnsAvailableJSON').val(),
                DataEnabled,
                DataAvailable,
                Translation,
                $FieldObj,
                IDString = '#' + $ContainerObj.find('.AssignedFields').attr('id') + ', #' + $ContainerObj.find('.AvailableFields').attr('id');

            if (DataEnabledJSON) {
                DataEnabled = Core.JSON.Parse(DataEnabledJSON);
            }
            if (DataAvailableJSON) {
                DataAvailable = Core.JSON.Parse(DataAvailableJSON);
            }

            $.each(DataEnabled, function(Index, Field) {

                // get field translation
                Translation = Core.Config.Get('Column' + Field) || Field;

                $FieldObj = $('<li />').attr('title', Field).attr('data-fieldname', Field).text(Translation);
                $ContainerObj.find('.AssignedFields').append($FieldObj);
            });
            $.each(DataAvailable, function(Index, Field) {

                // get field translation
                Translation = Core.Config.Get('Column' + Field) || Field;

                $FieldObj = $('<li />').attr('title', Field).attr('data-fieldname', Field).text(Translation);
                $ContainerObj.find('.AvailableFields').append($FieldObj);
            });

            Core.UI.AllocationList.Init(IDString, $ContainerObj.find('.AllocationList'), 'UpdateAllocationList', '', UpdateAllocationList);
            Core.UI.Table.InitTableFilter($ContainerObj.find('.FilterAvailableFields'), $ContainerObj.find('.AvailableFields'));
        });
    };

    /**
     * @name RegisterUpdatePreferences
     * @memberof Core.Agent.TableFilters
     * @function
     * @param {jQueryObject} $ClickedElement - The jQuery object of the element(s) that get the event listener
     * @param {String} ElementID - The ID of the element whose content should be updated with the server answer
     * @param {jQueryObject} $Form - The jQuery object of the form with the data for the server request
     * @description
     *      This function binds a click event on an html element to update the preferences of the given dahsboard widget.
     */
    TargetNS.RegisterUpdatePreferences = function ($ClickedElement, ElementID, $Form) {
        if (isJQueryObject($ClickedElement) && $ClickedElement.length) {
            $ClickedElement.click(function () {
                var URL = Core.Config.Get('Baselink') + Core.AJAX.SerializeForm($Form);
                Core.AJAX.ContentUpdate($('#' + ElementID), URL, function () {
                    Core.UI.ToggleTwoContainer($('#' + ElementID + '-setting'), $('#' + ElementID));
                });
                return false;
            });
        }
    };


    return TargetNS;
}(Core.Agent.TableFilters || {}));
