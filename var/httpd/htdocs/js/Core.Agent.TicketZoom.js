// --
// Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};

/**
 * @namespace Core.Agent.TicketZoom
 * @memberof Core.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for TicketZoom.
 */
Core.Agent.TicketZoom = (function (TargetNS) {
    /**
     * @private
     * @name CheckURLHashTimeout
     * @memberof Core.Agent.TicketZoom
     * @member {Object}
     * @description
     *      CheckURLHashTimeout
     */
    var CheckURLHashTimeout,
    /**
     * @private
     * @name InitialArticleID
     * @memberof Core.Agent.TicketZoom
     * @member {String}
     * @description
     *      InitialArticleID
     */
        InitialArticleID;

    /**
     * @name MarkTicketAsSeen
     * @memberof Core.Agent.TicketZoom
     * @function
     * @param {String} TicketID - TicketID of ticket which gets shown
     * @description
     *      Mark all articles as seen in frontend and backend.
     *      Article Filters will not be considered
     */
    TargetNS.MarkTicketAsSeen = function (TicketID) {
        TargetNS.TicketMarkAsSeenTimeout = window.setTimeout(function () {
            var Data = {
                Action: 'AgentTicketZoom',
                Subaction: 'TicketMarkAsSeen',
                TicketID: TicketID
            };

            // Mark old row as read
            $('#ArticleTable .ArticleID').closest('tr').removeClass('UnreadArticles').find('span.UnreadArticles').remove();

            // Mark article as seen in backend
            Core.AJAX.FunctionCall(
                Core.Config.Get('CGIHandle'),
                Data,
                function () {}
            );
        }, 3000);
    };

    /**
     * @name MarkAsSeen
     * @memberof Core.Agent.TicketZoom
     * @function
     * @param {String} TicketID - TicketID of ticket which get's shown.
     * @param {String} ArticleID - ArticleID of article which get's shown.
     * @param {String} [Timeout=3000] - Timeout in milliseconds
     * @description
     *      Mark an article as seen in frontend and backend.
     */
    TargetNS.MarkAsSeen = function (TicketID, ArticleID, Timeout) {

        // assign default timeout
        if (typeof Timeout === 'undefined') {
            Timeout = 3000;
        }

        TargetNS.MarkAsSeenTimeout = window.setTimeout(function () {
            var Data = {
                Action: 'AgentTicketZoom',
                Subaction: 'MarkAsSeen',
                TicketID: TicketID,
                ArticleID: ArticleID
            };

            // Mark old row as readed
            $('#ArticleTable .ArticleID[value=' + ArticleID + ']').closest('tr').removeClass('UnreadArticles').find('span.UnreadArticles').remove();
            $('.TimelineView li#ArticleID_' + ArticleID).find('.UnreadArticles').fadeOut(function() {
                $(this).closest('li').addClass('Seen');
            });

            // Mark article as seen in backend
            Core.AJAX.FunctionCall(
                Core.Config.Get('CGIHandle'),
                Data,
                function () {}
            );
        }, parseInt(Timeout, 10));
    };

    /**
     * @name IframeAutoHeight
     * @memberof Core.Agent.TicketZoom
     * @function
     * @param {jQueryObject} $Iframe - The iframe which should be auto-heighted
     * @description
     *      Set iframe height automatically based on real content height and default config setting.
     */
    TargetNS.IframeAutoHeight = function ($Iframe) {
        var NewHeight;

        if (isJQueryObject($Iframe)) {
            NewHeight = $Iframe.contents().height();
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
     * @private
     * @name LoadArticle
     * @memberof Core.Agent.TicketZoom
     * @function
     * @param {String} ArticleURL - The URL which should be loaded via AJAX
     * @param {String} ArticleID - The article number of the loaded article
     * @description
     *      This function loads the given article via ajax.
     */
    function LoadArticle(ArticleURL, ArticleID) {
        // Clear timeout for URL hash check, because hash is now changed manually
        window.clearTimeout(CheckURLHashTimeout);

        // Add loader to the widget
        $('#ArticleItems .WidgetBox').addClass('Loading');
        Core.AJAX.ContentUpdate($('#ArticleItems'), ArticleURL, function () {
            // Top position of Scroller element (surrounds article table)
            var ScrollerY = parseInt($('div.Scroller').offset().top, 10),
            // Height of scroller element
                ScrollerHeight = parseInt($('div.Scroller').height(), 10),
            // Top position of active article (offset based on screen position)
                ActiveArticlePosY = parseInt($('#ArticleTable tbody tr.Active').offset().top, 10),
            // Height of active article
                ActiveArticleHeight = parseInt($('#ArticleTable tbody tr.Active').height(), 10),
            // Bottom position of active article
                ActiveArticleBottomY = ActiveArticlePosY + ActiveArticleHeight,
            // Bottom position of scroller element
                ScrollerBottomY = ScrollerY + ScrollerHeight,
            // Offset of scroller element (relative)
                ScrollerOffset = $('div.Scroller').get(0).scrollTop;

            $('#ArticleItems a.AsPopup').bind('click', function () {
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

            // add switchable toggle for new article
            $('label.Switchable').off('click.Switch').on('click.Switch', function() {
                $(this).next('p.Value').find('.Switch').toggleClass('Hidden');
            });

            //Remove Loading class
            $('#ArticleItems .WidgetBox').removeClass('Loading');

            // Scroll to new active article
            // if article is not visible and is above the visible area, move the visible area
            // add 5px of delta for better usability (top border is definetly visible)
            if (ActiveArticlePosY < ScrollerY) {
                $('div.Scroller').get(0).scrollTop = ScrollerOffset + (ActiveArticlePosY - ScrollerY) - 5;
            }
            // if article is not visible and is below the visible area, move the visible area
            // add 5px of delta for better usability (bottom border is definetly visible)
            else if (ScrollerBottomY < ActiveArticleBottomY) {
                $('div.Scroller').get(0).scrollTop = ScrollerOffset + (ActiveArticleBottomY - ScrollerBottomY) + 5;
            }


            // Initiate URL hash check again
            TargetNS.CheckURLHash();

            // If session is over and login screen
            // is showed in article area
            Core.Agent.CheckSessionExpiredAndReload();

        });
    }

    /**
     * @name LoadArticleFromExternal
     * @memberof Core.Agent.TicketZoom
     * @function
     * @param {String} ArticleID - The article number of the loaded article
     * @param {Object} WindowObject
     * @description
     *      Used in OTRS Business Solution (TM). Loads an article in the Zoom from another window context (e.g. popup).
     */
    TargetNS.LoadArticleFromExternal = function (ArticleID, WindowObject) {
        var $Element = $('#ArticleTable td.No input.ArticleID[value=' + ArticleID + ']'),
            ArticleURL;

        // Check if we are in timeline view
        // in this case we can jump directly to the article
        if ($('.ArticleView .Timeline').hasClass('Active')) {
            window.location.hash = '#ArticleID_' + ArticleID;
        }
        else {
            if (!$Element.length) {
                if (typeof WindowObject === 'undefined') {
                    WindowObject = window;
                }
                WindowObject.alert(Core.Config.Get('Language.AttachmentViewMessage'));

                return;
            }

            ArticleURL = $Element.siblings('.ArticleInfo').val();
            LoadArticle(ArticleURL, ArticleID);
        }
    };

    /**
     * @name CheckURLHash
     * @memberof Core.Agent.TicketZoom
     * @function
     * @description
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
     * @name Init
     * @memberof Core.Agent.TicketZoom
     * @function
     * @param {Object} Options - The options, mostly defined in SysConfig and passed through.
     * @param {Number} Options.ArticleTableHeight - The height of the article table. Value is stored in the user preferences.
     * @description
     *      This function initializes the special module functions.
     */
    TargetNS.Init = function (Options) {
        var ZoomExpand = false,
            URLHash,
            $ArticleElement,
            ResizeTimeoutScroller;

        // Check, if ZoomExpand is active or not
        // Only active on tickets with less than 400 articles (see bug#8424)
        if ($('div.ArticleView a.OneArticle').length) {
            ZoomExpand = !$('div.ArticleView a.OneArticle').hasClass('Active');
        }

        Core.UI.Resizable.Init($('#ArticleTableBody'), Options.ArticleTableHeight, function (Event, UI, Height) {
            // remember new height for next reload
            window.clearTimeout(ResizeTimeoutScroller);
            ResizeTimeoutScroller = window.setTimeout(function () {
                Core.Agent.PreferencesUpdate('UserTicketZoomArticleTableHeight', Height);
            }, 1000);
        });


        $('.DataTable tbody td a.Attachment').bind('click', function (Event) {
            var Position;
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
        $('a.Timeline').bind('click', function() {
            $(this).attr('href', $(this).attr('href') + ';ArticleID=' + URLHash);
        });

        // loading new articles
        $('#ArticleTable tbody tr').bind('click', function () {
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

        $('a.AsPopup').bind('click', function () {
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
        if (!ZoomExpand && $('#ArticleTable tbody tr.Active').length) {
            $('div.Scroller').get(0).scrollTop = parseInt($('#ArticleTable tbody tr.Active').position().top, 10) - 30;
        }

        // init browser link message close button
        if ($('.MessageBrowser').length) {
            $('.MessageBrowser a.Close').on('click', function () {
                $('.MessageBrowser').fadeOut("slow");
                Core.Agent.PreferencesUpdate('UserAgentDoNotShowBrowserLinkMessage', 1);
                return false;
            });
        }

        // add switchable toggle
        $('label.Switchable').off('click.Switch').on('click.Switch', function() {
            $(this).next('p.Value').find('.Switch').toggleClass('Hidden');
        });
    };

    return TargetNS;
}(Core.Agent.TicketZoom || {}));
