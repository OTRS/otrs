// --
// Core.Customer.js - provides functions for the customer login
// Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};

/**
 * @namespace
 * @exports TargetNS as Core.Customer
 * @description
 *      This namespace contains all form functions.
 */
Core.Customer = (function (TargetNS) {
    if (!Core.Debug.CheckDependency('Core.Customer', 'Core.UI', 'Core.UI')) {
        return;
    }
    if (!Core.Debug.CheckDependency('Core.Customer', 'Core.Form', 'Core.Form')) {
        return;
    }
    if (!Core.Debug.CheckDependency('Core.Customer', 'Core.Form.Validate', 'Core.Form.Validate')) {
        return;
    }
    if (!Core.Debug.CheckDependency('Core.Customer', 'Core.UI.Accessibility', 'Core.UI.Accessibility')) {
        return;
    }

    /**
     * @function
     * @return nothing
     *      This function initializes the application and executes the needed functions
     */
    TargetNS.Init = function () {
        var $TableElements = $('table.Overview tbody tr');

        Core.Exception.Init();

        Core.Form.Validate.Init();
        Core.UI.Popup.Init();
        // Add table functions here (because of performance reasons only do this if table has not more than 200 rows)
        if ($TableElements.length < 200) {
            $TableElements.filter(':nth-child(even)').addClass('Even');
        }
        // late execution of accessibility code
        Core.UI.Accessibility.Init();

        // Init tree selection/tree view for dynamic fields
        Core.UI.TreeSelection.InitTreeSelection();
        Core.UI.TreeSelection.InitDynamicFieldTreeViewRestore();
    };

    /**
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
     * @function
     * @description
     *      This function adds the class 'JavaScriptAvailable' to the 'Body' div to enhance the interface (clickable rows).
     */
    TargetNS.Enhance = function(){
        $('body').removeClass('NoJavaScript').addClass('JavaScriptAvailable');
    };

    TargetNS.InitFocus = function(){
        $('input[type="text"]').first().focus();
    };

    return TargetNS;
}(Core.Customer || {}));
