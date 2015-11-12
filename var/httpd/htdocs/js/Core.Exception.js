// --
// Core.Exception.js - provides the exception object and handling functions
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
 * @exports TargetNS as Core.Exception
 * @description
 *      This namespace contains the functions for handling application errors.
 */
Core.Exception = (function (TargetNS) {

    /**
     * @function Initialization code.
     */
    TargetNS.Init = function () {
        /*
         * Register an 'beforeunload' function which puts a status flag that
         *  the current page is about to be left. Then AJAX errors because of
         *  pending AJAX requests must be suppressed.
         */
        $(window).bind('beforeunload.Exception', function(){
            // Use a public member so that we can also set it from a test case.
            TargetNS.AboutToLeave = true;
        });
    };
    /**
     * @function
     *      This is the constructor for the application error object
     * @param {String} ErrorMessage The error message
     * @param {String} ErrorType The error type
     * @return nothing
     */
    TargetNS.ApplicationError = function (ErrorMessage, ErrorType) {
        var Type = ErrorType,
            Message = ErrorMessage,
            Types = ['Error', 'InternalError', 'TypeError', 'CommunicationError'],
            DefaultType = 'Error';

        if (!$.inArray(Type, Types)) {
            Type = DefaultType;
        }

        this.GetType = function () {
            return Type;
        };

        this.GetMessage = function () {
            return Message;
        };
    };

    /**
     * @function
     *      This function throws an application error
     * @param {String} ErrorMessage The error message
     * @param {String} ErrorType The error type
     * @return nothing
     */
    TargetNS.Throw = function (ErrorMessage, ErrorType) {
        throw new TargetNS.ApplicationError(ErrorMessage, ErrorType);
    };

    /**
     * @function
     *      This function returns true, if the given ErrorObject is an ApplicationError of the given Type
     * @param {Object} ErrorObject The error object
     * @param {String} ErrorType The error type to be checked
     * @return {Boolean} Returns true, if the ErrorObject is an ApplicationError object and has the type ErrorType
     */
    TargetNS.IsErrorOfType = function (ErrorObject, ErrorType) {
        return  (ErrorObject instanceof TargetNS.ApplicationError && ErrorObject.GetType === ErrorType);
    };

    /**
     * @function
     *      This function handles the given error object (used as last possibility to catch the error)
     * @param {Object} Error The error object
     * @param {String} Trace (Optional) A string containing the stacktrace
     * @return {Boolean} If the error could be handled, returns if it was shown to the user or not.
     *      If the error could not be handled, this method will rethrow it.
     */
    TargetNS.HandleFinalError = function (ErrorObject, Trace) {
        var UserErrorMessage = 'An error occurred! Do you want to see the complete error message?';

        if (ErrorObject instanceof TargetNS.ApplicationError) {
            // Suppress AJAX errors which were raised by leaving the page while the AJAX call was still running.
            if (TargetNS.AboutToLeave && ErrorObject.GetType() === 'CommunicationError') {
                return false;
            }
            TargetNS.ShowError(ErrorObject.GetMessage(), ErrorObject.GetType(), Trace);
            if (window.confirm(UserErrorMessage)) {
                alert(ErrorObject.GetMessage() + (Trace ? ('\n\n' + Trace) : ''));
            }
            return true;
        }
        else if (ErrorObject instanceof Error) {
            TargetNS.ShowError(ErrorObject.message, 'JavaScriptError', Trace);
            if (window.confirm(UserErrorMessage)) {
                alert(ErrorObject.message + (Trace ? ('\n\n' + Trace) : ''));
            }
            throw ErrorObject; // rethrow
        }
        else {
            TargetNS.ShowError(ErrorObject, 'UndefinedError', Trace);
            if (window.confirm(UserErrorMessage)) {
                alert(ErrorObject + (Trace ? ('\n\n' + Trace) : ''));
            }
            throw ErrorObject; // rethrow
        }
    };

    /**
     * @function
     *      This function shows an error message in the log
     * @param {string} ErrorType The error type
     * @param {string} ErrorMessage The error message
     * @param {string} Trace (Optional) The stacktrace
     * @return nothing
     */
    TargetNS.ShowError = function (ErrorMessage, ErrorType, Trace) {
        Core.Debug.Log('[ERROR] ' + ErrorType + ': ' + ErrorMessage);
        if (typeof Trace !== 'undefined') {
            Core.Debug.Log('[STACKTRACE] ' + Trace);
        }
    };

    return TargetNS;
}(Core.Exception || {}));
