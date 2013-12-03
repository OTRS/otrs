// --
// Core.Customer.TicketZoom.js - provides functions for the customer login
// Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.Customer = Core.Customer || {};

/**
 * @namespace
 * @exports TargetNS as Core.Customer.TicketZoom
 * @description
 *      This namespace contains all functions for CustomerTicketZoom.
 */
Core.Customer.TicketZoom = (function (TargetNS) {
    if (!Core.Debug.CheckDependency('Core.Customer', 'Core.UI.RichTextEditor', 'Core.UI.RichTextEditor')) {
        return;
    }

    /**
     * @function
     * @param {DOMObject} an iframe
     * @description
     *      sets the size of the iframe to the size of its inner html
     *      .contents accesses the iframe to get its height
     */

    function CalculateHeight(Iframe){
        Iframe =  isJQueryObject(Iframe) ? Iframe.get(0) : Iframe;
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

            $(Iframe).height(NewHeight + 'px');
        }, 1500);
    }

    /**
     * @function
     * @param {DOMObject} an iframe
     * @description     *
     */
    function ResizeIframe(Iframe, Callback){
        // initial height calculation
        $(Iframe).attr('onload', function() {
            CalculateHeight(this);
            if ($.isFunction(Callback)) {
                Callback();
            }
        });
    }

    /**
     * @function
     * @param {DOMObject} an iframe
     * @description
     *      This function contains some workarounds for all browsers to get re-size the iframe
     * @see http://sonspring.com/journal/jquery-iframe-sizing
     */
    function CheckIframe(Iframe, callback){
        if ($.browser.safari || $.browser.opera){
            $(Iframe).load(function(){
                setTimeout(ResizeIframe, 0, this, callback);
            });
            var Source = Iframe.src;
            Iframe.src = '';
            Iframe.src = Source;
        }
        else {
            $(Iframe).load(function(){
                ResizeIframe(this, callback);
            });
        }
    }

    /**
     * @function
     * @description
     *      This function is called when an articles should be loaded. Our trick is, to hide the
     *      url of a containing iframe in the title attribute of the iframe so that it doesn't load
     *      immediately when the site loads. So we set the url in this function.
     */

    function LoadMessage($Message, $Status){
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
            /*  Set StateStorage to true */
            $Status.val('true');

            /*  Show MessageContent -> add class Visible */
            $Message.addClass('Visible');

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
     * @function
     * @description
     *      This function checks the value of a hidden input field containing the state of the article:
     *      untouched (= not yet loaded), true or false. If the article is already loaded (-> true), and
     *      user calls this function by clicking on the message head, the article gets hidden by removing
     *      the class 'Visible' and the status changes to false. If the message head is clicked while the
     *      status is false (e.g. the article is hidden), the article gets the class 'Visible' again and
     *      the status gets changed to true.
     */

    function ToggleMessage($Message){
        var $Status = $('> input[name=ArticleState]', $Message);
        switch ($Status.val()){
            case "untouched":
                LoadMessage($Message, $Status);
            break;
            case "true":
                $Message.removeClass('Visible');
                $Status.val("false");
            break;
            case "false":
                $Message.addClass('Visible');
                $Status.val("true");
            break;
        }
    }

    /**
     * @function
     * @description
     *      This function binds functions to the 'MessageHeader' and the 'Reply' button
     *      to toggle the visibility of the MessageBody and the reply form.
     *      Also it checks the iframes to re-size them to their full (inner) size
     *      and hides the quotes inside the iframes + adds an anchor to toggle the visibility of the quotes
     */
    TargetNS.Init = function(){
        var $Messages = $('#Messages > li'),
            $VisibleMessage = $Messages.last(),
            $VisibleIframe = $('.VisibleFrame'),
            $MessageHeaders = $('.MessageHeader', $Messages),
            $FollowUp = $('#FollowUp'),
            $RTE = $('#RichText'),
            ZoomExpand = $('#ZoomExpand').val();

        $MessageHeaders.click(function(Event){
            ToggleMessage($(this).parent());
            Event.preventDefault();
        });
        $('#ReplyButton').click(function(Event){
            Event.preventDefault();
            $FollowUp.addClass('Visible');
            $('html').css({scrollTop: $('#Body').height()});
            Core.UI.RichTextEditor.Focus($RTE);
        });
        $('#CloseButton').click(function(Event){
            Event.preventDefault();
            $FollowUp.removeClass('Visible');
            $('html').css({scrollTop: $('#Body').height()});
        });
        /* correct the status saved in the hidden field for all visible messages if ZoomExpand is present*/
        if (!ZoomExpand || isNaN(ZoomExpand)) {
            $('> input[name=ArticleState]', $Messages).val("true");
            ResizeIframe($VisibleIframe);
        }
        else {
            /* correct the status saved in the hidden field of the initial visible message */
            $('> input[name=ArticleState]', $VisibleMessage).val("true");
            ResizeIframe($VisibleIframe.get(0));
        }
    };

    return TargetNS;
}(Core.Customer.TicketZoom || {}));
