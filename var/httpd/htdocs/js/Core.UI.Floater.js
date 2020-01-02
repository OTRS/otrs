// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var Core = Core || {};
Core.UI = Core.UI || {};

/**
 * @namespace Core.UI.Floater
 * @memberof Core.UI
 * @author OTRS AG
 * @description
 *      This namespace contains the Floater code.
 */
Core.UI.Floater = (function (TargetNS) {

    /**
     * @private
     * @name InitFloaters
     * @memberof Core.UI
     * @function
     * @description
     *      This function initializes iframe floaters on links with certain trigger attributes. To provide
     *      a floater on a link (<a>) element, just add data-trigger="floater" to any <a> which has
     *      a non-empty href attribute. Its also possible to add the data attribute on runtime.
     */
    TargetNS.Init = function() {

        var FloaterHoverTimer = {},
            FloaterTriggerHoverTimer = {};

        /**
         * @private
         * @name CreateFloaterOpenTimeout
         * @memberof Core.UI.Floater.Init
         * @function
         * @param {jQueryObject} $Element
         * @param {Function} TimeoutFunction
         * @description
         *      This function sets the Timeout for closing a floater.
         */
        function CreateFloaterOpenTimeout($Element, TimeoutFunction) {
            FloaterTriggerHoverTimer[$Element] = setTimeout(TimeoutFunction, 500);
        }

        /**
         * @private
         * @name ClearFloaterOpenTimeout
         * @memberof Core.UI.Floater.Init
         * @function
         * @param {jQueryObject} $Element
         * @description
         *      This function clears the Timeout for a floater.
         */
        function ClearFloaterOpenTimeout($Element) {
            if (typeof FloaterTriggerHoverTimer[$Element] !== 'undefined') {
                clearTimeout(FloaterTriggerHoverTimer[$Element]);
            }
        }

        /**
         * @private
         * @name CreateFloaterOpenTimeout
         * @memberof Core.UI.Floater.Init
         * @function
         * @param {jQueryObject} $Element
         * @param {Function} TimeoutFunction
         * @description
         *      This function sets the Timeout for closing a floater.
         */
        function CreateFloaterCloseTimeout($Element, TimeoutFunction) {
            FloaterHoverTimer[$Element] = setTimeout(TimeoutFunction, 500);
        }

        /**
         * @private
         * @name ClearFloaterCloseTimeout
         * @memberof Core.UI.Floater.Init
         * @function
         * @param {jQueryObject} $Element
         * @description
         *      This function clears the Timeout for a floater.
         */
        function ClearFloaterCloseTimeout($Element) {
            if (typeof FloaterHoverTimer[$Element] !== 'undefined') {
                clearTimeout(FloaterHoverTimer[$Element]);
            }
        }

        /**
         * @private
         * @name RemoveActiveFloater
         * @memberof Core.UI.Floater.Init
         * @function
         * @param {jQueryObject} $FloaterObj
         * @description
         *      This function clears the Timeout for a floater.
         */
        function RemoveActiveFloater($FloaterObj) {

            if (!$FloaterObj) {
                $FloaterObj = $('div.MetaFloater:visible');
            }

            $('[data-trigger="floater"]').removeClass('FloaterOpen');
            $FloaterObj.fadeOut('fast', function() {
                $(this).remove();
                ClearFloaterCloseTimeout($(this));
            });
        }

        // init floaters
        $('body').off('click.FloaterClose').on('click.FloaterClose', '.MetaFloater > a.Close', function() {
            RemoveActiveFloater($(this).closest('.MetaFloater'));
            return false;
        });

        $('body').off('click.FloaterScale').on('click.FloaterScale', '.MetaFloater > a.Scale', function() {

            var $IconObj = $(this).find('i'),
                $IframeObj = $(this).closest('.MetaFloater').find('iframe');

            if ($IconObj.hasClass('fa-search-plus')) {
                $IconObj.removeClass('fa-search-plus').addClass('fa-search-minus');
                $IframeObj.addClass('NoScale');
            }
            else {
                $IconObj.removeClass('fa-search-minus').addClass('fa-search-plus');
                $IframeObj.removeClass('NoScale');
            }

            return false;
        });

        $('body').off('mouseenter.Floater').on('mouseenter.Floater', 'div.MetaFloater', function() {
            ClearFloaterCloseTimeout($(this));
        });

        $('body').off('mouseleave.Floater').on('mouseleave.Floater', 'div.MetaFloater', function() {
            CreateFloaterCloseTimeout($(this), function () {
                RemoveActiveFloater();
            });
        });

        $('body').off('mouseleave.FloaterTrigger').on('mouseleave.FloaterTrigger', '[data-trigger="floater"]', function(Event) {
            ClearFloaterOpenTimeout($(Event.target));
            CreateFloaterCloseTimeout($(this), function () {
                RemoveActiveFloater();
            });
        });

        $('body').off('mouseenter.FloaterTrigger').on('mouseenter.FloaterTrigger', '[data-trigger="floater"]', function(Event) {

            ClearFloaterCloseTimeout($(this));

            // Set Timeout for opening floater
            CreateFloaterOpenTimeout($(Event.target), function () {

                var $TriggerObj    = $(Event.target),
                    TriggerOffset  = $TriggerObj.offset(),
                    ViewportWidth  = parseInt($(window).width(), 10),
                    AvailableHeightBottom,
                    AvailableHeightTop,
                    FloaterWidth,
                    $FloaterObj,
                    Margin = 25,
                    iFrameURL = $TriggerObj.data('floater-url'),
                    FloaterTemplate = Core.Template.Render('MetaFloater');

                if (!iFrameURL) {
                    return false;
                }

                // don't open the floater again if there is one already
                if ($TriggerObj.hasClass('FloaterOpen')) {
                    return false;
                }

                $('[data-trigger="floater"]').removeClass('FloaterOpen');
                $TriggerObj.addClass('FloaterOpen');

                $FloaterObj = $(FloaterTemplate);

                // only one floater at the same time, so close other ones
                $('body > div.MetaFloater:visible').remove();

                // show floater to be able to calculate its width
                $FloaterObj.appendTo('body').css('display', 'none');

                // calculate floater dimensions
                FloaterWidth = parseInt($FloaterObj.outerWidth(), 10);

                // set left position
                if (TriggerOffset.left - ViewportWidth / 50 < FloaterWidth / 2) {

                    // case 1: trigger element on far left side without enough space to show the floater
                    $FloaterObj.addClass('Left').css({
                        right: 'auto',
                        left: TriggerOffset.left
                    });
                }
                else if (ViewportWidth - TriggerOffset.left + ($TriggerObj.outerWidth() / 2) - ViewportWidth / 50 < FloaterWidth / 2) {

                    // case 2: trigger element on far right side
                    $FloaterObj.addClass('Right').css({
                        right: 'auto',
                        left: TriggerOffset.left - FloaterWidth + $TriggerObj.outerWidth()
                    });
                }
                else {

                    // Default position: Centered relative to the trigger element
                    $FloaterObj.addClass('Center').css({
                        right: 'auto',
                        left: parseInt(TriggerOffset.left + ($TriggerObj.outerWidth() / 2) - FloaterWidth / 2, 10)
                    });
                }

                // calculate available height to bottom of page
                AvailableHeightBottom = parseInt($(window).scrollTop() + $(window).height() - (TriggerOffset.top + $TriggerObj.outerHeight()), 10);

                // calculate available height to top of page
                AvailableHeightTop = parseInt(TriggerOffset.top - $(window).scrollTop(), 10);

                // decide whether list should be positioned on top or at the bottom of the input field
                if (AvailableHeightTop > AvailableHeightBottom) {
                    $FloaterObj.addClass('Bottom').css({
                        top: 'auto',
                        bottom: parseInt($('body').height() - TriggerOffset.top, 10) + Margin
                    });
                }
                else {
                    $FloaterObj.addClass('Top').css({
                        top: parseInt(TriggerOffset.top + $TriggerObj.outerHeight(), 10) + Margin,
                        bottom: 'auto'
                    });
                }

                $FloaterObj.find('iframe').attr('src', iFrameURL);
                $FloaterObj.find('a.Open').attr('href', $TriggerObj.attr('href'));
                $FloaterObj.fadeIn();

                $('div.MetaFloater:visible iframe').off('load.MetaFloater').on('load.MetaFloater', function() {
                    $(this).closest('.Content').fadeIn('fast', function() {
                        var $ActiveFloaterObj = $('div.MetaFloater:visible');
                        $ActiveFloaterObj
                            .children('div.NoPreview, a.Scale, a.Open').fadeIn()
                            .parent()
                            .children('i').remove();
                    });
                });
            });
        });
    }

    Core.Init.RegisterNamespace(TargetNS, 'APP_GLOBAL');

    return TargetNS;
}(Core.UI.Floater || {}));
