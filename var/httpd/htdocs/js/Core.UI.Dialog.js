// --
// Core.UI.Dialog.js - Dialogs
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.UI.Dialog.js,v 1.9 2010-08-11 08:25:51 mg Exp $
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
 * @exports TargetNS as Core.UI.Dialog
 * @description
 *      Contains the code for the different dialogs.
 */
Core.UI.Dialog = (function (TargetNS) {
    /**
     * @function
     * @private
     * @return nothing
     * @description Adjusts the scrollable inner container of the dialog after every resizing.
     */
    function AdjustScrollableHeight() {
        // Check window height and adjust the scrollable height of InnerContent
        var ContentScrollHeight = Math.round(($(window).height() * 0.6) - 50);
        $('.Dialog:visible .Content .InnerContent').css('max-height', ContentScrollHeight);
    }

    /**
     * @function
     * @private
     * @return nothing
     * @description Focuses the first element within the dialog.
     */
    function FocusFirstElement() {
        $('div.Dialog:visible .Content')
            .find('a:visible, input:visible, textarea:visible, select:visible, button:visible')
            .filter(':first')
            .focus(1);
    }

    /**
     * @function
     * @private
     * @param CloseOnEscape If set to true, the escape key is checked for closing the dialog.
     * @return nothing
     * @description Initializes the key event logger for the dialog.
     *              Must be unbinded when closing the dialog.
     */
    function InitKeyEvent(CloseOnEscape) {
        var $Dialog = $('div.Dialog:visible');
        /*
         * Opera can't prevent the default action of special keys on keydown. That's why we need a special keypress event here,
         * to prevent the default action for the special keys.
         * See http://www.quirksmode.org/dom/events/keys.html for details
         */
        $(document).unbind('keypress.Dialog').bind('keypress.Dialog', function (Event) {
            if ($.browser.opera && (Event.keyCode === 9 || (Event.keyCode === 27 && CloseOnEscape))) {
                Event.preventDefault();
                Event.stopPropagation();
                return false;
            }
        }).unbind('keydown.Dialog').bind('keydown.Dialog', function (Event) {
            var $Tabbables, $First, $Last;

            // Tab pressed
            if (Event.keyCode === 9) {
                // :tabbable probably comes from jquery UI
                $Tabbables = $('a:visible, input:visible, textarea:visible, select:visible, button:visible', $Dialog);
                $First = $Tabbables.filter(':first');
                $Last  = $Tabbables.filter(':last');

                if (Event.target === $Last[0] && !Event.shiftKey) {
                    $First.focus(1);
                    Event.preventDefault();
                    Event.stopPropagation();
                    return false;
                }
                else if (Event.target === $First[0] && Event.shiftKey) {
                    $Last.focus(1);
                    Event.preventDefault();
                    Event.stopPropagation();
                    return false;
                }
            }
            // Escape pressed and CloseOnEscape is true
            else if (Event.keyCode === 27 && CloseOnEscape) {
                TargetNS.CloseDialog($Dialog);
                Event.preventDefault();
                Event.stopPropagation();
                return false;
            }
        });
    }

    function DefaultSubmitFunction() {
        $('.Dialog:visible form').submit();
    }

    function DefaultCloseFunction() {
        TargetNS.CloseDialog($('.Dialog:visible'));
    }

    /**
     * @function
     * @private
     * @param Params Hash with different config options:
     *               Modal: true|false (default: false) Shows a dark background overlay behind the dialog
     *               Type: Alert|Search (default: undefined) Defines a special type of dialog
     *               Title: string (default: undefnied) Defines the title of the dialog window
     *               Headline: string (default: undefined) Defines a special headline within the dialog window
     *               Text: string (default: undefined) The text which is outputtet in the dialog window
     *               HTML: string (default: undefined) Used for content dialog windows. Contains a complete HTML snippet or an jQuery object with containing HTML
     *               PositionTop: value (default: undefined) Defines the top position of the dilaog window
     *               PositionBottom: value (default: undefined) Defines the bottom position of the dilaog window
     *               PositionLeft: value|Center (default: undefined) Defines the left position of the dilaog window. Center centers the window
     *               PositionRight: value (default: undefined) Defines the right position of the dilaog window
     *               CloseOnClickOutside true|false (default: false) If true, clicking outside the dialog closes the dialog
     *               CloseOnEscape true|false (default: false) If true, pressing escape key closes the dialog
     *               Buttons: Array of Hashes with the following properties (buttons are placed in a div "footer" of the dialog):
     *                  Label: string Text of the button
     *                  Type: string 'Submit'|'Close' (default: none) Special type of the button - invokes a standard function
     *                  Class: string Optional class parameters for the button element
     *                  Function: function The function which is executed on click (optional)
     * @return nothing
     * @description The main dialog function used for all different types of dialogs.
     */
    function ShowDialog(Params) {
        var $Dialog, $Content, $ButtonFooter, ContentScrollHeight, HTMLBackup,
            DialogHTML = '<div class="Dialog"><div class="Header"><a class="Close" title="' + Core.Config.Get('DialogCloseMsg') + '" href="#"></a></div><div class="Content"></div><div class="Footer"></div></div>';

        // Close all opened dialogs
        if ($('.Dialog:visible').length) {
            TargetNS.CloseDialog($('.Dialog:visible'));
        }

        // If Dialog is a modal dialog, initialize overlay
        if (Params.Modal) {
            $('<div id="Overlay" tabindex="-1">').appendTo('body');
            $('body').css({
                'position': 'relative'
            });
            $('#Overlay').height($(document).height()).css('top', 0);
        }

        // Build Dialog HTML
        $Dialog = $(DialogHTML);

        if (Params.Modal) {
            $Dialog.addClass('Modal');
        }

        // If Param HTML is provided, get the HTML data
        // Data can be a HTML string or an jQuery object with containing HTML data
        if (Params.HTML) {
            // Get HTML with JS function innerhTML, because jQuery html() strips out the script blocks
            if (typeof Params.HTML !== 'string' && isJQueryObject(Params.HTML)) {
                HTMLBackup = (Params.HTML)[0].innerHTML;
                Core.Data.Set($('body'), 'DialogCopy', HTMLBackup);
                Core.Data.Set($('body'), 'DialogCopySelector', Params.HTML.selector);
                Params.HTML.empty();
                Params.HTML = HTMLBackup;
            }
        }

        // Type 'Alert'
        if (Params.Type === 'Alert') {
            $Dialog.addClass('Alert');
            $Dialog.attr("role", "alertdialog");
            $Content = $Dialog.find('.Content').append('<div class="InnerContent"></div>').find('.InnerContent');
            $Content.append('<span class="Icon"></span>');
            if (Params.Headline) {
                $Content.append('<h2>' + Params.Headline + '</h2>');
            }
            if (Params.Text) {
                $Content.append('<p>' + Params.Text + '</p>');
            }
            Params.Buttons = [{
                Label: 'OK',
                Type: 'Close'
            }];
            $Content.append('<div class="Center Spacing"><button type="button" id="DialogButton1" class="Close">Ok</button></div>');
        }
        // Define different other types here...
        else if (Params.Type === 'Search') {
            $Dialog.addClass('Search');
            $Dialog.attr("role", "dialog");
            $Content = $Dialog.find('.Content');
            if (Params.HTML) {
                $Content.append(Params.HTML);
            }
        }
        // If no type is defined, default type is used
        else {
            $Dialog.attr("role", "dialog");
            $Content = $Dialog.find('.Content');
            // buttons are defined only in default type
            if (Params.Buttons) {
                $Content.append('<div class="InnerContent"></div>').find('.InnerContent').append(Params.HTML);
                $ButtonFooter = $('<div class="ContentFooter Center"></div>');
                $.each(Params.Buttons, function (Index, Value) {
                    var Classes = '';
                    if (Value.Type === 'Close') {
                        Classes = 'Close';
                    }
                    if (Value.Class) {
                        Classes += ' ' + Value.Class;
                    }
                    $ButtonFooter.append('<button id="DialogButton' + (Index - 0 + 1) + '" ' + (Classes.length ? ('class="' + Classes + '" ') : '') + 'type="button">' + Value.Label + '</button>');
                });
                $ButtonFooter.appendTo($Content);
            }
            else {
                if (Params.HTML) {
                    $Content.append(Params.HTML);
                }
            }
        }

        // If Title is defined, add dialog title
        if (Params.Title) {
            $Dialog.find('.Header').append('<h1>' + Params.Title + '</h1>');
        }

        // Check if "ContentFooter" is used in Content and change Footer
        if ($Dialog.find('.Content .ContentFooter').length) {
            $Dialog.find('.Footer').addClass('ContentFooter');
        }

        // Add Dialog to page
        $Dialog.appendTo('body');

        // Check window height and adjust the scrollable height of InnerContent
        AdjustScrollableHeight();

        // Set position for Dialog
        if (Params.Type === 'Alert') {
            $Dialog.css({
                top:    $(window).scrollTop() + ($(window).height() * 0.3),
                left:   Math.round(($(window).width() - $Dialog.width()) / 2)
            });
        }

        if (typeof Params.PositionTop !== 'undefined') {
            $Dialog.css('top', Params.PositionTop);
        }
        if (typeof Params.PositionLeft !== 'undefined') {
            if (Params.PositionLeft === 'Center') {
                $Dialog.css('left', Math.round(($(window).width() - $Dialog.width()) / 2));
            }
            else {
                $Dialog.css('left', Params.PositionLeft);
            }
        }
        if (typeof Params.PositionBottom !== 'undefined') {
            $Dialog.css('bottom', Params.PositionBottom);
        }
        if (typeof Params.PositionRight !== 'undefined') {
            $Dialog.css('right', Params.PositionRight);
        }

        // Add event-handling
        $Dialog.draggable({
            containment: Params.Modal ? 'window' : 'body',
            handle: '.Header'
        });

        // Add button events
        if (Params.Buttons) {
            $.each(Params.Buttons, function (Index, Value) {
                $('#DialogButton' + (Index - 0 + 1)).click(function () {
                    if (Value.Type === 'Submit') {
                        if ($.isFunction(Value.Function)) {
                            if (Value.Function()) {
                                DefaultSubmitFunction();
                            }
                        }
                        else {
                            DefaultSubmitFunction();
                        }
                    }
                    else if (Value.Type === 'Close') {
                        if ($.isFunction(Value.Function)) {
                            if (Value.Function()) {
                                DefaultCloseFunction();
                            }
                        }
                        else {
                            DefaultCloseFunction();
                        }
                    }
                    else {
                        if ($.isFunction(Value.Function)) {
                            Value.Function();
                        }
                    }
                });
            });
        }

        // Add event-handling for Close-Buttons and -Links
        $Dialog.find('.Header a.Close').click(function () {
            var $CloseButton = $('.Dialog:visible button.Close');
            if ($CloseButton.length) {
                $CloseButton.trigger('click');
            }
            else {
                DefaultCloseFunction();
            }
            return false;
        });

        // Add CloseOnClickOutside functionality
        if (Params.CloseOnClickOutside) {
            $(document).unbind('click.Dialog').bind('click.Dialog', function (event) {
                // If target element is removed before this event triggers, the enclosing div.Dialog can't be found anymore
                // We check, if we can find a parent HTML element to be sure, that the element is not removed
                if ($(event.target).parents('html').length && $(event.target).closest('div.Dialog').length === 0) {
                    TargetNS.CloseDialog($('div.Dialog:visible'));
                }
            });
        }

        // Add resize event handler for calculating the scroll height
        $(window).unbind('resize.Dialog').bind('resize.Dialog', function (event) {
            AdjustScrollableHeight();
        });

        // Init KeyEvent-Logger
        InitKeyEvent(Params.CloseOnEscape);

        // Focus first focusable element
        FocusFirstElement();
    }

    /**
     * @function
     * @description
     *      Shows a default dialog.
     * @param HTML The content HTML which should be shown
     * @param Title The title of the dialog
     * @param PositionTop The top position the dialog is positioned initially
     * @param PositionLeft The left position the dialog is positioned initially
     * @param Modal If defined and set to true, an overlay is shown for a modal dialog
     * @param Buttons The button array
     * @return nothing
     */
    TargetNS.ShowContentDialog = function (HTML, Title, PositionTop, PositionLeft, Modal, Buttons) {
        ShowDialog({
            HTML: HTML,
            Title: Title,
            Modal: Modal,
            CloseOnClickOutside: true,
            CloseOnEscape: true,
            PositionTop: PositionTop,
            PositionLeft: PositionLeft,
            Buttons: Buttons
        });
    };

    /**
     * @function
     * @description
     *      Shows a alert dialog.
     * @param Headline The bold headline
     * @param Text The description
     * @param CloseFunction The special function which is started on closing the dialog (optional, if used also the removing of the dialog itself must be handled)
     * @return nothing
     */
    TargetNS.ShowAlert = function (Headline, Text, CloseFunction) {
        ShowDialog({
            Type: 'Alert',
            Modal: true,
            Headline: Headline,
            Text: Text,
            OnClose: CloseFunction
        });
    };

    /**
     * @function
     * @description
     *      Closes all dialogs specified.
     * @param Object The jQuery object that defines the dialog or any child element of it, which should be closed
     * @return nothing
     */
    TargetNS.CloseDialog = function (Object) {
        var BackupHTML, BackupHTMLSelector;
        $(Object).closest('.Dialog:visible').remove();
        $('#Overlay').remove();
        $('body').css({
            'overflow': 'auto',
            'position': 'static'
        });
        $(document).unbind('keydown.Dialog').unbind('keypress.Dialog').unbind('click.Dialog');
        $(window).unbind('resize.Dialog');

        // Revert orignal html
        BackupHTMLSelector = Core.Data.Get($('body'), 'DialogCopySelector');
        BackupHTML = Core.Data.Get($('body'), 'DialogCopy');
        if (BackupHTML && BackupHTMLSelector) {
            $(BackupHTMLSelector).append(BackupHTML);
        }
    };

    /**
     * @function
     * @description
     *      Registers the click event for the dialogs.
     * @param {jQueryObject} $Selector The jQuery Object on which the click event for the dialog should be registered
     * @param {Object} Params The dialog parameters
     * @return nothing
     */
    TargetNS.RegisterDialog = function ($Selector, Params) {
        $Selector.click(function (event) {
            ShowDialog(Params);
            event.preventDefault();
            event.stopPropagation();
            return false;
        });
    };

    /**
     * @function
     * @description
     *      Registers the click event for content dialogs.
     * @param {jQueryObject} $Selector The jQuery Object on which the click event for the dialog should be registered
     * @param {string} HTML The content HTML which should be shown
     * @param {string} Title The title of the dialog
     * @param {string} PositionTop The top position the dialog is positioned initially
     * @param {string} PositionLeft The left position the dialog is positioned initially
     * @param {boolean} Modal If defined and set to true, an overlay is shown for a modal dialog
     * @return nothing
     */
    TargetNS.RegisterContentDialog = function ($Selector, HTML, Title, PositionTop, PositionLeft, Modal, Buttons) {
        $Selector.click(function (event) {
            TargetNS.ShowContentDialog(HTML, Title, PositionTop, PositionLeft, Modal, Buttons);
            event.preventDefault();
            event.stopPropagation();
            return false;
        });
    };

    /**
     * @function
     * @description
     *      Registers the event for the special attachment dialog.
     * @param {jQueryObject} $Selector The jQuery Object on which the click event for the dialog should be registered
     * @param {string} HTMLString The HTML data to be shown in the dialog, can also be the ID of a HTML containing element
     * @return nothing
     */
    TargetNS.RegisterAttachmentDialog = function ($Selector) {
        $Selector.click(function (event) {
            var Position, HTML, $HTMLObject;
            if ($(this).attr('rel') && $('#' + $(this).attr('rel')).length) {
                Position = $(this).offset();
                Core.UI.Dialog.ShowContentDialog($('#' + $(this).attr('rel'))[0].innerHTML, 'Attachments', Position.top, parseInt(Position.left, 10) + 25);
            }
            event.preventDefault();
            event.stopPropagation();
            return false;
        });
    };

    return TargetNS;
}(Core.UI.Dialog || {}));