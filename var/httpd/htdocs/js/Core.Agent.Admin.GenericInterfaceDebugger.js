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
 * @namespace Core.Agent.Admin.GenericInterfaceDebugger
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the GenericInterface debugger module.
 */
Core.Agent.Admin.GenericInterfaceDebugger = (function (TargetNS) {

    /**
     * @private
     * @name FormatISODate
     * @memberof Core.Agent.Admin.GenericInterfaceDebugger
     * @function
     * @returns {String} ISO-formatted date
     * @param {String} Year
     * @param {String} Month
     * @param {String} Day
     * @description
     *      Formats a date as ISO.
     */
    function FormatISODate (Year, Month, Day) {
        var Result = '',
            Temp;

        Temp = parseInt(Year || 0, 10);
        Result = Result + Temp + '-';

        Temp = parseInt(Month || 0, 10);
        if (Temp < 10) {
            Temp = '0' + Temp;
        }
        Result = Result + Temp + '-';

        Temp = parseInt(Day || 0, 10);
        if (Temp < 10) {
            Temp = '0' + Temp;
        }
        Result = Result + Temp;

        return Result;
    }

    /**
     * @name Init
     * @memberof Core.Agent.Admin.GenericInterfaceDebugger
     * @function
     * @description
     *      Initializes the module functions.
     */
    TargetNS.Init = function () {

        TargetNS.WebserviceID = parseInt(Core.Config.Get('WebserviceID'), 10);

        // add click binds
        $('#FilterRefresh').on('click', TargetNS.GetRequestList);
        $('#DeleteButton').on('click', TargetNS.ShowDeleteDialog);

        TargetNS.GetRequestList();
    };

    /**
     * @name GetRequestList
     * @memberof Core.Agent.Admin.GenericInterfaceDebugger
     * @function
     * @description
     *      Loads the request list via AJAX.
     */
    TargetNS.GetRequestList = function() {
        var Data = {
            Action: 'AdminGenericInterfaceDebugger',
            Subaction: 'GetRequestList',
            WebserviceID: TargetNS.WebserviceID,
            FilterLimit: $('#FilterLimit').val() || '',
            FilterSort: $('#FilterSort').val() || '',
            FilterRemoteIP: $('#FilterRemoteIP').val() || '',
            FilterType: $('#FilterType').val() || ''
        };

        Data.FilterFrom = FormatISODate($('#FilterFromYear').val(), $('#FilterFromMonth').val(), $('#FilterFromDay').val()) + ' 00:00:00';
        Data.FilterTo = FormatISODate($('#FilterToYear').val(), $('#FilterToMonth').val(), $('#FilterToDay').val()) + ' 23:59:59';

        $('#CommunicationDetails').css('visibility', 'hidden');
        $('.RequestListWidget').addClass('Loading');

        Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {
            var HTML = '';

            if (!Response || !Response.LogData) {
                alert(Core.Language.Translate('An error occurred during communication.'));
                return;
            }

            $('.RequestListWidget').removeClass('Loading');

            if (!Response.LogData.length) {
                $('#RequestList tbody').empty().append('<tr><td colspan="4">' + Core.Language.Translate('No data found.') + '</td></tr>');
                return;
            }

            $('#RequestList tbody').empty();

            $.each(Response.LogData, function(){
                HTML += '<tr>';
                HTML += '<td><a href="#" class="AsBlock">' + this.CommunicationType + '<input type="hidden" class="CommunicationID" value="' + this.CommunicationID + '" /></a></td>';
                HTML += '<td><a href="#" class="AsBlock">' + this.Created + '</a></td>';
                HTML += '<td><a href="#" class="AsBlock">' + this.CommunicationID + '</a></td>';
                HTML += '<td><a href="#" class="AsBlock">' + (this.RemoteIP || '-') + '</a></td>';
                HTML += '</tr>';
            });

            $('#RequestList tbody').html(HTML);

            $('#RequestList a').on('click', function() {
                var CommunicationID = $(this).blur().parents('tr').find('input.CommunicationID').val();

                // highlight selected entry
                $(this).parents('tr').addClass('Active').siblings().removeClass('Active');

                TargetNS.LoadCommunicationDetails(CommunicationID);

                return false;
            });

        }, 'json');
    };

    /**
     * @name LoadCommunicationDetails
     * @memberof Core.Agent.Admin.GenericInterfaceDebugger
     * @function
     * @param {String} CommunicationID
     * @description
     *      Load communication details via AJAX.
     */
    TargetNS.LoadCommunicationDetails = function(CommunicationID) {

        var Data = {
            Action: 'AdminGenericInterfaceDebugger',
            Subaction: 'GetCommunicationDetails',
            WebserviceID: TargetNS.WebserviceID,
            CommunicationID: CommunicationID
        };

        $('#CommunicationDetails').css('visibility', 'hidden');
        $('.RequestListWidget').addClass('Loading');

        Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {
            if (!Response || !Response.LogData || !Response.LogData.Data) {
                alert(Core.Language.Translate('An error occurred during communication.'));
                return;
            }

            $('#CommunicationDetails > .Header').empty();
            $('#CommunicationDetails > .Content').empty();
            $('.RequestListWidget').removeClass('Loading');

            if (!Response.LogData.Data.length) {
                $('#CommunicationDetails > .Header').append('<h2>' + Core.Language.Translate('Request Details') + '</h2>');
                $('#CommunicationDetails > .Content').append('<p class="ErrorMessage">' + Core.Language.Translate('No data found.') + '</p>');
                $('#CommunicationDetails').css('visibility', 'visible').show();
            }
            else {
                $('#CommunicationDetails > .Header').append('<h2>' + Core.Language.Translate('Request Details for Communication ID') + ' ' + CommunicationID + '</h2>');

                $.each(Response.LogData.Data, function(){
                    var $Container = $('<div class="WidgetSimple Expanded"></div>'),
                        $Header = $('<div class="Header"></div>'),
                        $Content = $('<div class="Content"></div>');

                    $Header.append('<div class="WidgetAction Toggle"><a href="#" title="' + Core.Language.Translate('Show or hide the content.') + '"><i class="fa fa-caret-right"></i><i class="fa fa-caret-down"></i></a></div>');
                    $Header.append('<h3 class="DebugLevel_' + this.DebugLevel + '">' + this.Summary + ' (' + this.Created + ', ' + this.DebugLevel + ')</h3>');
                    $Container.append($Header);

                    if (this.Data && this.Data.length) {

                        // quote XML tags
                        this.Data = this.Data.replace(new RegExp("&", "gm"), "&amp;");
                        this.Data = this.Data.replace(new RegExp("<", "gm"), "&lt;");
                        this.Data = this.Data.replace(new RegExp(">", "gm"), "&gt;");

                        $Content.append('<pre><code>' + this.Data + '</code></pre>');
                    }
                    $Container.append($Content);

                    $('#CommunicationDetails > .Content').append($Container);
                });
                $('#CommunicationDetails').css('visibility', 'visible').show();
                Core.UI.InitWidgetActionToggle();
            }
        }, 'json');
    };

    /**
     * @name ShowDeleteDialog
     * @memberof Core.Agent.Admin.GenericInterfaceDebugger
     * @function
     * @param {String} Event
     * @description
     *      Shows a confirmation dialog to clear the log.
     */
    TargetNS.ShowDeleteDialog = function(Event){
        Core.UI.Dialog.ShowContentDialog(
            $('#DeleteDialogContainer'),
            Core.Language.Translate('Clear debug log'),
            '240px',
            'Center',
            true,
            [
               {
                   Label: Core.Language.Translate('Cancel'),
                   Function: function () {
                       Core.UI.Dialog.CloseDialog($('#DeleteDialog'));
                   }
               },
               {
                   Label: Core.Language.Translate('Clear'),
                   Function: function () {
                       var Data = {
                            Action: 'AdminGenericInterfaceDebugger',
                            Subaction: 'ClearDebugLog',
                            WebserviceID: TargetNS.WebserviceID
                        };

                        $('#CommunicationDetails').css('visibility', 'hidden');
                        $('.RequestListWidget').addClass('Loading');

                        Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {
                            if (!Response || !Response.Success) {
                                alert(Core.Language.Translate('An error occurred during communication.'));
                                return;
                            }

                            TargetNS.GetRequestList();

                        }, 'json');

                       Core.UI.Dialog.CloseDialog($('#DeleteDialog'));
                   }
               }
           ]
        );

        Event.stopPropagation();
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.GenericInterfaceDebugger || {}));
