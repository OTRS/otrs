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
 * @namespace Core.Agent.Admin.GenericInterfaceTransportHTTPSOAP
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the GenericInterface Transport HTTP SOAP module.
 */
Core.Agent.Admin.GenericInterfaceTransportHTTPSOAP = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Admin.GenericInterfaceTransportHTTPSOAP
     * @function
     * @description
     *      This function binds events to certain actions
     */
    TargetNS.Init = function () {

        // bind change function to Request Name Scheme field
        $('#RequestNameScheme').on('change', function(){
            if ($(this).val() === 'Append' || $(this).val() === 'Replace') {
                $('.RequestNameFreeTextField').removeClass('Hidden');
                $('#RequestNameFreeText').addClass('Validate_Required');
            }
            else {
                $('.RequestNameFreeTextField').addClass('Hidden');
                $('#RequestNameFreeText').removeClass('Validate_Required');
            }
        });

        // bind change function to Response Name Scheme field
        $('#ResponseNameScheme').on('change', function(){
            if ($(this).val() === 'Append' || $(this).val() === 'Replace') {
                $('.ResponseNameFreeTextField').removeClass('Hidden');
                $('#ResponseNameFreeText').addClass('Validate_Required');
            }
            else {
                $('.ResponseNameFreeTextField').addClass('Hidden')
                $('#ResponseNameFreeText').removeClass('Validate_Required');
            }
        });

        // bind change function to SOAP Action field
        $('#SOAPAction').on('change', function(){
            if ($(this).val() === 'Yes') {
                $('.SOAPActionField').removeClass('Hidden');
            }
            else {
                $('.SOAPActionField').addClass('Hidden');
            }
        });

        // bind change function to Authentication field
        $('#Authentication').on('change', function(){
            if ($(this).val() === 'BasicAuth') {
                $('.BasicAuthField').removeClass('Hidden');
                $('.BasicAuthField').find('#UserName').each(function(){
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

        // bind change function to Use SSL field
        $('#UseSSL').on('change', function(){
            if ($(this).val() === 'Yes') {
                $('.SSLField').removeClass('Hidden');
                $('.SSLField').find('#SSLP12Certificate').each(function(){
                    $(this).addClass('Validate_Required');
                });
                $('.SSLField').find('#SSLP12Password').each(function(){
                    $(this).addClass('Validate_Required');
                });
            }

            else {
                $('.SSLField').addClass('Hidden');
                $('.SSLField').find('#SSLP12Certificate').each(function(){
                    $(this).removeClass('Validate_Required');
                });
                $('.SSLField').find('#SSLP12Password').each(function(){
                    $(this).removeClass('Validate_Required');
                });
            }
        });

        // bind click function to Save and finish button
        $('#SaveAndFinishButton').on('click', function(){
            $('#ReturnToWebservice').val(1);
        });

        Core.Agent.SortedTree.Init($('.SortableList'), $('#TransportConfigForm'), $('#Sort'), Core.Config.Get('SortData'));
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.GenericInterfaceTransportHTTPSOAP || {}));
