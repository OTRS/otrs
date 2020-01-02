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
 * @namespace Core.Agent.Admin.GenericInterfaceMappingXSLT
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the GenericInterface Mapping XSLT module.
 */
Core.Agent.Admin.GenericInterfaceMappingXSLT = (function (TargetNS) {

    /**
     * @name RemoveValue
     * @memberof Core.Agent.Admin.GenericInterfaceMappingXSLT
     * @function
     * @returns {Boolean} Returns false.
     * @param {String} IDSelector - ID of the pressed remove value button.
     * @description
     *      This function removes a value from regex list and creates a stub input so
     *      the server can identify if a value is empty or deleted (useful for server validation).
     */
    TargetNS.RemoveValue = function (IDSelector){

        var $Type = IDSelector.match(/^(Pre|Post)/)[1];
        var $KeyPrefix = $Type + 'Key_';
        var $DeletedValue = $Type + 'DeletedValue';

        // copy HTML code for an input replacement for the deleted regex
        var $Clone = $('.' + $DeletedValue).clone(),

        // get the index of the value to delete (its always the second element (1) in this RegEx
        $ObjectIndex = IDSelector.match(/.+_(\d+)/)[1];

        // set the input replacement attributes to match the deleted original regex
        // new regex and other controls are not needed anymore
        $Clone.attr('id', $KeyPrefix + $ObjectIndex);
        $Clone.attr('name', $KeyPrefix + $ObjectIndex);
        $Clone.removeClass($DeletedValue);

        // add the input replacement to the mapping type so it can be parsed and distinguish from
        // empty regexes by the server
        $('#' + IDSelector).closest('fieldset').append($Clone);

        // remove regex
        $('#' + IDSelector).parent().remove();

        return false;
    };

    /**
     * @name AddValue
     * @memberof Core.Agent.Admin.GenericInterfaceMappingXSLT
     * @function
     * @returns {Boolean} Returns false
     * @param {Object} ValueInsert - HTML container of the value mapping row.
     * @description
     *      This function adds a new regex to the regex list
     */
    TargetNS.AddValue = function (ValueInsert) {

        var $Type = ValueInsert.attr('class').match(/(Pre|Post)ValueInsert/)[1];
        var $ValueCounter = '#' + $Type + 'ValueCounter';
        var $ValueTemplate = $Type + 'ValueTemplate';

        // clone key dialog
        var $Clone = $('.' + $ValueTemplate).clone(),
            ValueCounter = $($ValueCounter).val();

        // increment key counter
        ValueCounter++;

        // remove unnecessary classes
        $Clone.removeClass('Hidden ' + $ValueTemplate);

        // add needed class
        $Clone.addClass('ValueRow');

        // copy values and change ids and names
        $Clone.find(':input, a.RemoveButton').each(function(){
            var ID = $(this).attr('id');
            $(this).attr('id', ID + '_' + ValueCounter);
            $(this).attr('name', ID + '_' + ValueCounter);

            // add error control to key
            if($(this).hasClass('KeyTemplate')) {
                $(this).removeClass('KeyTemplate');
                $(this).addClass('Validate_Required');

                // set error controls
                $(this).parent().find('#' + ID + 'Error').attr('id', ID + '_' + ValueCounter + 'Error');
                $(this).parent().find('#' + ID + 'Error').attr('name', ID + '_' + ValueCounter + 'Error');

                $(this).parent().find('#' + ID + 'ServerError').attr('id', ID + '_' + ValueCounter + 'ServerError');
                $(this).parent().find('#' + ID + 'ServerError').attr('name', ID + '_' + ValueCounter + 'ServerError');
            }

            // add event handler to remove button
            if($(this).hasClass('RemoveButton')) {

                // bind click function to remove button
                $(this).on('click', function () {
                    TargetNS.RemoveValue($(this).attr('id'));
                    return false;
                });
            }
        });

        $Clone.find('label').each(function(){
            var FOR = $(this).attr('for');
            $(this).attr('for', FOR + '_' + ValueCounter);
        });

        // append to container
        ValueInsert.append($Clone);

        // set new value for KeyName
        $($ValueCounter).val(ValueCounter);

        return false;
    };

    /**
     * @name Init
     * @memberof Core.Agent.Admin.GenericInterfaceMappingXSLT
     * @function
     * @description
     *       Initialize module functionality
     */
    TargetNS.Init = function () {

        // bind click function to add button
        $('#PreAddValue').on('click', function () {
            TargetNS.AddValue(
                $(this).closest('fieldset').find('.PreValueInsert')
            );
            return false;
        });
        $('#PostAddValue').on('click', function () {
            TargetNS.AddValue(
                $(this).closest('fieldset').find('.PostValueInsert')
            );
            return false;
        });

        // bind click function to remove button
        $('.ValueRemove').on('click', function () {
            TargetNS.RemoveValue($(this).attr('id'));
            return false;
        });

    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.GenericInterfaceMappingXSLT || {}));
