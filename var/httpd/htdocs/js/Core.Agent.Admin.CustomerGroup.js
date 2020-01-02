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
 * @namespace Core.Agent.Admin.CustomerGroup
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module function for CustomerGroup selection.
 */
 Core.Agent.Admin.CustomerGroup = (function (TargetNS) {

    /*
    * @name Init
    * @memberof Core.Agent.Admin.CustomerGroup
    * @function
    * @description
    *      This function initializes filter and "SelectAll" actions.
    */
    TargetNS.Init = function () {
        var RelationItems = Core.Config.Get('RelationItems');

        // initialize "SelectAll" checkbox and bind click event on "SelectAll" for each relation item
        if (RelationItems) {
            $.each(RelationItems, function (index) {
                Core.Form.InitSelectAllCheckboxes($('table td input[type="checkbox"][name="' + Core.App.EscapeSelector(RelationItems[index]) + '"]'), $('#SelectAll' + Core.App.EscapeSelector(RelationItems[index])));

                $('input[type="checkbox"][name="' + Core.App.EscapeSelector(RelationItems[index]) + '"]').click(function () {
                    Core.Form.SelectAllCheckboxes($(this), $('#SelectAll' + Core.App.EscapeSelector(RelationItems[index])));
                });
            });
        }

        // initialize table filter
        Core.UI.Table.InitTableFilter($("#FilterGroups"), $("#Group"));
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.CustomerGroup || {}));
