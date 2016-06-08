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
 * @namespace Core.Agent.Admin.Attachment
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module function for Attachment module.
 */
 Core.Agent.Admin.Attachment = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Admin.Attachment
     * @function
     * @description
     *      This function initializes the table filter.
     */
    TargetNS.Init = function () {
        Core.UI.Table.InitTableFilter($("#FilterAttachments"), $("#Attachments"));

        // bind click function to remove button
        $('#Attachments a.TrashCan').on('click', function () {
            if (window.confirm(Core.Language.Translate('Do you really want to delete this attachment?'))) {
                return true;
            }
            return false;
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
 }(Core.Agent.Admin.Attachment || {}));
