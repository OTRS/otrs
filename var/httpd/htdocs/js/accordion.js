var Dom = YAHOO.util.Dom;
var Event = YAHOO.util.Event;
var $ = function(id) {
      return document.getElementById(id);
}

//++++++++++++++++++++++++++++++++++++
// YUI ACCORDION
// 1/22/2008 - Edwart Visser
//
// accordion
//
// REQUIRES: yahoo-dom-event.js, animation-min.js
//
// TODO: build hover script for highlighting header in IE
// TODO: attach behaviour based on rel attribute
//++++++++++++++++++++++++++++++++++++

YAHOO.namespace("lutsr");

YAHOO.lutsr.accordion = {
    properties : {
        animation : true,
        animationDuration : 20,
        multipleOpen : false
    },

    init : function(animation,animationDuration,multipleOpen) {
        if(animation) {
            this.animation = animation;
        }
        if(animationDuration) {
            this.animationDuration = animationDuration;
        }
        if(multipleOpen) {
            this.multipleOpen = multipleOpen;
        }

        var accordionObjects = Dom.getElementsByClassName("accordion");

        if(accordionObjects.length > 0) {

            for(var i=0; i<accordionObjects.length; i++) {
//                if(accordionObjects[i].nodeName == "DIV") {
                    var headers = accordionObjects[i].getElementsByClassName("accordionhead");
//                    var bodies = headers[i].parentNode.getElementsByClassName("accordionbody");
                    var bodies = accordionObjects[i].getElementsByClassName("accordionbody");
//                }
                this.attachEvents(headers,bodies,i);
            }
        }
    },

    attachEvents : function(headers,bodies,nr) {
        for(var i=0; i<headers.length; i++) {
            var headerProperties = {
                objRef : headers[i],
                objRefBody : bodies[i],
                nr : i,
                jsObj : this
            }

            Event.addListener(headers[i],"click",this.clickHeader,headerProperties);
        }
    },

    clickHeader : function(e,headerProperties) {
        var parentObj = headerProperties.objRefBody.parentNode;
        var headers = parentObj.getElementsByClassName("accordionbody");
        var header = headers[headerProperties.nr];

        if(Dom.hasClass(header,"open")) {
            var icon = headerProperties.objRef.getElementsByClassName("accordion-expand-down")[0];
            icon.style.display = "block";
            var icon2 = headerProperties.objRef.getElementsByClassName("accordion-collapse-up")[0];
            icon2.style.display = "none";
            headerProperties.jsObj.collapse(header);
        } else {
            var icon = headerProperties.objRef.getElementsByClassName("accordion-expand-down")[0];
            icon.style.display = "none";
            var icon2 = headerProperties.objRef.getElementsByClassName("accordion-collapse-up")[0];
            icon2.style.display = "block";
            if(headerProperties.jsObj.properties.multipleOpen) {
                headerProperties.jsObj.expand(header);
            } else {
                for(var i=0; i<headers.length; i++) {
                    if(Dom.hasClass(headers[i],"open")) {
                        headerProperties.jsObj.collapse(headers[i]);
                    }
                }
                headerProperties.jsObj.expand(header);
            }
        }
    },

    collapse : function(header) {
        Dom.removeClass(Dom.getPreviousSibling(header),"selected");
        if(!this.properties.animation) {
            Dom.removeClass(header,"open");
        } else {
            this.initAnimation(header,"close");
        }
    },
    expand : function(header) {
        Dom.addClass(Dom.getPreviousSibling(header),"selected");
        if(!this.properties.animation) {
            Dom.addClass(header,"open");
        } else {
            this.initAnimation(header,"open");
        }
    },

    initAnimation : function(header,dir) {
        if(dir == "open") {
            Dom.setStyle(header,"visibility","hidden");
            Dom.setStyle(header,"height","auto");
            Dom.addClass(header,"open");
            var attributes = {
                height : {
                    from : 0,
                    to : header.offsetHeight
                }
            }
            Dom.setStyle(header,"height",0);
            Dom.setStyle(header,"visibility","visible");

            var animation = new YAHOO.util.Anim(header,attributes);
            animationEnd = function() {
                // leave it here
            }
            animation.duration = this.properties.animationDuration;
            animation.useSeconds = false;
            animation.onComplete.subscribe(animationEnd);
            animation.animate();
        } else if ("close") {
            var attributes = {
                height : {
                    to : 0
                }
            }
            animationEnd = function() {
                Dom.removeClass(header,"open");
            }
            var animation = new YAHOO.util.Anim(header,attributes);
            animation.duration = this.properties.animationDuration;
            animation.useSeconds = false;
            animation.onComplete.subscribe(animationEnd);
            animation.animate();
        }
    }
}

initPage = function() {
    YAHOO.lutsr.accordion.init();
}

Event.on(window,"load",initPage);
