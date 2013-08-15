// --
// Core.UI.RichTextEditor.js - provides all UI functions
// Copyright (C) 2001-2013 OTRS AG, http://otrs.org/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.UI = Core.UI || {};

/**
 * @namespace
 * @exports TargetNS as Core.UI.RichTextEditor
 * @description
 *      Richtext Editor
 * @requires
 *      CKEDITOR
 */
Core.UI.RichTextEditor = (function (TargetNS) {
    var $FormID;

    /**
     * @function
     * @private
     * @description Check in the window which hidden element has a name same to 'FormID' and return it like a JQuery object
     */
    function CheckFormID() {
        if (typeof $FormID === 'undefined') {
            $FormID = $('input:hidden[name=FormID]');
        }
        return $FormID;
    }

    /**
     * @function
     * @param {jQueryObject} $EditorArea The jQuery object of the element that will be a rich text editor
     * @return nothing
     *      This function initializes the application and executes the needed functions
     */
    TargetNS.Init = function ($EditorArea) {
        var EditorID = '',
            Editor,
            Instance,
            UserLanguage;

        if (isJQueryObject($EditorArea) && $EditorArea.length === 1) {
            EditorID = $EditorArea.attr('id');
        }

        if (EditorID === '') {
            Core.Exception.Throw('RichTextEditor: Need exactly one EditorArea!', 'TypeError');
        }

        // remove the CKEditor instance if already exists
        Instance = CKEDITOR.instances[EditorID];
        if (Instance) {
            Instance.destroy(true);
        }

        CKEDITOR.on('instanceCreated', function (Editor) {
            CKEDITOR.addCss(Core.Config.Get('RichText.EditingAreaCSS'));
            // Remove the validation error tooltip if content is added to the editor
            Editor.editor.on('change', function(evt) {
                Core.Form.Validate.ValidateElement($(Editor.editor.element.$));
            });
        });

        // The format for the language is different between OTRS and CKEditor (see bug#8024)
        // To correct this, we replace "_" with "-" in the language (e.g. zh_CN becomes zh-cn)
        UserLanguage = Core.Config.Get('UserLanguage').replace(/_/, "-");

        Editor = CKEDITOR.replace(EditorID,
        {
            customConfig: '', // avoid loading external config files
            defaultLanguage: UserLanguage,
            language: UserLanguage,
            width: Core.Config.Get('RichText.Width', 620),
            resize_minWidth: Core.Config.Get('RichText.Width', 620),
            height: Core.Config.Get('RichText.Height', 320),
            removePlugins : 'elementspath,scayt,menubutton',
            forcePasteAsPlainText: false,
            format_tags: 'p;h1;h2;h3;h4;h5;h6;pre',
            fontSize_sizes: '8px;10px;12px;16px;18px;20px;22px;24px;26px;28px;30px;',
            enterMode: CKEDITOR.ENTER_BR,
            shiftEnterMode: CKEDITOR.ENTER_BR,
            contentsLangDirection: Core.Config.Get('RichText.TextDir', 'ltr'),
            disableNativeSpellChecker: false,
            toolbar: CheckFormID().length ? Core.Config.Get('RichText.Toolbar') : Core.Config.Get('RichText.ToolbarWithoutImage'),
            filebrowserUploadUrl: Core.Config.Get('Baselink'),
            extraPlugins: Core.Config.Get('RichText.SpellChecker') ? 'aspell,onchange' : 'onchange'
        });
        if (CheckFormID().length) {
            CKEDITOR.config.action = Core.Config.Get('RichText.PictureUploadAction', 'PictureUpload');
            CKEDITOR.config.formID = CheckFormID().val();
        }
        CKEDITOR.config.spellerPagesServerScript = Core.Config.Get('Baselink');

        // Hack for updating the textarea with the RTE content (bug#5857)
        // Rename the original function to another name, than overwrite the original one
        CKEDITOR.instances[EditorID].updateElementOriginal = CKEDITOR.instances[EditorID].updateElement;
        CKEDITOR.instances[EditorID].updateElement = function() {
            var Data;

            // First call the original function
            CKEDITOR.instances[EditorID].updateElementOriginal();

            // Now check if there is actually any non-whitespace content in the
            //  textarea field. If not, set it to an empty value to make sure
            //  the server side validation works correctly and there is no trash
            //  like '<br/>' stored in the DB.
            Data = this.element.getValue(); // get textarea content

            // only if data contains no image tag,
            // this is important for inline images, we don't want to remove them!
            if ( !Data.match(/<img/) ) {

                // remove tags and whitespace for checking
                Data = Data.replace(/\s+|&nbsp;|<\/?\w+[^>]*\/?>/g, '');
                if (!Data.length) {
                    this.element.setValue(''); // reset textarea
                }
            }
        };

        // Needed for clientside validation of RTE
        CKEDITOR.instances[EditorID].on('blur', function () {
            CKEDITOR.instances[EditorID].updateElement();
            Core.Form.Validate.ValidateElement($EditorArea);
        });

        // needed for client-side validation
        CKEDITOR.instances[EditorID].on('focus', function () {
            if ($EditorArea.attr('class').match(/Error/)) {
                window.setTimeout(function () {
                    CKEDITOR.instances[EditorID].updateElement();
                    Core.Form.Validate.ValidateElement($EditorArea);
                }, 0);
            }
        });

        // mainly needed for client-side validation
        $EditorArea.focus(function () {
            TargetNS.Focus($EditorArea);
            Core.UI.ScrollTo($("label[for=" + $EditorArea.attr('id') + "]"));
        });
    };

    /**
     * @function
     * @return nothing
     *      This function initializes as a rich text editor every textarea element that containing the RichText class
     */
    TargetNS.InitAll = function () {
        $('textarea.RichText').each(function () {
            TargetNS.Init($(this));
        });
    };

    /**
     * @function
     * @param {jQueryObject} $EditorArea The jQuery object of the element that is a rich text editor
     * @return The rich text editor length
     *      This function return the length for a rich text editor object
     */
    TargetNS.GetRTE = function ($EditorArea) {
        if (isJQueryObject($EditorArea)) {
            var $RTE = $('#cke_' + $EditorArea.attr('id'));
            return ($RTE.length ? $RTE : undefined);
        }
    };

    /**
     * @function
     * @param {jQueryObject} $EditorArea The jQuery object of the element that is a rich text editor
     * @return nothing
     *      This function updates the linked field for a rich text editor
     */
    TargetNS.UpdateLinkedField = function ($EditorArea) {
        var EditorID = '',
            Data,
            StrippedContent;

        if (isJQueryObject($EditorArea) && $EditorArea.length === 1) {
            EditorID = $EditorArea.attr('id');
        }

        if (EditorID === '') {
            Core.Exception.Throw('RichTextEditor: Need exactly one EditorArea!', 'TypeError');
        }

        Data = CKEDITOR.instances[EditorID].getData();
        StrippedContent = Data.replace(/\s+|&nbsp;|<\/?\w+[^>]*\/?>/g, '');

        if (StrippedContent.length === 0 && !Data.match(/<img/)) {
            $EditorArea.val('');
        }
        else {
            $EditorArea.val(Data);
        }
    };

    /**
     * @function
     * @param {jQueryObject} $EditorArea The jQuery object of the element that is a rich text editor
     * @return nothing
     *      This function check if a rich text editor is enable in this moment
     */
    TargetNS.IsEnabled = function ($EditorArea) {
        var EditorID = '';

        if (isJQueryObject($EditorArea) && $EditorArea.length === 1) {
            EditorID = $EditorArea.attr('id');
            if ($('#cke_' + Core.App.EscapeSelector(EditorID)).length) {
                return true;
            }
        }

        return false;
    };

    /**
     * @function
     * @param {jQueryObject} $EditorArea The jQuery object of the element that is a rich text editor
     * @return nothing
     *      This function check if a rich text editor has the browser focus enabled
     */
    TargetNS.Focus = function ($EditorArea) {
        var EditorID = '';

        if (isJQueryObject($EditorArea) && $EditorArea.length === 1) {
            EditorID = $EditorArea.attr('id');
        }

        if (EditorID === '') {
            Core.Exception.Throw('RichTextEditor: Need exactly one EditorArea!', 'TypeError');
        }

        if (typeof CKEDITOR === 'object') {
            CKEDITOR.instances[EditorID].focus();
        }
        else {
            $EditorArea.focus();
        }
    };

    return TargetNS;
}(Core.UI.RichTextEditor || {}));
