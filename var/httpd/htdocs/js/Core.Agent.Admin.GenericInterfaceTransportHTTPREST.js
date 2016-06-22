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
 * @namespace Core.Agent.Admin.GenericInterfaceTransportHTTPREST
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the GenericInterface Mapping XSLT module.
 */
Core.Agent.Admin.GenericInterfaceTransportHTTPREST = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Admin.GenericInterfaceTransportHTTPREST
     * @function
     * @description
     *      This function binds events to certain actions
     */
    TargetNS.Init = function () {

        // bind change function to Authentication field
        $('#Authentication').bind('change', function(){
            if ($(this).val() === 'BasicAuth') {
                $('.BasicAuthField').removeClass('Hidden');
                $('.BasicAuthField').find('#User').each(function(){
                    $(this).addClass('Validate_Required');
                });
            }
            else {
                $('.BasicAuthField').addClass('Hidden');
                $('.BasicAuthField').find('#User').each(function(){
                    $(this).removeClass('Validate_Required');
                });
            }
        });

        // bind change function to Use SSL option field
        $('#UseX509').bind('change', function(){
            if ($(this).val() === 'Yes') {
                $('.X509Field').removeClass('Hidden');

                $('.X509Field').find('#X509CertFile').each(function(){
                    $(this).addClass('Validate_Required');
                });
                $('.X509Field').find('#X509KeyFile').each(function(){
                    $(this).addClass('Validate_Required');
                });
            }

            else {
                $('.X509Field').addClass('Hidden');

                $('.X509Field').find('#X509CertFile').each(function(){
                    $(this).removeClass('Validate_Required');
                });
                $('.X509Field').find('#X509KeyFile').each(function(){
                    $(this).removeClass('Validate_Required');
                });
            }
        });

        // bind click function to save and finish button
        $('#SaveAndFinishButton').bind('click', function(){
            $('#ReturnToWebservice').val(1);
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.GenericInterfaceTransportHTTPREST || {}));
