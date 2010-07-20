// --
// Core.Agent.Search.js - provides the special module functions for the global search
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.Agent.Search.js,v 1.10 2010-07-20 06:41:13 martin Exp $
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
     * @return a true value
     *      This function rebuild attribute selection, only show available attributes
     */
    // rebuild attribute selection, only show available attributes
//    function RebuildSelection () {
    TargetNS.RebuildSelection = function () {

        // get original selection
        var $AttributeClone = $('#AttributeOrig').clone();
        $AttributeClone.attr( 'id', 'Attribute');

        // strip all already used attributes
        $AttributeClone.find('option').each( function () {
            var $Attribute = $(this);
            $('#SearchInsert label').each( function () {
                if ( $(this).attr('for') == $Attribute.attr('value') ) {
                    $Attribute.remove();
                }
            });
        });

        // replace selection with original selection
        $('#Attribute').replaceWith( $AttributeClone );

        return true;
    }

    // add attributes
    TargetNS.ItemAdd = function (Attribute) {
        $('#SerachAttributesHidden').find('label').each( function () {
            if ( $(this).attr( 'for' ) == Attribute ) {
                var $Element1 = $(this).prev().clone();
                var $Element2 = $(this).clone();
                var $Element3 = $(this).next().clone();
                $Element1.appendTo('#SearchInsert');
                $Element2.appendTo('#SearchInsert');
                $Element3.appendTo('#SearchInsert');
            }
        });
    }

    // remove attributes
    TargetNS.ItemRemove = function ($Element) {
        $Element.prev().prev().remove();
        $Element.prev().remove();
        $Element.remove();
    }

    /**
     * @function
     * @param {Event} Action
     * @return nothing
     *      This function open the search dialog
     */
    // open search dialog
    TargetNS.OpenSearchDialog = function (Action, Profile) {

        if ( !Action ) {
            Action = Core.Config.Get('Action');
        }
        if ( !Profile ) {
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

                // register add of attribute
                $('.Add').bind('click', function(){
                    var Attribute = $('#Attribute').val();
                    TargetNS.ItemAdd(Attribute);

                    // rebuild selection
                    TargetNS.RebuildSelection();

                    return false;
                });

                // register remove of attribute
                $('.Remove').live('click', function(){
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
                $('#SearchFormSubmit').live('click', function(){
                    $('#SearchForm').submit();
                    return false;
                });

                // load profile
                $('#Profile').bind('change', function(){
                    var Profile = $('#Profile').val();
                    TargetNS.OpenSearchDialog(Action, Profile);
                    return false;
                });

                // show add profile block or not
                $('#SearchProfileNew').bind('click', function(){
                    if ( $('#SearchProfileAddBlock').css('display') == 'none') {
                        $('#SearchProfileAddBlock').show();
                    }
                    else {
                        $('#SearchProfileAddBlock').hide();
                    }
                });

                // add new profile
                $('#SearchProfileAddAction').bind('click', function(){

                    // get name
                    var Name = $('#SearchProfileAddName').val();
                    if ( !Name ) {
                        return false;
                    }

                    // add name to profile selection
                    var $Element1 = $('#ProfileList').children().first().clone();
                    $Element1.text(Name);
                    $('#ProfileList').append($Element1);
                    var $Element2 = $('#Profile').children().first().clone();
                    $Element2.text(Name);
                    $Element2.attr( 'value', Name );
                    $Element2.attr( 'selected', 'selected' );
                    $('#Profile').append($Element2);

                    // set input box to empty
                    $('#SearchProfileAddName').val('');

                    // hide add template block
                    $('#SearchProfileAddBlock').hide();

                    return false;
                });

                // delete profile
                $('#SearchProfileDelete').bind('click', function(){

                    // strip all already used attributes
                    $('#Profile').find('option').each( function () {
                        if ( $(this).attr( 'value' ) != 'last-search' ) {
                            if ( $(this).attr( 'selected' ) == true ) {

                                // rebuild attributes
                                $('#SearchInsert').text('');

                                // remove remote
                                DeleteRemote( $(this).val() );

                                // remove local
                                $(this).remove();

                                // show fulltext
                                TargetNS.ItemAdd('Fulltext');

                                // rebuild selection
                                TargetNS.RebuildSelection();
                            }
                        }
                    });

                    return false;
                });

            }, 'html'
        );
    };

    // delete profile
    function DeleteRemote (Profile) {
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
    };

    return TargetNS;
}(Core.Agent.Search || {}));
