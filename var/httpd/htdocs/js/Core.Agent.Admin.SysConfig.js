// --
// Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};
Core.Agent.Admin = Core.Agent.Admin || {};

/**
 * @namespace Core.Agent.Admin.SysConfig
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the SysConfig module.
 */
Core.Agent.Admin.SysConfig = (function (TargetNS) {
    /**
     * @name Init
     * @memberof Core.Agent.Admin.SysConfig
     * @function
     * @description
     *      Initializes SysConfig screen.
     */
    TargetNS.Init = function () {
        $('#AdminSysConfig h3 input[type="checkbox"]').click(function () {
            $(this).parent('h3').parent('fieldset').toggleClass('Invalid');
        });

        // don't allow editing disabled fields
        $('#AdminSysConfig').on('focus', '.Invalid input', function() {
            $(this).blur();
        });

        // bind function to SysConfigGroup dropdown
        $('#SysConfigGroup').bind('change', function(){
            $('#SysConfigGroupForm').submit();
        });

        // enable dialog if explanation string is too long
        $('fieldset > p.Description').each(function() {

            var MaxLength = 200,
                Length = $(this).text().length,
                FullText,
                OverlayTitle = $(this)
                    .closest('fieldset')
                    .find('h3')
                    .find('label')
                    .text();

            // if the full description text is too long, cut it and
            // show a "info" button which will open a dialog.
            if (Length > MaxLength && Length > MaxLength + 100) {

                FullText  = $(this).text();
                $(this).text(FullText.substr(0, MaxLength) + '...');

                // Repair string for correct displaying the overlay message - bug#11913
                FullText = FullText.replace(/</g, '&lt;').replace(/>/g, '&gt;');

                $(this)
                    .append('&nbsp;<a href="#" class="DescriptionOverlay">' + Core.Language.Translate("Show more") + '</a>')
                    .find('a.DescriptionOverlay')
                    .bind('click', function() {

                        Core.UI.Dialog.ShowDialog({
                            Modal: true,
                            Title: OverlayTitle,
                            HTML: '<div style="padding: 15px; line-height: 150%; width: 550px;">' + FullText + '</div>',
                            PositionTop: '100px',
                            PositionLeft: 'Center',
                            CloseOnEscape: true,
                            CloseOnClickOutside: true
                        });

                        return false;
                    });
            }
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.SysConfig || {}));
