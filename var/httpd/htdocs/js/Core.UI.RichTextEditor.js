// --
// Core.UI.RichTextEditor.js - provides all UI functions
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.UI.RichTextEditor.js,v 1.4 2010-07-21 23:02:04 cg Exp $
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
        var ToolbarSet = 'Simple',
            EditorID = '',
            Editor;
        if (CheckFormID().length) {
            ToolbarSet = 'Full';
        }

        if (isJQueryObject($EditorArea) && $EditorArea.length === 1) {
            EditorID = $EditorArea.attr('id');
        }

        if (EditorID === '') {
            Core.Exception.Throw('RichTextEditor: Need exactly one EditorArea!', 'TypeError');
        }

        CKEDITOR.on('instanceCreated', function (Editor) {
            Editor.editor.addCss(Core.Config.Get('RichText.EditingAreaCSS'));
        });

        Editor = CKEDITOR.replace(EditorID,
        {
            customConfig: '', // avoid loading external config files
            defaultLanguage: Core.Config.Get('UserLanguage'),
            language: Core.Config.Get('UserLanguage'),
            width: Core.Config.Get('RichText.Width') || 620,
            resize_minWidth: Core.Config.Get('RichText.Width') || 620,
            height: Core.Config.Get('RichText.Height') || 320,
            removePlugins : 'elementspath',
            baseHref: Core.Config.Get('RichText.BasePath'),
            skin: 'default',
            forcePasteAsPlainText: false,
            fontSize_sizes: '8px;10px;12px;16px;18px;20px;22px;24px;26px;28px;30px;',
            enterMode: CKEDITOR.ENTER_BR,
            shiftEnterMode: CKEDITOR.ENTER_BR,
            contentsLangDirection: Core.Config.Get('RichText.TextDir') ? Core.Config.Get('RichText.TextDir') : 'ltr',
            disableNativeSpellChecker: false,
            toolbar_Full: [
                ['Bold', 'Italic', 'Underline', 'Strike', '-', 'NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock', '-', 'Link', 'Unlink', '-', 'Image', 'HorizontalRule', '-', 'Undo', 'Redo', '-', 'Find', 'SpellCheck'],
                '/',
                ['Format', 'Font', 'FontSize', '-', 'TextColor', 'BGColor', 'RemoveFormat', '-', 'Source']
            ],
            toolbar_Simple: [
                ['Bold', 'Italic', 'Underline', 'Strike', '-', 'NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock', '-', 'Link', 'Unlink', '-', 'HorizontalRule', '-', 'Undo', 'Redo', '-', 'Find', 'SpellCheck'],
                '/',
                ['Format', 'Font', 'FontSize', '-', 'TextColor', 'BGColor', 'RemoveFormat', '-', 'Source']
            ],
            toolbar: ToolbarSet,
            filebrowserUploadUrl: Core.Config.Get('Baselink'),
            extraPlugins: Core.Config.Get('RichText.SpellChecker') ? 'aspell' : ''
        });
        if (CheckFormID().length) {
            CKEDITOR.config.action = 'PictureUpload';
            CKEDITOR.config.formID = CheckFormID().val();
        }
        CKEDITOR.config.spellerPagesServerScript = Core.Config.Get('Baselink');

        // Needed for clientside validation of RTE
        CKEDITOR.instances[EditorID].on('blur', function () {
            TargetNS.UpdateLinkedField($EditorArea);
            Core.Form.Validate.ValidateElement($EditorArea);
        });

        // mainly needed for clientside validation
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
        StrippedContent = Data.replace(/\s+|&nbsp;|<\/?\w+\s?\/?>/g, '');
        if (StrippedContent.length === 0) {
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
            if ($('cke_' + EditorID).length) {
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

        CKEDITOR.instances[EditorID].focus();

    };

    return TargetNS;
}(Core.UI.RichTextEditor || {}));