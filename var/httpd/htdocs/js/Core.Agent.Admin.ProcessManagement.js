// --
// Core.Agent.Admin.ProcessManagement.js - provides the special module functions for the Process Management.
// Copyright (C) 2001-2013 OTRS AG, http://otrs.org/
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

            if (PopupType !== 'ProcessOverview') {
                TargetNS.ShowOverlay();
            }

            Core.UI.Popup.OpenPopup($(this).attr('href'), PopupType);
            return false;
        });

        $('a.AsPopup_Redirect').bind('click', function (Event) {
            var $Form = $(this).closest('form');

            $('#PopupRedirect').val(1);
            $('#PopupRedirectAction').val($(this).data('action'));
            $('#PopupRedirectSubaction').val($(this).data('subaction'));
            $('#PopupRedirectID').val($(this).data('id'));
            $('#PopupRedirectEntityID').val($(this).data('entity'));
            // Only used for path popup
            $('#PopupRedirectStartActivityID').val($(this).data('startactivityid'));

            if ($(this).hasClass('Edit_Confirm')) {
                if (window.confirm(Core.Agent.Admin.ProcessManagement.Localization.EditConfirm)) {
                    // Remove onbeforeunload event only if there is no validation pending on form submit
                    if (!($Form.hasClass("Validate"))) {
                        $(window).unbind("beforeunload.PMPopup");
                    }
                    $(this).closest('form').submit();
                }
            }
            else {
                // Remove onbeforeunload event only if there is no validation pending on form submit
                if (!($Form.hasClass("Validate"))) {
                    $(window).unbind("beforeunload.PMPopup");
                }
                $(this).closest('form').submit();
            }
            return false;
        });

        $('a.GoBack').bind('click', function (Event) {
            // Remove onbeforeunload event (which is only needed if you close the popup via the window "X")
            $(window).unbind("beforeunload.PMPopup");
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

    function InitDeleteEntity() {
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
                Path, PathLength = 0, PathKey;

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

                    // get Path length
                    for (PathKey in Path) {
                        if (Path.hasOwnProperty(PathKey)) {
                            PathLength++;
                        }
                    }

                    // if no other activity is on the canvas, make this activity to the startactivity
                    if (PathLength === 1) {
                        TargetNS.Canvas.SetStartActivity(EntityID);
                        TargetNS.ProcessData.Process[ProcessEntityID].StartActivity = EntityID;

                    }

                    TargetNS.Canvas.MakeDraggable();
                }
                else {
                    alert(Core.Agent.Admin.ProcessManagement.Localization.ActivityAlreadyPlaced);
                }
            }
            else {
                Core.Exception.Throw('Error: Entity not defined!', 'ProcessError');
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
                        Position.left > parseInt(ActivityPosition.left, 10) &&
                        Position.left < parseInt(ActivityPosition.left, 10) + 110 &&
                        Position.top > parseInt(ActivityPosition.top, 10) &&
                        Position.top < parseInt(ActivityPosition.top, 10) + 80
                    ) {
                    ActivityMatch = Key;
                    return false;
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
                        TargetNS.ProcessData.Activity[Activity] = Response.ActivityConfig.Activity[Activity];

                    }, 'json');
                }
            }
            else {
                Core.Exception.Throw('Error: Entity not defined!', 'ProcessError');
            }
        }

        // Check if any transition has a dummy endpoint
        function DummyActivityConnected(ProcessEntityID) {
            var DummyFound = false;
            $.each(TargetNS.ProcessData.Process[ProcessEntityID].Path, function (Activity, ActivityData) {
                $.each(ActivityData, function (Transition, TransitionData) {
                    if (typeof TransitionData.ActivityEntityID === 'undefined') {
                        DummyFound = true;
                    }
                });
            });
            return DummyFound;
        }

        function AddTransitionToCanvas(Event, UI) {
            var Position = GetPositionOnCanvas(Event),
                EntityID = $(UI.draggable).data('entity'),
                Entity = TargetNS.ProcessData.Transition[EntityID],
                ProcessEntityID = $('#ProcessEntityID').val(),
                Activity,
                Path = TargetNS.ProcessData.Process[ProcessEntityID].Path;

            // if a dummy activity exists, another transition was placed to the canvas but not yet
            // connected to an end point. One cannot place to unconnected transitions on the canvas.
            if ($('#Dummy').length && DummyActivityConnected(ProcessEntityID)) {
              alert(Core.Agent.Admin.ProcessManagement.Localization.UnconnectedTransition);
              return;
            }

            if (typeof Entity !== 'undefined') {
                // Check if mouse position is within an activity
                // If yes, add the Dialog to the Activity
                // if not, just cancel
                Activity = CheckIfMousePositionIsOverActivity(Position);

                // If this transition is already bind to this activity
                // you cannot bind it a second time
                if (Path[Activity] && typeof Path[Activity][EntityID] !== 'undefined') {
                    alert(Core.Agent.Admin.ProcessManagement.Localization.TransitionAlreadyPlaced);
                    return;
                }

                if (Activity) {
                    // Create dummy activity to use for initial transition
                    TargetNS.Canvas.CreateActivityDummy(Activity);

                    // Create transition between this Activity and DummyElement
                    TargetNS.Canvas.CreateTransition(Activity, 'Dummy', EntityID);

                    // Add Transition to Path
                    if (typeof Path[Activity] === 'undefined') {
                        Path[Activity] = {};
                    }
                    Path[Activity][EntityID] = {
                        ActivityEntityID: undefined
                    };
                }
            }
            else {
                Core.Exception.Throw('Error: Entity not defined!', 'ProcessError');
            }
        }

        function AddTransitionActionToCanvas(Event, UI) {
            var EntityID = $(UI.draggable).data('entity'),
                Entity = TargetNS.ProcessData.TransitionAction[EntityID],
                Transition,
                ProcessEntityID = $('#ProcessEntityID').val(),
                Path = TargetNS.ProcessData.Process[ProcessEntityID].Path;

            if (typeof Entity !== 'undefined') {
                Transition = TargetNS.Canvas.DragTransitionActionTransition;

                if (!Transition.TransitionID) {
                    return false;
                }

                // If this action is already bound to this transition
                // you cannot bind it a second time
                if (Path[Transition.StartActivity] &&
                    typeof Path[Transition.StartActivity][Transition.TransitionID] !== 'undefined' &&
                    typeof Path[Transition.StartActivity][Transition.TransitionID].TransitionAction !== 'undefined' &&
                    ($.inArray(EntityID, Path[Transition.StartActivity][Transition.TransitionID].TransitionAction) >= 0)
                ) {
                    alert(Core.Agent.Admin.ProcessManagement.Localization.TransitionActionAlreadyPlaced);
                    return;
                }

                if (Transition) {
                    // Add Action to Path
                    if (typeof Path[Transition.StartActivity][Transition.TransitionID].TransitionAction === 'undefined') {
                        Path[Transition.StartActivity][Transition.TransitionID].TransitionAction = [];
                    }
                    Path[Transition.StartActivity][Transition.TransitionID].TransitionAction.push(EntityID);

                    // Show success icon in the label
                    $(Transition.Connection.canvas).append('<div class="Icon Success"></div>').find('.Icon').fadeIn().delay(1000).fadeOut();
                }
            }
            else {
                Core.Exception.Throw('Error: Entity not defined!', 'ProcessError');
            }
        }

        $('#Activities li, #ActivityDialogs li, #Transitions li, #TransitionActions li').draggable({
            revert: 'invalid',
            helper: function () {
                var $Clone = $(this).clone();
                $Clone.addClass('EntityDrag').find('span').remove();
                return $Clone[0];
            },
            start: function (Event, UI) {
                var $Source = $(this),
                    SourceID = $Source.closest('ul').attr('id');

                if (SourceID === 'ActivityDialogs' || SourceID === 'Transitions') {

                    // Set event flag
                    TargetNS.Canvas.DragActivityItem = true;

                    $('#Canvas .Activity').addClass('Highlighted');
                }
                else if (SourceID === 'TransitionActions') {
                    // Set event flag
                    TargetNS.Canvas.DragTransitionAction = true;

                    // Highlight all available Transitions
                    $('.TransitionLabel').addClass('Highlighted');
                }
                else {
                    UI.helper.css('z-index', 1000);
                }
            },
            stop: function (Event, UI) {
                var $Source = $(this),
                    SourceID = $Source.closest('ul').attr('id');

                if (SourceID === 'ActivityDialogs' || SourceID === 'Transitions') {

                    // Reset event flag
                    TargetNS.Canvas.DragActivityItem = false;

                    $('#Canvas .Activity').removeClass('Highlighted');
                }
                else if (SourceID === 'TransitionActions') {
                    // Reset event flag
                    TargetNS.Canvas.DragTransitionAction = false;

                    // Unhighlight all available Transitions
                    $('.TransitionLabel').removeClass('Highlighted');
                }
            }
        });

        $('#Canvas').droppable({
            accept: '#Activities li, #ActivityDialogs li, #Transitions li, #TransitionActions li',
            drop: function (Event, UI) {
                var $Source = $(UI.draggable),
                    SourceID = $Source.closest('ul').attr('id');

                if (SourceID === 'Activities') {
                    AddActivityToCanvas(Event, UI);
                }
                else if (SourceID === 'ActivityDialogs') {
                    AddActivityDialogToCanvas(Event, UI);
                }
                else if (SourceID === 'Transitions') {
                    AddTransitionToCanvas(Event, UI);
                }
                else if (SourceID === 'TransitionActions') {
                    AddTransitionActionToCanvas(Event, UI);
                }
                else {
                    Core.Exception.Throw('Error: No matching droppable found', 'ProcessError');
                }
            }
        });
    };

    TargetNS.UpdateAccordion = function () {
        // get new Accordion HTML via AJAX and replace the accordion with this HTML
        // re-initialize accordion functions (accordion, filters, DnD)
        var Data = {
                Action: 'AdminProcessManagement',
                Subaction: 'UpdateAccordion'
            },
            ActiveElement;

        // get active accordion element to open the same element again after updating
        ActiveElement = $('ul#ProcessElements > li.Active').index();

        // Call the ajax function
        Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {
            $('ul#ProcessElements').replaceWith(Response);

            // Initialize Accordion in the sidebar
            Core.UI.Accordion.Init($('ul#ProcessElements'), 'li.AccordionElement h2 a', 'div.Content');

            // open accordion element again, which was active before the update
            Core.UI.Accordion.OpenElement($('ul#ProcessElements > li:nth-child(' + (parseInt(ActiveElement,10) + 1) + ')'));

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
            InitDeleteEntity();
        }, 'html');
    };

    TargetNS.UpdateSyncMessage = function () {
        // check if there is a 'dirty' sync state and show a message below the header
        var Data = {
                Action: 'AdminProcessManagement',
                Subaction: 'UpdateSyncMessage'
            };

        // Call the ajax function
        Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {

            if (!Response.length) {
                return true;
            }

            if ($('.MessageBox.Notice').length) {
                return true;
            }

            $(Response).insertBefore('div.MainBox');

        }, 'html');
    };

    TargetNS.UpdateScreensPath = function (WindowObject, Callback) {

        // Collect data for update of the screenspath
        var Data = {
                Action: 'AdminProcessManagement',
                Subaction: 'UpdateScreensPath',
                ProcessID: $('input[name=ID]').val(),
                ProcessEntityID: $('#ProcessEntityID').val()
            };

        // Call the ajax function
        Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {
            if (!Response || !Response.Success) {
                if (Response && Response.Message) {
                    alert(Response.Message);
                }
                else {
                    alert ('Error during AJAX communication');
                }
                return;
            }
            else {
                if (typeof Callback !== 'undefined') {
                    Callback(WindowObject);
                }
            }
        }, 'json');
    };

    TargetNS.HandlePopupClose = function () {
        // update accordion
        Core.Agent.Admin.ProcessManagement.UpdateAccordion();
        // redraw canvas
        Core.Agent.Admin.ProcessManagement.Canvas.Redraw();
        // remove overlay
        Core.Agent.Admin.ProcessManagement.HideOverlay();
    };

    TargetNS.InitProcessOverview = function() {

        InitProcessPopups();

        Core.UI.Table.InitTableFilter($('#Filter'), $('#Processes'), 0);
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
        InitDeleteEntity();

        // Initialize DeleteProcess
        $('#ProcessDelete').bind('click.ProcessDelete', function (Event) {
            ShowDeleteProcessConfirmationDialog($(Event.target).closest('a'));
            Event.stopPropagation();
            return false;
        });

        $('#SubmitAndContinue').bind('click', function() {
            $('#ContinueAfterSave').val(1);
            $('#Submit').click();
        });

        // Init submit function
        $('#Submit').bind('click', function (Event) {
            var ProcessEntityID = $('#ProcessEntityID').val(),
                StartActivity;

            // get process layout and store it into a hidden field as JSON string
            $('input[name=ProcessLayout]').val(Core.JSON.Stringify(TargetNS.ProcessLayout));

            // check if there are "open" transitions, e.g. transitions that have only a startpoint but no defined endpoint
            // these open transitions must be deleted before saving
            $.each(TargetNS.ProcessData.Process[ProcessEntityID].Path, function (Activity, ActivityData) {
                $.each(ActivityData, function (Transition, TransitionData) {
                    if (typeof TransitionData.ActivityEntityID === 'undefined') {
                        delete ActivityData[Transition];
                    }
                });
            });

            // get process path and store it into a hidden field as JSON string
            $('input[name=Path]').val(Core.JSON.Stringify(TargetNS.ProcessData.Process[ProcessEntityID].Path));

            // get start activity and dialogs and store it into hidden fields as JSON string
            StartActivity = TargetNS.ProcessData.Process[ProcessEntityID].StartActivity;
            $('input[name=StartActivity]').val(StartActivity);
            $('input[name=StartActivityDialog]').val(TargetNS.ProcessData.Activity[StartActivity].ActivityDialog["1"]);

            $('#ProcessForm').submit();
            return false;
        });

        // Init Canvas Resizing Functions
        $('#ExtendCanvasHeight').bind('click', function () {
            TargetNS.Canvas.Extend({
                Width: 0,
                Height: 150
            });
            return false;
        });

        $('#ExtendCanvasWidth').bind('click', function () {
            TargetNS.Canvas.Extend({
                Width: 150,
                Height: 0
            });
            return false;
        });

        $('#ShowEntityIDs').bind('click', function(Event) {
            if ($(this).hasClass('Visible')) {
                $(this).removeClass('Visible').text(Core.Agent.Admin.ProcessManagement.Localization.ShowEntityIDs);
                $('em.EntityID').remove();
            }
            else {
                $(this).addClass('Visible').text(Core.Agent.Admin.ProcessManagement.Localization.HideEntityIDs);
                TargetNS.Canvas.ShowEntityIDs();
            }
            return false;
        });

        // Init Diagram Canvas
        TargetNS.Canvas.Init();
    };

    TargetNS.InitActivityEdit = function () {
        function InitListFilter(Event, UI) {
         // only do something, if the element was removed from the right list
            if (UI.sender.attr('id') === 'AssignedActivityDialogs') {
                Core.UI.Table.InitTableFilter($('#FilterAvailableActivityDialogs'), $('#AvailableActivityDialogs'));
            }
        }

        // Initialize Allocation List
        Core.UI.AllocationList.Init("#AvailableActivityDialogs, #AssignedActivityDialogs", ".AllocationList", InitListFilter);

        // Initialize list filter
        Core.UI.Table.InitTableFilter($('#FilterAvailableActivityDialogs'), $('#AvailableActivityDialogs'));

        $('#Submit').bind('click', function() {
            $('#ActivityForm').submit();
        });

        Core.Form.Validate.SetSubmitFunction($('#ActivityForm'), function (Form) {

            // get assigned activity dialogs
            $('input[name=ActivityDialogs]').val(Core.JSON.Stringify(Core.UI.AllocationList.GetResult('#AssignedActivityDialogs', 'id')));

            // not needed for normal submit
            $(window).unbind("beforeunload.PMPopup");

            Form.submit();
        });

        // Init popups
        InitProcessPopups();

        // Init handling of closing popup with the OS functionality ("X")
        $(window).unbind("beforeunload.PMPopup").bind("beforeunload.PMPopup", function () {
            window.opener.Core.Agent.Admin.ProcessManagement.HandlePopupClose();
        });

        $('.ClosePopup').bind("click", function () {
            $(window).unbind("beforeunload.PMPopup");
        });
    };

    TargetNS.InitActivityDialogEdit = function () {
        var MandatoryFields = ['Queue', 'State', 'Lock', 'Priority', 'Type', 'CustomerID'],
            FieldsWithoutDefaultValue = ['CustomerID', 'Article'];

        function UpdateFields(Event, UI) {
            var Fieldname,
                DefaultFieldConfig = {};

            // if the element was removed from the AssignedFields list, remove FieldDetails data
            if (UI.sender.attr('id') === 'AssignedFields') {
                Core.UI.Table.InitTableFilter($('#FilterAvailableFields'), $('#AvailableFields'));
                $(UI.item)
                    .removeData('config')
                    .removeAttr('data-config');
            }
            // otherwise, force the user to enter data in the modal dialog
            else {
                Fieldname = $(UI.item).clone().find('span').remove().end().text().trim();

                // if Field is Mandatory set Display to "Show As Mandatory" as default
                if ($.inArray(Fieldname, MandatoryFields) > -1) {
                    DefaultFieldConfig.Display = "2";
                }
                else {
                    DefaultFieldConfig.Display = "1";
                }

                $(UI.item)
                    .data('config', Core.JSON.Stringify(DefaultFieldConfig))
                    .find('.FieldDetailsOverlay').trigger('click');
            }
        }

        // Initialize Allocation List
        Core.UI.AllocationList.Init("#AvailableFields, #AssignedFields", ".AllocationList", UpdateFields);

        // Initialize list filter
        Core.UI.Table.InitTableFilter($('#FilterAvailableFields'), $('#AvailableFields'));

        $('#Submit').bind('click', function() {
            $('#ActivityDialogForm').submit();
            return false;
        });

        Core.Form.Validate.SetSubmitFunction($('#ActivityDialogForm'), function (Form) {
            var FieldConfig = Core.UI.AllocationList.GetResult('#AssignedFields', 'id'),
                FieldDetails = {};

            // get FieldDetails and add them to config
            $('#AssignedFields').find('li').each(function () {
                var Details,
                    ConfigValue = $(this).data('config'),
                    Field = $(this).data('id');

                if (typeof ConfigValue === 'string') {
                    Details = Core.JSON.Parse(ConfigValue);
                }
                else {
                    Details = ConfigValue;
                }

                FieldDetails[Field] = Details;
            });

            // get assigned activity dialogs
            $('input[name=Fields]').val(Core.JSON.Stringify(FieldConfig));
            $('input[name=FieldDetails]').val(Core.JSON.Stringify(FieldDetails));

            // not needed for normal submit
            $(window).unbind("beforeunload.PMPopup");

            Form.submit();
        });

        // Init Fields modal overlay
        $('.FieldDetailsOverlay').unbind('click').bind('click', function () {
            var FieldID = $(this).data('entity'),
                FieldConfig = $(this).closest('li').data('config'),
                $Element = $(this),
                Fieldname = $(this).closest('li').clone().find('span').remove().end().text().trim();

            if (typeof FieldConfig === 'string') {
                FieldConfig = Core.JSON.Parse(FieldConfig);
            }

            // Set field values
            $('#DialogFieldName').text(Fieldname);

            // Open dialog
            Core.UI.Dialog.ShowContentDialog(
                $('#Dialogs #FieldDetails'),
                TargetNS.Localization.DialogTitle,
                '200px',
                'Center',
                true,
                [
                     {
                         Label: TargetNS.Localization.SaveMsg,
                         Class: 'Primary',
                         Function: function () {
                             var FieldConfig = {};

                             FieldConfig.DescriptionShort = $('#DescShort').val();
                             FieldConfig.DescriptionLong = $('#DescLong').val();
                             FieldConfig.DefaultValue = $('#DefaultValue').val();
                             FieldConfig.Display = $('#Display').val();

                             if (Fieldname === 'Article') {
                                 if (typeof FieldConfig.Config === 'undefined'){
                                     FieldConfig.Config = {};
                                 }
                                 FieldConfig.Config.ArticleType = $('#ArticleType').val();

                                 // show error if internal article type is set for an interface different than AgentInterface
                                 if ($('#Interface').val() !== 'AgentInterface' && $('#ArticleType').val().match(/int/i)){
                                     window.alert(Core.Agent.Admin.ProcessManagement.Localization.WrongArticleTypeMsg);
                                     return;
                                 }
                             }

                             $Element.closest('li').data('config', Core.JSON.Stringify(FieldConfig));

                             Core.UI.Dialog.CloseDialog($('.Dialog'));
                         }
                     },
                     {
                         Label: TargetNS.Localization.CancelMsg,
                         Function: function () {
                             Core.UI.Dialog.CloseDialog($('.Dialog'));
                         }
                     }
                ]
            );

            // some fields must be mandatory, if they are present.
            // remove option from dropdown for these fields
            // set "Show As Mandatory" as default
            if ($.inArray(Fieldname, MandatoryFields) > -1) {
                $('#Display')
                    .find('option[value=1]').remove()
                    .end()
                    .val('2');
            }
            // otherwise set "Show Field" as default
            else {
                $('#Display').val('1');
            }

            // fields without default value can not be hidden
            if ($.inArray(Fieldname, FieldsWithoutDefaultValue) > -1 ) {
                $('#Display').find('option[value=0]').remove();
            }

            // if there is a field config already the default settings from above are now overwritten
            if (typeof FieldConfig !== 'undefined') {
                $('#DescShort').val(FieldConfig.DescriptionShort);
                $('#DescLong').val(FieldConfig.DescriptionLong);
                $('#DefaultValue').val(FieldConfig.DefaultValue);

                if (typeof FieldConfig.Display !== 'undefined') {
                    $('#Display').val(FieldConfig.Display);
                }

                if (Fieldname === 'Article') {
                    if (typeof FieldConfig.Config === 'undefined'){
                        FieldConfig.Config = {};
                    }
                    $('#ArticleType').val(FieldConfig.Config.ArticleType);
                }

            }

            // some fields do not have a default value.
            // disable the input field
            if ($.inArray(Fieldname, FieldsWithoutDefaultValue) > -1) {
                $('#DefaultValue').prop('readonly', true).prop('disabled', true);
            }

            // only article should show ArticleType select.
            if (Fieldname === 'Article') {
                $('#ArticleTypeContainer').removeClass('Hidden');
            }
            else {
                $('#ArticleTypeContainer').addClass('Hidden');
            }

            return false;
        });

        InitProcessPopups();

        // Init handling of closing popup with the OS functionality ("X")
        $(window).unbind("beforeunload.PMPopup").bind("beforeunload.PMPopup", function () {
            window.opener.Core.Agent.Admin.ProcessManagement.HandlePopupClose();
        });

        $('.ClosePopup').bind("click", function () {
            $(window).unbind("beforeunload.PMPopup");
        });
    };

    TargetNS.InitTransitionEdit = function () {

        // Init addition of new conditions
        $('#ConditionAdd').bind('click', function() {
            // get current parent index
            var CurrentParentIndex = parseInt($(this).prev('.ConditionField').first().attr('id').replace(/Condition\[/g, '').replace(/\]/g, ''), 10),
                // in case we add a whole new condition, the fieldindex must be 1
                LastKnownFieldIndex = 1,
                // get current index
                ConditionHTML = $('#ConditionContainer').html().replace(/_INDEX_/g, CurrentParentIndex + 1).replace(/_FIELDINDEX_/g, LastKnownFieldIndex);

            $($.parseHTML(ConditionHTML)).insertBefore($('#ConditionAdd'));
            return false;
        });

        // Init removal of conditions
        $('#PresentConditionsContainer').delegate('.ConditionField > .Remove', 'click', function() {
            if ($('#PresentConditionsContainer').find('.ConditionField').length > 1) {

                $(this).parent().prev('label').remove();
                $(this).parent().remove();
            }
            else {
                alert("Sorry, the only existing condition can't be removed.");
            }

            return false;
        });

        // Init addition of new fields within conditions
        $('#PresentConditionsContainer').delegate('.ConditionFieldAdd', 'click', function() {
            // get current parent index
            var CurrentParentIndex = $(this).closest('.ConditionField').attr('id').replace(/Condition\[/g, '').replace(/\]/g, ''),
                // get the index for the newly to be added element
                // therefore, we search the preceding fieldset and the first
                // label in it to get its "for"-attribute which contains the index
                LastKnownFieldIndex = parseInt($(this).prev('fieldset').find('label').attr('for').replace(/ConditionFieldName\[\d+\]\[/, '').replace(/\]/, ''), 10),
                // add new field
                ConditionFieldHTML = $('#ConditionFieldContainer').html().replace(/_INDEX_/g, CurrentParentIndex).replace(/_FIELDINDEX_/g, LastKnownFieldIndex + 1);

            $($.parseHTML(ConditionFieldHTML)).insertBefore($(this));
            return false;
        });

        // Init removal of fields within conditions
        $('.Condition .Field').delegate('.Remove', 'click', function() {
            if ($(this).closest('.Field').find('.Fields').length > 1) {
                $(this).parent().prev('label').remove();
                $(this).parent().remove();
            }
            else {
                alert("Sorry, the only existing field can't be removed.");
            }

            return false;
        });

        $('#Submit').bind('click', function() {
            $('#TransitionForm').submit();
            return false;
        });

        Core.Form.Validate.SetSubmitFunction($('#TransitionForm'), function (Form) {
            var ConditionConfig = TargetNS.GetConditionConfig($('#PresentConditionsContainer').find('.ConditionField'));
            $('input[name=ConditionConfig]').val(Core.JSON.Stringify(ConditionConfig));

            // not needed for normal submit
            $(window).unbind("beforeunload.PMPopup");

            Form.submit();
        });

        // Init handling of closing popup with the OS functionality ("X")
        $(window).unbind("beforeunload.PMPopup").bind("beforeunload.PMPopup", function () {
            window.opener.Core.Agent.Admin.ProcessManagement.HandlePopupClose();
        });

        $('.ClosePopup').bind("click", function () {
            $(window).unbind("beforeunload.PMPopup");
        });

    };

    TargetNS.InitTransitionActionEdit = function () {
        // Init addition of new config parameters
        $('#ConfigAdd').bind('click', function() {
            // get the index for the newly to be added element
            // therefore, we search the preceding fieldset and the first
            // label in it to get its "for"-attribute which contains the index
            var $PreviousField = $(this).prev('fieldset'),
                LastKnownFieldIndex,
                ConfigParamHTML;

            if ($PreviousField.length) {
                LastKnownFieldIndex = parseInt($PreviousField.find('label').attr('for').replace(/ConfigKey\[/, '').replace(/\]/, ''), 10);
            }
            else {
                LastKnownFieldIndex = 0;
            }

            // get current index
            ConfigParamHTML = $('#ConfigParamContainer').html().replace(/_INDEX_/g, LastKnownFieldIndex + 1);

            $($.parseHTML(ConfigParamHTML)).insertBefore($('#ConfigAdd'));
            return false;
        });

        // Init removal of fields
        $('#ConfigParams').delegate('.Remove', 'click', function() {
            $(this).parent().remove();
            return false;
        });

        $('#Submit').bind('click', function() {
            $('#TransitionForm').submit();
            return false;
        });

        Core.Form.Validate.SetSubmitFunction($('#TransitionForm'), function (Form) {
            // not needed for normal submit
            $(window).unbind("beforeunload.PMPopup");

            Form.submit();
        });

        InitProcessPopups();

        // Init handling of closing popup with the OS functionality ("X")
        $(window).unbind("beforeunload.PMPopup").bind("beforeunload.PMPopup", function () {
            window.opener.Core.Agent.Admin.ProcessManagement.HandlePopupClose();
        });

        $('.ClosePopup').bind("click", function () {
            $(window).unbind("beforeunload.PMPopup");
        });
    };

    TargetNS.InitPathEdit = function () {
        var CurrentProcessEntityID = Core.Config.Get('Config.ProcessEntityID'),
            CurrentTransitionEntityID = Core.Config.Get('Config.TransitionEntityID'),
            StartActivityID = Core.Config.Get('Config.StartActivityID'),
            ActivityInfo = window.opener.Core.Agent.Admin.ProcessManagement.ProcessData.Activity,
            PathInfo = window.opener.Core.Agent.Admin.ProcessManagement.ProcessData.Process[CurrentProcessEntityID].Path,
            StartActivityEntityID = '', EndActivityEntityID = '',
            AssignedTransitionActions = [];

        // Initialize Allocation List
        Core.UI.AllocationList.Init("#AvailableTransitionActions, #AssignedTransitionActions", ".AllocationList");

        // Initialize list filter
        Core.UI.Table.InitTableFilter($('#FilterAvailableTransitionActions'), $('#AvailableTransitionActions'));

        // store process data to hidden field for later merging
        $('#ProcessData').val(Core.JSON.Stringify(window.opener.Core.Agent.Admin.ProcessManagement.ProcessData.Process));

        // set current start and end activity (just for information purposes, not changeable)
        $.each(PathInfo, function(Activity, Transition) {
            if (Activity === StartActivityID && typeof Transition[CurrentTransitionEntityID] !== 'undefined') {
                $('#StartActivity').text(ActivityInfo[Activity].Name);
                $('#EndActivity').text(ActivityInfo[Transition[CurrentTransitionEntityID].ActivityEntityID].Name);

                StartActivityEntityID     = Activity;
                EndActivityEntityID       = Transition[CurrentTransitionEntityID].ActivityEntityID;
                AssignedTransitionActions = Transition[CurrentTransitionEntityID].TransitionAction;

                return false;
            }
        });

        // Set chosen Startactivity, Endactivity and Transition
        $('#Transition').val(CurrentTransitionEntityID);
        $('#EditPath a').data('entity', CurrentTransitionEntityID);

        if (AssignedTransitionActions && AssignedTransitionActions.length) {
            // Display assigned Transition Actions
            $.each(AssignedTransitionActions, function(Index, TransitionActionEntityID) {
                $('#AvailableTransitionActions').find('#' + TransitionActionEntityID).remove().appendTo($('#AssignedTransitionActions'));
            });
        }

        // if transition select is updated, also update transition edit link
        $('#Transition').bind('change', function () {
           $('#EditPath a').data('entity', $(this).val());
        });

        $('#Submit').bind('click', function() {
            $('#PathForm').submit();
            return false;
        });

        // init submit
        Core.Form.Validate.SetSubmitFunction($('#PathForm'), function (Form) {

            var NewTransitionEntityID = $('#Transition').val(),
                NewTransitionActions  = [],
                TransitionInfo;

            $('#AssignedTransitionActions li').each(function() {
                NewTransitionActions.push($(this).attr('id'));
            });

            // collection transition info for later merging
            TransitionInfo = {
                StartActivityEntityID  : StartActivityEntityID,
                NewTransitionEntityID  : NewTransitionEntityID,
                NewTransitionActions   : NewTransitionActions,
                NewTransitionActivityID: EndActivityEntityID
            };

            $('#TransitionInfo').val(Core.JSON.Stringify(TransitionInfo));

            // not needed for normal submit
            $(window).unbind("beforeunload.PMPopup");

            Form.submit();
        });

        // Init popups
        InitProcessPopups();

        // Init handling of closing popup with the OS functionality ("X")
        $(window).unbind("beforeunload.PMPopup").bind("beforeunload.PMPopup", function () {
            window.opener.Core.Agent.Admin.ProcessManagement.HandlePopupClose();
        });

        $('.ClosePopup').bind("click", function () {
            $(window).unbind("beforeunload.PMPopup");
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

    TargetNS.GetConditionConfig = function ($Conditions) {

        if (!$Conditions.length) {
            return {};
        }

        var Conditions = {},
            ConditionKey;

        $Conditions.each(function() {

            // get condition key
            ConditionKey = $(this).attr('id').replace(/(Condition\[|\])/g, '');

            // use condition key as key for our list
            Conditions[ConditionKey] = {
                Type: $(this).find('.Field > select').val(),
                Fields: {}
            };

            // get all fields of the current condition
            $(this).find('fieldset.Fields').each(function() {

                var FieldKey = $(this).find('label').attr('for').replace(/(ConditionFieldName\[\d+\]\[|\])/g, '');
                Conditions[ConditionKey].Fields[$(this).find('input').first().val()] = {
                    Type  : $(this).find('select').val(),
                    Match : $(this).find('input').last().val()
                };
            });

        });

        return Conditions;
    };

    TargetNS.UpdateConfig = function (Config) {
        if (typeof Config === 'undefined') {
            return false;
        }

        // Update config from e.g. popup windows

        // Update Process
        if (typeof Config.Process !== 'undefined') {
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
