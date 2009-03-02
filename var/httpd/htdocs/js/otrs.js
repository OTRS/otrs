// --
// AJAX.dtl - provides AJAX functions
// Copyright (C) 2001-2009 OTRS AG, http://otrs.org/\n";
// --
// $Id: otrs.js,v 1.1 2009-03-02 23:45:25 martin Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

// create global OTRS name space
var OTRS = {};
var OTRSConfig = {};

// config settings
OTRS.ConfigGet = function (Key) {
    return OTRSConfig[Key];
};
OTRS.ConfigSet = function (Key, Value) {
    OTRSConfig[Key] = Value;
};

// update input and option fields
function AJAXUpdate(Subaction, Changed, Depend, Update) {
    var url = AJAXURLGet(Subaction, Changed, Depend, Update);
    new Ajax.Request(url,
        {
            method:'get',
            onLoading: function() {
               AJAXLoadingImage('Load', Update);
            },
            onLoaded: function() {
               AJAXLoadingImage('Unload', Update);
            },
            onSuccess: function(transport) {
                var Response = transport.responseText;
                if (!Response) {
                    alert("ERROR: No content from: " + url);
                }
                var ObjectRef= Response.evalJSON();
                if (ObjectRef) {
                    AJAXUpdateItems(ObjectRef, Update);
                }
                else {
                    alert("ERROR: Invalid JSON: " + Response);
                }
            },
            onFailure: function() {
                alert('ERROR: Something went wrong!')
            }
        }
    );
}

// generate requested url
function AJAXURLGet (Subaction, Changed, FieldName, FieldName2) {
    var ParamPart = '';

    // check if we need to fill some not used fields for Update
    for (F2=0;F2<FieldName2.length;F2++) {
        var Hit = 0;
        for (F=0;F<FieldName.length;F++) {
            if ( FieldName[F] == FieldName2[F2] ) {
                Hit = 1;
            }
        }
        if ( Hit == 0 ) {
            FieldName.push(FieldName2[F2]);
        }
    }

    // build url based on depends
    for (F=0;F<FieldName.length;F++) {
        if (document.compose[FieldName[F]]) {
            var Param = document.compose[FieldName[F]].value;
            var ParamEncode = encodeURIComponent(Param);
            ParamPart = ParamPart + '&' + FieldName[F] + '=' + ParamEncode;
        }
    }
    var url = OTRS.ConfigGet('Baselink') + 'Action=' + OTRS.ConfigGet('Action') + '&Subaction=' + Subaction + '&ElementChanged=' + Changed + ParamPart;

    // add sessionid if no cookies are used
    if ( !OTRS.ConfigGet('SessionIDCookie') ) {
        url = url + '&' + OTRS.ConfigGet('SessionName') + '=' + OTRS.ConfigGet('SessionID') + '&' + OTRS.ConfigGet('CustomerPanelSessionName') + '=' + OTRS.ConfigGet('SessionID');
    }
    return url;
}

// update fields
function AJAXUpdateItems (ObjectRef, FieldName) {
    for (F=0;F<FieldName.length;F++) {
        if (document.compose[FieldName[F]]) {
            if ( document.compose[FieldName[F]].options ) {
                var Length = document.compose[FieldName[F]].length;
                for(i=0; i<=Length; i++) {
                    document.compose[FieldName[F]].options[0] = null;
                }
                if (ObjectRef) {
                    var List = ObjectRef[FieldName[F]];
                    if (List) {
                        for (var i = 0; i < List.length; i++) {
                            document.compose[FieldName[F]].options[i] = new Option(List[i][1],List[i][0],List[i][2],List[i][3]);

                            // overwrite option text, because of wrong html quoting of text content
                            document.compose[FieldName[F]].options[i].innerHTML = List[i][1];
                        }
                    }
                }
            }
            else {
                if (ObjectRef && ObjectRef[FieldName[F]]) {
                    document.compose[FieldName[F]].value = ObjectRef[FieldName[F]];
                }
            }
        }
    }
    return true;
}

// show loading image
function AJAXLoadingImage (Type, FieldName) {
    for (F=0;F<FieldName.length;F++) {
        if (document.compose[FieldName[F]] && document.getElementById('AJAXImage' + FieldName[F])) {
            if (Type == 'Load') {
                document.getElementById('AJAXImage' + FieldName[F]).innerHTML="<img src=\"" + OTRS.ConfigGet('Images') + "loading.gif\" border=\"0\">";
            }
            else {
                document.getElementById('AJAXImage' + FieldName[F]).innerHTML="";
            }
        }
    }
    return true;
}

// preload of loading image (to load it at page load time)
function AJAXLoadingImagePreload (FieldName) {
    for (F=0;F<FieldName.length;F++) {
        ImagePreload = new Image();
        ImagePreload.src = FieldName[F];
    }
}
AJAXLoadingImagePreload( [OTRS.ConfigGet('Images') + 'loading.gif'] );

