// --
// Core.Agent.Admin.ProcessManagement.Canvas.js - provides the special module functions for the Process Management Diagram Canvas.
// Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
// --
// $Id: Core.Agent.Admin.ProcessManagement.Canvas.js,v 1.19 2012-08-02 12:49:56 mn Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

/*global Joint */

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};
Core.Agent.Admin = Core.Agent.Admin || {};
Core.Agent.Admin.ProcessManagement = Core.Agent.Admin.ProcessManagement || {};

/**
 * @namespace
 * @exports TargetNS as Core.Agent.Admin.ProcessManagement.Canvas
 * @description
 *      This namespace contains the special module functions for the ProcessManagement Diagram Canvas module.
 */
Core.Agent.Admin.ProcessManagement.Canvas = (function (TargetNS) {

    var BPMN = Joint.dia.bpmn,
        Elements = {},
        ElementList = [],
        JointObject;
    
    function TransitionDblClick() {
        alert('Open Path popup if available');
    }
    
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
                MaxWidth = Left + 130;
            }
            if (Top > MaxHeight) {
                MaxHeight = Top + 100;
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
    
    function InitObjectMoving() {
        var MovingTimer;
        // bind object moving event to all elements (only connected Elements aka Joints).
        // Every move causes a redraw after which we need a new initialization
        
        if (typeof JointObject !== 'undefined') {
            JointObject.registerCallback('objectMoving', function (SingleJointObject) {
                // Event fires very often, so use a timer to reduce the number of function executions
                if (typeof MovingTimer !== 'undefined') {
                    window.clearTimeout(MovingTimer);
                }
                
                MovingTimer = window.setTimeout(function () {
                    // Re-Initialize DblClick
                    if (JointObject && JointObject._registeredObjects) {
                        $.each(JointObject._registeredObjects, function (Key, Value) {
                            if (typeof Value.initTransitionDblClick !== 'undefined') {
                                Value.initTransitionDblClick(SingleJointObject, TransitionDblClick);
                            }
                        });
                    }                    
                }, 100);
            });        
        }
    }
    
    function ChangeTransitionColor(TransitionObject, Color) {
        TransitionObject._opt.attrs.stroke = Color;
    };
    
    TargetNS.CreateStartEvent = function (PosX, PosY) {
        var DefaultX = 30,
            DefaultY = 30;
        
        PosX = PosX || DefaultX;
        PosY = PosY || DefaultY;
        
        Elements.StartEvent = BPMN.StartEvent.create({
            x: PosX,
            y: PosY
        });

        ElementList.push(Elements.StartEvent);
    };
    
    TargetNS.CreateActivity = function (EntityID, EntityName, ActivityID, PosX, PosY) {
        Elements[EntityID] = BPMN.Activity.create({
            position: {x: PosX, y: PosY},
            label: EntityName,
            id: EntityID,
            dblClickFunction: function() {
                var Path = Core.Config.Get('Config.PopupPathActivity') + ";EntityID=" + EntityID + ";ID=" + ActivityID;
                Core.Agent.Admin.ProcessManagement.ShowOverlay();
                Core.UI.Popup.OpenPopup(Path, 'Activity');
            }
        });
        
        ElementList.push(Elements[EntityID]);
    };

    TargetNS.ActivityDummy = '';
    
    TargetNS.CreateActivityDummy = function (PosX, PosY) {
        TargetNS.ActivityDummy = BPMN.ActivityDummy.create({
            position: {x: PosX, y: PosY},
            id: 'ActivityDummy'
        });
    };
    
    TargetNS.RemoveActivityDummy = function () {
        var JointObject = TargetNS.ActivityDummy.joints()[0];
        TargetNS.ActivityDummy.remove();
        ChangeTransitionColor(JointObject, "#F00");
        JointObject.update();
    };
    
    TargetNS.ShowActivityLoader = function (EntityID) {
        if (typeof Elements[EntityID] !== 'undefined') {
            Elements[EntityID].removeLabel();
            Elements[EntityID].showLoader();
        }
    };
    
    TargetNS.ShowActivityAddActivityDialogSuccess = function (EntityID) {
        if (typeof Elements[EntityID] !== 'undefined') {
            // show icon for success
            Elements[EntityID].hideLoader();
            Elements[EntityID].showSuccessIcon();
            
            // wait 1 second and fade out
            window.setTimeout(function () {
                Elements[EntityID].hideSuccessIcon(function () {
                    Elements[EntityID].drawLabel();
                });
            }, 1000);
        }
    };
    
    TargetNS.ShowActivityAddActivityDialogError = function (EntityID) {
        Elements[EntityID].hideLoader();
        Elements[EntityID].drawLabel();
    };
    
    TargetNS.UpdateElementPosition = function (Element) {
        var Properties,
            EntityID;
        // Element can be "false" if newly placed on the canvas
        // otherwise it's an object
        if (Element) {
            Properties = Element.properties;
            EntityID = Properties.id;
            
            if (typeof Core.Agent.Admin.ProcessManagement.ProcessLayout[EntityID] !== 'undefined') {
                // Save new element position
                Core.Agent.Admin.ProcessManagement.ProcessLayout[EntityID] = {
                    left: parseInt(Properties.position.x, 10) + parseInt(Properties.dx, 10),
                    top: parseInt(Properties.position.y, 10) + parseInt(Properties.dy, 10)
                };            
            }
        }
    };
    
    TargetNS.SetStartActivity = function (EntityID) {
        // Not more than one StartActivity allowed, function does not check this!
        // After the initialization of the canvas, an automatic setting of the StratActivity is not useful
        // Only the user can change this by moving the arrow
        if (typeof Elements[EntityID] !== 'undefined') {
            JointObject = Elements.StartEvent.joint(Elements[EntityID], BPMN.StartArrow).registerForever(ElementList);
            
            JointObject.registerCallback("disconnected", function () {
                ChangeTransitionColor(JointObject, "#F00");
            });
            
            JointObject.registerCallback("justConnected", function (Side) {
                var Config = Core.Agent.Admin.ProcessManagement.ProcessData,
                    ProcessEntityID = $('#ProcessEntityID').val(),
                    StartActivity, EndActivityID, EndActivity;
                
                if (Side === "start") {
                    // Handle start cap change
                    StartActivity = this;
                    if (StartActivity.wholeShape && StartActivity.wholeShape.properties && StartActivity.wholeShape.properties.object === 'Activity') {
                        alert(Core.Agent.Admin.ProcessManagement.Localization.StartEventCapChange);
                        window.setTimeout(function () {
                            var Dummy;
                            JointObject.disconnect('start');
                            Dummy = JointObject._start;
                            JointObject.replaceDummy(Dummy, Elements.StartEvent.wrapper);
                            JointObject.addJoint(Elements.StartEvent.wrapper);
                            
                            if (!JointObject.isStartDummy() && !JointObject.isEndDummy()) {
                                ChangeTransitionColor(JointObject, "#000");                    
                            }
                            JointObject.update();
                        }, 100);
                    }
                    window.setTimeout(function () {
                        if (!JointObject.isStartDummy() && !JointObject.isEndDummy()) {
                            ChangeTransitionColor(JointObject, "#000");
                            JointObject.update();
                        }
                    }, 200);    
                }
                else {  // side === "end"
                    // Handle end cap change
                    EndActivity = this;
                    if (EndActivity.wholeShape && EndActivity.wholeShape.properties && EndActivity.wholeShape.properties.object === 'Activity') {
                        EndActivityID = EndActivity.wholeShape.properties.id;
                        Config.Process[ProcessEntityID].StartActivity = EndActivityID;
                    }
                    
                    window.setTimeout(function () {
                        if (!JointObject.isStartDummy() && !JointObject.isEndDummy()) {
                            ChangeTransitionColor(JointObject, "#000");
                            JointObject.update();
                        }
                    }, 200);
                }
            });
            InitObjectMoving();
        }
    };
    
    TargetNS.CreateTransition = function (StartElement, EndElement, EntityID, TransitionName) {
        var Config = Core.Agent.Admin.ProcessManagement.ProcessData,
            ProcessEntityID = $('#ProcessEntityID').val(),
            Path = Config.Process[ProcessEntityID].Path,
            LocalJointObject,
            StartActivity, EndActivity,
            OldActivity;
            
        StartActivity = Elements[StartElement];
        if (EndElement === "Dummy") {
            EndActivity = TargetNS.ActivityDummy;
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
        
        // Establish the joint
        LocalJointObject = StartActivity.joint(EndActivity, (BPMN.Arrow.label = TransitionName, BPMN.Arrow)).registerForever(ElementList);
        StartActivity.initTransitionDblClick(undefined, TransitionDblClick);
        if (EndElement !== "Dummy") {
            EndActivity.initTransitionDblClick(undefined, TransitionDblClick);    
        }
        
        // Register callbacks for disconnecting and connecting transitions
        LocalJointObject.registerCallback("disconnected", function () {
            // get old activity (the activity that was just disconnected)
            // to find the correct config data if the transition is connected again
            OldActivity = this;
            ChangeTransitionColor(LocalJointObject, "#F00");
        });
        
        LocalJointObject.registerCallback("justConnected", function (Side) {
            var Config = Core.Agent.Admin.ProcessManagement.ProcessData,
                ProcessEntityID = $('#ProcessEntityID').val(),
                StartActivityID, StartActivity, EndActivityID, EndActivity,
                PathElement,
                OldActivityID; 
            
                
            if (typeof OldActivity !== 'undefined') {
                OldActivityID = OldActivity.wholeShape.properties.id;    
            }
                
            if (Side === "start") {
                // Handle start cap change
                StartActivity = this;
                if (StartActivity.wholeShape && StartActivity.wholeShape.properties && StartActivity.wholeShape.properties.object === 'Activity') {
                    StartActivityID = StartActivity.wholeShape.properties.id;
                    
                    // remove old Path info from config
                    PathElement = Path[OldActivityID][EntityID];
                    delete Path[OldActivityID][EntityID];
                    
                    // add new path info
                    Path[StartActivityID][EntityID] = PathElement;
                    
                    // re-initialize DblClick
                    StartActivity.wholeShape.initTransitionDblClick(undefined, TransitionDblClick);
                    
                }
                window.setTimeout(function () {
                    LocalJointObject.callback("objectMoving", LocalJointObject, [StartActivity]);
                    
                    if (!LocalJointObject.isStartDummy() && !LocalJointObject.isEndDummy()) {
                        ChangeTransitionColor(LocalJointObject, "#000");
                        LocalJointObject.update();
                    }
                }, 200);    
            }
            else {  // side === "end"
                // Handle end cap change
                EndActivity = this;
                if (EndActivity.wholeShape && EndActivity.wholeShape.properties && EndActivity.wholeShape.properties.object === 'Activity') {
                    EndActivityID = EndActivity.wholeShape.properties.id;
                    StartActivityID = LocalJointObject.startObject().wholeShape.properties.id;
                    
                    // otherwise change end activity in Path info from config
                    Path[StartActivityID][EntityID]["ActivityID"] = EndActivityID;
                    
                    // re-initialize DblClick
                    Elements[EndActivityID].initTransitionDblClick(undefined, TransitionDblClick);
                }
                
                window.setTimeout(function () {
                    LocalJointObject.callback("objectMoving", LocalJointObject, [EndActivity]);
                    
                    if (!LocalJointObject.isStartDummy() && !LocalJointObject.isEndDummy()) {
                        ChangeTransitionColor(LocalJointObject, "#000");
                        LocalJointObject.update();
                    }
                }, 200);
            }
        });
    };
    
    TargetNS.DrawDiagram = function () {
        var Config = Core.Agent.Admin.ProcessManagement.ProcessData,
            Layout = Core.Agent.Admin.ProcessManagement.ProcessLayout,
            ProcessEntityID = $('#ProcessEntityID').val(),
            StartActivity = Config.Process[ProcessEntityID].StartActivity;
        
        // Always start with drawing the start event element
        TargetNS.CreateStartEvent();
        
        // Draw all available Activities (Keys of the ProcessData-Path)
        $.each(Config.Process[ProcessEntityID].Path, function (Key, Value) {
            if (typeof Layout[Key] !== 'undefined') {
                TargetNS.CreateActivity(Key, Config.Activity[Key].Name, Config.Activity[Key].ID, Layout[Key].left, Layout[Key].top);
            }
            else {
                console.log('Error: Activity without Layout Position!');
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
                $.each(TransitionHash, function (Key, Value) {
                    TransitionID = Key;
                    // if EndActivity available, draw transition directly
                    if (typeof Value !== 'undefined') {
                        EndActivityID = Value.ActivityID;
                        TargetNS.CreateTransition(StartActivityID, EndActivityID, TransitionID);
                    }
                    // if EndActivity is undefined draw transition with dummy
                    else {
                        // Create dummy activity to use for initial transition
                        TargetNS.CreateActivityDummy(100, 100);
                        
                        // Create transition between this Activity and DummyElement
                        TargetNS.CreateTransition(Activity, 'Dummy', EntityID);
                        
                        // Remove Connection to DummyElement and delete DummyElement again
                        TargetNS.RemoveActivityDummy();                        
                    }
                });
            }
        });
    };
    
    TargetNS.Redraw = function () {
        $('#Canvas').empty();
        TargetNS.Init();
    };
    
    TargetNS.Init = function () {
        var CanvasSize = GetCanvasSize($('#Canvas')),
            CanvasWidth = CanvasSize.Width,
            CanvasHeight = CanvasSize.Height;
        
        Joint.paper("Canvas", CanvasWidth, CanvasHeight);
        
        TargetNS.DrawDiagram();

        InitObjectMoving();
    };
    
    return TargetNS;
}(Core.Agent.Admin.ProcessManagement.Canvas || {}));
