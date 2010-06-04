// --
// Core.Exception.js - provides the exception object and handling functions
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.Exception.js,v 1.1 2010-06-04 11:19:31 mn Exp $
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
     *      This function handles the given error object
     * @param {Object} Error The error object
     * @return nothing
     */
    TargetNS.HandleError = function (ErrorObject) {
        if (ErrorObject instanceof TargetNS.ApplicationError) {
            TargetNS.ShowError(ErrorObject.GetMessage(), ErrorObject.GetType());
        }
        else if (ErrorObject instanceof Error) {
            TargetNS.ShowError(ErrorObject.message, 'JavaScriptError');
            throw ErrorObject;
        }
        else {
            TargetNS.ShowError(ErrorObject, 'UndefinedError');
            throw ErrorObject;
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
        Core.Debug.Log('[ERROR] ' + ErrorType + ': ' + ErrorMessage);
    };

    return TargetNS;
}(Core.Exception || {}));