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
Core.Agent.Admin = Core.Agent.Admin || {};

/**
 * @namespace Core.Agent.Admin.GenericInterfaceMapping
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the GenericInterface Mapping module.
 */
Core.Agent.Admin.GenericInterfaceMapping = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Admin.GenericInterfaceMapping
     * @function
     * @description
     *      This function initialize module functionality.
     */
    TargetNS.Init = function () {
        var MappingSimpleData = Core.Config.Get('MappingSimple');

        if (typeof MappingSimpleData !== 'undefined') {
            TargetNS.MappingSimpleInit(MappingSimpleData);
        }
    };

    /**
     * @name MappingSimpleInit
     * @memberof Core.Agent.Admin.GenericInterfaceMapping
     * @function
     * @param {Object} Params - Initialization and internationalization parameters.
     * @description
     *      This function initialize correctly all other function according to the local language.
     */
    TargetNS.MappingSimpleInit = function (Params) {
        TargetNS.WebserviceID = parseInt(Params.WebserviceID, 10);
        TargetNS.DeletedString = Params.DeletedString;

        // remove Validate_Required class from templates, if not
        // a validation is fire on hidden fields
        $('.KeyTemplate').find(':input').removeClass('Validate_Required');

        $('.DefaultType').on('change', function(){

            // call function to hide or show
            // MapTo field
            TargetNS.ToggleMapTo($(this));
        });

        // register add of attribute
        $('#AddKeyMapping').on('click', function () {
            TargetNS.AddKeyMapping();
            return false;
        });

        // register change new key name action
        $('.NewValue').on('change', function(){

            // modified title
            $(this).closest('.WidgetKey').find('.Title').html(Core.Language.Translate('Mapping for Key %s', $(this).val()));
        });

        // register remove key action
        $('.AdditionalInformation .KeyMapRemove').on('click', function () {
            TargetNS.ShowDeleteDialog($(this).attr('id'));
            return false;
        });

        // bind click function to add button
        $('.ValueAdd').on('click', function () {
            TargetNS.AddValueMapping(
                $(this).closest('fieldset').parent().find('.ValueInsert'),
                $(this).closest('fieldset').parent().find('.KeyIndex').val()
            );
            return false;
        });

        // bind click function to remove button
        $('.ValueRemove').on('click', function () {
            TargetNS.RemoveValueMapping($(this));
        //            $(this).parent().remove();
            return false;
        });
    };

    /**
     * @name AddKeyMapping
     * @memberof Core.Agent.Admin.GenericInterfaceMapping
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
        $Clone.find('.Title').html(Core.Language.Translate('Mapping for Key'));

        // copy values and change ids and names
        $Clone.find(':input,[href]').each(function(){
            var ID = $(this).attr('id');
            $(this).attr('id', ID + KeyCounter);
            $(this).attr('name', ID + KeyCounter);
            $(this).addClass('Validate_Required');

            // add event handler to Add button
            if($(this).hasClass('ValueAdd')) {

                // bind click function to add button
                $(this).on('click', function () {
                    TargetNS.AddValueMapping($(this).closest('fieldset').parent().find('.ValueInsert'), KeyCounter);
                    return false;
                });
            }

            if($(this).hasClass('KeyMapRemove')) {

                // bind click function to remove button
                $(this).on('click', function () {
                    TargetNS.ShowDeleteDialog($(this).attr('id'));
                    return false;
                });
            }

            if($(this).hasClass('DefaultType')) {
                $(this).on('change', function(){

                    // call function to hide or show
                    // MapTo field
                    TargetNS.ToggleMapTo($(this));
                });
            }

            if($(this).hasClass('NewValue')) {
                $(this).on('change', function(){

                    // modified title
                    $(this).closest('.WidgetKey').find('.Title').html(Core.Language.Translate('Mapping for Key %s', $(this).val()));
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
     * @memberof Core.Agent.Admin.GenericInterfaceMapping
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

                // bind click function to remove button
                $(this).on('click', function () {
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
     * @memberof Core.Agent.Admin.GenericInterfaceMapping
     * @function
     * @param {jQueryObject} Object - JQuery object where the new value mapping is removed.
     * @description
     *      This function removes a new value mapping dialog.
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
     * @memberof Core.Agent.Admin.GenericInterfaceMapping
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
     * @memberof Core.Agent.Admin.GenericInterfaceMapping
     * @function
     * @param {String} IDSelector - ID object of the clicked element.
     * @description
     *      This function shows a confirmation dialog with 2 buttons.
     */
    TargetNS.ShowDeleteDialog = function(IDSelector){
        Core.UI.Dialog.ShowContentDialog(
            $('#DeleteDialogContainer'),
            Core.Language.Translate('Delete this Key Mapping'),
            '240px',
            'Center',
            true,
            [
               {
                   Label: Core.Language.Translate('Delete'),
                   Function: function () {
                       $('#' + IDSelector).closest('.WidgetKey').remove();
                       Core.UI.Dialog.CloseDialog($('#DeleteDialog'));
                   }
               },
               {
                   Label: Core.Language.Translate('Cancel'),
                   Function: function () {
                       Core.UI.Dialog.CloseDialog($('#DeleteDialog'));
                   }
               }
           ]
        );
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.GenericInterfaceMapping || {}));
