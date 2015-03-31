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
     * @private
     * @name AddSelectClearButton
     * @memberof Core.Agent.Admin.GenericAgentEvent
     * @function
     * @description
     *      Adds a button next to every select field to clear the selection.
     *      Only select fields with size > 1 are selected (no dropdowns).
     */
    function AddSelectClearButton() {
        var $SelectFields = $('select');

        // Loop over all select fields available on the page
        $SelectFields.each(function () {
            var Size = parseInt($(this).attr('size'), 10),
                $SelectField = $(this),
                SelectID = this.id,
                ButtonHTML = '<a href="#" title="' + TargetNS.Localization.RemoveSelection + '" class="GenericAgentClearSelect" data-select="' + SelectID + '"><span>' + TargetNS.Localization.RemoveSelection + '</span><i class="fa fa-undo"></i></a>';


            // Only handle select fields with a size > 1, leave all single-dropdown fields untouched
            if (isNaN(Size) || Size <= 1) {
                return;
            }

            // If select field has a tree selection icon already,
            // // we want to insert the new code after that element
            if ($SelectField.next('a.ShowTreeSelection').length) {
                $SelectField = $SelectField.next('a.ShowTreeSelection');
            }

            // insert button HTML
            $SelectField.after(ButtonHTML);
        });

        // Bind click event on newly inserted button
        // The name of the corresponding select field is saved in a data attribute
        $('.GenericAgentClearSelect').on('click.ClearSelect', function () {
            var SelectID = $(this).data('select'),
                $SelectField = $('#' + SelectID);

            if (!$SelectField.length) {
                return;
            }

            // Clear field value
            $SelectField.val('');
            $(this).blur();

            return false;
        });
    }

    /**
     * @name Localization
     * @memberof Core.Agent.Admin.GenericAgentEvent
     * @member {Array}
     * @description
     *     The localization array for translation strings.
     */
    TargetNS.Localization = undefined;

    /**
     * @name Init
     * @memberof Core.Agent.Admin.GenericAgentEvent
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

        $('#AddEvent').bind('click', function (Event){
            if ( $('#EventType').val() !== null ) {
                TargetNS.AddEvent( $('#EventType').val() );
                return false;
            }
        });

        $('#EventType').bind('change', function (){
            TargetNS.ToogleEventSelect($(this).val());
        });

        AddSelectClearButton();
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

    /**
     * @function
     * @return nothing
     * @description Inits admin generic agent editing.
     */

    TargetNS.InitEditing = function () {
        $('form[name="compose"] button[type="submit"]').on( 'click', function () {
            CheckSearchStringsForStopWords( function () {
                $('form[name="compose"]:first').submit();
            });

           return false;
        });
    };

    /**
     * @function
     * @private
     * @param {Function} Callback function to execute, if no stop words were found.
     * @return nothing
     * @description Checks if specific values of the search form contain stop words.
     *              If stop words are present, a warning will be displayed.
     *              If stop words are not present, the given callback will be executed.
     */
    function CheckSearchStringsForStopWords(Callback) {
        var SearchStrings = [],
            SearchStringsFound = 0,
            RelevantElementNames = [
                'From',
                'To',
                'Cc',
                'Subject',
                'Body'
            ],
            StopWordCheckData;

        $.each( RelevantElementNames, function (Index, ElementName) {
            var $Element = $('form[name="compose"] input[name="' + ElementName + '"]');

            if ($Element.length) {
                if ( $Element.val() && $Element.val() !== '' ) {
                    SearchStrings.push($Element.val());
                    SearchStringsFound = 1;
                }
            }
        });

        // Check if stop words are present.
        if (!SearchStringsFound) {
            Callback();
            return;
        }

        StopWordCheckData = {
            Action: 'AgentTicketSearch',
            Subaction: 'AJAXStopWordCheck',
            SearchStrings: SearchStrings
        };

        Core.AJAX.FunctionCall(
            Core.Config.Get('CGIHandle'),
            StopWordCheckData,
            function (Result) {
                if ( Result.FoundStopWords.length ) {
                    alert(Core.Config.Get('SearchStringsContainStopWordsMsg') + ' ' + Result.FoundStopWords);
                }
                else {
                    Callback();
                }
            }
        );
    }

    return TargetNS;
}(Core.Agent.Admin.GenericAgent || {}));
