// --
// Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};

/**
 * @namespace Core.Customer
 * @memberof Core
 * @author OTRS AG
 * @description
 *      This namespace contains all global functions for the customer interface.
 */
Core.Customer = (function (TargetNS) {
    if (!Core.Debug.CheckDependency('Core.Customer', 'Core.UI', 'Core.UI')) {
        return false;
    }
    if (!Core.Debug.CheckDependency('Core.Customer', 'Core.Form', 'Core.Form')) {
        return false;
    }
    if (!Core.Debug.CheckDependency('Core.Customer', 'Core.Form.Validate', 'Core.Form.Validate')) {
        return false;
    }
    if (!Core.Debug.CheckDependency('Core.Customer', 'Core.UI.Accessibility', 'Core.UI.Accessibility')) {
        return false;
    }
    if (!Core.Debug.CheckDependency('Core.Agent', 'Core.UI.InputFields', 'Core.UI.InputFields')) {
        return false;
    }

    /**
     * @name SupportedBrowser
     * @memberof Core.Customer
     * @member {Boolean}
     * @description
     *     Indicates a supported browser.
     */
    TargetNS.SupportedBrowser = true;

    /**
     * @name IECompatibilityMode
     * @memberof Core.Customer
     * @member {Boolean}
     * @description
     *     IE Compatibility Mode is active.
     */
    TargetNS.IECompatibilityMode = false;

    /**
     * @name Init
     * @memberof Core.Customer
     * @function
     * @description
     *      This function initializes the application and executes the needed functions.
     */
    TargetNS.Init = function () {
        TargetNS.SupportedBrowser = Core.App.BrowserCheck('Customer');
        TargetNS.IECompatibilityMode = Core.App.BrowserCheckIECompatibilityMode();

        if (TargetNS.IECompatibilityMode) {
            TargetNS.SupportedBrowser = false;
            alert(Core.Language.Translate('Please turn off Compatibility Mode in Internet Explorer!'));
        }

        if (!TargetNS.SupportedBrowser) {
            alert(
                Core.Language.Translate('The browser you are using is too old.')
                + ' '
                + Core.Language.Translate('OTRS runs with a huge lists of browsers, please upgrade to one of these.')
                + ' '
                + Core.Language.Translate('Please see the documentation or ask your admin for further information.')
            );
        }

        // unveil full error details only on click
        $('.TriggerFullErrorDetails').on('click', function() {
            $('.Content.ErrorDetails').toggle();
        });

        if (Core.Config.Get('ChatEngine::Active') === '1') {
            TargetNS.InitCheckChatRequests();
        }
    };

    /**
     * @name ClickableRow
     * @memberof Core.Customer
     * @function
     * @description
     *      This function makes the whole row in the MyTickets and CompanyTickets view clickable.
     */
    TargetNS.ClickableRow = function(){
        $("table tr").click(function(){
            window.location.href = $("a", this).attr("href");
            return false;
        });
    };

    /**
     * @name Enhance
     * @memberof Core.Customer
     * @function
     * @description
     *      This function adds the class 'JavaScriptAvailable' to the 'Body' div to enhance the interface (clickable rows).
     */
    TargetNS.Enhance = function(){
        $('body').removeClass('NoJavaScript').addClass('JavaScriptAvailable');
    };

    /**
     * @name InitCheckChatRequests
     * @memberof Core.Customer
     * @function
     * @description
     *      This function checks for new chat requests.
     */
    TargetNS.InitCheckChatRequests = function () {

        window.setInterval(function() {

            var Data = {
                Action: 'CustomerChat',
                Subaction: 'ChatGetOpenRequests'
            };

            Core.AJAX.FunctionCall(
                Core.Config.Get('Baselink'),
                Data,
                function(Response) {
                    if (!Response || parseInt(Response, 10) < 1) {
                        $('.Individual .ChatRequests').fadeOut(function() {
                            $(this).addClass('Hidden');
                        });
                    }
                    else {
                        $('.Individual .ChatRequests')
                            .fadeIn(function() {
                                $(this).removeClass('Hidden');
                            })
                            .find('.Counter')
                            .text(Response);

                        // show tooltip to get the users attention
                        if (!$('.Individual .ChatRequests .ChatTooltip').length) {
                            $('.Individual .ChatRequests')
                                .append('<span class="ChatTooltip">' + Core.Language.Translate("You have unanswered chat requests") + '</span>')
                                .find('.ChatTooltip')
                                .bind('click', function(Event) {
                                    $(this).fadeOut();
                                    Event.stopPropagation();
                                    return false;
                                })
                                .fadeIn();
                        }
                    }
                },
                'json'
            );

        }, 60000);
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_GLOBAL_EARLY');

    return TargetNS;
}(Core.Customer || {}));
