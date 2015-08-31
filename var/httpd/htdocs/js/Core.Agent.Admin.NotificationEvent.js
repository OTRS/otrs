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
 * @namespace Core.Agent.Admin.NotificationEvent
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the Notification Event module.
 */
Core.Agent.Admin.NotificationEvent = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Admin.NotificationEvent
     * @function
     * @param {Object} Params - Initialization and internationalization parameters.
     * @description
     *      This function initialize correctly all other function according to the local language.
     */
    TargetNS.Init = function (Params) {

        TargetNS.Localization = Params.Localization;

        // bind click function to add button
        $('.LanguageAdd').bind('change', function () {
            TargetNS.AddLanguage($(this).val(), $('.LanguageAdd option:selected').text());
            return false;
        });

        //bind click function to remove button
        $('.LanguageRemove').bind('click', function () {

            if (window.confirm(TargetNS.Localization.DeleteNotificationLanguageMsg)) {
                TargetNS.RemoveLanguage($(this));
            }
            return false;
        });
    };

   /**
     * @name AddLanguage
     * @memberof Core.Agent.Admin.NotificationEvent
     * @function
     * @param {string} LanguageID - short name of the language like es_MX.
     * @param {string} Language - full name of the language like Spanish (Mexico).
     * @returns {Bool} Returns false to prevent event bubbling.
     * @description
     *      This function add a new notification event language.
     */
    TargetNS.AddLanguage = function(LanguageID, Language){

        var $Clone = $('.Template').clone();

        if (Language === '-'){
            return false;
        }

        // remove unnecessary classes
        $Clone.removeClass('Hidden Template');

        // add title
        $Clone.find('.Title').html(Language);

        // update remove link
        $Clone.find('#Template_Language_Remove').attr('name', LanguageID + '_Language_Remove');
        $Clone.find('#Template_Language_Remove').attr('id', LanguageID + '_Language_Remove');

        // set hidden language field
        $Clone.find('.LanguageID').attr('name', 'LanguageID');
        $Clone.find('.LanguageID').val(LanguageID);

        // update subject label
        $Clone.find('#Template_Label_Subject').attr('for', LanguageID + '_Subject');
        $Clone.find('#Template_Label_Subject').attr('id', LanguageID + '_Label_Subject');

        // update subject field
        $Clone.find('#Template_Subject').attr('name', LanguageID + '_Subject');
        $Clone.find('#Template_Subject').addClass('Validate_Required');
        $Clone.find('#Template_Subject').attr('id', LanguageID + '_Subject');
        $Clone.find('#Template_SubjectError').attr('id', LanguageID + '_SubjectError');

        // update body label
        $Clone.find('#Template_Label_Body').attr('for', LanguageID + '_Body');
        $Clone.find('#Template_Label_Body').attr('id', LanguageID + '_Label_Body');

        // update body field
        $Clone.find('#Template_Body').attr('name', LanguageID + '_Body');
        $Clone.find('#Template_Body').addClass('RichText');
        $Clone.find('#Template_Body').addClass('Validate_RequiredRichText');
        $Clone.find('#Template_Body').attr('id', LanguageID + '_Body');
        $Clone.find('#Template_BodyError').attr('id', LanguageID + '_BodyError');

        // append to container
        $('.NotificationLanguageContainer').append($Clone);

        // initialize the rich text editor if set
        if (parseInt(Core.Config.Get('RichTextSet'), 10) === 1) {
            Core.UI.RichTextEditor.InitAll();
        }

        // bind click function to remove button
        $('.LanguageRemove').bind('click', function () {

            if (window.confirm(TargetNS.Localization.DeleteNotificationLanguageMsg)) {
                TargetNS.RemoveLanguage($(this));
            }
            return false;
        });

        TargetNS.LanguageSelectionRebuild();

        return false;
    };


    /**
     * @name RemoveLanguage
     * @memberof Core.Agent.Admin.NotificationEvent
     * @function
     * @param {jQueryObject} Object - JQuery object used to remove the language block
     * @description
     *      This function removes a notification event language.
     */
    TargetNS.RemoveLanguage = function (Object) {
        Object.closest('.NotificationLanguage').remove();
        TargetNS.LanguageSelectionRebuild();
    };


    /**
     * @name LanguageSelectionRebuild
     * @memberof Core.Agent.Admin.NotificationEvent
     * @function
     * @returns {Boolean} Returns true.
     * @description
     *      This function rebuilds language selection, only show available languages.
     */
    TargetNS.LanguageSelectionRebuild = function () {

        // get original selection with all possible fields and clone it
        var $Languages = $('#LanguageOrig option').clone();

        $('#Language').empty();

        // strip all already used attributes
        $Languages.each(function () {
            if (!$('.NotificationLanguageContainer label#' + $(this).val() + '_Label_Subject').length) {
                $('#Language').append($(this));
            }
        });

        // bind click function to add button
        $('.LanguageAdd').bind('change', function () {
            TargetNS.AddLanguage($(this).val(), $('.LanguageAdd option:selected').text());
            return false;
        });

        return true;
    };

    return TargetNS;
}(Core.Agent.Admin.NotificationEvent || {}));
