// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

/*eslint-disable no-window*/

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};
Core.Agent.Admin = Core.Agent.Admin || {};

/**
 * @namespace Core.Agent.Admin.ProcessManagement
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the ProcessManagement module.
 */
Core.Agent.Admin.ProcessManagement = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Admin.ProcessManagement
     * @function
     * @description
     *      This function initializes the module functionality.
     */
    TargetNS.Init = function () {
        var Subaction = Core.Config.Get('Subaction');

        // Initialize Popup
        InitProcessPopups();

        // Initialize Popup response (Redirect and close Popup)
        InitProcessPopupsResponse();

        // Initialize table filter
        Core.UI.Table.InitTableFilter($('#Filter'), $('#Processes'), 0);

        // Depending on Subaction initialize specific functions
        if (Subaction === 'ActivityNew' ||
            Subaction === 'ActivityNewAction' ||
            Subaction === 'ActivityEdit' ||
            Subaction === 'ActivityEditAction') {
            TargetNS.InitActivityEdit();
        }
        else if (Subaction === 'ActivityDialogNew' ||
            Subaction === 'ActivityDialogNewAction' ||
            Subaction === 'ActivityDialogEdit' ||
            Subaction === 'ActivityDialogEditAction') {
            TargetNS.InitActivityDialogEdit();
        }
        else if (Subaction === 'TransitionNew' ||
            Subaction === 'TransitionNewAction' ||
            Subaction === 'TransitionEdit' ||
            Subaction === 'TransitionEditAction') {
            TargetNS.InitTransitionEdit();
        }
        else if (Subaction === 'TransitionActionNew' ||
            Subaction === 'TransitionActionNewAction' ||
            Subaction === 'TransitionActionEdit' ||
            Subaction === 'TransitionActionEditAction') {
            TargetNS.InitTransitionActionEdit();
        }
        else if (Subaction === 'ProcessEdit' ||
            Subaction === 'ProcessEditAction') {
            TargetNS.InitProcessEdit();
        }
        else if (Subaction === 'ProcessPrint') {
            $('.ProcessPrint').on('click', function() {
                window.print();
                return false;
            });
        }

        // Depending on Action initialize specific functions
        if (Core.Config.Get('Action') === 'AdminProcessManagementPath' && Subaction !== 'ClosePopup') {
           TargetNS.InitPathEdit();
        }
    };

    /**
     * @private
     * @name InitProcessPopups
     * @memberof Core.Agent.Admin.ProcessManagement
     * @function
     * @description
     *      Initializes needed popup handler.
     */
    function InitProcessPopups() {
        $('a.AsPopup').on('click', function () {
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

        $('a.AsPopup_Redirect').on('click', function () {
            var $Form = $(this).closest('form');

            $('#PopupRedirect').val(1);
            $('#PopupRedirectAction').val($(this).data('action'));
            $('#PopupRedirectSubaction').val($(this).data('subaction'));
            $('#PopupRedirectID').val($(this).data('id'));
            $('#PopupRedirectEntityID').val($(this).data('entity'));
            // Only used for path popup
            $('#PopupRedirectStartActivityID').val($(this).data('startactivityid'));

            if ($(this).hasClass('Edit_Confirm')) {
                if (window.confirm(Core.Language.Translate('As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?'))) {
                    // Remove onbeforeunload event only if there is no validation pending on form submit
                    if (!($Form.hasClass("Validate"))) {
                        $(window).off("beforeunload.PMPopup");
                    }
                    $(this).closest('form').submit();
                }
            }
            else {
                // Remove onbeforeunload event only if there is no validation pending on form submit
                if (!($Form.hasClass("Validate"))) {
                    $(window).off("beforeunload.PMPopup");
                }
                $(this).closest('form').submit();
            }
            return false;
        });

        $('a.GoBack').on('click', function () {
            // Remove onbeforeunload event (which is only needed if you close the popup via the window "X")
            $(window).off("beforeunload.PMPopup");
        });
    }

    /**
     * @private
     * @name InitProcessPopupsResponse
     * @memberof Core.Agent.Admin.ProcessManagement
     * @function
     * @description
     *      Initializes redirect and close popups response.
     */
    function InitProcessPopupsResponse() {
        var Redirect = Core.Config.Get('Redirect'),
            ClosePopup = Core.Config.Get('ClosePopup'),
            Data;

        if (typeof Redirect !== 'undefined') {

            Data = {
                Action: Redirect.Action,
                Subaction: Redirect.Subaction,
                ID: Redirect.ID,
                EntityID: Redirect.EntityID,
                Field: Redirect.Field,
                StartActivityID: Redirect.StartActivityID
            };

            // send results to main window
            window.opener.Core.Agent.Admin.ProcessManagement.UpdateConfig(Redirect.ConfigJSON);

            // reload popup
            Core.App.InternalRedirect(Data);
        }
        else if (typeof ClosePopup !== 'undefined') {

            window.opener.Core.Agent.Admin.ProcessManagement.UpdateScreensPath(window, function (WindowObject) {
                //send results to main window
                WindowObject.opener.Core.Agent.Admin.ProcessManagement.UpdateConfig(ClosePopup.ConfigJSON);

                // update accordion
                WindowObject.opener.Core.Agent.Admin.ProcessManagement.UpdateAccordion();

                // update sync message
                WindowObject.opener.Core.Agent.Admin.ProcessManagement.UpdateSyncMessage();

                // redraw canvas
                WindowObject.opener.Core.Agent.Admin.ProcessManagement.Canvas.Redraw();

                // remove overlay
                WindowObject.opener.Core.Agent.Admin.ProcessManagement.HideOverlay();

                // remove onbeforeunload event (which is only needed if you close the popup via the window "X")
                $(WindowObject).off("beforeunload.PMPopup");

                // close popup
                WindowObject.close();
            });
        }
    }

    /**
     * @private
     * @name ShowDeleteProcessConfirmationDialog
     * @memberof Core.Agent.Admin.ProcessManagement
     * @function
     * @param {jQueryObject} $Element
     * @description
     *      Shows a confirmation dialog to delete processes.
     */
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
                   Label: Core.Language.Translate('Cancel'),
                   Function: function () {
                       Core.UI.Dialog.CloseDialog($('.Dialog'));
                   }
               },
               {
                   Label: Core.Language.Translate('Delete'),
                   Class: 'Primary',
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
                               return false;
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

    /**
     * @private
     * @name ShowDeleteEntityConfirmationDialog
     * @memberof Core.Agent.Admin.ProcessManagement
     * @function
     * @param {jQueryObject} $Element
     * @param {String} EntityType
     * @param {String} EntityName
     * @param {String} EntityID
     * @param {String} ItemID
     * @description
     *      Shows a confirmation dialog to delete entities.
     */
    function ShowDeleteEntityConfirmationDialog($Element, EntityType, EntityName, EntityID, ItemID) {
        var DialogID = 'Delete' + EntityType + 'ConfirmationDialog',
            $DialogElement = $('#Dialogs #' + DialogID);

        // Update EntityName in Dialog
        $DialogElement.find('span.EntityName').text(EntityName);

        Core.UI.Dialog.ShowContentDialog(
            $('#Dialogs #' + DialogID),
            Core.Language.Translate('Delete Entity'),
            '240px',
            'Center',
            true,
            [
               {
                   Label: Core.Language.Translate('Cancel'),
                   Function: function () {
                       Core.UI.Dialog.CloseDialog($('.Dialog'));
                   }
               },
               {
                   Label: Core.Language.Translate('Delete'),
                   Class: 'Primary',
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
                               return false;
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

    /**
     * @private
     * @name InitDeleteEntity
     * @memberof Core.Agent.Admin.ProcessManagement
     * @function
     * @description
     *      Initializes the event handler to delete entities.
     */
    function InitDeleteEntity() {
        $('a.DeleteEntity').on('click.DeleteEntity', function () {
            var EntityID = $(this).closest('li').data('entity'),
                EntityName = $(this).closest('li').clone().children().remove().end().text(),
                ItemID = $(this).closest('li').data('id'),
                EntityType;

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

    /**
     * @name ProcessData
     * @memberof Core.Agent.Admin.ProcessManagement
     * @member {Object}
     * @description
     *     Structure to save all process data.
     */
    TargetNS.ProcessData = {};

    /**
     * @name ProcessLayout
     * @memberof Core.Agent.Admin.ProcessManagement
     * @member {Object}
     * @description
     *     Structure to save all layout data for the process.
     */
    TargetNS.ProcessLayout = {};

    /**
     * @name InitAccordionDnD
     * @memberof Core.Agent.Admin.ProcessManagement
     * @function
     * @description
     *      Initializes all event handler to drag and drop elements from the accordion to the canvas.
     */
    TargetNS.InitAccordionDnD = function () {
      /**
       * @private
       * @name GetMousePosition
       * @memberof Core.Agent.Admin.ProcessManagement.InitAccordionDND
       * @function
       * @returns {Object} Mouse position.
       * @param {Object} Event - The event object.
       * @description
       *      Calculates mouse position.
       */
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

      /**
       * @private
       * @name GetPositionOnCanvas
       * @memberof Core.Agent.Admin.ProcessManagement.InitAccordionDND
       * @function
       * @returns {Object} Position of mouse on canvas.
       * @param {Object} Event - The event object.
       * @description
       *      Calculates mouse position relative to canvas object.
       */
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

      /**
       * @private
       * @name AddActivityToCanvas
       * @memberof Core.Agent.Admin.ProcessManagement.InitAccordionDND
       * @function
       * @param {Object} Event - The event object.
       * @param {Object} UI - jQuery UI object.
       * @description
       *      Adds activity to the canvas after drop event.
       */
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
                    alert(Core.Language.Translate('This Activity is already used in the Process. You cannot add it twice!'));
                }
            }
            else {
                Core.Exception.Throw('Error: Entity not defined!', 'ProcessError');
            }
        }

      /**
       * @private
       * @name CheckIfMousePositionIsOverActivity
       * @memberof Core.Agent.Admin.ProcessManagement.InitAccordionDND
       * @function
       * @returns {String|Boolean} Returns ID of activity or false, if mouse is not over an activity.
       * @param {Object} Position - A mouse position object.
       * @description
       *      Checks if mouse position is over an activity (e.g. to drop activity dialogs to an activity).
       */
        function CheckIfMousePositionIsOverActivity(Position) {
            var ProcessEntityID = $('#ProcessEntityID').val(),
                Path = TargetNS.ProcessData.Process[ProcessEntityID].Path,
                ActivityMatch = false;

            // Loop over all assigned activities and check the position
            $.each(Path, function (Key) {
                var ActivityPosition = TargetNS.ProcessLayout[Key];
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

      /**
       * @private
       * @name AddActivityDialogToCanvas
       * @memberof Core.Agent.Admin.ProcessManagement.InitAccordionDND
       * @function
       * @param {Object} Event - The event object.
       * @param {Object} UI - jQuery UI object.
       * @description
       *      Adds activity dialog to the canvas after drop event.
       */
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
                                alert(Core.Language.Translate('Error during AJAX communication'));
                            }

                            TargetNS.Canvas.ShowActivityAddActivityDialogError(Activity);
                            return false;
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

      /**
       * @private
       * @name DummyActivityConnected
       * @memberof Core.Agent.Admin.ProcessManagement.InitAccordionDND
       * @function
       * @returns {Boolean} True if a dummy endpoint was found, false otherwise.
       * @param {String} ProcessEntityID - The process ID.
       * @description
       *      Check if any transition has a dummy endpoint.
       */
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

      /**
       * @private
       * @name AddTransitionToCanvas
       * @memberof Core.Agent.Admin.ProcessManagement.InitAccordionDND
       * @function
       * @returns {Boolean} False if a another unconnected transition is on the canvas
       * @param {Object} Event - The event object.
       * @param {Object} UI - jQuery UI object.
       * @description
       *      Adds transition to the canvas after drop event.
       */
        function AddTransitionToCanvas(Event, UI) {
            var Position = GetPositionOnCanvas(Event),
                EntityID = $(UI.draggable).data('entity'),
                Entity = TargetNS.ProcessData.Transition[EntityID],
                ProcessEntityID = $('#ProcessEntityID').val(),
                Activity,
                Path = TargetNS.ProcessData.Process[ProcessEntityID].Path;

            // if a dummy activity exists, another transition was placed to the canvas but not yet
            // connected to an end point. One cannot place two unconnected transitions on the canvas.
            if ($('#Dummy').length && DummyActivityConnected(ProcessEntityID)) {
              alert(Core.Language.Translate('An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.'));
              return false;
            }

            if (typeof Entity !== 'undefined') {
                // Check if mouse position is within an activity
                // If yes, add the Dialog to the Activity
                // if not, just cancel
                Activity = CheckIfMousePositionIsOverActivity(Position);

                // If this transition is already bind to this activity
                // you cannot bind it a second time
                if (Path[Activity] && typeof Path[Activity][EntityID] !== 'undefined') {
                    alert(Core.Language.Translate('This Transition is already used for this Activity. You cannot use it twice!'));
                    return false;
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

      /**
       * @private
       * @name AddTransitionActionToCanvas
       * @memberof Core.Agent.Admin.ProcessManagement.InitAccordionDND
       * @function
       * @returns {Boolean} Returns false, if transition is not defined.
       * @param {Object} Event - The event object.
       * @param {Object} UI - jQuery UI object.
       * @description
       *      Adds transition action to the canvas after drop event.
       */
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
                    alert(Core.Language.Translate('This TransitionAction is already used in this Path. You cannot use it twice!'));
                    return false;
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

        $('#Activities li.OneRow, #ActivityDialogs li.OneRow, #Transitions li.OneRow, #TransitionActions li.OneRow').draggable({
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
            stop: function () {
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
            accept: '#Activities li.OneRow, #ActivityDialogs li.OneRow, #Transitions li.OneRow, #TransitionActions li.OneRow',
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

    /**
     * @name UpdateAccordion
     * @memberof Core.Agent.Admin.ProcessManagement
     * @function
     * @description
     *      Update accordion data from server.
     */
    TargetNS.UpdateAccordion = function () {
        // get new Accordion HTML via AJAX and replace the accordion with this HTML
        // re-initialize accordion functions (accordion, filters, DnD)
        var Data = {
                Action: 'AdminProcessManagement',
                Subaction: 'UpdateAccordion'
            },
            ActiveElementIndex = parseInt($('ul#ProcessElements > li.Active').index(), 10),
            ActiveElementValue = $('ul#ProcessElements > li:eq(' + ActiveElementIndex + ') .ProcessElementFilter').val();

        // Call the ajax function
        Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {
            $('ul#ProcessElements').replaceWith(Response);

            // Initialize Accordion in the sidebar
            Core.UI.Accordion.Init($('ul#ProcessElements'), 'li.AccordionElement h2 a', 'div.Content');

            // Open accordion element again, which was active before the update.
            Core.UI.Accordion.OpenElement($('ul#ProcessElements > li:eq(' + ActiveElementIndex + ')'));

            // Initialize filters
            Core.UI.Table.InitTableFilter($('#ActivityFilter'), $('#Activities'));
            Core.UI.Table.InitTableFilter($('#ActivityDialogFilter'), $('#ActivityDialogs'));
            Core.UI.Table.InitTableFilter($('#TransitionFilter'), $('#Transitions'));
            Core.UI.Table.InitTableFilter($('#TransitionActionFilter'), $('#TransitionActions'));

            // Set previous value and filter.
            $('ul#ProcessElements > li:eq(' + ActiveElementIndex + ') .ProcessElementFilter').trigger('keydown').val(ActiveElementValue);

            // Init DnD on Accordion
            TargetNS.InitAccordionDnD();

            // Initialize the different create and edit links/buttons
            InitProcessPopups();

            // Initialize the different Delete Links
            InitDeleteEntity();
        }, 'html');
    };

    /**
     * @name UpdateSyncMessage
     * @memberof Core.Agent.Admin.ProcessManagement
     * @function
     * @description
     *      Check if there is a 'dirty' sync state and show a message below the header.
     */
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

    /**
     * @name UpdateScreensPath
     * @memberof Core.Agent.Admin.ProcessManagement
     * @function
     * @param {Object} WindowObject
     * @param {Function} Callback
     * @description
     *      Updates screen path.
     */
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
                    alert(Core.Language.Translate('Error during AJAX communication'));
                }
                return false;
            }
            else {
                if (typeof Callback !== 'undefined') {
                    Callback(WindowObject);
                }
            }
        }, 'json');
    };

    /**
     * @name HandlePopupClose
     * @memberof Core.Agent.Admin.ProcessManagement
     * @function
     * @description
     *      Close overlay and re-initialize canvas and accordion.
     */
    TargetNS.HandlePopupClose = function () {
        // update accordion
        Core.Agent.Admin.ProcessManagement.UpdateAccordion();
        // redraw canvas
        Core.Agent.Admin.ProcessManagement.Canvas.Redraw();
        // remove overlay
        Core.Agent.Admin.ProcessManagement.HideOverlay();
    };

    /**
     * @name InitProcessEdit
     * @memberof Core.Agent.Admin.ProcessManagement
     * @function
     * @description
     *      Initialize process edit screen.
     */
    TargetNS.InitProcessEdit = function () {
      var ConfigProcess = Core.Config.Get('ConfigProcess');

        // Get Process Data
        TargetNS.ProcessData = {
            Process: ConfigProcess.Process,
            Activity: ConfigProcess.Activity,
            ActivityDialog: ConfigProcess.ActivityDialog,
            Transition: ConfigProcess.Transition,
            TransitionAction: ConfigProcess.TransitionAction
        };

        TargetNS.ProcessLayout = ConfigProcess.ProcessLayout;

        // Initialize Accordion in the sidebar
        Core.UI.Accordion.Init($('ul#ProcessElements'), 'li.AccordionElement h2 a', 'div.Content');

        // Initialize filters
        Core.UI.Table.InitTableFilter($('#ActivityFilter'), $('#Activities'));
        Core.UI.Table.InitTableFilter($('#ActivityDialogFilter'), $('#ActivityDialogs'));
        Core.UI.Table.InitTableFilter($('#TransitionFilter'), $('#Transitions'));
        Core.UI.Table.InitTableFilter($('#TransitionActionFilter'), $('#TransitionActions'));

        // Init DnD on Accordion
        TargetNS.InitAccordionDnD();

        // Initialize the different Delete Links
        InitDeleteEntity();

        // Initialize DeleteProcess
        $('#ProcessDelete').on('click.ProcessDelete', function (Event) {
            ShowDeleteProcessConfirmationDialog($(Event.target).closest('a'));
            Event.stopPropagation();
            return false;
        });

        // Init submit function
        $('#Submit').on('click', function () {
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
            if (StartActivity !== '') {
                $('input[name=StartActivity]').val(StartActivity);
                $('input[name=StartActivityDialog]').val(TargetNS.ProcessData.Activity[StartActivity].ActivityDialog["1"]);
            }
            $('#ProcessForm').submit();
            return false;
        });

        // Init Canvas Resizing Functions
        $('#ExtendCanvasHeight').on('click', function () {
            TargetNS.Canvas.Extend({
                Width: 0,
                Height: 150
            });
            return false;
        });

        $('#ExtendCanvasWidth').on('click', function () {
            TargetNS.Canvas.Extend({
                Width: 150,
                Height: 0
            });
            return false;
        });

        $('#ShowEntityIDs').on('click', function() {
            if ($(this).hasClass('Visible')) {
                $(this).removeClass('Visible').text(Core.Language.Translate('Show EntityIDs'));
                $('em.EntityID').remove();
            }
            else {
                $(this).addClass('Visible').text(Core.Language.Translate('Hide EntityIDs'));
                TargetNS.Canvas.ShowEntityIDs();
            }
            return false;
        });

        // Init Diagram Canvas
        TargetNS.Canvas.Init();
    };

    /**
     * @name InitActivityEdit
     * @memberof Core.Agent.Admin.ProcessManagement
     * @function
     * @description
     *      Initialize activity edit screen.
     */
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

        $('#Submit').on('click', function() {
            $('#ActivityForm').submit();
        });

        Core.Form.Validate.SetSubmitFunction($('#ActivityForm'), function (Form) {

            // get assigned activity dialogs
            $('input[name=ActivityDialogs]').val(Core.JSON.Stringify(Core.UI.AllocationList.GetResult('#AssignedActivityDialogs', 'id')));

            // not needed for normal submit
            $(window).off("beforeunload.PMPopup");

            Form.submit();
        });

        // Init handling of closing popup with the OS functionality ("X")
        $(window).off("beforeunload.PMPopup").on("beforeunload.PMPopup", function () {
            window.opener.Core.Agent.Admin.ProcessManagement.HandlePopupClose();
        });

        $('.ClosePopup').on("click", function () {
            $(window).off("beforeunload.PMPopup");
        });
    };

    /**
     * @name InitActivityDialogEdit
     * @memberof Core.Agent.Admin.ProcessManagement
     * @function
     * @description
     *      Initialize activity dialog edit screen.
     */
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
                Fieldname = $.trim($(UI.item).data('id'));

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

        $('#Submit').on('click', function() {
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
            $(window).off("beforeunload.PMPopup");

            Form.submit();
        });

        // Init Fields modal overlay
        $('.FieldDetailsOverlay').off('click').on('click', function () {
            var FieldConfig = $(this).closest('li').data('config'),
                $Element = $(this),
                Fieldname = $.trim($(this).closest('li').data('id')),
                FieldNameTranslated = $('.AllocationList').find('li[data-id="' + Fieldname + '"]').data('name-translated');

            if (typeof FieldConfig === 'string') {
                FieldConfig = Core.JSON.Parse(FieldConfig);
            }

            // Open dialog
            Core.UI.Dialog.ShowContentDialog(
                $('#Dialogs #FieldDetails'),
                Core.Language.Translate('Edit Field Details') + ': ' + FieldNameTranslated,
                '200px',
                'Center',
                true,
                [
                     {
                         Label: Core.Language.Translate('Save'),
                         Class: 'Primary',
                         Function: function () {
                             var FieldConfigElement = {};

                             FieldConfigElement.DescriptionShort = $('#DescShort').val();
                             FieldConfigElement.DescriptionLong = $('#DescLong').val();
                             FieldConfigElement.DefaultValue = $('#DefaultValue').val();
                             FieldConfigElement.Display = $('#Display').val();

                             if (Fieldname === 'Article') {
                                 if (typeof FieldConfigElement.Config === 'undefined'){
                                     FieldConfigElement.Config = {};
                                 }
                                 FieldConfigElement.Config.CommunicationChannel = $('#CommunicationChannel').val();

                                 FieldConfigElement.Config.IsVisibleForCustomer = '0';
                                 if ($('#IsVisibleForCustomer').prop('checked')) {
                                    FieldConfigElement.Config.IsVisibleForCustomer = '1';
                                 }

                                 // show error if not customer visible article is set for an interface different than AgentInterface
                                 if ($('#Interface').val() !== 'AgentInterface' && !$('#IsVisibleForCustomer').prop('checked')){
                                     window.alert(Core.Language.Translate('Customer interface does not support articles not visible for customers.'));
                                     return false;
                                 }

                                 // add the time units value to the fieldconfig
                                 FieldConfigElement.Config.TimeUnits = $('#TimeUnits').val();
                             }

                             $Element.closest('li').data('config', Core.JSON.Stringify(FieldConfigElement));

                             Core.UI.Dialog.CloseDialog($('.Dialog'));
                         }
                     },
                     {
                         Label: Core.Language.Translate('Cancel'),
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
            if ($.inArray(Fieldname, FieldsWithoutDefaultValue) > -1) {
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
                    if (FieldConfig.Config.CommunicationChannel) {
                        $('#CommunicationChannel').val(FieldConfig.Config.CommunicationChannel);
                    }
                    if (FieldConfig.Config.IsVisibleForCustomer === '1') {
                        $('#IsVisibleForCustomer').prop("checked", true);
                    }
                    if (FieldConfig.Config.TimeUnits) {
                        $('#TimeUnits').val(FieldConfig.Config.TimeUnits);
                    }
                }
            }

            // redraw display field
            $('#Display').trigger('redraw.InputField');

            // some fields do not have a default value.
            // disable the input field
            if ($.inArray(Fieldname, FieldsWithoutDefaultValue) > -1) {
                $('#DefaultValue').prop('readonly', true).prop('disabled', true);
            }

            // only article should show Communication channel select.
            if (Fieldname === 'Article') {

                $('#CommunicationChannelContainer').removeClass('Hidden');
                $('#CommunicationChannelContainer').prev('label').css('display', 'block');
                $('#CommunicationChannelContainer .Modernize').trigger('redraw.InputField');

                $('#IsVisibleForCustomerContainer').removeClass('Hidden');
                $('#IsVisibleForCustomerContainer').prev('label').css('display', 'block');

                $('#TimeUnitsContainer').removeClass('Hidden');
                $('#TimeUnitsContainer').prev('label').css('display', 'block');
                $('#TimeUnitsContainer .Modernize').trigger('redraw.InputField');
            }
            else {

                $('#CommunicationChannelContainer').addClass('Hidden');
                $('#CommunicationChannelContainer').prev('label').css('display', 'none');

                $('#IsVisibleForCustomerContainer').addClass('Hidden');
                $('#IsVisibleForCustomerContainer').prev('label').css('display', 'none');

                $('#TimeUnitsContainer').addClass('Hidden');
                $('#TimeUnitsContainer').prev('label').css('display', 'none');
            }

            return false;
        });

        // Init handling of closing popup with the OS functionality ("X")
        $(window).off("beforeunload.PMPopup").on("beforeunload.PMPopup", function () {
            window.opener.Core.Agent.Admin.ProcessManagement.HandlePopupClose();
        });

        $('.ClosePopup').on("click", function () {
            $(window).off("beforeunload.PMPopup");
        });
    };

    /**
     * @name InitTransitionEdit
     * @memberof Core.Agent.Admin.ProcessManagement
     * @function
     * @description
     *      Initialize transition edit screen.
     */
    TargetNS.InitTransitionEdit = function () {

        // Init addition of new conditions
        $('#ConditionAdd').on('click', function() {
            // get current parent index
            var CurrentParentIndex = parseInt($(this).prev('.WidgetSimple').first().attr('id').replace(/Condition\[/g, '').replace(/\]/g, ''), 10),
                // in case we add a whole new condition, the fieldindex must be 1
                LastKnownFieldIndex = 1,
                // get current index
                ConditionHTML = $('#ConditionContainer').html().replace(/_INDEX_/g, CurrentParentIndex + 1).replace(/_FIELDINDEX_/g, LastKnownFieldIndex);

            $($.parseHTML(ConditionHTML)).insertBefore($('#ConditionAdd'));
            Core.UI.InputFields.Init();
            return false;
        });

        // Init removal of conditions
        $('#PresentConditionsContainer').delegate('.ParentWidget > .Header .RemoveButton', 'click', function() {
            if ($('#PresentConditionsContainer').find('.ConditionField').length > 1) {

                $(this).closest('.WidgetSimple').remove();
            }
            else {
                alert(Core.Language.Translate("Sorry, the only existing condition can't be removed."));
            }

            return false;
        });

        // Init addition of new fields within conditions
        $('#PresentConditionsContainer').off('click.AddField').on('click.AddField', '.FieldWidget .AddButton', function() {
            // get current parent index
            var CurrentParentIndex = $(this).closest('.ParentWidget').attr('id').replace(/Condition\[/g, '').replace(/\]/g, ''),
                // get the index for the newly to be added element
                // therefore, we search the preceding fieldset and the first
                // label in it to get its "for"-attribute which contains the index
                LastKnownFieldIndex = parseInt($(this).closest('.WidgetSimple').find('.Content').find('label').first().attr('for').replace(/ConditionFieldName\[\d+\]\[/, '').replace(/\]/, ''), 10),
                // add new field
                ConditionFieldHTML = $('#ConditionFieldContainer').html().replace(/_INDEX_/g, CurrentParentIndex).replace(/_FIELDINDEX_/g, LastKnownFieldIndex + 1);

            $($.parseHTML(ConditionFieldHTML)).insertAfter($(this).closest('.WidgetSimple').find('fieldset').last());
            Core.UI.InputFields.Init();
            return false;
        });

        // Init removal of fields within conditions
        $('#PresentConditionsContainer').off('click.RemoveField').on('click.RemoveField', '.FieldWidget .RemoveButton', function() {
            if ($(this).closest('.Content').find('fieldset').length > 1) {
                $(this).parent().closest('fieldset').remove();
            }
            else {
                alert(Core.Language.Translate("Sorry, the only existing field can't be removed."));
            }

            return false;
        });

        $('#Submit').on('click', function() {
            $('#TransitionForm').submit();
            return false;
        });

        Core.Form.Validate.SetSubmitFunction($('#TransitionForm'), function (Form) {
            var ConditionConfig = TargetNS.GetConditionConfig($('#PresentConditionsContainer').find('.ConditionField'));
            $('input[name=ConditionConfig]').val(Core.JSON.Stringify(ConditionConfig));

            // not needed for normal submit
            $(window).off("beforeunload.PMPopup");

            Form.submit();
        });

        // Init handling of closing popup with the OS functionality ("X")
        $(window).off("beforeunload.PMPopup").on("beforeunload.PMPopup", function () {
            window.opener.Core.Agent.Admin.ProcessManagement.HandlePopupClose();
        });

        $('.ClosePopup').on("click", function () {
            $(window).off("beforeunload.PMPopup");
        });

        Core.UI.InputFields.Init();

    };

    /**
     * @name InitTransitionActionEdit
     * @memberof Core.Agent.Admin.ProcessManagement
     * @function
     * @description
     *      Initialize transition action edit screen.
     */
    TargetNS.InitTransitionActionEdit = function () {
        // Init addition of new config parameters
        $('#ConfigAdd').on('click', function() {
            // get the index for the newly to be added element
            // therefore, we search the preceding fieldset and the first
            // label in it to get its "for"-attribute which contains the index
            var $PreviousField = $(this).closest('.WidgetSimple').find('.Content fieldset').last(),
                LastKnownFieldIndex,
                ConfigParamHTML;

            if ($PreviousField.length) {
                LastKnownFieldIndex = parseInt($PreviousField.find('label').first().attr('for').replace(/ConfigKey\[/, '').replace(/\]/, ''), 10);
            }
            else {
                LastKnownFieldIndex = 0;
            }

            // get current index
            ConfigParamHTML = $('#ConfigParamContainer').html().replace(/_INDEX_/g, LastKnownFieldIndex + 1);

            $($.parseHTML(ConfigParamHTML)).insertAfter($PreviousField);
            return false;
        });

        // Init removal of fields
        $('#ConfigParams').delegate('.RemoveButton', 'click', function() {
            if ($(this).closest('.Content').find('fieldset').length > 1) {
                $(this).closest('fieldset').remove();
            }
            else {
                alert(Core.Language.Translate("Sorry, the only existing parameter can't be removed."));
            }
            return false;
        });

        $('#Submit').on('click', function() {
            $('#TransitionForm').submit();
            return false;
        });

        Core.Form.Validate.SetSubmitFunction($('#TransitionForm'), function (Form) {
            // not needed for normal submit
            $(window).off("beforeunload.PMPopup");

            Form.submit();
        });

        // Init handling of closing popup with the OS functionality ("X")
        $(window).off("beforeunload.PMPopup").on("beforeunload.PMPopup", function () {
            window.opener.Core.Agent.Admin.ProcessManagement.HandlePopupClose();
        });

        $('.ClosePopup').on("click", function () {
            $(window).off("beforeunload.PMPopup");
        });
    };

    /**
     * @name InitPathEdit
     * @memberof Core.Agent.Admin.ProcessManagement
     * @function
     * @description
     *      Initialize path edit screen.
     */
    TargetNS.InitPathEdit = function () {
        var CurrentProcessEntityID = Core.Config.Get('ProcessEntityID'),
            CurrentTransitionEntityID = Core.Config.Get('TransitionEntityID'),
            StartActivityID = Core.Config.Get('StartActivityID'),
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
                $('#StartActivity').attr('title', ActivityInfo[Activity].Name).text(ActivityInfo[Activity].Name);
                $('#EndActivity').attr('title', ActivityInfo[Transition[CurrentTransitionEntityID].ActivityEntityID].Name).text(ActivityInfo[Transition[CurrentTransitionEntityID].ActivityEntityID].Name);

                StartActivityEntityID = Activity;
                EndActivityEntityID = Transition[CurrentTransitionEntityID].ActivityEntityID;
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
        $('#Transition').on('change', function () {
           $('#EditPath a').data('entity', $(this).val());
        });

        $('#Submit').on('click', function() {
            $('#PathForm').submit();
            return false;
        });

        // init submit
        Core.Form.Validate.SetSubmitFunction($('#PathForm'), function (Form) {

            var NewTransitionEntityID = $('#Transition').val(),
                NewTransitionActions = [],
                TransitionInfo;

            $('#AssignedTransitionActions li').each(function() {
                NewTransitionActions.push($(this).attr('id'));
            });

            // collection transition info for later merging
            TransitionInfo = {
                StartActivityEntityID: StartActivityEntityID,
                NewTransitionEntityID: NewTransitionEntityID,
                NewTransitionActions: NewTransitionActions,
                NewTransitionActivityID: EndActivityEntityID
            };

            $('#TransitionInfo').val(Core.JSON.Stringify(TransitionInfo));

            // not needed for normal submit
            $(window).off("beforeunload.PMPopup");

            Form.submit();
        });

        InitProcessPopups();

        // Init handling of closing popup with the OS functionality ("X")
        $(window).off("beforeunload.PMPopup").on("beforeunload.PMPopup", function () {
            window.opener.Core.Agent.Admin.ProcessManagement.HandlePopupClose();
        });

        $('.ClosePopup').on("click", function () {
            $(window).off("beforeunload.PMPopup");
        });
    };

    /**
     * @name ShowOverlay
     * @memberof Core.Agent.Admin.ProcessManagement
     * @function
     * @description
     *      Opens overlay.
     */
    TargetNS.ShowOverlay = function () {
        $('<div id="Overlay" tabindex="-1">').appendTo('body');
        $('body').css({
            'overflow': 'hidden'
        });
        $('#Overlay').height($(document).height()).css('top', 0);

        // If the underlying page is perhaps to small, we extend the page to window height for the dialog
        $('body').css('min-height', $(window).height());
    };

    /**
     * @name HideOverlay
     * @memberof Core.Agent.Admin.ProcessManagement
     * @function
     * @description
     *      Closes overlay and restores normal view.
     */
    TargetNS.HideOverlay = function () {
        $('#Overlay').remove();
        $('body').css({
            'overflow': 'visible',
            'min-height': 0
        });
    };

    /**
     * @name GetConditionConfig
     * @memberof Core.Agent.Admin.ProcessManagement
     * @function
     * @returns {Object} Conditions and fields.
     * @param {jQueryObject} $Conditions - Conditions element in DOM.
     * @description
     *      Get all conditions and corresponding fields.
     */
    TargetNS.GetConditionConfig = function ($Conditions) {

        var Conditions = {},
            ConditionKey;

        if (!$Conditions.length) {
            return {};
        }

        $Conditions.each(function() {

            // get condition key
            ConditionKey = $(this).closest('.WidgetSimple').attr('id').replace(/(Condition\[|\])/g, '');

            // use condition key as key for our list
            Conditions[ConditionKey] = {
                Type: $(this).find('.Field > select').val(),
                Fields: {}
            };

            // get all fields of the current condition
            $(this).find('.FieldWidget fieldset').each(function() {
                Conditions[ConditionKey].Fields[$(this).find('input').first().val()] = {
                    Type: $(this).find('select').val(),
                    Match: $(this).find('input').last().val()
                };
            });

        });

        return Conditions;
    };

    /**
     * @name UpdateConfig
     * @memberof Core.Agent.Admin.ProcessManagement
     * @function
     * @returns {Boolean} Returns false, if Config is not defined.
     * @param {Object} Config
     * @description
     *      Update gloabl process config object after config change e.g. in popup windows.
     */
    TargetNS.UpdateConfig = function (Config) {
        if (typeof Config === 'undefined') {
            return false;
        }

        // IE (11) has some permission problems with objects from other windows
        // Therefore we "copy" the object if we are in IE
        if ($.browser.trident) {
            Config = Core.JSON.Parse(Core.JSON.Stringify(Config));
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

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.ProcessManagement || {}));

/*eslint-enable no-window*/
