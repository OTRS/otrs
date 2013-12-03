// --
// Core.Agent.Admin.GenericAgent.js - provides the special module functions for the GenericInterface job.
// Copyright (C) 2003-2013 OTRS AG, http://otrs.org/
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
 * @namespace
 * @exports TargetNS as Core.Agent.Admin.GenericAgentEvent
 * @description
 *      This namespace contains the special module functions for the GenericInterface job module.
 */
Core.Agent.Admin.GenericAgent = (function (TargetNS) {

    /**
     * @variable
     * @private
     *     This variable stores the parameters that are passed from the DTL and contain all the data that the dialog needs.
     */
    var DialogData = [];

    /**
     * @function
     * @param {Object} Params, initialization and internationalization parameters.
     * @return nothing
     *      This function initialize correctly all other function according to the local language
     */
    TargetNS.Init = function (Params) {

        TargetNS.Localization = Params.Localization;

        $('.DeleteEvent').bind('click', function (Event) {
            TargetNS.ShowDeleteEventDialog( Event, $(this) );
            return false;
        });

        $('#AddEvent').bind('click', function (){
            if ( $('#EventType').val() !== null ) {
                TargetNS.AddEvent( $('#EventType').val() );
            }
        });

        $('#EventType').bind('change', function (){
            TargetNS.ToogleEventSelect($(this).val());
        });
    };

    TargetNS.ToogleEventSelect = function (SelectedEventType) {
        $('.EventList').addClass('Hidden');
        $('#' + SelectedEventType + 'Event').removeClass('Hidden');
    };


    /**
     * @function
     * @param {String} EventType, the type of event trigger to assign to an jobr
     * i.e ticket or article
     * @return nothing
     *      This function calls the AddEvent action on the server
     */
    TargetNS.AddEvent = function (EventType) {

        var $Clone = $('.EventRowTemplate').clone(),
            EventName = $('#'+ EventType + 'Event').val(),
            IsDuplicated = false;

        if ( !EventName ) {
            return false;
        }

        // check for duplicated entries
        $('[class*=EventValue]').each(function(index) {
            if ( $(this).val() === EventName ) {
                IsDuplicated = true;
            }
        });
        if (IsDuplicated) {
            TargetNS.ShowDuplicatedDialog('EventName');
            return false;
        }

        // add needed values
        $Clone.find('.EventType').html(EventType);
        $Clone.find('.EventName').html(EventName);
        $Clone.find('.EventValue').attr('name','EventValues').val(EventName);

        // bind delete function
        $Clone.find('#DeleteEvent').bind('click', function (Event) {
            // remove row
            TargetNS.ShowDeleteEventDialog(Event, $(this) );
            return false;
        });

        // remove unneeded classes
        $Clone.removeClass('Hidden EventRowTemplate');

        // append to container
        $('#EventsTable > tbody:last').append($Clone);

    };

    /**
     * @function
     * @param {EventObject} event object of the clicked element.
     * @return nothing
     *      This function shows a confirmation dialog with 2 buttons
     */
    TargetNS.ShowDeleteEventDialog = function(Event, Object, EventName){
        var LocalDialogData;

        Core.UI.Dialog.ShowContentDialog(
            $('#DeleteEventDialogContainer'),
            TargetNS.Localization.DeleteEventMsg,
            '240px',
            'Center',
            true,
            [
               {
                   Label: TargetNS.Localization.CancelMsg,
                   Class: 'Primary',
                   Function: function () {
                       Core.UI.Dialog.CloseDialog($('#DeleteEventDialog'));
                   }
               },
               {
                   Label: TargetNS.Localization.DeleteMsg,
                   Function: function () {
                       Object.parents('tr:first').remove();
                       Core.UI.Dialog.CloseDialog($('#DeleteEventDialog'));
                   }
               }
           ]
        );

        Event.stopPropagation();
        Event.preventDefault();
    };

    /**
     * @function
     * @param {string} Field ID object of the element should receive the focus on close event.
     * @return nothing
     *      This function shows an alert dialog for duplicated entries.
     */
    TargetNS.ShowDuplicatedDialog = function(Field){
        Core.UI.Dialog.ShowAlert(
            TargetNS.Localization.DuplicateEventTitle,
            TargetNS.Localization.DuplicateEventMsg,
            function () {
                Core.UI.Dialog.CloseDialog($('.Alert'));
                $('#EventType').focus();
                return false;
            }
        );
    };

    return TargetNS;
}(Core.Agent.Admin.GenericAgent || {}));
