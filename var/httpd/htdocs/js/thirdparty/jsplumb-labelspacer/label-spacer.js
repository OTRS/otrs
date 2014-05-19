/**

LabelSpacer

This is the glue code between jsPlumb and jsMagnetize, which takes care of appropriately configuring 
a Magnetizer: supplying it with the list of elements to move, which are labels, as well as all of the 
positioning functions, and the constrain functions, which defer to the underlying connectors.

To use this, include this script in a page, and then instantiate an instance like this:

var labelSpacer = new LabelSpacer();

This will use all of the defaults:

jsPlumb 				: 	jsPlumb 		- You can supply an instance of jsPlumb for the label spacer to manage. By default it uses the static jsPlumb instance.
padding  				:  	[20,20] 		- default padding, in pixels, in each direction.
fireAfterDrag			: 	true 			- runs the spacer algorithm after drag stop of any element
fireOnNewConnections	: 	true 			- runs the spacer when a new connection is established
debug 					: 	false 			- if true, shows a visual cue representing the origin used by the magnetizer.
getLabel				:	see constructor docs

*/
;(function() {

	//
	// helper functions to get/set positions using absolute coords on elements.
	//
	var _getAbsolutePosition = function(entry) {
			var o = {
				left:parseInt(entry.el.style.left || 0, 10),
				top:parseInt(entry.el.style.top || 0, 10)
			};
			return o;
		},
		_setAbsolutePosition = function(entry, p) {
			//  set the absolute position on the connection. it is cleared on a drag.
			var _x = p.left - entry.connectorOffset.left,
				_y = p.top - entry.connectorOffset.top;
			
			entry.connection.setAbsoluteOverlayPosition(entry.label, [ _x, _y ]);
		};		

	/**
	* @name LabelSpacer
	* @desc The glue code between the magnetizer and an instance of jsPlumb.
	* @param {Object} params Constructor params
	* @param {jsPlumbInstance} [params.jsPlumb=jsPlumb] jsPlumb instance to work with. Defaults to the static jsPlumb instance if not provided.
	* @param {Boolean} [params.fireAfterDrag=true] Whether or not to execute the label space routine after an element has been dragged.
	* @param {Boolean} [params.fireOnNewConnections=true] Whether or not to execute the label space routine after a new connection is established.
	* @param {Boolean} [params.debug=false] If true, shows some visual cues to help with debugging.
	* @param {Function} [params.getLabel] Optional function to extract the label overlay from some connection.  Your function is passed a connection and may return a Label overlay or null. By default, the label spacer retrieves the label registered with id "label".
	*/
	window.LabelSpacer = function(params) {
		params = params || {};

		// if no specific instance of jsPlumb given, use the default, static instance.
		var _jsPlumb = params.jsPlumbInstance || jsPlumb,
			self = this,
			cache = {},
			dirtyCache = {},
			debug = params.debug,
			fireOnNewConnections = params.fireOnNewConnections !== false,
			fireAfterDrag = params.fireAfterDrag !== false,
			getLabel = params.getLabel || function(connection) {
				return connection.getOverlay("label");
			};

		// override jsPlumb draggable method; we mark an element as 'dirty' when a
		// drag starts.
		var _draggable = _jsPlumb.draggable;
		_jsPlumb.draggable = function(el, params, options) {
			params = params || {};
			var elId = _jsPlumb.getId(el[0]);
			params.start = jsPlumbUtil.wrap(params.start, function(e, ui) {
				dirtyCache[elId] = true;	
			});
			params.stop = jsPlumbUtil.wrap(params.stop, function(e, ui) {
				if (fireAfterDrag)
					self.execute();
				dirtyCache[elId] = false;
			});
			_draggable.apply(_jsPlumb, [ el, params, options ]);
		};				

		var magnetizer = new Magnetizer({
			getPosition:_getAbsolutePosition,
			setPosition:_setAbsolutePosition,
			padding:params.padding,			
			getSize:function(entry) { return entry.size; },
			getId : function(entry) { return entry.id; },
			constrain:function(id, current, delta) {
				var entry = cache[id],			
					connector = entry.connector,
					o = entry.connectorOffset,
					_x = current[0] + delta.left,
					_y = current[1] + delta.top,
					_sx = _x - o.left,
					_sy = _y - o.top;

				// now [_sx,_sy] gives us the value relative to the Connector canvas's origin, so we find the
				// segment closest to that point.
				var closest = connector.findSegmentForPoint(_sx, _sy);

				// [l,t] gives us the point in absolute coordinates relative to the jsPlumb Container.
				var l = o.left + closest.x,
					t = o.top + closest.y;

				if (debug) {
					$("." + id + "-marker").remove();
					$("body").append($("<div class='" + id + "-marker' style='z-index:90000;position:absolute;width:5px;height:5px;background-color:red;left:" + l + "px;top:" + t + "px;'></div>"));
				}

				// the return value is delta allowed, so return difference between [l,t] and the current position.
				return {
					left:l - current[0],
					top:t - current[1]
				};
			},
			filter:function(id) {
				// this filters elements that should be magnetized.  we magnetize labels for connections for which
				// one element (source or target) has been dragged and is marked dirty, or for connections whose
				// labels have not been magnetized (either since creation or after a reset)
				return dirtyCache[cache[id].connection.sourceId] !== false &&
						dirtyCache[cache[id].connection.targetId] !== false;
			}
		});

		/**
		* @name LabelSpacer#execute
		* @function
		* @desc Executes the label spacer. All labels that have never been spaced, or are on a connection
		* whose source or target has been dragged since the last spacing operation, are included.
		*/
		this.execute = function() {
			var connections = _jsPlumb.select(), els = [];
			connections.each(function(c) {
				var lbl = getLabel(c);
				if (lbl != null) {
					var lblElement = lbl.getElement(),
						lblId = _jsPlumb.getId(lblElement),
						size = [ $(lblElement).outerWidth(), $(lblElement).outerHeight() ],
						conn = c.getConnector(),
						op = conn.canvas.offsetParent,
						opo = op == null ? {left:0, top:0 } : $(op).offset(),
						co = $(conn.canvas).offset(),
						data = {
							connection:c,
							label:lbl,
							el:lblElement,
							size:size,
							id:lblId,
							connector:conn,
							connectorOffset:{left:co.left - opo.left, top:co.top - opo.top },
							parentOffset:opo
						};

					els.push(data);
					// stash the data, keyed by label element id.
					cache[lblId] = data;
				}
			});

			magnetizer.setElements(els);
			magnetizer.executeAtCenter();
			_jsPlumb.repaintEverything();
		};

		// if fireOnNewConnections is set, add listener to jsplumb
		if (fireOnNewConnections)
			_jsPlumb.bind("connection", this.execute);

		/**
		* @name LabelSpacer#reset
		* @function 
		* @desc Resets the spacer so that on the next execute call, all labels are included.
		*/
		this.reset = function() {
			dirtyCache = {};
			cache = {};
			_jsPlumb.repaintEverything(true);
		};
	};

}).call(this);