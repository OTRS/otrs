// --
// Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};

/**
 * @namespace Core.Agent.TicketMerge
 * @memberof Core.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains the TicketMerge functions.
 */
Core.Agent.TicketMerge = (function (TargetNS) {

    /**
     * @name Init
     * @private
     * @memberof Core.Agent.TicketMerge
     * @function
     * @description
     *      This function switches the given fields between mandatory and optional.
     */
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
    }

    /**
     * @name Init
     * @memberof Core.Agent.TicketMerge
     * @function
     * @description
     *      This function initializes the functionality for the TicketMerge screen.
     */
    TargetNS.Init = function () {
        // initial setting for to/subject/body
        SwitchMandatoryFields();

        // watch for changes of inform sender field
        $('#InformSender').bind('click', function(){
            SwitchMandatoryFields();
        });

        // Subscribe to ToggleWidget event to handle special behaviour in ticket merge screen
        Core.App.Subscribe('Event.UI.ToggleWidget', function ($WidgetElement) {
            if ($WidgetElement.attr('id') !== 'WidgetInformSender') {
                return;
            }

            // if widget is being opened and checkbox is not yet checked, check it
            if ($WidgetElement.hasClass('Expanded') && !$('#InformSender').prop('checked')) {
                $('#InformSender').trigger('click');
            }
        });
    };

    return TargetNS;
}(Core.Agent.TicketMerge || {}));
