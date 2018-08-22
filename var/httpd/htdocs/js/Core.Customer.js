// --
// Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
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
            alert(Core.Config.Get('TurnOffCompatibilityModeMsg'));
        }

        if (!TargetNS.SupportedBrowser) {
            alert(
                Core.Config.Get('BrowserTooOldMsg')
                + ' '
                + Core.Config.Get('BrowserListMsg')
                + ' '
                + Core.Config.Get('BrowserDocumentationMsg')
            );
        }

        Core.Exception.Init();

        Core.Form.Validate.Init();
        Core.UI.Popup.Init();

        // late execution of accessibility code
        Core.UI.Accessibility.Init();

        // Modernize input fields
        Core.UI.InputFields.Init();

        // Init tree selection/tree view for dynamic fields
        Core.UI.TreeSelection.InitTreeSelection();
        Core.UI.TreeSelection.InitDynamicFieldTreeViewRestore();

        // Initialize customer chat request checks in the background.
        if (
            typeof Core.Customer.Chat !== 'undefined'
            && typeof Core.Customer.Chat.Toolbar !== 'undefined'
            && typeof Core.Customer.Chat.Toolbar.Init !== 'undefined'
            )
        {
            Core.Customer.Chat.Toolbar.Init();
        }

        // check if we're on a touch device and on the regular resolution (non-mobile). If that's the case,
        // don't allow triggering the link on "parent" elements directly, they should only expand the sub menu
        Core.App.Responsive.CheckIfTouchDevice();
        $('#Navigation > ul > li > a').on('click', function(Event) {
            if (Core.App.Responsive.IsTouchDevice() && $(this).next('ul:visible').length && Core.App.Responsive.GetScreenSize() === 'ScreenXL') {
                Event.preventDefault();
                Event.stopPropagation();
            }
        });

        // unveil full error details only on click
        $('.TriggerFullErrorDetails').on('click', function() {
            $('.Content.ErrorDetails').toggle();
        });
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

    return TargetNS;
}(Core.Customer || {}));
