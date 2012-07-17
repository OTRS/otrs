// --
// Core.Agent.Admin.ProcessManagement.Canvas.js - provides the special module functions for the Process Management Diagram Canvas.
// Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
// --
// $Id: Core.Agent.Admin.ProcessManagement.Canvas.js,v 1.2 2012-07-17 14:00:21 mn Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

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
        ElementList,
        JointObject;
    
    function UpdateElementList() {
        ElementList = $.map(Elements, function (Value, Key) {
            return Value;
        });
    }
    
    TargetNS.CreateStartEvent = function (PosX, PosY) {
        var DefaultX = 30,
            DefaultY = 30;
        
        PosX = PosX || DefaultX;
        PosY = PosY || DefaultY;
        
        Elements['StartEvent'] = BPMN.StartEvent.create({
            x: PosX,
            y: PosY
        });
        
        UpdateElementList();
    };
    
    TargetNS.CreateActivity = function (EntityID, EntityName, PosX, PosY) {
        Elements[EntityID] = BPMN.Activity.create({
            position: {x: PosX, y: PosY},
            label: EntityName,
            id: EntityID,
            dblClickFunction: function() {
                // ToDo: Open Activity Popup
                alert(EntityID);
            }
        });
        
        UpdateElementList();
    };
    
    TargetNS.SetStartActivity = function (EntityID) {
        // Not more than one StartActivity allowed, function does not check this!
        // After the initialization of the canvas, an automatic setting of the StratActivity is not useful
        // Only the user can change this by moving the arrow
        if (Elements[EntityID] !== undefined) {
            JointObject = Elements['StartEvent'].joint(Elements[EntityID], BPMN.StartArrow).registerForever(ElementList);  
        }
    };
    
    TargetNS.CreateTransition = function (StartElement, EndElement, TransitionName) {
        // TODO
    };
    
    TargetNS.DrawDiagram = function () {
        // Dummy-Demo-Content, must be replaced by algorithm to read the config and draw the config elements
        TargetNS.CreateStartEvent();
        
        TargetNS.CreateActivity('A-1', 'Test-Activity 1', 100, 90);
        TargetNS.CreateActivity('A-2', 'Test-Activity 2', 300, 70);
        
        TargetNS.SetStartActivity('A-1');
    };
    
    TargetNS.Init = function () {
        // TODO: Correct calculation of needed width and height
        var CanvasWidth = 1000,
            CanvasHeight = 500;
        
        Joint.paper("Canvas", CanvasWidth, CanvasHeight);
        
        TargetNS.DrawDiagram();

        // bind object moving event to all elements. Every move causes a redraw after which we need a new initialization
        JointObject.registerCallback('objectMoving', function (SingleJointObject) {
            if (JointObject && JointObject._registeredObjects) {
                $.each(JointObject._registeredObjects, function (Key, Value) {
                    if (typeof Value.initTransitionDblClick !== 'undefined') {
                        Value.initTransitionDblClick(SingleJointObject);
                    }
                });
            }
        });
    };
    
    return TargetNS;
}(Core.Agent.Admin.ProcessManagement.Canvas || {}));
