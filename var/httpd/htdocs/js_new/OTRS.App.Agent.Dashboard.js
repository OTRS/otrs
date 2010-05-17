// --
// OTRS.Agent.Dashboard.js - provides the special module functions for TicketZoom
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.App.Agent.Dashboard.js,v 1.5 2010-05-17 10:24:04 mg Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};
OTRS.App = OTRS.App || {};
OTRS.App.Agent = OTRS.App.Agent || {};

/**
 * @namespace
 * @exports TargetNS as OTRS.App.Agent
 * @description
 *      This namespace contains the special module functions for the Dashboard.
 */
OTRS.App.Agent.Dashboard = (function (TargetNS) {
    /**
     * @function
     * @return nothing
     *      This function initializes the special module functions
     */
    TargetNS.Init = function () {
        OTRS.UI.DnD.Sortable(
            $(".SidebarColumn"),
            {
                Handle: '.Header h2',
                Items: '.CanDrag',
                Placeholder: 'DropPlaceholder',
                Tolerance: 'pointer',
                Distance: 15,
                Opacity: 0.6
            }
        );

        OTRS.UI.DnD.Sortable(
            $(".ContentColumn"),
            {
                Handle: '.Header h2',
                Items: '.CanDrag',
                Placeholder: 'DropPlaceholder',
                Tolerance: 'pointer',
                Distance: 15,
                Opacity: 0.6
            }
        );
    };

    /**
     * @function
     * @return nothing
     *      This function binds a click event on an html element to update the preferences of the given dahsboard widget
     * @param {jQueryObject} $ClickedElement The jQuery object of the element(s) that get the event listener
     * @param {string} ElementID The ID of the element whose content should be updated with the server answer
     * @param {jQueryObject} $Form The jQuery object of the form with the data for the server request
     */
    TargetNS.RegisterUpdatePreferences = function ($ClickedElement, ElementID, $Form) {
        if (isJQueryObject($ClickedElement) && $ClickedElement.length) {
            $ClickedElement.click(function () {
                var URL = OTRS.Config.Get('Baselink') + OTRS.AJAX.SerializeForm($Form);
                OTRS.AJAX.ContentUpdate($('#' + ElementID), URL, function () {
                    OTRS.UI.ToggleTwoContainer($('#' + ElementID + '-setting'), $('#' + ElementID));
                    OTRS.UI.Table.InitCSSPseudoClasses();
                });
                return false;
            });
        }
    };

    return TargetNS;
}(OTRS.App.Agent.Dashboard || {}));