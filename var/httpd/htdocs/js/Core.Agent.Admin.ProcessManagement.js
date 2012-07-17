// --
// Core.Agent.Admin.ProcessManagement.js - provides the special module functions for the Process Management.
// Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
// --
// $Id: Core.Agent.Admin.ProcessManagement.js,v 1.5 2012-07-17 09:44:52 mn Exp $
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
 * @exports TargetNS as Core.Agent.Admin.ProcessManagement
 * @description
 *      This namespace contains the special module functions for the ProcessManagement module.
 */
Core.Agent.Admin.ProcessManagement = (function (TargetNS) {

    function InitProcessPopups() {
        $('a.AsPopup').bind('click', function (Event) {
            var Matches,
                PopupType = 'Process';

            Matches = $(this).attr('class').match(/PopupType_(\w+)/);
            if (Matches) {
                PopupType = Matches[1];
            }

            Core.UI.Popup.OpenPopup($(this).attr('href'), PopupType);
            return false;
        });        
    }

    function ShowDeleteProcessConfirmationDialog($Element) {
        var DialogElement = $Element.data('dialog-element'),
            DialogTitle = $Element.data('dialog-title'),
            EntityID = $Element.data('id');
        
        Core.UI.Dialog.ShowContentDialog(
            $('#Dialogs #' + DialogElement),
            DialogTitle,
            '240px',
            'Center',
            true,
            [
               {
                   Label: TargetNS.Localization.CancelMsg,
                   Class: 'Primary',
                   Function: function () {
                       Core.UI.Dialog.CloseDialog($('.Dialog'));
                   }
               },
               {
                   Label: TargetNS.Localization.DeleteMsg,
                   Function: function () {
                       var Data = {
                               Action: 'AdminProcessManagement',
                               Subaction: 'ProcessDelete',
                               ID: ProcessID
                           };

                       Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {
                           if (!Response || !Response.Success) {
                               alert(Response.Message);
                               return;
                           }

                           Core.App.InternalRedirect({
                               Action: Data.Action,
                           });
                       }, 'json');
                   }
               }
           ]
        );        
    }

    function ShowDeleteEntityConfirmationDialog(EntityType, EntityName, EntityID, ItemID) {
        var DialogID = 'Delete' + EntityType + 'ConfirmationDialog',
            $DialogElement = $('#Dialogs #' + DialogID);
        
        // Update EntityName in Dialog
        $DialogElement.find('span.EntityName').text(EntityName);
        
        Core.UI.Dialog.ShowContentDialog(
            $('#Dialogs #' + DialogID),
            TargetNS.Localization.DeleteEntityTitle,
            '240px',
            'Center',
            true,
            [
               {
                   Label: TargetNS.Localization.CancelMsg,
                   Class: 'Primary',
                   Function: function () {
                       Core.UI.Dialog.CloseDialog($('.Dialog'));
                   }
               },
               {
                   Label: TargetNS.Localization.DeleteMsg,
                   Function: function () {
                       var Data = {
                               Action: 'AdminProcessManagementProcessEdit',
                               Subaction: EntityType + 'Delete',
                               ID: ItemID,
                               EntityID: EntityID
                           };

                       Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {
                           if (!Response || !Response.Success) {
                               alert(Response.Message);
                               return;
                           }

                           
                       }, 'json');
                   }
               }
           ]
        );        
    }    
    
    TargetNS.ProcessData = {};
    
    TargetNS.InitProcessEdit = function () {
        // Get Process Data
        TargetNS.ProcessData = Core.JSON.Parse($('#ProcessData').val());
        
        // Initialize Accordion in the sidebar
        Core.UI.Accordion.Init($('ul#ProcessElements'), 'li.AccordionElement h2 a', 'div.Content');

        // Initialize filters
        Core.UI.Table.InitTableFilter($('#ActivityFilter'), $('#Activities'));
        Core.UI.Table.InitTableFilter($('#ActivityDialogFilter'), $('#ActivityDialogs'));
        Core.UI.Table.InitTableFilter($('#TransitionFilter'), $('#Transitions'));
        Core.UI.Table.InitTableFilter($('#TransitionActionFilter'), $('#TransitionActions'));
        
        // Initialize the different create and edit links/buttons
        InitProcessPopups();
        
        // Initialize the different Delete Links
        $('a.DeleteEntity').bind('click.DeleteEntity', function (Event) {
           var EntityID = $(this).closest('li').data('entity'),
               EntityName = $(this).closest('li').clone().children().remove().end().text(),
               ItemID = $(this).closest('li').data('id'),
               EntityType,
               CheckResult = {};
           
           if (!EntityID.length) {
               return false;
           }

           if ($(this).hasClass('DeleteActivity')) {
               EntityType = 'Activity';
           }
           else if ($(this).hasClass('DeleteActivityDialog')) {
               EntityType = 'ActivityDialog';
           }
           else if ($(this).hasClass('DeleteTransition')) {
               EntityType = 'Transition';
           }
           else if ($(this).hasClass('DeleteTransitionAction')) {
               EntityType = 'TransitionAction';
           }
           
           // Now check (via ajax) if the given entity is still used in a process/activity/activity dialog etc.
           // If so, show an error message in a modal dialog.
           // If not, show a confirmation modal dialog. Deletion via ajax. If successful, remove element from list.
           //CheckResult = CheckUsageOfEntity(EntityType, EntityID);
           CheckResult.Deleteable = true;
           if (!CheckResult.Deleteable) {
               ShowErrorDialog(CheckResult.Usage);
           }
           else {
               ShowDeleteEntityConfirmationDialog(EntityType, EntityName, EntityID, ItemID);
           }

           return false;
        });
        
        // Initialize DeleteProcess
        $('#ProcessDelete').bind('click.ProcessDelete', function (Event) {
            ShowDeleteProcessConfirmationDialog($(Event.target).closest('a'));
            Event.stopPropagation();
            return false;
        });
    };
    
    TargetNS.InitActivityEdit = function () {
        // Initialize Allocation List
        Core.UI.AllocationList.Init("#AvailableActivityDialogs, #AssignedActivityDialogs", ".AllocationList");
        
        // Init submit function
        $('#Submit').bind('click', function (Event) {
            // get assigned activity dialogs
            $('input[name=ActivityDialogs]').val(Core.JSON.Stringify(Core.UI.AllocationList.GetResult('#AssignedActivityDialogs', 'id')));
            
            $('#ActivityForm').submit();
            return false;
        });
        
        // Init popups
        InitProcessPopups();
    };

    TargetNS.InitActivityDialogEdit = function () {
        // Initialize Allocation List
        Core.UI.AllocationList.Init("#AvailableFields, #AssignedFields", ".AllocationList");
        
        $('#Submit').bind('click', function (Event) {
            // get assigned activity dialogs
            $('input[name=Fields]').val(Core.JSON.Stringify(Core.UI.AllocationList.GetResult('#AssignedFields', 'id')));

            $('#ActivityDialogForm').submit();
            return false;
        });
    };
    
    return TargetNS;
}(Core.Agent.Admin.ProcessManagement || {}));
