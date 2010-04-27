// --
// OTRS.AJAX.js - provides the funcionality for AJAX calls
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.AJAX.js,v 1.2 2010-04-27 06:47:37 mn Exp $
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

    function SerializeData(Data) {
        var QueryString = "";
        $.each(Data, function (Key, Value) {
            QueryString += Key + '=' + encodeURIComponent(Value) + ";";
        });
        return QueryString;
    }

    function GetSessionInformation() {
        var Data = {};
        if (!OTRS.Config.Get('SessionIDCookie')) {
            Data[OTRS.Config.Get('SessionName')] = OTRS.Config.Get('SessionID');
            Data[OTRS.Config.Get('CustomerPanelSessionName')] = OTRS.Config.Get('SessionID');
        }
        return Data;
    }

    function GetAdditionalDefaultData() {
        var Data = {};
        Data = GetSessionInformation();
        Data.Action = OTRS.Config.Get('Action');
        return Data;
    }

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

    TargetNS.SerializeForm = function ($Element) {
        var QueryString = "";
        if ($Element instanceof jQuery && $Element.length) {
            $Element = $Element.closest('form');
            $Element.find('input:not(:file), textarea, select').filter(':not([disabled=disabled])').each(function () {
                QueryString += $(this).attr('name') + '=' + encodeURIComponent($(this).val()) + ";";
            });
        }
        return QueryString;
    };

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
                    alert("ERROR: Invalid JSON from: " + URL);
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
                alert('ERROR: Something went wrong!');
            }
        });

        return false;
    };

    /**
     * @function
     *      Sets a single option value
     * @param {String} Key The name of the config option (also combined ones like Richtext.Width)
     * @param {Object} Value The value of the option. Can be every kind of javascript variable type.
     * @return nothing
     */
    TargetNS.RegisterFormUpdate = function (EventType, $EventElement, Subaction, ChangedElement, FieldsToUpdate) {
        if ($EventElement.length) {
            $EventElement.bind(EventType, function () {
                TargetNS.AJAXFormUpdate($EventElement, Subaction, ChangedElement, FieldsToUpdate);
            });
        }
    };

    TargetNS.ContentUpdate = function ($ElementToUpdate, URL, Callback) {
        URL += SerializeData(GetSessionInformation());

        $.ajax({
            url: URL,
            dataType: 'html',
            success: function (Response) {
                if (!Response) {
                    alert("ERROR: No content from: " + URL);
                }
                else if ($ElementToUpdate && $ElementToUpdate instanceof jQuery && $ElementToUpdate.length) {
                    $ElementToUpdate.html(Response);
                }
                else {
                    alert("ERROR: No such element id: " + $ElementToUpdate.attr('id') + " in page!");
                }
            },
            complete: function () {
                if ($.isFunction(Callback)) {
                    Callback();
                }
            },
            error: function () {
                alert('ERROR: Something went wrong!');
            }
        });

        return false;
    };

    TargetNS.RegisterContentUpdate = function (EventType, $EventElement, $ElementToUpdate, URL, Callback) {
        if ($EventElement.length) {
            $EventElement.bind(EventType, function () {
                TargetNS.AJAXContentUpdate($ElementToUpdate, URL, Callback);
            });
        }
    };

    TargetNS.FunctionCall = function (URL, Data, Callback) {
        Data = $.extend(Data, GetSessionInformation());
        $.ajax({
            type: 'POST',
            url: URL,
            data: Data,
            dataType: 'json',
            success: function (Response) {
                if (!Response) {
                    alert("ERROR: No content from: " + URL);
                }
                // call the callback
                if ($.isFunction(Callback)) {
                    Callback(Response);
                }
                else {
                    alert("ERROR: Invalid callback method: " + Callback.toString());
                }
            },
            error: function () {
                alert('ERROR: Something went wrong!');
            }
        });
    };

    TargetNS.RegisterFunctionCall = function (EventType, $EventElement, URL, Data, Callback) {
        if ($EventElement.length) {
            $EventElement.bind(EventType, function () {
                TargetNS.AJAXFunctionCall(URL, Data, Callback);
            });
        }
    };

    return TargetNS;
}(OTRS.AJAX || {}));