// --
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
 * @namespace Core.UI.Popup
 * @memberof Core.UI
 * @author OTRS AG
 * @description
 *      Popup windows.
 */
Core.UI.Popup = (function (TargetNS) {
    /**
     * @private
     * @name OpenPopups
     * @memberof Core.UI.Popup
     * @member {Object}
     * @description
     *      All open popups.
     */
    var OpenPopups = {},

    /**
     * @private
     * @name PopupProfiles
     * @memberof Core.UI.Popup
     * @member {Object}
     * @description
     *      Defined popup profiles.
     */
        PopupProfiles,

    /**
     * @private
     * @name PopupDefaultProfile
     * @memberof Core.UI.Popup
     * @member {Object}
     * @description
     *      Default profile.
     */
        PopupDefaultProfile = 'Default',

    /**
     * @private
     * @name RegisterPopupTimeOut
     * @memberof Core.UI.Popup
     * @member {Object}
     * @description
     *      Time to wait before a popup is registered at the parent window.
     */
        RegisterPopupTimeOut = 1000,

    /**
     * @private
     * @name WindowMode
     * @memberof Core.UI.Popup
     * @member {String}
     * @description
     *      Defines the mode to open popups.
     *      If the screen size is <1024px (ScreenL), we do not open popup windows,
     *      but add fullsize iframes to the page.
     *      Mode can be 'Popup' or 'Iframe'.
     */
        WindowMode = 'Popup';

    if (!Core.Debug.CheckDependency('Core.UI.Dialog', 'Core.Config', 'Core.Config')) {
        return false;
    }

    PopupProfiles = {
        'Default': {
            WindowURLParams: "dependent=yes,location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,toolbar=no",
            Left: 100,
            Top: 100,
            Width: 1024,
            Height: 700
        }
    };

    /**
     * @private
     * @name CheckOpenPopups
     * @memberof Core.UI.Popup
     * @function
     * @description
     *      Check which popup windows are still open.
     */
    function CheckOpenPopups() {
        $.each(OpenPopups, function (Key, Value) {
            if (Value.closed) {
                delete OpenPopups[Key];
            }
        });
    }

    /**
     * @private
     * @name CheckOpenPopups
     * @memberof Core.UI.Popup
     * @function
     * @returns {Object} Open popups of given type.
     * @param {String} Type - The type of a window, e.g. 'Action'.
     * @description
     *      Check which popup window are still open.
     */
    function GetPopupObjectByType(Type) {
        return OpenPopups[Type];
    }

    /**
     * @private
     * @name GetWindowParentObject
     * @memberof Core.UI.Popup
     * @function
     * @returns {Object} Parent window object.
     * @description
     *      Get the window parent object of the current popup.
     */
    function GetWindowParentObject() {
        // we have a normal popup, opener is defined
        if (window.opener !== null) {
            return window.opener;
        }
        else {
            return window.parent;
        }
    }

    /**
     * @private
     * @name CurrentIsPopupWindow
     * @memberof Core.UI.Popup
     * @function
     * @returns {String} Returns the type of popup if one, undefined otherwise.
     * @description
     *      Checks if current window is an OTRS popup.
     */
    function CurrentIsPopupWindow() {
        var PopupType;

        if (window.name.match(/OTRSPopup_([^_]+)_.+/)) {
            PopupType = RegExp.$1;
        }

        return PopupType;
    }

    /**
     * @name ProfileAdd
     * @memberof Core.UI.Popup
     * @function
     * @param {String} Key - Name of the Profile (UID).
     * @param {String} Values - Profile string as expected by window.open(),
     *                         e. g. "dependent=yes,height=700,left=100,top=100,location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,toolbar=no,width=1000".
     * @description
     *      Adds a popup profile.
     */
    TargetNS.ProfileAdd = function (Key, Values) {
        PopupProfiles[Key] = Values;
    };

    /**
     * @name ProfileList
     * @memberof Core.UI.Popup
     * @function
     * @returns {Object} PopupProfiles object.
     * @description
     *      Get the list of registered popup profiles.
     */
    TargetNS.ProfileList = function () {
        return PopupProfiles;
    };

    /**
     * @name RegisterPopupEvent
     * @memberof Core.UI.Popup
     * @function
     * @description
     *      Register the pop-up event for a window.
     */
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

    /**
     * @name FirePopupEvent
     * @memberof Core.UI.Popup
     * @function
     * @param {String} Type - The event type that will be launched.
     * @param {Object} Param  - The element that contain information about the new screen address.
     * @description
     *      This function starts the pop-up event.
     */
    TargetNS.FirePopupEvent = function (Type, Param) {
        $(window).unbind('beforeunload.Popup').unbind('unload.Popup');
        $(window).trigger('Popup', [Type, Param]);
    };

    /**
     * @name CheckPopupsOnUnload
     * @memberof Core.UI.Popup
     * @function
     * @returns {String} A Warning text.
     * @description
     *      This review if some popup windows are open, then try to send a warning.
     */
    TargetNS.CheckPopupsOnUnload = function () {
        var Size = 0;
        CheckOpenPopups();
        $.each(OpenPopups, function (Key, Value) {
            // IE(7) treats windows in new tabs (opened with right-click) also as popups
            // Therefore we check if the popup is a real OTRS popup.
            // IE9 can't read the WindowType property from the window object,
            // so we check for the correct popup window name now.
            if (Value.name.match(/OTRSPopup_.+/)) {
                Size++;
            }
        });
        if (Size) {
            return Core.Config.Get('PopupLeaveParentWindowMsg');
        }
    };

    /**
     * @name ClosePopupsOnUnload
     * @memberof Core.UI.Popup
     * @function
     * @description
     *      This function close the active popup windows.
     */
    TargetNS.ClosePopupsOnUnload = function () {
        CheckOpenPopups();
        $.each(OpenPopups, function (Key, Value) {
            // IE(7) treats windows in new tabs (opened with right-click) also as popups
            // Therefore we check if the popup is a real OTRS popup.
            // IE9 can't read the WindowType property from the window object,
            // so we check for the correct popup window name now.
            if (Value.name.match(/OTRSPopup_.+/)) {
                TargetNS.ClosePopup(Value);
            }
        });
    };

    /**
     * @name RegisterPopupAtParentWindow
     * @memberof Core.UI.Popup
     * @function
     * @param {Object} WindowObject - Real window object.
     * @param {String} Type - the window type.
     * @description
     *      This function set the type for a popup window.
     */
    TargetNS.RegisterPopupAtParentWindow = function (WindowObject) {
        var Type;

        /OTRSPopup_([^_]+)_.*/.exec(WindowObject.name);
        Type = RegExp.$1;

        if (typeof OpenPopups[Type] === 'undefined') {
            OpenPopups[Type] = WindowObject;
        }
        else {
            if (OpenPopups[Type] !== WindowObject) {
                OpenPopups[Type] = WindowObject;
            }
        }
    };

    /**
     * @name InitRegisterPopupAtParentWindow
     * @memberof Core.UI.Popup
     * @function
     * @description
     *      This function set a timeout and after that try to register a popup at a parent window.
     */
    TargetNS.InitRegisterPopupAtParentWindow = function () {
        window.setTimeout(function () {
            var PopupType = CurrentIsPopupWindow(),
                ParentWindow;

            if (typeof PopupType !== 'undefined') {
                ParentWindow = GetWindowParentObject();
            }

            if (ParentWindow &&
                ParentWindow.Core &&
                ParentWindow.Core.UI &&
                ParentWindow.Core.UI.Popup
            ) {
                try {
                    ParentWindow.Core.UI.Popup.RegisterPopupAtParentWindow(window, PopupType);
                }
                catch (Event) {
                    // no code here
                    $.noop(Event);
                }
            }
            Core.UI.Popup.InitRegisterPopupAtParentWindow();
        }, RegisterPopupTimeOut);
    };

    /**
     * @name GetPopupObject
     * @memberof Core.UI.Popup
     * @function
     * @returns {Object} The window object of the popup or undefined.
     * @param {String} Type - The type of a window, e.g. 'Action'.
     * @description
     *      Get window object by popup type.
     */
    TargetNS.GetPopupObject = function (Type) {
        return GetPopupObjectByType(Type);
    };

    /**
     * @name GetWindowMode
     * @memberof Core.UI.Popup
     * @function
     * @returns {String} The window mode ('Popup' or 'Iframe') or undefined.
     * @description
     *      Get the window mode.
     */
    TargetNS.GetWindowMode = function () {
        if (WindowMode === 'Popup' || WindowMode === 'Iframe') {
            return WindowMode;
        }
        else {
            return undefined;
        }
    };

    /**
     * @name SetWindowMode
     * @memberof Core.UI.Popup
     * @function
     * @param {String} Mode - The new window mode ('Popup' or 'Iframe').
     * @description
     *      Set the window mode.
     */
    TargetNS.SetWindowMode = function (Mode) {
        if (Mode === 'Popup' || Mode === 'Iframe') {
            WindowMode = Mode;
        }
        else {
            WindowMode = undefined;
        }
    };

    /**
     * @name Resize
     * @memberof Core.UI.Popup
     * @function
     * @param {String} Type - The type of a window, e.g. 'Action'.
     * @param {String} Width - Width in pixels.
     * @param {String} Height - Height in pixels.
     * @description
     *      This function resizes an opened window.
     */
    TargetNS.Resize = function (Type, Width, Height) {
        var PopupObject = GetPopupObjectByType(Type);
        // do not resize in iframe mode
        if (WindowMode === 'Iframe') {
            return;
        }
        if (typeof PopupObject !== 'undefined') {
            PopupObject.resizeTo(Width, Height);
        }
    };

    /**
     * @name OpenPopup
     * @memberof Core.UI.Popup
     * @function
     * @param {String} URL - The URL to be open in the new window.
     * @param {String} Type - The type of a window, e.g. 'Action'.
     * @param {String} Profile - The profile of a window, which defines the window parameters. Optional, default is 'Default'.
     * @description
     *      This function opens a popup window. Every popup is of a specific type and there can only be one window of a type at a time.
     */
    TargetNS.OpenPopup = function (URL, Type, Profile) {
        var PopupObject,
            PopupProfile,
            NewWindow,
            WindowName,
            ConfirmClosePopup = true,
            PopupFeatures;

        CheckOpenPopups();
        if (URL) {
            PopupObject = GetPopupObjectByType(Type);

            if (typeof PopupObject !== 'undefined') {
                ConfirmClosePopup = window.confirm(Core.Config.Get('PopupAlreadyOpenMsg'));
                if (ConfirmClosePopup) {
                    TargetNS.ClosePopup(PopupObject);
                }
            }

            // Only load new popup if the user accepted that the old popup is closed
            if (ConfirmClosePopup) {
                PopupProfile = PopupProfiles[Profile] ? Profile : PopupDefaultProfile;
                /*
                 * Special treatment for the window name. At least in some browsers, window names
                 *  are global, so only one popup window with a particular name may exist across
                 *  all browser tabs. To avoid conflicts with that, we use 'randomized' names
                 *  by including the current time in the name string. This name is also needed
                 *  to save the Type parameter.
                 */
                WindowName = 'OTRSPopup_' + Type + '_' + Date.parse(new Date());
                if (WindowMode === 'Popup') {
                    PopupFeatures = PopupProfiles[PopupProfile].WindowURLParams;
                    // Get the position of the current screen on browsers which support it (non-IE) and
                    //  use it to open the popup on the same screen
                    PopupFeatures += ',left=' + ((window.screen.left || 0) + PopupProfiles[PopupProfile].Left);
                    PopupFeatures += ',top=' + ((window.screen.top || 0) + PopupProfiles[PopupProfile].Top);
                    PopupFeatures += ',width=' + PopupProfiles[PopupProfile].Width;
                    PopupFeatures += ',height=' + PopupProfiles[PopupProfile].Height;

                    NewWindow = window.open(URL, WindowName, PopupFeatures);

                    // check for popup blockers.
                    // currently, popup windows cannot easily be detected in chrome, because it will
                    //      load the entire content in an invisible window.
                    if (!NewWindow || NewWindow.closed || typeof NewWindow.closed === 'undefined') {
                        window.alert(Core.Config.Get('PopupBlockerMsg'));
                    }
                    else {
                        OpenPopups[Type] = NewWindow;
                    }
                }
                else if (WindowMode === 'Iframe') {
                    // jump to the top  and remove window scrollbar
                    window.scrollTo(0, 0);
                    $('body').css({
                        'overflow': 'hidden'
                    });
                    // add iframe overlay
                    $('body').append('<iframe data-popuptype="' + Type + '" name="' + WindowName + '" class="PopupIframe" src="' + URL + '"></iframe>');
                }
            }
        }
    };

    /**
     * @name HasOpenPopups
     * @memberof Core.UI.Popup
     * @function
     * @returns {Boolean} True, if popups are open on the page, false otherwise.
     * @description
     *      Checks if there are open popups on the page.
     */
    TargetNS.HasOpenPopups = function() {
        var HasOpenPopups = false,
            Popup;

        CheckOpenPopups();
        for (Popup in OpenPopups) {
            if (OpenPopups.hasOwnProperty(Popup)) {
                HasOpenPopups = true;
                break;
            }
         }

        return HasOpenPopups;
    };

    /**
     * @name ClosePopup
     * @memberof Core.UI.Popup
     * @function
     * @param {String|Object} PopupType - The type of a popup or the window object. If not defined, the current popup windoe is closed.
     * @description
     *      This function closes a opened popup.
     */
    TargetNS.ClosePopup = function (PopupType) {
        var PopupObject;

        // If parameter is not defined, we are in a popup and want to close this popup itself.
        // We get the PopupType from the current popup window
        if (typeof PopupType === 'undefined') {
            PopupType = CurrentIsPopupWindow();
        }

        // The PopupType is a string, if we are in a popup or the paraemter of the function was a string
        // with the type of Popup to close.
        if (typeof PopupType === 'string') {
            // We try to get the popup object by type, which only works, if we are in the parent window
            // If PopupObject is undefined after that, we are in the popup window itself.
            PopupObject = GetPopupObjectByType(PopupType);

            // We are in the popup window itself and try to get a window object of the parent window.
            if (typeof PopupObject === 'undefined') {
                PopupObject = GetWindowParentObject();
            }
        }
        // If PopupType is not a string, it is an window object, which we got as a parameter
        // from the function call.
        else {
            PopupObject = PopupType;
        }

        if (typeof PopupObject !== 'undefined') {
            // If we opened a real popup, we can close it now safely
            // Thsi works from the parent window as well as from the popup window itself
            if (WindowMode === 'Popup') {
                PopupObject.close();
            }
            // If we are in Iframe mode, we have to make sure, that we delete the iframe DOM element
            // from the parent window (PopupObject.document)
            // We also restore the parent windows CSS.
            else {
                // in some circumstances PopupType can be a window object instead of a string
                // we extract the PopupType from the window name and carry on
                if (typeof PopupType !== 'string') {
                    if (PopupType && typeof PopupType.name !== 'undefined' && PopupType.name.match(/OTRSPopup_([^_]+)_.+/)) {
                        PopupType = RegExp.$1;
                    }
                }

                $('iframe.PopupIframe[data-popuptype=' + PopupType + ']', PopupObject.document).remove();
                $('body', PopupObject.document).css({
                    'overflow': 'auto'
                });
            }

            CheckOpenPopups();
        }
    };

    /**
     * @name Init
     * @memberof Core.UI.Popup
     * @function
     * @description
     *      The init function.
     */
    TargetNS.Init = function () {

        // Whenever the screen size changes to smaller or equal ScreenL,
        // we need to change the window mode to Iframe
        Core.App.Subscribe('Event.App.Responsive.SmallerOrEqualScreenL', function () {
            TargetNS.SetWindowMode('Iframe');
        });

        // Set window mode back to Popup, if screen size is big enough
        Core.App.Subscribe('Event.App.Responsive.ScreenXL', function () {
            TargetNS.SetWindowMode('Popup');
        });

        $(window).bind('beforeunload.Popup', function () {
            return Core.UI.Popup.CheckPopupsOnUnload();
        });
        $(window).bind('unload.Popup', function () {
            Core.UI.Popup.ClosePopupsOnUnload();
        });
        Core.UI.Popup.RegisterPopupEvent();

        // if this window is a popup itself, register another function
        if (CurrentIsPopupWindow()) {
            Core.UI.Popup.InitRegisterPopupAtParentWindow();
            $('.CancelClosePopup').bind('click', function () {
                TargetNS.ClosePopup();
            });
            $('.UndoClosePopup').bind('click', function () {
                var RedirectURL = $(this).attr('href'),
                    ParentWindow = GetWindowParentObject();
                ParentWindow.Core.UI.Popup.FirePopupEvent('URL', { URL: RedirectURL });
                TargetNS.ClosePopup();
            });

            // add a class to the body element, if this popup is a real popup
            if (window.opener) {
                $('body').addClass('RealPopup');
            }
        }
    };

    return TargetNS;
}(Core.UI.Popup || {}));
