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
 * @namespace Core.Agent.Overview
 * @memberof Core.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains the View functions.
 */
Core.Agent.Overview = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Overview
     * @function
     * @description
     *      This function initializes the functionality for the Overview screen.
     */
    TargetNS.Init = function () {
        var Profile = Core.Config.Get('Profile'),
            View = Core.Config.Get('View'),
            TicketID, ActionRowTickets = Core.Config.Get('ActionRowTickets') || {};

        // Disable any event handlers on the "label" elements.
        $('ul.Actions form > label').off("click").on("click", function() {
            return false;
        });

        // create open popup event for dropdown actions
        $('ul.Actions form > select').off("change").on("change", function() {
            var URL;
            if ($(this).val() !== '0') {
                if (Core.Config.Get('Action') === 'AgentTicketQueue' ||
                    Core.Config.Get('Action') === 'AgentTicketService' ||
                    Core.Config.Get('Action') === 'AgentTicketStatusView' ||
                    Core.Config.Get('Action') === 'AgentTicketEscalationView'
                ) {
                    $(this).closest('form').submit();
                }
                else {
                    URL = Core.Config.Get('Baselink') + $(this).parents().serialize();
                    Core.UI.Popup.OpenPopup(URL, 'TicketAction');

                    // reset the select box so that it can be used again from the same window
                    $(this).val('0');
                }
            }
        });

        // open ticket search modal dialog
        $('#TicketSearch').on('click', function () {
            Core.Agent.Search.OpenSearchDialog('AgentTicketSearch', Profile);
            return false;
        });

        // open settings modal dialog
        $('#ShowContextSettingsDialog').on('click', function (Event) {
            Core.UI.Dialog.ShowContentDialog($('#ContextSettingsDialogContainer'), Core.Language.Translate("Settings"), '15%', 'Center', true,
                [
                    {
                        Label: Core.Language.Translate("Save"),
                        Type: 'Submit',
                        Class: 'Primary',
                        Function: function () {
                            var $ListContainer = $('.AllocationListContainer').find('.AssignedFields'),
                                FieldID;
                            if (isJQueryObject($ListContainer) && $ListContainer.length) {
                                $.each($ListContainer.find('li'), function() {
                                    FieldID = 'UserFilterColumnsEnabled-' + $(this).attr('data-fieldname');

                                    // only add this field if its not already there. This could happen
                                    // if e.g. the save button is clicked multiple times
                                    if (!$('#' + Core.App.EscapeSelector(FieldID)).length) {
                                        $('<input name="UserFilterColumnsEnabled" type="hidden" />').attr('id', FieldID).val($(this).attr('data-fieldname')).appendTo($ListContainer.closest('div'));
                                    }
                                });
                            }
                            return true;
                        }
                    }
                ], true);
            Event.preventDefault();
            Event.stopPropagation();
            Core.Agent.TableFilters.SetAllocationList();
            return false;
        });

        // change queue for selected ticket
        $('.InlineActions, .OverviewActions').on('change', 'select[name=DestQueueID]', function () {
            $(this).closest('form').submit();
        });

        // add actions for selected (or hovered) ticket
        for (TicketID in ActionRowTickets) {
            Core.UI.ActionRow.AddActions($('#TicketID_' + TicketID), ActionRowTickets[TicketID]);
        }

        // call functions in regard to a view
        if (View === 'Small') {
            TargetNS.InitViewSmall();
        }
        else if (View === 'Medium') {
            TargetNS.InitViewMedium();
        }
        else if (View === 'Preview') {
            TargetNS.InitViewPreview();
        }

        $('a.SplitSelection').off('click').on('click', function() {
            Core.Agent.TicketSplit.OpenSplitSelection($(this).attr('href'));
            return false;
        });
    };

    /**
     * @name InitViewSmall
     * @memberof Core.Agent.Overview
     * @function
     * @description
     *      This function initializes JS functionality for view Small.
     */
    TargetNS.InitViewSmall = function () {

        var URL, ColumnFilter, NewColumnFilterStrg, MyRegEx, SessionInformation,
            $MasterActionLink;

        // initializes a click event for table with checkboxes
        Core.UI.InitCheckboxSelection($('table td.Checkbox'));

        // initializes autocompletion for customer user
        Core.Agent.TableFilters.InitCustomerUserAutocomplete($(".CustomerUserAutoComplete"));

        // initializes autocompletion for customer ID
        Core.Agent.TableFilters.InitCustomerIDAutocomplete($(".CustomerIDAutoComplete"));

        // initializes autocompletion for user
        Core.Agent.TableFilters.InitUserAutocomplete($(".UserAutoComplete"));

        // click event for opening popup
        $('a.AsPopup').on('click', function () {
            Core.UI.Popup.OpenPopup($(this).attr('href'), 'Action');
            return false;
        });

        // change event for column filter
        $('.ColumnFilter').on('change', function () {

            // define variables
            URL = Core.Config.Get("Baselink") + 'Action=' + Core.Config.Get("Action") + ';' + Core.Config.Get('LinkPage');
            SessionInformation = Core.App.GetSessionInformation();
            $.each(SessionInformation, function (Key, Value) {
                URL += encodeURIComponent(Key) + '=' + encodeURIComponent(Value) + ';';
            });
            ColumnFilter = $(this)[0].name;
            NewColumnFilterStrg = $(this)[0].name + '=' + encodeURIComponent($(this).val()) + ';';

            MyRegEx = new  RegExp(ColumnFilter+"=[^;]*;");

            // check for already set parameter and replace
            if (URL.match(MyRegEx)) {
                URL = URL.replace(MyRegEx, NewColumnFilterStrg);
            }

            // otherwise add the new column filter
            else {
                URL = URL + NewColumnFilterStrg;
            }

            // redirect
            window.location.href =  URL;
        });

        // click event on table header trigger
        $('.OverviewHeader').off('click').on('click', '.ColumnSettingsTrigger', function() {
            var $TriggerObj = $(this),
                FilterName;

            if ($TriggerObj.hasClass('Active')) {
                $TriggerObj
                    .next('.ColumnSettingsContainer')
                    .find('.ColumnSettingsBox')
                    .fadeOut('fast', function() {
                        $TriggerObj.removeClass('Active');
                    });
            }
            else {

                // slide up all open settings widgets
                $('.ColumnSettingsTrigger')
                    .next('.ColumnSettingsContainer')
                    .find('.ColumnSettingsBox')
                    .fadeOut('fast', function() {
                        $(this).parent().prev('.ColumnSettingsTrigger').removeClass('Active');
                    });

                // show THIS settings widget
                $TriggerObj
                    .next('.ColumnSettingsContainer')
                    .find('.ColumnSettingsBox')
                    .fadeIn('fast', function() {

                        $TriggerObj.addClass('Active');

                        // refresh filter dropdown
                        FilterName = $TriggerObj
                            .next('.ColumnSettingsContainer')
                            .find('select')
                            .attr('name');

                        if (
                                $TriggerObj.closest('th').hasClass('CustomerID') ||
                                $TriggerObj.closest('th').hasClass('CustomerUserID') ||
                                $TriggerObj.closest('th').hasClass('Responsible') ||
                                $TriggerObj.closest('th').hasClass('Owner')
                            ) {

                            if (!$TriggerObj.parent().find('.SelectedValue').length) {
                                Core.AJAX.FormUpdate($('#Nothing'), 'AJAXFilterUpdate', FilterName, [ FilterName ], function() {
                                    var AutoCompleteValue = $TriggerObj
                                            .next('.ColumnSettingsContainer')
                                            .find('select')
                                            .val(),
                                        AutoCompleteText  = $TriggerObj
                                            .next('.ColumnSettingsContainer')
                                            .find('select')
                                            .find('option:selected')
                                            .text();

                                    if (AutoCompleteValue !== 'DeleteFilter') {

                                        $TriggerObj
                                            .next('.ColumnSettingsContainer')
                                            .find('select')
                                            .after('<span class="SelectedValue Hidden">' + AutoCompleteText + ' (' + AutoCompleteValue + ')</span>')
                                            .parent()
                                            .find('input[type=text]')
                                            .after('<a href="#" class="DeleteFilter"><i class="fa fa-trash-o"></i></a>')
                                            .parent()
                                            .find('a.DeleteFilter')
                                            .off()
                                            .on('click', function() {
                                                $(this)
                                                    .closest('.ColumnSettingsContainer')
                                                    .find('select')
                                                    .val('DeleteFilter')
                                                    .trigger('change');

                                                return false;
                                            });
                                    }
                                });
                            }
                        }
                        else {
                            Core.AJAX.FormUpdate($('#ColumnFilterAttributes'), 'AJAXFilterUpdate', FilterName, [ FilterName ]);
                        }
                });
            }

            return false;
        });

        // click event for whole table row
        $('.MasterAction').off('click').on('click', function (Event) {
            $MasterActionLink = $(this).find('.MasterActionLink');

            // prevent MasterAction on Dynamic Fields links
            if ($(Event.target).hasClass('DynamicFieldLink')) {
                return true;
            }

            // only act if the link was not clicked directly
            if (Event.target !== $MasterActionLink.get(0)) {
                if (Event.ctrlKey || Event.metaKey) {
                    Core.UI.Popup.open($MasterActionLink.attr('href'));
                }
                else {
                    window.location = $MasterActionLink.attr('href');
                }
                return false;
            }
        });
    };

    /**
     * @name InitInlineActions
     * @memberof Core.Agent.Overview
     * @function
     * @description
     *      This function initializes the inline actions mini overlay in medium/preview views.
     */
    TargetNS.InitInlineActions = function () {
        $('.OverviewMedium > li, .OverviewLarge > li').on('mouseenter', function() {
            $(this).find('ul.InlineActions').css('top', '0px');

            Core.App.Publish('Event.Agent.TicketOverview.InlineActions.Shown');
        });
        $('.OverviewMedium > li, .OverviewLarge > li').on('mouseleave', function(Event) {

            // The inline actions would hide if hovering over the queue selection due to a bug in IE.
            //   See bug#12403 for more information.
            // The exception has to be added also for modernized dropdowns.
            //   See bug#13100 for more information.
            if (
                Event.target.tagName.toLowerCase() === 'select'
                || $(Event.target).hasClass('InputField_Search')
                )
            {
                return false;
            }

            $(this).find('ul.InlineActions').css('top', '-35px');

            Core.App.Publish('Event.Agent.TicketOverview.InlineActions.Hidden', [$(this).find('ul.InlineActions')]);
        });
    };

    /**
     * @name InitViewMedium
     * @memberof Core.Agent.Overview
     * @function
     * @description
     *      This function initializes JS functionality for view Medium.
     */
    TargetNS.InitViewMedium = function () {

        var $MasterActionLink,
            Matches, PopupType = 'TicketAction';

        // initializes a click event for div with checkboxes
        Core.UI.InitCheckboxSelection($('div.Checkbox'));

        // initialize inline actions overlay
        TargetNS.InitInlineActions();

        // Stop propagation on click on a part of the InlienActionRow without a link
        // Otherwise that would trigger the li-wide link to the ticketzoom
        $('ul.InlineActions').click(function (Event) {
            Event.cancelBubble = true;
            if (Event.stopPropagation) {
                Event.stopPropagation();
            }
        });

        // click event for whole table row
        $('.MasterAction').off('click').on('click', function (Event) {
            $MasterActionLink = $(this).find('.MasterActionLink');

            // prevent MasterAction on Dynamic Fields links
            if ($(Event.target).hasClass('DynamicFieldLink')) {
                return true;
            }
            // only act if the link was not clicked directly
            if (Event.target !== $MasterActionLink.get(0)) {
                if (Event.ctrlKey || Event.metaKey) {
                    Core.UI.Popup.open($MasterActionLink.attr('href'));
                }
                else {
                    window.location = $MasterActionLink.attr('href');
                }
                return false;
            }
        });

        // click event for opening popup
        $('a.AsPopup').on('click', function () {
            Matches = $(this).attr('class').match(/PopupType_(\w+)/);
            if (Matches) {
                PopupType = Matches[1];
            }

            Core.UI.Popup.OpenPopup($(this).attr('href'), PopupType);
            return false;
        });

        if ($('body').hasClass('TouchDevice')) {
            $('ul.InlineActions li:not(.ResponsiveActionMenu)').hide();
        }

        $('li.ResponsiveActionMenu').on('click.ToggleResponsiveActionMenu', function () {
            $(this).siblings().toggle();
            $(this).toggleClass('Opened');
            return false;
        });
    };

    /**
     * @name InitViewPreview
     * @memberof Core.Agent.Overview
     * @function
     * @description
     *      This function initializes JS functionality for view Preview (Large).
     */
    TargetNS.InitViewPreview = function () {

        var Matches, PopupType = 'TicketAction',
            $MasterActionLink,
            URL, Index, ReplyFieldsFormID = Core.Config.Get('ReplyFieldsFormID');

        /**
         * @private
         * @name ReplyFieldsOnChange
         * @memberof Core.Agent.Overview
         * @function
         * @param {Number} FormID - ID of element
         * @description
         *      Bind change event for element which ID is FormID.
         */
        function ReplyFieldsOnChange (FormID) {
            $('#' + FormID + ' select[name=ResponseID]').on('change', function () {
                if ($(this).val() > 0) {
                    URL = Core.Config.Get('Baselink') + $(this).parents().serialize();
                    Core.UI.Popup.OpenPopup(URL, 'TicketAction');

                    // reset the select box so that it can be used again from the same window
                    $(this).val('0');
                }
            });
        }

        /**
         * @private
         * @name ReplyFieldsOnClick
         * @memberof Core.Agent.Overview
         * @function
         * @param {Number} FormID - ID of element
         * @description
         *      Bind click event for element which ID is FormID.
         */
        function ReplyFieldsOnClick (FormID) {
            $('#' + FormID + ' select[name=ResponseID]').on('click', function (Event) {
                Event.stopPropagation();
                return false;
            });
        }

        // initializes a click event for div with checkboxes
        Core.UI.InitCheckboxSelection($('div.Checkbox'));

        // initialize inline actions overlay
        TargetNS.InitInlineActions();

        // initializes the accordion effect on the specified list
        Core.UI.Accordion.Init($('.Preview > ul'), 'li h3 a', '.HiddenBlock');

        Core.App.Subscribe('Event.UI.Accordion.OpenElement', function($Element) {
            Core.UI.InputFields.Activate($Element);
        });

        // Stop propagation on click on a part of the InlienActionRow without a link
        // Otherwise that would trigger the li-wide link to the ticketzoom
        $('ul.InlineActions').click(function (Event) {
            Event.cancelBubble = true;
            if (Event.stopPropagation) {
                Event.stopPropagation();
            }
        });

        // click event for opening popup
        $('a.AsPopup').on('click', function () {
            Matches = $(this).attr('class').match(/PopupType_(\w+)/);
            if (Matches) {
                PopupType = Matches[1];
            }

            Core.UI.Popup.OpenPopup($(this).attr('href'), PopupType);
            return false;
        });

        // click event for whole table row
        $('.MasterAction').off('click').on('click', function (Event) {
            $MasterActionLink = $(this).find('.MasterActionLink');

            // If the user is trying to select text from or use article actions, MasterAction should not be executed.
            if (
                typeof Event.target === 'object'
                && (
                    $(Event.target).hasClass('ArticleBody')
                    || $(Event.target).hasClass('ItemActions')
                    || $(Event.target).parents('.Actions').length
                )
                )
            {
                return true;
            }

            // prevent MasterAction on Dynamic Fields links
            if ($(Event.target).hasClass('DynamicFieldLink')) {
                return true;
            }

            // Prevent MasterAction on Modernize input fields.
            if ($(Event.target).hasClass('InputField_Search')) {
                return true;
            }

            // only act if the link was not clicked directly
            if (Event.target !== $MasterActionLink.get(0)) {
                if (Event.ctrlKey || Event.metaKey) {
                    Core.UI.Popup.open($MasterActionLink.attr('href'));
                }
                else {
                    window.location = $MasterActionLink.attr('href');
                }
                return false;
            }
        });

        // bind events on Reply dropdown elements
        if (typeof ReplyFieldsFormID !== 'undefined') {
            for (Index in ReplyFieldsFormID) {
                ReplyFieldsOnChange(ReplyFieldsFormID[Index]);
                ReplyFieldsOnClick(ReplyFieldsFormID[Index]);
            }
        }

        if ($('body').hasClass('TouchDevice')) {
            $('ul.InlineActions li:not(.ResponsiveActionMenu)').hide();
        }

        $('li.ResponsiveActionMenu').on('click.ToggleResponsiveActionMenu', function () {
            $(this).siblings().toggle();
            $(this).toggleClass('Opened');
            return false;
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Overview || {}));
