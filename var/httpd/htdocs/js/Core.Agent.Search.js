// --
// Core.Agent.Search.js - provides the special module functions for the global search
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.Agent.Search.js,v 1.2 2010-07-13 14:08:31 martin Exp $
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

    // rebuild attribute selection, only show available attributes
    function RebuildSelection () {

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

    TargetNS.OpenSearchDialog = function () {
        Core.AJAX.ContentUpdate(
            $('#SearchOverlay'),
            Core.Config.Get('CGIHandle') + '?Action=AgentTicketSearch;Subaction=AJAX',
            function () {
                Core.UI.Dialog.ShowContentDialog($('#SearchOverlay'), '', '10px', 'Center', true);

                // WORKAROUND for ShowContentDialog and duplicate id attribute
                $('#SearchOverlay').remove();

                // register add of attribute
                Core.UI.RegisterEvent('click', $('.Add'), function(){
                    var Attribute = $(this).prev().prev().val()
                    var Element1 = $("#Search" + Attribute ).prev().clone();
                    var Element2 = $("#Search" + Attribute ).clone();
                    var Element3 = $("#Search" + Attribute ).next().clone();
                    Element1.appendTo('#SearchInsert');
                    Element2.appendTo('#SearchInsert');
                    Element3.appendTo('#SearchInsert');

                    // rebuild selection
                    RebuildSelection();

                    return false;
                });

                // register remove of attribute
                Core.UI.RegisterLiveEvent('click', $('.Remove'), function(){
                    var Element = $(this).parent();
                    Element.prev().prev().remove();
                    Element.prev().remove();
                    Element.remove();

                    // rebuild selection
                    RebuildSelection();

                    return false;
                });

                // register submit
                Core.UI.RegisterLiveEvent('click', $('#SearchFormSubmit'), function(){
                    $('#SearchForm').submit();
                    return false;
                });
            }
        );
    };

    return TargetNS;
}(Core.Agent.Search || {}));
