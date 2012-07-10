// --
// Core.UI.AllocationList.js - provides functionality for allocation lists
// Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
// --
// $Id: Core.UI.AllocationList.js,v 1.1 2012-07-10 13:29:32 mn Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.UI = Core.UI || {};

/**
 * @namespace
 * @exports TargetNS as Core.UI.AllocationList
 * @description
 *      Support for Allocation Lists (sortable lists)
 */
Core.UI.AllocationList = (function (TargetNS) {
    if (!Core.Debug.CheckDependency('Core.UI.AllocationList', '$([]).sortable', 'jQuery UI sortable')) {
        return;
    }

    /**
     * @function
     * @description
     *      gets the result of an allocation list.
     * @param {String} ResultListSelector
     *      The selector for the list which will be evaluated for the result
     * @param {String} DataAttribute
     *      The data attribute to determine the selection
     * @return {Array} An array of values defined by DataAttribute
     */    
    TargetNS.GetResult = function (ResultListSelector, DataAttribute) {
        var $List = $(ResultListSelector),
            Result = [];
        
        if (!$List.length || !$List.find('li').length) {
            return [];
        }
        
        $List.find('li').each(function () {
            var Value = $(this).data(DataAttribute);
            if (typeof Value !== 'undefined') {
                Result.push(Value);
            }
        });
        
        return Result;
    };
    
    /**
     * @function
     * @description
     *      Initializes an allocation list.
     * @param {String} ListSelector
     *      The selector for the lists to initialize
     * @param {String} ConnectorSelector
     *      The selector for the connection (dnd), probably a class
     * @return nothing
     */
    TargetNS.Init = function (ListSelector, ConnectorSelector) {
        var $Lists = $(ListSelector);
        
        if (!$Lists.length) {
            return;
        }
        
        $Lists
            .find('li').removeClass('Even').end()    
            .sortable({
                connectWith: ConnectorSelector,
            }).disableSelection();
    };

    return TargetNS;
}(Core.UI.Popup || {}));
