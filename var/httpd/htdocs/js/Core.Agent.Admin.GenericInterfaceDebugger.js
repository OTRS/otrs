// --
// Core.Agent.Admin.GenericInterfaceDebugger.js - provides the special module functions for the GenericInterface debugger.
// Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};
Core.Agent.Admin = Core.Agent.Admin || {};

/**
 * @namespace
 * @exports TargetNS as Core.Agent.Admin.GenericInterfaceDebugger
 * @description
 *      This namespace contains the special module functions for the GenericInterface debugger module.
 */
Core.Agent.Admin.GenericInterfaceDebugger = (function (TargetNS) {

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

    TargetNS.Init = function (Params) {
        TargetNS.WebserviceID = parseInt(Params.WebserviceID, 10);
        TargetNS.Localization = Params.Localization;
    };

    TargetNS.GetRequestList = function() {
        var Data = {
            Action: 'AdminGenericInterfaceDebugger',
            Subaction: 'GetRequestList',
            WebserviceID: TargetNS.WebserviceID,
            FilterRemoteIP: $('#FilterRemoteIP').val() || '',
            FilterType: $('#FilterType').val() || ''
        };


        Data.FilterFrom = FormatISODate($('#FilterFromYear').val(), $('#FilterFromMonth').val(), $('#FilterFromDay').val()) + ' 00:00:00';
        Data.FilterTo   = FormatISODate($('#FilterToYear').val(), $('#FilterToMonth').val(), $('#FilterToDay').val()) + ' 23:59:59';

        $('#CommunicationDetails').css('visibility', 'hidden');
        $('.RequestListWidget').addClass('Loading');

        Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {
            var HTML = '';

            if (!Response || !Response.LogData) {
                alert(TargetNS.Localization.CommunicationErrorMsg);
                return;
            }

            $('.RequestListWidget').removeClass('Loading');

            if (!Response.LogData.length) {
                $('#RequestList tbody').empty().append('<tr><td colspan="3">' + TargetNS.Localization.NoDataFoundMsg + '</td></tr>');
                return;
            }

            $('#RequestList tbody').empty();

            $.each(Response.LogData, function(){
                HTML += '<tr>';
                HTML += '<td><a href="#" class="AsBlock">' + this.CommunicationType + '<input type="hidden" class="CommunicationID" value="' + this.CommunicationID + '" /></a></td>';
                HTML += '<td><a href="#" class="AsBlock">' + this.Created + '</a></td>';
                HTML += '<td><a href="#" class="AsBlock">' + (this.RemoteIP || '-') + '</a></td>';
                HTML += '</tr>';
            });

            $('#RequestList tbody').html(HTML);

            $('#RequestList a').bind('click', function(Event) {
                var CommunicationID = $(this).blur().parents('tr').find('input.CommunicationID').val();

                TargetNS.LoadCommunicationDetails(CommunicationID);

                return false;
            });

        }, 'json');
    };

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
                alert(TargetNS.Localization.CommunicationErrorMsg);
                return;
            }

            $('#CommunicationDetails > .Content').empty();
            $('.RequestListWidget').removeClass('Loading');

            if (!Response.LogData.Data.length) {
                $('#CommunicationDetails > .Content').append('<p class="ErrorMessage">' + TargetNS.Localization.NoDataFoundMsg + '</p>');
                $('#CommunicationDetails').css('visibility', 'visible').show();
            }
            else {
                $.each(Response.LogData.Data, function(){
                    var $Container = $('<div class="WidgetSimple Expanded"></div>'),
                        $Header = $('<div class="Header"></div>'),
                        $Content = $('<div class="Content"></div>');

                    $Header.append('<div class="WidgetAction Toggle"><a href="#" title="' + TargetNS.Localization.ToggleContentMsg + '"><i class="icon-caret-right"></i><i class="icon-caret-down"></i></a></div>');
                    $Header.append('<h3 class="DebugLevel_' + this.DebugLevel + '">' + this.Summary + ' (' + this.Created + ', ' + this.DebugLevel + ')</h3>');
                    $Container.append($Header);

                    if (this.Data && this.Data.length) {

                        // quote XML tags
                        this.Data = this.Data.replace( new RegExp("<","gm"),"&lt;");
                        this.Data = this.Data.replace( new RegExp(">","gm"),"&gt;");

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

    TargetNS.ShowDeleteDialog = function(Event){
        Core.UI.Dialog.ShowContentDialog(
            $('#DeleteDialogContainer'),
            TargetNS.Localization.ClearDebugLogMsg,
            '240px',
            'Center',
            true,
            [
               {
                   Label: TargetNS.Localization.CancelMsg,
                   Function: function () {
                       Core.UI.Dialog.CloseDialog($('#DeleteDialog'));
                   }
               },
               {
                   Label: TargetNS.Localization.ClearMsg,
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
                                alert(TargetNS.Localization.CommunicationErrorMsg);
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

    return TargetNS;
}(Core.Agent.Admin.GenericInterfaceDebugger || {}));