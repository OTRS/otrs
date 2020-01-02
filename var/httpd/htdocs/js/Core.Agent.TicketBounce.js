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

/**
 * @namespace Core.Agent.TicketBounce
 * @memberof Core.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for AgentTicketBounce functionality.
 */
 Core.Agent.TicketBounce = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.TicketBounce
     * @function
     * @description
     *      This function binds click event on checkbox.
     */
    TargetNS.Init = function () {

        // function to switch between mandatory and optional
        function SwitchMandatoryFields() {
            var InformSenderChecked = $('#InformSender').prop('checked'),
                $ElementsLabelObj = $('#To,#Subject,#RichText').parent().prev('label');

            if (InformSenderChecked) {
                $ElementsLabelObj
                    .addClass('Mandatory')
                    .find('.Marker')
                    .removeClass('Hidden');
            }
            else if (!InformSenderChecked) {
                $ElementsLabelObj
                    .removeClass('Mandatory')
                    .find('.Marker')
                    .addClass('Hidden');
            }

            return;
        }

        // initial setting for to/subject/body
        SwitchMandatoryFields();

        // watch for changes of inform sender field
        $('#InformSender').on('click', function(){
            SwitchMandatoryFields();
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
 }(Core.Agent.TicketBounce || {}));
