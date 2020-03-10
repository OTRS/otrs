// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
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

        var NewHeight,
            IframeBodyHeight,
            ArticleHeightMax = Core.Config.Get('Ticket::Frontend::HTMLArticleHeightMax');

        if (isJQueryObject($Iframe)) {
            IframeBodyHeight = $Iframe.contents().find('body').height();
            NewHeight = $Iframe.contents().height();
            if (!NewHeight || isNaN(NewHeight)) {
                NewHeight = Core.Config.Get('Ticket::Frontend::HTMLArticleHeightDefault');
            }
            else {
                if (IframeBodyHeight > ArticleHeightMax
                    || NewHeight > ArticleHeightMax) {
                    NewHeight = ArticleHeightMax;
                }
                else if (IframeBodyHeight > NewHeight) {
                    NewHeight = IframeBodyHeight;
                }
            }

            // add delta for scrollbar
            NewHeight = parseInt(NewHeight, 10) + 25;

            // make sure the minimum height is in line with the avatar images
            if (NewHeight < 46) {
                NewHeight = 46;
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
                ScrollerOffset = $('div.Scroller').get(0).scrollTop,
            // article menu
                ArticleIndex, Index, MenuItems = Core.Config.Get('MenuItems') || [];

            $('#ArticleItems a.AsPopup').on('click', function () {
                var Matches,
                    PopupType = 'TicketAction';

                Matches = $(this).attr('class').match(/PopupType_(\w+)/);
                if (Matches) {
                    PopupType = Matches[1];
                }
                Core.UI.Popup.OpenPopup($(this).attr('href'), PopupType);
                return false;
            });

            // Add event bindings to new widget.
            ArticleDetailsEvents();

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

            // create open popup event for dropdown elements
            if (MenuItems.length > 0) {
                for (ArticleIndex in MenuItems) {
                    for (Index in MenuItems[ArticleIndex]) {
                        if (MenuItems[ArticleIndex][Index].ItemType === 'Dropdown' && MenuItems[ArticleIndex][Index].Type === 'OnLoad') {
                            if (MenuItems[ArticleIndex][Index].DropdownType === 'Forward') {
                                Core.Agent.TicketZoom.ArticleActionMenuDropdown(MenuItems[ArticleIndex][Index].FormID, "ForwardTemplateID");
                            }
                            else if (MenuItems[ArticleIndex][Index].DropdownType === 'Reply') {
                                Core.Agent.TicketZoom.ArticleActionMenuDropdown(MenuItems[ArticleIndex][Index].FormID, "ResponseID");
                            }
                        }
                    }
                }
            }

            // Initialize modern input fields in article actions.
            Core.UI.InputFields.Activate($('#ArticleItems'));
        });
    }

    /**
     * @name ArticleActionMenuDropdown
     * @memberof Core.Agent.TicketZoom
     * @function
     * @param {String} FormID - ID of html element for which event is created
     * @param {String} Name - Name of html element for which event is created
     * @description
     *      This function creates onchange open popup event for dropdown html element.
     */
    TargetNS.ArticleActionMenuDropdown = function (FormID, Name) {
        var URL;
        $('#' + FormID + ' select[name=' + Name + ']').on('change', function () {
            if ($(this).val() > 0) {
                URL = Core.Config.Get('Baselink') + $(this).parents().serialize();
                Core.UI.Popup.OpenPopup(URL, 'TicketAction');

                // reset the select box so that it can be used again from the same window
                $(this).val('0');
            }
        });
    };

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
     * @private
     * @name ArticleViewEvents
     * @memberof Core.Agent.TicketZoom
     * @function
     * @description
     *      This function initializes article view settings dialog.
     */
    function ArticleViewEvents() {
        var $ArticleViewSettingsObj = $('#ArticleViewSettings'),
            ArticleViewSettingsDialogHTML;

        if (!$ArticleViewSettingsObj.length) {
            return;
        }

        ArticleViewSettingsDialogHTML = Core.Template.Render('Agent/TicketZoom/ArticleViewSettingsDialog', {
            'ArticleViewStrg': Core.Config.Get('ArticleViewStrg')
        });

        // Calendar settings button
        $ArticleViewSettingsObj.off('click.AgentTicketZoom').on('click.AgentTicketZoom', function (Event) {

            Core.UI.Dialog.ShowContentDialog(ArticleViewSettingsDialogHTML, Core.Language.Translate('Settings'), '10px', 'Center', true,
                [
                    {
                        Label: Core.Language.Translate('Close this dialog'),
                        Type: 'Close'
                    }
                ], true);

            $('#ArticleView').off('change').on('change', function() {

                if (!parseInt(Core.Config.Get('OTRSBusinessIsInstalled'), 10) && ($(this).val() === null || $(this).val() === '')) {
                    Core.UI.Dialog.CloseDialog($('.Dialog:visible'));
                    Core.Agent.ShowOTRSBusinessRequiredDialog();
                    return false;
                }
                else {
                    Core.UI.Dialog.MakeDialogWait();
                    $('#ArticleView').closest('form').submit();
                }
            });

            Event.preventDefault();
            Event.stopPropagation();

            return false;
        });
    }

    /**
     * @private
     * @name ArticleFilterEvents
     * @memberof Core.Agent.TicketZoom
     * @function
     * @param {String} ArticleFilterDialog - parameter which defines what kind of dialog will be created
     * @param {String} TicketID - ID of ticket which is shown
     * @description
     *      This function sets and resets article filter.
     */
    function ArticleFilterEvents(ArticleFilterDialog, TicketID) {

        if (ArticleFilterDialog === 1) {
            $('#SetArticleFilter').on('click', function () {
                Core.UI.Dialog.ShowContentDialog($('#ArticleFilterDialog'), Core.Language.Translate("Article filter"), '20px', 'Center', true, [
                    {
                        Label: Core.Language.Translate("Apply"),
                        Function: function () {
                            var Data = Core.AJAX.SerializeForm($('#ArticleFilterDialogForm'));
                            Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function () {
                                location.reload();
                            }, 'text');
                        }
                    },
                    {
                        Label: Core.Language.Translate("Reset"),
                        Function: function () {
                            $('#CommunicationChannelFilter').val('').trigger('redraw.InputField');
                            $('#ArticleSenderTypeFilter').val('').trigger('redraw.InputField');
                        }
                    }
                ]);
                return false;
            });
            $('#ResetArticleFilter').on('click', function () {
                var Data = {
                    Action:       'AgentTicketZoom',
                    Subaction:    'ArticleFilterSet',
                    TicketID:     TicketID,
                    SaveDefaults: 1
                };
                Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function () {
                    location.reload();
                });
            });
        }
        else {
            $('#SetArticleFilter').on('click', function () {
                $('#EventTypeFilterDialog').find('form').css('width', '500px');
                Core.UI.Dialog.ShowContentDialog($('#EventTypeFilterDialog'), Core.Language.Translate("Event Type Filter"), '20px', 'Center', true, [
                    {
                        Label: Core.Language.Translate("Apply"),
                        Function: function () {
                            var Data = Core.AJAX.SerializeForm($('#EventTypeFilterDialogForm'));
                            Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function () {
                                location.reload();
                            }, 'text');
                        }
                    },
                    {
                        Label: Core.Language.Translate("Reset"),
                        Function: function () {
                            $('#EventTypeFilter').val('').trigger('redraw.InputField');
                        }
                    }
                ]);
                return false;
            });
            $('#ResetArticleFilter').on('click', function () {
                var Data = {
                    Action:       'AgentTicketZoom',
                    Subaction:    'EvenTypeFilterSet',
                    TicketID:     TicketID,
                    SaveDefaults: 1
                };
                Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function () {
                    location.reload();
                });
            });
        }
    }

    /**
     * @private
     * @name InitProcessWidget
     * @memberof Core.Agent.TicketZoom
     * @function
     * @description
     *      This function initializes events for process widget.
     */
     function InitProcessWidget() {
        var WidgetWidth, FieldsPerRow, FieldMargin, FieldWidth;

        if ($('.DynamicFieldAutoResize').length > 0) {
            WidgetWidth  = parseInt($('#DynamicFieldsWidget').innerWidth() - 15, 10);
            FieldMargin  = parseInt($('.DynamicFieldAutoResize').css('margin-right'), 10) + 2;
            FieldsPerRow = 4;

            // define amount of fields per row depending on display resolution
            if (WidgetWidth < 400) {
                FieldsPerRow = 1;
            }
            else if (WidgetWidth < 600) {
                FieldsPerRow = 2;
            }
            else if (WidgetWidth < 1000) {
                FieldsPerRow = 3;
            }

            // determine the needed field width and resize the fields
            if (FieldsPerRow === 1) {
                FieldWidth = '100%';
            }
            else {
                FieldWidth = parseInt(WidgetWidth / FieldsPerRow - FieldMargin - 1, 10) || 0;
            }

            $('.DynamicFieldAutoResize').width(FieldWidth);
        }

        $('.ShowFieldInfoOverlay').on('click', function() {

            var OverlayTitle  = $(this).closest('label').attr('title'),
                OverlayHTML   = $(this).closest('.FieldContainer').find('.Value').html();

            OverlayHTML = '<div class="FieldOverlay">' + OverlayHTML + '</div>';

            Core.UI.Dialog.ShowDialog({
                Modal: true,
                Title: OverlayTitle,
                HTML: OverlayHTML,
                PositionTop: '100px',
                PositionLeft: 'Center',
                CloseOnEscape: true,
                Buttons: [
                    {
                        Type: 'Close',
                        Label: Core.Language.Translate("Close this dialog"),
                        Function: function() {
                            Core.UI.Dialog.CloseDialog($('.Dialog:visible'));
                            Core.Form.EnableForm($('form[name="compose"]'));
                            return false;
                        }
                    }
                ]
            });
        });
    }

    function ArticleDetailsEvents() {

        // Toggle article details.
        $('.WidgetAction.Expand').off('click').on('click', function() {
            var $WidgetObj = $(this).closest('.WidgetSimple'),
                $WidgetMenu = $WidgetObj.find('.WidgetMenu'),
                $WidgetMessage = $WidgetObj.find('.WidgetMessage');

            if ($WidgetObj.hasClass('MenuExpanded')) {
                $WidgetMenu.slideUp('fast');
                $WidgetObj.removeClass('MenuExpanded');

                if ($WidgetMessage.length === 1) {
                    $WidgetMenu.removeClass('SpacingBottom');
                }
            }
            else {
                $WidgetMenu.slideDown('fast');
                $WidgetObj.addClass('MenuExpanded');

                if ($WidgetMessage.length === 1) {
                    $WidgetMenu.addClass('SpacingBottom');
                }
            }
            return false;
        });
    }

    /**
     * @name InitWidgets
     * @memberof Core.Agent.TicketZoom
     * @function
     * @param {Object} AsyncWidgetActions - list of widgets to initialize
     * @description
     *      This function initializes configured asynchronous widgets.
     */
    function InitWidgets(AsyncWidgetActions) {
        $.each(AsyncWidgetActions, function (ElementID, URLPart) {
            Core.AJAX.ContentUpdate($('#' + ElementID), Core.Config.Get('Baselink') + URLPart, function() {

                // wait for content update
                $('#' + ElementID).find("a.AsPopup").on('click', function () {
                    var Matches,
                        PopupType = 'TicketAction';

                    Matches = $(this).attr('class').match(/PopupType_(\w+)/);
                    if (Matches) {
                        PopupType = Matches[1];
                    }

                    Core.UI.Popup.OpenPopup($(this).attr('href'), PopupType);
                    return false;
                });

                $('#' + ElementID).find('.WidgetSimple').hide().fadeIn();
                Core.UI.InitWidgetActionToggle();
            });
        });
    }

    /**
     * @name Init
     * @memberof Core.Agent.TicketZoom
     * @function
     * @description
     *      This function initializes the special module functions.
     */
    TargetNS.Init = function () {
        var ZoomExpand = false,
            URLHash,
            $ArticleElement,
            ResizeTimeoutScroller,
            ArticleIndex, Index, MenuItems = Core.Config.Get('MenuItems') || [],
            ArticleTableHeight = parseInt(Core.Config.Get('ArticleTableHeight'), 10),
            TicketID = Core.Config.Get('TicketID'),
            Count, ArticleIDs = Core.Config.Get('ArticleIDs'),
            ArticleFilterDialog = parseInt(Core.Config.Get('ArticleFilterDialog'), 10),
            AsyncWidgetActions = Core.Config.Get('AsyncWidgetActions') || {},
            TimelineView = Core.Config.Get('TimelineView'),
            ProcessWidget = Core.Config.Get('ProcessWidget');

        // create open popup event for dropdown elements
        if (MenuItems.length > 0) {
            for (ArticleIndex in MenuItems) {
                for (Index in MenuItems[ArticleIndex]) {
                    if (MenuItems[ArticleIndex][Index].ItemType === 'Dropdown' && MenuItems[ArticleIndex][Index].Type !== 'OnLoad') {
                        if (MenuItems[ArticleIndex][Index].DropdownType === 'Forward') {
                            TargetNS.ArticleActionMenuDropdown(MenuItems[ArticleIndex][Index].FormID, "ForwardTemplateID");
                        }
                        else if (MenuItems[ArticleIndex][Index].DropdownType === 'Reply') {
                            TargetNS.ArticleActionMenuDropdown(MenuItems[ArticleIndex][Index].FormID, "ResponseID");
                        }
                    }
                }
            }
        }

        // Check, if ZoomExpand is active or not.
        //   Only active on tickets with less than 400 articles (see bug#8424).
        //   Since passed value is a regular 0/1 string, make sure it's a boolean first. To do this, convert it to
        //   integer by performing addition on it (+) and then use double not (!!) for casting it to boolean.
        //   !! + "1" === false;
        //   !! + "0" === true;
        ZoomExpand = !! + Core.Config.Get('ZoomExpand');

        Core.UI.Resizable.Init($('#ArticleTableBody'), ArticleTableHeight, function (Event, UI, Height) {
            // remember new height for next reload
            window.clearTimeout(ResizeTimeoutScroller);
            ResizeTimeoutScroller = window.setTimeout(function () {
                Core.Agent.PreferencesUpdate('UserTicketZoomArticleTableHeight', Height);
            }, 1000);
        });


        $('.DataTable tbody td a.Attachment').on('click', function (Event) {
            var Position;
            if ($(this).attr('rel') && $('#' + $(this).attr('rel')).length) {
                Position = $(this).offset();
                Core.UI.Dialog.ShowContentDialog($('#' + $(this).attr('rel'))[0].innerHTML, Core.Language.Translate('Attachments'), Position.top - $(window).scrollTop(), parseInt(Position.left, 10) + 25);
            }
            Event.preventDefault();
            Event.stopPropagation();
            return false;
        });

        // Table sorting
        Core.UI.Table.Sort.Init($('#ArticleTable'));

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
        $('a.Timeline').on('click', function() {
            $(this).attr('href', $(this).attr('href') + ';ArticleID=' + URLHash);
        });

        // Start asynchronous loading of widgets
        InitWidgets(AsyncWidgetActions);

        // loading new articles
        $('#ArticleTable tbody tr').on('click', function () {

            Core.App.Publish('Event.Agent.TicketZoom.ArticleClick');

            // Mode: show one article - load new article via ajax
            if (!ZoomExpand) {
                // Add active state to new row
                $(this).closest('table').find('tr').removeClass('Active').end().end().addClass('Active');

                // Mark old row as readed
                $(this).closest('tr').removeClass('UnreadArticles').find('span.UnreadArticles').remove();

                // Load content of new article
                LoadArticle($(this).find('input.ArticleInfo').val(), $(this).find('input.ArticleID').val());

                // mark an article as seen
                TargetNS.MarkAsSeen(TicketID, $(this).find('input.ArticleID').val());
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

        $('a.AsPopup').on('click', function () {
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

        // Mark all articles as seen, in case the expanded zoom mode is active.
        if (parseInt(Core.Config.Get('TicketItemMarkAsSeen'), 10) === 1) {
            TargetNS.MarkTicketAsSeen(TicketID);
        }

        // Otherwise, mark just visible articles as seen.
        //   Do this only in case the expanded zoom mode is inactive, in order to avoid potential race condition with
        //   the previous action. Please see bug#13657 for more information.
        else {
            for (Count in ArticleIDs) {
                TargetNS.MarkAsSeen(TicketID, ArticleIDs[Count]);
            }
        }

        // event on change queue
        $('#DestQueueID').on('change', function () {
            if ($('#DestQueueID option:selected').val()) {
                $(this).closest('form').submit();
            }
        });

        // Add event bindings to all article widgets.
        ArticleDetailsEvents();

        // Initialize article view settings dialog.
        ArticleViewEvents();

        // initialize article filter events
        if (typeof ArticleFilterDialog !== 'undefined') {
            ArticleFilterEvents(ArticleFilterDialog, TicketID);
        }

        // initialize timeline view
        if (typeof TimelineView !== 'undefined' && parseInt(TimelineView.Enabled, 10) === 1) {
            Core.Agent.TicketZoom.TimelineView.InitTimelineView(TimelineView);
        }

        // initialize events for process widget
        if (typeof ProcessWidget !== 'undefined' && parseInt(ProcessWidget, 10) === 1) {
            InitProcessWidget();
        }

        Core.App.Subscribe('Event.AJAX.ContentUpdate.Callback', function() {
            $('a.SplitSelection').unbind('click.SplitSelection').bind('click.SplitSelection', function() {
                Core.Agent.TicketSplit.OpenSplitSelection($(this).attr('href'));
                return false;
            });
        });

        $('a.SplitSelection').unbind('click.SplitSelection').bind('click.SplitSelection', function() {
            Core.Agent.TicketSplit.OpenSplitSelection($(this).attr('href'));
            return false;
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.TicketZoom || {}));
