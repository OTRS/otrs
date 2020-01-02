// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var Core = Core || {};
Core.Customer = Core.Customer || {};

/**
 * @namespace Core.Customer.TicketZoom
 * @memberof Core.Customer
 * @author OTRS AG
 * @description
 *      This namespace contains all functions for CustomerTicketZoom.
 */
Core.Customer.TicketZoom = (function (TargetNS) {
    if (!Core.Debug.CheckDependency('Core.Customer', 'Core.UI.RichTextEditor', 'Core.UI.RichTextEditor')) {
        return false;
    }

    /**
     * @private
     * @name CalculateHeight
     * @memberof Core.Customer.TicketZoom
     * @function
     * @param {DOMObject} Iframe - DOM representation of an iframe
     * @description
     *      Sets the size of the iframe to the size of its inner html.
     */
    function CalculateHeight(Iframe){
        Iframe = isJQueryObject(Iframe) ? Iframe.get(0) : Iframe;

        setTimeout(function () {
            var $IframeContent = $(Iframe.contentDocument || Iframe.contentWindow.document),
                NewHeight = $IframeContent.height();
            if (!NewHeight || isNaN(NewHeight)) {
                NewHeight = 100;
            }
            else {
                if (NewHeight > 2500) {
                    NewHeight = 2500;
                }
            }

            NewHeight = parseInt(NewHeight, 10) + 25;
            $(Iframe).height(NewHeight + 'px');
        }, 1500);
    }

    /**
     * @private
     * @name CalculateHeight
     * @memberof Core.Customer.TicketZoom
     * @function
     * @param {DOMObject} Iframe - DOM representation of an iframe
     * @param {Function} [Callback]
     * @description
     *      Resizes Iframe to its max inner height and (optionally) calls callback.
     */
    function ResizeIframe(Iframe, Callback){
        Iframe = isJQueryObject(Iframe) ? Iframe.get(0) : Iframe;
        CalculateHeight(Iframe);
        if ($.isFunction(Callback)) {
            Callback();
        }
    }

    /**
     * @private
     * @name CheckIframe
     * @memberof Core.Customer.TicketZoom
     * @function
     * @param {DOMObject} Iframe - DOM representation of an iframe
     * @param {Function} [Callback]
     * @description
     *      This function contains some workarounds for all browsers to get re-size the iframe.
     * @see http://sonspring.com/journal/jquery-iframe-sizing
     */
    function CheckIframe(Iframe, Callback){
        var Source;

        Iframe = isJQueryObject(Iframe) ? Iframe.get(0) : Iframe;

        if ($.browser.safari || $.browser.opera){
            $(Iframe).on('load', function() {
                setTimeout(ResizeIframe, 0, Iframe, Callback);
            });
            Source = Iframe.src;
            Iframe.src = '';
            Iframe.src = Source;
        }
        else {
            $(Iframe).on('load', function() {
                ResizeIframe(this, Callback);
            });
        }
    }

    /**
     * @private
     * @name LoadMessage
     * @memberof Core.Customer.TicketZoom
     * @function
     * @param {jQueryObject} $Message
     * @description
     *      This function is called when an articles should be loaded. Our trick is, to hide the
     *      url of a containing iframe in the title attribute of the iframe so that it doesn't load
     *      immediately when the site loads. So we set the url in this function.
     */
    function LoadMessage($Message){
        var $SubjectHolder = $('h3 span', $Message),
            Subject = $SubjectHolder.text(),
            LoadingString = $SubjectHolder.attr('title'),
            $Iframe = $('iframe', $Message),
            Source = $Iframe.attr('title');

        /*  Change Subject to Loading */
        $SubjectHolder.text(LoadingString);

        /*  Load iframe -> get title and put it in src */
        if (Source !== 'about:blank') {
            $Iframe.attr('src', Source);
        }

        function Callback(){
            /*  Set data-articlestate to true and add class Visible */
            $Message.attr('data-articlestate', "true").addClass('Visible');

            /*  Change Subject back from Loading */
            $SubjectHolder.text(Subject).attr('title', Subject);
        }

        if ($Iframe.length) {
            CheckIframe($Iframe, Callback);
        }
        else {
            Callback();
        }
    }

    /**
     * @private
     * @name ToggleMessage
     * @memberof Core.Customer.TicketZoom
     * @function
     * @param {jQueryObject} $Message
     * @description
     *      This function checks the value of data-articlestate attribute containing the state of the article:
     *      untouched (= not yet loaded), true or false. If the article is already loaded (-> true), and
     *      user calls this function by clicking on the message head, the article gets hidden by removing
     *      the class 'Visible' and the status changes to false. If the message head is clicked while the
     *      status is false (e.g. the article is hidden), the article gets the class 'Visible' again and
     *      the status gets changed to true.
     */
    function ToggleMessage($Message){
        switch ($Message.attr('data-articlestate')) {
            case "untouched":
                LoadMessage($Message);
            break;
            case "true":
                $Message.removeClass('Visible');
                $Message.attr('data-articlestate', "false");
            break;
            case "false":
                $Message.addClass('Visible');
                $Message.attr('data-articlestate', "true");
            break;
        }
    }

    /**
     * @name Init
     * @memberof Core.Customer.TicketZoom
     * @function
     * @description
     *      This function binds functions to the 'MessageHeader' and the 'Reply' button
     *      to toggle the visibility of the MessageBody and the reply form.
     *      Also it checks the iframes to re-size them to their full (inner) size
     *      and hides the quotes inside the iframes + adds an anchor to toggle the visibility of the quotes.
     *      Furthermore it execute field updates, add and remove of attachments.
     */
    TargetNS.Init = function(){
        var $VisibleIframe = $('.VisibleFrame'),
            $FollowUp = $('#FollowUp'),
            $RTE = $('#RichText'),
            ZoomExpand = $('#ZoomExpand').val(),
            $Form,
            FieldID,
            DynamicFieldNames = Core.Config.Get('DynamicFieldNames');

        $('#Messages > li > .MessageHeader').on('click', function(Event){
            ToggleMessage($(this).parent());
            Event.preventDefault();
        });
        $('#ReplyButton').on('click', function(Event){
            Event.preventDefault();
            $FollowUp.addClass('Visible');
            $('html').css({scrollTop: $('#Body').height()});
            Core.UI.RichTextEditor.Focus($RTE);
        });
        $('#CloseButton').on('click', function(Event){
            Event.preventDefault();
            $FollowUp.removeClass('Visible');
            $('html').css({scrollTop: $('#Body').height()});
        });
        /* Set statuses saved in the hidden fields for all visible messages if ZoomExpand is present */
        if (!ZoomExpand || isNaN(ZoomExpand)) {
            $('#Messages > li').attr('data-articlestate', "true");
            ResizeIframe($VisibleIframe);
        }
        else {
            /* Set statuses saved in the hidden fields for all messages */
            $('#Messages > li:not(:last)').attr('data-articlestate', "untouched");
            $('#Messages > li:last').attr('data-articlestate', "true");
            ResizeIframe($VisibleIframe.get(0));
        }

        // init browser link message close button
        if ($('.MessageBrowser').length) {
            $('.MessageBrowser a.Close').on('click', function () {
                var Data = {
                    Action: 'CustomerTicketZoom',
                    Subaction: 'BrowserLinkMessage',
                    TicketID: $('input[name=TicketID]').val()
                };

                $('.MessageBrowser').fadeOut("slow");

                // call server, to save that the bo was closed and do not show it again on reload
                Core.AJAX.FunctionCall(
                    Core.Config.Get('CGIHandle'),
                    Data,
                    function () {}
                );

                return false;
            });
        }

        // Bind event to State field.
        $('#StateID').on('change', function () {
            Core.AJAX.FormUpdate($('#ReplyCustomerTicket'), 'AJAXUpdate', 'StateID', ['PriorityID', 'TicketID'].concat(DynamicFieldNames));
        });

        // Bind event to Priority field.
        $('#PriorityID').on('change', function () {
            Core.AJAX.FormUpdate($('#ReplyCustomerTicket'), 'AJAXUpdate', 'PriorityID', ['StateID', 'TicketID'].concat(DynamicFieldNames));
        });

        // Bind event to AttachmentUpload button.
        $('#Attachment').on('change', function () {
            var $Form = $('#Attachment').closest('form');
            Core.Form.Validate.DisableValidation($Form);
            $Form.find('#AttachmentUpload').val('1').end().submit();
        });

        // Bind event to AttachmentDelete button.
        $('button[id*=AttachmentDeleteButton]').on('click', function () {
            $Form = $(this).closest('form');
            FieldID = $(this).attr('id').split('AttachmentDeleteButton')[1];
            $('#AttachmentDelete' + FieldID).val(1);
            Core.Form.Validate.DisableValidation($Form);
            $Form.trigger('submit');
        });

        $('a.AsPopup').on('click', function () {
            Core.UI.Popup.OpenPopup($(this).attr('href'), 'TicketAction');
            return false;
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Customer.TicketZoom || {}));
