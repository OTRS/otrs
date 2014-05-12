;(function() {

    var root = this;
    var Farahey;
    if (typeof exports !== 'undefined') {
        Farahey = exports;
    } else {
        Farahey = root.Farahey = {};
    } 

    var findInsertionPoint = function(sortedArr, val, comparator) {   
           var low = 0, high = sortedArr.length;
           var mid = -1, c = 0;
           while(low < high)   {
              mid = parseInt((low + high)/2);
              c = comparator(sortedArr[mid], val);
              if(c < 0)   {
                 low = mid + 1;
              }else if(c > 0) {
                 high = mid;
              }else {
                 return mid;
              }
           }
           return low;
        },
        geomSupport = typeof jsPlumbGeom !== "undefined" ? jsPlumbGeom : Biltong,
        insertSorted = function(array, value, comparator) {
            var ip = findInsertionPoint(array, value, comparator);
            array.splice(ip, 0, value);
        },
        distanceFromOriginComparator = function(r1, r2, origin) {
            var d1 = geomSupport.lineLength(origin, [ r1.x + (r1.w / 2), r1.y + (r1.h / 2)]),
                d2 = geomSupport.lineLength(origin, [ r2.x + (r2.w / 2), r2.y + (r2.h / 2)]);

            return d1 < d2 ? -1 : d1 == d2 ? 0 : 1;
        },
        EntryComparator = function(origin, getSize) {
            var _origin = origin,
                _cache = {},
                _get = function(entry) {
                    if (!_cache[entry[1]]) {
                        var s = getSize(entry[2]);
                        _cache[entry[1]] = {
                            l:entry[0][0],
                            t:entry[0][1],
                            w:s[0],
                            h:s[1],
                            center:[entry[0][0] + (s[0] / 2), entry[0][1] + (s[1] / 2) ]
                        };
                    }
                    return _cache[entry[1]];
                }
            this.setOrigin = function(o) {
                _origin = o;
                _cache = {};
            };
            this.compare = function(e1, e2) {
                var d1 = geomSupport.lineLength(_origin, _get(e1).center),
                    d2 = geomSupport.lineLength(_origin, _get(e2).center);

                return d1 < d2 ? -1 : d1 == d2 ? 0 : 1;
            };
        };

    var _isOnEdge = function(r, axis, dim, v) { return (r[axis] <= v && v <= r[axis] + r[dim]); },
        _xAdj = [ function(r1, r2) { return r1.x + r1.w - r2.x; }, function(r1, r2) { return r1.x - (r2.x + r2.w); } ],
        _yAdj = [ function(r1, r2) { return r1.y + r1.h - r2.y; }, function(r1, r2) { return r1.y - (r2.y + r2.h); } ],
        _adj = [ null, [ _xAdj[0], _yAdj[1] ], [ _xAdj[0], _yAdj[0] ], [ _xAdj[1], _yAdj[0] ], [ _xAdj[1], _yAdj[1] ] ],                  
        _genAdj = function(r1, r2, m, b, s) {
            if (isNaN(m)) m = 0;
            var y = r2.y + r2.h, 
                x = (m == Infinity || m == -Infinity) ? r2.x + (r2.w / 2) :  (y - b) / m,
                theta = Math.atan(m);

            if (_isOnEdge(r2, "x", "w", x)) {   
                var rise = _adj[s][1](r1, r2), 
                    hyp = rise / Math.sin(theta),
                    run = hyp * Math.cos(theta);
                return { left:run, top:rise };
            }           
            else {
                var run = _adj[s][0](r1, r2),
                    hyp = run / Math.cos(theta),
                    rise = hyp * Math.sin(theta);
                return { left:run, top:rise };
            }
        },            
        /*
        * Calculates how far to move r2 from r1 so that it no longer overlaps.
        * if origin is supplied, then it means we want r2 to move along a vector joining r2's center to that point. 
        * otherwise we want it to move along a vector joining the two rectangle centers.
        */
        _calculateSpacingAdjustment = Farahey.calculateSpacingAdjustment = function(r1, r2) {
            var c1 = r1.center || [ r1.x + (r1.w / 2), r1.y + (r1.h / 2) ],
                c2 = r2.center || [ r2.x + (r2.w / 2), r2.y + (r2.h / 2) ],
                m = geomSupport.gradient(c1, c2),
                s = geomSupport.quadrant(c1, c2),
                b = (m == Infinity || m == -Infinity || isNaN(m)) ? 0 : c1[1] - (m * c1[0]);                

            return _genAdj(r1, r2, m, b, s);        
        },    
        // calculate a padded rectangle for the given element with offset & size, and desired padding.
        _paddedRectangle = Farahey.paddedRectangle = function(o, s, p) {
            return { x:o[0] - p[0], y: o[1] - p[1], w:s[0] + (2 * p[0]), h:s[1] + (2 * p[1]) };
        },
        _magnetize = function(positionArray, positions, sizes, padding, 
            constrain, origin, filter,
            updateOnStep, stepInterval, stepCallback) 
        {                        
            origin = origin || [0,0];
            stepCallback = stepCallback || function() { };

            var focus = _paddedRectangle(origin, [1,1], padding),
                iterations = 100, iteration = 1, uncleanRun = true, adjustBy, constrainedAdjustment,
                _movedElements = {},
                _move = function(id, o, x, y) {
                    _movedElements[id] = true;
                    o[0] += x;
                    o[1] += y;
                },
                step = function() {
                    for (var i = 0; i < positionArray.length; i++) {
                        var o1 = positions[positionArray[i][1]],
                            oid = positionArray[i][1],
                            a1 = positionArray[i][2], // angle to node from magnet origin
                            s1 = sizes[positionArray[i][1]],
                            // create a rectangle for first element: this encompasses the element and padding on each
                            //side
                            r1 = _paddedRectangle(o1, s1, padding);
                        
                        if (filter(positionArray[i][1]) && geomSupport.intersects(focus, r1)) {
                            adjustBy = _calculateSpacingAdjustment(focus, r1);
                            constrainedAdjustment = constrain(positionArray[i][1], o1, adjustBy);
                            _move(oid, o1, constrainedAdjustment.left, constrainedAdjustment.top);
                        }

                        // now move others to account for this one, if necessary.
                        // reset rectangle for node
                        r1 = _paddedRectangle(o1, s1, padding);
                        for (var j = 0; j < positionArray.length; j++) {                        
                            if (i != j) {
                              var o2 = positions[positionArray[j][1]],
                                  a2 = positionArray[j][2], // angle to node from magnet origin
                                  s2 = sizes[positionArray[j][1]],
                                  // create a rectangle for the second element, again by putting padding of the desired
                                  // amount around the bounds of the element.
                                  r2 = _paddedRectangle(o2, s2, padding);
                        
                              // if the two rectangles intersect then figure out how much to move the second one by.
                                if (geomSupport.intersects(r1, r2)) {
                                    // TODO in 0.3, instead of moving neither, the other node should move.
                                    if (filter(positionArray[j][1])) {
                                        uncleanRun = true;                                                                          
                                        adjustBy =  _calculateSpacingAdjustment(r1, r2),
                                        constrainedAdjustment = constrain(positionArray[j][1], o2, adjustBy);
                                        _move(positionArray[j][1], o2, constrainedAdjustment.left, constrainedAdjustment.top);
                                    }
                                }
                            }
                        } 
                    }

                    if (updateOnStep)
                        stepCallback();

                    if (uncleanRun && iteration < iterations) {
                        uncleanRun = false;
                        iteration++;
                        if (updateOnStep) {
                            window.setTimeout(step, stepInterval);
                        }
                        else
                            step();
                    }
                };            

            step();       
            return _movedElements;             
        };


        /**
        * @name Magnetizer
        * @classdesc Applies repulsive magnetism to a set of elements relative to a given point, with a specified
        * amount of padding around the point.
        */

        /**
        * @name Magnetizer#constructor
        * @function
        * @param {Selector|Element} [container] Element that contains the elements to magnetize. Only required if you intend to use the `executeAtEvent` method.
        * @param {Function} [getContainerPosition] Function that returns the position of the container (as an object of the form `{left:.., top:..}`) when requested. Only required if you intend to use the `executeAtEvent` method.
        * @param {Function} getPosition A function that takes an element id and returns its position. It does not matter to which element this position is computed as long as you remain consistent with this method, `setPosition` and the `origin` property.
        * @param {Function} setPosition A function that takes an element id and position, and sets it. See note about offset parent above.
        * @param {Function} getSize A function that takes an element id and returns its size, in pixels.
        * @param {Integer[]} [padding] Optional padding for x and y directions. Defaults to 20 pixels in each direction.
        * @param {Function} [constrain] Optional function that takes an id and a proposed amount of movement in each axis, and returns the allowed amount of movement in each axis. You can use this to constrain your elements to a grid, for instance, or a path, etc.
        * @param {Integer[]} [origin] The origin of magnetization, in pixels. Defaults to 0,0. You can also supply this to the `execute` call.
        * @param {Selector|String[]|Element[]} elements List of elements on which to operate.
        * @param {Boolean} [executeNow=false] Whether or not to execute the routine immediately.
        * @param {Function} [filter] Optional function that takes an element id and returns whether or not that element can be moved.
        * @param {Boolean} [orderByDistanceFromOrigin=false] Whether or not to sort elements first by distance from origin. Can have better results but takes more time.
        */
        root.Magnetizer = function(params) {
            var getPosition = params.getPosition,
                getSize = params.getSize,
                getId = params.getId,
                setPosition = params.setPosition,
                padding = params.padding ||  [20, 20],
                // expects a { left:.., top:... } object. returns how far it can actually go.
                constrain = params.constrain || function(id, current, delta) { return delta; },
                positionArray = [],
                positions = {},
                sizes = {},
                elements = params.elements || [],
                origin = params.origin || [0,0],
                executeNow = params.executeNow,
                minx, miny, maxx, maxy,
                getOrigin = this.getOrigin = function() { return origin; },
                filter = params.filter || function(_) { return true; },
                orderByDistanceFromOrigin = params.orderByDistanceFromOrigin,
                comparator = new EntryComparator(origin, getSize),
                updateOnStep = params.updateOnStep,
                stepInterval = params.stepInterval || 350,
                originDebugMarker,
                debug = params.debug,
                createOriginDebugger = function() {
                    var d = document.createElement("div");
                    d.style.position = "absolute";
                    d.style.width = "10px";
                    d.style.height = "10px";
                    d.style.backgroundColor = "red";
                    document.body.appendChild(d);
                    originDebugMarker = d;
                },
                _addToPositionArray = function(p) {
                    if (!orderByDistanceFromOrigin || positionArray.length == 0)
                        positionArray.push(p);
                    else {
                        insertSorted(positionArray, p, comparator.compare);                   
                    }
                },
                _updatePositions = function() {
                    comparator.setOrigin(origin);
                    positionArray = []; positions = {}; sizes = {};
                    minx = miny = Infinity;
                    maxx = maxy = -Infinity;
                    for (var i = 0; i < elements.length; i++) {
                        var p = getPosition(elements[i]),
                            s = getSize(elements[i]),
                            id = getId(elements[i]);

                        positions[id] = [p.left, p.top];
                        _addToPositionArray([ [p.left, p.top], id, elements[i]]);
                        sizes[id] = s;
                        minx = Math.min(minx, p.left);
                        miny = Math.min(miny, p.top);
                        maxx = Math.max(maxx, p.left + s[0]);
                        maxy = Math.max(maxy, p.top + s[1]);
                    }
                },
                _run = function() {
                    if (elements.length > 1) {
                        var _movedElements = _magnetize(positionArray, positions, sizes, padding, constrain, origin, filter, updateOnStep, stepInterval, _positionElements);                        
                        _positionElements(_movedElements);
                    }
                },
                _positionElements = function(_movedElements) {
                    for (var i = 0; i < elements.length; i++) {
                        var id = getId(elements[i]);
                        if (_movedElements[id])
                            setPosition(elements[i], { left:positions[id][0], top:positions[id][1] });
                    }
                },
                setOrigin = function(o) {
                    if (o != null) {
                        origin = o;
                        comparator.setOrigin(o);
                    }            
                };

            /**
            * @name Magnetizer#execute
            * @function
            * @desc Runs the magnetize routine.
            * @param {Integer[]} [o] Optional origin to use. You may have set this in the constructor and do not wish to supply it, or you may be happy with the default of [0,0].
            */
            this.execute = function(o) {
                setOrigin(o);
                _updatePositions();
                _run();
            };            

            /**
            * @name Magnetizer#executeAtCenter
            * @function
            * @desc Computes the center of all the nodes and then uses that as the magnetization origin when it runs the routine.
            */
            this.executeAtCenter = function() {
                _updatePositions();
                setOrigin([
                    (minx + maxx) / 2,
                    (miny + maxy) / 2
                ]);
                _run();
            };

            /**
            * @name Magnetizer#executeAtEvent
            * @function
            * @desc Runs the magnetize routine using the location of the given event as the origin. To use this
            * method you need to have provided a `container`,  and a `getContainerPosition` function to the
            * constructor.
            * @param {Event} e Event to get origin location from.
            */
            this.executeAtEvent = function(e) {
                var c = params.container, 
                    o = params.getContainerPosition(c),
                    x = e.pageX - o.left + c[0].scrollLeft, 
                    y = e.pageY - o.top + c[0].scrollTop;

                if (debug) {
                    originDebugMarker.style.left = e.pageX + "px";
                    originDebugMarker.style.top = e.pageY + "px";
                }

                this.execute([x,y]);
            };

            /**
            * @name Magnetize#setElements
            * @function
            * @desc Sets the current list of elements.
            * @param {Object[]} _els List of elements, in whatever format the magnetizer is setup to use.
            */
            this.setElements = function(_els) {
                elements = _els;
            };


            if (debug)
                createOriginDebugger();

            if (executeNow) this.execute();

        };
}).call(this);        

