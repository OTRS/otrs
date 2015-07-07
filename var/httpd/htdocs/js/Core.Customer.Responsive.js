// --
// Copyright (C) 2001-2013 OTRS AG, http://otrs.org/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.Customer = Core.Customer || {};

/**
 * @namespace Core.Customer.Responsive
 * @memberof Core.Customer
 * @author OTRS AG
 * @description
 *      This namespace contains the responsive functionality.
 */
Core.Customer.Responsive = (function (TargetNS) {

    Core.App.Subscribe('Event.App.Responsive.SmallerOrEqualScreenL', function () {

        // Add switch for Desktopmode
        if (!$('#ViewModeSwitch').length) {
            $('#Footer').append('<div id="ViewModeSwitch"><a href="#">' + Core.Config.Get('ViewModeSwitchDesktop') + '</a></div>');
            $('#ViewModeSwitch a').on('click.Responsive', function() {
                localStorage.setItem("DesktopMode", 1);
                location.reload(true);
                return false;
            });
        }

        // wrap sidebar modules with an additional container
        if (!$('.ResponsiveSidebarContainer').length) {
            $('#ZoomSidebar, #Navigation').wrap('<div class="ResponsiveSidebarContainer" />');
        }

        // make sure the relevant sidebar is being collapsed on clicking
        // on the background
        $('.ResponsiveSidebarContainer').off().on('click', function(Event) {

            // only react on a direct click on the background
            if (Event.target !== this) {
                return;
            }

            // check if the navigation container is currently invisible, in this
            // case the other container is expanded and we need to use the relevant trigger
            if (parseInt($('#Navigation').css('left'), 10) < 0 || parseInt($('#Navigation').css('left'), 10) === 10) {
                $('#ResponsiveSidebarHandle').trigger('click');
            }
            else {
                $('#ResponsiveNavigationHandle').trigger('click');
            }
        });

        // add handle for for navigation
        if (!$('#MainBox').hasClass('Login') && !$('#ResponsiveNavigationHandle').length) {
            $('#Header').append('<a id="ResponsiveNavigationHandle" href="#"><i class="fa fa-bars"></i></a>');
        }

        // add navigation sidebar expansion handling
        $('#ResponsiveNavigationHandle').off().on('click', function() {
            if (parseInt($('#Navigation').css('left'), 10) < 0 || parseInt($('#Navigation').css('left'), 10) === 10) {
                $('#ResponsiveSidebarHandle').animate({
                    'right': '-45px'
                });
                $('#Navigation').closest('.ResponsiveSidebarContainer').fadeIn();
                $('html').addClass('NoScroll');
                $('#Navigation').animate({
                    'left': '0px'
                });
            }
            else {
                $('#ResponsiveSidebarHandle').animate({
                    'right': '21px'
                });
                $('#Navigation').closest('.ResponsiveSidebarContainer').fadeOut();
                $('html').removeClass('NoScroll');
                $('#Navigation').animate({
                    'left': '-300px'
                });
            }
            return false;
        });

        // add sidebar handling
        if ($('#ZoomSidebar').length && !$('#ResponsiveSidebarHandle').length) {
            $('#Header').append('<a id="ResponsiveSidebarHandle" href="#"><i class="fa fa-caret-square-o-left"></i></a>');
        }

        // add sidebar column expansion handling
        $('#ResponsiveSidebarHandle').off().on('click', function() {
            if (parseInt($('#ZoomSidebar').css('right'), 10) < 0) {
                $('#ResponsiveNavigationHandle').animate({
                    'left': '-45px'
                });
                $('#ZoomSidebar').closest('.ResponsiveSidebarContainer').fadeIn();
                $('html').addClass('NoScroll');
                $('#ZoomSidebar').animate({
                    'right': '0px'
                });
            }
            else {
                $('#ResponsiveNavigationHandle').animate({
                    'left': '21px'
                });
                $('#ZoomSidebar').closest('.ResponsiveSidebarContainer').fadeOut();
                $('html').removeClass('NoScroll');
                $('#ZoomSidebar').animate({
                    'right': '-300px'
                });
            }
            return false;
        });

    });

    Core.App.Subscribe('Event.App.Responsive.ScreenXL', function () {

        // remove view mode switch
        $('#ViewModeSwitch').remove();
    });

    return TargetNS;

}(Core.Customer.Responsive || {}));
