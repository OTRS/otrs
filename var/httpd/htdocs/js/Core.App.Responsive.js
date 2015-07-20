// --
// Copyright (C) 2001-2013 OTRS AG, http://otrs.org/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.App = Core.App || {};

/**
 * @namespace Core.App.Responsive
 * @memberof Core.App
 * @author OTRS AG
 * @description
 *      This namespace contains the responsive functionality.
 */
Core.App.Responsive = (function (TargetNS) {
    /**
     * @private
     * @name ActiveScreenSize
     * @memberof Core.App.Responsive
     * @member {String}
     * @description
     *      The name of the active screen size, one of ScreenSizes
     */
    var ActiveScreenSize = 'ScreenXL',

    /**
     * @private
     * @name ScreenSizes
     * @memberof Core.App.Responsive
     * @member {Object}
     * @description
     *      All available screen sizes and their dependencies,
     *      Value-Array describes the screen sizes, that are bigger.
     *      Read it like: ScreenSize "Key" is smaller than the value-list of screen sizes.
     */
        ScreenSizes = {
            'ScreenXS': ['ScreenS', 'ScreenM', 'ScreenL', 'ScreenXL'],
            'ScreenS': ['ScreenM', 'ScreenL', 'ScreenXL'],
            'ScreenM': ['ScreenL', 'ScreenXL'],
            'ScreenL': ['ScreenXL'],
            'ScreenXL': []
        };

    /**
     * @private
     * @name GetAllScreenClasses
     * @memberof Core.App.Responsive
     * @function
     * @returns {Array} List of class names, based on screen sizes (prefixed with 'Visible-').
     * @description
     *      Returns an array of class names based on the available screen sizes.
     */
    function GetAllScreenClasses() {
        var Classes = [],
            Key;

        for(Key in ScreenSizes) {
            Classes.push('Visible-' + Key);
        }

        return Classes;
    }

    /**
     * @private
     * @name CheckScreenResolution
     * @memberof Core.App.Responsive
     * @function
     * @description
     *      Checks which is the active screen size and fires the matching events.
     *      Additionally sets the screen size body class.
     */
    function CheckScreenResolution() {
        var $ResponsiveFooter = $('#ResponsiveFooter'),
            AllClasses = GetAllScreenClasses().join(' '),
            Key, i;

        Core.App.Publish('Event.App.Responsive.CheckScreenResolution');

        // check visibility of responsive footer elements
        for (Key in ScreenSizes) {
            if ($ResponsiveFooter.find('.Visible-' + Key).is(':visible') && Key !== ActiveScreenSize) {
                ActiveScreenSize = Key;
                break;
            }
        }

        // set correct body class
        if (!$('body').hasClass('Visible-' + ActiveScreenSize)) {
            $('body')
                .removeClass(AllClasses)
                .addClass('Visible-' + ActiveScreenSize);

            // publish the events for this screen size only if it was not
            // the same screen size before.
            Core.App.Publish('Event.App.Responsive.' + ActiveScreenSize);
            Core.App.Publish('Event.App.Responsive.SmallerOrEqual' + ActiveScreenSize);

            // publish event for "SmallerOrEqual" screen sizes
            for (i = 0; i < ScreenSizes[ActiveScreenSize].length; i++) {
                Core.App.Publish('Event.App.Responsive.SmallerOrEqual' + ScreenSizes[ActiveScreenSize][i]);
            }
        }
    }

    /**
     * @name GetScreenSize
     * @memberof Core.App.Responsive
     * @function
     * @returns {String} The active screen size.
     * @description
     *      Returns the active screen size.
     */
    TargetNS.GetScreenSize = function () {
        return ActiveScreenSize;
    };

    /**
     * @name IsSmallerOrEqual
     * @memberof Core.App.Responsive
     * @function
     * @returns {Boolean} True, if ScreenSize is smaller than or equal to CompareSize, false otherwise.
     * @param {String} ScreenSize - The first screen size name.
     * @param {String} CompareSize - The screen size to compare the first ScreenSite with.
     * @description
     *      Checks if the given ScreenSize is smaller than or equal to CompareSize, based on the
     *      screen size names.
     */
    TargetNS.IsSmallerOrEqual = function (ScreenSize, CompareSize) {
        var i;

        if (ScreenSize === CompareSize) {
            return true;
        }

        for(i = 0; i < ScreenSizes[ScreenSize].length; i++) {
            if (ScreenSizes[ScreenSize][i] === CompareSize) {
                return true;
            }
        }

        return false;
    };

    /**
     * @name CheckIfTouchDevice
     * @memberof Core.App.Responsive
     * @function
     * @description
     *      Checks, if this is a touch device and adds a class to the body.
     */
    TargetNS.CheckIfTouchDevice = function () {
        if (('ontouchstart' in window) || (navigator.msMaxTouchPoints > 0)) {
            $('body').addClass('TouchDevice');
        }
    };

    /**
     * @name IsTouchDevice
     * @memberof Core.App.Responsive
     * @function
     * @returns {Boolean} True if a touch devices was detected, false otherwise
     * @description
     *      Checks, if this is a touch device and adds a class to the body.
     */
    TargetNS.IsTouchDevice = function () {
        return ($('body').hasClass('TouchDevice'));
    };

    /**
     * @name Init
     * @memberof Core.App.Responsive
     * @function
     * @description
     *      Initialize all responsive functionalities.
     */
    TargetNS.Init = function () {
        var TimeoutID = 0;

        // Check DesktopMode
        /*eslint-disable no-window*/
        if ((top.location.href !== location.href && window.name.search(/^OTRSPopup_/) === -1) || parseInt(localStorage.getItem("DesktopMode"), 10) > 0) {
            /*eslint-enable no-window*/

            // if the DesktopMode has been triggered manually, we add a switch to the footer
            // for switching back to mobile mode
            if (!$('#ViewModeSwitch').length) {
                $('#Footer').append('<div id="ViewModeSwitch"><a href="#">' + Core.Config.Get('ViewModeSwitchMobile') + '</a></div>');
                $('#ViewModeSwitch').on('click.Responsive', function() {
                    localStorage.setItem("DesktopMode", 0);
                    location.reload();
                    return false;
                });
            }

            // In DesktopMode, all responsive pubsub events should not be initialized.
            // body gets class Visible-ScreenXL to "emulate" desktop behaviour
            $('body').addClass('Visible-ScreenXL');
            return;
        }

        $(window).on('resize', function () {
            clearTimeout(TimeoutID);
            TimeoutID = window.setTimeout(function () {
                CheckScreenResolution();
            }, 50);
        });

        Core.App.Subscribe('Event.App.Responsive.ScreenXS', function () {
        });

        Core.App.Subscribe('Event.App.Responsive.SmallerOrEqualScreenXS', function () {
        });

        Core.App.Subscribe('Event.App.Responsive.ScreenS', function () {
        });

        Core.App.Subscribe('Event.App.Responsive.SmallerOrEqualScreenS', function () {
        });

        Core.App.Subscribe('Event.App.Responsive.ScreenM', function () {
        });

        Core.App.Subscribe('Event.App.Responsive.SmallerOrEqualScreenM', function () {
        });

        Core.App.Subscribe('Event.App.Responsive.ScreenL', function () {
        });

        Core.App.Subscribe('Event.App.Responsive.SmallerOrEqualScreenL', function () {

        });

        Core.App.Subscribe('Event.App.Responsive.ScreenXL', function () {

        });

        Core.App.Subscribe('Event.App.Responsive.SmallerOrEqualScreenXL', function () {
        });

        CheckScreenResolution();
    };

    return TargetNS;

}(Core.App.Responsive || {}));
