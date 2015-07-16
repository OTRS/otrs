// --
// Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.Form = Core.Form || {};

/**
 * @namespace Core.Form.ErrorTooltips
 * @memberof Core.Form
 * @author OTRS AG
 * @description
 *      This namespace contains the Tooltip initialization functions.
 */
Core.Form.ErrorTooltips = (function (TargetNS) {

    /**
     * @private
     * @name TooltipContainerID
     * @memberof Core.Form.ErrorTooltips
     * @member {String}
     * @description
     *      ID of the container DOM element.
     */
    var TooltipContainerID = 'OTRS_UI_Tooltips_ErrorTooltip',
    /**
     * @private
     * @name TooltipOffsetTop
     * @memberof Core.Form.ErrorTooltips
     * @member {Number}
     * @description
     *      Top offset in pixel of the tooltip from the DOM element.
     */
        TooltipOffsetTop = 20,
    /**
     * @private
     * @name TooltipOffsetLeft
     * @memberof Core.Form.ErrorTooltips
     * @member {Number}
     * @description
     *      Left offset in pixel of the tooltip from the DOM element.
     */
        TooltipOffsetLeft = 20,
    /**
     * @private
     * @name TongueClass
     * @memberof Core.Form.ErrorTooltips
     * @member {String}
     * @description
     *      Class name of the tooltip for the tongue. Defines if the tongue is left or right.
     */
        TongueClass = 'TongueLeft',
    /**
     * @private
     * @name TonguePosition
     * @memberof Core.Form.ErrorTooltips
     * @member {String}
     * @description
     *      Class name of the tooltip for the tongue position. Defines if the tongue is top or bottom.
     */
        TonguePosition = 'TongueBottom',
    /**
     * @private
     * @name $TooltipContent
     * @memberof Core.Form.ErrorTooltips
     * @member {jQueryObject}
     * @description
     *      The tooltip base HTML.
     */
        $TooltipContent = $('<div class="Content" role="tooltip"></div>'),
    /**
     * @private
     * @name $Tooltip
     * @memberof Core.Form.ErrorTooltips
     * @member {jQueryObject}
     * @description
     *      The HTMl of the complete Tooltip.
     */
        $Tooltip,
    /**
     * @private
     * @name Offset
     * @memberof Core.Form.ErrorTooltips
     * @member {Object}
     * @description
     *      The offset of the element for which a tooltip is shown.
     */
        Offset;

    /**
     * @name ShowTooltip
     * @memberof Core.Form.ErrorTooltips
     * @function
     * @param {jQueryObject} $Element - jquery object.
     * @param {String} TooltipContent - The string content that will be show in tooltip.
     * @param {String} TooltipPosition - Vertical position of the tooltip: 'TongueTop' or 'TongueBottom'.
     * @description
     *      This function shows the tooltip for an element with a certain content.
     */
    TargetNS.ShowTooltip = function($Element, TooltipContent, TooltipPosition) {
        var $TooltipContainer = $('#' + TooltipContainerID),
            TopOffset;

        if (TooltipPosition == null) {
            TooltipPosition = TonguePosition;
        }

        if (!$TooltipContainer.length) {
            $('body').append('<div id="' + TooltipContainerID + '" class="TooltipContainer"></div>');
            $TooltipContainer = $('#' + TooltipContainerID);
        }

        /*
         * Now determine if the tongue needs to be right or left, depending on the
         * position of the target element on the screen.
         */
        if (($(document).width() - $Element.offset().left) < 250) {
            TongueClass = 'TongueRight';
        }

        /*
         * Now create and fill the tooltip with the error message.
         */
        $Tooltip = $('<div class="Tooltip ' + TongueClass + ' ' + TooltipPosition + '"></div>');
        $TooltipContent.html(TooltipContent);
        $Tooltip.append($TooltipContent);

        Offset = $Element.offset();

        if (TooltipPosition === 'TongueBottom') {
            TopOffset = Offset.top + TooltipOffsetTop;
        }
        else if (TooltipPosition === 'TongueTop') {
            TopOffset = Offset.top - $Element.height() - TooltipOffsetTop;
        }

        $TooltipContainer
            .empty()
            .append($Tooltip)
            .css('left', Offset.left + TooltipOffsetLeft)
            .css('top', TopOffset)
            .show();
    };

    /**
     * @name HideTooltip
     * @memberof Core.Form.ErrorTooltips
     * @function
     * @description
     *      This function hides the tooltip for an element.
     */
    TargetNS.HideTooltip = function() {
        $('#' + TooltipContainerID).hide().empty();
    };

    /**
     * @name InitTooltip
     * @memberof Core.Form.ErrorTooltips
     * @function
     * @param {jQueryObject} $Element - The elements (within a jQuery object) for whom the tooltips are initialized.
     * @param {String} TooltipContent - Content of the tooltip, may contain HTML.
     * @description
     *      This function initializes the tooltips on an input field.
     */
    TargetNS.InitTooltip = function ($Element, TooltipContent) {
        $Element.unbind('focus.Tooltip');
        $Element.bind('focus.Tooltip', function () {
            TargetNS.ShowTooltip($Element, TooltipContent);
        });

        $Element.unbind('blur.Tooltip');
        $Element.bind('blur.Tooltip', TargetNS.HideTooltip);
    };

    /**
     * @name RemoveTooltip
     * @memberof Core.Form.ErrorTooltips
     * @function
     * @param {jQueryObject} $Element - The elements (within a jQuery object) for whom the tooltips are removed.
     * @description
     *      This function removes the tooltip from an input field.
     */
    TargetNS.RemoveTooltip = function ($Element) {
        TargetNS.HideTooltip();
        $Element.unbind('focus.Tooltip');
        $Element.unbind('blur.Tooltip');
    };

    /**
     * @private
     * @name ShowRTETooltip
     * @memberof Core.Form.ErrorTooltips
     * @function
     * @param {Object} Event - The event object.
     * @description
     *      This function shows the tooltip for a rich text editor.
     */
    function ShowRTETooltip(Event) {
        TargetNS.ShowTooltip($('#cke_' + Event.listenerData.ElementID + ' .cke_contents'), Event.listenerData.Message);
    }

    /**
     * @private
     * @name RemoveRTETooltip
     * @memberof Core.Form.ErrorTooltips
     * @function
     * @description
     *      This function remove the tooltip from a rich text editor.
     */
    function RemoveRTETooltip() {
        TargetNS.HideTooltip();
    }

    /**
     * @name InitRTETooltip
     * @memberof Core.Form.ErrorTooltips
     * @function
     * @param {jQueryObject} $Element - The RTE element for whom the tooltips are initialized.
     * @param {String} Message - The string content that will be show in tooltip.
     * @description
     *      This function initializes the necessary stuff for a tooltip in a rich text editor.
     */
    TargetNS.InitRTETooltip = function ($Element, Message) {
        var ElementID = $Element.attr('id');
        CKEDITOR.instances[ElementID].on('focus', ShowRTETooltip, null, {ElementID: ElementID, Message: Message});
        CKEDITOR.instances[ElementID].on('blur', RemoveRTETooltip, null, ElementID);
    };

    /**
     * @name RemoveRTETooltip
     * @memberof Core.Form.ErrorTooltips
     * @function
     * @param {jQueryObject} $Element - The RTE element for whom the tooltips are removed.
     * @description
     *      This function removes the tooltip in a rich text editor.
     */
    TargetNS.RemoveRTETooltip = function ($Element) {
        var ElementID = $Element.attr('id');
        CKEDITOR.instances[ElementID].removeListener('focus', ShowRTETooltip);
        CKEDITOR.instances[ElementID].removeListener('blur', RemoveRTETooltip);
        TargetNS.HideTooltip();
    };

    return TargetNS;
}(Core.Form.ErrorTooltips || {}));
