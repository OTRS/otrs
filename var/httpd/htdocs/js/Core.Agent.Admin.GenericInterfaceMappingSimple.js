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
Core.Agent.Admin = Core.Agent.Admin || {};

/**
 * @namespace Core.Agent.Admin.GenericInterfaceMappingSimple
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the GenericInterface Mapping module.
 */
Core.Agent.Admin.GenericInterfaceMapping = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Admin.GenericInterfaceMappingSimple
     * @function
     * @param {Object} Params - Initialization and internationalization parameters.
     * @description
     *      This function initialize correctly all other function according to the local language.
     */
    TargetNS.Init = function (Params) {
        TargetNS.WebserviceID = parseInt(Params.WebserviceID, 10);
        TargetNS.Localization = Params.Localization;
        TargetNS.DeletedString = Params.DeletedString;

        // remove Validate_Required class from templates, if not
        // a validation is fire on hidden fields
        $('.KeyTemplate').find(':input').removeClass('Validate_Required');

        $('.DefaultType').bind('change', function(){

            // call function to hide or show
            // MapTo field
            TargetNS.ToggleMapTo($(this));
        });

        // register add of attribute
        $('#AddKeyMapping').bind('click', function () {
            TargetNS.AddKeyMapping();
            return false;
        });

        // register change new key name action
        $('.NewValue').bind('change', function(){

            // modified title
            $(this).closest('.WidgetKey').find('.Title').html('Mapping for Key ' + $(this).val());
        });

        // register remove key action
        $('.AdditionalInformation .KeyMapRemove').bind('click', function () {
            TargetNS.ShowDeleteDialog($(this).attr('id'));
            return false;
        });

        //bind click function to add button
        $('.ValueAdd').bind('click', function () {
            TargetNS.AddValueMapping(
                $(this).closest('fieldset').parent().find('.ValueInsert'),
                $(this).closest('fieldset').parent().find('.KeyIndex').val()
            );
            return false;
        });

        //bind click function to add button
        $('.ValueRemove').bind('click', function () {
            TargetNS.RemoveValueMapping($(this));
        //            $(this).parent().remove();
            return false;
        });
    };

    /**
     * @name AddKeyMapping
     * @memberof Core.Agent.Admin.GenericInterfaceMappingSimple
     * @function
     * @returns {Bool} Returns false to prevent event bubbling.
     * @description
     *      This function add a new dialog for a key mapping.
     */
    TargetNS.AddKeyMapping = function(){

        // clone key dialog
        var $Clone = $('.KeyTemplate').clone(),
            KeyCounter = $('#KeyCounter').val();

        // increment key counter
        KeyCounter++;

        // remove unnecessary classes
        $Clone.removeClass('Hidden KeyTemplate');

        // add title
        $Clone.find('.Title').html('Mapping for Key');

        // copy values and change ids and names
        $Clone.find(':input,[href]').each(function(){
            var ID = $(this).attr('id');
            $(this).attr('id', ID + KeyCounter);
            $(this).attr('name', ID + KeyCounter);
            $(this).addClass('Validate_Required');

            // add event handler to Add button
            if($(this).hasClass('ValueAdd')) {

                // bind click function to add button
                $(this).bind('click', function () {
                    TargetNS.AddValueMapping($(this).closest('fieldset').parent().find('.ValueInsert'), KeyCounter);
                    return false;
                });
            }

            if($(this).hasClass('KeyMapRemove')) {

                // bind click function to add button
                $(this).bind('click', function () {
                    TargetNS.ShowDeleteDialog($(this).attr('id'));
                    return false;
                });
            }

            if($(this).hasClass('DefaultType')) {
                $(this).bind('change', function(){

                    // call function to hide or show
                    // MapTo field
                    TargetNS.ToggleMapTo($(this));
                });
            }

            if($(this).hasClass('NewValue')) {
                $(this).bind('change', function(){

                    // modified title
                    $(this).closest('.WidgetKey').find('.Title').html('Mapping for Key ' + $(this).val());
                });
            }

            if($(this).hasClass('KeyIndex')) {
                $(this).val(KeyCounter);
            }

            $(this).parent().find('.' + ID + 'Label').attr('for', ID + KeyCounter);

            $(this).parent().find('#' + ID + 'Error').attr('id', ID + KeyCounter + 'Error');
            $(this).parent().find('#' + ID + 'ServerError').attr('id', ID + KeyCounter + 'ServerError');
        });

        // set correct for attribute
        $Clone.find('.AddValueMapping').attr('for', 'AddValueMapping' + KeyCounter);

        // append to container
        $('#KeyInsert').append($Clone);

        // reset template row values
        $('.NewRule').find(':input:not(:button)').attr('value', '');
        $('#KeyName' + KeyCounter).focus();

        // set new value for KeyCounter
        $('#KeyCounter').val(KeyCounter);

        // init toggle action
        Core.UI.InitWidgetActionToggle();

        Core.UI.InputFields.Activate();

        return false;
    };

    /**
     * @name AddValueMapping
     * @memberof Core.Agent.Admin.GenericInterfaceMappingSimple
     * @function
     * @returns {Bool} Returns false to prevent event bubbling.
     * @param {jQueryObject} ValueInsert - JQuery object where the new value mapping should be included.
     * @param {Number} KeyCounter - the index for the new value mapping.
     * @description
     *      This function adds a new value mapping dialog.
     */
    TargetNS.AddValueMapping = function (ValueInsert, KeyCounter) {

        // clone key dialog
        var $Clone = $('.ValueTemplate').clone(),
            ValueCounter = $('#ValueCounter' + KeyCounter).val(),
            Suffix;

        // increment value counter
        ValueCounter++;

        Suffix = KeyCounter + '_' + ValueCounter;

        // remove unnecessary classes
        $Clone.removeClass('Hidden ValueTemplate');

        // copy values and change ids and names
        $Clone.find(':input,[href]').each(function(){
            var ID = $(this).attr('id');
            $(this).attr('id', ID + Suffix);
            $(this).attr('name', ID + Suffix);
            $(this).addClass('Validate_Required');

            // add event handler to remove button
            if($(this).hasClass('ValueRemove')) {

                // bind click function to add button
                $(this).bind('click', function () {
                    // remove row
                    TargetNS.RemoveValueMapping($(this));
                    return false;
                });
            }

            $(this).parent().find('.' + ID + 'Label').attr('for', ID + Suffix);

            $(this).parent().find('#' + ID + 'Error').attr('id', ID + Suffix + 'Error');

            $(this).parent().find('#' + ID + 'ServerError').attr('id', ID + Suffix + 'ServerError');
        });
        // append to container
        ValueInsert.append($Clone);


        // set new value for KeyCounter
        $('#ValueCounter' + KeyCounter).val(ValueCounter);

        Core.UI.InputFields.Activate();

        return false;
    };

    /**
     * @name RemoveValueMapping
     * @memberof Core.Agent.Admin.GenericInterfaceMappingSimple
     * @function
     * @param {jQueryObject} Object - JQuery object used to decide if is, or not necessary to hide the input text control for MapTo value.
     * @description
     *      This function shows or hide the input text control for MapTo value.
     */
    TargetNS.RemoveValueMapping = function (Object) {
        var ID = Object.attr('id'),
        HTML = '';
        // 18 is the length for 'RemoveValueMapping' string
        ID = ID.substr(18);

        HTML += '<div>';
        HTML += '    <input type="hidden" name="ValueName' + ID + '" value="' + TargetNS.DeletedString + '" />';
        HTML += '    <input type="hidden" name="ValueMapTypeStrg' + ID + '" value="' + TargetNS.DeletedString + '" />';
        HTML += '    <input type="hidden" name="ValueMapNew' + ID + '" value="' + TargetNS.DeletedString + '" />';
        HTML += '</div>';

        // append to container
        $('#KeyInsert').append(HTML);
        Object.parent().remove();
    };

    /**
     * @name ToggleMapTo
     * @memberof Core.Agent.Admin.GenericInterfaceMappingSimple
     * @function
     * @param {jQueryObject} Object - JQuery object used to decide if is, or not necessary to hide the input text control for MapTo value.
     * @description
     *      This function shows or hide the input text control for MapTo value.
     */
    TargetNS.ToggleMapTo = function (Object) {
    var ID = Object.attr('id');
    if (Object.val() !== 'MapTo') {
            $('.' + ID).addClass('Hidden');
            $('.' + ID).removeClass('Validate_Required');
        }
        else {
            $('.' + ID).removeClass('Hidden');
            $('.' + ID).addClass('Validate_Required');
        }
    };

    /**
     * @name ShowDeleteDialog
     * @memberof Core.Agent.Admin.GenericInterfaceMappingSimple
     * @function
     * @param {String} IDSelector - ID object of the clicked element.
     * @description
     *      This function shows a confirmation dialog with 2 buttons.
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
}(Core.Agent.Admin.GenericInterfaceMapping || {}));
