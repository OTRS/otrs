/**
 * The check box marks a task complete.  It is a simulated form field 
 * with three states ...
 * 0=unchecked, 1=some children checked, 2=all children checked
 * When a task is clicked, the state of the nodes and parent and children
 * are updated, and this behavior cascades.
 *
 * @extends YAHOO.widget.TextNode
 * @constructor
 * @param oData    {object}  A string or object containing the data that will
 *                           be used to render this node.
 * @param oParent  {Node}    This node's parent node
 * @param expanded {boolean} The initial expanded/collapsed state
 * @param checked  {boolean} The initial checked/unchecked state
 */
YAHOO.widget.TaskNode = function(oData, oParent, expanded, checked) {
	YAHOO.widget.TaskNode.superclass.constructor.call(this,oData,oParent,expanded);
    this.setUpCheck(checked || oData.checked);

};

YAHOO.extend(YAHOO.widget.TaskNode, YAHOO.widget.TextNode, {

    /**
     * True if checkstate is 1 (some children checked) or 2 (all children checked),
     * false if 0.
     * @type boolean
     */
    checked: false,

    /**
     * checkState
     * 0=unchecked, 1=some children checked, 2=all children checked
     * @type int
     */
    checkState: 0,

	/**
     * The node type
     * @property _type
     * @private
     * @type string
     * @default "TextNode"
     */
    _type: "TaskNode",
	
	taskNodeParentChange: function() {
        //this.updateParent();
    },
	
    setUpCheck: function(checked) {
        // if this node is checked by default, run the check code to update
        // the parent's display state
        if (checked && checked === true) {
            this.check();
        // otherwise the parent needs to be updated only if its checkstate 
        // needs to change from fully selected to partially selected
        } else if (this.parent && 2 === this.parent.checkState) {
             this.updateParent();
        }

        // set up the custom event on the tree for checkClick
        /**
         * Custom event that is fired when the check box is clicked.  The
         * custom event is defined on the tree instance, so there is a single
         * event that handles all nodes in the tree.  The node clicked is 
         * provided as an argument.  Note, your custom node implentation can
         * implement its own node specific events this way.
         *
         * @event checkClick
         * @for YAHOO.widget.TreeView
         * @param {YAHOO.widget.Node} node the node clicked
         */
        if (this.tree && !this.tree.hasEvent("checkClick")) {
            this.tree.createEvent("checkClick", this.tree);
        }

		this.tree.subscribe('clickEvent',this.checkClick);
        this.subscribe("parentChange", this.taskNodeParentChange);


    },

    /**
     * The id of the check element
     * @for YAHOO.widget.TaskNode
     * @type string
     */
    getCheckElId: function() { 
        return "ygtvcheck" + this.index; 
    },

    /**
     * Returns the check box element
     * @return the check html element (img)
     */
    getCheckEl: function() { 
        return document.getElementById(this.getCheckElId()); 
    },

    /**
     * The style of the check element, derived from its current state
     * @return {string} the css style for the current check state
     */
    getCheckStyle: function() { 
        return "ygtvcheck" + this.checkState;
    },


   /**
     * Invoked when the user clicks the check box
     */
    checkClick: function(oArgs) { 
		var node = oArgs.node;
		var target = YAHOO.util.Event.getTarget(oArgs.event);
		if (YAHOO.util.Dom.hasClass(target,'ygtvspacer')) {
	        node.logger.log("previous checkstate: " + node.checkState);
	        if (node.checkState === 0) {
	            node.check();
	        } else {
	            node.uncheck();
	        }

	        node.onCheckClick(node);
	        this.fireEvent("checkClick", node);
		    return false;
		}
    },

    /**
     * Override to get the check click event
     */
    onCheckClick: function() { 
        this.logger.log("onCheckClick: " + this);
    },

    /**
     * Refresh the state of this node's parent, and cascade up.
     */
    updateParent: function() { 
        var p = this.parent;

        if (!p || !p.updateParent) {
            this.logger.log("Abort udpate parent: " + this.index);
            return;
        }

        var somethingChecked = false;
        var somethingNotChecked = false;

        for (var i=0, l=p.children.length;i<l;i=i+1) {

            var n = p.children[i];

            if ("checked" in n) {
                if (n.checked) {
                    somethingChecked = true;
                    // checkState will be 1 if the child node has unchecked children
                    if (n.checkState === 1) {
                        somethingNotChecked = true;
                    }
                } else {
                    somethingNotChecked = true;
                }
            }
        }

        if (somethingChecked) {
            p.setCheckState( (somethingNotChecked) ? 1 : 2 );
        } else {
            p.setCheckState(0);
        }

        p.updateCheckHtml();
        p.updateParent();
    },

    /**
     * If the node has been rendered, update the html to reflect the current
     * state of the node.
     */
    updateCheckHtml: function() { 
        if (this.parent && this.parent.childrenRendered) {
            this.getCheckEl().className = this.getCheckStyle();
        }
    },

    /**
     * Updates the state.  The checked property is true if the state is 1 or 2
     * 
     * @param the new check state
     */
    setCheckState: function(state) { 
        this.checkState = state;
        this.checked = (state > 0);
    },

    /**
     * Check this node
     */
    check: function() { 
        this.logger.log("check");
        this.setCheckState(2);
        for (var i=0, l=this.children.length; i<l; i=i+1) {
            var c = this.children[i];
            if (c.check) {
                c.check();
            }
        }
        this.updateCheckHtml();
        this.updateParent();
    },

    /**
     * Uncheck this node
     */
    uncheck: function() { 
        this.setCheckState(0);
        for (var i=0, l=this.children.length; i<l; i=i+1) {
            var c = this.children[i];
            if (c.uncheck) {
                c.uncheck();
            }
        }
        this.updateCheckHtml();
        this.updateParent();
    },
    // Overrides YAHOO.widget.TextNode

    /*
	getContentHtml: function() { 
        var sb = [];
        sb[sb.length] = '<td';
        sb[sb.length] = ' id="' + this.getCheckElId() + '"';
        sb[sb.length] = ' class="' + this.getCheckStyle() + '"';
        sb[sb.length] = '>';
        sb[sb.length] = '<div class="ygtvspacer"></div></td>';

        sb[sb.length] = '<span';
        sb[sb.length] = ' id="' + this.labelElId + '"';
        if (this.title) {
            sb[sb.length] = ' title="' + this.title + '"';
        }
        sb[sb.length] = ' class="' + this.labelStyle  + '"';
        sb[sb.length] = ' >';
        sb[sb.length] = this.label;
        sb[sb.length] = '</span>';
        return sb.join("");
    }
    */
    getContentHtml: function() {                                                                                                                                           
        var sb = [];                                                                                                                                                       
        sb[sb.length] = '<td';                                                                                                                                             
        sb[sb.length] = ' id="' + this.getCheckElId() + '"';                                                                                                               
        sb[sb.length] = ' class="' + this.getCheckStyle() + '"';                                                                                                           
        sb[sb.length] = '>';                                                                                                                                               
        sb[sb.length] = '<div class="ygtvspacer"></div></td>';                                                                                                             
                                                                                                                                                                           
        sb[sb.length] = '<td><span';                                                                                                                                       
        sb[sb.length] = ' id="' + this.labelElId + '"';                                                                                                                    
        if (this.title) {                                                                                                                                                  
            sb[sb.length] = ' title="' + this.title + '"';                                                                                                                 
        }                                                                                                                                                                  
        sb[sb.length] = ' class="' + this.labelStyle  + '"';                                                                                                               
        sb[sb.length] = ' >';                                                                                                                                              
        sb[sb.length] = this.label;                                                                                                                                        
        sb[sb.length] = '</span></td>';                                                                                                                                    
        return sb.join("");                                                                                                                                                
    }  
});
