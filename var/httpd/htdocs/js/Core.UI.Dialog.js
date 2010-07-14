// --
// Core.UI.Dialog.js - Dialogs
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.UI.Dialog.js,v 1.2 2010-07-14 10:47:35 mn Exp $
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
     * @return $FocusableElements
     * @description Gets all focusbale element within the dialog.
     *              The close link in the header should be the last element.
     */
    function GetFocusableElements() {
        var $FocusableElements;
        $FocusableElements = $('div.Dialog:visible .Content').find('a:visible, input:visible, textarea:visible, select:visible, button:visible');
        $FocusableElements.push($('div.Dialog:visible .Header a.Close:visible')[0]);
        return $FocusableElements;
    }

    /**
     * @function
     * @private
     * @param Position number Represents the position of the element to be focused, starting by 0.
     * @return nothing
     * @description Focuses the specified element within the dialog.
     *              Needs the Object "Core.UI.Dialog.$FocusableElements" to be initialized and filled (with function GetFocusableElements()).
     */
    function FocusElement(Position) {
        if (typeof TargetNS.$FocusableElements !== 'undefined' && TargetNS.$FocusableElements.length > Position) {
            $(TargetNS.$FocusableElements[Position]).focus();
            TargetNS.FocusedElement = Position;
        }
    }

    /**
     * @function
     * @private
     * @return nothing
     * @description Focuses the first element within the dialog.
     */
    function FocusFirstElement() {
        FocusElement(0);
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
        /*
         * Opera can't prevent the default action of special keys on keydown. That's why we need a special keypress event here,
         * to prevent the default action for the special keys.
         * See http://www.quirksmode.org/dom/events/keys.html for details
         */
        $(document).unbind('keypress.Dialog').bind('keypress.Dialog', function (event) {
            if ($.browser.opera && (event.keyCode === 9 || (event.keyCode === 27 && CloseOnEscape))) {
                event.preventDefault();
                event.stopPropagation();
                return false;
            }
        }).unbind('keydown.Dialog').bind('keydown.Dialog', function (event) {
            // Shift + Tab pressed
            if (event.keyCode === 9 && event.shiftKey) {
                if ($(event.target).closest('div.Dialog').length === 0) {
                    FocusFirstElement();
                }
                else {
                    // Jump to the previous focusable element in the dialog
                    if (TargetNS.FocusedElement === 0) {
                        FocusElement(TargetNS.$FocusableElements.length - 1);
                    }
                    else {
                        FocusElement(TargetNS.FocusedElement - 1);
                    }
                }
                event.preventDefault();
                event.stopPropagation();
                return false;
            }
            // Tab pressed
            else if (event.keyCode === 9) {
                if ($(event.target).closest('div.Dialog').length === 0) {
                    FocusFirstElement();
                }
                else {
                    // Jump to next focusable element in the dialog
                    if (TargetNS.FocusedElement === (TargetNS.$FocusableElements.length - 1)) {
                        FocusFirstElement();
                    }
                    else {
                        FocusElement(TargetNS.FocusedElement + 1);
                    }
                }
                event.preventDefault();
                event.stopPropagation();
                return false;
            }
            // Escape pressed and CloseOnEscape is true
            else if (event.keyCode === 27 && CloseOnEscape) {
                TargetNS.CloseDialog($('div.Dialog:visible'));
                event.preventDefault();
                event.stopPropagation();
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
        var $Dialog, $Content, $ButtonFooter, ContentScrollHeight,
            DialogHTML = '<div class="Dialog"><div class="Header"><span class="LeftCorner"></span><span><a class="Close" title="' + Core.Config.Get('DialogCloseMsg') + '" href="#"></a></span></div><div class="Content"></div><div class="Footer"><span class="LeftCorner"></span><span></span></div></div>';

        // Close all opened dialogs
        if ($('.Dialog:visible').length) {
            TargetNS.CloseDialog($('.Dialog:visible'));
        }

        // If Dialog is a modal dialog, initialize overlay
        if (Params.Modal) {
            $('<div id="Overlay" tabindex="-1">').appendTo('body');
            $('body').css({
                'overflow': 'hidden',
                'position': 'relative'
            });
            $('#Overlay').height($(window).height()).css('top', $(window).scrollTop());
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
                Params.HTML = (Params.HTML)[0].innerHTML;
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
            $Dialog.find('.Header span:not(.LeftCorner)').prepend('<h1>' + Params.Title + '</h1>');
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
                if ($(event.target).closest('div.Dialog').length === 0) {
                    TargetNS.CloseDialog($('div.Dialog:visible'));
                }
            });
        }

        // Add resize event handler for calculating the scroll height
        $(window).unbind('resize.Dialog').bind('resize.Dialog', function (event) {
            AdjustScrollableHeight();
        });

        // Init KeyEvent-Logger
        TargetNS.$FocusableElements = GetFocusableElements();
        InitKeyEvent(Params.CloseOnEscape);

        // Focus first focusable element
        FocusFirstElement();

        // Set width of header and footer (esp. for IE7)
        if ($.browser.msie && $.browser.version === "7.0") {
            $Dialog.find('.Header > span.LeftCorner + span').width($Dialog.width() - 7);
            $Dialog.find('.Footer > span.LeftCorner + span').width($Dialog.width() - 14);
            $Dialog.find('.Content > .ContentFooter').width($Dialog.width() - 13);
        }
    }

    /**
     * @field
     * @description This variable contains al focusable elements of the open dialog.
     */
    TargetNS.$FocusableElements = [];

    /**
     * @field
     * @description The latest focused element of the open dialog.
     */
    TargetNS.FocusedElement = 0;

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
        $(Object).closest('.Dialog:visible').remove();
        $('#Overlay').remove();
        $('body').css({
            'overflow': 'auto',
            'position': 'static'
        });
        $(document).unbind('keydown.Dialog').unbind('keypress.Dialog').unbind('click.Dialog');
        $(window).unbind('resize.Dialog');
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
                $HTMLObject = $('#UIElementPool .AttachmentDialog').clone().find('.AttachmentContent').unwrap();
                $HTMLObject.append($('#' + $(this).attr('rel'))[0].innerHTML);
                Core.UI.Dialog.ShowContentDialog($HTMLObject.html(), 'Attachments', Position.top, parseInt(Position.left, 10) + 25);
            }
            event.preventDefault();
            event.stopPropagation();
            return false;
        });
    };

    return TargetNS;
}(Core.UI.Dialog || {}));