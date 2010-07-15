// --
// Core.UI.Popup.js - provides functionality to open popup windows
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.UI.Popup.js,v 1.2 2010-07-15 08:53:50 mn Exp $
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
 * @exports TargetNS as Core.UI.Popup
 * @description
 *      Popup windows
 */
Core.UI.Popup = (function (TargetNS) {
    var OpenPopups = {},
        PopupProfiles,
        PopupDefaultProfile = 'Default',
        RegisterPopupTimeOut = 1000;

    PopupProfiles = {
        'Default': "dependent=yes,height=500,left=100,top=100,location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,toolbar=no,width=1000"
    };

    function CheckOpenPopups() {
        $.each(OpenPopups, function (Key, Value) {
            if (Value.closed) {
                delete OpenPopups[Key];
            }
        });
    }

    function GetPopupObjectByType(Type) {
        return OpenPopups[Type];
    }

    TargetNS.RegisterPopupEvent = function () {
        $(window).bind('Popup', function (Event, Type, Param) {
            if (Type && typeof Type !== 'undefined') {
                if (Type === 'Reload') {
                    window.location.reload();
                }
                else if (Type === 'URL') {
                    if (Param && typeof Param.URL !== 'undefined') {
                        window.location.href = Param.URL;
                    }
                }
            }
        });
    };

    TargetNS.FirePopupEvent = function (Type, Param) {
        $(window).unbind('beforeunload.Popup').unbind('unload.Popup');
        $(window).trigger('Popup', [Type, Param]);
    };

    TargetNS.CheckPopupsOnUnload = function () {
        var Size = 0;
        CheckOpenPopups();
        $.each(OpenPopups, function (Key, Value) {
            Size++;
        });
        if (Size) {
            return Core.Config.Get('PopupLeaveParentWindowMsg');
        }
    };

    TargetNS.ClosePopupsOnUnload = function () {
        CheckOpenPopups();
        $.each(OpenPopups, function (Key, Value) {
            TargetNS.ClosePopup(Value);
        });
    };

    TargetNS.RegisterPopupAtParentWindow = function (WindowObject) {
        var Type = WindowObject.WindowType;
        if (typeof OpenPopups[Type] === 'undefined') {
            OpenPopups[Type] = WindowObject;
        }
        else {
            if (OpenPopups[Type] !== WindowObject) {
                OpenPopups[Type] = WindowObject;
            }
        }
    };

    TargetNS.InitRegisterPopupAtParentWindow = function () {
        window.setTimeout(function () {
            if (window.opener &&
                window.opener.Core &&
                window.opener.Core.UI &&
                window.opener.Core.UI.Popup
            ) {
                try {
                    window.opener.Core.UI.Popup.RegisterPopupAtParentWindow(window);
                }
                catch (Error) {}
            }
            Core.UI.Popup.InitRegisterPopupAtParentWindow();
        }, RegisterPopupTimeOut);
    };

    /**
     * @function
     * @description
     *      Get window object by popup type.
     * @param {String} Type The type of a window, e.g. 'Action'
     * @return {Object} The window object of the popup or undefined
     */
    TargetNS.GetPopupObject = function (Type) {
        return GetPopupObjectByType(Type);
    };

    /**
     * @function
     * @description
     *      This function resizes an opened window.
     * @param {String} Type The type of a window, e.g. 'Action'
     * @param {String} Width Width in pixels
     * @param {String} Height Height in pixels
     * @return nothing
     */
    TargetNS.Resize = function (Type, Width, Height) {
        var Object = GetPopupObjectByType(Type);
        if (typeof Object !== 'undefined') {
            Object.resizeTo(Width, Height);
        }
    };

    /**
     * @function
     * @description
     *      This function opens a popup window. Every popup is of a specific type and there can only be one window of a type at a time.
     * @param {String} URL The URL to be open in the new window
     * @param {String} Type The type of a window, e.g. 'Action'
     * @param {String} Profile The profile of a window, which defines the window parameters. Optional, default is 'Default'
     * @return nothing
     */
    TargetNS.OpenPopup = function (URL, Type, Profile) {
        var PopupObject, PopupProfile;
        CheckOpenPopups();
        if (URL) {
            PopupObject = GetPopupObjectByType(Type);
            if (typeof PopupObject !== 'undefined') {
                TargetNS.ClosePopup(PopupObject);
            }
            PopupProfile = PopupProfiles[Profile] ? Profile : PopupDefaultProfile;
            OpenPopups[Type] = window.open(URL, Type, PopupProfiles[PopupProfile]);
            OpenPopups[Type].WindowType = Type;
        }
    };

    /**
     * @function
     * @description
     *      This function closes a opened popup.
     * @param {String or Object} Popup The type of a popup or the window object
     * @return nothing
     */
    TargetNS.ClosePopup = function (Popup) {
        if (typeof Popup === 'string') {
            Popup = GetPopupObjectByType(Popup);
        }
        if (typeof Popup !== 'undefined') {
            Popup.close();
            CheckOpenPopups();
        }
    };

    return TargetNS;
}(Core.UI.Popup || {}));
