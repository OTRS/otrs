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
 * @namespace Core.Agent.Admin.Group
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for AdminGroup.
 */
Core.Agent.Admin.Group = (function (TargetNS) {

    /**
     * @name Init
     * @memberof CCore.Agent.Admin.Group
     * @function
     * @description
     *      This function initializes the special module functions
     */
    TargetNS.Init = function () {

        Core.Form.Validate.SetSubmitFunction($('form#GroupUpdate'), function(Form) {

            if ($('#GroupOldName').val() !== 'admin' || $('#GroupName').val() === 'admin') {
                Form.submit();
                return false;
            }

            Core.UI.Dialog.ShowContentDialog('<p style="width:400px;">' + Core.Language.Translate("WARNING: When you change the name of the group 'admin', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.") + '</p>', '', '150px', 'Center', true, [
                {
                    Label: Core.Language.Translate('Cancel'),
                    Function: function () {
                        Core.UI.Dialog.CloseDialog($('.Dialog:visible'));
                        Core.Form.EnableForm($('form#GroupUpdate'));
                        $('#GroupName').focus();
                    }
                },
                {
                    Label: Core.Language.Translate('Confirm'),
                    Function: function () {
                        Core.UI.Dialog.CloseDialog($('.Dialog:visible'));
                        Form.submit();
                    },
                    Class: 'Primary'
                }
            ]);
        });

        Core.UI.Table.InitTableFilter($('#FilterGroups'), $('#Groups'));
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.Group || {}));
