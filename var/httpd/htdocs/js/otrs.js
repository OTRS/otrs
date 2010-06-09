// --
// otrs.js - provides AJAX functions
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: otrs.js,v 1.19 2010-06-09 12:25:03 mg Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --


// create global name space
var Core = {};
var UI = {};

// init
Core.Init = function () {
    Core.ImagePreload( [OTRS.Config.Get('Images') + 'loading.gif'] );
}

// preload of loading image (to load it at page load time)
Core.ImagePreload = function(FieldName) {
    for (F=0;F<FieldName.length;F++) {
        ImagePreload = new Image();
        ImagePreload.src = FieldName[F];
    }
}

// update content element
Core.AJAXContentUpdate = function(Element, url, OnLoad, OnLoaded ) {

    // add sessionid if no cookies are used
    if ( !Core.Config.Get('SessionIDCookie') ) {
        url = url + '&' + Core.Config.Get('SessionName') + '=' + Core.Config.Get('SessionID') + '&' + Core.Config.Get('CustomerPanelSessionName') + '=' + Core.Config.Get('SessionID');
    }

    $.ajax({
        type:     'GET',
        url:      url,
        async:    true,
        dataType: 'html',
        success: function(Response) {
            if (!Response) {
                alert("ERROR: No content from: " + url);
            }
            if ( Element ) {
                if ( document.getElementById(Element) ) {
                    document.getElementById(Element).innerHTML = Response;
                }
                else {
                    alert("ERROR: No such element id: " + Element + " in page!");
                }
            }
        },
        beforeSend: OnLoad,
        complete:   OnLoaded,
        error:      function() {
            alert('ERROR: Something went wrong!')
        }
    });

    return true;
};


// update input and option fields
Core.AJAXUpdate = function(Subaction, Changed, Depend, Update) {
    var url = Core.AJAXURLGet(Subaction, Changed, Depend, Update);
    $.ajax({
        type:     'GET',
        url:      url,
        async:    true,
        dataType: 'json',
        success: function(Response) {
            if (!Response) {
                alert("ERROR: Invalid JSON from: " + url);
            }
            else {
                Core.AJAXUpdateItems(Response, Update);
            }
        },
        beforeSend: function() {
            Core.AJAXLoadingImage('Load', Update);
        },
        complete: function() {
            Core.AJAXLoadingImage('Unload', Update);
        },
        error:      function() {
            alert('ERROR: Something went wrong!')
        }
    });
    return true;
}

// generate requested url
Core.AJAXURLGet = function(Subaction, Changed, FieldName, FieldName2) {
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
    var url = Core.Config.Get('Baselink') + 'Action=' + Core.Config.Get('Action') + '&Subaction=' + Subaction + '&ElementChanged=' + Changed + ParamPart;

    // add sessionid if no cookies are used
    if ( !Core.Config.Get('SessionIDCookie') ) {
        url = url + '&' + Core.Config.Get('SessionName') + '=' + Core.Config.Get('SessionID') + '&' + Core.Config.Get('CustomerPanelSessionName') + '=' + Core.Config.Get('SessionID');
    }
    return url;
}

// update fields
Core.AJAXUpdateItems = function(ObjectRef, FieldName) {
    for (F=0;F<FieldName.length;F++) {

        // update form attributes
        if (document.compose[FieldName[F]]) {

            // update form options
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

            // update normal form input/textarea fields
            else {
                if (ObjectRef && ObjectRef[FieldName[F]]) {
                    document.compose[FieldName[F]].value = ObjectRef[FieldName[F]];
                }
            }
        }

        // update iframe

    }
    return true;
}

// show loading image
Core.AJAXLoadingImage = function(Type, FieldName) {
    for (F=0;F<FieldName.length;F++) {
        if (document.compose[FieldName[F]] && document.getElementById('AJAXImage' + FieldName[F])) {
            if (Type == 'Load') {
                document.getElementById('AJAXImage' + FieldName[F]).innerHTML="<img src=\"" + Core.Config.Get('Images') + "loading.gif\" border=\"0\">";
            }
            else {
                document.getElementById('AJAXImage' + FieldName[F]).innerHTML="";
            }
        }
    }
    return true;
}

