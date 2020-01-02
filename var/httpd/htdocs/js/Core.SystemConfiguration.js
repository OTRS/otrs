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

/**
 * @namespace Core.SystemConfiguration
 * @memberof Core
 * @author OTRS AG
 * @description
 *      This namespace contains the special functions for SystemConfiguration module.
 */
 Core.SystemConfiguration = (function (TargetNS) {

    var ValueTypes = new Array();

    /**
     * @private
     * @name SerializeData
     * @memberof Core.SystemConfiguration
     * @function
     * @returns {String} query string of the data
     * @param {Object} Data - The data that should be converted.
     * @description
     *      Converts a given hash into a query string.
     */
    function SerializeData(Data) {
        var QueryString = '';
        $.each(Data, function (Key, Value) {
            QueryString += ';' + encodeURIComponent(Key) + '=' + encodeURIComponent(Value);
        });
        return QueryString;
    }

    /**
    * @name Init
    * @memberof Core.SystemConfiguration
    * @function
    * @description
    *      This function initializes module functionality.
    */
    TargetNS.Init = function () {
        var Index,
            Type;

        $("button.RemoveButton").on("click", function() {
            $(this).blur();
            TargetNS.RemoveItem($(this));
        });

        $("button.AddArrayItem").on("click", function() {
            $(this).blur();
            TargetNS.AddArrayItem($(this));
        });
        $("button.AddHashKey").on("click", function() {
            $(this).blur();
            TargetNS.AddHashKeyClick($(this));
        });

        $("a.ResetSetting").on("click", function() {
            Core.Agent.Admin.SystemConfiguration.InitDialogReset($(this));
            return false;
        });

        $("a.RevertToHistoricalValue").on("click", function() {
            TargetNS.RevertToHistoricalValue($(this));
            return false;
        });

        $("input:checkbox").on("click", function() {
            TargetNS.CheckboxValueSet($(this));
        });

        // Init short cuts
        $('.WidgetSimple.Setting').on('keydown', 'input, select, checkbox', function(Event) {

            var $WidgetObj = $(this).closest('.WidgetSimple.Setting');

            if (!Event) {
                return false;
            }

            if ($WidgetObj.hasClass('IsLockedByMe')) {

                // Enter: Save current setting
                if (Event.keyCode && Event.keyCode === 13) {

                    if ($(this).hasClass('Key')) {
                        $(this).closest('.HashItem').find('button.AddKey').trigger('click');
                    }
                    else {
                        $WidgetObj.find('button.Update').trigger('click');
                    }

                    return false;
                }

                // Esc: Cancel editing
                else if (Event.keyCode && Event.keyCode === 27) {
                    $WidgetObj.find('button.Cancel').trigger('click');
                }
            }
        });

        TargetNS.InitButtonVisibility();


        // init ValueTypes
        for (Index in window["Core"]["SystemConfiguration"]) {
            Type = typeof window["Core"]["SystemConfiguration"][Index];
            if (Type != "function") {
                ValueTypes.push(Index);
            }
        }

        Core.App.Subscribe('SystemConfiguration.SettingListUpdate', function() {

            // check if we need to disable editAll/SaveAll
            if (!$('.WidgetSimple.Setting:visible').length) {
                $('#EditAll, #SaveAll, #CancelAll').prop('disabled', true).addClass('Disabled');
            }
            else {
                $('#EditAll, #SaveAll, #CancelAll').prop('disabled', false).removeClass('Disabled');
            }

            if (!$('.WidgetSimple.Setting.IsLockedByMe:visible').length) {
                $('#SaveAll, #CancelAll').prop('disabled', true).addClass('Disabled');
            }
            else {
                $('#SaveAll, #CancelAll').prop('disabled', false).removeClass('Disabled');
            }
        });

        Core.UI.Table.InitTableFilter($("#FilterUsers"), $("#Users"));

        // Define endsWith() method if a browser has no support for it, e.g. IE11 (see bug#14845).
        if (typeof String.prototype.endsWith === 'undefined') {
            String.prototype.endsWith = function(search, this_len) {
                if (this_len === undefined || this_len > this.length) {
                    this_len = this.length;
                }
                return this.substring(this_len - search.length, this_len) === search;
            };
        }
    };


    /**
     * @public
     * @name InitConfigurationTree
     * @memberof Core.SystemConfiguration
     * @function
     * @param {String} RedirectAction - Action parameter for next http request.
     * @param {String} Category - If a category should be considered when the tree is rendered (category key)
     * @param {String} UserModificationActive - Limit to settings that can be modified by users.
     * @returns {Boolean} - redirect
     * @description
     *      This function initializes Configuration Tree
     */
    TargetNS.InitConfigurationTree = function(RedirectAction, Category, UserModificationActive) {

        var Data = {
            Action    : 'AdminSystemConfiguration',
            Subaction : 'AJAXNavigationTree',
            Category  : Category || $('#Category').val(),
            UserModificationActive : UserModificationActive
        };

        if (Core.Config.Get('Action') == 'AgentPreferences') {
            Data.Action = 'AgentPreferences';
        }

        // if there are only the base categories available, hide the selection
        // and use 'All' as default.
        if ($('#Category option').length <= 2) {
            $('.SystemConfigurationCategories').hide();
            $('.SystemConfigurationCategories').next('.CallForAction').hide();
            $('#Category').val('All').trigger('change');
            Data["Category"] = 'All';
        }

        $('#ConfigTree').on('click', '.OpenNodeInNewWindow', function(Event) {
            window.open(Core.Config.Get('CGIHandle') + '?Action=AdminSystemConfigurationGroup;RootNavigation=' + $(this).data('node'), '_blank');
            Event.preventDefault;
            return false;
        });

        if (Core.Config.Get('Action') == 'AgentPreferences') {
            Data["IsValid"] = 1;
        }

        if (!$('#ConfigTree').length) {
            return false;
        }

        Core.AJAX.FunctionCall(
            Core.Config.Get('CGIHandle'),
            Data,
            function (HTML) {

                var Group,
                    SelectedNode = $('#SelectedNode').val(),
                    Data = {
                        'Action' : RedirectAction
                    };

                if ($('#ConfigTree').hasClass('jstree')) {
                    $('#ConfigTree').jstree('destroy');
                    $('#ConfigTree').empty();
                }

                $('#ConfigTree').html(HTML);

                $('#ConfigTree')
                    .jstree({
                        core: {
                            multiple: false,
                            animation: 70,
                            themes: {
                                name: 'InputField',
                                variant: 'Tree',
                                icons: false,
                                dots: false,
                                url: false
                            }
                        },
                        search: {
                            show_only_matches: true,
                            show_only_matches_children: true
                        },
                        plugins: [ 'search', 'wholerow' ]
                    })
                    .on('after_open.jstree', function (Node, Selected, Event) {  //eslint-disable-line no-unused-vars
                        Core.UI.InitStickyElement();
                    })
                    .on('after_close.jstree', function (Node, Selected, Event) {  //eslint-disable-line no-unused-vars
                        Core.UI.InitStickyElement();
                    })
                    .on('hover_node.jstree', function (Node, Selected, Event) {  //eslint-disable-line no-unused-vars
                        $('#ConfigTree #' + Core.App.EscapeSelector(Selected.node.id)).children('a').append('<span class="OpenNodeInNewWindow" title="' + Core.Language.Translate('Open this node in a new window') + '" data-node="' + Selected.node.id + '"><i class="fa fa-external-link"></i></span>').find('.OpenNodeInNewWindow').fadeIn();
                    })
                    .on('dehover_node.jstree', function (Node, Selected, Event) {  //eslint-disable-line no-unused-vars
                        $('#ConfigTree #' + Core.App.EscapeSelector(Selected.node.id)).find('.OpenNodeInNewWindow').remove();
                    });

                if (SelectedNode) {
                    $('#ConfigTree').jstree('select_node', Core.App.EscapeHTML(SelectedNode));
                }

                $('#ConfigTree')
                    .on('select_node.jstree', function (Node, Selected, Event) {  //eslint-disable-line no-unused-vars

                        $('.ContentColumn').html(Core.Template.Render("Agent/WidgetLoading"));

                        Data["RootNavigation"] = Selected.node.id;
                        Group = $("input#Group").val();
                        if (Group != "") {
                            Data["Subaction"] = "Group";
                            Data["Group"] = Group;
                        }
                        Data.Category = $('#Category').val();

                        // check if another user is being edited
                        if ($('#CurrentUserID').val()) {
                            Data.EditUserID = parseInt($('#CurrentUserID').val(), 10);
                        }

                        // Show settings.
                        SettingList(Selected.selected[0]);

                        return false;
                    }
                );

                $("#ConfigTreeSearch").on('keyup keydown', function() {
                    $('#ConfigTree').jstree('search', $(this).val());
                });
            }, 'html'
        );
    };

    /**
     * @public
     * @name Update
     * @memberof Core.SystemConfiguration
     * @function
     * @param {jQueryObject} $Object - jquery object.
     * @param {Boolean} ToggleValid - toggle ValidID
     * @param {Boolean} ToggleUserModification - toggle UserModificationActive
     * @description
     *      This function updates the setting.
     */
    TargetNS.Update = function ($Object, ToggleValid, ToggleUserModification) {
        var
            URL,
            Data = {},
            Action,
            Key,
            Value,
            $Widget = $Object.closest(".WidgetSimple"),
            SettingName = $Widget.find("input[name='SettingName']").val(),
            ValidationError,
            IsValid,
            UserModificationActive,
            Item,
            $InvalidElement;

        // if there are still hash items within the current Widget
        // for which a key field has been added but no value has been
        // added, hinder the user from saving the setting
        if ($Widget.find('button.AddKey:visible').length) {
            alert(Core.Language.Translate('Please add values for all keys before saving the setting.'));
            return;
        }

        CheckIDs($Widget);

        $Widget
            .find('form')
            .find('input:not(:checkbox):not(:file):not([name=SettingName]):not(.Key):not(.InputField_Search),' +
                ' textarea, select, div.Array, div.Hash, .AddArrayItem, .AddHashKey, div.WorkingHoursItem input')
            .filter(':not([disabled=disabled])')
            .each(function () {

            var FullName = $(this).attr('id'),
                Value,
                $Container,
                ValueType;

            if($(this).hasClass("hasDatepicker")) {
                return;
            }

            if ($(this).is('div')) {
                return;
            }

            // run element validation
            if (!Core.Form.Validate.ValidateElement($(this))) {

                // Highlight error
                ValidationError = 1;
                Core.Form.Validate.HighlightError(this, "Error");
                $(this).on("change", function() {
                    Core.Form.Validate.UnHighlightError(this);
                });

                // Continue, check for other errors as well.
                return;
            }

            // check ValueType
            for (Item in ValueTypes) {
                if ($(this).hasClass(ValueTypes[Item])) {
                    ValueType = ValueTypes[Item];
                    break;
                }
            }

            // get value
            if ($(this).hasClass("AddArrayItem")) {
                $Container = $(this).closest(".Array");
                // check if array is empty
                if ($Container.find("> .ArrayItem").length == 0) {
                    if ($Container.hasClass("VacationDaysArray")
                        || $Container.hasClass("VacationDaysOneTimeArray")
                    ) {
                        Value = {};
                    }
                    else {
                        Value = [];
                    }

                    FullName = SettingName + $(this).attr("data-suffix");
                    FullName = FullName.substr(0, FullName.lastIndexOf("_Array"));
                }
                else {
                    // Array is not empty.
                    return;
                }
            }
            else if ($(this).hasClass("AddHashKey")) {
                // check if array is empty
                if ($(this).closest(".Hash").find("> .HashItem > .SettingContent").length == 0) {
                    Value = {};
                    FullName = SettingName + $(this).attr("data-suffix");
                    FullName = FullName.substr(0, FullName.lastIndexOf("_Hash"));
                }
                else {
                    // Hash is not empty.
                    return;
                }
            }
            else if (ValueType != null) {
                // Run dedicated ValueGet() for this ValueType (in a Core.SystemConfiguration.ValueTypeX.js).
                Value = window["Core"]["SystemConfiguration"][ValueType]["ValueGet"]($(this));
                if (Value == null) {
                    return;
                }
            }
            else if ($(this).is('select')) {
                Value = $(this).find('option:selected').val();
            }
            else if (Value === undefined) {
                Value = $(this).val();
            }

            if($(this).parent().parent().hasClass("HashItem")) {
                // update key name
                Key = $(this).parent().parent().find(".Key").val();

                FullName = FullName.substr(0, FullName.lastIndexOf("###"));
                FullName += "###" + Key;
            }

            Data[SettingName] = ValueSet(Data[SettingName], FullName, Value);
        });

        if (ValidationError) {
            $InvalidElement = $Widget.find('.Error:first');

            $('html, body').animate({scrollTop: $InvalidElement.offset().top -100 }, 'slow');

            // Focus first error element.
            $InvalidElement.focus();

            return;
        }

        Value = {
            EffectiveValue: Core.JSON.Stringify(Data[SettingName])
        };

        // show loader
        Core.UI.WidgetOverlayShow($Widget, 'Loading');

        if (Core.Config.Get('Action') == 'AgentPreferences') {
            Action = 'AgentPreferences';
        }
        else {
            Action = 'AdminSystemConfigurationGroup';
        }

        URL = Core.Config.Get('Baselink') +
            'Action=' + Action +
            ';Subaction=SettingUpdate;' +
            'SettingName=' + encodeURIComponent(SettingName) +
            ';ChallengeToken=' + Core.Config.Get('ChallengeToken');

        if (ToggleValid) {
            IsValid = 0;
            if ($Widget.find(".SettingDisabled:visible").length || $Widget.find(".SettingEnable:visible").length) {
                IsValid = 1;
            }

            URL += ';IsValid=' + IsValid;
        }

        if (ToggleUserModification) {
            UserModificationActive = 0;
            if ($Widget.find(".UserModificationNotActive:visible").length) {
                UserModificationActive = 1;
            }

            URL += ';UserModificationActive=' + UserModificationActive;
        }

        Core.AJAX.FunctionCall(
            URL,
            Value,
            function(Response) {
                var LinkURL = 'Action=AdminSystemConfigurationDeployment;Subaction=Deployment';

                TargetNS.CleanWidgetClasses($Widget);
                TargetNS.SettingRender(Response, $Widget);

                if (Response.Data.SettingData.IsDirty) {
                    if (Core.Config.Get('SessionUseCookie') === '0') {
                        LinkURL += ';' + Core.Config.Get('SessionName') + '=' + Core.Config.Get('SessionID');
                    }

                    Core.UI.ShowNotification(
                        Core.Language.Translate('You have undeployed settings, would you like to deploy them?'),
                        'Notice',
                        LinkURL,
                        function() {
                            Core.UI.InitStickyElement();
                        }
                    );
                }
                else if (Response.Data.DeploymentNeeded == 0) {
                    Core.UI.HideNotification(
                        Core.Language.Translate('You have undeployed settings, would you like to deploy them?'),
                        'Notice',
                        function() {
                            Core.UI.InitStickyElement();
                        }
                    );
                }

                Core.UI.WidgetOverlayHide($Widget, Response.Data.Error === undefined);
            }
        );
    }

    /**
     * @private
     * @name ValueSet
     * @memberof Core.SystemConfiguration
     * @function
     * @param {Object} Data - existing resulting object
     * @param {String} Name - setting name.
     * @param {Object} Value - subvalue that will be merged to the Data.
     * @returns {Object} - updated Data.
     * @description
     *      This function merges complex Value to the already existing Data
     *      (used for complex structures like AoH, etc)
     */
    function ValueSet(Data, Name, Value) {
        var Result = Data,
            StructureArray = Name.split(/_(?=Array|Hash)/),
            HashKey,
            SettingName = StructureArray.shift(),
            Structure,
            ArrayIndex,
            SubName,
            RemoveIndexes = [],
            Item;

        if (StructureArray.length) {
            Structure = StructureArray.shift();

            if (Structure.match(/Array\d+/)) {
                // contains array, check index

                ArrayIndex = Structure.match(/\d+/)[0];
                ArrayIndex--;

                if (Result === undefined) {
                    Result = [];
                }

                while(Result.length < ArrayIndex) {
                    RemoveIndexes.push(Result.length);  // mark index for removal
                    Result.push("");                    // temporary push empty value, we will remove it later
                }

                if (StructureArray.length == 0) {
                    // last item in the Structure

                    Result.push(Value);
                }
                else {
                    // start recursion
                    SubName =  StructureArray.join("_");
                    if (SubName != "") {
                        SubName = "_" + SubName;
                    }
                    SubName = SettingName + SubName;

                    if (Result.length < ArrayIndex) {
                        Result.push(ValueSet(undefined, SubName, Value));
                    }
                    else {
                        Result[ArrayIndex] = ValueSet(Result[ArrayIndex], SubName, Value);
                    }
                }

                // delete array elements that are not used
                if (RemoveIndexes.length) {
                    RemoveIndexes.reverse();

                    for(ArrayIndex in RemoveIndexes) {
                        Result.splice(RemoveIndexes[ArrayIndex], 1);
                    }
                }

            }
            else if (Structure.match(/Hash/)) {
                // contains hash

                HashKey = Structure.match(/###(.*?)$/)[1];
                if (Result === undefined) {
                    Result = {};
                }

                if (StructureArray.length == 0) {
                    // last item in the Structure

                    Result[HashKey] = Value;
                }
                else {
                    // start recursion
                    SubName =  StructureArray.join("_");
                    if (SubName != "") {
                        SubName = "_" + SubName;
                    }
                    SubName = SettingName + SubName;

                    if (Result[HashKey] === undefined) {
                        Result[HashKey] = ValueSet(undefined, SubName, Value);
                    }
                    else {
                        Result[HashKey] = ValueSet(Result[HashKey], SubName, Value);
                    }
                }
            }
            else {
                // scalar value
                Result = Value;
            }
        }
        else {
            if ($.isArray(Value)) {
                // Value is array
                if (Result === undefined) {
                    Result = [];
                }

                for (Item in Value) {
                    Result.push(ValueSet(Result[Item], "", Value[Item]));
                }

            }
            else if (typeof Value == "object") {
                // Value is object
                if (Result === undefined) {
                    Result = {};
                }

                for (Item in Value) {
                    Result[Item] = ValueSet(Result[Item], "", Value[Item]);
                }
            }
            else {
                // scalar
                Result = Value;
            }
        }
        return Result;
    }

    /**
     * @public
     * @name RemoveItem
     * @memberof Core.SystemConfiguration
     * @function
     * @param {jQueryObject} $Object - jquery object.
     * @description
     *      Remove complete item from the array/hash
     */
    TargetNS.RemoveItem = function ($Object) {
        var $Div = $Object.closest(".Array, .Hash");

        $Object.closest("div")
            .remove();

        CheckMinItems($Div);
        CheckMaxItems($Div);
    }

    /**
     * @public
     * @name AddArrayItem
     * @memberof Core.SystemConfiguration
     * @function
     * @param {jQueryObject} $Object - jquery object.
     * @description
     *      Add new item to the array
     */
    TargetNS.AddArrayItem = function ($Object) {
        var
            Data = 'Action=AdminSystemConfigurationGroup;Subaction=AddArrayItem;',
            $Widget = $Object.closest(".WidgetSimple"),
            $SettingName = $Widget.find("input[name='SettingName']"),
            IDSuffix = $Object.attr("data-suffix"),
            Structure = StructureGet($Object);

        // return if another AJAX call is already started
        if ($Widget.find(".AJAXLoader:visible").length > 0) {
            return;
        }

        Data += 'SettingName=' + encodeURIComponent($SettingName.val()) + ';';
        Data += 'IDSuffix=' + encodeURIComponent(IDSuffix) + ';';
        Data += 'Structure=' + encodeURIComponent(Structure) + ';';

        // show loader
        Core.UI.WidgetOverlayShow($Widget, 'Loading');

        Core.AJAX.FunctionCall(
            Core.Config.Get('Baselink'),
            Data,
            function(Response) {
                var Suffix = $Object.attr("data-suffix"),
                    SuffixID = Suffix.match(/\d+$/)[0],
                    $Array = $Object.parent(),
                    RemoveButton,
                    Key = "",
                    ElementSuffix;

                if (Response.Error) {
                    alert(Response.Error);
                    $Widget.find(".AJAXLoader").hide();
                    return;
                }

                if (Response.Item) {
                    $Object.before(
                        Core.Template.Render("SysConfig/AddArrayItem")
                    );
                    $Array.find(".ArrayItem:last").append(Response.Item);

                    // Add remove button(s)
                    RemoveButton = Core.Template.Render("SysConfig/RemoveButton");

                    $Array.find("> .ArrayItem:last, > .ArrayItem:last .ArrayItem")
                        .append(RemoveButton);

                    $Array.find("> .ArrayItem:last .RemoveButton")
                        .show()
                        .on("click",function() {
                            TargetNS.RemoveItem($(this).closest("div"));
                    });

                    // add buttons
                    $Array.find("> .ArrayItem:last .Array,> .ArrayItem:last .Hash").each(function() {
                        var Count = 0,
                            Suffix = [],
                            $Element = $(this),
                            $HashItem = $(this).closest(".HashItem");

                        if ($HashItem.length) {
                            Key = $HashItem.find(".Key").val();
                        }

                        while (!$Array.is($Element)) {

                            Count = $Element.find(
                                "> .Array > .ArrayItem, > .Hash > .HashItem, > .ArrayItem, > .HashItem"
                            ).length;
                            Count++;

                            if ($Element.hasClass("Array")) {
                                // array
                                Suffix.push("_Array" + Count);
                            }
                            else {
                                // hash
                                Suffix.push("_Hash###" + Key);
                            }

                            $Element = $Element.parent().closest(".Hash, .Array");
                        }
                        // Remove first item, since it is already included in the IDSuffix
                        Suffix.shift();

                        ElementSuffix = IDSuffix + Suffix.join("");

                        $(this).find("> .ArrayItem:last").after(
                            Core.Template.Render("SysConfig/AddButton", {
                                Suffix : ElementSuffix + "_Array" + Count,
                                Class: 'AddArrayItem'
                            })
                        );

                        $(this).find("> .HashItem:last").after(
                            Core.Template.Render("SysConfig/AddButton", {
                                Suffix : ElementSuffix + "_Hash###",
                                Class: 'AddHashKey'
                            })
                        );

                        $(this).find("> button.AddArrayItem")
                            .show()
                            .off("click")
                            .on("click", function() {
                                TargetNS.AddArrayItem($(this));
                        });

                        $(this).find("button.AddKey")
                            .show()
                            .off("click")
                            .on("click", function() {
                                AddHashKey($(this));
                        });
                        $(this).find("> button.AddHashKey")
                            .show()
                            .off("click")
                            .on("click", function() {
                                TargetNS.AddHashKeyClick($(this));
                        });
                    });

                    Core.UI.InputFields.InitSelect(
                        $Array.find("> .ArrayItem:last .Modernize")
                    );

                    $Array.find("> .ArrayItem:last input:checkbox").on("change", function () {
                        TargetNS.CheckboxValueSet($(this));
                    });
                }

                CheckMinItems($Object);
                CheckMaxItems($Object);


                // increment and replace suffix id
                SuffixID++;
                Suffix = Suffix.replace(/\d+$/, SuffixID);
                $Object.attr("data-suffix", Suffix);

                Core.UI.WidgetOverlayHide($Widget);
            }
        );
    }

    /**
     * @public
     * @name AddHashKeyClick
     * @memberof Core.SystemConfiguration
     * @function
     * @param {jQueryObject} $Object - jquery object.
     * @description
     *      Handle add new hash key
     */
    TargetNS.AddHashKeyClick = function ($Object) {
        var $Widget = $Object.closest(".WidgetSimple"),
            RemoveButton = Core.Template.Render("SysConfig/RemoveButton");

        // return if another item is currently being added
        if ($Widget.find(".AJAXLoader:visible").length > 0) {
            return;
        }

        Core.UI.WidgetOverlayShow($Widget, 'Loading');

        $Object.before(Core.Template.Render("SysConfig/AddHashKey", {
            'IDSuffix' : $Object.attr("data-suffix")
        }));

        $Object
            .closest("div")
            .find("button.AddKey:last")
            .off("click")
            .on("click", function() {
                AddHashKey($(this));
            })
            .after(RemoveButton);

        $Object
            .closest("div")
            .find("button.RemoveButton:last").on("click",function() {
                TargetNS.RemoveItem($(this).closest("div"));
            });

        CheckMinItems($Object);
        CheckMaxItems($Object);

        Core.UI.WidgetOverlayHide($Widget);
    }

    /**
     * @private
     * @name AddHashKey
     * @memberof Core.SystemConfiguration
     * @function
     * @param {jQueryObject} $Object - jquery object.
     * @description
     *      Add new hash key
     */
    function AddHashKey($Object) {
        /* Needs to be an AJAX call */

        var
            $Widget = $Object.closest(".WidgetSimple"),
            $HashItem = $Object.parent(),
            $KeyElement = $HashItem.find(".Key"),
            Key = $KeyElement.val(),
            Name = $Widget.find("input[name='SettingName']").val(),
            Data = 'Action=AdminSystemConfigurationGroup;Subaction=AddHashKey;',
            IDSuffix = $KeyElement.attr("data-suffix") + Key,
            Structure = StructureGet($Object);

        if ($Widget.find(".AJAXLoader:visible").length > 0) {
            return;
        }

        if (!$KeyElement.val()) {
            alert(Core.Language.Translate('The key must not be empty.'));
            return;
        }

        // Check if hash already contains same Key
        if ($HashItem.closest(".Hash").find("> .HashItem >.Key").filter(function() {
                return $(this).val() === Key;
            }).length > 1) {

            alert(Core.Language.Translate("A key with this name ('%s') already exists.", Key));
            return;
        }

        Data += 'Key=' + encodeURIComponent(Key) + ';';
        Data += 'SettingName=' + encodeURIComponent(
            $Widget.find("input[name='SettingName']").val()
        );
        Data += ';IDSuffix=' + encodeURIComponent(IDSuffix) + ';';
        Data += 'Structure=' + encodeURIComponent(Structure) + ';';

        // show loader
        Core.UI.WidgetOverlayShow($Widget, 'Loading');

        Core.AJAX.FunctionCall(
            Core.Config.Get('Baselink'),
            Data,
            function(Response) {
                var $Hash = $Object.closest(".Hash"),
                    RemoveButton,
                    Key = "";

                if (Response.Error) {
                    alert(Response.Error);
                    $Widget.find(".AJAXLoader").hide();
                    return;
                }

                if (Response.Item) {
                    // Set input key name
                    $HashItem.find("input").attr("name", Name + "Key[]");

                    // Remove button
                    $HashItem.find("button.AddKey").remove();

                    // Add new input for hash value
                    $HashItem.append(Response.Item);

                    // Add remove button(s)
                    RemoveButton = Core.Template.Render("SysConfig/RemoveButton");
                    $HashItem.append(RemoveButton);

                    $HashItem.find(".ArrayItem")
                        .append(RemoveButton);

                    $HashItem.find(".RemoveButton")
                        .show()
                        .on("click",function() {
                            TargetNS.RemoveItem($(this).closest("div"));
                    });

                    // add buttons
                    $HashItem.find(".Array, .Hash").each(function() {
                        var Count = 0,
                            Suffix = [],
                            $Element = $(this),
                            $ClosestHashItem = $(this).closest(".HashItem"),
                            ElementSuffix;

                        if ($ClosestHashItem.length) {
                            Key = $ClosestHashItem.find(".Key").val();
                        }

                        while (!$Hash.is($Element)) {

                            Count = $Element.find(
                                "> .Array > .ArrayItem, > .Hash > .HashItem, > .ArrayItem, > .HashItem"
                            ).length;
                            Count++;

                            if ($Element.hasClass("Array")) {
                                // array
                                Suffix.push("_Array" + Count);
                            }
                            else {
                                // hash
                                Suffix.push("_Hash###" + Key);
                            }

                            $Element = $Element.parent().closest(".Hash, .Array");
                        }
                        // Remove first item, since it is already included in the IDSuffix
                        Suffix.shift();

                        ElementSuffix = IDSuffix + Suffix.join("");

                        $(this).find("> .ArrayItem").after(
                            Core.Template.Render("SysConfig/AddButton", {
                                Suffix : ElementSuffix + "_Array" + Count,
                                Class: 'AddArrayItem'
                            })
                        );

                        $(this).find("> .HashItem").after(
                            Core.Template.Render("SysConfig/AddButton", {
                                Suffix : ElementSuffix + "_Hash###",
                                Class: 'AddHashKey'
                            })
                        );

                        $HashItem.find("button.AddArrayItem")
                            .show()
                            .off("click")
                            .on("click", function() {
                                TargetNS.AddArrayItem($(this));
                        });

                        $Hash.find("button.AddKey")
                            .show()
                            .off("click")
                            .on("click", function() {
                                AddHashKey($(this));
                        });

                        $HashItem.find("button.AddHashKey")
                            .show()
                            .off("click")
                            .on("click", function() {
                                TargetNS.AddHashKeyClick($(this));
                        });
                    });

                    $Hash.find("input:checkbox").on("change", function () {
                        TargetNS.CheckboxValueSet($(this));
                    });

                    Core.UI.InputFields.InitSelect(
                        $Hash.find(".Modernize")
                    );

                    $KeyElement.attr("readonly", "readonly");
                }

                Core.UI.WidgetOverlayHide($Widget);
            }
        );
    }

    /**
     * @public
     * @name SettingReset
     * @memberof Core.SystemConfiguration
     * @function
     * @param {jQueryObject} $Object - jquery object
     * @param {Number} ResetOptions - reset-globally,reset-locally
     * @description
     *      Reset setting to the default value.
     */
    TargetNS.SettingReset = function ($Object, ResetOptions) {
        var $Widget = $Object.closest(".WidgetSimple"),
            $SettingName = $Widget.find("input[name='SettingName']"),
            // TODO: Action might need to be changed.
            Data = 'Action=AdminSystemConfigurationGroup;Subaction=SettingReset;';

        Data += 'SettingName=' + encodeURIComponent($SettingName.val()) + ';';
        Data += 'ResetOptions=' + encodeURIComponent(ResetOptions) + ';';

        // show loader
        Core.UI.WidgetOverlayShow($Widget, 'Loading');

        Core.AJAX.FunctionCall(
            Core.Config.Get('Baselink'),
            Data,
            function(Response) {
                var LinkURL = 'Action=AdminSystemConfigurationDeployment;Subaction=Deployment';

                TargetNS.SettingRender(Response, $Widget);
                TargetNS.CleanWidgetClasses($Widget);

                if (Response.Data.SettingData.IsDirty) {
                    $Widget.addClass('IsDirty');
                }

                if (Response.Error === undefined) {
                    Core.UI.WidgetOverlayHide($Widget, true);

                    if (Response.DeploymentNeeded == 0) {

                        // hide the "deployment" notification
                        Core.UI.HideNotification(
                            Core.Language.Translate('You have undeployed settings, would you like to deploy them?'),
                            'Notice',
                            function() {
                                Core.UI.InitStickyElement();
                            }
                        );
                    }
                    else {
                        if (Core.Config.Get('SessionUseCookie') === '0') {
                            LinkURL += ';' + Core.Config.Get('SessionName') + '=' + Core.Config.Get('SessionID');
                        }
                        Core.UI.ShowNotification(
                            Core.Language.Translate('You have undeployed settings, would you like to deploy them?'),
                            'Notice',
                            LinkURL,
                            function() {
                                Core.UI.InitStickyElement();
                            }
                        );
                    }
                }
                Core.App.Publish('SystemConfiguration.SettingListUpdate');
            }
        );
    }

    /**
     * @public
     * @name RevertToHistoricalValue
     * @memberof Core.SystemConfiguration
     * @function
     * @param {jQueryObject} $Object - jquery object
     * @returns {Boolean} - false in case delete all values is not needed
     * @description
     *      Delete user setting.
     */
    TargetNS.RevertToHistoricalValue = function ($Object) {
        var $SettingName = $("#SettingName"),
            URL = Core.Config.Get('Baselink') + 'Action=AdminSystemConfigurationSettingHistory;Subaction=RevertToHistoricalValue;';

        URL += 'SettingName=' + encodeURIComponent($SettingName.attr('value')) + ';';
        URL += 'ModifiedVersionID=' + encodeURIComponent($Object.attr('value'));
        URL += SerializeData(Core.App.GetSessionInformation());

        if (window.confirm(Core.Language.Translate("Do you really want to revert this setting to its historical value?"))) {
            window.location = URL;
        }

        return false;
    }


    /**
     * @public
     * @name CheckboxValueSet
     * @memberof Core.SystemConfiguration
     * @function
     * @param {jQueryObject} $Object - jQueryObject
     * @description
     *      This function sets the hidden input field value according to the
     *      checkbox($Object) state.
     */
    TargetNS.CheckboxValueSet = function ($Object) {
        // Set hidden input field value
        $Object
            .next()
            .val($Object.is(":checked") ? 1:0);
    }

    /**
     * @public
     * @name CleanWidgetClasses
     * @memberof Core.Agent.Admin.SystemConfiguration
     * @function
     * @param {jQueryObject} $Widget - The widget jquery object
     * @description
     *      Cleans up all locked/modified classes on the widget
     */
    TargetNS.CleanWidgetClasses = function ($Widget) {
        $Widget.removeClass('IsLockedByMe IsDirty IsModified IsLockedByAnotherUser');
    }

    /**
     * @public
     * @name SettingRender
     * @memberof Core.SystemConfiguration
     * @function
     * @param {Object} Response - AJAX response
     * @param {jQueryObject} $Widget - jQueryObject
     * @description
     *      This function renders setting received by AJAX call(Response) to the provided $Widget.
     */
    TargetNS.SettingRender = function (Response, $Widget) {
        var $EditLink = $Widget.find(".SettingEdit");

        $Widget.find("fieldset").html(Response.Data.HTMLStrg);

        // remove old Icon class
        $EditLink.find("i").removeClass();
        $EditLink.removeClass();

        if (Response.Data.SettingData.ExclusiveLockGUID == "0") {
            // Unlocked

            $EditLink.find("i").addClass("fa fa-pencil-square-o");
            $EditLink.addClass("SettingEdit Unlocked");
            $EditLink.attr("title", Core.Language.Translate("Edit this setting"));
        }
        else {
            // Locked

            $EditLink.find("i").addClass("fa fa-unlock");
            $EditLink.addClass("SettingEdit Locked");
            $EditLink.attr("title", Core.Language.Translate("Unlock setting."));

            $Widget.find("fieldset .Update").on("click", function () {
                TargetNS.Update($(this), 0 , 0);
            });

            $Widget.find("fieldset .Cancel").off("click").on("click", function () {
                Core.Agent.Admin.SystemConfiguration.Cancel($(this));
                return false;
            });

            TargetNS.InitButtonVisibility($Widget);
            $Widget.find("button.AddArrayItem").on("click", function() {
                $(this).blur();
                TargetNS.AddArrayItem($(this));
            });
            $Widget.find("button.AddHashKey").on("click", function() {
                $(this).blur();
                TargetNS.AddHashKeyClick($(this));
            });
            $Widget.find(".RemoveButton").on("click",function() {
                TargetNS.RemoveItem($(this).closest("div"));
            });
        }

        if (Response.Data.SettingData.IsValid == '1') {
            $Widget.find(".Header .Icon i")
                .addClass("Hidden");

            $Widget.find(".SettingDisabled").addClass("Hidden");
            $Widget.find(".SettingEnabled").removeClass("Hidden");
            $Widget.removeClass("IsDisabled");
        }
        else {
            $Widget.find(".Header .Icon i")
                .removeClass("Hidden");

            $Widget.find(".SettingDisabled").removeClass("Hidden");
            $Widget.find(".SettingEnabled").addClass("Hidden");
            $Widget.addClass("IsDisabled");
        }

        if (Response.Data.SettingData.UserModificationActive == '1') {
            $Widget.find(".UserModificationNotActive").addClass("Hidden");
            $Widget.find(".UserModificationActive").removeClass("Hidden");
        }
        else {
            $Widget.find(".UserModificationNotActive").removeClass("Hidden");
            $Widget.find(".UserModificationActive").addClass("Hidden");
        }

        if (Response.Data.Error != null) {
            alert(Response.Data.Error);
        }

        if (Response.Data.HTMLStrg.indexOf("<select") > -1) {
            Core.UI.InputFields.Activate($Widget.find("fieldset"));
        }

        if (Response.Data.SettingData.IsModified) {
            $Widget.addClass('IsModified');
            $Widget.find("button.ResetSetting").show();

            // for user preferences
            $Widget.find(".ResetUserSetting").removeClass("Hidden");
        }
        else {
            $Widget.removeClass('IsModified');

            // for user preferences
            $Widget.find(".ResetUserSetting").addClass("Hidden");
        }

        if (Response.Data.SettingData.IsDirty) {
            $Widget.addClass('IsDirty');
        }

        if ($Widget.hasClass('MenuExpanded')) {
            $Widget.find('.WidgetMessage.Bottom').show();
        }

        $Widget.find("a.ResetSetting")
            .off("click")
            .on("click", function() {

            Core.Agent.Admin.SystemConfiguration.InitDialogReset($(this));

            return false;
        });

        if (Response.Data.SettingData.IsLockedByMe == "1") {
            $Widget.addClass('IsLockedByMe');
        }

        if (Response.Data.SettingData.Invalid != "1") {
            // setting is valid
            $Widget.find(".Icon .fa-check-circle-o").removeClass("Hidden");
        }

        $Widget.find("input:checkbox")
        .off("change")
        .on("change", function() {
            TargetNS.CheckboxValueSet($(this));
        });
    }

    /**
     * @private
     * @name CheckMinItems
     * @memberof Core.SystemConfiguration
     * @function
     * @param {jQueryObject} $Object - jQueryObject
     * @description
     *      Initialize Array/Hash container with MinItems.
     */
    function CheckMinItems($Object) {
        var $Structure = $Object,
            MinItems;

        if (!$Structure.hasClass("Array") && !$Structure.hasClass("Hash")) {
            $Structure = $Object.closest(".Array, .Hash");
        }

        MinItems = $Structure.attr("data-min-items");

        if (MinItems !== undefined) {
            if ($Structure.find("> .ArrayItem, > .HashItem").length <= MinItems) {
                // Hide all Remove buttons
                $Structure.find("> .ArrayItem .RemoveButton, > .HashItem .RemoveButton").hide();
            }
            else {
                // Show all Remove buttons
                $Structure.find("> .ArrayItem .RemoveButton, > .HashItem .RemoveButton").show();
            }
        }
        else {
            // Show all Remove buttons
            $Structure.find("> .ArrayItem .RemoveButton, > .HashItem .RemoveButton").show();
        }
    }

    /**
     * @private
     * @name CheckMaxItems
     * @memberof Core.SystemConfiguration
     * @function
     * @param {jQueryObject} $Object - jQueryObject
     * @description
     *      Initialize Array/Hash container with MaxItems.
     */
    function CheckMaxItems($Object) {
        var $Structure = $Object,
            MaxItems;

        if (!$Structure.hasClass("Array") && !$Structure.hasClass("Hash")) {
            $Structure = $Object.closest(".Array, .Hash");
        }

        MaxItems = $Structure.attr("data-max-items");

        if (MaxItems !== undefined) {
            if ($Structure.find("> .ArrayItem, > .HashItem").length >= MaxItems) {
                // Hide all AddArrayItem and AddHashKey buttons.
                $Structure.find("> .AddArrayItem, > .AddHashKey").hide();
            }
            else {
                // Show all AddArrayItem and AddHashKey buttons.
                $Structure.find("> .AddArrayItem:not(.Hidden), > .AddHashKey:not(.Hidden)").show();
            }
        }
        else {
            // Show all AddArrayItem and AddHashKey buttons.
            $Structure.find("> .AddArrayItem:not(.Hidden), > .AddHashKey:not(.Hidden)").show();
        }
    }

    /**
     * @private
     * @name StructureGet
     * @memberof Core.SystemConfiguration
     * @function
     * @param {jQueryObject} $Object - jQueryObject
     * @param {String} Structure - result of previous call
     * @returns {String} - Structure
     * @description
     *      Get a sub structure of $Object in the complex item.
     */
    function StructureGet($Object, Structure) {
        var Result = "",
            $Item;

        if (Structure) {
            Result = Structure;
        }

        $Item = $Object.parent().closest(".Array, .Hash, .Setting");

        if ($Item.hasClass("Setting")) {
            return Result;
        }
        else if ($Item.hasClass("Array")) {
            if (Result) {
                Result += '.';
            }
            Result += "Array";
        }
        else if ($Item.hasClass("Hash")) {
            if (Result) {
                Result += '.';
            }
            Result += "Hash";
        }

        return StructureGet($Item, Result);
    }

    /**
     * @private
     * @name CheckIDs
     * @memberof Core.SystemConfiguration
     * @function
     * @param {jQueryObject} $Object - jQueryObject
     * @description
     *      Go through all items that are used for EffectiveValue calcutation,
     *      and update their IDs according to the latest changes(array position
     *      or renamed hash key).
     */
    function CheckIDs($Object) {
        $Object.find(".Entry, .AddArrayItem").each(function() {
            var OldID,
                ID,
                Key,
                SubString,
                Count = 0,
                $ClosestItem,
                ValueType,
                Index;

            if ($(this).hasClass("Entry")) {
                OldID = $(this).attr("id");
            }
            else {
                OldID = $(this).attr("data-suffix");
            }
            ID = OldID;

            // check ValueType
            for (Index in ValueTypes) {
                if ($(this).hasClass(ValueTypes[Index])) {
                    ValueType = ValueTypes[Index];
                    break;
                }
            }

            if (ID.indexOf("_Hash###") > 0) {
                // put placeholders
                while (ID.indexOf("_Hash###") > 0) {
                    SubString = ID.match(/(_Hash###.*?)(_Array|_Hash|Day$|Month$|Year$|Hour$|Minute$|$)/)[1];

                    ID = ID.replace(SubString, "_PLACEHOLDER" + Count);
                    Count++;
                }

                $ClosestItem = $(this).closest(".HashItem");

                while (Count > 0) {
                    Count--;

                    // get key value
                    Key = $ClosestItem.find(".Key").val();
                    Key = Core.App.EscapeHTML(Key);

                    // update id
                    ID = ID.replace("_PLACEHOLDER" + Count, "_Hash###" + Key);

                    $ClosestItem = $ClosestItem.parent().closest(".HashItem");
                }

                // set new id
                if ($(this).hasClass("Entry")) {
                    $(this).attr("id", ID);
                }
                else {
                    $(this).attr("data-suffix", ID);
                }
            }

            if (ID.indexOf("_Array") >= 0) {
                if ($(this).closest('.Array').find(".ArrayItem").length > 0) {
                    $(this).closest('.Array').find(".ArrayItem").each(function() {
                        Count = 0;

                        $(this).find(
                            ".SettingContent input:visible:not(.InputField_Search), " +
                            ".SettingContent select:visible, .SettingContent select.Modernize, " +
                            ".SettingContent textarea:visible"
                        ).each(function() {
                            OldID = $(this).attr('id');

                            ID = OldID;

                            while (ID.indexOf("_Array") >= 0) {
                                SubString = ID.match(/(_Array\d+)/)[1];
                                ID = ID.replace(SubString, "_PLACEHOLDER" + Count);
                                Count++;
                            }

                            $ClosestItem = $(this).closest('.ArrayItem');

                            while (Count > 0) {
                                Count--;

                                Key = $ClosestItem.index() + 1;
                                ID = ID.replace("_PLACEHOLDER" + Count, "_Array" + Key);
                                // update id
                                $(this).attr('id', ID);

                                $ClosestItem = $ClosestItem.parent().closest(".ArrayItem");
                            }

                            if (OldID != ID && ValueType) {

                                // Run dedicated CheckID() for this ValueType (in a Core.SystemConfiguration.ValueTypeX.js).
                                if (window["Core"]["SystemConfiguration"][ValueType]["CheckID"]) {
                                    window["Core"]["SystemConfiguration"][ValueType]["CheckID"]($(this), OldID);
                                }
                            }
                        });
                    });
                }
                else {
                    // Array is empty, there is just button with data-suffix.
                    OldID = $(this).closest('.Array').find("button").attr('data-suffix');

                    ID = OldID;

                    while (ID.indexOf("_Array") >= 0) {
                        SubString = ID.match(/(_Array\d+)/)[1];
                        ID = ID.replace(SubString, "_PLACEHOLDER" + Count);
                        Count++;
                    }

                    $ClosestItem = $(this).closest('.ArrayItem');

                    for (Index = 0; Index < Count; Index++) {
                        Key = $ClosestItem.index();
                        if (Key < 0) {
                            Key = 0;
                        }
                        Key++;

                        ID = ID.replace("_PLACEHOLDER" + Index, "_Array" + Key);
                        // update id
                        $(this).closest('.Array').find("button").attr('data-suffix', ID);

                        $ClosestItem = $ClosestItem.parent().closest(".ArrayItem");
                    }
                }
            }
        });
    }

    /**
     * @public
     * @name InitButtonVisibility
     * @memberof Core.SystemConfiguration
     * @function
     * @param {jQueryObject} $Object - jQueryObject
     * @description
     *      Initialize add button visibility.
     */
    TargetNS.InitButtonVisibility = function ($Object) {
        if ($Object === undefined) {
            $Object = $(document);
        }

        /* check hashes and arrays with minimum and maximum items */
        $Object.find(".Hash[data-min-items], .Array[data-min-items]").each(function() {
            CheckMinItems($(this));
        });

        $Object.find(".Hash[data-max-items], .Array[data-max-items]").each(function() {
            CheckMaxItems($(this));
        });

        /* show buttons inside hashes and arrays without minimum/maximum items */
        $Object.find(".Hash:not([data-min-items]), .Array:not([data-min-items])").each(function() {
            $(this).find("> .ArrayItem > .RemoveButton, > .HashItem > .RemoveButton").show();
        });

        $Object.find(".Hash:not([data-max-items]), .Array:not([data-max-items])").each(function() {
            $(this)
                .find("> .AddHashKey:not(.Hidden), > .AddArrayItem:not(.Hidden)").show();
        });
    }

    /**
     * @private
     * @name SettingList
     * @memberof Core.SystemConfiguration
     * @function
     * @param {String} Selected - selected navigation (Frontend::Module)
     * @description
     *      This function reloads list of settings (AJAX) when user clicks on Navigation item.
     */
    function SettingList(Selected) {
        var Data,
            Action = 'AdminSystemConfigurationGroup',
            BreadCrumbItems,
            ListItem,
            URL = Core.Config.Get('CGIHandle'),
            Index;

        $('.ContentColumn').html(Core.Template.Render("Agent/WidgetLoading"));

        // Update BreadCrumb
        $('ul.BreadCrumb li:nth-child(2)').nextAll().remove();
        BreadCrumbItems = Selected.split("::");

        if (Core.Config.Get('Action') == 'AgentPreferences') {
            URL += "?Action=AgentPreferences;Subaction=Group;Group=Advanced;RootNavigation=";
        }
        else {
            URL += "?Action=AdminSystemConfigurationGroup;RootNavigation=";
        }
        for (Index in BreadCrumbItems) {
            if (Index != 0) {
                URL += "::";
            }

            URL += BreadCrumbItems[Index];
            ListItem = Core.Template.Render("SysConfig/BreadCrumbItem", {
                Title: BreadCrumbItems[Index],
                URL: URL
            });
            $('ul.BreadCrumb').append(ListItem);
        }

        if (Core.Config.Get('Action') == 'AgentPreferences') {
            Action = "AgentPreferences";
        }

        window.history.pushState(null, null, URL);

        Data = {
            Action     : Action,
            Subaction  : 'SettingList',
            Category   : $('#Category').val(),
            RootNavigation : Selected
        };

        if (Core.Config.Get('Action') == 'AgentPreferences') {
            Data["IsValid"] = 1;
            // TODO: Implement - right now it goes always to the Advanced group.
            Data["Group"] = 'Advanced';
        }

        if (!$('#ConfigTree').length) {
            return;
        }

        Core.AJAX.FunctionCall(
            Core.Config.Get('CGIHandle'),
            Data,
            function (HTML) {
                var Counter = 0;

                $(".ContentColumn").html(HTML);
                TargetNS.Init();
                if (Core.Config.Get('Action') == 'AgentPreferences') {
                    Core.Agent.Preferences.InitSysConfig();
                    Core.UI.Table.InitTableFilter($("#FilterSettings"), $(".SettingsList"));
                }
                else {
                    Core.Agent.Admin.SystemConfiguration.InitGroupView(true);
                }

                // check if we need to show/hide the help and dynamic actions widget
                if ($('.WidgetSimple .Setting').length) {
                    $('#UserWidgetState_SystemConfiguration_Help, #UserWidgetState_SystemConfiguration_Sticky').removeClass('Hidden');
                }
                else {
                    $('#UserWidgetState_SystemConfiguration_Help, #UserWidgetState_SystemConfiguration_Sticky').addClass('Hidden');
                }
                Core.UI.InitStickyElement();

                Core.App.Publish('SystemConfiguration.SettingListUpdate');

                Core.UI.InputFields.InitSelect(
                    $(".SettingsList .Modernize")
                );

                // scroll to top to see all the settings from the current node
                $('html, body').animate({
                    scrollTop: $('.ContentColumn .WidgetSimple').first().position().top
                }, {
                    duration: 'fast',
                    always: function () {

                        // This function is called 2 times: one time for html and another for body.
                        // We want to set the class on element only when both are done.
                        if (Counter === 1) {
                            $('ul.SettingsList').addClass('Initialized');
                        }

                        Counter++;
                    },
                });
            }, 'html'
        );

        window.setTimeout(function() {
            Core.Agent.Admin.SystemConfiguration.InitFavourites();
        }, 1000);
    }

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.SystemConfiguration || {}));
