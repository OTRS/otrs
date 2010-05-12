// --
// OTRS.Exception.js - provides the exception object and handling functions
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.Exception.js,v 1.1 2010-05-12 14:06:36 mn Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

function ApplicationError(ErrorType, ErrorMessage) {
    var Type = ErrorType,
        Message = ErrorMessage,
        Types = ['Error', 'InternalError', 'TypeError'];
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
     *      This function handles the given error object
     * @param {Object} Error The error object
     * @return nothing
     */
    TargetNS.HandleError = function (Error) {
        if (Error instanceof ApplicationError) {
            TargetNS.ShowError(Error.GetType(), Error.GetMessage());
        }
        else if (Error instanceof Error) {
            TargetNS.ShowError('JavaScriptError', Error.message);
        }
        else {
            TargetNS.ShowError('UndefinedError', Error);
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
    TargetNS.ShowError = function (ErrorType, ErrorMessage) {
        OTRS.Debug.Log('[ERROR] ' + ErrorType + ': ' + ErrorMessage);
    };

    return TargetNS;
}(OTRS.Exception || {}));