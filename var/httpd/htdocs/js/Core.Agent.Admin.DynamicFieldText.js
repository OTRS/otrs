// --
// Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
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
 * @namespace Core.Agent.Admin.DynamicFieldText
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the DynamicFieldText module.
 */
Core.Agent.Admin.DynamicFieldText = (function (TargetNS) {

    /**
     * @name RemoveRegEx
     * @memberof Core.Agent.Admin.DynamicFieldText
     * @function
     * @returns {Boolean} Returns true.
     * @param {String} IDSelector - ID of the pressed remove value button.
     * @description
     *      This function removes a RegEx.
     */
    TargetNS.RemoveRegEx = function(IDSelector) {

        var ObjectIndex = IDSelector.match(/.+_(\d+)/)[1];
        $('#RegExRow_' + ObjectIndex).remove();

        return true;
    };

    /**
     * @name AddRegEx
     * @memberof Core.Agent.Admin.DynamicFieldText
     * @function
     * @returns {Boolean} Returns false
     * @param {Object} RegExInsert - HTML container of the RegEx.
     * @description
     *      This function adds a new RegEx.
     */
    TargetNS.AddRegEx = function(RegExInsert) {
        var $Clone = $('.RegExTemplate').clone(),
            RegExCounter = $('#RegExCounter').val();

        // increment RegEx counter
        RegExCounter++;

        // remove unnecessary classes
        $Clone.removeClass('Hidden RegExTemplate');

        // add needed class and id
        $Clone.addClass('RegExRow');
        $Clone.addClass('W50pc');
        $Clone.attr('id', 'RegExRow_' + RegExCounter);

        // copy RegExs and change ids and names
        $Clone.find(':input, a.RemoveRegEx').each(function(){
            var ID = $(this).attr('id');
            $(this).attr('id', ID + '_' + RegExCounter);
            $(this).attr('name', ID + '_' + RegExCounter);

            $(this).addClass('Validate_Required');

            // set error controls
            $(this).parent().find('#' + ID + 'Error').attr('id', ID + '_' + RegExCounter + 'Error');
            $(this).parent().find('#' + ID + 'Error').attr('name', ID + '_' + RegExCounter + 'Error');

            $(this).parent().find('#' + ID + 'ServerError').attr('id', ID + '_' + RegExCounter + 'ServerError');
            $(this).parent().find('#' + ID + 'ServerError').attr('name', ID + '_' + RegExCounter + 'ServerError');

            // add event handler to remove button
            if( $(this).hasClass('RemoveRegEx') ) {

                // bind click function to remove button
                $(this).bind('click', function () {
                    TargetNS.RemoveRegEx($(this).attr('id'));
                    return false;
                });
            }
        });

        $Clone.find('label').each(function(){
            var FOR = $(this).attr('for');
            $(this).attr('for', FOR + '_' + RegExCounter);
        });

        // append to container
        RegExInsert.append($Clone);

        // set new count of RegExs
        $('#RegExCounter').val(RegExCounter);

        return false;
    };

    return TargetNS;
}(Core.Agent.Admin.DynamicFieldText || {}));
