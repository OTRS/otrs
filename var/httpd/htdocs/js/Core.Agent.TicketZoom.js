// --
// Core.Agent.TicketZoom.js - provides the special module functions for TicketZoom
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.Agent.TicketZoom.js,v 1.8 2010-07-21 13:35:04 mn Exp $
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
     * @return nothing
     *      This function initializes the special module functions
     */
    TargetNS.Init = function () {
        var $THead = $('#FixedTable thead'),
            $TBody = $('#FixedTable tbody');

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

        // loading new articles
        $('#FixedTable tr').bind('click', function (Event) {
            // Mode: show one article - load new article vai ajax
            if ($('ul.ArticleView li.OneArticle').hasClass('Active')) {
                // Add active state to new row
                $(this).closest('table').find('tr').removeClass('Active').end().end().addClass('Active');
                // Load content of new article
                Core.AJAX.ContentUpdate($('#ArticleItems'), $(this).find('input.ArticleInfo').val(), function () {
                    $('#ArticleItems a.AsPopup').bind('click', function (Event) {
                        Core.UI.Popup.OpenPopup($(this).attr('href'), 'Action');
                        return false;
                    });
                    // Add event bindings to new widget
                    Core.UI.InitWidgetActionToggle();
                });
            }
            // Mode: show all articles - jump to the selected article
            else {
                location.href = '#' + $(this).find('input.ArticleID').val();
            }

            return false;
        });
    };

    return TargetNS;
}(Core.Agent.TicketZoom || {}));