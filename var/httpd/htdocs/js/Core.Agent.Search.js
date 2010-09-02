// --
// Core.Agent.Search.js - provides the special module functions for the global search
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.Agent.Search.js,v 1.15 2010-09-02 10:14:11 mg Exp $
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
 * @exports TargetNS as Core.Agent.Search
 * @description
 *      This namespace contains the special module functions for the search.
 */
Core.Agent.Search = (function (TargetNS) {

    /**
     * @function
     * @return nothing
     *      This function rebuild attribute selection, only show available attributes
     */

    TargetNS.RebuildSelection = function () {

        // get original selection
        var $AttributeClone = $('#AttributeOrig').clone();
        $AttributeClone.attr('id', 'Attribute');

        // strip all already used attributes
        $AttributeClone.find('option').each(function () {
            var $Attribute = $(this);
            $('#SearchInsert label').each(function () {
                if ($(this).attr('for') === $Attribute.attr('value')) {
                    $Attribute.remove();
                }
            });
        });

        // replace selection with original selection
        $('#Attribute').replaceWith($AttributeClone);

        return true;
    };

    /**
     * @function
     * @return nothing
     *      This function add attributes for search
     */

    TargetNS.ItemAdd = function (Attribute) {
        $('#SerachAttributesHidden').find('label').each(function () {
            if ($(this).attr('for') === Attribute) {
                $(this).prev().clone().appendTo('#SearchInsert');;
                $(this).clone().appendTo('#SearchInsert');
                $(this).next().clone().appendTo('#SearchInsert');;
            }
        });
        return false;
    };

    /**
     * @function
     * @param {jQueryObject} $Element The jQuery object of the form  or any element within this form
     * @return nothing
     *      This function remove attributes from an element
     */

    TargetNS.ItemRemove = function ($Element) {
        $Element.prev().prev().remove();
        $Element.prev().remove();
        $Element.remove();
    };

    // delete profile

    /**
     * @function
     * @private
     * @param {Profile} Profile The profile that will be delete
     * @return nothing
     * @description Delete a profile via an ajax requests
     */
    function DeleteRemote(Profile) {
        var Data = {
            Action: 'AgentTicketSearch',
            Subaction: 'AJAXProfileDelete',
            Profile: Profile
        };
        Core.AJAX.FunctionCall(
            Core.Config.Get('CGIHandle'),
            Data,
            function () {}
        );
    }

    /**
     * @function
     * @param {Event} Action
     * @return nothing
     *      This function open the search dialog
     */

    TargetNS.OpenSearchDialog = function (Action, Profile) {

        if (!Action) {
            Action = Core.Config.Get('Action');
        }
        if (!Profile) {
            Profile = 'last-search';
        }
        var Data = {
            Action: 'AgentSearch',
            Referrer: Action,
            Profile: Profile
        };
        Core.AJAX.FunctionCall(
            Core.Config.Get('CGIHandle'),
            Data,
            function (HTML) {
                Core.UI.Dialog.ShowContentDialog(HTML, '', '10px', 'Center', true);

                // hide add template block
                $('#SearchProfileAddBlock').hide();

                if ($('#Profile').val() && $('#Profile').val() !== 'last-search') {
                    $('#SearchProfileDelete').show();
                }

                // register add of attribute
                $('.Add').bind('click', function () {
                    var Attribute = $('#Attribute').val();
                    if (TargetNS.ItemAdd(Attribute)) {

                        // rebuild selection
                        TargetNS.RebuildSelection();
                    }

                    return false;
                });

                // register remove of attribute
                $('.Remove').live('click', function () {
                    var $Element = $(this).parent();
                    TargetNS.ItemRemove($Element);

                    // rebuild selection
                    TargetNS.RebuildSelection();

                    return false;
                });

                // register return key
                $('#SearchForm').unbind('keypress.FilterInput').bind('keypress.FilterInput', function (Event) {
                    if ((Event.charCode || Event.keyCode) === 13) {
                        $('#SearchForm').submit();
                        return false;
                    }
                });

                // register submit
                $('#SearchFormSubmit').live('click', function () {
                    $('#SearchForm').submit();
                    return false;
                });

                // load profile
                $('#Profile').bind('change', function () {
                    var Profile = $('#Profile').val();
                    TargetNS.OpenSearchDialog(Action, Profile);
                    return false;
                });

                // show add profile block or not
                $('#SearchProfileNew').bind('click', function (Event) {
                    $('#SearchProfileAddBlock').toggle();
                    Event.preventDefault();
                    return false;
                });

                // add new profile
                $('#SearchProfileAddAction').bind('click', function () {
                    var Name, $Element1, $Element2;

                    // get name
                    Name = $('#SearchProfileAddName').val();
                    if (!Name) {
                        return false;
                    }

                    // add name to profile selection
                    $Element1 = $('#ProfileList').children().first().clone();
                    $Element1.text(Name);
                    $('#ProfileList').append($Element1);
                    $Element2 = $('#Profile').children().first().clone();
                    $Element2.text(Name);
                    $Element2.attr('value', Name);
                    $Element2.attr('selected', 'selected');
                    $('#Profile').append($Element2);

                    // set input box to empty
                    $('#SearchProfileAddName').val('');

                    // hide add template block
                    $('#SearchProfileAddBlock').hide();

                    $('#SearchProfileDelete').show();

                    return false;
                });

                // delete profile
                $('#SearchProfileDelete').bind('click', function (Event) {

                    // strip all already used attributes
                    $('#Profile').find('option').each(function () {
                        if ($(this).attr('value') !== 'last-search') {
                            if ($(this).attr('selected') === true) {

                                // rebuild attributes
                                $('#SearchInsert').text('');

                                // remove remote
                                DeleteRemote($(this).val());

                                // remove local
                                $(this).remove();

                                // show fulltext
                                TargetNS.ItemAdd('Fulltext');

                                // rebuild selection
                                TargetNS.RebuildSelection();
                            }
                        }
                    });

                    if ($('#Profile').val() && $('#Profile').val() === 'last-search') {
                        $('#SearchProfileDelete').hide();
                    }

                    Event.preventDefault();
                    return false;
                });

            }, 'html'
        );
    };

    return TargetNS;
}(Core.Agent.Search || {}));
