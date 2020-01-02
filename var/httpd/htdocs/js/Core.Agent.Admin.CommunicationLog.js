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
Core.Agent.Admin = Core.Agent.Admin || {};

/**
 * @namespace Core.Agent.Admin.CommunicationLog
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the CommunicationLog module.
 */
Core.Agent.Admin.CommunicationLog = (function (TargetNS) {

    /**
     * @name ShowContextSettingsDialog
     * @memberof Core.Agent.Admin.CommunicationLog
     * @function
     * @description
     *      Bind event on Setting button.
     */
    TargetNS.ShowContextSettingsDialog = function() {
        $('#ShowContextSettingsDialog').on('click', function (Event) {
            Core.UI.Dialog.ShowContentDialog($('#ContextSettingsDialogContainer'), Core.Language.Translate("Settings"), '20%', 'Center', true,
                [
                    {
                        Label: Core.Language.Translate("Save"),
                        Type: 'Submit',
                        Class: 'Primary'}
                ]);
            Event.preventDefault();
            Event.stopPropagation();
            return false;
        });
    }

    /**
     * @private
     * @name SerializeData
     * @memberof Core.Agent.Admin.CommunicationLog
     * @function
     * @returns {String} query string of the data
     * @param {Object} Data - The data that should be converted.
     * @description
     *      Converts a given hash into a query string.
     */
    function SerializeData(Data) {
        var QueryString = '';
        $.each(Data, function (Key, Value) {
            QueryString += ';' + encodeURIComponent(Key) + '=' + encodeURIComponent(Value);
        });
        return QueryString;
    }

    /**
     * @name Init
     * @memberof Core.Agent.Admin.CommunicationLog
     * @function
     * @description
     *       Initialize module functionality
     */
    TargetNS.Init = function () {

        var URL = Core.Config.Get('Baselink'),
            LogEntryCount,
            ObjectSelected,
            ObjectIdElement,
            AccountID = Core.Config.Get('AccountID');

        TargetNS.ShowContextSettingsDialog();

        // initialize history back button
        $("#OverviewButton").off('click.OverviewButton').on('click.OverviewButton', function(event) {
            event.preventDefault();
            history.back(1);
        });

        // initialize table filters
        Core.UI.Table.InitTableFilter($('#FilterCommunications'), $('#CommunicationsTable'));
        Core.UI.Table.InitTableFilter($('#FilterAccounts'), $('#AccountsTable'));
        Core.UI.Table.InitTableFilter($('#FilterCommunicationLogList'), $('#CommunicationLogListTable'));

        // initialize table sorting
        Core.UI.Table.Sort.Init($('#ObjectListTable'));
        Core.UI.Table.Sort.Init($('#AccountsTable'));
        Core.UI.Table.Sort.Init($('#CommunicationLogListTable'));

        // initialize time range update in communication log overview
        $('#TimeRange').off('change.TimeRange').on('change.TimeRange', function () {

            URL = Core.Config.Get('Baselink');
            URL += SerializeData({
                Action: 'AdminCommunicationLog',
                StartTime: $('#TimeRange').val(),
                Expand: $('#CommunicationList').hasClass('Expanded') ? 1 : 0
            });
            window.location = URL;
        });

        // initialize time range update in mail account view
        $('#TimeRangeAccounts').off('change.TimeRangeAccounts').on('change.TimeRangeAccounts', function () {

            URL = Core.Config.Get('Baselink');
            URL += SerializeData({
                Action: 'AdminCommunicationLog',
                Subaction: 'Accounts',
                StartTime: $('#TimeRangeAccounts').val()
            });
            window.location = URL;
        });

        // Initialize priority filter update in communication log zoom screen.
        $('#PriorityFilter').off('change.PriorityFilter').on('change.PriorityFilter', function () {

            URL = Core.Config.Get('Baselink');
            URL += SerializeData({
                Action: 'AdminCommunicationLog',
                Subaction: 'Zoom',
                PriorityFilter: $('#PriorityFilter').val(),
                CommunicationID: Core.Config.Get('CommunicationID')
            });
            window.location = URL;
        });

        // initialize object log entry update
        $('#ObjectListTable > tbody').children('tr').off('click.ObjectList').on('click.ObjectList', function() {


            URL = Core.Config.Get('Baselink');
            URL += SerializeData({
                Action: 'AdminCommunicationLog',
                Subaction: 'GetObjectLog',
                CommunicationID: Core.Config.Get('CommunicationID'),
                ObjectLogID : $(this).attr('id')
            });

            // setup loader and row activation
            $('#CommunicationObjectWidget').addClass('Loading');
            $('#ObjectListTable').find('tr.Active').removeClass('Active');
            $('#' + Core.App.EscapeSelector($(this).attr('id'))).addClass('Active');

            Core.AJAX.ContentUpdate($('#ObjectLogWidget'), URL, function () {

                // remove loader and initialize table sorting function
                $('#CommunicationObjectWidget').removeClass('Loading');
                Core.UI.Table.Sort.Init($('#ObjectLogListTable'));
                Core.UI.InitWidgetActionToggle();

                // initialize communication log object filter
                Core.UI.Table.InitTableFilter($('#FilterObjectLogEntries'), $('#ObjectLogListTable'));

                // count the entry numbers
                LogEntryCount = 1;

                $('#ObjectLogListTable').find('td.ObjectLogEntry').each(function() {
                    $(this).text(LogEntryCount);
                    LogEntryCount++;
                });

                // Enforce priority filter on returned data.
                ApplyPriorityFilter();
            });
        });

        // select the given object or the first entry in object list table.
        ObjectSelected = $('#ObjectListTable > tbody').children('tr:first');
        if (Core.Config.Get('ObjectLogID')) {
            ObjectIdElement = $('#ObjectListTable > tbody').children('tr#' + Core.Config.Get('ObjectLogID'));
            if (ObjectIdElement.length) {
                ObjectSelected = ObjectIdElement;
            }
        }
        ObjectSelected.click();

        // initialize mail account entry update
        $('#AccountsTable > tbody').children('tr').off('click.AccountList').on('click.AccountList', function() {

            var $Row = $(this);
            var AccountID = $Row.attr('id')

            if (!AccountID) {
                return;
            }

            URL = Core.Config.Get('Baselink');
            URL += SerializeData({
                Action: 'AdminCommunicationLog',
                Subaction: 'GetCommunicationLog',
                StartTime: $('#TimeRangeAccounts').val(),
                AccountID : AccountID
            });


            // setup loader and row activation
            $('#AccountsWidget').addClass('Loading');
            $('#AccountsTable').find('tr.Active').removeClass('Active');
            $('#' + Core.App.EscapeSelector($(this).attr('id'))).addClass('Active');

            Core.AJAX.ContentUpdate($('#FilteredCommunicationsWidget'), URL, function () {

                // remove loader and initialize table sorting function
                $('#AccountsWidget').removeClass('Loading');
                Core.UI.Table.Sort.Init($('#CommunicationLogListTable'));
                Core.UI.InitWidgetActionToggle();

                // initialize communication log object filter
                Core.UI.Table.InitTableFilter($('#FilterCommunicationLogList'), $('#CommunicationLogListTable'));

                // Initialize master action row handler.
                Core.UI.InitMasterAction();
            });
        });

        // select the first entry in object list table or a given row by mail account id
        if (AccountID) {
            $('#' + Core.App.EscapeSelector(AccountID)).addClass('Active');
        }
        else {
            $('#AccountsTable > tbody').children('tr:first').click();
        }

        // Initialize master action row handler.
        Core.UI.InitMasterAction();
    };

    /**
     * @private
     * @name ApplyPriorityFilter
     * @memberof Core.Agent.Admin.CommunicationLog
     * @description
     *      Removes rows that do not satisfy selected log level. Please note that each log level contains all lower
     *      levels as well, so, for example, 'Trace' will show all log messages, while 'Warn' will show only 'Warn' and
     *      'Error'.
     */
    function ApplyPriorityFilter() {
        var PriorityFilter = $('#PriorityFilter').val() || 'Trace',
            Priorities = [
                'Trace',
                'Debug',
                'Info',
                'Notice',
                'Warn',
                'Error'
            ],
            HiddenPriorities = [];

        $.each(Priorities, function(Index, Priority) {
            if (Priority == PriorityFilter) {
                return false;
            }
            HiddenPriorities.push(Priority);
        });

        if (HiddenPriorities.length == 0) {
            return;
        }

        // Remove filtered rows.
        $('#ObjectLogListTable > tbody').children('tr:not(".FilterMessage")').each(function (Index, Row) {
            if ($(Row).find('td.Priority:not(".' + HiddenPriorities.join('"):not(".') + '")').length == 0) {
                $(Row).remove();
            }
        });

        // If no rows remain, show no match message.
        if ($('#ObjectLogListTable > tbody').children('tr:not(".FilterMessage")').length == 0) {
            $('#ObjectLogListTable > tbody').children('tr.FilterMessage')
                .removeClass('Hidden')
                .removeClass('FilterMessage');
        }
    }

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.CommunicationLog || {}));
