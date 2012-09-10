// --
// Core.Agent.CustomerInformationCenterSearch.js - provides the special module functions for the CIC search
// Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
// --
// $Id: Core.Agent.CustomerInformationCenterSearch.js,v 1.1 2012-09-10 10:07:17 mg Exp $
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
 * @exports TargetNS as Core.Agent.CustomerInformationCenterSearch
 * @description
 *      This namespace contains the special module functions for the search.
 */
Core.Agent.CustomerInformationCenterSearch = (function (TargetNS) {

    /**
     * @function
     * @private
     * @return nothing
     * @description Shows waiting dialog until screen is ready.
     */
    function ShowWaitingDialog(){
        Core.UI.Dialog.ShowContentDialog('<div class="Spacing Center"><span class="AJAXLoader" title="' + Core.Config.Get('LoadingMsg') + '"></span></div>', Core.Config.Get('LoadingMsg'), '10px', 'Center', true);
    }

    /**
     * @function
     * @param {String} Action which is used in framework right now.
     * @param {String} Used profile name.
     * @return nothing
     *      This function open the search dialog after clicking on "search" button in nav bar.
     */

    TargetNS.OpenSearchDialog = function () {

        var Data = {
            Action: 'AgentCustomerInformationCenterSearch',
        };

        ShowWaitingDialog();

        Core.AJAX.FunctionCall(
            Core.Config.Get('CGIHandle'),
            Data,
            function (HTML) {
                // if the waiting dialog was cancelled, do not show the search
                //  dialog as well
                if (!$('.Dialog:visible').length) {
                    return;
                }

                Core.UI.Dialog.ShowContentDialog(HTML, Core.Config.Get('SearchMsg'), '10px', 'Center', true, undefined, true);

                $("#AgentCustomerInformationCenterSearchCustomerID").autocomplete({
                    minLength: Core.Config.Get('Autocomplete.MinQueryLength'),
                    delay: Core.Config.Get('Autocomplete.QueryDelay'),
                    source: function (Request, Response) {
                        var URL = Core.Config.Get('Baselink'), Data = {
                            Action: 'AgentCustomerInformationCenterSearch',
                            Subaction: 'SearchCustomerID',
                            Term: Request.term,
                            MaxResults: Core.Config.Get('Autocomplete.MaxResultsDisplayed')
                        };
                        Core.AJAX.FunctionCall(URL, Data, function (Result) {

                            console.log(Result);

                            var Data = [];
                            $.each(Result, function () {
                                Data.push({
                                    label: this.Label,
                                    // customer list representation (see CustomerUserListFields from Defaults.pm)
                                    value: this.Value,
                                    // customer user id
                                });
                            });

                            console.log(Data);
                            Response(Data);
                        });
                    },
                    select: function (Event, UI) {
                        //var CustomerKey = UI.item.key,
                        //    CustomerValue = UI.item.value;

                        Event.preventDefault();
                        return false;
                    }
                });



/*
                // hide add template block
                $('#SearchProfileAddBlock').hide();

                // hide save changes in template block
                $('#SaveProfile').parent().hide().prev().hide().prev().hide();

                // search profile is selected
                if ($('#SearchProfile').val() && $('#SearchProfile').val() !== 'last-search') {

                    // show delete button
                    $('#SearchProfileDelete').show();

                    // show profile link
                    $('#SearchProfileAsLink').show();

                    // show save changes in template block
                    $('#SaveProfile').parent().show().prev().show().prev().show();

                    // set SaveProfile to 0
                    $('#SaveProfile').removeAttr('checked');
                }

                // register add of attribute
                $('.Add').bind('click', function () {
                    var Attribute = $('#Attribute').val();
                    TargetNS.SearchAttributeAdd(Attribute);
                    TargetNS.AdditionalAttributeSelectionRebuild();

                    return false;
                });

                // register return key
                $('#SearchForm').unbind('keypress.FilterInput').bind('keypress.FilterInput', function (Event) {
                    if ((Event.charCode || Event.keyCode) === 13) {
                        if (!CheckForSearchedValues()) {
                            return false;
                        }
                        else {
                           $('#SearchForm').submit();
                        }
                        return false;
                    }
                });

                // register submit
                $('#SearchFormSubmit').bind('click', function () {
                    var ShownAttributes = '';

                    // remember shown attributes
                    $('#SearchInsert label').each(function () {
                        if ( $(this).attr('id') ) {
                            ShownAttributes = ShownAttributes + ';' + $(this).attr('id');
                        }
                    });
                    $('#SearchForm #ShownAttributes').val(ShownAttributes);

                    // Normal results mode will return HTML in the same window
                    if ($('#SearchForm #ResultForm').val() === 'Normal') {

                        if (!CheckForSearchedValues()) {
                            return false;
                        }
                        else {
                           $('#SearchForm').submit();
                           ShowWaitingDialog();
                        }
                    }
                    else { // Print and CSV should open in a new window, no waiting dialog
                        $('#SearchForm').attr('target', 'SearchResultPage');
                        if (!CheckForSearchedValues()) {
                            return false;
                        }
                        else {
                           $('#SearchForm').submit();
                           $('#SearchForm').attr('target', '');
                        }
                    }
                    return false;
                });

                // load profile
                $('#SearchProfile').bind('change', function () {
                    var Profile = $('#SearchProfile').val(),
                        EmptySearch = $('#EmptySearch').val(),
                        Action = $('#SearchAction').val();

                    TargetNS.OpenSearchDialog(Action, Profile, EmptySearch);
                    return false;
                });

                // show add profile block or not
                $('#SearchProfileNew').bind('click', function (Event) {
                    $('#SearchProfileAddBlock').toggle();
                    $('#SearchProfileAddName').focus();
                    Event.preventDefault();
                    return false;
                });

                // add new profile
                $('#SearchProfileAddAction').bind('click', function () {
                    var Name, $Element1;

                    // get name
                    Name = $('#SearchProfileAddName').val();
                    if (!Name) {
                        return false;
                    }

                    // add name to profile selection
                    $Element1 = $('#SearchProfile').children().first().clone();
                    $Element1.text(Name);
                    $Element1.attr('value', Name);
                    $Element1.attr('selected', 'selected');
                    $('#SearchProfile').append($Element1);

                    // set input box to empty
                    $('#SearchProfileAddName').val('');

                    // hide add template block
                    $('#SearchProfileAddBlock').hide();

                    // hide save changes in template block
                    $('#SaveProfile').parent().hide().prev().hide().prev().hide();

                    // set SaveProfile to 1
                    $('#SaveProfile').attr('checked', 'checked');

                    // show delete button
                    $('#SearchProfileDelete').show();

                    // show profile link
                    $('#SearchProfileAsLink').show();

                    return false;
                });

                // direct link to profile
                $('#SearchProfileAsLink').bind('click', function (Event) {
                    var Profile = $('#SearchProfile').val(),
                        Action = $('#SearchAction').val();

                    window.location.href = Core.Config.Get('Baselink') + 'Action=' + Action +
                    ';Subaction=Search;TakeLastSearch=1;SaveProfile=1;Profile=' + encodeURIComponent(Profile);
                    return false;
                });

                // delete profile
                $('#SearchProfileDelete').bind('click', function (Event) {

                    // strip all already used attributes
                    $('#SearchProfile').find('option:selected').each(function () {
                        if ($(this).attr('value') !== 'last-search') {

                            // rebuild attributes
                            $('#SearchInsert').text('');

                            // remove remote
                            SearchProfileDelete($(this).val());

                            // remove local
                            $(this).remove();

                            // show fulltext
                            TargetNS.SearchAttributeAdd('Fulltext');

                            // rebuild selection
                            TargetNS.AdditionalAttributeSelectionRebuild();
                        }
                    });

                    if ($('#SearchProfile').val() && $('#SearchProfile').val() === 'last-search') {

                        // hide delete link
                        $('#SearchProfileDelete').hide();

                        // show profile link
                        $('#SearchProfileAsLink').hide();

                    }

                    Event.preventDefault();
                    return false;
                });
 */

            }, 'html'
        );
    };

    return TargetNS;
}(Core.Agent.Search || {}));
