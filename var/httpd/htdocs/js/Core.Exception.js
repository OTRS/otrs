// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var Core = Core || {};

/**
 * @namespace Core.Exception
 * @memberof Core
 * @author OTRS AG
 * @description
 *      This namespace contains the functions for handling application errors.
 */
Core.Exception = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Exception
     * @function
     * @description
     *      Initializes the module functionality.
     */
    TargetNS.Init = function () {
        /*
         * Register an 'beforeunload' function which puts a status flag that
         *  the current page is about to be left. Then AJAX errors because of
         *  pending AJAX requests must be suppressed.
         */
        $(window).on('beforeunload.Exception', function(){
            // Use a public member so that we can also set it from a test case.
            TargetNS.AboutToLeave = true;
        });

    };

    /**
     * @name ApplicationError
     * @memberof Core.Exception
     * @function
     * @param {String} ErrorMessage - The error message
     * @param {String} ErrorType - The error type
     * @description
     *      This is the constructor for the application error object.
     */
    TargetNS.ApplicationError = function (ErrorMessage, ErrorType) {
        var Type = ErrorType,
            Message = ErrorMessage,
            Types = ['Error', 'InternalError', 'TypeError', 'CommunicationError', 'ConnectionError'],
            DefaultType = 'Error';

        if (!$.inArray(Type, Types)) {
            Type = DefaultType;
        }

        /**
         * @name GetType
         * @memberof Core.Exception.ApplicationError
         * @function
         * @returns {String} Type of error.
         * @description
         *      Returns the type of error this ErrorObject is of (e.g. InternalError, TypeError, CommunicationError).
         */
        this.GetType = function () {
            return Type;
        };

        /**
         * @name GetMessage
         * @memberof Core.Exception.ApplicationError
         * @function
         * @returns {String} Error message.
         * @description
         *      Returns the error message of theErrorObject.
         */
        this.GetMessage = function () {
            return Message;
        };
    };

    /**
     * @name Throw
     * @memberof Core.Exception
     * @function
     * @param {String} ErrorMessage - The error message
     * @param {String} ErrorType - The error type
     * @description
     *      This function throws an application error.
     */
    TargetNS.Throw = function (ErrorMessage, ErrorType) {
        throw new TargetNS.ApplicationError(ErrorMessage, ErrorType);
    };

    /**
     * @name IsErrorOfType
     * @memberof Core.Exception
     * @function
     * @returns {Boolean} True, if ErrorObject is of given type, false otherwise.
     * @param {Object} ErrorObject - The error object
     * @param {String} ErrorType - The error type to be checked
     * @description
     *      Checks if the given ErrorObject is an ApplicationError of the given Type.
     */
    TargetNS.IsErrorOfType = function (ErrorObject, ErrorType) {
        return (ErrorObject instanceof TargetNS.ApplicationError && ErrorObject.GetType() === ErrorType);
    };

    /**
     * @name HandleFinalError
     * @memberof Core.Exception
     * @function
     * @returns {Boolean} If the error could be handled, returns if it was shown to the user or not.
     * @param {Object} ErrorObject - The error object
     * @description
     *      This function handles the given error object (used as last possibility to catch the error).
     */
    TargetNS.HandleFinalError = function (ErrorObject) {
        var UserErrorMessage = 'An error occurred! Please check the browser error log for more details!',
            ErrorType;

        if (typeof Core.Language !== 'undefined') {
            UserErrorMessage = Core.Language.Translate('An error occurred! Please check the browser error log for more details!')
        }

        if (ErrorObject instanceof TargetNS.ApplicationError) {
            ErrorType = ErrorObject.GetType();

            // Suppress AJAX errors which were raised by leaving the page while the AJAX call was still running.
            if (TargetNS.AboutToLeave && (ErrorType === 'CommunicationError' || ErrorType === 'ConnectionError')) {
                return false;
            }

            if (ErrorType === 'ConnectionError' || ErrorType === 'CommunicationError') {
                Core.App.Publish('Core.App.AjaxError');
            }
            else {
                TargetNS.ShowError(ErrorObject.GetMessage(), ErrorType);
                alert(UserErrorMessage);
            }

            return true;
        }
        else if (ErrorObject instanceof Error) {
            TargetNS.ShowError(ErrorObject.message, 'JavaScriptError');
            alert(UserErrorMessage);
            throw ErrorObject; // rethrow
        }
        else {
            TargetNS.ShowError(ErrorObject, 'UndefinedError');
            alert(UserErrorMessage);
            throw ErrorObject; // rethrow
        }
    };

    /**
     * @name ShowError
     * @memberof Core.Exception
     * @function
     * @param {String} ErrorMessage - The error message.
     * @param {String} ErrorType - The error type.
     * @description
     *      This function shows an error message in the log.
     */
    TargetNS.ShowError = function (ErrorMessage, ErrorType) {
        Core.Debug.Log('[ERROR] ' + ErrorType + ': ' + ErrorMessage);
    };

    Core.Init.RegisterNamespace(TargetNS, 'DOCUMENT_READY');

    return TargetNS;
}(Core.Exception || {}));
