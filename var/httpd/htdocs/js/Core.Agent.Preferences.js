// --
// Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};

/**
 * @namespace Core.Agent.Preferences
 * @memberof Core.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the AgentPreferences module.
 */
Core.Agent.Preferences = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Preferences
     * @function
     * @description
     *      This function initializes the module functionality.
     */
    TargetNS.Init = function () {
        Core.SystemConfiguration.InitConfigurationTree('AgentPreferences', null, 1);

        // make sure user has chosen at least one transport for mandatory notifications
        $('tr.Mandatory .NotificationEvent').closest('form').off().on('submit', function(Event) {
            $(this).find('tr.Mandatory').each(function() {
                var FoundEnabled = false;
                $(this).find('.NotificationEvent').each(function() {
                    if ($(this).prop('checked')) {
                        FoundEnabled = true;
                    }
                });

                // if there is not at least one transport enabled, omit the actions
                if (!FoundEnabled) {
                    alert(Core.Language.Translate("Sorry, but you can't disable all methods for notifications marked as mandatory."));
                    Event.preventDefault();
                    Event.stopPropagation();
                    return false;
                }
            });
        });

        $('.NotificationEvent').on('click', function(Event){
            var FoundEnabled = false,
                $TargetObj = $(this).parent().find('input[type=hidden]');

            // if the user is trying to disable this transport, go through all transport checkboxes
            // for this notification and check if at least one of them is checked
            if (!$(this).prop('checked') && $(this).closest('tr').hasClass('Mandatory')) {

                $(this).closest('tr.Mandatory').find('.NotificationEvent').each(function() {
                    if ($(this).prop('checked')) {
                        FoundEnabled = true;
                        return true;
                    }
                });

                // if there is not at least one transport enabled, omit the actions
                if (!FoundEnabled) {
                    alert(Core.Language.Translate("Sorry, but you can't disable all methods for this notification."));
                    Event.stopPropagation();
                    return false;
                }
            }

            if ($TargetObj.val() == 0){
                $TargetObj.val(1);
            }
            else{
                $TargetObj.val(0);
            }
        });

        // update classic preferences
        $('.PreferenceClassic button.Update').on('click', function() {

            var $FormObj = $(this).closest('form'),
                $WidgetObj = $(this).closest('.WidgetSimple'),
                $ButtonObj = $(this);

            Core.UI.WidgetOverlayShow($WidgetObj, 'Loading');

            Core.AJAX.FunctionCall(
                Core.Config.Get('Baselink') + 'ChallengeToken=' + Core.Config.Get('ChallengeToken'),
                Core.AJAX.SerializeForm($FormObj),
                function(Response) {

                    if (Response) {
                        if (Response.Priority === 'Error') {

                            // if there is already a message box, replace the content
                            if ($WidgetObj.find('.WidgetMessage').length) {
                                $WidgetObj.find('.WidgetMessage').text(Core.Language.Translate(Response.Message));
                            }
                            else {
                                $WidgetObj.find('.Content').before('<div class="WidgetMessage Top Error" style="display: none;"></div>');
                                $WidgetObj.find('.WidgetMessage').text(Core.Language.Translate(Response.Message));
                                $WidgetObj.find('.WidgetMessage').slideDown().delay(5000).slideUp(function() {
                                    $(this).remove();
                                });
                            }

                            Core.UI.WidgetOverlayHide($WidgetObj);
                        }
                        else {
                            Core.UI.WidgetOverlayHide($WidgetObj, true);
                        }
                    }
                    else {

                        if ($WidgetObj.find('.WidgetMessage').length) {
                            $WidgetObj.find('.WidgetMessage').text(Core.Language.Translate(Response.Message));
                        }
                        else {
                            $WidgetObj.find('.Content').before('<div class="WidgetMessage Top Error" style="display: none;"></div>');
                            $WidgetObj.find('.WidgetMessage').text(Core.Language.Translate('An unknown error ocurred. Please contact the administrator.'));
                            $WidgetObj.find('.WidgetMessage').slideDown().delay(5000).slideUp(function() {
                                $(this).remove();
                            });
                        }

                        Core.UI.WidgetOverlayHide($WidgetObj);
                    }

                    // clear up password fields
                    if ($WidgetObj.find('input[type=password]').length) {
                        $WidgetObj.find('input[type=password]').val('');
                    }

                    $ButtonObj.blur();
                }
            );

            return false;
        });

        $('#ToggleView').on('click', function() {
            if ($(this).hasClass('Grid')) {
                Core.Agent.PreferencesUpdate('AgentPreferencesView', 'List');
                $('.GridView').fadeOut();
                $('.ListView').fadeIn(function() {

                    // check if the "no matches found" message is the only visible entry
                    if ($('.ListView .DataTable tbody tr:visible').length == 1 && $('.ListView .DataTable tbody tr:visible').hasClass('FilterMessage')) {
                        $('.ListView .DataTable tr.FilterMessage').removeClass('Hidden');
                    }
                    else {
                        $('.ListView .DataTable tr.FilterMessage').hide();
                    }
                    $('#ToggleView').removeClass('Grid').addClass('List');
                });
            }
            else {
                Core.Agent.PreferencesUpdate('AgentPreferencesView', 'Grid');
                $('.ListView').fadeOut();
                $('.GridView').fadeIn(function() {
                    $('#ToggleView').removeClass('List').addClass('Grid');
                });
            }
        });


        Core.UI.Table.InitTableFilter($("#FilterSettings"), $(".SettingsList"));
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Preferences || {}));
