// --
// Core.Debug.js - provides debugging functions
// Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};

/**
 * @namespace
 * @exports TargetNS as Core.Debug
 * @description
 *      This namespace contains all debug functions
 */
Core.Debug = (function (TargetNS) {

    var DebugConsole, DebugLog;
    if (typeof console === 'object' && typeof console.log === 'function') {
        DebugConsole = console;
        DebugLog = console.log;
    }
    else if (typeof opera === 'object' && typeof opera.PostError === 'function') {
        DebugConsole = opera;
        DebugLog = opera.PostError;
    }

    /**
     * @function
     * @description
     *      Simple logging function. All parameters will be passed to
     *      the debug console of Firebug et al, if present.
     */
    TargetNS.Log = DebugConsole ?
        function () {
            DebugLog.apply(DebugConsole, arguments);
        } :
        function () {}; // NOOP function for performance reasons in production systems

    /**
     * @exports TargetNS.CheckDependency as Core.Debug.CheckDependency
     * @function
     * @description
     *      Checks if a required function or namespace is present.
     * @param {String} TargetNamespace
     *      Namespace for which the check is executed
     * @param {String} Required
     *      The name of the function/namespace whose presence is checked
     * @param {String} RequiredLabel
     *      Label for the
     *      required item which will be included in the error message
     * @param {Boolean} Silent
     *      Do not issue an alert
     *
     * @return true if the required item was found, false otherwise (an an alert and an exception will be issued in that case)
     */
    /*jslint evil: true */
    TargetNS.CheckDependency = function (TargetNamespace, Required, RequiredLabel, Silent) {
        var RequiredEval, ErrorMessage;

        try {
            RequiredEval = eval('try{ typeof ' + Required + '} catch (E) {}');
        }
        catch (Exception) {
        }

        if (RequiredEval === 'function' || RequiredEval === 'object') {
            return true;
        }
        if (!Silent) {
            ErrorMessage = 'Namespace ' + TargetNamespace + ' could not be initialized, because ' +
                RequiredLabel + ' could not be found.';
            alert(ErrorMessage);
            // don't use Core.Exception here, it may not be available
            throw ErrorMessage;
        }
        return false;
    };
    /*jslint evil: false */

    /**
     * @exports TargetNS.BrowserCheck as Core.Debug.BrowserCheckAgent
     * @function
     * @description
     *      Checks if the used browser is not on the OTRS browser blacklist
     *      of the agent interface.
     * @return true if the used browser is *not* on the black list.
     */
    TargetNS.BrowserCheckAgent = function () {
        var AppropriateBrowser = true,
            BrowserBlackList = Core.Config.Get('BrowserBlackList::Agent');
        if (typeof BrowserBlackList !== 'undefined') {
            $.each(BrowserBlackList, function (Key, Value) {
                if ($.isFunction(Value)) {
                    if (Value()) {
                        AppropriateBrowser = false;
                    }
                }
            });
            return AppropriateBrowser;
        }
    };

    /**
     * @exports TargetNS.BrowserCheck as Core.Debug.BrowserCheckCustomer
     * @function
     * @description
     *      Checks if the used browser is not on the OTRS browser blacklist
     *      of the customer interface.
     * @return true if the used browser is *not* on the black list.
     */
    TargetNS.BrowserCheckCustomer = function () {
        var AppropriateBrowser = true,
        BrowserBlackList = Core.Config.Get('BrowserBlackList::Customer');
        if (typeof BrowserBlackList !== 'undefined') {
            $.each(BrowserBlackList, function (Key, Value) {
                if ($.isFunction(Value)) {
                    if (Value()) {
                        AppropriateBrowser = false;
                    }
                }
            });
            return AppropriateBrowser;
        }
    };

    /**
     * @exports TargetNS.SimulateRTLPage as Core.Debug.SimulateRTLPage
     * @function
     * @description
     *      Use this function to test your HTML/CSS/JS code against usage in RTL.
     *
     *      This function changes all visible texts on a page to Arabic for RTL
     *      testing purposes. It also sets the class "RTL" on the body element to
     *      cause the layout to switch to RTL.
     */
    TargetNS.SimulateRTLPage = function () {

        $('body').addClass('RTL');

        var ExcludeTags = {
            'html': 1,
            'head': 1,
            'style': 1,
            'title': 1,
            'link': 1,
            'meta': 1,
            'script': 1,
            'object': 1,
            'iframe': 1
        },
        Replacement = 'رسال الإجابة (البريد الإلكتروني';

        /**
         * @function
         * @private
         * @return nothing
         * @description This function replaced the value attribute with the equivalent length in replacement string.
         */
        function ReplaceAllText(Node) {
            var ChildNodes = (Node || document.body).childNodes,
            CurrentNode,
            InputType,
            InputValue,
            ReplacementValue,
            CurrentText,
            I = 0;

            while (I < ChildNodes.length) {
                CurrentNode = ChildNodes[I++];

                if (CurrentNode.nodeType === 1 && !ExcludeTags[CurrentNode.nodeName])
                {
                    ReplaceAllText(CurrentNode);
                    if (CurrentNode.nodeName === 'INPUT') {
                        InputType = CurrentNode.getAttribute('type');
                        if (InputType === 'button' ||
                            InputType === 'submit' ||
                            InputType === 'reset' ||
                            InputType === 'text') {
                            InputValue = CurrentNode.getAttribute('value');
                            if (InputValue && InputValue.length) {
                                ReplacementValue = Replacement.substr(0, InputValue.length);
                                CurrentNode.setAttribute('value', ReplacementValue);
                            }
                        }

                    }
                }

                if (CurrentNode.nodeType !== 3) {
                    continue;
                }

                CurrentText = CurrentNode.nodeValue;
                if (!CurrentText) {
                    continue;
                }

                CurrentText = CurrentText.replace(/\s+/g, '');
                if (!CurrentText.length) {
                    continue;
                }

                CurrentNode.nodeValue = Replacement.substr(0, CurrentText.length);
            }
        }

        return ReplaceAllText();
    };

    return TargetNS;
}(Core.Debug || {}));
