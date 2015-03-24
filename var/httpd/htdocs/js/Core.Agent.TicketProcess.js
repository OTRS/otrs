// --
// Core.Agent.TicketProcess.js - provides the special module functions for TicketProcess
// Copyright (C) 2001-2013 OTRS AG, http://otrs.org/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};

/**
 * @namespace Core.Agent.TicketProcess
 * @memberof Core.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for TicketProcess.
 */
Core.Agent.TicketProcess = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.TicketProcess
     * @function
     * @description
     *      This function initializes the special module functions.
     */
    TargetNS.Init = function () {

        $('#ProcessEntityID').bind('change', function () {
            var Data = {
                Action: 'AgentTicketProcess',
                Subaction: 'DisplayActivityDialogAJAX',
                ProcessEntityID: $('#ProcessEntityID').val(),
                IsAjaxRequest: 1,
                IsMainWindow: 1
            };

            if ($('#IsProcessEnroll').val() !== 'undefined' && $('#IsProcessEnroll').val() === '1') {
                $.extend(Data, {
                    IsMainWindow: 0,
                    IsProcessEnroll: 1,
                    TicketID: $('#TicketID').val()
                });
            }

            // remove/destroy CKEditor instances
            // This is needed to initialize other instances (in other activity dialogs)
            // without a page reload
            if (typeof CKEDITOR !== 'undefined' && CKEDITOR.instances) {
                $.each(CKEDITOR.instances, function (Key) {
                    CKEDITOR.instances[Key].destroy();
                });
            }

            if ($('#ProcessEntityID').val()) {

                // remove the content of the activity dialog
                $('#ActivityDialogContent').empty();

                // fade out the empty container so it will fade in again on processes change
                // is not recommended to empty after fade out at this point since the transition offect
                // will not look so nice
                $('#ActivityDialogContent').fadeOut('fast');

                // show loader icon
                $('#AJAXLoader').removeClass('Hidden');

                // get new ActivityDialog content
                Core.AJAX.FunctionCall(
                    Core.Config.Get('CGIHandle'),
                    Data,
                    function (Response) {
                    var $ElementToUpdate = $('#ActivityDialogContent'),
                        JavaScriptString = '',
                        ErrorMessage;

                    if (!Response) {

                        // We are out of the OTRS App scope, that's why an exception would not be caught. Therefor we handle the error manually.
                        Core.Exception.HandleFinalError(new Core.Exception.ApplicationError("No content received.", 'CommunicationError'));
                        $('#AJAXLoader').addClass('Hidden');
                    }
                    else if ($ElementToUpdate && isJQueryObject($ElementToUpdate) && $ElementToUpdate.length) {
                        $ElementToUpdate.get(0).innerHTML = Response;
                        $ElementToUpdate.find('script').each(function() {
                            JavaScriptString += $(this).html();
                            $(this).remove();
                        });
                        $ElementToUpdate.fadeIn();
                        try {
                            /*jslint evil: true */
                            eval(JavaScriptString);
                        }
                        catch (ignore) {}

                        // Handle special server errors (Response = <div class="ServerError" data-message="Message"></div>)
                        // Check if first element has class 'ServerError'
                        if ( $ElementToUpdate.children().first().hasClass('ServerError') ) {
                            ErrorMessage = $ElementToUpdate.children().first().data('message');

                            // Add class ServerError to the process select element
                            $('#ProcessEntityID').addClass('ServerError');
                            // Set a custom error message to the proccess select element
                            $('#ProcessEntityIDServerError').children().first().text(ErrorMessage);
                        }

                        Core.Form.Validate.Init();

                        // Register event for tree selection dialog
                        Core.UI.TreeSelection.InitTreeSelection();

                        // move help triggers into field rows for dynamic fields
                        $('.Row > .FieldHelpContainer').each(function () {
                            if (!$(this).next('label').find('.Marker').length) {
                                $(this).prependTo($(this).next('label'));
                            }
                            else {
                                $(this).insertAfter($(this).next('label').find('.Marker'));
                            }
                        });

                        // Initially display dynamic fields with TreeMode = 1 correctly
                        Core.UI.TreeSelection.InitDynamicFieldTreeViewRestore();

                        $('#AJAXLoader').addClass('Hidden');
                        $('#AJAXDialog').val('1');

                    }
                    else {

                        // We are out of the OTRS App scope, that's why an exception would not be caught. Therefor we handle the error manually.
                        Core.Exception.HandleFinalError(new Core.Exception.ApplicationError("No such element id: " + $ElementToUpdate.attr('id') + " in page!", 'CommunicationError'));
                        $('#AJAXLoader').addClass('Hidden');
                    }
                }, 'html');
            }
            else {
                $('#ActivityDialogContent').fadeOut(400, function() {
                    $('#ActivityDialogContent').empty();
                });
            }
            return false;
        });
    };

    return TargetNS;
}(Core.Agent.TicketProcess || {}));