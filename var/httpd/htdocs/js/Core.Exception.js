// --
// Core.Exception.js - provides the exception object and handling functions
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.Exception.js,v 1.3 2010-11-25 08:37:17 mn Exp $
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
     * @return nothing
     */
    TargetNS.HandleFinalError = function (ErrorObject, Trace) {
        var UserErrorMessage = 'An error occured! Do you want to see the complete error messages?';

        if (ErrorObject instanceof TargetNS.ApplicationError) {
            TargetNS.ShowError(ErrorObject.GetMessage(), ErrorObject.GetType(), Trace);
            if (window.confirm(UserErrorMessage)) {
                alert(ErrorObject.GetMessage() + '\n\n' + Trace);
            }
        }
        else if (ErrorObject instanceof Error) {
            TargetNS.ShowError(ErrorObject.message, 'JavaScriptError', Trace);
            if (window.confirm(UserErrorMessage)) {
                alert(ErrorObject.message + '\n\n' + Trace);
            }
            throw ErrorObject; // rethrow
        }
        else {
            TargetNS.ShowError(ErrorObject, 'UndefinedError', Trace);
            if (window.confirm(UserErrorMessage)) {
                alert(ErrorObject + '\n\n' + Trace);
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