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
 * @namespace Core.Agent.Admin.PostMasterFilter
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special function for PostMasterFilter module.
 */
 Core.Agent.Admin.PostMasterFilter = (function (TargetNS) {

    /*
    * @name Init
    * @memberof Core.Agent.Admin.PostMasterFilter
    * @function
    * @description
    *      This function initializes table filter.
    */
    TargetNS.Init = function () {
        Core.UI.Table.InitTableFilter($('#FilterPostMasterFilters'), $('#PostMasterFilters'));

        // bind click on delete button
        $('#PostMasterFilters a.DeleteAction').on('click', function () {
            if (window.confirm(Core.Language.Translate('Do you really want to delete this filter?'))) {
                return true;
            }
            return false;
        });

        // check all negate labels and add a marker color if negate is enabled
        $('.FilterFields label.Negate input').each(function() {
            if ($(this).is(':checked')) {
                $(this).closest('label').addClass('Checked');
            }
            else {
                $(this).closest('label').removeClass('Checked');
            }
        });

        $('.FilterFields label.Negate input').on('click', function() {
            if ($(this).is(':checked')) {
                $(this).closest('label').addClass('Checked');
            }
            else {
                $(this).closest('label').removeClass('Checked');
            }
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.PostMasterFilter || {}));
