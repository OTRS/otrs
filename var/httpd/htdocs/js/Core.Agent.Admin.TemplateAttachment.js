// --
// Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
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
 * @namespace Core.Agent.Admin.TemplateAttachment
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module function for TemplateAttachment selection.
 */
 Core.Agent.Admin.TemplateAttachment = (function (TargetNS) {

    /*
    * @name Init
    * @memberof Core.Agent.Admin.TemplateAttachment
    * @function
    * @description
    *      This function initializes filter and "SelectAll" actions.
    */
    TargetNS.Init = function () {

        // initialize "SelectAll" checkbox and bind click event on "SelectAll" for each relation item
        Core.Form.InitSelectAllCheckboxes($('table td input[type="checkbox"][name=ItemsSelected]'), $('#SelectAllItemsSelected'));

        $('input[type="checkbox"][name=ItemsSelected]').click(function () {
            Core.Form.SelectAllCheckboxes($(this), $('#SelectAllItemsSelected'));
        });

        // initialize table filters
        Core.UI.Table.InitTableFilter($("#FilterTemplates"), $("#Templates"));
        Core.UI.Table.InitTableFilter($("#FilterAttachments"), $("#Attachments"));
        Core.UI.Table.InitTableFilter($("#Filter"), $("#TemplateAttachment"));
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.TemplateAttachment || {}));