// start ajax request and call a callback when ready
// AJAXFunctionCall({
//     Url: 'http://otrs-installation/index.pl?Action=...' - URL for Request, optional (otherwise Config is used)
//     Data: {name:'Value'} - JSON or Query String, optional
//     Callback: CallbackFunc - JS function pointer, optional (otherwise no callback is called)
// })
Core.AJAXFunctionCall = function(Param) {
    var Url, Data, Callback;

    // use parameter Url or build a fallback manually
    if ( Param['Url'] ) {
        Url = Param['Url'];
    }
    else {
        Url = Core.Config.Get('Baselink') + 'Action=' + Core.Config.Get('Action');
        // add sessionid if no cookies are used
        if ( !Core.Config.Get('SessionIDCookie') ) {
            Url = Url + '&' + Core.Config.Get('SessionName') + '=' + Core.Config.Get('SessionID') + '&' + Core.Config.Get('CustomerPanelSessionName') + '=' + Core.Config.Get('SessionID');
        }
    }

    // use parameter data, otherwise leave data empty
    if ( Param['Data'] ) {
        Data = Param['Data'];
    }
    else {
        Data = '';
    }

    if ( Param['Callback'] ) {
        Callback = Param['Callback'];
    }

    // if no Data is given, but a valid Url, than extract query string from url, because needs to be the Data parameter
    if ( Data == '' && Url ) {
        var Index = Url.indexOf("?");
        if ( Index >= 0 ) {
          Data = Url.substr(Index + 1);
          Url = Url.substr(0, Index);
        }
    }

    $.ajax({
        type:     'POST',
        url:      Url,
        data:     Data,
        dataType: 'json',
        success: function(Response) {
            if (!Response) {
                alert("ERROR: No content from: " + url);
            }
            // call the callback
            if (typeof Callback == 'function') {
                Callback(Response);
            }
            else {
                alert("ERROR: Invalid callback method: " + Callback.toString());
            }
        },
        error:      function() {
            alert('ERROR: Something went wrong!')
        }
    });
}

UI.Settings = function( Element1, Element2 ) {

    var Icon1 = document.getElementById(Element1);
    if ( !Icon1.style.display || Icon1.style.display == 'block' ) {
        $( '#' + Element1 ).slideUp('fast', function () {
            $('#' + Element2).slideDown('fast');
        });
    }
    else {
        $( '#' + Element2 ).slideUp('fast', function () {
            $('#' + Element1).slideDown('fast');
        });
    }

    return true;
}

UI.Sortable = function( Data ) {
    $(Data.Selector).sortable({
        placeholder: Data.Placeholder,
        forcePlaceholderSize: true,
        opacity: 0.6,
        cursor: 'move',
        handle: Data.Handle,
        update: function(event, ui) {
            var url = Data.UpdateURL;
            $(Data.UpdateOrder).each(
                function(i) {
                    url = url + ';' + Data.UpdateAttribute + '=' + $(this).attr(Data.UpdateValue);
                }
            );
            Core.AJAXContentUpdate('', url );
        }
    });
    return true;
}

UI.Accordion = function( Element1, Element2, Element3 ) {

    var Data = document.getElementById(Element1);
    var Icon1 = document.getElementById(Element2);
    var Icon2 = document.getElementById(Element3);

    // coplaps data
    if ( !Data.style.display || Data.style.display == 'block' ) {
        $( '#' + Element1 ).slideUp('normal', function () {

            // toggle icons
            if ( Icon1 && Icon2 ) {
                Icon1.style.display = '';
                Icon2.style.display = 'none';
            }
        });
    }
    // expand data
    else {
        $('#' + Element1).slideDown('normal', function () {

            // toggle icons
            if ( Icon1 && Icon2 ) {
                Icon1.style.display = 'none';
                Icon2.style.display = '';
            }
        });
    }

    return true;
}

UI.Dialog = function( Data ) {

    var Buttons = {};

    Buttons[Data.Translation.Submit] = function() {
        $(Data.Form).submit();
    };
    Buttons[Data.Translation.Cancel] = function() {
        $(Data.Dialog).dialog('close');
    };

    // on document ready
    $(Data.Document).ready( function() {

        // instantiate the dialog
        $(Data.Dialog).dialog( {
            autoOpen:   false,
            bgiframe:   true,
            width:      350,
            modal:      Data.Modal,
            draggable:  false,
            resizable:  false,
            title:      Data.Title,
            buttons:    Buttons
        } );

        // add event listener to show dialog
        $(Data.Selector).click(function() {
            $(Data.Dialog).dialog('open');
        } );

    } );

    return true;
}

