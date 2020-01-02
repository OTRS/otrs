// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};
Core.Agent.Admin = Core.Agent.Admin || {};

/**
 * @namespace Core.Agent.Admin.GenericInterfaceWebservice
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the GenericInterface web service module.
 */
Core.Agent.Admin.GenericInterfaceWebservice = (function (TargetNS) {

    /**
     * @name HideElements
     * @memberof Core.Agent.Admin.GenericInterfaceWebservice
     * @function
     * @description
     *      Hides specific DOM elements.
     */
    TargetNS.HideElements = function(){
        $('button.HideActionOnChange').parent().hide();
        $('.HideOnChange').hide();
        $('.HideLinkOnChange').contents().unwrap();
    };

    /**
     * @name Init
     * @memberof Core.Agent.Admin.GenericInterfaceWebservice
     * @function
     * @description
     *      This function initialize the module functionality.
     */
    TargetNS.Init = function () {
        var Action = Core.Config.Get('Subaction'),
            Webservice;

        TargetNS.WebserviceID = parseInt($('#WebserviceID').val(), 10);

        if (Action === "Add") {
            TargetNS.HideElements();
        }

        $('#DeleteButton').on('click', TargetNS.ShowDeleteDialog);
        $('#CloneButton').on('click', TargetNS.ShowCloneDialog);
        $('#ImportButton').on('click', TargetNS.ShowImportDialog);

        Webservice = Core.Config.Get('Webservice');

        $('#ProviderTransportProperties').on('click', function() {
            TargetNS.Redirect(Webservice.Transport, 'ProviderTransportList', {CommunicationType: 'Provider'});
        });

        $('#RequesterTransportProperties').on('click', function() {
            TargetNS.Redirect(Webservice.Transport, 'RequesterTransportList', {CommunicationType: 'Requester'});
        });

        $('#OperationList').on('change', function() {
            TargetNS.Redirect(Webservice.Operation, 'OperationList', {OperationType: $(this).val()});
        });

        $('#InvokerList').on('change', function() {
            TargetNS.Redirect(Webservice.Invoker, 'InvokerList', {InvokerType: $(this).val()});
        });

        $('.HideTrigger').on('change', function(){
            TargetNS.HideElements();
        });

        $('#ProviderErrorHandling').on('change', function() {
            TargetNS.Redirect(Webservice.ErrorHandling, 'ProviderErrorHandling', {
                CommunicationType: 'Provider',
                ErrorHandlingType: $(this).val()
            });
        });

        $('#RequesterErrorHandling').on('change', function() {
            TargetNS.Redirect(Webservice.ErrorHandling, 'RequesterErrorHandling', {
                CommunicationType: 'Requester',
                ErrorHandlingType: $(this).val()
            });
        });

        // initialize the table sorting feature
        $('.ErrorHandlingPriority tbody').sortable({
            create: function () {

                // enumerate rows on page load
                var Count = 1;
                $(this).find("tr td:first-child").each(function() {
                    $(this).text(Count);
                    Count++;
                });
            },
            stop: function () {

                var $Widget = $(this).closest('.WidgetSimple'),
                    Count = 1,
                    Priority = [];

                // re-enumerate rows after sorting actions
                $(this).find("tr td:first-child").each(function() {
                    $(this).text(Count);
                    Count++;
                });

                $(this).find("tr").each(function() {
                    if ($(this).attr('id')) {
                        Priority.push($(this).attr('id'));
                    }
                });

                if (Priority.length > 1) {

                    $Widget.addClass('Loading');

                    Core.AJAX.FunctionCall(
                        Core.Config.Get('Baselink'),
                        $(this).closest('table').data('query-string') + ';Priority=' + JSON.stringify(Priority),
                        function() {

                            $Widget.removeClass('Loading');

                            $Widget.find('h2')
                                   .before('<i class="fa fa-check"></i>')
                                   .prev('.fa-check')
                                   .hide()
                                   .css('float', 'right')
                                   .css('margin-right', '5px')
                                   .css('margin-top', '3px')
                                   .css('color', '#666666')
                                   .delay(200)
                                   .fadeIn(function() {
                                $(this).delay(1500).fadeOut();
                            });
                        }
                    );
                }
            }
        }).disableSelection();

        $('#SaveAndFinishButton').on('click', function(){
            $('#ReturnToWebservice').val(1);
        });

        // Initialize delete action dialog events
        $('.DeleteOperation').each(function() {
            $(this).on('click', TargetNS.ShowDeleteActionDialog);
        });
        $('.DeleteInvoker').each(function() {
            $(this).on('click', TargetNS.ShowDeleteActionDialog);
        });
    };

    /**
     * @name ShowDeleteDialog
     * @memberof Core.Agent.Admin.GenericInterfaceWebservice
     * @function
     * @param {Object} Event - The browser event object, e.g. of the clicked DOM element.
     * @description
     *      Shows a confirmation dialog to delete the web service.
     */
    TargetNS.ShowDeleteDialog = function(Event){
        Core.UI.Dialog.ShowContentDialog(
            $('#DeleteDialogContainer'),
            Core.Language.Translate('Delete web service'),
            '240px',
            'Center',
            true,
            [
                {
                     Label: Core.Language.Translate('Cancel'),
                     Function: function () {
                         Core.UI.Dialog.CloseDialog($('#DeleteDialog'));
                     }
                },

                {
                     Label: Core.Language.Translate('Delete'),
                     Function: function () {
                         var Data = {
                             Action: 'AdminGenericInterfaceWebservice',
                             Subaction: 'Delete',
                             WebserviceID: TargetNS.WebserviceID
                         };

                         Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {
                             if (!Response || !Response.Success) {
                                 alert(Core.Language.Translate('An error occurred during communication.'));
                                 return;
                             }

                             Core.App.InternalRedirect({
                                 Action: Data.Action,
                                 DeletedWebservice: Response.DeletedWebservice
                             });
                         }, 'json');

                     }
                }
            ]
        );

        Event.stopPropagation();
    };

    /**
     * @name ShowCloneDialog
     * @memberof Core.Agent.Admin.GenericInterfaceWebservice
     * @function
     * @param {Object} Event - The browser event object, e.g. of the clicked DOM element.
     * @description
     *      Shows a dialog to clone a web service.
     */
    TargetNS.ShowCloneDialog = function(Event){

        var CurrentDate, CloneName;

        Core.UI.Dialog.ShowContentDialog(
            $('#CloneDialogContainer'),
            Core.Language.Translate('Clone web service'),
            '240px',
            'Center',
            true
        );

        // init validation
        // Currently we have not a function to initialize the validation on a single form
        Core.Form.Validate.Init();

        // get current system time to define suggested the name of the cloned web service
        CurrentDate = new Date();
        CloneName = $('#Name').val() + "-" + CurrentDate.getTime();

        // set the suggested name
        $('.CloneName').val(CloneName);

        // bind button actions
        $('#CancelCloneButtonAction').on('click', function() {
            Core.UI.Dialog.CloseDialog($('#CloneDialog'));
        });

        $('#CloneButtonAction').on('click', function() {
            $('#CloneForm').submit();
        });

        Event.stopPropagation();
    };

    /**
     * @name ShowImportDialog
     * @memberof Core.Agent.Admin.GenericInterfaceWebservice
     * @function
     * @param {Object} Event - The browser event object, e.g. of the clicked DOM element.
     * @description
     *      Shows a dialog to import a web service.
     */
    TargetNS.ShowImportDialog = function(Event){

        Core.UI.Dialog.ShowContentDialog(
            $('#ImportDialogContainer'),
            Core.Language.Translate('Import web service'),
            '240px',
            'Center',
            true
        );

        // init validation
        // Currently we have not a function to initialize the validation on a single form
        Core.Form.Validate.Init();

        $('#CancelImportButtonAction').on('click', function() {
            Core.UI.Dialog.CloseDialog($('#ImportDialog'));
        });

        $('#ImportButtonAction').on('click', function() {
            $('#ImportForm').submit();
        });

        Event.stopPropagation();
    };

    /**
     * @name Redirect
     * @memberof Core.Agent.Admin.GenericInterfaceWebservice
     * @function
     * @param {String} Config
     * @param {String} DataSource
     * @param {Object} Data
     * @description
     *      Redirects.
     */
    TargetNS.Redirect = function(Config, DataSource, Data) {
        var WebserviceConfigPart, Action, ConfigElement;

        // get configuration
        // after JS refactoring this is most probably already a config object
        // and not a config key anymore
        // keeping the old part for backwards compatibility (can be removed later)
        if (typeof Config === 'object') {
            WebserviceConfigPart = Config;
        }
        else {
            WebserviceConfigPart = Core.Config.Get(Config);
        }

        // get the Config Element name, if none it will have "null" value
        ConfigElement = $('#' + DataSource).val();

        // check is config element is a valid scring
        if (ConfigElement !== null) {

            // get action
            Action = WebserviceConfigPart[ ConfigElement ];

            $.extend(Data, {
                Action: Action,
                Subaction: 'Add',
                WebserviceID: TargetNS.WebserviceID
            });

            // redirect to correct url
            Core.App.InternalRedirect(Data);
        }
    };

    /**
     * @name ShowDeleteActionDialog
     * @memberof Core.Agent.Admin.GenericInterfaceWebservice
     * @function
     * @param {Object} Event - The browser event object, e.g. of the clicked DOM element.
     * @description
     *      Shows a dialog to delete operation or invoker.
     */
    TargetNS.ShowDeleteActionDialog = function(Event){
        var ActionType, ActionName, DialogTitle, Target;

        // If event target is trash can, change it to parent instead.
        if ($(Event.target).hasClass('fa')) {
            Target = $(Event.target).parent();
        }
        else {
            Target = $(Event.target);
        }

        if (Target.hasClass('DeleteOperation')) {
            ActionType = 'Operation';
            ActionName = Target.attr('id').substring(15);
            DialogTitle = Core.Language.Translate('Delete operation');
        }
        else {
            ActionType = 'Invoker';
            ActionName = Target.attr('id').substring(13);
            DialogTitle = Core.Language.Translate('Delete invoker');
        }

        Core.UI.Dialog.ShowContentDialog(
            $('#Delete' + ActionType + 'DialogContainer'),
            DialogTitle,
            '240px',
            'Center',
            true,
            [
               {
                   Label: Core.Language.Translate('Cancel'),
                   Class: 'Primary',
                   Function: function () {
                       Core.UI.Dialog.CloseDialog($('#Delete' + ActionType + 'Dialog'));
                   }
               },
               {
                   Label: Core.Language.Translate('Delete'),
                   Function: function () {
                       var Data = {
                            Action: 'AdminGenericInterfaceWebservice',
                            Subaction: 'DeleteAction',
                            WebserviceID: TargetNS.WebserviceID,
                            ActionType: ActionType,
                            ActionName: ActionName
                        };
                        Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {
                            if (!Response || !Response.Success) {
                                alert(Core.Language.Translate('An error occurred during communication.'));
                                return;
                            }

                            Core.App.InternalRedirect({
                                Action: Data.Action,
                                Subaction: 'Change',
                                WebserviceID: TargetNS.WebserviceID
                            });

                        }, 'json');

                       Core.UI.Dialog.CloseDialog($('#Delete' + ActionType + 'Dialog'));
                   }
               }
           ]
        );

        Event.stopPropagation();
        Event.preventDefault();
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.GenericInterfaceWebservice || {}));
