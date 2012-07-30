// --
// Core.Agent.Admin.ProcessManagement.js - provides the special module functions for the Process Management.
// Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
// --
// $Id: Core.Agent.Admin.ProcessManagement.js,v 1.20 2012-07-30 10:35:51 mn Exp $
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
                               Action: Data.Action
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
    TargetNS.ProcessLayout = {};

    TargetNS.InitAccordionDnD = function () {
        function GetMousePosition(Event) {
            var PosX = 0,
                PosY = 0;
            if (!Event) {
                Event = window.event;
            }
            if (Event.pageX || Event.pageY) {
                PosX = Event.pageX;
                PosY = Event.pageY;
            }
            else if (Event.clientX || Event.clientY) {
                PosX = Event.clientX + document.body.scrollLeft + document.documentElement.scrollLeft;
                PosY = Event.clientY + document.body.scrollTop + document.documentElement.scrollTop;
            }
            
            return {left: PosX, top: PosY};
        }
        
        function GetPositionOnCanvas(Event) {
            var $Canvas = $('#Canvas'),
                CanvasPosition,
                MousePosition,
                PosX, PosY;
            
            CanvasPosition = $Canvas.offset();
            MousePosition = GetMousePosition(Event);
            
            PosX = MousePosition.left - CanvasPosition.left;
            PosY = MousePosition.top - CanvasPosition.top;
            
            return {left: PosX, top: PosY};
        }
        
        function AddActivityToCanvas(Event, UI) {
            var Position = GetPositionOnCanvas(Event),
                EntityID = $(UI.draggable).data('entity'),
                ActivityID = $(UI.draggable).data('id'),
                Entity = TargetNS.ProcessData.Activity[EntityID],
                ProcessEntityID = $('#ProcessEntityID').val(),
                Path;

            if (typeof Entity !== 'undefined') {
                // Check if Activity is already placed
                // If so, it can't be placed again
                Path = TargetNS.ProcessData.Process[ProcessEntityID].Path;
                
                if (!Path[EntityID]) {
                    // Update Config
                    Path[EntityID] = {};
                    // Update Layout
                    TargetNS.ProcessLayout[EntityID] = {
                        left: Position.left,
                        top: Position.top
                    };
                    // Draw Entity
                    TargetNS.Canvas.CreateActivity(EntityID, Entity.Name, ActivityID, Position.left, Position.top);
                }
                else {
                    alert(Core.Agent.Admin.ProcessManagement.Localization.ActivityAlreadyPlaced);
                }
            }
            else {
                console.log('Error: Entity not defined');
            }
        }
        
        function CheckIfMousePositionIsOverActivity(Position) {
            var ProcessEntityID = $('#ProcessEntityID').val(),
                Path = TargetNS.ProcessData.Process[ProcessEntityID].Path,
                ActivityMatch = false;
            
            // Loop over all assigned activities and check the position
            $.each(Path, function (Key, Value) {
                var Activity = Key,
                    ActivityPosition = TargetNS.ProcessLayout[Key];
                
                if (
                        Position.left > ActivityPosition.left &&
                        Position.left < ActivityPosition.left + 130 &&
                        Position.top > ActivityPosition.top &&
                        Position.top < ActivityPosition.top + 100
                    ) {
                    ActivityMatch = Key;
                    return;
                }
            });
            
            return ActivityMatch;
        }
        
        function AddActivityDialogToCanvas(Event, UI) {
            var Position = GetPositionOnCanvas(Event),
                EntityID = $(UI.draggable).data('entity'),
                Entity = TargetNS.ProcessData.ActivityDialog[EntityID],
                Activity, AJAXData;

            if (typeof Entity !== 'undefined') {
                // Check if mouse position is within an activity
                // If yes, add the Dialog to the Activity
                // if not, just cancel
                Activity = CheckIfMousePositionIsOverActivity(Position);
                
                if (Activity) {
                    // Remove Label, show Loader
                    TargetNS.Canvas.ShowActivityLoader(Activity);
                    
                    // Call AJAX function to add ActivityDialog to Activity
                    AJAXData = {
                        Action: 'AdminProcessManagementActivity',
                        Subaction: 'AddActivityDialog',
                        EntityID: Activity,
                        ActivityDialog: EntityID
                    };

                    Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), AJAXData, function (Response) {
                        if (!Response || !Response.Success) {
                            if (Response && Response.Message) {
                                alert(Response.Message);
                            }
                            else {
                                alert ('Error during AJAX communication');
                            }
                            
                            TargetNS.Canvas.ShowActivityAddActivityDialogError(Activity);
                            return;
                        }
                        
                        TargetNS.Canvas.ShowActivityAddActivityDialogSuccess(Activity);
                        
                        // Update Config
                        TargetNS.ProcessData.Activity[Activity] = Response.ActivityConfig;

                    }, 'json');
                }
            }
            else {
                console.log('Error: Entity not defined');
            }
        }
        
        $('#Activities li, #ActivityDialogs li').draggable({
            revert: 'invalid',
            helper: function () {
                var $Clone = $(this).clone();
                $Clone.addClass('EntityDrag').find('span').remove();
                return $Clone[0];
            }
        });
        
        $('#Canvas').droppable({
            accept: '#Activities li, #ActivityDialogs li',
            drop: function (Event, UI) {
                var $Source = $(UI.draggable),
                    SourceID = $Source.closest('ul').attr('id');
                
                if (SourceID === 'Activities') {
                    AddActivityToCanvas(Event, UI);
                }
                else if (SourceID === 'ActivityDialogs') {
                    AddActivityDialogToCanvas(Event, UI);
                }
                else {
                    console.log('Error: No matching droppable found');
                }
            }
        });
    };
    
    TargetNS.UpdateAccordion = function () {
        // get new Accordion HTML via AJAX and replace the accordion with this HTML
        // re-initialize accordion functions (accordion, filters, DnD)
        var Data = {
                Action: 'AdminProcessManagement',
                Subaction: 'UpdateAccordion',
            };
       
        // Call the ajax function
        Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {
            $('ul#ProcessElements').replaceWith(Response);
            
            // Initialize Accordion in the sidebar
            Core.UI.Accordion.Init($('ul#ProcessElements'), 'li.AccordionElement h2 a', 'div.Content');

            // Initialize filters
            Core.UI.Table.InitTableFilter($('#ActivityFilter'), $('#Activities'));
            Core.UI.Table.InitTableFilter($('#ActivityDialogFilter'), $('#ActivityDialogs'));
            Core.UI.Table.InitTableFilter($('#TransitionFilter'), $('#Transitions'));
            Core.UI.Table.InitTableFilter($('#TransitionActionFilter'), $('#TransitionActions'));

            // Init DnD on Accordion
            TargetNS.InitAccordionDnD();
        }, 'html');
    };
    
    TargetNS.InitProcessEdit = function () {
        // Get Process Data
        TargetNS.ProcessData = {
                Process: Core.Config.Get('Config.Process'),
                Activity: Core.Config.Get('Config.Activity'),
                ActivityDialog: Core.Config.Get('Config.ActivityDialog'),
                Transition: Core.Config.Get('Config.Transition'),
                TransitionAction: Core.Config.Get('Config.TransitionAction')
        };
        
        TargetNS.ProcessLayout = Core.Config.Get('Config.ProcessLayout');
        
        // Initialize Accordion in the sidebar
        Core.UI.Accordion.Init($('ul#ProcessElements'), 'li.AccordionElement h2 a', 'div.Content');

        // Initialize filters
        Core.UI.Table.InitTableFilter($('#ActivityFilter'), $('#Activities'));
        Core.UI.Table.InitTableFilter($('#ActivityDialogFilter'), $('#ActivityDialogs'));
        Core.UI.Table.InitTableFilter($('#TransitionFilter'), $('#Transitions'));
        Core.UI.Table.InitTableFilter($('#TransitionActionFilter'), $('#TransitionActions'));

        // Init DnD on Accordion
        TargetNS.InitAccordionDnD();
        
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
    
    TargetNS.InitTransitionEdit = function () {
        
        // Init addition of new config parameters
        $('#ConfigAdd').bind('click', function() {
            
            // get current index
            var ConfigParamsPresent = $('#ConfigParams').find('fieldset'),
                NewCurrentIndex = ConfigParamsPresent.length + 1,
                // add new config param
                ConfigParamHTML = $('#ConfigParamContainer').html().replace(/_INDEX_/g, NewCurrentIndex);

            $(ConfigParamHTML).insertBefore($('#ConfigAdd'));

            return false;
        });
        
        // Init removal of fields
        $('#ConfigParams').delegate('.Remove', 'click', function() {
            $(this).parent().remove();
            
            return false;
        });
        
        $('#Submit').bind('click', function (Event) {
            $('#TransitionForm').submit();
            return false;
        });
        
    };
    
    TargetNS.ShowOverlay = function () {
        $('<div id="Overlay" tabindex="-1">').appendTo('body');
        $('body').css({
            'overflow': 'hidden'
        });
        $('#Overlay').height($(document).height()).css('top', 0);

        // If the underlying page is perhaps to small, we extend the page to window height for the dialog
        $('body').css('min-height', $(window).height());
    };
    
    TargetNS.HideOverlay = function () {
        $('#Overlay').remove();
        $('body').css({
            'overflow': 'auto'
        });
        $('body').css('min-height', 'auto');
    };
    
    TargetNS.UpdateConfig = function (Config) {
        if (typeof Config === 'undefined') {
            return false;
        }
        
        // Update config from e.g. popup windows
        // Update process 
        if (typeof Config.Process !== 'undefined') {
            // TODO: Handle Path update here (merge!)
            TargetNS.ProcessData.Process = Config.Process;
        }
        
        // Update Activities
        if (typeof Config.Activity !== 'undefined') {
            $.each(Config.Activity, function (Key, Value) {
                TargetNS.ProcessData.Activity[Key] = Value;
            });
        }
        
        // Update Activity Dialogs
        if (typeof Config.ActivityDialog !== 'undefined') {
            $.each(Config.ActivityDialog, function (Key, Value) {
                TargetNS.ProcessData.ActivityDialog[Key] = Value;
            });
        }

        // Update Transitions
        if (typeof Config.Transition !== 'undefined') {
            $.each(Config.Transition, function (Key, Value) {
                TargetNS.ProcessData.Transition[Key] = Value;
            });
        }

        // Update Transition Actions
        if (typeof Config.TransitionAction !== 'undefined') {
            $.each(Config.TransitionAction, function (Key, Value) {
                TargetNS.ProcessData.TransitionAction[Key] = Value;
            });
        }
    };
    
    return TargetNS;
}(Core.Agent.Admin.ProcessManagement || {}));
