// --
// OTRS.Debug.js - provides debugging functions
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.Debug.js,v 1.2 2010-03-29 09:58:14 mn Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};

/**
 * @namespace
 * @description
 *      This namespace contains all debug functions
 */
OTRS.Debug = (function (Namespace) {

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
    Namespace.Log = DebugConsole
        ? function () { DebugLog.apply(DebugConsole, arguments); }
        : function() {}; // NOOP function for performance reasons in production systems

    /**
     * @function
     * @description
     *      Checks if a required function or namespace is present.
     * @param {String} TargetNamespace
     *      Namespace for which the check is executed
     * @param {String} Required
     *      The name of the function/namespace whose presence is checked
     * @param {String} RequiredLabel
     *      Label for the required item which will be included in the error message
     * @param {Boolean} Silent
     *      Do not issue an alert
     *
     * @return true if the required item was found, false otherwise (an an alert will be issued in that case)
     */
    Namespace.CheckDependency = function(TargetNamespace, Required, RequiredLabel, Silent){

        var RequiredEval;
        try {
            RequiredEval = eval('try{ typeof ' + Required + '} catch (E) {}' );
        }
        catch (Exception) {
        }

        if (RequiredEval === 'function' || RequiredEval === 'object') {
            return true;
        }
        if (!Silent) {
            alert('Error: Namespace ' + TargetNamespace + ' could not be initialized, because ' +
                RequiredLabel + ' could not be found.');
        }
        return false;
    };

    /**
     * @function
     * @description
     *      Use this function to test your HTML/CSS/JS code against usage in RTL.
     *
     *      This function changes all visible texts on a page to Arabic for RTL
     *      testing purposes. It also sets the class "RTL" on the body element to
     *      cause the layout to switch to RTL.
     */
    Namespace.SimulateRTLPage = function () {

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
        };

        var Replacement = 'رسال الإجابة (البريد الإلكتروني';

        function ReplaceAllText(Node) {
            var ChildNodes = (Node || document.body).childNodes;

            var I = 0;
            while (I < ChildNodes.length) {
                var CurrentNode = ChildNodes[I++];

                if (CurrentNode.nodeType === 1 && !ExcludeTags[CurrentNode.nodeName])
                {
                    ReplaceAllText(CurrentNode);
                    if (CurrentNode.nodeName == 'INPUT') {
                        var InputType = CurrentNode.getAttribute('type');
                        if (InputType == 'button'
                            || InputType == 'submit'
                        || InputType == 'reset'
                            || InputType == 'text') {
                            var InputValue = CurrentNode.getAttribute('value');
                            if (InputValue && InputValue.length) {
                                var ReplacementValue = Replacement.substr(0, InputValue.length);
                                CurrentNode.setAttribute('value', ReplacementValue);
                            }
                        }

                    }
                }

                if (CurrentNode.nodeType !== 3) {
                    continue;
                }

                var CurrentText = CurrentNode.nodeValue;
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
    }

    return Namespace;
}(OTRS.Debug || {}));
