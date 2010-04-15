// --
// OTRS.UI.Popup.js - provides functionality to open popup windows
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.UI.Popup.js,v 1.1 2010-04-15 23:11:18 mn Exp $
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
 * @description
 *      Popups
 */
OTRS.UI.Popup = (function(Namespace){
    var OpenPopups = {},
        PopupProfiles,
        PopupDefaultProfile = 'Default';

    PopupProfiles = {
        'Default': "dependent=yes,height=500,left=100,top=100,location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,toolbar=no,width=800"
    };

    function CheckOpenPopups(){
        $.each(OpenPopups, function(Key, Value){
            alert(Key + ' - ' +  Value);
            if (Value.closed) {
                delete OpenPopups[Key];
            }
        });
    }

    function GetPopupObjectByType(Type){
        $.each(OpenPopups, function(Key, Value){
            if (Key === Type) {
                return Value;
            }
        });
        return;
    }

    Namespace.GetPopupObject = function(Type){
        return GetPopupObjectByType(Type);
    }

    Namespace.Resize = function(Type, Width, Height){
        var Object = GetPopupObjectByType(Type);
        if (typeof Object !== 'undefined') {
            Object.resizeTo(Width, Height);
        }
    }

    /**
     * @function
     * @description
     *      This function initializes the sortable nature on the specified Elements.
     *      Child elements with the class "CanDrag" can then be sorted with Drag and Drop.
     * @param {jQueryObject} $Elements
     *      The elements which should be made sortable
     * @return nothing
     */
    Namespace.OpenPopup = function(URL, Type, Profile){
        var PopupObject, PopupProfile;
        CheckOpenPopups();
        if (URL) {
            PopupObject = GetPopupObjectByType(Type);
            if (typeof PopupObject !== 'undefined') {
                Namespace.ClosePopup(PopupObject);
            }
            PopupProfile = PopupProfiles[Profile] ? Profile : PopupDefaultProfile;
            OpenPopups[Type] = window.open(URL, Type, PopupProfiles[PopupProfile]);
        }
    }

    Namespace.ClosePopup = function(Popup){
        if (typeof Popup === 'String') {
            Popup = GetPopupObjectByType(Popup);
        }
        if (Popup && Popup instanceof window) {
            Popup.close();
            CheckOpenPopups();
        }
    }

    return Namespace;
}(OTRS.UI.Popup || {}));
