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
     * @description
     *      This function initialize correctly all other function according to the local language.
     */
    TargetNS.Init = function () {

        // bind click function to add button
        $('.LanguageAdd').off('change.NotificationEvent').on('change.NotificationEvent', function () {
            TargetNS.AddLanguage($(this).val(), $('.LanguageAdd option:selected').text());
            return false;
        });

        // bind click function to remove button
        $('.LanguageRemove').off('click.NotificationEvent').on('click.NotificationEvent', function () {

            if (window.confirm(Core.Language.Translate('Do you really want to delete this notification language?'))) {
                TargetNS.RemoveLanguage($(this));
            }
            return false;
        });

        function VisibleForAgentHandler() {
            var TooltipObject = $('#VisibleForAgentTooltip');

            if ($('#VisibleForAgent').val() > 0) {
                TooltipObject.removeAttr('readonly');

                // show default transport value
                $('.AgentEnabledByDefault').show();
            }
            else {
                TooltipObject.attr('readonly', 'readonly');

                // hide default transport value
                $('.AgentEnabledByDefault').hide();
            }
        }

        $('#VisibleForAgent').on('change.NotificationEvent', VisibleForAgentHandler);

        // Run on first view.
        VisibleForAgentHandler();

        // initialize table filter
        Core.UI.Table.InitTableFilter($("#FilterNotifications"), $("#Notifications"));

        // register dialog box for delete notification
        $('.NotificationDelete').click(function (Event) {
            if (window.confirm(Core.Language.Translate('Do you really want to delete this notification?'))) {
                window.location = $(this).attr('href');
            }

            // don't interfere with MasterAction
            Event.stopPropagation();
            Event.preventDefault();
            return false;
        });

        // add special validation method
        Core.Form.Validate.AddMethod("Validate_OneChecked", function() {
            if($(".Validate_OneChecked:checkbox:checked").length > 0){
                return true;
            }
           return false;
        });

        // add special validation rule
        Core.Form.Validate.AddRule("Validate_OneChecked", {Validate_OneChecked: true});

        // set up attributes (enable/disable) to some fields on click
        $('#EmailSecuritySettings').click(function() {
            var InputField = [
                "EmailSigningCrypting_Search",
                "EmailMissingSigningKeys_Search",
                "EmailMissingCryptingKeys_Search",
                "EmailDefaultSigningKeys_Search"
            ];

            if (this.checked) {
                $.each(InputField, function(index, item) {
                    $('#' + item)
                        .removeAttr('readonly disabled')
                        .parent()
                        .removeClass('AlreadyDisabled');
                });

                $('.Security').removeAttr('disabled', 'disabled');
            }
            else {
                $.each(InputField, function(index, item) {
                    $('#' + item)
                        .attr({
                            'readonly' : 'readonly',
                            'disabled' : 'disabled'
                        })
                        .parent()
                        .addClass('AlreadyDisabled');
                });

                $('.Security').attr('disabled', 'disabled');
            }
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
            Core.UI.RichTextEditor.InitAllEditors();
        }

        // bind click function to remove button
        $('.LanguageRemove').off('click.NotificationEvent').on('click.NotificationEvent', function () {

            if (window.confirm(Core.Language.Translate('Do you really want to delete this notification language?'))) {
                TargetNS.RemoveLanguage($(this));
            }
            return false;
        });

        TargetNS.LanguageSelectionRebuild();

        Core.UI.InitWidgetActionToggle();

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

        $('#Language').trigger('redraw.InputField');

        // bind click function to add button
        $('.LanguageAdd').off('change.NotificationEvent').on('change.NotificationEvent', function () {
            TargetNS.AddLanguage($(this).val(), $('.LanguageAdd option:selected').text());
            return false;
        });

        return true;
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.NotificationEvent || {}));
