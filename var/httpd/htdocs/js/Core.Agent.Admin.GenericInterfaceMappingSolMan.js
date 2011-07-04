// --
// Core.Agent.Admin.GenericInterfaceMapping.js - provides the special module functions for the GenericInterface mapping.
// Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
// --
// $Id: Core.Agent.Admin.GenericInterfaceMappingSolMan.js,v 1.3 2011-07-04 21:45:25 cr Exp $
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
 * @exports TargetNS as Core.Agent.Admin.GenericInterfaceMappingSimple
 * @description
 *      This namespace contains the special module functions for the GenericInterface Mapping module.
 */
Core.Agent.Admin.GenericInterfaceMappingSolMan= (function (TargetNS) {

    /**
     * @function
     * @param {Object} Params, initialization and internationalization parameters.
     * @return nothing
     *      This function initialize correctly all other function according to the local language
     */
    TargetNS.Init = function (Params) {
        TargetNS.WebserviceID = parseInt(Params.WebserviceID, 10);
        TargetNS.Localization = Params.Localization;
    };

    /**
     * @function
     * @param {string} IDSelector, id of the pressed remove value button.
     * @return nothing
     *      This function removes a value mapping and creates a stub input so the server can
     *      identify if a value is empty or deleted (useful for server validation)
     */
    TargetNS.RemoveValueMapping = function (IDSelector){

        // copy HTML code for an input replacement for the deleted value
        var $Clone = $('.DeletedValue').clone(),

        // get the index of the value to delete (its always the second element (1) in this RegEx
        $ObjectIndex = IDSelector.match(/.+_(\d+)/)[1],

        // get the mapping type name
        $KeyName = $('#'+ IDSelector).closest('fieldset').find('.KeyName').val();

        // set the input replacement attributes to match the deleted original value
        // new value and other controls are not needed anymore
        $Clone.attr('id', 'ValueName' + $KeyName + '_' + $ObjectIndex);
        $Clone.attr('name', 'ValueName' + $KeyName + '_' + $ObjectIndex);
        $Clone.removeClass('DeletedValue');

        // add the input replacement to the mapping type so it can be parsed and distinguish from
        // empty values by the server
        $('#'+ IDSelector).closest('fieldset').append($Clone);

        // remove value mapping
        $('#'+ IDSelector).parent().remove();

        return false;
    };

    /**
     * @function
     * @param {Object} ValueInsert, HTML container of the value mapping row
     * @param {string} KeyName, name of the mapping key type
     * @return nothing
     *      This function removes a value mapping
     */
    TargetNS.AddValueMapping = function (ValueInsert, KeyName) {

        // clone key dialog
        var $Clone = $('.ValueTemplate').clone(),
            ValueCounter = $('#ValueCounter' + KeyName).val();

        // increment key counter
        ValueCounter ++;

        // remove unnecessary classes
        $Clone.removeClass('Hidden ValueTemplate');

        // add needed class
        $Clone.addClass('ValueTemplateRow');

        // copy values and change ids and names
        $Clone.find(':input').each(function(){
            var ID = $(this).attr('id');
            $(this).attr('id', ID + KeyName + '_' + ValueCounter);
            $(this).attr('name', ID + KeyName + '_' + ValueCounter);

            $(this).addClass('Validate_Required@');

            // set error controls
            $(this).parent().find('#' + ID + 'Error').attr('id', ID +  KeyName + '_' + ValueCounter + 'Error');
            $(this).parent().find('#' + ID + 'Error').attr('name', ID + KeyName + '_' + ValueCounter + 'Error');

            $(this).parent().find('#' + ID + 'ServerError').attr('id', ID + KeyName + '_' + ValueCounter + 'ServerError');
            $(this).parent().find('#' + ID + 'ServerError').attr('name', ID + KeyName + '_' + ValueCounter + 'ServerError');

            // add event handler to remove button
            if( $(this).hasClass('Remove') ) {

                // bind click function to remove button
                $(this).bind('click', function () {
                    TargetNS.RemoveValueMapping($(this).attr('id'));
                    return false;
                });
            }
        });

        $Clone.find('label').each(function(){
            var FOR = $(this).attr('for');
            $(this).attr('for', FOR + KeyName + '_' + ValueCounter);
        });

        // append to container
        ValueInsert.append($Clone);

        // set new value for KeyName
        $('#ValueCounter' + KeyName).val(ValueCounter);

        return false;
    };

    /**
     * @function
     * @param {string} KeyName, name of the mapping type.
     * @return nothing
     *      This function creates a new HTML section for the selected mapping type
     */
    TargetNS.AddKeyMapping = function(KeyName) {

        // clone key dialog
        var $Clone = $('.KeyTemplate').clone(),
        $MappingConfig = Core.Config.Get( 'Mapping.SolMan' ),
        $KeyDisplayName = $MappingConfig[KeyName];

        // remove unnecessary classes
        $Clone.removeClass('Hidden KeyTemplate');

        // add title
        $Clone.find('.Title').html('Mapping for ' + $KeyDisplayName);

        $Clone.find('.ValueDefaultLabel').attr('for', KeyName + 'Default');

        // copy values and change IDs and names
        $Clone.find(':input').each(function(){
            var ID = $(this).attr('id');

            // hidden fields that has the KeyName
            if ( $(this).hasClass('KeyName') ) {
                $(this).attr('id', KeyName);
                $(this).attr('name', KeyName);
                $(this).val(KeyName);
            }

            // Default value fields
            else if ( $(this).hasClass('ValueDefault') ) {
                $(this).attr('id',   KeyName + 'Default');
                $(this).attr('name', KeyName + 'Default');
            }

            // any other field
            else {
                $(this).attr('id', ID + KeyName);
                $(this).attr('name', ID + KeyName);
            }

            // add event handler to Add button
            if( $(this).hasClass('Add') ) {

                // bind click function to add button
                $(this).bind('click', function () {
                    TargetNS.AddValueMapping( $(this).closest('fieldset').find('.ValueInsert'), KeyName );
                    return false;
                });
            }

            if( $(this).hasClass('Remove') ) {

                // bind click function to add button
                $(this).bind('click', function () {
                    Core.Agent.Admin.GenericInterfaceMappingSolMan.ShowDeleteDialog( $(this).attr('id') );
                    return false;
                });
            }
        });

        // append to container
        $('#KeyInsert').append($Clone);

        // reset template row values
        $('.NewRule').find(':input:not(:button)').attr('value','');

         // remove mapping type from list
         $('#KeyMapType').find('option:selected').each(function () {
             $(this).remove();
         });

        Core.UI.InitWidgetActionToggle();

        return false;
    };

    /**
     * @function
     * @return nothing
     *      This function rebuild mapping key types selection, only show available keys.
     */
    TargetNS.KeyMapTypeSelectionRebuild = function() {

        // get original selection
        var $KeyMapTypeClone = $('#KeyMapTypeOrig').clone();
        $KeyMapTypeClone.attr('id', 'KeyMapType');

        // strip all already used attributes
        $KeyMapTypeClone.find('option').each(function () {
            var $KeyMap = $(this);
               $('.KeyName').each(function(){
                   if ($(this).attr('id') !== 'Template') {
                       if ($(this).attr('id') === $KeyMap.attr('value')) {
                           $KeyMap.remove();
                       }
                   }
               });
        });

        // replace selection with original selection
        $('#KeyMapType').replaceWith($KeyMapTypeClone);

        return true;
    };

    /**
     * @function
     * @param {string} IDSelector ID object of the clicked element.
     * @return nothing
     *      This function shows a confirmation dialog with 2 buttons
     */
    TargetNS.ShowDeleteDialog = function(IDSelector){

        Core.UI.Dialog.ShowContentDialog(
            $('#DeleteDialogContainer'),
            TargetNS.Localization.DeleteKeyMappingtMsg,
            '240px',
            'Center',
            true,
            [
               {
                   Label: TargetNS.Localization.DeleteMsg,
                   Function: function () {
                       $('#' + IDSelector).closest('.WidgetKey').remove();
                       TargetNS.KeyMapTypeSelectionRebuild();
                       $('#KeyMapType').bind('change', function () {
                           if ($(this).val()) {
                               TargetNS.AddKeyMapping($(this).val());
                           }
                           return false;
                       });
                       Core.UI.Dialog.CloseDialog($('#DeleteDialog'));
                   }
               },
               {
                   Label: TargetNS.Localization.CancelMsg,
                   Function: function () {
                       Core.UI.Dialog.CloseDialog($('#DeleteDialog'));
                   }
               }
           ]
        );
    };

    return TargetNS;
}(Core.Agent.Admin.GenericInterfaceMappingSolMan || {}));