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
 * @namespace Core.Agent.Admin.SelectBox
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module function for AdminSelectBox.
 */
 Core.Agent.Admin.SelectBox = (function (TargetNS) {

    /*
    * @name Init
    * @memberof Core.Agent.Admin.SelectBox
    * @function
    * @description
    *      This function initializes the module functionality.
    */
    TargetNS.Init = function () {
        Core.Form.Validate.SetSubmitFunction($('#AdminSelectBoxForm'), function (Form) {
            Form.submit();

            if ($('#ResultFormat option:selected').text() !== 'CSV'
                && $('#ResultFormat option:selected').text() !== 'Excel'
             ) {
                window.setTimeout(function(){
                    Core.Form.DisableForm($(Form));
                }, 0);
            }
        });

        Core.UI.Table.InitTableFilter($('#FilterResults'), $('#Results'));
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.SelectBox || {}));
