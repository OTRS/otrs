// --
// OTRS.UI.Tooltips.js - provides provides Tooltip functions
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: OTRS.Forms.ErrorTooltips.js,v 1.2 2010-03-29 09:58:14 mn Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var OTRS = OTRS || {};
OTRS.Forms = OTRS.Forms || {};

/**
 * @namespace
 * @description
 *      This namespace contains the Tooltip initialization functions
 */
OTRS.Forms.ErrorTooltips = (function (Namespace) {

    var TooltipContainerID = 'OTRS_UI_Tooltips_ErrorTooltip';
    var TooltipOffsetTop = 20;
    var TooltipOffsetLeft = 0;

    function ShowTooltip( $Element, TooltipContent ) {

        var $TooltipContainer = $('#' + TooltipContainerID);
        if (!$TooltipContainer.length) {
            $('body').append('<div id="' + TooltipContainerID + '" class="TooltipContainer"></div>');
            $TooltipContainer = $('#' + TooltipContainerID);
        }

        /*
         * Now determine if the tongue needs to be right or left, depending on the
         * position of the target element on the screen.
         */
        var TongueClass = 'TongueLeft';
        if (($(document).width() - $Element.offset().left) < 250) {
            TongueClass = 'TongueRight';
        }

        /*
         * Now create and fill the tooltip with the error message.
         */
        var $TooltipContent = $('<div class="Content" role="tooltip"></div>');
        $TooltipContent.html(TooltipContent);

        var $Tooltip = $('<div class="Tooltip ' + TongueClass + '"><div class="Tongue"></div></div>');
        $Tooltip.append($TooltipContent);

        var Offset = $Element.offset();

        $TooltipContainer
            .empty()
            .append($Tooltip)
            .css('left', Offset.left + TooltipOffsetLeft)
            .css('top', Offset.top + TooltipOffsetTop)
            .show();
    }

    function HideTooltip() {
        $('#' + TooltipContainerID).hide().empty();
    }

    /**
     * @function
     * @description
     *      This function initializes the tooltips on an input field
     * @param {jQueryObject} $Elements
     *      The elements (within a jQuery object) for whom the tooltips are initialized.
     * @param {String} TooltipContent
     *      Content of the tooltip, may contain HTML.
     * @return nothing
     */
    Namespace.InitTooltip = function($Element, TooltipContent){
        $Element.unbind('focus.Tooltip');
        $Element.bind(  'focus.Tooltip', function(){
            ShowTooltip($Element, TooltipContent);
        });

        $Element.unbind('blur.Tooltip');
        $Element.bind(  'blur.Tooltip', HideTooltip);
    };

    /**
     * @function
     * @description
     *      This function removes the tooltip from an input field
     * @param {jQueryObject} $Element
     *      The elements (within a jQuery object) for whom the tooltips are removed.
     * @return nothing
     */
    Namespace.RemoveTooltip = function($Element){
        HideTooltip();
        $Element.unbind('focus.Tooltip');
        $Element.unbind('blur.Tooltip');
    }

    return Namespace;
}(OTRS.Forms.ErrorTooltips || {}));