// --
// Core.Agent.TicketZoom.js - provides the special module functions for TicketZoom
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.Agent.TicketZoom.js,v 1.12 2010-07-30 09:24:31 martin Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};

/**
 * @namespace
 * @exports TargetNS as Core.Agent.TicketZoom
 * @description
 *      This namespace contains the special module functions for TicketZoom.
 */
Core.Agent.TicketZoom = (function (TargetNS) {
    /**
     * @function
     * @param {jQueryObject} $Iframe The iframe which should be auto-heighted
     * @return nothing
     *      This function initializes the special module functions
     */
    TargetNS.IframeAutoHeight = function ($Iframe) {
        if (isJQueryObject($Iframe)) {
            var NewHeight = $Iframe.get(0).contentWindow.document.body.scrollHeight;
            if (!NewHeight || isNaN(NewHeight)) {
                NewHeight = Core.Config.Get('Ticket::Frontend::HTMLArticleHeightDefault');
            }
            else {
                if (NewHeight > Core.Config.Get('Ticket::Frontend::HTMLArticleHeightMax')) {
                    NewHeight = Core.Config.Get('Ticket::Frontend::HTMLArticleHeightMax');
                }
            }
            $Iframe.height(NewHeight + 'px');
        }
    };

    /**
     * @function
     * @private
     * @param {String} ArticleURL The URL which should be loaded via AJAX
     * @param {String} ArticleID The article number of the loaded article
     * @return nothing
     *      This function loads the given article via ajax
     */
    function LoadArticle(ArticleURL, ArticleID) {

        // Clear timeout for URL hash check, because hash is now changed manually
        window.clearTimeout(TargetNS.CheckURLHashTimeout);

        // Add loader to the widget
        $('#ArticleItems .WidgetBox').addClass('Loading');
        Core.AJAX.ContentUpdate($('#ArticleItems'), ArticleURL, function () {
            $('#ArticleItems a.AsPopup').bind('click', function (Event) {
                Core.UI.Popup.OpenPopup($(this).attr('href'), 'Action');
                return false;
            });

            // Add event bindings to new widget
            Core.UI.InitWidgetActionToggle();

            // Add hash to the URL to provide direct URLs and history back/forward functionality
            location.hash = '#' + ArticleID;
            TargetNS.ActiveURLHash = location.hash.replace(/#/, '');

            //Remove Loading class
            $('#ArticleItems .WidgetBox').removeClass('Loading');

            // Initiate URL hash chack again
            TargetNS.CheckURLHashTimeout = window.setTimeout(function () {
                TargetNS.CheckURLHash();
            }, 500);
        });
    }

    /**
     * @function
     * @return nothing
     *      This function checks if teh url hash has changed and initiates an article load
     */
    TargetNS.CheckURLHash = function () {

        // if not defined yet
        if (typeof TargetNS.ActiveURLHash === 'undefined') {
            TargetNS.ActiveURLHash = location.hash.replace(/#/, '');
        }

        // if defined and saved value is different to latest value (= user has used history back or forward)
        else if (TargetNS.ActiveURLHash !== location.hash.replace(/#/, '')) {
            TargetNS.ActiveURLHash = location.hash.replace(/#/, '');

            // if article ID is found in article list (= article id is valid)
            $ArticleElement = $('#FixedTable').find('input.ArticleID[value=' + TargetNS.ActiveURLHash + ']');
            if ($ArticleElement.length) {

                // Add active state to new row
                $($ArticleElement).closest('table').find('tr').removeClass('Active').end().end().closest('tr').addClass('Active');

                // Load content of new article
                LoadArticle($ArticleElement.closest('td').find('input.ArticleInfo').val(), TargetNS.ActiveURLHash);
            }
        }

        // start check again in 500ms
        TargetNS.CheckURLHashTimeout = window.setTimeout(function () {
            TargetNS.CheckURLHash();
        }, 500);
    }

    /**
     * @function
     * @return nothing
     *      This function initializes the special module functions
     */
    TargetNS.Init = function () {
        var $THead = $('#FixedTable thead'),
            $TBody = $('#FixedTable tbody'),
            ZoomExpand = !$('div.ArticleView a.OneArticle').hasClass('Active'),
            URLHash,
            $ArticleElement;

        Core.UI.Resizable.Init($("#ArticleTableBody"));
        Core.UI.InitTableHead($THead, $TBody);

        $(window).resize(function () {
            window.clearTimeout(TargetNS.ResizeTimeOut);
            TargetNS.ResizeTimeOut = window.setTimeout(function () {
                Core.UI.AdjustTableHead($THead, $TBody);
            }, 500);
        });

        Core.UI.Dialog.RegisterAttachmentDialog($('.TableSmall tbody td a.Attachment'));

        // Table sorting
        Core.UI.Table.Sort.Init($('#FixedTable'), function () {
            $(this).find('tr')
                .removeClass('Even')
                .filter(':even')
                .addClass('Even')
                .end()
                .removeClass('Last')
                .filter(':last')
                .addClass('Last');
        });

        // load another article, if in "show one article" mode and article id is provided by location hash
        if (!ZoomExpand) {
            URLHash = location.hash.replace(/#/, '');

            // if article ID is found in article list (= article id is valid)
            $ArticleElement = $('#FixedTable').find('input.ArticleID[value=' + URLHash + ']');
            if ($ArticleElement.length) {

                // Add active state to new row
                $($ArticleElement).closest('table').find('tr').removeClass('Active').end().end().closest('tr').addClass('Active');

                // Load content of new article
                LoadArticle($ArticleElement.closest('td').find('input.ArticleInfo').val(), URLHash);
            }

            // if URL hash is empty, set it initially to the active article for working browser history
            else if (URLHash === '') {
                location.hash = '#' + $('#FixedTable tr.Active input.ArticleID').val();
            }
        }

        // loading new articles
        $('#FixedTable tr').bind('click', function (Event) {

            // Mode: show one article - load new article via ajax
            if (!ZoomExpand) {

                // Add active state to new row
                $(this).closest('table').find('tr').removeClass('Active').end().end().addClass('Active');

                // Mark old row as readed
                $(this).closest('table').find('tr').removeClass('UnreadArticles');

                // Load content of new article
                LoadArticle($(this).find('input.ArticleInfo').val(), $(this).find('input.ArticleID').val());
            }

            // Mode: show all articles - jump to the selected article
            else {
                location.href = '#Article' + $(this).find('input.ArticleID').val();
            }

            return false;
        });

        // init control function to check the location hash, if the user used the history back or forward buttons
        if (!ZoomExpand) {
            TargetNS.CheckURLHashTimeout = window.setTimeout(function(){
                TargetNS.CheckURLHash();
            }, 500);
        }
    };

    return TargetNS;
}(Core.Agent.TicketZoom || {}));
