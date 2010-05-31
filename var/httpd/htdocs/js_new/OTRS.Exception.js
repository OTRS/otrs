// --
// OTRS.Exception.js - provides the exception object and handling functions
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.Exception.js,v 1.2 2010-05-31 13:04:05 mn Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

function ApplicationError(ErrorMessage, ErrorType) {
    var Type = ErrorType,
        Message = ErrorMessage,
        Types = ['Error', 'InternalError', 'TypeError', 'CommunicationError'];
        DefaultType = 'Error';

    if (!$.inArray(Type, Types)) {
        Type = DefaultType;
    }

    this.GetType = function () {
        return Type;
    }

    this.GetMessage = function () {
        return Message;
    }
}

var OTRS = OTRS || {};

/**
 * @namespace
 * @exports TargetNS as OTRS.Exception
 * @description
 *      This namespace contains the functions for handling application errors.
 */
OTRS.Exception = (function (TargetNS) {
    /**
     * @function
     *      This function throws an application error
     * @param {String} ErrorMessage The error message
     * @param {String} ErrorType The error type
     * @return nothing
     */
    TargetNS.Throw = function (ErrorMessage, ErrorType) {
        throw new ApplicationError(ErrorMessage, ErrorType);
    };

    /**
     * @function
     *      This function handles the given error object
     * @param {Object} Error The error object
     * @return nothing
     */
    TargetNS.HandleError = function (Error) {
        if (Error instanceof ApplicationError) {
            TargetNS.ShowError(Error.GetMessage(), Error.GetType());
        }
        else if (Error instanceof Error) {
            TargetNS.ShowError(Error.message, 'JavaScriptError');
        }
        else {
            TargetNS.ShowError(Error, 'UndefinedError');
        }
        alert('An error occured! For details please see your browser log!');
    };

    /**
     * @function
     *      This function shows an error message in the log
     * @param {string} ErrorType The error type
     * @param {string} ErrorMessage The error message
     * @return nothing
     */
    TargetNS.ShowError = function (ErrorMessage, ErrorType) {
        OTRS.Debug.Log('[ERROR] ' + ErrorType + ': ' + ErrorMessage);
    };

    return TargetNS;
}(OTRS.Exception || {}));