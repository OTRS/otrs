// --
// Core.Agent.Admin.ProcessManagement.js - provides the special module functions for the Process Management.
// Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
// --
// $Id: Core.Agent.Admin.ProcessManagement.js,v 1.10 2012-07-23 07:15:37 mn Exp $
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
            
            TargetNS.ShowOverlay();

            Core.UI.Popup.OpenPopup($(this).attr('href'), PopupType);
            return false;
        });

        $('a.AsPopup_Redirect').bind('click', function (Event) {
            $('#PopupRedirect').val(1);
            $('#PopupRedirectAction').val($(this).data('action'));
            $('#PopupRedirectSubaction').val($(this).data('subaction'));
            $('#PopupRedirectID').val($(this).data('id'));
            $('#PopupRedirectEntityID').val($(this).data('entity'));

            $(this).closest('form').submit();
            return false;
        });
    }
    
    function ShowDeleteProcessConfirmationDialog($Element) {
        var DialogElement = $Element.data('dialog-element'),
            DialogTitle = $Element.data('dialog-title'),
            ProcessID = $Element.data('id');
        
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

                       // Change the dialog to an ajax loader
                       $('.Dialog')
                           .find('.ContentFooter').empty().end()
                           .find('.InnerContent').empty().append('<div class="Spacing Center"><span class="AJAXLoader"></span></div>');
                       
                       // Call the ajax function
                       Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {
                           if (!Response || !Response.Success) {
                               alert(Response.Message);
                               Core.UI.Dialog.CloseDialog($('.Dialog'));
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

    function ShowDeleteEntityConfirmationDialog($Element, EntityType, EntityName, EntityID, ItemID) {
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
                               Action: 'AdminProcessManagement',
                               Subaction: 'EntityDelete',
                               EntityType: EntityType,
                               EntityID: EntityID,
                               ItemID: ItemID
                           };

                       // Change the dialog to an ajax loader
                       $('.Dialog')
                           .find('.ContentFooter').empty().end()
                           .find('.InnerContent').empty().append('<div class="Spacing Center"><span class="AJAXLoader"></span></div>');
                       
                       // Call the ajax function
                       Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {
                           if (!Response || !Response.Success) {
                               alert(Response.Message);
                               Core.UI.Dialog.CloseDialog($('.Dialog'));
                               return;
                           }

                           // Remove element from accordion
                           $Element.closest('li').remove();
                           Core.UI.Dialog.CloseDialog($('.Dialog'));
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
           
           ShowDeleteEntityConfirmationDialog($(this), EntityType, EntityName, EntityID, ItemID);
           
           return false;
        });
        
        // Initialize DeleteProcess
        $('#ProcessDelete').bind('click.ProcessDelete', function (Event) {
            ShowDeleteProcessConfirmationDialog($(Event.target).closest('a'));
            Event.stopPropagation();
            return false;
        });
        
        // Init Diagram Canvas
        TargetNS.Canvas.Init();
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

        // Init popups
        // TODO create field details popup and re-enable
        // InitProcessPopups();
    };
    
    TargetNS.ShowOverlay = function () {
        $('<div id="Overlay" tabindex="-1">').appendTo('body');
        $('body').css({
            'overflow': 'hidden'
        });
        $('#Overlay').height($(document).height()).css('top', 0);

        // If the underlying page is perhaps to small, wie extend the page to window height for the dialog
        $('body').css('min-height', $(window).height());
    };
    
    TargetNS.HideOverlay = function () {
        $('#Overlay').remove();
        $('body').css({
            'overflow': 'auto'
        });
        $('body').css('min-height', 'auto');
    };
    
    TargetNS.UpdateConfig = function (ConfigJSON) {
        var Config = Core.JSON.Parse(ConfigJSON);
        
        if (typeof Config === 'undefined') {
            return false;
        }
        
        // Update config from popup window

        // Update process 
        if (typeof Config.Process !== 'undefined') {
            // TODO: Handle Path update here (merge!)
            TragetNS.ProcessData.Process = Config.Process;
        }
        
        // Update Activities
        if (typeof Config.Activity !== 'undefined') {
            
            
        }
        
        
        
    };
    
    return TargetNS;
}(Core.Agent.Admin.ProcessManagement || {}));
