// --
// Core.Agent.TicketZoom.js - provides the special module functions for TicketZoom
// Copyright (C) 2001-2013 OTRS AG, http://otrs.org/
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
    var CheckURLHashTimeout,
        InitialArticleID;

    /**
     * @function
     * @param {String} TicketID of ticket which get's shown
     * @return nothing
     *      Mark all articles as seen in frontend and backend.
     *      Article Filters will not be considered
     */
    TargetNS.MarkTicketAsSeen = function (TicketID) {
        TargetNS.TicketMarkAsSeenTimeout = window.setTimeout(function () {
            // Mark old row as readed
            $('#ArticleTable .ArticleID').closest('tr').removeClass('UnreadArticles').find('span.UnreadArticles').remove();

            // Mark article as seen in backend
            var Data = {
                Action: 'AgentTicketZoom',
                Subaction: 'TicketMarkAsSeen',
                TicketID: TicketID
            };
            Core.AJAX.FunctionCall(
                Core.Config.Get('CGIHandle'),
                Data,
                function () {}
            );
        }, 3000);
    };

    /**
     * @function
     * @param {String} TicketID of ticket which get's shown
     * @param {String} ArticleID of article which get's shown
     * @return nothing
     *      Mark an article as seen in frontend and backend.
     */
    TargetNS.MarkAsSeen = function (TicketID, ArticleID) {
        TargetNS.MarkAsSeenTimeout = window.setTimeout(function () {
            // Mark old row as readed
            $('#ArticleTable .ArticleID[value=' + ArticleID + ']').closest('tr').removeClass('UnreadArticles').find('span.UnreadArticles').remove();

            // Mark article as seen in backend
            var Data = {
                Action: 'AgentTicketZoom',
                Subaction: 'MarkAsSeen',
                TicketID: TicketID,
                ArticleID: ArticleID
            };
            Core.AJAX.FunctionCall(
                Core.Config.Get('CGIHandle'),
                Data,
                function () {}
            );
        }, 3000);
    };

    /**
     * @function
     * @param {jQueryObject} $Iframe The iframe which should be auto-heighted
     * @return nothing
     *      This function initializes the special module functions
     */
    TargetNS.IframeAutoHeight = function ($Iframe) {
        if (isJQueryObject($Iframe)) {
            var NewHeight = $Iframe.contents().height();
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
        window.clearTimeout(CheckURLHashTimeout);

        // Add loader to the widget
        $('#ArticleItems .WidgetBox').addClass('Loading');
        Core.AJAX.ContentUpdate($('#ArticleItems'), ArticleURL, function () {
            var TicketScrollerTop = 0;

            $('#ArticleItems a.AsPopup').bind('click', function (Event) {
                var Matches,
                    PopupType = 'TicketAction';

                Matches = $(this).attr('class').match(/PopupType_(\w+)/);
                if (Matches) {
                    PopupType = Matches[1];
                }
                Core.UI.Popup.OpenPopup($(this).attr('href'), PopupType);
                return false;
            });

            // Add event bindings to new widget
            Core.UI.InitWidgetActionToggle();

            // Add hash to the URL to provide direct URLs and history back/forward functionality
            // If new ArticleID is again the InitialArticleID than remove hash from URL
            if (ArticleID === InitialArticleID) {
                location.hash = '';
                TargetNS.ActiveURLHash = ArticleID;
            }
            else {
                location.hash = '#' + ArticleID;
                TargetNS.ActiveURLHash = ArticleID;
            }

            //Remove Loading class
            $('#ArticleItems .WidgetBox').removeClass('Loading');

            // Scroll to new active article
            TicketScrollerTop = parseInt($('#ArticleTable tbody tr.Active').offset().top, 10) - parseInt($('#ArticleTable tbody').offset().top, 10);
            $('div.Scroller').get(0).scrollTop = TicketScrollerTop;

            // Initiate URL hash check again
            TargetNS.CheckURLHash();

            // If session is over and login screen
            // is showed in article area
            Core.Agent.CheckSessionExpiredAndReload();

        });
    }

    /**
     * @function
     * @return nothing
     *      This function checks if the url hash (representing the current article)
     *      has changed and initiates an article load. A change can happen by clicking
     *      'back' in the browser, for example.
     */
    TargetNS.CheckURLHash = function () {
        var URLHash = location.hash.replace(/#/, ''),
            $ArticleElement;

        // if URLHash is empty, that means we are watching the initial article,
        // save this information in URLHash as if it would have been in the URL
        if (URLHash === '') {
            URLHash = InitialArticleID;
        }

        // if not defined yet
        if (typeof TargetNS.ActiveURLHash === 'undefined') {
            TargetNS.ActiveURLHash = InitialArticleID;
        }
        // if defined and saved value is different to latest value (= user has used history back or forward)
        else if (TargetNS.ActiveURLHash !== URLHash) {
            TargetNS.ActiveURLHash = URLHash;

            // if article ID is found in article list (= article id is valid)
            $ArticleElement = $('#ArticleTable').find('input.ArticleID[value=' + TargetNS.ActiveURLHash + ']');
            if ($ArticleElement.length) {
                // Add active state to new row
                $($ArticleElement).closest('table').find('tr').removeClass('Active').end().end().closest('tr').addClass('Active');

                // Load content of new article
                LoadArticle($ArticleElement.closest('td').find('input.ArticleInfo').val(), TargetNS.ActiveURLHash);
            }
        }

        // start check again in 500ms
        window.clearTimeout(CheckURLHashTimeout);
        CheckURLHashTimeout = window.setTimeout(function () {
            TargetNS.CheckURLHash();
        }, 500);

    };

    /**
     * @function
     * @return nothing
     *      This function initializes the special module functions
     */
    TargetNS.Init = function (Options) {
        var ZoomExpand = false,
            URLHash,
            $ArticleElement,
            ResizeTimeoutScroller,
            ResizeTimeoutWindow;

        // Check, if ZoomExpand is active or not
        // Only active on tickets with less than 400 articles (see bug#8424)
        if ($('div.ArticleView a.OneArticle').length) {
            ZoomExpand = !$('div.ArticleView a.OneArticle').hasClass('Active');
        }

        Core.UI.Resizable.Init($('#ArticleTableBody'), Options.ArticleTableHeight, function (Event, UI, Height, Width) {
            // remember new height for next reload
            window.clearTimeout(ResizeTimeoutScroller);
            ResizeTimeoutScroller = window.setTimeout(function () {
                Core.Agent.PreferencesUpdate('UserTicketZoomArticleTableHeight', Height);
            }, 1000);
        });


        $('.TableSmall tbody td a.Attachment').bind('click', function (Event) {
            var Position, HTML, $HTMLObject;
            if ($(this).attr('rel') && $('#' + $(this).attr('rel')).length) {
                Position = $(this).offset();
                Core.UI.Dialog.ShowContentDialog($('#' + $(this).attr('rel'))[0].innerHTML, 'Attachments', Position.top - $(window).scrollTop(), parseInt(Position.left, 10) + 25);
            }
            Event.preventDefault();
            Event.stopPropagation();
            return false;
        });

        // Table sorting
        Core.UI.Table.Sort.Init($('#ArticleTable'), function () {
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

            // if URL hash is empty, set it initially to the active article for working browser history
            if (URLHash === '') {
                InitialArticleID = $('#ArticleTable tr.Active input.ArticleID').val();
                //location.hash = '#' + $('#ArticleTable tr.Active input.ArticleID').val();
            }
            else {
                // if article ID is found in article list (= article id is valid)
                $ArticleElement = $('#ArticleTable').find('input.ArticleID[value=' + URLHash + ']');
                if ($ArticleElement.length) {

                    // Add active state to new row
                    $ArticleElement.closest('table').find('tr').removeClass('Active').end().end().closest('tr').addClass('Active');

                    // Load content of new article
                    LoadArticle($ArticleElement.closest('td').find('input.ArticleInfo').val(), URLHash);
                }
            }
        }

        // loading new articles
        $('#ArticleTable tbody tr').bind('click', function (Event) {
            // Mode: show one article - load new article via ajax
            if (!ZoomExpand) {
                // Add active state to new row
                $(this).closest('table').find('tr').removeClass('Active').end().end().addClass('Active');

                // Mark old row as readed
                $(this).closest('tr').removeClass('UnreadArticles').find('span.UnreadArticles').remove();

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
            TargetNS.CheckURLHash();
        }

        $('a.AsPopup').bind('click', function (Event) {
            var Matches,
                PopupType = 'TicketAction';

            Matches = $(this).attr('class').match(/PopupType_(\w+)/);
            if (Matches) {
                PopupType = Matches[1];
            }

            Core.UI.Popup.OpenPopup($(this).attr('href'), PopupType);
            return false;
        });

        // Scroll to active article
        if ( !ZoomExpand && $('#ArticleTable tbody tr.Active').length ) {
            $('div.Scroller').get(0).scrollTop = parseInt($('#ArticleTable tbody tr.Active').position().top, 10) - 30;
        }
    };

    return TargetNS;
}(Core.Agent.TicketZoom || {}));
