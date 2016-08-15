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
 * @namespace Core.Agent.Admin.GenericInterfaceMappingXSLT
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the GenericInterface Mapping XSLT module.
 */
Core.Agent.Admin.GenericInterfaceMappingXSLT = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Admin.GenericInterfaceMappingXSLT
     * @function
     * @description
     *      This function binds event to the 'Save and finish' button
     */
    TargetNS.Init = function () {

        // bind click function to save and finish button
        $('#SaveAndFinishButton').bind('click', function(){
            $('#ReturnToAction').val(1);
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.GenericInterfaceMappingXSLT || {}));
