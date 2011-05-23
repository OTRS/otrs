// --
// Core.Agent.Admin.GenericInterfaceWebserviceHistory.js - provides the special module functions for the GenericInterface WebserviceHistory.
// Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
// --
// $Id: Core.Agent.Admin.GenericInterfaceWebserviceHistory.js,v 1.1 2011-05-23 16:02:34 cg Exp $
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
 * @exports TargetNS as Core.Agent.Admin.GenericInterfaceWebserviceHistory
 * @description
 *      This namespace contains the special module functions for the GenericInterface WebserviceHistory module.
 */
Core.Agent.Admin.GenericInterfaceWebserviceHistory = (function (TargetNS) {


    TargetNS.Init = function (Params) {
        TargetNS.WebserviceID = parseInt(Params.WebserviceID, 10);
        TargetNS.Localization = Params.Localization;
    };

    TargetNS.GetWebserviceList = function() {
        var Data = {
            Action: 'AdminGenericInterfaceWebserviceHistory',
            Subaction: 'GetWebserviceList',
            WebserviceID: TargetNS.WebserviceID,
            FilterRemoteIP: $('#FilterRemoteIP').val() || '',
            FilterType: $('#FilterType').val() || ''
        };

        $('#WebserviceDetails').css('visibility', 'hidden');
        $('.WebserviceListWidget').addClass('Loading');

        Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {
            if (!Response || !Response.LogData) {
                alert(TargetNS.Localization.WebserviceHistoryErrorMsg);
                return;
            }

            $('.WebserviceListWidget').removeClass('Loading');

            if (!Response.LogData.length) {
                $('#WebserviceList tbody').empty().append('<tr><td colspan="3">' + TargetNS.Localization.NoDataFoundMsg + '</td></tr>');
            }
            else {
                $('#WebserviceList tbody').empty();

                $.each(Response.LogData, function(){
                    var $Tr = $('<tr></tr>');

                    $Tr.append('<td><a href="#" class="AsBlock">' + this.ID + '<input type="hidden" class="WebserviceHistoryID" value="' + this.ID + '" /></a></td>');
                    $Tr.append('<td><a href="#" class="AsBlock">' + this.CreateTime + '</a></td>');
                    $Tr.append('<td><a href="#" class="AsBlock">' + (this.ChangeTime || '-') + '</a></td>');

                    $('#WebserviceList').append($Tr);
                });

                $('#WebserviceList a').bind('click', function(Event) {
                    var WebserviceHistoryID = $(this).blur().parents('tr').find('input.WebserviceHistoryID').val();

                    TargetNS.LoadWebserviceHistoryDetails(WebserviceHistoryID);

                    return false;
                });

            }
        }, 'json');
    };

    TargetNS.LoadWebserviceHistoryDetails = function(WebserviceHistoryID) {

        var Data = {
            Action: 'AdminGenericInterfaceWebserviceHistory',
            Subaction: 'GetWebserviceHistoryDetails',
            WebserviceID: TargetNS.WebserviceID,
            WebserviceHistoryID: WebserviceHistoryID,
        };

        $('#WebserviceHistoryDetails').css('visibility', 'hidden');
        $('.WebserviceListWidget').addClass('Loading');

        Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {
            if (!Response || !Response.LogData ) {
                alert(TargetNS.Localization.WebserviceHistoryErrorMsg);
                return;
            }

            $('#WebserviceHistoryDetails > .Content').empty();
            $('.WebserviceListWidget').removeClass('Loading');

            if (!Response.LogData.Config) {
                $('#WebserviceHistoryDetails > .Content').append('<p class="ErrorMessage">' + TargetNS.Localization.NoDataFoundMsg + '</p>');
                $('#WebserviceHistoryDetails').css('visibility', 'visible').show();
            }
            else {
                    var $Container = $('<div class="WidgetSimple"></div>'),
                        $Header = $('<div class="Header"></div>'),
                        $Content = $('<div class="Content"></div>'),
                        $Fieldset = $('<fieldset class="TableLike"></fieldset>');

                    $Container.append($Header);

                    $Fieldset.append('<label for="Config">ID:</label>' +
                            '<div class="Field">' + Response.LogData.WebserviceID + '<div class="Clear"></div>'
                    );
                    $Fieldset.append('<label for="Config">Create time:</label>' +
                            '<div class="Field">' + Response.LogData.CreateTime + '<div class="Clear"></div>'
                    );

                    $Fieldset.append('<label for="Config">Change Time:</label>' +
                            '<div class="Field">' + (Response.LogData.ChangeTime || '-') + '<div class="Clear"></div>'
                    );
                    $Fieldset.append('<label for="Config">Config:</label>' +
                        '<div class="Field"><textarea id="Config" disable="disable">' + Response.LogData.Config + '</textarea></div>'
                        + '<div class="Clear"></div>'
                    );

                    $Content.append($Fieldset);

                    $('#WebserviceHistoryDetails > .Content').append($Content);
                $('#WebserviceHistoryDetails').css('visibility', 'visible').show();
                Core.UI.InitWidgetActionToggle();
            }
        }, 'json');
    };


    return TargetNS;
}(Core.Agent.Admin.GenericInterfaceWebserviceHistory || {}));