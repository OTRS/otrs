// --
// OTRS.UI.RichTextEditor.js - provides all UI functions
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.UI.RichTextEditor.js,v 1.1 2010-05-10 16:29:46 mn Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};
OTRS.UI = OTRS.UI || {};

/**
 * @namespace
 * @exports TargetNS as OTRS.UI.RichTextEditor
 * @description
 *      Richtext Editor
 * @requires
 *      CKEDITOR
 */
OTRS.UI.RichTextEditor = (function (TargetNS) {
    var $FormID;

    function CheckFormID() {
        if (typeof $FormID === 'undefined') {
            $FormID = $('input:hidden[name=FormID]');
        }
        return $FormID;
    }

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
            throw "Need exactly one EditorArea!";
            return false;
        }

        CKEDITOR.on('instanceCreated', function (Editor) {
            Editor.editor.addCss(OTRS.Config.Get('RichText.EditingAreaCSS'));
        });

        Editor = CKEDITOR.replace(EditorID,
        {
            customConfig: '', // avoid loading external config files
            defaultLanguage: OTRS.Config.Get('UserLanguage'),
            language: OTRS.Config.Get('UserLanguage'),
            width: OTRS.Config.Get('RichText.Width') || 620,
            resize_minWidth: OTRS.Config.Get('RichText.Width') || 620,
            height: OTRS.Config.Get('RichText.Height') || 320,
            baseHref: OTRS.Config.Get('RichText.BasePath'),
            skin: 'default',
            forcePasteAsPlainText: false,
            fontSize_sizes: '8px;10px;12px;16px;18px;20px;22px;24px;26px;28px;30px;',
            enterMode: CKEDITOR.ENTER_BR,
            shiftEnterMode: CKEDITOR.ENTER_BR,
            contentsLangDirection: OTRS.Config.Get('RichText.TextDir') ? OTRS.Config.Get('RichText.TextDir') : 'ltr',
            disableNativeSpellChecker: false,
            toolbar_Full: [
                ['Bold','Italic','Underline','Strike','-','NumberedList','BulletedList','-','Outdent','Indent','-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock','-','Link','Unlink','-','Image','HorizontalRule','-','Undo','Redo','-','Find','SpellCheck'],
                '/',
                ['Format','Font','FontSize','-','TextColor','BGColor','RemoveFormat','-','Source'],
            ],
            toolbar_Simple: [
                ['Bold','Italic','Underline','Strike','-','NumberedList','BulletedList','-','Outdent','Indent','-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock','-','Link','Unlink','-','HorizontalRule','-','Undo','Redo','-','Find','SpellCheck'],
                '/',
                ['Format','Font','FontSize','-','TextColor','BGColor','RemoveFormat','-','Source'],
            ],
            toolbar: ToolbarSet,
            filebrowserUploadUrl: OTRS.Config.Get('Baselink'),
            extraPlugins: OTRS.Config.Get('RichText.SpellChecker') ? 'aspell' : ''
        });
        if (CheckFormID().length) {
            CKEDITOR.config.action = 'PictureUpload';
            CKEDITOR.config.formID = CheckFormID().val();
        }
        CKEDITOR.config.spellerPagesServerScript = OTRS.Config.Get('Baselink');
    };

    TargetNS.InitAll = function () {
        $('textarea.RichText').each(function () {
            TargetNS.Init($(this));
        });
    }

    TargetNS.UpdateLinkedField = function ($EditorArea) {
        var EditorID = '',
            Data,
            StrippedContent;

        if (isJQueryObject($EditorArea) && $EditorArea.length === 1) {
            EditorID = $EditorArea.attr('id');
        }

        if (EditorID === '') {
            throw "Need exactly one EditorArea!";
            return false;
        }

        Data = CKEDITOR.instances[EditorID].getData();
        StrippedContent = Data.replace(/\s+|&nbsp;|<\/?\w+\s?\/?>/g, '');
        if (StrippedContent.length == 0) {
            $EditorArea.val('');
        }
        else {
            $EditorArea.val(Data);
        }
    }

    TargetNS.Focus = function ($EditorArea) {
        var EditorID = '';

        if (isJQueryObject($EditorArea) && $EditorArea.length === 1) {
            EditorID = $EditorArea.attr('id');
        }

        if (EditorID === '') {
            throw "Need exactly one EditorArea!";
            return false;
        }

        CKEDITOR.instances[EditorID].focus();

    }

    return TargetNS;
}(OTRS.UI.RichTextEditor || {}));