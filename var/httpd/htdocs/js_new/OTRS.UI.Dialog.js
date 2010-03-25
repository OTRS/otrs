// --
// OTRS.UI.Dialog.js - Dialogs
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.UI.Dialog.js,v 1.1 2010-03-25 15:04:37 mg Exp $
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
 * @description
 *      Contains the code for the different dialogs.
 */
OTRS.UI.Dialog = (function () {

    /**
     * @function
     * @private
     * @param Params Hash with different config options:
     *               Modal: true|false (default: false) Shows a dark background overlay behind the dialog
     *               Type: Alert|Search (default: undefined) Defines a special type of dialog
     *               Title: string (default: undefnied) Defines the title of the dialog window
     *               Headline: string (default: undefined) Defines a special headline within the dialog window
     *               Text: string (default: undefined) The text which is outputtet in the dialog window
     *               HTML: string (default: undefnied) Used for content dialog windows. Contains a complete HTML snippet
     *               PositionTop: value (default: undefined) Defines the top position of the dilaog window
     *               PositionBottom: value (default: undefined) Defines the bottom position of the dilaog window
     *               PositionLeft: value|Center (default: undefined) Defines the left position of the dilaog window. Center centers the window
     *               PositionRightp: value (default: undefined) Defines the right position of the dilaog window
     *               OnClose: function (default: undefined) Function for closing logic of dialog
     *               CloseOnClickOutside true|false (default: false) If true, clicking outside the dialog closes the dialog
     *               CloseOnEscape true|false (default: false) If true, pressing escape key closes the dialog
     * @return nothing
     * @description The main dialog function used for all different types of dialogs.
     */
    function ShowDialog(Params) {
        var $Dialog, $Content, ContentScrollHeight;

        // Alle offenen Dialogs schliessen
        if ($('.Dialog:visible').length) {
            OTRS.UI.Dialog.CloseDialog($('.Dialog:visible'));
        }

        // If Dialog is a modal dialog, initialize overlay
        if (Params.Modal) {
            $('<div id="Overlay" tabindex="-1">').appendTo('body');
            $('body').css({
                'overflow': 'hidden',
                'position': 'relative'
            });
        }

        // Build Dialog HTML
        $Dialog = $('#UIElementPool div.Dialog').clone();

        if (Params.Modal) {
            $Dialog.addClass('Modal');
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
            $Content.append('<div class="Center Spacing"><button type="button" class="Close">Ok</button></div>');
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
            if (Params.HTML) {
                $Content.append(Params.HTML);
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

        // Add event-handling for Close-Buttons and Links
        $Dialog.find('.Header a.Close, button.Close').click(function(){
            if (Params.OnClose && $.isFunction(Params.OnClose)) {
                Params.OnClose();
            }
            else {
                OTRS.UI.Dialog.CloseDialog(this);
            }
            return false;
        });

        // Add CloseOnClickOutside functionality
        if (Params.CloseOnClickOutside) {
            /*
             * Always unbind events before binding...
             */
            $(document).unbind('click.Dialog').bind('click.Dialog', function(event) {
                if ($(event.target).closest('div.Dialog').length == 0) {
                    OTRS.UI.Dialog.CloseDialog($('div.Dialog:visible'));
                }
            });
        }

        // Add resize event handler for calculating the scroll height
        $(window).unbind('resize.Dialog').bind('resize.Dialog', function(event) {
            AdjustScrollableHeight();
        });

        // Init KeyEvent-Logger
        OTRS.UI.Dialog.$FocusableElements = GetFocusableElements();
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
     * @param Position Represents the position of the element to be focused, starting by 0.
     * @return nothing
     * @description Focuses the specified element within the dialog.
     *              Needs the Object "OTRS.UI.Dialog.$FocusableElements" to be initialized and filled (with function GetFocusableElements()).
     */
    function FocusElement(Position) {
        if (typeof OTRS.UI.Dialog.$FocusableElements !== 'undefined' && OTRS.UI.Dialog.$FocusableElements.length > Position) {
            $(OTRS.UI.Dialog.$FocusableElements[Position]).focus();
            OTRS.UI.Dialog.FocusedElement = Position;
        }
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
        $(document).unbind('keypress.Dialog').bind('keypress.Dialog', function(event) {
            if ($.browser.opera && (event.keyCode === 9 || (event.keyCode === 27 && CloseOnEscape))) {
                event.preventDefault();
                event.stopPropagation();
                return false;
            }
        }).unbind('keydown.Dialog').bind('keydown.Dialog', function(event) {
            // Shift + Tab pressed
            if (event.keyCode === 9 && event.shiftKey) {
                if ($(event.target).closest('div.Dialog').length == 0) {
                    FocusFirstElement();
                }
                else {
                    // Jump to the previous focusable element in the dialog
                    if (OTRS.UI.Dialog.FocusedElement === 0) {
                        FocusElement(OTRS.UI.Dialog.$FocusableElements.length - 1);
                    }
                    else {
                        FocusElement(OTRS.UI.Dialog.FocusedElement - 1);
                    }
                }
                event.preventDefault();
                event.stopPropagation();
                return false;
            }
            // Tab pressed
            else if (event.keyCode === 9) {
                if ($(event.target).closest('div.Dialog').length == 0) {
                    FocusFirstElement();
                }
                else {
                    // Jump to next focusable element in the dialog
                    if (OTRS.UI.Dialog.FocusedElement === (OTRS.UI.Dialog.$FocusableElements.length - 1)) {
                        FocusFirstElement();
                    }
                    else {
                        FocusElement(OTRS.UI.Dialog.FocusedElement + 1);
                    }
                }
                event.preventDefault();
                event.stopPropagation();
                return false;
            }
            // Escape pressed and CloseOnEscape is true
            else if (event.keyCode === 27 && CloseOnEscape) {
                OTRS.UI.Dialog.CloseDialog($('div.Dialog:visible'));
                event.preventDefault();
                event.stopPropagation();
                return false;
            }
        });
    }

    /**
     * @function
     * @private
     * @return nothing
     * @description Adjusts the scrollable inner container of the dialog after every resizing.
     */
    function AdjustScrollableHeight(){
        // Check window height and adjust the scrollable height of InnerContent
        var ContentScrollHeight = Math.round(($(window).height() * 0.6) - 50);
        $('.Dialog:visible .Content .InnerContent').css('max-height', ContentScrollHeight);
    }

    return {

        /**
         * @field
         * @description This variable contains al focusable elements of the open dialog.
         */
        $FocusableElements: [],

        /**
         * @field
         * @description The latest focused element of the open dialog.
         */
        FocusedElement: 0,

        /**
         * @function
         * @description
         *      Shows a default dialog.
         * @param HTML The content HTML which should be shown
         * @param Title The title of the dialog
         * @param PositionTop The top position the dialog is positioned initially
         * @param PositionLeft The left position the dialog is positioned initially
         * @param Modal If defined and set to true, an overlay is shown for a modal dialog
         * @return nothing
         */
        ShowContentDialog: function (HTML, Title, PositionTop, PositionLeft, Modal) {
            ShowDialog({
                HTML: HTML,
                Title: Title,
                Modal: Modal,
                CloseOnClickOutside: true,
                CloseOnEscape: true,
                PositionTop: PositionTop,
                PositionLeft: PositionLeft
            });
        },

        /**
         * @function
         * @description
         *      Shows a alert dialog.
         * @param Headline The bold headline
         * @param Text The description
         * @param CloseFunction The special function which is started on closing the dialog (optional, if used also the removing of the dialog itself must be handled)
         * @return nothing
         */
        ShowAlert: function (Headline, Text, CloseFunction) {
            ShowDialog({
                Type: 'Alert',
                Modal: true,
                Headline: Headline,
                Text: Text,
                OnClose: CloseFunction
            });
        },

        /**
         * @function
         * @description
         *      Closes all dialogs specified.
         * @param Object The javascript or jQuery object that defines the dialog or any child element of it, which should be closed
         * @return nothing
         */
        CloseDialog: function (Object) {
            $(Object).closest('.Dialog').remove();
            $('#Overlay').remove();
            $('body').css({
                'overflow': 'auto',
                'position': 'static'
            });
            $(document).unbind('keydown.Dialog').unbind('keypress.Dialog').unbind('click.Dialog');
            $(window).unbind('resize.Dialog');
        }
    };
}());