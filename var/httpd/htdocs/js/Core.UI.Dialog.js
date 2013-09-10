// --
// Core.UI.Dialog.js - Dialogs
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
 * @exports TargetNS as Core.UI.Dialog
 * @description
 *      Contains the code for the different dialogs.
 */
Core.UI.Dialog = (function (TargetNS) {

    /*
     * check dependencies first
     */
    if (!Core.Debug.CheckDependency('Core.UI.Dialog', '$([]).draggable', 'jQuery UI draggable')) {
        return;
    }
    if (!Core.Debug.CheckDependency('Core.UI.Dialog', 'Core.Config', 'Core.Config')) {
        return;
    }

    /**
     * @function
     * @return nothing
     * @description Adjusts the scrollable inner container of the dialog after every resizing.
     */
    function AdjustScrollableHeight(AllowAutoGrow) {
        // Check window height and adjust the scrollable height of InnerContent
        // Calculation:
        // Window height
        // - top margin of dialog twice (for top and bottom) - only use this for big dialog windows
        // - some static pixels for Header and Footer of dialog
        var ContentScrollHeight = 0,
            WindowHeight = $(window).height(),
            WindowScrollTop = $(window).scrollTop(),
            DialogTopMargin = $('.Dialog:visible').offset().top,
            DialogHeight = $('.Dialog:visible').height();

        // if dialog height is more than 300px recalculate width of InnerContent to make it scrollable
        // if dialog is smaller than 300px this is not necessary
        // if AllowAutoGrow is set, auto-resizing should be possible
        if (AllowAutoGrow || DialogHeight > 300) {
            ContentScrollHeight = WindowHeight - ((DialogTopMargin - WindowScrollTop) * 2) - 100;
        }
        else {
            ContentScrollHeight = 200;
        }
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
     * @param Params Hash with different config options:
     *               Modal: true|false (default: false) Shows a dark background overlay behind the dialog
     *               Type: Alert|Search (default: undefined) Defines a special type of dialog
     *               Title: string (default: undefined) Defines the title of the dialog window
     *               Headline: string (default: undefined) Defines a special headline within the dialog window
     *               Text: string (default: undefined) The text which is outputtet in the dialog window
     *               HTML: string (default: undefined) Used for content dialog windows. Contains a complete HTML snippet or an jQuery object with containing HTML
     *               PositionTop: value (default: undefined) Defines the top position of the dialog window
     *               PositionBottom: value (default: undefined) Defines the bottom position of the dialog window
     *               PositionLeft: value|Center (default: undefined) Defines the left position of the dialog window. Center centers the window
     *               PositionRight: value (default: undefined) Defines the right position of the dialog window
     *               CloseOnClickOutside true|false (default: false) If true, clicking outside the dialog closes the dialog
     *               CloseOnEscape true|false (default: false) If true, pressing escape key closes the dialog
     *               AllowAutoGrow: true|false (default: false) If true, the InnerContent of the dialog can resize until the max window height is reached,
     *                                                          If false (default), InnerContent of small dialogs does not resize over 200px
     *               Buttons: Array of Hashes with the following properties (buttons are placed in a div "footer" of the dialog):
     *                  Label: string Text of the button
     *                  Type: string 'Submit'|'Close' (default: none) Special type of the button - invokes a standard function
     *                  Class: string Optional class parameters for the button element
     *                  Function: function The function which is executed on click (optional)
     * @return nothing
     * @description The main dialog function used for all different types of dialogs.
     */
    TargetNS.ShowDialog = function(Params) {
        // If no callback function for the close is given (via the Button definition),
        // the dialog is just closed
        // otherwise the defined Close button is triggered
        // this invokes the callback and the closing of the dialog
        function HandleClosingAction() {
            var $CloseButton = $('.Dialog:visible button.Close');

            // Hide any possibly existing tooltips.
            if (Core.Form && Core.Form.ErrorTooltips) {
                Core.Form.ErrorTooltips.HideTooltip();
            }

            if ($CloseButton.length) {
                $CloseButton.trigger('click');
            }
            else {
                DefaultCloseFunction();
            }
        }

        // Calculates the correct position of the dialog, given by the Position
        // Type can be 'top' or 'bottom'
        function CalculateDialogPosition(Position, Type) {
            var ScrollTop = $(window).scrollTop(),
                WindowHeight = $(window).height();

            Type = Type || 'top';
            // convert Position to a string so that numbers can be passed too
            //  (later string operations are executed on that object)
            Position = Position.toString();

            // position is in percent
            if (Position.match(/%/)) {
                Position = parseInt(Position.replace(/%/, ''), 10);
                if (Type === 'top') {
                    Position = parseInt(WindowHeight * (Position / 100), 10) + ScrollTop;
                }
                else if (Type === 'bottom') {
                    Position = WindowHeight + ScrollTop - parseInt(WindowHeight * (Position / 100), 10);
                }
            }
            // handle as px
            else {
                Position = parseInt(Position.replace(/px/, ''), 10);
                if (Type === 'top') {
                    Position = Position + ScrollTop;
                }
                else if (Type === 'bottom') {
                    Position = WindowHeight + ScrollTop - Position;
                }
            }

            return (Position + 'px');
        }

        var $Dialog, $Content, $ButtonFooter, ContentScrollHeight, HTMLBackup, DialogCopy, DialogCopySelector, $InnerContent, InnerContentWidth = 0,
            DialogHTML = '<div class="Dialog"><div class="Header"><a class="Close" title="' + Core.Config.Get('DialogCloseMsg') + '" href="#"><i class="icon-remove"></i></a></div><div class="Content"></div><div class="Footer"></div></div>';

        // Close all opened dialogs
        if ($('.Dialog:visible').length) {
            TargetNS.CloseDialog($('.Dialog:visible'));
        }

        // If Dialog is a modal dialog, initialize overlay
        if (Params.Modal) {
            $('<div id="Overlay" tabindex="-1">').appendTo('body');
            $('body').css({
                'overflow': 'hidden'
            });
            $('#Overlay').height($(document).height()).css('top', 0);

            // If the underlying page is perhaps to small, wie extend the page to window height for the dialog
            $('body').css('min-height', $(window).height());
        }

        // Build Dialog HTML
        $Dialog = $(DialogHTML);

        if (Params.Modal) {
            $Dialog.addClass('Modal');
        }

        // If Param HTML is provided, get the HTML data
        // Data can be a HTML string or an jQuery object with containing HTML data
        if (Params.HTML) {
            // If the data is a string, this is created dynamically or was delivered via AJAX.
            // But if the data is a jQueryObject, that means, that the prepared HTML code for the dialog
            // was originally put as part of the DTL into the HTML page
            // For compatibility reasons (no double IDs etc.) we have to cut out the dialog HTML and
            // only use it for the dialog itself.
            // After the dialog is closed again we have to revert this cut-out, because otherwise we
            // could not open the dialog again (because the HTML would be missing).
            // But we cannot use the Dialog HTML to put it back in the page, because this HTML could be changed
            // in the dialog. So we have to save the data somewhere which was cut out and write it back later.
            // Be careful: There can be more than one dialog, we have to save the data dependent on the dialog

            // Get HTML with JS function innerHTML, because jQuery html() strips out the script blocks
            if (typeof Params.HTML !== 'string' && isJQueryObject(Params.HTML)) {
                // First get the data structure, ehich is (perhaps) already saved
                // If the data does not exists Core.Data.Get returns an empty hash
                DialogCopy = Core.Data.Get($('body'), 'DialogCopy');
                HTMLBackup = (Params.HTML)[0].innerHTML;
                DialogCopySelector = Params.HTML.selector;
                // Add the new HTML data to the data structure and save it to the document
                DialogCopy[DialogCopySelector] = HTMLBackup;
                Core.Data.Set($('body'), 'DialogCopy', DialogCopy);
                // Additionally, we save the selector as data on the dialog itself for later restoring
                // Remove the original dialog template content from the page
                Params.HTML.empty();
                // and use the variable as string (!!) with the content which was cut out
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
                Type: 'Close',
                Function: Params.OnClose
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
            $Dialog.find('div.Header').append('<h1>' + Params.Title + '</h1>');
        }

        // Add Dialog to page
        $Dialog.appendTo('body');

        // Check if "ContentFooter" is used in Content
        if ($Dialog.find('.Content .ContentFooter').length) {
            // change default Footer
            $Dialog.find('.Footer').addClass('ContentFooter');
            // add special css for IE8
            if ($.browser.msie && $.browser.version === 8) {
                $InnerContent = $Dialog.find('.Content .InnerContent');
                InnerContentWidth = $InnerContent.width() + parseInt($InnerContent.css('padding-left'), 10) + parseInt($InnerContent.css('padding-right'), 10);
                $Dialog.find('.Content .ContentFooter').width(InnerContentWidth);
            }
        }

        // Now add the selector for the original dialog template content to the dialog, if it exists
        if (DialogCopySelector && DialogCopySelector.length) {
            Core.Data.Set($Dialog, 'DialogCopySelector', DialogCopySelector);
        }

        // Set position for Dialog
        if (Params.Type === 'Alert') {
            $Dialog.css({
                top:    $(window).scrollTop() + ($(window).height() * 0.3),
                left:   Math.round(($(window).width() - $Dialog.width()) / 2)
            });
        }

        if (typeof Params.PositionTop !== 'undefined') {
            $Dialog.css('top', CalculateDialogPosition(Params.PositionTop, 'top'));
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
            $Dialog.css('bottom', CalculateDialogPosition(Params.PositionBottom, 'bottom'));
        }
        if (typeof Params.PositionRight !== 'undefined') {
            $Dialog.css('right', Params.PositionRight);
        }

        // Check window height and adjust the scrollable height of InnerContent
        AdjustScrollableHeight(Params.AllowAutoGrow);

        // Add event-handling
        $Dialog.draggable({
            containment: 'body',
            handle: '.Header',
            start: function(Event, UI) {
                // Hide any possibly existing tooltips as they will not be moved
                //  with this dialog.
                if (Core.Form && Core.Form.ErrorTooltips) {
                    Core.Form.ErrorTooltips.HideTooltip();
                }
            }
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
            HandleClosingAction();
            return false;
        });

        // Add CloseOnClickOutside functionality
        if (Params.CloseOnClickOutside) {
            $(document).unbind('click.Dialog').bind('click.Dialog', function (event) {
                // If target element is removed before this event triggers, the enclosing div.Dialog can't be found anymore
                // We check, if we can find a parent HTML element to be sure, that the element is not removed
                if ($(event.target).parents('html').length && $(event.target).closest('div.Dialog').length === 0) {
                    HandleClosingAction();
                }
            });
        }

        // Add resize event handler for calculating the scroll height
        $(window).unbind('resize.Dialog').bind('resize.Dialog', function () {
            AdjustScrollableHeight(Params.AllowAutoGrow);
        });

        // Init KeyEvent-Logger
        InitKeyEvent(Params.CloseOnEscape);

        // Focus first focusable element
        FocusFirstElement();
    };

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
    TargetNS.ShowContentDialog = function (HTML, Title, PositionTop, PositionLeft, Modal, Buttons, AllowAutoGrow) {
        TargetNS.ShowDialog({
            HTML: HTML,
            Title: Title,
            Modal: Modal,
            CloseOnClickOutside: true,
            CloseOnEscape: true,
            PositionTop: PositionTop,
            PositionLeft: PositionLeft,
            Buttons: Buttons,
            AllowAutoGrow: AllowAutoGrow
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
        TargetNS.ShowDialog({
            Type: 'Alert',
            Modal: true,
            Title: Headline,
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
        var $Dialog, DialogCopy, DialogCopySelector, BackupHTML, Editor;
        $Dialog = $(Object).closest('.Dialog:visible');

        // Get the original selector for the content template
        DialogCopySelector = Core.Data.Get($Dialog, 'DialogCopySelector');

        $Dialog.remove();
        $('#Overlay').remove();
        $('body').css({
            'overflow': 'auto'
        });
        $(document).unbind('keydown.Dialog').unbind('keypress.Dialog').unbind('click.Dialog');
        $(window).unbind('resize.Dialog');
        $('body').css('min-height', 'auto');

        // Revert orignal html
        if (DialogCopySelector.length) {
            DialogCopy = Core.Data.Get($('body'), 'DialogCopy');
            // Get saved HTML
            if (typeof DialogCopy !== 'undefined') {
                BackupHTML = DialogCopy[DialogCopySelector];

                // If HTML could be restored, write it back into the page
                if (BackupHTML && BackupHTML.length) {
                    $(DialogCopySelector).append(BackupHTML);
                }

                // delete this variable from the object
                delete DialogCopy[DialogCopySelector];
            }

            // write the new DialogCopy back
            Core.Data.Set($('body'), 'DialogCopy', DialogCopy);
        }
    };

    return TargetNS;
}(Core.UI.Dialog || {}));
