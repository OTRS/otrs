// --
// OTRS.UI.Popup.js - provides functionality to open popup windows
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.UI.Popup.js,v 1.3 2010-04-19 16:36:29 mg Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};
OTRS.UI = OTRS.UI || {};

/**
 * @namespace
 * @exports TargetNS as OTRS.UI.Popup
 * @description
 *      Popup windows
 */
OTRS.UI.Popup = (function (TargetNS) {
    var OpenPopups = {},
        PopupProfiles,
        PopupDefaultProfile = 'Default';

    PopupProfiles = {
        'Default': "dependent=yes,height=500,left=100,top=100,location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,toolbar=no,width=800"
    };

    function CheckOpenPopups() {
        $.each(OpenPopups, function (Key, Value) {
            alert(Key + ' - ' +  Value);
            if (Value.closed) {
                delete OpenPopups[Key];
            }
        });
    }

    function GetPopupObjectByType(Type) {
        $.each(OpenPopups, function (Key, Value) {
            if (Key === Type) {
                return Value;
            }
        });
        return;
    }

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
        }
    };

    /**
     * @function
     * @description
     *      This function closes a opened popup.
     * @param {String or Object} Popup The type of a popup or thw window object
     * @return nothing
     */
    TargetNS.ClosePopup = function (Popup) {
        if (typeof Popup === 'String') {
            Popup = GetPopupObjectByType(Popup);
        }
        if (Popup && Popup instanceof window) {
            Popup.close();
            CheckOpenPopups();
        }
    };

    return TargetNS;
}(OTRS.UI.Popup || {}));
