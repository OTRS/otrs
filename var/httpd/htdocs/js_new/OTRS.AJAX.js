// --
// OTRS.AJAX.js - provides the funcionality for AJAX calls
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.AJAX.js,v 1.7 2010-06-02 08:40:02 mn Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};

/**
 * @namespace
 * @exports TargetNS as OTRS.AJAX
 * @description
 *      This namespace contains the functionality for AJAX calls.
 */
OTRS.AJAX = (function (TargetNS) {
    var AJAXLoaderPrefix = 'AJAXLoader',
        ActiveAJAXCalls = {};

    /**
     * @function
     * @private
     * @param {string} FieldID Id of the field which is updated via ajax
     * @description Shows and hides an ajax loader for every element which is updates via ajax
     */
    function ToggleAJAXLoader(FieldID) {
        var $Element = $('#' + FieldID),
            $Loader = $('#' + AJAXLoaderPrefix + FieldID),
            LoaderHTML = '<span id="' + AJAXLoaderPrefix + FieldID + '" class="AJAXLoader"></span>';

        if (!$Loader.length) {
            if ($Element.length) {
                $Element.append(LoaderHTML);
                if (typeof ActiveAJAXCalls[FieldID] === 'undefined') {
                    ActiveAJAXCalls[FieldID] = 0;
                }
                ActiveAJAXCalls[FieldID]++;
            }
        }
        else if ($Loader.is(':hidden')) {
            $Loader.show();
            if (typeof ActiveAJAXCalls[FieldID] === 'undefined') {
                ActiveAJAXCalls[FieldID] = 0;
            }
            ActiveAJAXCalls[FieldID]++;
        }
        else {
            ActiveAJAXCalls[FieldID]--;
            if (ActiveAJAXCalls[FieldID] <= 0) {
                $Loader.hide();
                ActiveAJAXCalls[FieldID] = 0;
            }
        }
    }

    /**
     * @function
     * @private
     * @param {Object} Data The data that should be converted
     * @return {string} query string of the data
     * @description Converts a given hash into a query string
     */
    function SerializeData(Data) {
        var QueryString = "";
        $.each(Data, function (Key, Value) {
            QueryString += Key + '=' + encodeURIComponent(Value) + ";";
        });
        return QueryString;
    }

    /**
     * @function
     * @private
     * @return {Object} Hash with session data, if needed
     * @description Collects session data in a hash if available
     */
    function GetSessionInformation() {
        var Data = {};
        if (!OTRS.Config.Get('SessionIDCookie')) {
            Data[OTRS.Config.Get('SessionName')] = OTRS.Config.Get('SessionID');
            Data[OTRS.Config.Get('CustomerPanelSessionName')] = OTRS.Config.Get('SessionID');
        }
        return Data;
    }

    /**
     * @function
     * @private
     * @return {Object} Hash with additional session and action data
     * @description Collects additional data that are needed for the ajax requests
     */
    function GetAdditionalDefaultData() {
        var Data = {};
        Data = GetSessionInformation();
        Data.Action = OTRS.Config.Get('Action');
        return Data;
    }

    /**
     * @function
     * @private
     * @param {Object} Data The new field data
     * @param {Object} FieldsToUpdate The array of field elements
     * @return nothing
     * @description Updates the given fields with the given data
     */
    function UpdateFormElements(Data, FieldsToUpdate) {
        $.each(FieldsToUpdate, function (Index, Value) {
            var $Element = $('#' + Value),
                ElementData;
            if ($Element.length && Data) {
                // Select elements
                if ($Element.is('select')) {
                    $Element.empty();
                    ElementData = Data[Value];
                    if (ElementData) {
                        $.each(ElementData, function (Index, Value) {
                            // Workaround: Overwrite Value again because of wrong HTML encoding... (needed?)
                            $Element.append(new Option(Value[1], Value[0], Value[2], Value[3])).html(Value[1]);
                        });
                    }
                }
                // Other form elements
                else {
                    if (Data[Value]) {
                        $Element.val(Value);
                    }
                }
            }
        });
    }

    /**
     * @function
     *      Serializes the form data into a query string
     * @param {jQueryObject} $Element The jQuery object of the form  or any element within this form that should be serialized
     * @return {string} The query string
     */
    TargetNS.SerializeForm = function ($Element) {
        var QueryString = "";
        if (isJQueryObject($Element) && $Element.length) {
            $Element = $Element.closest('form');
            $Element.find('input:not(:file), textarea, select').filter(':not([disabled=disabled])').each(function () {
                QueryString += $(this).attr('name') + '=' + encodeURIComponent($(this).val()) + ";";
            });
        }
        return QueryString;
    };

    /**
     * @function
     *      Submits a special form via ajax and updates the form with the data returned from the server
     * @param {jQueryObject} $EventElement The jQuery object of the element(s) which are included in the form that should be submitted
     * @param {String} Subaction The subaction parameter for the perl module
     * @param {String} ChangedElement The name of the element which was changed by the user
     * @param {Object} FieldsToUpdate The names of the fields that should be updated with the server answer
     * @return nothing
     */
    TargetNS.FormUpdate = function ($EventElement, Subaction, ChangedElement, FieldsToUpdate) {
        var URL = OTRS.Config.Get('Baselink'),
            QueryString = TargetNS.SerializeForm($EventElement),
            Data = GetAdditionalDefaultData();

        Data.Subaction = Subaction;
        Data.ElementChanged = ChangedElement;
        QueryString += SerializeData(Data);

        $.each(FieldsToUpdate, function (Index, Value) {
            ToggleAJAXLoader(Value);
        });

        $.ajax({
            url: URL,
            data: QueryString,
            dataType: 'json',
            success: function (Response) {
                if (!Response) {
                    OTRS.Exception.Throw("Invalid JSON from: " + URL, 'CommunicationError');
                }
                else {
                    UpdateFormElements(Response, FieldsToUpdate);
                }
            },
            complete: function () {
                $.each(FieldsToUpdate, function (Index, Value) {
                    ToggleAJAXLoader(Value);
                });
            },
            error: function () {
                OTRS.Exception.Throw("Error during AJAX communication", 'CommunicationError');
            }
        });

        return false;
    };

    /**
     * @function
     *      Binds an event on the form element to call the FormUpdate on event trigger
     * @param {jQueryObject} $EventElement The jQuery object of the element(s) which are included in the form that should be submitted
     * @param {String} Subaction The subaction parameter for the perl module
     * @param {String} ChangedElement The name of the element which was changed by the user
     * @param {Object} FieldsToUpdate The names of the fields that should be updated with the server answer
     * @return nothing
     */
    TargetNS.RegisterFormUpdate = function (EventType, $EventElement, Subaction, ChangedElement, FieldsToUpdate) {
        if ($EventElement.length) {
            $EventElement.bind(EventType, function () {
                TargetNS.AJAXFormUpdate($EventElement, Subaction, ChangedElement, FieldsToUpdate);
            });
        }
    };

    /**
     * @function
     *      Calls an URL via Ajax and updates a html element with the answer html of the server
     * @param {jQueryObject} $ElementToUpdate The jQuery object of the element(s) which should be updated
     * @param {String} URL The URL which is called via Ajax
     * @param {Function} Callback The additional callback function which is called after the request returned from the server
     * @return nothing
     */
    TargetNS.ContentUpdate = function ($ElementToUpdate, URL, Callback) {
        var QueryString, QueryIndex = URL.indexOf("?");

        if (QueryIndex >= 0) {
            QueryString = URL.substr(QueryIndex + 1);
            URL = URL.substr(0, QueryIndex);
        }
        QueryString += SerializeData(GetSessionInformation());

        $.ajax({
            url: URL,
            data: QueryString,
            dataType: 'html',
            success: function (Response) {
                if (!Response) {
                    OTRS.Exception.Throw("No content from: " + URL, 'CommunicationError');
                }
                else if ($ElementToUpdate && isJQueryObject($ElementToUpdate) && $ElementToUpdate.length) {
                    $ElementToUpdate.html(Response);
                }
                else {
                    OTRS.Exception.Throw("No such element id: " + $ElementToUpdate.attr('id') + " in page!", 'CommunicationError');
                }
            },
            complete: function () {
                if ($.isFunction(Callback)) {
                    Callback();
                }
            },
            error: function () {
                OTRS.Exception.Throw("Error during AJAX communication", 'CommunicationError');
            }
        });

        return false;
    };

    /**
     * @function
     *      Binds an event on a given element to call The ContentUpdate on event trigger
     * @param {String} EventType The type of event for which the listener is defined ('click', 'change', ...)
     * @param {jQueryObject} $EventElement The jQuery object of the element(s) on which the event listener is defined
     * @param {jQueryObject} $ElementToUpdate The jQuery object of the element(s) which should be updated
     * @param {String} URL The URL which is called via Ajax
     * @param {Function} Callback The additional callback function which is called after the request returned from the server
     * @return nothing
     */
    TargetNS.RegisterContentUpdate = function (EventType, $EventElement, $ElementToUpdate, URL, Callback) {
        if ($EventElement.length) {
            $EventElement.bind(EventType, function () {
                TargetNS.AJAXContentUpdate($ElementToUpdate, URL, Callback);
            });
        }
    };


    /**
     * @function
     *      Calls an URL via Ajax and executes a given function after the request returned from the server
     * @param {String} URL The URL which is called via Ajax
     * @param {Object} Data The data hash
     * @param {Function} Callback The callback function which is called after the request returned from the server
     * @return nothing
     */
    TargetNS.FunctionCall = function (URL, Data, Callback) {
        Data = $.extend(Data, GetSessionInformation());
        $.ajax({
            type: 'POST',
            url: URL,
            data: Data,
            dataType: 'json',
            success: function (Response) {
                if (!Response) {
                    OTRS.Exception.Throw("No content from: " + URL, 'CommunicationError');
                }
                // call the callback
                if ($.isFunction(Callback)) {
                    Callback(Response);
                }
                else {
                    OTRS.Exception.Throw("Invalid callback method: " + Callback.toString(), 'CommunicationError');
                }
            },
            error: function () {
                OTRS.Exception.Throw("Error during AJAX communication", 'CommunicationError');
            }
        });
    };

    /**
     * @function
     *      Binds an event on a given element to call the FunctionCall ajax function on event trigger
     * @param {String} EventType The type of event for which the listener is defined ('click', 'change', ...)
     * @param {jQueryObject} $EventElement The jQuery object of the element(s) on which the event listener is defined
     * @param {String} URL The URL which is called via Ajax
     * @param {Object} Data The data hash
     * @param {Function} Callback The callback function which is called after the request returned from the server
     * @return nothing
     */
    TargetNS.RegisterFunctionCall = function (EventType, $EventElement, URL, Data, Callback) {
        if ($EventElement.length) {
            $EventElement.bind(EventType, function () {
                TargetNS.AJAXFunctionCall(URL, Data, Callback);
            });
        }
    };

    return TargetNS;
}(OTRS.AJAX || {}));