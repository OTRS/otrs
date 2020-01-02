// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

/*global Clipboard */

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};
Core.Agent.Admin = Core.Agent.Admin || {};

/**
 * @namespace Core.Agent.Admin.SystemConfiguration
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special function for AdminSystemConfiguration module.
 */
 Core.Agent.Admin.SystemConfiguration = (function (TargetNS) {

     /**
      * @name OpenSearchDialog
      * @memberof Core.Agent.Admin.SystemConfiguration
      * @function
      * @description
      *      This function open the search dialog after clicking on "search" button in nav bar.
      */
     TargetNS.OpenSearchDialog = function () {

         var Data = {
             Action    : 'AdminSystemConfiguration',
             Subaction : 'SearchDialog',
             Term      : $('#SystemConfigurationEditSearch').data('term'),
             Category  : $('#SystemConfigurationEditSearch').data('category')
         };

         Core.UI.Dialog.ShowContentDialog('<div class="Spacing Center"><span class="AJAXLoader" title="' + Core.Language.Translate('Loading...') + '"></span></div>', Core.Language.Translate('Loading...'), '10px', 'Center', true);

         Core.AJAX.FunctionCall(
             Core.Config.Get('CGIHandle'),
             Data,
             function (HTML) {

                 // if the waiting dialog was cancelled, do not show the search
                 //  dialog as well
                 if (!$('.Dialog:visible').length) {
                     return;
                 }
                 Core.UI.Dialog.ShowContentDialog(HTML, Core.Language.Translate('Search the System Configuration'), '10px', 'Center', true);

                 // register return key
                 $('.AdminSystemConfigurationSearchForm').off('keypress.FilterInput').on('keypress.FilterInput', function (Event) {
                     if ((Event.charCode || Event.keyCode) === 13) {
                         $('#SearchFormSubmit').trigger('click');
                         return false;
                     }
                 });

                 $('#SearchFormSubmit').off('click.StartSearch').on('click.StartSearch', function() {

                     if (!$('.AdminSystemConfigurationSearchForm input[name=Search]').val()) {
                         alert(Core.Language.Translate('Please enter at least one search word to find anything.'));
                         return false;
                     }

                     $('.AdminSystemConfigurationSearchForm').submit();
                     Core.UI.Dialog.ShowContentDialog('<div class="Spacing Center"><span class="AJAXLoader" title="' + Core.Language.Translate('Loading...') + '"></span></div>', Core.Language.Translate('Loading...'), '10px', 'Center', true);
                 });

             }, 'html'
         );
     };

     /**
     * @public
     * @name InitDialogDeployment
     * @memberof Core.Agent.Admin.SystemConfiguration
     * @function
     * @description
     *      This function initializes Deployment Dialog
     */
    TargetNS.InitDialogDeployment = function() {

        function DeploymentLock() {

            var $DialogObj = $('#DialogDeployment'),
                $DialogFooterObj = $DialogObj.closest('.Dialog').find('.ContentFooter');

            // show the preparation dialog
            $DialogFooterObj.children('div').hide();
            $DialogObj.find('.Overlay.Preparing i.Error').hide();
            $DialogObj.find('.Overlay.Preparing i.Active').fadeIn();
            $DialogObj.find('.Overlay.Preparing em').text(Core.Language.Translate("Preparing to deploy, please wait..."));

            Core.AJAX.FunctionCall(
                Core.Config.Get('Baselink') + 'Action=AdminSystemConfigurationDeployment;Subaction=AJAXDeploymentIsLocked',
                {},
                function(Response) {

                    var $DialogObj = $('#DialogDeployment'),
                        $DialogFooterObj = $DialogObj.closest('.Dialog').find('.ContentFooter');

                    // Response will be 1 in case of a successful lock
                    // and -1 in case of an error (which probably means that
                    // another user has already locked the deployment to them)
                    if (Response && parseInt(Response, 10) === -1) {
                        $DialogObj.find('.Overlay.Preparing').fadeOut();
                        $DialogObj.find('#DeploymentComment').fadeIn();
                        $DialogFooterObj.find('.ButtonsRegular').fadeIn();
                    }
                    else {

                        $DialogObj.find('.Overlay.Preparing i.Active').hide();
                        $DialogObj.find('.Overlay.Preparing i.Error').fadeIn();
                        $DialogObj.find('.Overlay.Preparing em').text(Core.Language.Translate("Unfortunately deploying is currently not possible, maybe because another agent is already deploying. Please try again later."));
                        $DialogFooterObj.find('.ButtonsTryAgain').fadeIn();
                        $DialogFooterObj.find('.ButtonsTryAgain button').off('click.TryAgain').on('click.TryAgain', function() {
                            DeploymentLock();
                        });
                    }
                }
            );
        }

        $('#DeploymentStart').off('click.OpenDeploymentDialog').on('click.OpenDeploymentDialog', function() {

            var DialogTemplate = Core.Template.Render('SysConfig/DialogDeployment'),
                $DialogObj = $(DialogTemplate);

            DeploymentLock();

            Core.UI.Dialog.ShowContentDialog($DialogObj, Core.Language.Translate('Deploy'), '100px', 'Center', true);
            Core.UI.InitWidgetActionToggle();
            Core.Form.Validate.Init();

            $('.CloseDialog').off('click.CloseDeploymentDialog').on('click.CloseDeploymentDialog', function() {
                Core.UI.Dialog.CloseDialog($('.Dialog:visible'));
            });

            $('#Deploy').off('click.Deploy').on('click.Deploy', function() {

                var URL = Core.Config.Get('Baselink') + 'Action=AdminSystemConfigurationDeployment;Subaction=AJAXDeployment',
                    Data = {
                        Comments         : $('#DeploymentComment').val(),
                        SelectedSettings : $('#SelectedSettings').val(),
                        AdvancedMode     : $('#AdvancedMode').val()
                    },
                    $DialogContentObj = $(this).closest('.Dialog').find('.InnerContent'),
                    $DialogFooterObj = $(this).closest('.Dialog').find('.ContentFooter');

                if (Data.Comments.length > 250) {
                    return false;
                }

                if ($DialogContentObj.hasClass('Deploying')) {
                    alert(Core.Language.Translate('The deployment is already running.'));
                    return false;
                }

                $DialogContentObj.addClass('Deploying').find('.Overlay').fadeIn();
                $DialogContentObj.find('.Overlay i.Active').fadeIn();

                Core.AJAX.FunctionCall(
                    URL,
                    Data,
                    function(Response) {

                        // Show only close button and remove 'Deploying' state
                        $DialogContentObj.removeClass('Deploying');
                        $DialogFooterObj.find('.ButtonsRegular').hide();

                        // success
                        if (Response && Response.Result && Response.Result.Success == 1) {

                            $DialogContentObj.find('.Overlay i.Active').hide();
                            $DialogContentObj.find('.Overlay i.Success').fadeIn();
                            $DialogContentObj.find('em').text(
                                Core.Language.Translate("Deployment successful. You're being redirected...")
                            );

                            window.setTimeout(function() {

                                if (!Response.RedirectURL) {
                                    Core.App.InternalRedirect({
                                        'Action' : 'AdminSystemConfiguration'
                                    });
                                }
                                else {
                                    window.location.href = Core.Config.Get('Baselink') + Response.RedirectURL;
                                }
                            }, 1000);
                        }
                        // error
                        else {

                            $DialogFooterObj.find('.ButtonsFinish').show();
                            $DialogContentObj.find('.Overlay i.Active').hide();
                            $DialogContentObj.find('.Overlay i.Error').fadeIn();
                            $DialogContentObj.find('em').text(
                                Core.Language.Translate('There was an error. Please save all settings you are editing and check the logs for more information.')
                            );
                        }

                        if (Response && Response.Result && Response.Result.Error !== undefined) {
                            $DialogContentObj.find('em').after(
                                Response.Result.Error
                            );
                        }
                    }
                );

                return false;
            });

            return false;
        });
    };

    /**
     * @public
     * @name InitDialogReset
     * @memberof Core.Agent.Admin.SystemConfiguration
     * @function
     * @param {jQueryObject} $Object - jquery object.
     * @description
     *      This function initializes Reset Dialog
     */
    TargetNS.InitDialogReset = function($Object) {
        var DialogTemplate,
            $DialogObj,
            URL,
            Data,
            Name,
            ModificationAllowed = $Object.attr("data-user-modification"),
            OTRSBusinessIsInstalled = parseInt(Core.Config.Get('OTRSBusinessIsInstalled'), 10);

        Name = $Object.closest(".WidgetSimple").find(".Header h2").text();
        DialogTemplate = Core.Template.Render('SysConfig/DialogReset',{
            Name: Name,
            ModificationAllowed: ModificationAllowed,
            OTRSBusinessIsInstalled: OTRSBusinessIsInstalled
        });
        $DialogObj = $(DialogTemplate);

        Core.UI.Dialog.ShowContentDialog($DialogObj, Core.Language.Translate('Reset setting'), '150px', 'Center', true);


        // Check how many users have changed it's value
        if ($Object.attr("data-user-modification") == "1" && OTRSBusinessIsInstalled == "1") {
            URL = Core.Config.Get('Baselink') + 'Action=AdminSystemConfiguration;Subaction=UserModificationsCount';
            Data = {
                Name: Name,
            },

            Core.AJAX.FunctionCall(
                URL,
                Data,
                function(Response) {
                    if (Response == "") {
                        Response = 0;
                    }

                    $(".UserModificationCount")
                        .html(Response)
                        .parent()
                        .removeClass("Hidden")
                        .parent()
                        .find("i")
                        .addClass("Hidden");
                }
            );
        }

        $("button#ResetConfirm").off("click").on("click", function() {
            var ResetOptions = $("#ResetOptions").val();

            // Validation
            if(ResetOptions == "") {
                alert(Core.Language.Translate("Reset option is required!"));
                return;
            }
            Core.UI.Dialog.CloseDialog($(".Dialog"));
            Core.SystemConfiguration.SettingReset($Object, ResetOptions);
        });

        $("button.CloseDialog").off("click").on("click", function() {
            Core.UI.Dialog.CloseDialog($(".Dialog"));
        });
    }

    /**
     * @public
     * @name Cancel
     * @memberof Core.Agent.Admin.SystemConfiguration
     * @function
     * @param {jQueryObject} $Object - jquery object.
     * @description
     *      This function handles click on the Cancel button
     */
    TargetNS.Cancel = function ($Object) {
        var $Link = $Object.closest(".WidgetSimple").find("a.SettingEdit");
        Unlock($Link);
    }

    /**
     * @public
     * @name InitSettingListCompare
     * @memberof Core.Agent.Admin.SystemConfiguration
     * @function
     * @description
     *      This function initializes Deployment History Details
     */
    TargetNS.InitSettingListCompare = function() {

        function ToggleCheckbox($CheckBoxObj, DirectClick) {

            var SettingsList = [];

            $CheckBoxObj.closest('.SettingContainer').toggleClass('Selected');
            if (!DirectClick) {
                $CheckBoxObj.prop("checked", !$CheckBoxObj.prop("checked"));
            }

            // check if there are any selected settings left
            if ($('.SettingsList.Compare.Deployment h2 input[type=checkbox]:checked').length) {
                $('button#DeploymentStart').removeClass('Disabled').prop('disabled', false);
            }
            else {
                $('button#DeploymentStart').addClass('Disabled').prop('disabled', true);
            }

            // update the list of to-be-deployed settings
            $('.SettingsList.Compare.Deployment h2 input[type=checkbox]:checked').each(function() {
                SettingsList.push($(this).val());
            });
            $('#SelectedSettings').val(Core.JSON.Stringify(SettingsList));
        }

        // toggle setting selection
        $('.SettingsList.Compare.Deployment .Header').on('click', function(Event) {
            if (Event.originalEvent.target.nodeName.toLowerCase() === 'input') {
                return false;
            }
            ToggleCheckbox($(this).find('input[type=checkbox]'));
        });

        // toggle setting selection (directly on checkbox)
        $('.SettingsList.Compare.Deployment h2 input[type=checkbox]').on('click', function(Event) {
            ToggleCheckbox($(this), true);
            Event.stopPropagation();
        });

        $('.SettingsList.Compare.Deployment h2 a').on('click', function(Event) {
            Event.stopPropagation();
        });

        // toggle comparison
        $('.WidgetAction.CompareAll a').on('click', function() {

            if ($(this).hasClass('Active')) {
                $('.WidgetAction.Compare a.Active').trigger('click');
                $(this).removeClass('Active');
            }
            else {
                $(this).addClass('Active');
                $('.WidgetAction.Compare a:not(.Active)').trigger('click');
            }

            return false;
        });

        $('.WidgetAction.Compare a').on('click', function() {

            if ($(this).hasClass('Active')) {

                $(this).removeClass('Active');
                $(this).closest('.SettingContainer').removeClass('Comparing');
                $(this).closest('li').find('.SettingOld h2 .Label, .SettingNew h2 .Label').fadeOut();
                $(this).closest('li').find('.SettingOld').animate({
                    'width' : '0px'
                }, function() {
                    $(this).css('height', '0px');
                });
                $(this).closest('li').find('.SettingNew').animate({
                    'width' : '100%'
                });

                $(this).closest('li').find('.WidgetMessage').slideUp();
            }
            else {

                $(this).addClass('Active');
                $(this).closest('.SettingContainer').addClass('Comparing');
                $(this).closest('li').find('.SettingNew').animate({
                    'width' : '50%'
                });
                $(this).closest('li').find('.SettingOld').css('height', 'auto').animate({
                    'width' : '50%'
                }, function() {
                    $(this).closest('li').find('.SettingOld h2 .Label, .SettingNew h2 .Label').fadeIn();
                });

                $(this).closest('li').find('.WidgetMessage').slideDown(function() {

                    // go through all attributes and check if the values are different between old and new
                    $(this).closest('.SettingNew').find('.WidgetMessage p').each(function() {

                        var Class = $(this).attr('class'),
                            ValueNew = $(this).find('strong').text(),
                            ValueOld = $(this).closest('.SettingContainer').find('.SettingOld .WidgetMessage p.' + Class).find('strong').text();

                        if (ValueNew != ValueOld) {
                            $(this).find('strong').addClass('Different');
                        }
                    });


                });
            }

            return false;
        });

    };

    /**
     * @public
     * @name InitGroupView
     * @memberof Core.Agent.Admin.SystemConfiguration
     * @function
     * @param {Boolean} IsAjax - IsAjax.
     * @description
     *      This function initializes Group View
     */
    TargetNS.InitGroupView = function(IsAjax) {

        Core.UI.Table.InitTableFilter($("#FilterSettings"), $(".SettingsList"));

        // Expand the actionmenu on click on the header
        $('.WidgetSimple.Setting .Header').on('click', function(Event) {
            if (Event.originalEvent.target.nodeName.toLowerCase() === 'a') {
                return true;
            }

            $(this).find('.WidgetAction.Expand').trigger('click');
            Event.stopPropagation();
            Event.preventDefault();
        });

        // Show expanded mode
        $('.WidgetAction.Expand').on('click CloseWidgetMenu', function() {

            var $WidgetObj = $(this).closest('.WidgetSimple'),
                $DefaultObj = $WidgetObj.find('.WidgetMessage.Bottom'),
                OriginalPadding = parseInt($WidgetObj.find('.Content').css('padding-bottom'), 10);

            if ($WidgetObj.hasClass('MenuExpanded')) {
                $WidgetObj.find('.WidgetMenu').slideUp('fast')
                $WidgetObj.removeClass('MenuExpanded');

                if ($DefaultObj.length) {
                    $WidgetObj.find('.Content').animate({
                        'padding-bottom' : parseInt($WidgetObj.data('original-padding'), 10)
                    }, 'fast');
                    $DefaultObj.slideUp('fast');
                }
            }
            else {
                $WidgetObj.find('.WidgetMenu').slideDown('fast');
                $WidgetObj.addClass('MenuExpanded');

                if ($DefaultObj.length) {
                    $WidgetObj.data('original-padding', OriginalPadding);
                    $WidgetObj.find('.Content').animate({
                        'padding-bottom' : OriginalPadding + $DefaultObj.height()
                    }, 'fast');
                    $DefaultObj.slideDown('fast');
                }
            }
            return false;
        });

        // Lock Setting
        $("a.SettingEdit").on("click", function(){
            Edit($(this));
            return false;
        });

        $("a.EditAlias").on("click", function(){
            $(this).closest('.WidgetSimple').find('a.SettingEdit').trigger('click');
            return false;
        });

        $("a.CancelAlias").on("click", function(){
            $(this).closest('.WidgetSimple').find('.SettingUpdateBox button.Cancel').trigger('click');
            return false;
        });

        $("a.SaveAlias").on("click", function(){
            $(this).closest('.WidgetSimple').find('.SettingUpdateBox button.Update').trigger('click');
            return false;
        });

        $(".SettingUpdateBox .Update").on("click", function () {
            Core.SystemConfiguration.Update($(this), 0, 0);
            return false;
        });

        $(".SettingUpdateBox .Cancel").on("click", function () {
            TargetNS.Cancel($(this));
            return false;
        });

        $(".Validate_DateMonth:disabled").each(function() {
            $(this).parent().find(".DatepickerIcon").hide();
        });

        $('#SaveAll').on('click', function() {
            $('.Setting.IsLockedByMe:visible').find('button.Update').trigger('click');
            return false;
        });

        $('#EditAll').on('click', function() {
            $('.Setting:not(.IsDisabled):not(.IsLockedByAnotherUser):not(.IsLockedByMe):visible').find('a.SettingEdit').trigger('click');
            return false;
        });

        $('#CancelAll').on('click', function() {
            $('.Setting.IsLockedByMe:visible').find('button.Cancel').trigger('click');
            return false;
        });

        // Check each 2 minutes if there are updated settings
        if (IsAjax === undefined || !IsAjax) {
            setInterval(function(){
                CheckSettings();
            }, 10000);
        }

        // Init setting toggle
        $(".SettingDisabled, .SettingEnabled, .SettingEnable").on('click', function () {
            EnableModification($(this));
            Core.SystemConfiguration.Update($(this), 1, 0);
            return false;
        });

        if (parseInt(Core.Config.Get('OTRSBusinessIsInstalled'), 10) == "1") {
            $(".UserModificationActive, .UserModificationNotActive").on('click', function () {
                EnableModification($(this));
                Core.SystemConfiguration.Update($(this), 0, 1);
                return false;
            });
        }
    };

    /**
    * @name InitClipboard
    * @memberof Core.Agent.Admin.SystemConfiguration
    * @function
    * @description
    *      Inits the clipboard function on all buttons with a certain class.
    *      This is meant for copying a direct link to a certain setting to clipboard.
    */
    TargetNS.InitClipboard = function() {

        var SysconfigClipboard = new Clipboard('.Button.CopyToClipboard');

        SysconfigClipboard.on('success', function(Event) {

            $(Event.trigger).find('i.fa-link').fadeOut(function() {
                $(this).after('<i class="fa fa-check" style="display: none;"></i>').next('i').fadeIn(function() {
                    $(this).delay(1000).fadeOut(function() {
                        $(this).prev('i').fadeIn();
                        $(this).remove();
                    })
                });
            });

            Event.clearSelection();
        });
    };

    /**
    * @name InitFavourites
    * @memberof Core.Agent.Admin.SystemConfiguration
    * @function
    * @description
    *      Add and remove settings from favourites for the current user.
    */
    TargetNS.InitFavourites = function() {

        if ($('.WidgetSimple .Setting').length) {
            $('#UserWidgetState_SystemConfiguration_Help, #UserWidgetState_SystemConfiguration_Sticky').removeClass('Hidden');
        }

        // Remove a setting from favourites.
        $('.Setting').off('click.RemoveFromFavourites').on('click.RemoveFromFavourites', '.Button.RemoveFromFavourites', function() {

            var $TriggerObj = $(this),
                SettingName = $TriggerObj.data('setting-name'),
                Data = {
                    Action: 'AgentPreferences',
                    Subaction: 'UserSystemConfigurationFavourites'
                },
                Index;

            Core.AJAX.FunctionCall(Core.Config.Get('Baselink'), Data, function (Response) {

                if (Response.length === 0 || !SettingName) {
                    return false;
                }

                // Remove SettingName from an array of favourites.
                Index = Response.indexOf(SettingName);
                if (Response.length > 0 && Index > -1) {
                    Response.splice(Index, 1);
                }

                // Update preferences.
                Core.Agent.PreferencesUpdate('UserSystemConfigurationFavourites', JSON.stringify(Response), function() {

                    if (Core.Config.Get('Subaction') === 'Favourites') {
                        $TriggerObj.closest('.Setting').fadeOut(function() {
                            $(this).remove();
                        });
                    }
                    else {
                        $TriggerObj.removeClass('RemoveFromFavourites').addClass('AddToFavourites').find('span').animate({ 'opacity': '0' }, function() {
                            $(this).text(Core.Language.Translate('Add to favourites'));
                            $TriggerObj.find('span').animate({ 'opacity': '1' });
                        });
                        $TriggerObj.find('i.fa-star').fadeOut(function() {
                            $(this).after('<i class="fa fa-check" style="display: none;"></i>').next('i').fadeIn(function() {
                                $(this).delay(1000).fadeOut(function() {
                                    $(this).prev('i').removeClass('fa-star').addClass('fa-star-o').fadeIn();
                                    $(this).remove();
                                })
                            });
                        });
                    }
                });

                return false;

            }, 'json');
        });

        // Add a setting to favourites.
        $('.Setting').off('click.AddToFavourites').on('click.AddToFavourites', '.Button.AddToFavourites', function() {

            var $TriggerObj = $(this),
                SettingName = $TriggerObj.data('setting-name'),
                Data = {
                    Action: 'AgentPreferences',
                    Subaction: 'UserSystemConfigurationFavourites'
                };

            Core.AJAX.FunctionCall(Core.Config.Get('Baselink'), Data, function (Response) {

                if (!Response || !SettingName || Response.indexOf(SettingName) > -1) {
                    return false;
                }

                // Add SettingName to an array of favourites.
                Response.push(SettingName);

                // Update preferences
                Core.Agent.PreferencesUpdate('UserSystemConfigurationFavourites', JSON.stringify(Response), function() {

                    $TriggerObj.removeClass('AddToFavourites').addClass('RemoveFromFavourites').find('span').animate({ 'opacity': '0' }, function() {
                        $(this).text(Core.Language.Translate('Remove from favourites'));
                        $TriggerObj.find('span').animate({ 'opacity': '1' });
                    });
                    $TriggerObj.find('i.fa-star-o').fadeOut(function() {
                        $(this).after('<i class="fa fa-check" style="display: none;"></i>').next('i').fadeIn(function() {
                            $(this).delay(1000).fadeOut(function() {
                                $(this).prev('i').removeClass('fa-star-o').addClass('fa-star').fadeIn();
                                $(this).remove();
                            })
                        });
                    });
                });

                return false;

            }, 'json');
        });
    };

    /**
    * @name InitDeploymentRestore
    * @memberof Core.Agent.Admin.SystemConfiguration
    * @function
    * @description
    *      Bind event on deployment restore button.
    */
    TargetNS.InitDeploymentRestore = function() {

        $('.DeploymentRestore').on('click', function (Event) {

            if (window.confirm(Core.Language.Translate("By restoring this deployment all settings will be reverted to the value they had at the time of the deployment. Do you really want to continue?"))) {

                return true;
            }

            // don't interfere with MasterAction
            Event.stopPropagation();
            Event.preventDefault();
            return false;
        });
    };

    /**
    * @name InitAutoComplete
    * @memberof Core.Agent.Admin.SystemConfiguration
    * @function
    * @description
    *      Use autocomplete for the search field on the sysconfig home page
    */
    TargetNS.InitAutoComplete = function() {

        var $Input = $('#SearchBoxAutoComplete input[type=text]');

        Core.UI.Autocomplete.Init($Input, function (Request, Response) {
            var URL = Core.Config.Get('Baselink'), Data = {
                Action: 'AdminSystemConfiguration',
                Subaction: 'AJAXSearch',
                Term: Request.term,
                MaxResults: Core.UI.Autocomplete.GetConfig('MaxResultsDisplayed')
            };

            $Input.data('AutoCompleteXHR', Core.AJAX.FunctionCall(URL, Data, function (Result) {
                var ValueData = [];
                $Input.removeData('AutoCompleteXHR');
                $.each(Result, function (index, name) {
                    ValueData.push({
                        label: name,
                        value: name
                    });
                });
                Response(ValueData);
            }));
        }, function (Event, UI) {

            $Input.val(UI.item.value).next('.AJAXLoader').show();
            Core.App.InternalRedirect({
                'Action' : 'AdminSystemConfiguration',
                'Subaction' : 'View',
                'Setting' :  UI.item.value
            });
        });
    };

    /**
    * @name Init
    * @memberof Core.Agent.Admin.SystemConfiguration
    * @function
    * @description
    *      This function initializes module functionality.
    */
    TargetNS.Init = function () {

        TargetNS.InitDialogDeployment();
        Core.SystemConfiguration.InitConfigurationTree('AdminSystemConfigurationGroup');
        TargetNS.InitClipboard();
        TargetNS.InitFavourites();
        TargetNS.InitDeploymentRestore();
        TargetNS.InitAutoComplete();

        if (Core.Config.Get('Action') === 'AdminSystemConfiguration' || Core.Config.Get('Action') === 'AdminSystemConfigurationGroup') {

            $('.WidgetAction.Toggle a').on('click', function() {

                var $WidgetObj = $(this).closest('.WidgetSimple'),
                    WidgetID = $WidgetObj.attr('id');

                // save the state of this certain widget
                if (WidgetID) {
                    Core.Agent.PreferencesUpdate(WidgetID, ($(this).closest('.WidgetSimple').hasClass('Expanded')) ? '1' : '0');
                }

                // recalculate the position of the fixed help widget
                Core.UI.InitStickyElement();
            });

            Core.UI.InitStickyElement();
        }

        if (
            Core.Config.Get('Action') === 'AdminSystemConfigurationGroup' ||
                (
                    Core.Config.Get('Action') === 'AdminSystemConfiguration' && (
                        Core.Config.Get('Subaction') === 'Search'
                        || Core.Config.Get('Subaction') === 'SearchLocked'
                        || Core.Config.Get('Subaction') === 'View'
                        || Core.Config.Get('Subaction') === 'Favourites'
                        || Core.Config.Get('Subaction') === 'ViewCustomGroup'
                        || Core.Config.Get('Subaction') === 'Invalid'
                    )
                )
            )
        {
            TargetNS.InitGroupView();
        }

        if (Core.Config.Get('Subaction') === 'Deployment'
            || Core.Config.Get('Subaction') === 'DeploymentHistoryDetails'
            || Core.Config.Get('Action') === 'AdminSystemConfigurationSettingHistory'
        ) {
            TargetNS.InitSettingListCompare();
        }

        $('#SystemConfigurationEditSearch').on('click', function() {
            $('#Navigation a.Search').trigger('click');
            return false;
        });

        $('#Category').on('change', function() {
            var ParagraphHeight = $('#ConfigTree').height(),
                SelectedCategory = $(this).val();

            Core.Agent.PreferencesUpdate('UserSystemConfigurationCategory', SelectedCategory);

            $('#ConfigTree').html('<p class="Center"><i class="fa fa-spinner fa-spin"></i></p>');
            $('#ConfigTree > p').css('line-height', ParagraphHeight + 'px');
            Core.SystemConfiguration.InitConfigurationTree('AdminSystemConfigurationGroup', SelectedCategory);
        });

        $('.SystemConfigurationCategories + a').on('click', function() {
            var HTML = Core.Template.Render('SysConfig/HelpDialog');
            Core.UI.Dialog.ShowContentDialog(HTML, Core.Language.Translate('Help'), '200px', 'Center', true);
            return false;
        });

        $('.GoBackButton').on('click', function() {
            window.history.back();
            return false;
        });

        // show a custom title tooltip for disabled keys to let users understand why some keys cant be edited
        $('.SettingsList').on('mouseenter', 'input.Key[readonly]', function() {
            $(this).data('original-title', $(this).attr('title'));
            $(this).attr('title', Core.Language.Translate('Keys with values can\'t be renamed. Please remove this key/value pair instead and re-add it afterwards.'));
        });
        $('.SettingsList').on('mouseleave', 'input.Key[readonly]', function() {
            var OriginalTitle = $(this).data('original-title');
            if (OriginalTitle) {
                $(this).attr('title', $(this).data('original-title'));
                $(this).removeData('original-title');
            }
        });

        // toggle hidden checkboxes on click of WorkingHoursItems
        $('.ContentColumn').on('click', '.WorkingHoursItem', function() {

            var $CheckboxObj = $(this).find('input[type=checkbox]');
            if (!$(this).closest('.WidgetSimple.Setting').hasClass('IsLockedByMe')) {
                return false;
            }

            if ($CheckboxObj.prop('checked')) {
                $(this).removeClass('Checked');
                $CheckboxObj.prop('checked', false);
            }
            else {
                $(this).addClass('Checked');
                $CheckboxObj.prop('checked', true);
            }
        });

        Core.UI.Table.InitTableFilter($('#FilterDeployments'), $('#Deployments'));
    };

    /**
    * @private
    * @name Edit
    * @memberof Core.Agent.Admin.SystemConfiguration
    * @function
    * @param {jQueryObject} $Object - jquery object.
    * @description
    *      This function handles click on the Edit link.
    */
    function Edit($Object) {
        // Skip if another AJAX is already active.
        if ($Object.closest(".WidgetSimple").hasClass("HasOverlay")) {
            return;
        }

        if ($Object.hasClass("Locked")) {
            // try to unlock
            Unlock($Object);
        }
        else {
            // try to lock
            Lock($Object);
        }
    }

    /**
     * @private
     * @name Unlock
     * @memberof Core.Agent.Admin.SystemConfiguration
     * @function
     * @param {jQueryObject} $Object - jquery object.
     * @description
     *      This function unlocks the setting.
     */
    function Unlock($Object) {

        var $Widget = $Object.closest(".WidgetSimple"),
            $SettingName = $Widget.find("input[name='SettingName']"),
            Data = "Action=AdminSystemConfigurationGroup;Subaction=Unlock;";

        Data += 'SettingName=' + encodeURIComponent($SettingName.val()) + ';';

        // show loader
        Core.UI.WidgetOverlayShow($Widget, 'Loading');

        Core.AJAX.FunctionCall(
            Core.Config.Get('Baselink'),
            Data,
            function(Response) {

                $("#fieldset" + $Object.attr("data-id")).html(Response.Data.HTMLStrg);

                // remove old Icon class
                $Object.find("i").removeClass();
                $Object.removeClass();

                // set new class
                $Object.find("i").addClass("fa fa-pencil-square-o");
                $Object.addClass("SettingEdit Unlocked");

                $Object.attr("title", Core.Language.Translate("Edit this setting"));

                if (Response.Data.HTMLStrg.indexOf("<select") > -1) {
                    Core.UI.InputFields.Activate($("#fieldset" + $Object.attr("data-id")));
                }

                // Remove old Error
                $Object
                    .closest(".WidgetSimple")
                    .find(".Error")
                    .remove();

                // hide loader
                Core.UI.WidgetOverlayHide($Widget);

                Core.SystemConfiguration.CleanWidgetClasses($Widget);

                // check which classes to add
                if (Response.Data.SettingData.IsModified) {
                    $Widget.addClass('IsModified');
                }

                if (Response.Data.SettingData.IsDirty) {
                    $Widget.addClass('IsDirty');
                }

                if (Response.Data.SettingData.IsLocked) {
                    $Widget.addClass('IsLockedByAnotherUser');
                }

                if ($Widget.hasClass('MenuExpanded')) {
                    $Widget.find('.WidgetMessage.Bottom').show();
                }

                Core.App.Publish('SystemConfiguration.SettingListUpdate');
            }
        );
    }

    /**
     * @private
     * @name Lock
     * @memberof Core.Agent.Admin.SystemConfiguration
     * @function
     * @param {jQueryObject} $Object - jquery object.
     * @description
     *      This function locks the setting.
     */
    function Lock($Object) {
        var
            $Widget = $Object.closest(".WidgetSimple"),
            $SettingName = $Widget.find("input[name='SettingName']"),
            Data = "Action=AdminSystemConfigurationGroup;Subaction=Lock;";

        Data += 'SettingName=' + encodeURIComponent($SettingName.val()) + ';';

        // show loader
        Core.UI.WidgetOverlayShow($Widget, 'Loading');

        Core.AJAX.FunctionCall(
            Core.Config.Get('Baselink'),
            Data,
            function(Response) {

                if (Response.Error != null) {
                    alert(Response.Error);
                    // hide loader
                    Core.UI.WidgetOverlayHide($Widget);
                    return;
                }
                $("#fieldset" + $Object.attr("data-id")).html(Response.Data.HTMLStrg);

                if(!Response.Data.SettingData.Error) {
                    // remove old Icon class
                    $Object.find("i").removeClass();
                    $Object.removeClass();

                    // set new class
                    $Object.find("i").addClass("fa fa-unlock");
                    $Object.addClass("SettingEdit Locked");

                    $Object.attr("title", Core.Language.Translate("Unlock setting."));

                    $Widget.find(".Update").on("click", function () {
                        Core.SystemConfiguration.Update($(this), 0, 0);
                    });

                    $Widget.find(".Cancel").on("click", function () {
                        TargetNS.Cancel($(this));
                        return false;
                    });

                    Core.SystemConfiguration.InitButtonVisibility($Widget);
                }

                if (Response.Data.HTMLStrg.indexOf("<select") > -1) {
                    Core.UI.InputFields.Activate($("#fieldset" + $Object.attr("data-id")));
                }

                $Widget.find("input:checkbox")
                    .on("change", function() {
                        Core.SystemConfiguration.CheckboxValueSet($(this));
                    });

                // Remove old Error
                $Widget
                    .find(".Error")
                    .remove();

                if (Response.Data.SettingData.Error) {
                    // Add new Error
                    $Widget
                        .find(".WidgetMessage")
                        .after(Response.Data.SettingData.Error);

                    $Object.closest(".WidgetAction").hide();
                }

                $Widget.find("button.RemoveButton").on("click", function() {
                    $(this).blur();
                    Core.SystemConfiguration.RemoveItem($(this));
                });

                $Widget.find("button.AddArrayItem").on("click", function() {
                    $(this).blur();
                    Core.SystemConfiguration.AddArrayItem($(this));
                });
                $Widget.find("button.AddHashKey").on("click", function() {
                    $(this).blur();
                    Core.SystemConfiguration.AddHashKeyClick($(this));
                });

                // check which classes to add
                if (Response.Data.SettingData.IsModified) {
                    $Widget.find("a.ResetSetting").show().on("click", function() {
                        TargetNS.InitDialogReset($(this));
                    });
                }

                if ($Widget.hasClass('MenuExpanded')) {
                    $Widget.find('.WidgetMessage.Bottom').show();
                }

                // hide loader
                Core.UI.WidgetOverlayHide($Widget);
                $Widget.addClass('IsLockedByMe');

                // focus the first visible input field
                $Widget.find('input[type=text]:not(.InputField_Search):visible').first().focus();

                Core.App.Publish('SystemConfiguration.SettingListUpdate');
            }
        );
    }

    /**
     * @private
     * @name CheckSettings
     * @memberof Core.Agent.Admin.SystemConfiguration
     * @function
     * @param {jQueryObject} $Object - jquery object.
     * @description
     *      This function updates unlocked settings.
     */
    function CheckSettings() {
        var URL,
            Data,
            IsLockedByAnotherUser,
            Settings = [];

        // get all unlocked settings on the page
        $("ul.SettingsList .WidgetSimple:not(.IsLockedByMe) .SettingContainer").each(function() {
            IsLockedByAnotherUser = 0;
            if ($(this).closest(".WidgetSimple").hasClass("IsLockedByAnotherUser")) {
                IsLockedByAnotherUser = 1;
            }

            Data = {};
            Data["SettingName"] = $(this).find("> input").val();
            Data["ChangeTime"] = $(this).find(".Setting").attr("data-change-time");
            Data["IsLockedByAnotherUser"] = IsLockedByAnotherUser;

            Settings.push(Data);
        });

        URL = Core.Config.Get('Baselink') +
            "Action=AdminSystemConfigurationGroup;Subaction=CheckSettings;" +
            'ChallengeToken=' + Core.Config.Get('ChallengeToken');

        // check for updates
        Core.AJAX.FunctionCall(
            URL,
            {
                Settings: Core.JSON.Stringify(Settings)
            },
            function(Response) {
                var ArrayIndex,
                    Setting,
                    $Widget;

                if (Response.Error) {
                    alert(Response.Error);
                    return;
                }

                for (ArrayIndex in Response.Data) {
                    // check if user already locked the setting
                    Setting = Response.Data[ArrayIndex];

                    $Widget = $("#Setting" + Setting.SettingData.DefaultID +":not(.IsLockedByMe)");
                    if($Widget.length > 0) {

                        // Update setting
                        Core.SystemConfiguration.SettingRender(
                            {
                                Data: Setting
                            },
                            $Widget
                        );

                        if (Setting.SettingData.IsLockedByAnotherUser) {
                            $Widget.addClass("IsLockedByAnotherUser");

                            if ($Widget.find("> .Content > .LockedByAnotherUser").length == 0) {
                                $Widget.find("> .Content").prepend('<div class="LockedByAnotherUser"></div>');
                            }
                        }
                        else {
                            $Widget.removeClass("IsLockedByAnotherUser");
                            $Widget.find("> .Content > .LockedByAnotherUser").remove();
                        }

                        if (Setting.SettingData.IsModified) {
                            $Widget.addClass("IsModified");
                        }
                        else {
                            $Widget.removeClass("IsModified");
                        }

                        if (Setting.SettingData.IsDirty) {
                            $Widget.addClass("IsDirty");
                        }
                        else {
                            $Widget.removeClass("IsDirty");
                        }
                    }
                }
            }
        );
    }

    /**
     * @private
     * @name EnableModification
     * @memberof Core.Agent.Admin.SystemConfiguration
     * @function
     * @param {jQueryObject} $Object - jquery object.
     * @description
     *      This function removes "disabled" attribute in the form items.
     */
    function EnableModification($Object) {
        $Object.closest(".WidgetSimple")
            .find("form :disabled")
            .each(function(){
                $(this).removeAttr("disabled");
            });
    }

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.SystemConfiguration || {}));
