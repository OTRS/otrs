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
 * @namespace Core.Agent.Admin.PackageManager
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special function for AdminPackageManager module.
 */
 Core.Agent.Admin.PackageManager = (function (TargetNS) {

    var StatusNotificationText = Core.Language.Translate('There is a package upgrade process running, click here to see status information about the upgrade progress.'),
        FinisedNotificationText = Core.Language.Translate('A package upgrade was recently finished. Click here to see the results.');

    /**
      * @name GetPackageUpgradeResult
      * @memberof Core.Agent.Admin.PackageManager
      * @function
      * @description
      *      This function queries the status of the package upgrade process (via AJAX request) from the system data table.
      */
    TargetNS.GetPackageUpgradeResult = function() {
         var Data = {
             Action    : 'AdminPackageManager',
             Subaction : 'AJAXGetPackageUpgradeResult',
        },
        DialogTemplate;

        Core.AJAX.FunctionCall(
            Core.Config.Get('CGIHandle'),
            Data,
            function (Response) {
                if (!Response || !Response.Success) {
                    Core.UI.Dialog.ShowAlert(
                        Core.Language.Translate('An error occurred during communication.'),
                        Core.Language.Translate('No response from get package upgrade result.')
                    );
                    return false;
                }

                DialogTemplate = Core.Template.Render('PackageManager/InformationDialog', {
                    PackageList: Response.PackageList,
                    UpgradeStatus: Response.UpgradeStatus,
                    UpgradeSuccess: Response.UpgradeSuccess,
                });

                // When finish, do not allow to click outside to close, instead show a button to actively remove data.
                if (Response.UpgradeStatus === 'Finished') {
                    Core.UI.Dialog.ShowDialog({
                        HTML: DialogTemplate,
                        Title: Core.Language.Translate('Update all packages'),
                        Modal: true,
                        CloseOnClickOutside: false,
                        CloseOnEscape: false,
                        PositionTop: '10px',
                        PositionLeft: 'Center',
                        AllowAutoGrow: true,
                        Buttons: [
                            {
                                Label: Core.Language.Translate('Dismiss'),
                                Function: function () {
                                    Core.AJAX.FunctionCall(
                                        Core.Config.Get('CGIHandle'),
                                        'Action=' + 'AdminPackageManager' + ';Subaction=AJAXDeletePackageUpgradeData;',
                                        function (Response) {

                                        if (!Response || !Response.Success) {
                                            alert(Core.Language.Translate("An error occurred during communication."));
                                        }
                                        Core.UI.Dialog.CloseDialog($('.Dialog:visible'));
                                        window.location.reload();
                                    });
                                },
                                Class: 'CallForAction',
                                Type: 'Close',
                            },
                        ]
                    });
                }

                // Otherwise show normal dialog without buttons.
                else {
                    Core.UI.Dialog.ShowContentDialog(DialogTemplate, Core.Language.Translate('Update All Packages'), '100px', 'Center', true);
                }
            }, 'json'
        );
     };

     /**
      * @name PackageUpgradeAll
      * @memberof Core.Agent.Admin.PackageManager
      * @function
      * @description
      *      This function creates a daemon task (via AJAX call) to upgrade all installed packages.
      */
    TargetNS.PackageUpgradeAll = function() {
         var Data = {
             Action    : 'AdminPackageManager',
             Subaction : 'AJAXPackageUpgradeAll',
        };

        Core.AJAX.FunctionCall(
            Core.Config.Get('CGIHandle'),
            Data,
            function (Response) {
                if (!Response || !Response.Success) {
                    Core.UI.Dialog.ShowAlert(
                        Core.Language.Translate('An error occurred during communication.'),
                        Core.Language.Translate('No response from package upgrade all.')
                    );
                    return false;
                }

                TargetNS.DisablePackageActions();
                TargetNS.GetPackageUpgradeRunStatus();
            }, 'json'
        );
     };

     /**
      * @name DisablePackageActions
      * @memberof Core.Agent.Admin.PackageManager
      * @function
      * @description
      *      This function prevent package actions for running.
      */
    TargetNS.DisablePackageActions = function() {
        $('.UpgradeAll').off('click');
        $('.PackageAction').addClass('Disabled').on('click', function(Event){
            Core.UI.Dialog.ShowAlert(
                Core.Language.Translate('Currently not possible'),
                Core.Language.Translate('This is currently disabled because of an ongoing package upgrade.')
            );
            Event.stopPropagation();
            Event.preventDefault();
            return false;
        });
     };

     /**
      * @name EnablePackageActions
      * @memberof Core.Agent.Admin.PackageManager
      * @function
      * @description
      *      Tis function activate all package actions.
      */
    TargetNS.EnablePackageActions = function() {
        $('.PackageAction').removeClass('Disabled').off('click');

        $('.UpgradeAll').off('click.UpgradeAll').on('click.UpgradeAll', function() {

            if (Core.Config.Get('DaemonCheckNotRunning')) {
                Core.UI.Dialog.ShowAlert(
                    Core.Language.Translate('Currently not possible'),
                    Core.Language.Translate('This option is currently disabled because the OTRS Daemon is not running.')
                );
                return false;
            }

            if (window.confirm(Core.Language.Translate("Are you sure you want to update all installed packages?"))) {
                TargetNS.PackageUpgradeAll();
            }

            return false;
        });
    };

     /**
      * @name GetPackageUpgradeRunStatus
      * @memberof Core.Agent.Admin.PackageManager
      * @function
      * @description
      *      This function checks if there is currently a PackageUpgradeAll process running (via AJAX request),
      *         depending on the results it also enable/disable package actions and show/hide notifications.
      */
    TargetNS.GetPackageUpgradeRunStatus = function() {
         var Data = {
             Action    : 'AdminPackageManager',
             Subaction : 'AJAXGetPackageUpgradeRunStatus',
        },
        NotificationType;

        Core.AJAX.FunctionCall(
            Core.Config.Get('CGIHandle'),
            Data,
            function (Response) {
                if (!Response || !Response.Success) {
                    Core.UI.Dialog.ShowAlert(
                        Core.Language.Translate('An error occurred during communication.'),
                        Core.Language.Translate('No response from get package upgrade run status.')
                    );
                    return false;
                }

                /* When the process is running finished notifications needs to be removed and in
                    progress notification has to be shown, all package actions needs to be disabled
                */
                if (Response.IsRunning){
                    TargetNS.DisablePackageActions();

                    Core.UI.HideNotification(FinisedNotificationText, 'Error', undefined);
                    Core.UI.HideNotification(FinisedNotificationText, 'Confirmation', undefined);

                    Core.UI.ShowNotification(
                        StatusNotificationText,
                        'Notice',
                        undefined,
                        function() {
                            $('#PackageUpgradeNotification a').on('click', function(){
                                TargetNS.GetPackageUpgradeResult();
                                return false;
                            });
                        },
                        'PackageUpgradeNotification',
                        'fa-spin fa-circle-o-notch'
                    );
                }
                else {
                    Core.UI.HideNotification(StatusNotificationText, 'Notice', undefined);
                    TargetNS.EnablePackageActions();
                }

                /* When we get the confirmation that the process has finished, progress notification
                    has to be removed and finished notification has to be shown.
                */
                if (Response.UpgradeStatus && Response.UpgradeStatus === 'Finished') {

                    Core.UI.HideNotification(StatusNotificationText, 'Notice', undefined);

                    NotificationType = 'Error';
                    if (Response.UpgradeSuccess && Response.UpgradeSuccess) {
                        NotificationType = 'Confirmation';
                    }

                    Core.UI.ShowNotification(
                        FinisedNotificationText,
                        NotificationType,
                        undefined,
                        function() {
                            $('#PackageUpgradeFinishedNotification a').on('click', function(){
                                TargetNS.GetPackageUpgradeResult();
                                return false;
                            });
                        },
                        'PackageUpgradeFinishedNotification',
                        undefined
                    );
                }
            }, 'json'
        );
     };

    /**
    * @name Init
    * @memberof Core.Agent.Admin.PackageManager
    * @function
    * @description
    *      This function initializes module functionality.
    */
    TargetNS.Init = function () {

        TargetNS.EnablePackageActions();
        TargetNS.GetPackageUpgradeRunStatus();

        setInterval(function(){
                TargetNS.GetPackageUpgradeRunStatus();
        }, 30000);
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.PackageManager || {}));
