// --
// Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

/*global jsPlumb, LabelSpacer */

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};
Core.Agent.Admin = Core.Agent.Admin || {};
Core.Agent.Admin.ProcessManagement = Core.Agent.Admin.ProcessManagement || {};

/**
 * @namespace Core.Agent.Admin.ProcessManagement.Canvas
 * @memberof Core.Agent.Admin.ProcessManagement
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the ProcessManagement Diagram Canvas module.
 */
Core.Agent.Admin.ProcessManagement.Canvas = (function (TargetNS) {

    /**
     * @private
     * @name Elements
     * @memberof Core.Agent.Admin.ProcessManagement.Canvas
     * @member {Array}
     * @description
     *      Glocal list of all process management elements (activities, ...).
     */
    var Elements = {},
    /**
     * @private
     * @name ActivityBoxHeight
     * @memberof Core.Agent.Admin.ProcessManagement.Canvas
     * @member {Number}
     * @description
     *      Height of activity box in pixel.
     */
        ActivityBoxHeight = 80;

    /**
     * @private
     * @name GetCanvasSize
     * @memberof Core.Agent.Admin.ProcessManagement.Canvas
     * @function
     * @returns {Object} Needed width and height of canvas.
     * @param {jQueryObject} $Element - jQuery object of Canvas area element.
     * @description
     *      Calculate minimum needed width ans height of canvas area to show all elements.
     */
    function GetCanvasSize($Element) {
        var MinWidth = 500,
            MinHeight = 500,
            MaxWidth = 0,
            MaxHeight = 0,
            ScreenWidth;

        // Find maximum X and maximum Y value in Layout config data.
        // This data was saved the last time the process was edited
        // it is possible to extend the canvas for larger drawings.
        // The minimum width is based on the available space (screen resolution)

        // Get width of surrounding element (possible canvas width)
        ScreenWidth = $Element.width();

        // Loop through available elements and find max needed width and height
        $.each(Core.Agent.Admin.ProcessManagement.ProcessLayout, function (Key, Value) {
            var Left = parseInt(Value.left, 10),
                Top = parseInt(Value.top, 10);

            if (Left > MaxWidth) {
                MaxWidth = Left + 110;
            }
            if (Top > MaxHeight) {
                MaxHeight = Top + ActivityBoxHeight;
            }
        });

        // Width should always be at least the screen width
        if (ScreenWidth > MaxWidth) {
            MaxWidth = ScreenWidth;
        }

        // The canvas should always have at least a minimum size
        if (MinWidth > MaxWidth) {
            MaxWidth = MinWidth;
        }
        if (MinHeight > MaxHeight) {
            MaxHeight = MinHeight;
        }

        return {
            Width: MaxWidth,
            Height: MaxHeight
        };
    }

    /**
     * @private
     * @name ShowRemoveEntityCanvasConfirmationDialog
     * @memberof Core.Agent.Admin.ProcessManagement.Canvas
     * @function
     * @param {String} EntityType
     * @param {String} EntityName
     * @param {String} EntityID
     * @param {Function} Callback
     * @description
     *      Show confirmation dialog to remove entity from canvas.
     */
    function ShowRemoveEntityCanvasConfirmationDialog(EntityType, EntityName, EntityID, Callback) {
        var DialogID = 'Remove' + EntityType + 'CanvasConfirmationDialog',
            $DialogElement = $('#Dialogs #' + DialogID);

        // Update EntityName in Dialog
        $DialogElement.find('span.EntityName').text(EntityName);

        Core.UI.Dialog.ShowContentDialog(
            $('#Dialogs #' + DialogID),
            Core.Agent.Admin.ProcessManagement.Localization.RemoveEntityCanvasTitle,
            '240px',
            'Center',
            true,
            [
               {
                   Label: Core.Agent.Admin.ProcessManagement.Localization.CancelMsg,
                   Class: 'Primary',
                   Function: function () {
                       Core.UI.Dialog.CloseDialog($('.Dialog'));
                   }
               },
               {
                   Label: Core.Agent.Admin.ProcessManagement.Localization.DeleteMsg,
                   Function: function () {
                       if (typeof Callback !== 'undefined') {
                           Callback();
                       }
                   }
               }
           ]
        );
    }

    /**
     * @name CreateStartEvent
     * @memberof Core.Agent.Admin.ProcessManagement.Canvas
     * @function
     * @param {String} PosX
     * @param {String} PosY
     * @description
     *      Create the initial start event at a specific position.
     */
    TargetNS.CreateStartEvent = function (PosX, PosY) {
        var DefaultX = 30,
            DefaultY = 30;

        PosX = PosX || DefaultX;
        PosY = PosY || DefaultY;

        $('#Canvas').append('<div id="StartEvent"></div>').find('#StartEvent').css({
            'top': PosY + 'px',
            'left': PosX + 'px'
        });
    };

    /**
     * @name CreateActivity
     * @memberof Core.Agent.Admin.ProcessManagement.Canvas
     * @function
     * @param {String} EntityID
     * @param {String} EntityName
     * @param {String} ActivityID
     * @param {String} PosX
     * @param {String} PosY
     * @description
     *      Create activity at specific position.
     */
    TargetNS.CreateActivity = function (EntityID, EntityName, ActivityID, PosX, PosY) {

        var EntityNameHeight,
            $EntityBox;

        $('#Canvas')
            .append('<div class="Activity Task" id="' + Core.App.EscapeHTML(EntityID) + '"><span>' + Core.App.EscapeHTML(EntityName) + '</span><div class="TaskTypeIcon"><i class="fa fa-user fa-lg"></i></div><div class="Icon Loader"></div><div class="Icon Success"></div></div>')
            .find('#' + EntityID)
            .css({
                'top': PosY + 'px',
                'left': PosX + 'px'
            })
            .bind('mouseenter.Activity', function() {
                TargetNS.ShowActivityTooltip($(this));
                TargetNS.ShowActivityDeleteButton($(this));
                TargetNS.ShowActivityEditButton($(this));
                if (TargetNS.DragActivityItem) {
                    $(this).addClass('ReadyToDrop');
                }
                $(this).addClass('Hovered');
            })
            .bind('mouseleave.Activity', function() {
                $('#DiagramTooltip').hide();
                $(this).removeClass('ReadyToDrop').find('.DiagramDeleteLink').remove();
                $(this).removeClass('ReadyToDrop').find('.DiagramEditLink').remove();
                $(this).removeClass('Hovered');
            })
            .bind('dblclick.Activity', function() {
                var Path = Core.Config.Get('Config.PopupPathActivity') + "EntityID=" + EntityID + ";ID=" + ActivityID,
                    SessionData = Core.App.GetSessionInformation();
                if (!Core.Config.Get('SessionIDCookie') && Path.indexOf(SessionData[Core.Config.Get('SessionName')]) === -1) {
                    Path += ';' + encodeURIComponent(Core.Config.Get('SessionName')) + '=' + encodeURIComponent(SessionData[Core.Config.Get('SessionName')]);
                }

                Core.Agent.Admin.ProcessManagement.ShowOverlay();
                Core.UI.Popup.OpenPopup(Path, 'Activity');
            });

        // Correct placing of activity name within box
        $EntityBox = $('#' + EntityID);
        EntityNameHeight = $EntityBox.find('span').height();
        $EntityBox.find('span').css('margin-top', parseInt((ActivityBoxHeight - EntityNameHeight) / 2, 10));

        // make the activity able to accept transitions
        jsPlumb.makeTarget(EntityID, {
            anchor: 'Continuous',
            isTarget: true,
            detachable: true,
            reattach: true,
            endpoint: [ 'Dot', { radius: 7, hoverClass: 'EndpointHover' } ],
            paintStyle: { fillStyle: '#000' },
            parameters: {
                'Parent': EntityID
            }
        });

        // Add the Activity to our list of elements
        Elements[EntityID] = $('#' + EntityID);
    };

    /**
     * @name CreateActivityDummy
     * @memberof Core.Agent.Admin.ProcessManagement.Canvas
     * @function
     * @param {String} StartActivityID
     * @description
     *      Create a dummy activity.
     */
    TargetNS.CreateActivityDummy = function (StartActivityID) {
        var StartActivityPosition, DummyPosition, CanvasSize = {};

        if ($('#Dummy').length) {
            $('#Dummy').remove();
        }

        CanvasSize.width = $('#Canvas').width();
        CanvasSize.height = $('#Canvas').height();

        // get position of start activity to calculate position of dummy
        StartActivityPosition = $('#' + StartActivityID).position();
        DummyPosition = StartActivityPosition;
        DummyPosition.top += 120;
        DummyPosition.left += 150;

        // check if DummyPosition is out of canvas and correct position
        if ((CanvasSize.width - 85) <= DummyPosition.left) {
            DummyPosition.left -= 250;
        }
        if ((CanvasSize.height - 115) <= DummyPosition.top) {
            DummyPosition.top -= 240;
        }

        $('#Canvas').append('<div class="Activity" id="Dummy"><span>Dummy</span></div>').find('#Dummy').css({
            top: DummyPosition.top,
            left: DummyPosition.left
        });
    };

    /**
     * @name ShowTransitionTooltip
     * @memberof Core.Agent.Admin.ProcessManagement.Canvas
     * @function
     * @returns {Boolean} Returns false, if transition is not defined.
     * @param {Object} Connection
     * @param {String} StartActivity
     * @description
     *      Show tooltip of a transition.
     */
    TargetNS.ShowTransitionTooltip = function (Connection, StartActivity) {
        var $Tooltip = $('#DiagramTooltip'),
            $Element = $(Connection.canvas),
            $TitleElement = $Element.clone(),
            text,
            position = { x: 0, y: 0},
            Transition = Core.Agent.Admin.ProcessManagement.ProcessData.Transition,
            ElementID = $TitleElement.find('span').attr('id'),
            CurrentProcessEntityID = $('#ProcessEntityID').val(),
            PathInfo = Core.Agent.Admin.ProcessManagement.ProcessData.Process[CurrentProcessEntityID].Path,
            AssignedTransitionActions = [],
            CanvasWidth, CanvasHeight,
            TooltipWidth, TooltipHeight;

        $TitleElement.find('a').remove();
        text = '<h4>' + Core.App.EscapeHTML($TitleElement.text()) + '</h4>';

        if (typeof Transition[ElementID] === 'undefined') {
            return false;
        }

        if (!$Tooltip.length) {
            $Tooltip = $('<div id="DiagramTooltip"></div>').css('display', 'none').appendTo('#Canvas');
        }
        else if ($Tooltip.is(':visible')) {
            $Tooltip.hide();
        }

        $.each(PathInfo, function(Activity, TransitionObject) {
            if (Activity === StartActivity && typeof TransitionObject[ElementID] !== 'undefined' && typeof TransitionObject[ElementID].TransitionAction !== 'undefined') {
                AssignedTransitionActions = TransitionObject[ElementID].TransitionAction;
                return false;
            }
        });

        // Add content to the tooltip
        text += "<ul>";
        if (AssignedTransitionActions.length) {
            $.each(AssignedTransitionActions, function (Key, Value) {
                text += "<li>" + Core.App.EscapeHTML(Core.Agent.Admin.ProcessManagement.ProcessData.TransitionAction[Value].Name) + " (" + Core.App.EscapeHTML(Value) + ") </li>";
            });
        }
        else {
            text += '<li class="NoDialogsAssigned">' + Core.Agent.Admin.ProcessManagement.Localization.NoTransitionActionsAssigned + '</li>';
        }
        text += "</ul>";

        $Tooltip.html(text);

        // calculate tooltip position
        // x: x-coordinate of canvas + x-coordinate of element within canvas + width of element
        //position.x = parseInt($Element.css('left'), 10) + parseInt($Element.width(), 10) + 30;
        //
        // y: y-coordinate of canvas + y-coordinate of element within canvas + height of element
        //position.y = parseInt($Element.css('top'), 10) + 15;

        // calculate tooltip position
        // if activity box is at the right border of the canvas, switch tooltip to the left side of the box
        CanvasWidth = $('#Canvas').width();
        TooltipWidth = $Tooltip.width();

        // If activity does not fit in canvas, generate tooltip on the left side
        if (CanvasWidth < (parseInt($Element.css('left'), 10) + parseInt($Element.width(), 10) + TooltipWidth)) {
            // x: x-coordinate of element within canvas - width of tooltip
            position.x = parseInt($Element.css('left'), 10) - TooltipWidth - 5;
        }
        // otherwise put tooltip on the right side (default behaviour)
        else {
            // x: x-coordinate of canvas + x-coordinate of element within canvas + width of element
            position.x = parseInt($Element.css('left'), 10) + parseInt($Element.width(), 10) + 40;
        }

        // if activity box is at the bottom border of the canvas, set tooltip y-coordinate to the top as far as needed
        CanvasHeight = $('#Canvas').height();
        TooltipHeight = $Tooltip.height();

        // y-coordinate
        if (parseInt($Element.css('top'), 10) + TooltipHeight + 15 > CanvasHeight) {
            position.y = CanvasHeight - TooltipHeight - 15;
        }
        else {
            position.y = parseInt($Element.css('top'), 10) + 15;
        }

        $Tooltip
            .css('top', position.y)
            .css('left', position.x)
            .show();
    };

    /**
     * @name ShowActivityTooltip
     * @memberof Core.Agent.Admin.ProcessManagement.Canvas
     * @function
     * @returns {Boolean} Returns false, if activity is not defined.
     * @param {jQueryObject} $Element
     * @description
     *      Show tooltip of an activity.
     */
    TargetNS.ShowActivityTooltip = function ($Element) {
        var $Tooltip = $('#DiagramTooltip'),
            text = '<h4>' + Core.App.EscapeHTML($Element.find('span').text()) + '</h4>',
            position = {x: 0, y: 0},
            Activity = Core.Agent.Admin.ProcessManagement.ProcessData.Activity,
            ActivityDialogs,
            CanvasWidth,
            CanvasHeight,
            TooltipWidth,
            TooltipHeight;

        if (typeof Activity[$Element.attr('id')] === 'undefined') {
            return false;
        }

        ActivityDialogs = Activity[$Element.attr('id')].ActivityDialog;

        if (!$Tooltip.length) {
            $Tooltip = $('<div id="DiagramTooltip"></div>').css('display', 'none').appendTo('#Canvas');
        }
        else if ($Tooltip.is(':visible')) {
            $Tooltip.hide();
        }

        // Add content to the tooltip
        text += "<ul>";
        if (ActivityDialogs) {
            $.each(ActivityDialogs, function (Key, Value) {
                var Interfaces = Core.Agent.Admin.ProcessManagement.ProcessData.ActivityDialog[Value].Interface,
                    SelectedInterface = '';

                $.each(Interfaces, function (InterfaceKey, InterfaceValue) {
                    if (SelectedInterface.length) {
                        SelectedInterface += '/';
                    }
                    SelectedInterface += InterfaceValue.substr(0, 1);
                });
                text += "<li><span class=\"AvailableIn\">" + SelectedInterface + "</span> " + Core.App.EscapeHTML(Core.Agent.Admin.ProcessManagement.ProcessData.ActivityDialog[Value].Name) + " (" + Core.App.EscapeHTML(Value) + ") </li>";
            });
        }
        else {
            text += '<li class="NoDialogsAssigned">' + Core.Agent.Admin.ProcessManagement.Localization.NoDialogsAssigned + '</li>';
        }

        text += "</ul>";

        $Tooltip.html(text);

        // calculate tooltip position
        // if activity box is at the right border of the canvas, switch tooltip to the left side of the box
        CanvasWidth = $('#Canvas').width();
        TooltipWidth = $Tooltip.width();

        // If activity does not fit in canvas, generate tooltip on the left side
        if (CanvasWidth < (parseInt($Element.css('left'), 10) + parseInt($Element.width(), 10) + TooltipWidth)) {
            // x: x-coordinate of element within canvas - width of tooltip
            position.x = parseInt($Element.css('left'), 10) - TooltipWidth - 10;
        }
        // otherwise put tooltip on the right side (default behaviour)
        else {
            // x: x-coordinate of canvas + x-coordinate of element within canvas + width of element
            position.x = parseInt($Element.css('left'), 10) + parseInt($Element.width(), 10) + 15;
        }

        // if activity box is at the bottom border of the canvas, set tooltip y-coordinate to the top as far as needed
        CanvasHeight = $('#Canvas').height();
        TooltipHeight = $Tooltip.height();

        // y-coordinate
        if (parseInt($Element.css('top'), 10) + TooltipHeight + 10 > CanvasHeight) {
            position.y = CanvasHeight - TooltipHeight - 10;
        }
        else {
            position.y = parseInt($Element.css('top'), 10) + 10;
        }

        $Tooltip
            .css('top', position.y)
            .css('left', position.x)
            .show();
    };

    /**
     * @name ShowActivityDeleteButton
     * @memberof Core.Agent.Admin.ProcessManagement.Canvas
     * @function
     * @returns {Boolean} Returns false, if activity is not defined.
     * @param {jQueryObject} $Element
     * @description
     *      Show button to delete an activity.
     */
    TargetNS.ShowActivityDeleteButton = function ($Element) {
        var $delete = $('.DiagramDeleteLink').clone(),
            Activity = Core.Agent.Admin.ProcessManagement.ProcessData.Activity,
            ElementID = $Element.attr('id');

        if (typeof Activity[ElementID] === 'undefined') {
            return false;
        }

        if ($delete.is(':visible')) {
            $delete.hide();
        }

        $Element.append($delete);

        $delete
            .show()
            .unbind('click')
            .bind('click', function () {
                ShowRemoveEntityCanvasConfirmationDialog('Activity', Activity[ElementID].Name, ElementID, function () {
                    TargetNS.RemoveActivity(ElementID);
                    Core.UI.Dialog.CloseDialog($('.Dialog'));
                });
                return false;
            });
    };

    /**
     * @name ShowActivityEditButton
     * @memberof Core.Agent.Admin.ProcessManagement.Canvas
     * @function
     * @returns {Boolean} Returns false, if activity is not defined.
     * @param {jQueryObject} $Element
     * @description
     *      Show button to edit an activity.
     */
    TargetNS.ShowActivityEditButton = function ($Element) {
        var $edit = $('.DiagramEditLink').clone(),
            Activity = Core.Agent.Admin.ProcessManagement.ProcessData.Activity,
            ElementID = $Element.attr('id');

        if (typeof Activity[ElementID] === 'undefined') {
            return false;
        }

        if ($edit.is(':visible')) {
            $edit.hide();
        }

        $Element.append($edit);

        $edit
            .show()
            .unbind('click')
            .bind('click', function () {
                var Path = Core.Config.Get('Config.PopupPathActivity') + "EntityID=" + ElementID + ";ID=" + Activity[ElementID].ID,
                    SessionData = Core.App.GetSessionInformation();
                if (!Core.Config.Get('SessionIDCookie') && Path.indexOf(SessionData[Core.Config.Get('SessionName')]) === -1) {
                    Path += ';' + encodeURIComponent(Core.Config.Get('SessionName')) + '=' + encodeURIComponent(SessionData[Core.Config.Get('SessionName')]);
                }

                Core.Agent.Admin.ProcessManagement.ShowOverlay();
                Core.UI.Popup.OpenPopup(Path, 'Activity');
                return false;
            });
    };

    /**
     * @name ShowActivityLoader
     * @memberof Core.Agent.Admin.ProcessManagement.Canvas
     * @function
     * @param {String} EntityID
     * @description
     *      Show loader on activity element.
     */
    TargetNS.ShowActivityLoader = function (EntityID) {
        if (typeof Elements[EntityID] !== 'undefined') {
            $('#' + EntityID).find('span').hide().parent().find('.Loader').show();
        }
    };

    /**
     * @name ShowActivityAddActivityDialogSuccess
     * @memberof Core.Agent.Admin.ProcessManagement.Canvas
     * @function
     * @param {String} EntityID
     * @description
     *      Show success icon on activity (and fade out again after 1 second).
     */
    TargetNS.ShowActivityAddActivityDialogSuccess = function (EntityID) {
        if (typeof Elements[EntityID] !== 'undefined') {
            // show icon for success
            $('#' + EntityID).find('.Loader').hide().parent().find('.Success').show();

            // wait 1 second, fade success icon out and label back in
            window.setTimeout(function () {
                $('#' + EntityID).find('.Success').fadeOut('slow', function() {
                    $('#' + EntityID).find('span').fadeIn();
                });
            }, 1000);
        }
    };

    /**
     * @name ShowActivityAddActivityDialogError
     * @memberof Core.Agent.Admin.ProcessManagement.Canvas
     * @function
     * @param {String} EntityID
     * @description
     *      Remove loader on activity on error.
     */
    TargetNS.ShowActivityAddActivityDialogError = function (EntityID) {
        $('#' + EntityID).find('.Loader').hide().parent().find('span').show();
    };

    /**
     * @name RemoveActivity
     * @memberof Core.Agent.Admin.ProcessManagement.Canvas
     * @function
     * @param {String} EntityID
     * @description
     *      Remove activity from canvas an data structures.
     */
    TargetNS.RemoveActivity = function (EntityID) {
        var Config = Core.Agent.Admin.ProcessManagement.ProcessData,
            Layout = Core.Agent.Admin.ProcessManagement.ProcessLayout,
            ProcessEntityID = $('#ProcessEntityID').val();

        // remove HTML elements
        $('#DiagramTooltip').hide();
        $('#' + EntityID).find('.DiagramDeleteLink').remove();
        $('#' + EntityID).find('.DiagramEditLink').remove();

        // if Activity is StartActivity, this Activity cannot be removed...
        if (Config.Process[ProcessEntityID].StartActivity === EntityID) {
            alert(Core.Agent.Admin.ProcessManagement.Localization.ActivityCannotBeDeleted);
            return;
        }

        // update config
        // delete entity and all transitions starting *from* here
        if (typeof Config.Process[ProcessEntityID].Path[EntityID] !== 'undefined') {
            delete Config.Process[ProcessEntityID].Path[EntityID];
        }

        // delete Elements array entry
        Core.Agent.Admin.ProcessManagement.Canvas.RemoveActivityFromConfig(EntityID);

        // delete all transitions *to* this entity
        $.each(Config.Process[ProcessEntityID].Path, function (StartActivity, Value) {
            // the Value is a hash with the transition name as Key
            // loop again
            $.each(Value, function (Transition, EndActivity) {
                // Key is now the Transition
                // Value is a hash with a Key "ActivityID" which is possibly our deleted Entity
                if (EndActivity.ActivityEntityID && EndActivity.ActivityEntityID === EntityID) {
                    delete Config.Process[ProcessEntityID].Path[StartActivity][Transition];
                }
            });
        });

        // remove layout information
        delete Layout[EntityID];

        // remove connections
        jsPlumb.detachAllConnections(EntityID);

        // remove element from canvas
        $('#Canvas').find('#' + EntityID).remove();
    };

    /**
     * @name RemoveActivityFromConfig
     * @memberof Core.Agent.Admin.ProcessManagement.Canvas
     * @function
     * @param {String} EntityID
     * @description
     *      Remove activity from config.
     */
    TargetNS.RemoveActivityFromConfig = function (EntityID) {
        delete Elements[EntityID];
    };

    /**
     * @name UpdateElementPosition
     * @memberof Core.Agent.Admin.ProcessManagement.Canvas
     * @function
     * @param {jQueryObject} $Element
     * @description
     *      Update position of element in layout data structure.
     */
    TargetNS.UpdateElementPosition = function ($Element) {
        var EntityID;
        // Element can be "false" if newly placed on the canvas
        // otherwise it's an object
        if ($Element) {
            EntityID = $Element.attr('id');
            if (typeof Core.Agent.Admin.ProcessManagement.ProcessLayout[EntityID] !== 'undefined') {
                // Save new element position
                Core.Agent.Admin.ProcessManagement.ProcessLayout[EntityID] = {
                    left: parseInt($Element.css('left'), 10),
                    top: parseInt($Element.css('top'), 10)
                };
            }
        }
    };

    /**
     * @name SetStartActivity
     * @memberof Core.Agent.Admin.ProcessManagement.Canvas
     * @function
     * @param {String} EntityID
     * @description
     *      Set start activity and add connection to it from start event.
     */
    TargetNS.SetStartActivity = function (EntityID) {

        // Not more than one StartActivity allowed, function does not check this!
        // After the initialization of the canvas, an automatic setting of the StartActivity is not useful
        // Only the user can change this by moving the arrow
        if (typeof Elements[EntityID] !== 'undefined') {

            // Create the connection from StartEvent to StartActivity
            // We don't create the Endpoints here, because every Activity
            // creates its own Endpoint on CreateActivity()
            jsPlumb.connect({
                source: 'StartEvent',
                target: EntityID,
                anchor: 'Continuous',
                endpoint: 'Blank',
                detachable: true,
                reattach: true
            });
        }
    };

    /**
     * @name LastTransitionDetails
     * @memberof Core.Agent.Admin.ProcessManagement.Canvas
     * @member {Object}
     * @description
     *     Structure to save last transition to restore correctly after repaint.
     */
    TargetNS.LastTransitionDetails = {};

    /**
     * @name CreateTransition
     * @memberof Core.Agent.Admin.ProcessManagement.Canvas
     * @function
     * @returns {Boolean} Returns fale, if start activity or end activity is not defined.
     * @param {String} StartElement
     * @param {String} EndElement
     * @param {String} EntityID
     * @param {String} TransitionName
     * @description
     *      Create new transition between StartElement and EndElement.
     */
    TargetNS.CreateTransition = function (StartElement, EndElement, EntityID, TransitionName) {

        var Config = Core.Agent.Admin.ProcessManagement.ProcessData,
            ProcessEntityID = $('#ProcessEntityID').val(),
            StartActivity, EndActivity, Connection,
            PopupPath;

        StartActivity = Elements[StartElement];
        if (EndElement === "Dummy") {
            EndActivity = $('#Dummy').attr('id');
        }
        else {
            EndActivity = Elements[EndElement];
        }

        if ((typeof StartActivity === 'undefined') || (typeof EndActivity === 'undefined')) {
            return false;
        }

        // Get TransitionName from Config
        if (typeof TransitionName === 'undefined') {
            if (Config.Transition && Config.Transition[EntityID]) {
                TransitionName = Config.Transition[EntityID].Name;
            }
            else {
                TransitionName = 'NoName';
            }
        }

        PopupPath = Core.Config.Get('Config.PopupPathPath') + "ProcessEntityID=" + ProcessEntityID + ";TransitionEntityID=" + EntityID + ";StartActivityID=" + StartElement;

        Connection = jsPlumb.connect({
            source: StartActivity,
            target: EndActivity,
            anchor: 'Continuous',
            endpoints: [
                "Blank",
                [ 'Dot', { radius: 7, hoverClass: 'EndpointHover' } ]
            ],
            endpointStyle: { fillStyle: '#000' },
            detachable: true,
            reattach: true,
            overlays: [
                [ "Diamond", { location: 18, width: 15, length: 25, paintStyle: { fillStyle: '#FFF', outlineWidth: 1, outlineColor: '#000'} } ],
                [ "Label", { label: '<span id="' + EntityID + '" title="' + Core.App.EscapeHTML(TransitionName) + '">' + Core.App.EscapeHTML(TransitionName) + '</span>', location: 0.5, cssClass: 'TransitionLabel', id: 'label', events: {
                    mouseenter: function(labelOverlay, originalEvent) {
                        TargetNS.LastTransitionDetails = {
                            LabelOverlay: labelOverlay,
                            StartElement: StartElement,
                            EndElement: EndElement
                        };
                        TargetNS.HighlightTransitionLabel(labelOverlay, StartElement, EndElement);
                        originalEvent.stopPropagation();
                        return false;
                    },
                    mouseleave: function(labelOverlay, originalEvent) {
                        TargetNS.UnHighlightTransitionLabel(labelOverlay);
                        originalEvent.stopPropagation();
                        return false;
                    }
                }}]
            ],
            parameters: {
                TransitionID: EntityID
            }
        });

        Connection.bind('mouseenter', function () {
            var Overlay = Connection.getOverlay('label');

            // add class to label
            if (Overlay) {
                $(Overlay.canvas).addClass('Hovered');
            }
        });

        Connection.bind('mouseleave', function () {
            var Overlay = Connection.getOverlay('label');

            // remove hover class from label
            if (Overlay) {
                $(Overlay.canvas).removeClass('Hovered');
            }
        });

        Connection.bind('dblclick', function(ConnectionObject, Event) {
            var EndActivityObject = ConnectionObject.endpoints[1],
                SessionData = Core.App.GetSessionInformation();
            // Do not open path dialog for dummy connections
            // dblclick on overlays (e.g. labels) propagate to the connection
            // prevent opening path dialog twice if clicked on label
            if (EndActivityObject !== 'Dummy' && !$(Event.srcElement).hasClass('TransitionLabel')) {
                Core.Agent.Admin.ProcessManagement.ShowOverlay();

                if (!Core.Config.Get('SessionIDCookie') && PopupPath.indexOf(SessionData[Core.Config.Get('SessionName')]) === -1) {
                    PopupPath += ';' + encodeURIComponent(Core.Config.Get('SessionName')) + '=' + encodeURIComponent(SessionData[Core.Config.Get('SessionName')]);
                }

                Core.UI.Popup.OpenPopup(PopupPath, 'Path');
            }
            Event.stopImmediatePropagation();
            return false;
        });
    };

    /**
     * @name HighlightTransitionLabel
     * @memberof Core.Agent.Admin.ProcessManagement.Canvas
     * @function
     * @param {String} Connection
     * @param {String} StartActivity
     * @param {String} EndActivity
     * @description
     *      Highlight transition label.
     */
    TargetNS.HighlightTransitionLabel = function(Connection, StartActivity, EndActivity) {

        var Config = Core.Agent.Admin.ProcessManagement.ProcessData,
            ProcessEntityID = $('#ProcessEntityID').val(),
            Path = Config.Process[ProcessEntityID].Path,
            TransitionEntityID = Connection.component.getParameter('TransitionID'),
            StartActivityID = Connection.component.sourceId,
            PopupPath = Core.Config.Get('Config.PopupPathPath') + "ProcessEntityID=" + ProcessEntityID + ";TransitionEntityID=" + TransitionEntityID + ";StartActivityID=" + StartActivityID,
            SessionData = Core.App.GetSessionInformation();

        if (TargetNS.DragTransitionAction) {
            $(Connection.canvas).addClass('ReadyToDrop');
            TargetNS.DragTransitionActionTransition = {
                TransitionID: TransitionEntityID,
                StartActivity: StartActivityID,
                Connection: Connection
            };
        }

        if (!$(Connection.canvas).find('.Delete').length) {
            $(Connection.canvas).append('<a class="Delete" title="' + Core.Agent.Admin.ProcessManagement.Localization.TransitionDeleteLink + '" href="#"><i class="fa fa-trash-o"></i></a>').find('.Delete').bind('click', function(Event) {
                ShowRemoveEntityCanvasConfirmationDialog('Path', Config.Transition[TransitionEntityID].Name, TransitionEntityID, function () {
                    jsPlumb.detach(Connection.component);
                    delete Path[StartActivityID][TransitionEntityID];
                    Core.UI.Dialog.CloseDialog($('.Dialog'));
                });

                Event.stopPropagation();
                return false;
            });
        }

        if (!$(Connection.canvas).find('.Edit').length) {
            $(Connection.canvas).append('<a class="Edit" title="' + Core.Agent.Admin.ProcessManagement.Localization.TransitionEditLink + '" href="#"><i class="fa fa-edit"></i></a>').find('.Edit').bind('click', function(Event) {
                if (EndActivity !== 'Dummy') {
                    if (!Core.Config.Get('SessionIDCookie') && PopupPath.indexOf(SessionData[Core.Config.Get('SessionName')]) === -1) {
                        PopupPath += ';' + encodeURIComponent(Core.Config.Get('SessionName')) + '=' + encodeURIComponent(SessionData[Core.Config.Get('SessionName')]);
                    }
                    Core.Agent.Admin.ProcessManagement.ShowOverlay();
                    Core.UI.Popup.OpenPopup(PopupPath, 'Path');
                }
                Event.stopPropagation();
                return false;
            });
        }

        // highlight label
        $(Connection.canvas).addClass('Hovered');
        Connection.component.setPaintStyle({ strokeStyle: "#FF9922", lineWidth: '2' });

        // show tooltip with assigned transition actions
        TargetNS.ShowTransitionTooltip(Connection, StartActivity);

        $(Connection.canvas).unbind('dblclick.Transition').bind('dblclick.Transition', function(Event) {
            if (EndActivity !== 'Dummy') {
                Core.Agent.Admin.ProcessManagement.ShowOverlay();
                Core.UI.Popup.OpenPopup(PopupPath, 'Path');
            }
            Event.stopPropagation();
            return false;
        });
    };

    /**
     * @name UnHighlightTransitionLabel
     * @memberof Core.Agent.Admin.ProcessManagement.Canvas
     * @function
     * @param {String} Connection
     * @description
     *      Unhighlight transition label.
     */
    TargetNS.UnHighlightTransitionLabel = function(Connection) {
        $('#DiagramTooltip').hide();
        if (TargetNS.DragTransitionAction) {
            $(Connection.canvas).removeClass('ReadyToDrop');
            TargetNS.DragTransitionActionTransition = {};
        }
        $(Connection.canvas).removeClass('Hovered');
        Connection.component.setPaintStyle({ strokeStyle: "#000", lineWidth: '2' });
    };

    /**
     * @name DragActivityItem
     * @memberof Core.Agent.Admin.GenericAgentEvent
     * @member {Bool}
     * @description
     *     DragActivityItem.
     */
    TargetNS.DragActivityItem = false;

    /**
     * @name DragTransitionAction
     * @memberof Core.Agent.Admin.GenericAgentEvent
     * @member {Bool}
     * @description
     *     DragTransitionAction.
     */
    TargetNS.DragTransitionAction = false;

    /**
     * @name DragTransitionActionTransition
     * @memberof Core.Agent.Admin.GenericAgentEvent
     * @member {Object}
     * @description
     *     DragTransitionActionTransition.
     */
    TargetNS.DragTransitionActionTransition = {};

    /**
     * @name DrawDiagram
     * @memberof Core.Agent.Admin.ProcessManagement.Canvas
     * @function
     * @description
     *      Draws the diagram on the canvas.
     */
    TargetNS.DrawDiagram = function () {
        var Config = Core.Agent.Admin.ProcessManagement.ProcessData,
            Layout = Core.Agent.Admin.ProcessManagement.ProcessLayout,
            ProcessEntityID = $('#ProcessEntityID').val(),
            StartActivity = Config.Process[ProcessEntityID].StartActivity;

        // Set some jsPlumb defaults
        jsPlumb.importDefaults({
            Connector: [ 'Flowchart', { curviness: 0, margin: -1, showLoopback: false } ],
            PaintStyle: { strokeStyle: "#000", lineWidth: 2 },
            HoverPaintStyle: { strokeStyle: "#FF9922", lineWidth: 2 },
            ConnectionOverlays: [
                [ "PlainArrow", { location: -15, width: 20, length: 15 } ]
            ]
        });

        // Always start with drawing the start event element
        TargetNS.CreateStartEvent();

        // Draw all available Activities (Keys of the ProcessData-Path)
        $.each(Config.Process[ProcessEntityID].Path, function (Key) {
            if (typeof Layout[Key] !== 'undefined') {
                TargetNS.CreateActivity(Key, Config.Activity[Key].Name, Config.Activity[Key].ID, Layout[Key].left, Layout[Key].top);
            }
            else {
                Core.Exception.Throw('Error: Activity without Layout Position!', 'ProcessError');
            }
        });

        // Start Activity
        if (typeof StartActivity !== 'undefined') {
            TargetNS.SetStartActivity(StartActivity);
        }

        // Now draw the Transitions
        $.each(Config.Process[ProcessEntityID].Path, function (Key, Value) {
            var StartActivityID = Key,
                TransitionID, EndActivityID,
                TransitionHash = Value;

            if (typeof TransitionHash !== 'undefined') {
                $.each(TransitionHash, function (TransitionKey, TransitionValue) {
                    TransitionID = TransitionKey;
                    // if EndActivity available, draw transition directly
                    if (typeof TransitionValue !== 'undefined') {
                        EndActivityID = TransitionValue.ActivityEntityID;
                        TargetNS.CreateTransition(StartActivityID, EndActivityID, TransitionID);
                    }

                    // if EndActivity is undefined draw transition with dummy
                    else {

                        // Create dummy activity to use for initial transition
                        TargetNS.CreateActivityDummy(StartActivityID);

                        // Create transition between this Activity and DummyElement
                        TargetNS.CreateTransition(StartActivityID, 'Dummy', TransitionID);

                        // Remove Connection to DummyElement and delete DummyElement again
                        TargetNS.RemoveActivityDummy();
                    }
                });
            }
        });

        TargetNS.MakeDraggable();

        $('div.TransitionLabel')
            .delegate('a.Delete, a.Edit, span', 'mouseenter', function () {
                TargetNS.HighlightTransitionLabel(TargetNS.LastTransitionDetails.LabelOverlay, TargetNS.LastTransitionDetails.StartElement, TargetNS.LastTransitionDetails.EndElement);
            })
            .delegate('a.Delete, a.Edit, span', 'mouseleave', function () {
                TargetNS.UnHighlightTransitionLabel(TargetNS.LastTransitionDetails.LabelOverlay);
            });
    };

    /**
     * @name MakeDraggable
     * @memberof Core.Agent.Admin.ProcessManagement.Canvas
     * @function
     * @description
     *      Makes all activities draggable.
     */
    TargetNS.MakeDraggable = function() {
        // make all activities draggable (note the z-index!)
        jsPlumb.draggable($('#Canvas .Activity'), {
            containment: '#Canvas',
            start: function() {
                $('#DiagramTooltip').hide();
                $(this).find('.DiagramDeleteLink').remove();
                $(this).find('.DiagramEditLink').remove();
            },
            stop: function() {
                TargetNS.UpdateElementPosition($(this));
            }
        });
    };

    /**
     * @name Redraw
     * @memberof Core.Agent.Admin.ProcessManagement.Canvas
     * @function
     * @description
     *      Redraws diagram.
     */
    TargetNS.Redraw = function () {
        $('#ShowEntityIDs').removeClass('Visible').text(Core.Agent.Admin.ProcessManagement.Localization.ShowEntityIDs);
        jsPlumb.reset();
        $('#Canvas').empty();
        TargetNS.Init();
    };

    /**
     * @name Extend
     * @memberof Core.Agent.Admin.ProcessManagement.Canvas
     * @function
     * @param {Object} CanvasSize
     * @description
     *      Extends the canvas size.
     */
    TargetNS.Extend = function (CanvasSize) {
        var CanvasWidth,
            CanvasHeight;

        if (typeof CanvasSize !== 'undefined') {

            CanvasWidth = $('#Canvas').width() + parseInt(CanvasSize.Width, 10);
            CanvasHeight = $('#Canvas').height() + parseInt(CanvasSize.Height, 10);

            $('#Canvas').width(CanvasWidth).height(CanvasHeight);
        }
    };

    /**
     * @name Init
     * @memberof Core.Agent.Admin.ProcessManagement.Canvas
     * @function
     * @description
     *      Initialize module functionality.
     */
    TargetNS.Init = function () {
        var CanvasSize = GetCanvasSize($('#Canvas')),
            CanvasWidth = CanvasSize.Width,
            CanvasHeight = CanvasSize.Height,
            CanvasLabelSpacer;

        // set the width and height of the drawing canvas,
        // based on the saved layout information (if available)
        $('#Canvas').width(CanvasWidth).height(CanvasHeight);

        // reset, because at this point (initial draw or redraw), there cannot be a saved connection
        TargetNS.LatestConnectionTransitionID = undefined;

        // init label spacer
        CanvasLabelSpacer = new LabelSpacer();
        CanvasLabelSpacer.reset();

        // init binding to connection changes
        jsPlumb.bind('connection', function(Data) {
            var Config = Core.Agent.Admin.ProcessManagement.ProcessData,
                ProcessEntityID = $('#ProcessEntityID').val(),
                Path = Config.Process[ProcessEntityID].Path,
                TransitionID;

            // check if we need to register a new StartActivity
            if (Data.sourceId === 'StartEvent') {
                Config.Process[ProcessEntityID].StartActivity = Data.targetId;
            }

            // in case the target is the dummy, its a whole new transition
            // and we need to mark it as "to be connected", so the user will
            // see that there is something to do with it
            else if (Data.targetId === 'Dummy') {
                Data.connection.setPaintStyle({ strokeStyle: "red", lineWidth: 4 });
                Data.targetEndpoint.setPaintStyle({ fillStyle: "red" });
            }
            else if (Data.targetId === Data.sourceId) {
                return false;
            }
            // otherwise, an existing transition has been (re)connected
            else {
                // get TransitionID
                TransitionID = Data.connection.getParameter('TransitionID');

                // Fallback: try to get the ID from the earlier saved variable, if it cannot be retrieved from the connection
                if (typeof TransitionID === 'undefined') {
                    TransitionID = TargetNS.LatestConnectionTransitionID;
                }

                // set new Path
                // this event also fires on the initial drawing of the diagram
                // we have to make sure, that existing data is not overwritten
                // if the config entry already exists, there is no need to redefine it
                if (typeof Path[Data.sourceId][TransitionID] === 'undefined') {
                    Path[Data.sourceId][TransitionID] = {
                        ActivityEntityID: Data.targetId
                    };
                }
                else if (Path[Data.sourceId][TransitionID].ActivityEntityID !== Data.targetId) {
                    Path[Data.sourceId][TransitionID].ActivityEntityID = Data.targetId;
                }

                // set connection style to blackagain (if it was red before)
                Data.connection.setPaintStyle({ strokeStyle: "#000", lineWidth: 2 });
                Data.targetEndpoint.setPaintStyle({ fillStyle: "#000" });
            }
        });

        // init event to save transition ID, because information is lost while re-connecting connections
        jsPlumb.bind('beforeDrop', function(Data) {
           TargetNS.LatestConnectionTransitionID = Data.connection.getParameter('TransitionID');
           return true;
        });

        TargetNS.DrawDiagram();
    };

    /**
     * @name ShowEntityIDs
     * @memberof Core.Agent.Admin.ProcessManagement.Canvas
     * @function
     * @description
     *      Shows EntityIDs on every element for debugging.
     */
    TargetNS.ShowEntityIDs = function () {

        var ActivityEntityID, TransitionEntityID, Connections, Overlay;

        // show EntityIDs of Activities
        $('.Activity').each(function() {
            ActivityEntityID = $(this).attr('id');
            $(this).append('<em class="EntityID"><input type="text" value="' + ActivityEntityID + '" /></em>').find('.EntityID input').unbind().bind('focus', function(Event) {
                this.select();
                Event.stopPropagation();
            });
        });

        // show EntityIDs of Transitions
        Connections = jsPlumb.getConnections();
        $(Connections).each(function() {
            TransitionEntityID = this.getParameter('TransitionID');
            Overlay = this.getOverlay('label');
            if (Overlay) {
                $(Overlay.canvas).append('<em class="EntityID"><input type="text" value="' + TransitionEntityID + '" /></em>').find('.EntityID input').unbind().bind('focus', function(Event) {
                    this.select();
                    Event.stopPropagation();
                });
            }
        });

    };

    return TargetNS;
}(Core.Agent.Admin.ProcessManagement.Canvas || {}));

/*jslint nomen: true*/
