// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};
Core.Agent.Admin = Core.Agent.Admin || {};

/**
 * @namespace Core.Agent.Admin
 * @memberof Core.Agent
 * @author OTRS AG
 */

/**
 * @namespace Core.Agent.Admin.ACL
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the ACL module.
 */
Core.Agent.Admin.ACL = (function (TargetNS) {

    /**
     * @private
     * @name KeysWithoutSubkeys
     * @memberof Core.Agent.Admin.ACL
     * @member {Array}
     * @description
     *      KeysWithoutSubkeys
     */
    var KeysWithoutSubkeys = [ 'ActivityDialog', 'Action', 'Process' ];

    /**
     * @name Init
     * @memberof Core.Agent.Admin.ACL
     * @function
     * @description
     *      This function initialize the module.
     */
    TargetNS.Init = function() {
        Core.UI.Table.InitTableFilter($('#FilterACLs'), $('#ACLs'), 0);
        if (Core.Config.Get('Subaction') === 'ACLEdit') {
            TargetNS.InitACLEdit();
        }
    };

    /**
     * @private
     * @name ShowDeleteACLConfirmationDialog
     * @memberof Core.Agent.Admin.ACL
     * @function
     * @param {jQueryObject} $Element - The confirmation dialog template in the HTML.
     * @description
     *      Shows a confirmation dialog to delete the ACL entry.
     */
    function ShowDeleteACLConfirmationDialog($Element) {
        var DialogElement = $Element.data('dialog-element'),
            DialogTitle = $Element.data('dialog-title'),
            ACLID = $Element.data('id');

        Core.UI.Dialog.ShowContentDialog(
            $('#Dialogs #' + DialogElement),
            DialogTitle,
            '240px',
            'Center',
            true,
            [
               {
                   Label: Core.Language.Translate('Cancel'),
                   Class: 'Primary',
                   Function: function () {
                       Core.UI.Dialog.CloseDialog($('.Dialog'));
                   }
               },
               {
                   Label: Core.Language.Translate('Delete'),
                   Function: function () {
                       var Data = {
                               Action: 'AdminACL',
                               Subaction: 'ACLDelete',
                               ID: ACLID
                           };

                       // Change the dialog to an ajax loader
                       $('.Dialog')
                           .find('.ContentFooter').empty().end()
                           .find('.InnerContent').empty().append('<div class="Spacing Center"><span class="AJAXLoader"></span></div>');

                       // Call the ajax function
                       Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {
                           if (!Response || !Response.Success) {
                               alert(Response.Message);
                               Core.UI.Dialog.CloseDialog($('.Dialog'));
                               return;
                           }

                           Core.App.InternalRedirect({
                               Action: Data.Action
                           });
                       }, 'json');
                   }
               }
           ]
        );
    }

    /**
     * @name RestoreACLData
     * @memberof Core.Agent.Admin.ACL
     * @function
     * @returns {Boolean} Returns false, if $DataObj.val() is not defined
     * @param {jQueryObject} $DataObj
     * @param {jQueryObject} $TargetObj
     * @description
     *      Build up the DOM from the stored ACL data.
     */
    TargetNS.RestoreACLData = function($DataObj, $TargetObj) {

        var JSONString = $DataObj.val(),
            Data,
            Level1Key, Level2Key, Level3Key, Level4Key,
            $ItemObjLevel1, $ItemObjLevel2, $ItemObjLevel3, $ItemObjLevel4,
            $TempObjLevel2, $TempObjLevel3, $TempObjLevel4,
            SelectHTML,
            Value,
            Class,
            Bool,
            IsMatchItem = ($TargetObj.attr('id') === 'ACLMatch') ? true : false;

        if (!JSONString) {
            return false;
        }

        Data = JSON.parse(JSONString);

        for (Level1Key in Data) {

            if (Data.hasOwnProperty(Level1Key)) {

                $ItemObjLevel1 = $('#TemplateLevel1 > li').clone();
                $ItemObjLevel1
                    .attr('data-content', Level1Key)
                    .find('strong')
                    .text(Core.App.EscapeHTML(Level1Key))
                    .next('ul')
                    .find('.Icon.AddButton')
                    .after($('#' + Level1Key).parent().html());

                if (typeof Data[Level1Key] === 'object') {

                    $TempObjLevel2 = $('<div />');

                    for (Level2Key in Data[Level1Key]) {

                        if (Data[Level1Key].hasOwnProperty(Level2Key)) {

                            if ($.inArray(Level2Key, KeysWithoutSubkeys) !== -1 && !IsMatchItem) {
                                $ItemObjLevel2 = $('#TemplateLevel2Last > li').clone();
                            }
                            else {
                                $ItemObjLevel2 = $('#TemplateLevel2 > li').clone();
                            }

                            $ItemObjLevel2
                                .attr('data-content', Level2Key)
                                .find('strong')
                                .text(Core.App.EscapeHTML(Level2Key))
                                .next('ul')
                                .find('.Icon.AddButton')
                                .next('input')
                                .attr('data-parent', Level2Key);

                            if (Level2Key === 'DynamicField') {
                                SelectHTML = $('#' + Level2Key).parent().html();
                                SelectHTML += '<span class="AddAll">' + Core.Language.Translate('Add all') + '</span>';

                                $ItemObjLevel2
                                    .find('input')
                                    .after(SelectHTML)
                                    .parent()
                                    .find('input')
                                    .remove();
                                $ItemObjLevel2
                                    .find('select')
                                    .removeAttr('id')
                                    .attr('data-level', 3);
                            }

                            if ($.inArray(Level2Key, KeysWithoutSubkeys) !== -1 && !IsMatchItem) {

                                $ItemObjLevel2.find('ul').addClass('LastLevel');

                                $TempObjLevel3 = $('<div />');

                                for (Level3Key in Data[Level1Key][Level2Key]) {

                                    if (Data[Level1Key][Level2Key].hasOwnProperty(Level3Key)) {

                                        Value = Data[Level1Key][Level2Key][Level3Key];

                                        $ItemObjLevel3 = $('#TemplateLevel4 > li').clone();
                                        $ItemObjLevel3
                                            .attr('data-content', Value)
                                            .find('em')
                                            .before('<span>' + Core.App.EscapeHTML(Value) + '</span>');

                                        $TempObjLevel3.append($ItemObjLevel3);
                                    }
                                }
                                $ItemObjLevel2
                                    .children('ul')
                                    .prepend($TempObjLevel3.html())
                                    .find('.ItemPrefix')
                                    .addClass('Hidden');
                            }
                            else {

                                if (typeof Data[Level1Key][Level2Key] === 'object') {

                                    $TempObjLevel3 = $('<div />');

                                    for (Level3Key in Data[Level1Key][Level2Key]) {

                                        if (Data[Level1Key][Level2Key].hasOwnProperty(Level3Key)) {

                                            $ItemObjLevel3 = $('#TemplateLevel3 > li').clone();
                                            $ItemObjLevel3
                                                .attr('data-content', Level3Key)
                                                .children('.Icon')
                                                .after('<span>' + Core.App.EscapeHTML(Level3Key) + '</span>' + ':');

                                            if (typeof Data[Level1Key][Level2Key][Level3Key] !== 'object') {

                                                Class = 'True';
                                                Bool = parseInt(Data[Level1Key][Level2Key][Level3Key], 10);

                                                if (Bool === 0) {
                                                    Class = 'False';
                                                }

                                                $ItemObjLevel3
                                                    .find('ul')
                                                    .addClass('Boolean')
                                                    .find('li')
                                                    .attr('data-content', Bool)
                                                    .addClass('DataItem')
                                                    .find('span')
                                                    .before('<span class="Icon ' + Class + ' Boolean" />')
                                                    .remove();
                                            }
                                            else {

                                                $TempObjLevel4 = $('<div />');

                                                for (Level4Key in Data[Level1Key][Level2Key][Level3Key]) {

                                                    if (Data[Level1Key][Level2Key][Level3Key].hasOwnProperty(Level4Key)) {

                                                        Value = Data[Level1Key][Level2Key][Level3Key][Level4Key];

                                                        $ItemObjLevel4 = $('#TemplateLevel4 > li').clone();
                                                        $ItemObjLevel4
                                                            .attr('data-content', Value)
                                                            .find('em')
                                                            .before('<span>' + Core.App.EscapeHTML(Value) + '</span>');

                                                        $TempObjLevel4.append($ItemObjLevel4);
                                                    }
                                                }
                                                $ItemObjLevel3
                                                    .children('ul')
                                                    .prepend($TempObjLevel4.html())
                                                    .find('.ItemPrefix')
                                                    .addClass('Hidden');
                                            }
                                            $TempObjLevel3.append($ItemObjLevel3);
                                        }
                                    }
                                    $ItemObjLevel2.children('ul').prepend($TempObjLevel3.html());
                                }
                            }
                            $TempObjLevel2.append($ItemObjLevel2);
                        }
                    }
                    $ItemObjLevel1.children('ul').prepend($TempObjLevel2.html());
                }
                $TargetObj.append($ItemObjLevel1);
            }
        }
    };

    /**
     * @name AddItem
     * @memberof Core.Agent.Admin.ACL
     * @function
     * @param {jQueryObject} $Object
     * @param {String} Type
     * @description
     *      Adds an item to the list.
     */
    TargetNS.AddItem = function($Object, Type) {

        var AlreadyAdded = false,
            Value = $Object.val(),
            ValueEscaped = Core.App.EscapeHTML(Value),
            Level = parseInt($Object.attr('data-level'), 10),
            $LevelObj, $Target, $TriggerObj,
            Prefix, SelectHTML,
            IsMatchItem = ($Object.closest('#ACLMatch').length) ? true : false;

        if (Level === 1) {

            $Target = $Object.prevAll('.ACLFieldGroup');
            $Target.children('li').each(function() {
                if ($(this).attr('data-content') === Value) {
                    AlreadyAdded = true;
                    return;
                }
            });

            if (!AlreadyAdded) {

                $LevelObj = $('#TemplateLevel1 > li').clone();
                $LevelObj
                    .attr('data-content', Value)
                    .find('strong')
                    .text(ValueEscaped)
                    .next('ul')
                    .find('.Icon.AddButton')
                    .after($('#' + Value).parent().html());
                $Target.append($LevelObj);
            }
            else {
                alert(Core.Language.Translate('An item with this name is already present.'));
            }

            // Set empty value for $Object and blur its sibling modern input field (see bug#14157).
            $Object.val('').siblings('.InputField_Container').find('.InputField_Search').blur();
        }
        else if (Level === 2) {

            $Target = $Object.parent();
            $Target.parent().children('li').each(function() {
                if ($(this).attr('data-content') === Value) {
                    AlreadyAdded = true;
                    return;
                }
            });

            if (!AlreadyAdded) {

                if ($.inArray(Value, KeysWithoutSubkeys) !== -1 && !IsMatchItem) {
                    $LevelObj = $('#TemplateLevel2Last > li').clone();
                    $TriggerObj = $LevelObj.find('.AddButton');
                }
                else {
                    $LevelObj = $('#TemplateLevel2 > li').clone();
                }

                $LevelObj
                    .attr('data-content', Value)
                    .find('strong')
                    .text(ValueEscaped)
                    .next('ul')
                    .find('.Icon.AddButton')
                    .next('input')
                    .attr('data-parent', Value);

                if (Value === 'DynamicField') {
                    SelectHTML = $('#' + Value).parent().html();
                    SelectHTML += '<span class="AddAll">' + Core.Language.Translate('Add all') + '</span>';

                    $LevelObj
                        .find('input')
                        .after(SelectHTML)
                        .parent()
                        .find('input')
                        .remove();
                    $LevelObj
                        .find('select')
                        .removeAttr('id')
                        .attr('data-level', 3);
                }
                $Target.before($LevelObj);

                if ($.inArray(Value, KeysWithoutSubkeys) !== -1 && !IsMatchItem) {
                    $TriggerObj.click();
                }
            }
            else {
                alert(Core.Language.Translate('An item with this name is already present.'));
            }

            // Set empty value for $Object and blur its sibling modern input field (see bug#14157).
            $Object.val('').siblings('.InputField_Container').find('.InputField_Search').blur();
        }
        else if (Level === 3) {

            $LevelObj = $('#TemplateLevel3 > li').clone();
            $TriggerObj = $LevelObj.find('.AddButton');

            if (Value) {
                $LevelObj
                    .attr('data-content', Value)
                    .children('.Icon')
                    .after('<span>' + ValueEscaped + '</span>' + ':');
                $LevelObj.insertBefore($Object.parent());

                if (Type === 'Boolean') {
                    $LevelObj
                        .find('ul')
                        .addClass('Boolean')
                        .find('li')
                        .attr('data-content', '1')
                        .addClass('DataItem')
                        .find('span')
                        .before('<span class="Icon True Boolean" />')
                        .remove();
                }
            }
            $Object.val('');

            if (Value && Type !== 'Boolean') {
                $TriggerObj.click();
            }
        }
        else if (Level === 4) {

            $LevelObj = $('#TemplateLevel4 > li').clone();
            $TriggerObj = $Object.next('.AddButton');

            if (Value) {

                Prefix = $Object.prevAll('select').val();
                if (Prefix) {
                    Value = Prefix + Value;
                }

                $LevelObj
                    .attr('data-content', Value)
                    .find('em')
                    .before('<span>' + Value + '</span>');
                $LevelObj.insertBefore($Object.parent());
            }
            $Object
                .prevAll('select')
                .addClass('Hidden')
                .nextAll('input')
                .remove();

            if (Value) {
                $TriggerObj.click();
            }
        }
    };

    /**
     * @name CollectACLData
     * @memberof Core.Agent.Admin.ACL
     * @function
     * @returns {Object} ACL data structure.
     * @param {jQueryObject} $ItemObj
     * @description
     *      Collects the ACL data.
     */
    TargetNS.CollectACLData = function($ItemObj) {

        var Structure = {},
            $SubItemsObj,
            ItemNameLevel1,
            ItemNameLevel2,
            ItemNameLevel3;

        $ItemObj.children('li.DataItem').each(function() {

            ItemNameLevel1 = $(this).attr('data-content');
            Structure[ItemNameLevel1] = {};

            $SubItemsObj = $(this).children('ul').children('li.DataItem');

            if ($SubItemsObj.length > 0) {

                $SubItemsObj.each(function() {

                    ItemNameLevel2 = $(this).attr('data-content');
                    Structure[ItemNameLevel1][ItemNameLevel2] = {};
                    $SubItemsObj = $(this).children('ul').children('li.DataItem');

                    if ($SubItemsObj.length > 0) {

                        if ($(this).children('ul').hasClass('LastLevel')) {
                            Structure[ItemNameLevel1][ItemNameLevel2] = [];
                            $SubItemsObj.each(function() {
                                Structure[ItemNameLevel1][ItemNameLevel2].push($(this).attr('data-content'));
                            });
                        }
                        else {

                            $SubItemsObj.each(function() {

                                ItemNameLevel3 = $(this).attr('data-content');
                                $SubItemsObj = $(this).children('ul').children('li.DataItem');

                                if ($(this).children('ul').hasClass('Boolean')) {
                                    Structure[ItemNameLevel1][ItemNameLevel2][ItemNameLevel3] = parseInt($SubItemsObj.attr('data-content'), 10);
                                }
                                else {
                                    Structure[ItemNameLevel1][ItemNameLevel2][ItemNameLevel3] = [];
                                    if ($SubItemsObj.length > 0) {
                                        $SubItemsObj.each(function() {
                                            Structure[ItemNameLevel1][ItemNameLevel2][ItemNameLevel3].push($(this).attr('data-content'));
                                        });
                                    }
                                }
                            });
                        }
                    }
                });
            }
        });

        return Structure;
    };

    /**
     * @name InitACLEdit
     * @memberof Core.Agent.Admin.ACL
     * @function
     * @description
     *      Initializes the ACL editor.
     */
    TargetNS.InitACLEdit = function () {

        $('#ACLDelete').on('click.ACLDelete', function (Event) {
            ShowDeleteACLConfirmationDialog($(Event.target).closest('a'));
            Event.stopPropagation();
            return false;
        });

        $('.ItemAddLevel1')
            .attr('data-level', 1)
            .removeAttr('id');

        $('.LevelToBeAdded')
            .attr('data-level', 2)
            .removeClass('LevelToBeAdded');

        $('#Prefixes').removeAttr('id');

        $('.ACLStructure').on('click', '.DataItem strong', function() {
            $(this).prevAll('.Trigger').click();
        });

        $('.ACLStructure').on('click', '.Trigger', function() {
            if ($(this).hasClass('Collapse')) {
                $(this)
                    .removeClass('Collapse')
                    .nextAll('ul')
                    .addClass('Hidden');
            }
            else {
                $(this)
                    .addClass('Collapse')
                    .nextAll('ul')
                    .removeClass('Hidden');
            }
        });

        $('.ACLStructure').on('click', '.AddAll', function() {
            var $SelectObj = $(this).prev('select'),
                BooleanStr = '';

            if ($SelectObj.hasClass('Boolean')) {
                BooleanStr = 'Boolean';
            }

            $SelectObj.find('option').each(function() {
                $SelectObj.val($(this).attr('value'));
                TargetNS.AddItem($SelectObj, BooleanStr);
            });
        });

        $('.ACLStructure').on('click', '.AddDataItem', function() {

            // check if there is already an item placeholder. Do nothing then.
            if ($(this).prevAll('.NewDataItem').length) {
                return false;
            }

            $(this)
                .before('<input type="text" class="NewDataItem" data-level="4" />')
                .prevAll('select')
                .removeClass('Hidden');
            $('.NewDataItem').prevAll('select').focus();

            Core.App.Publish('ACL.InitAutocomplete');
        });

        $('.ACLStructure').on('blur keydown', '.NewDataItem', function(Event) {
            if ((Event.type === 'keydown' && Event.which === 13) || Event.type !== 'keydown') {
                if ($(this).hasClass('Added')) {
                    return false;
                }
                $(this).addClass('Added');
                TargetNS.AddItem($(this));
                return false;
            }
        });

        $('.ACLStructure').on('blur keydown', '.NewDataKey', function(Event) {
            if ((Event.type === 'keydown' && Event.which === 13) || Event.type !== 'keydown') {
                TargetNS.AddItem($(this));
                Core.UI.InputFields.Activate();
                return false;
            }
        });

        $('.ACLStructure').on('click', '.Icon.Boolean', function() {
            if ($(this).hasClass('True')) {
                $(this)
                    .removeClass('True')
                    .addClass('False')
                    .parent()
                    .attr('data-content', 0);
            }
            else {
                $(this)
                    .removeClass('False')
                    .addClass('True')
                    .parent()
                    .attr('data-content', 1);
            }
        });

        $('.ACLStructure').on('click', '.Editable span', function() {

            var $Obj = $(this),
                Value = $Obj.text(),
                Width = $Obj.width() + 3,
                $SelectObj = $('#TemplateLevel3').find('select'),
                $SelectObjClone = $SelectObj.clone(),
                RegexResult,
                LastLevel = true;

            // only apply on right spans
            if ($(this).hasClass('Icon')) {
                return false;
            }

            // only apply if not of type "boolean"
            if ($(this).nextAll('ul').hasClass('Boolean')) {
                return false;
            }

            // decide if we are already on the last level
            if (!$(this).next('em').length) {
                LastLevel = false;
            }


            if (LastLevel) {

                // get contents of the 'prefixes' selectbox to decide whether or not we
                // are dealing with a special type of string
                $SelectObj.find('option').each(function() {

                    var Prefix = $(this).attr('value'),
                        Regex;

                    if (Prefix) {

                        Prefix = Prefix.replace(/\[/, '');
                        Prefix = Prefix.replace(/\]/, '');
                        Prefix = $.trim(Prefix);
                        Regex = new RegExp('(\\[' + Prefix + '\\]).*');

                        RegexResult = Value.match(Regex);
                        if (RegexResult) {
                            Value = Value.replace(RegexResult[1], '');
                            $SelectObjClone.val(RegexResult[1]);
                        }
                    }
                });

                $Obj
                    .before('<input type="text" class="LiveEdit" value="' + Value + '" />')
                    .prev('input')
                    .css('width', parseInt(Width, 10) + 'px')
                    .nextAll('em')
                    .hide()
                    .parent()
                    .removeClass('DataItem')
                    .find('input')
                    .before($SelectObjClone)
                    .parent()
                    .find('select')
                    .focus()
                    .css('margin-right', '2px')
                    .addClass('LiveEditSelect')
                    .nextAll('span')
                    .remove();
            }
            else {

                $Obj
                    .before('<input type="text" class="LiveEdit Big" value="' + Value + '" />')
                    .prev('input')
                    .css('width', parseInt(Width, 10) + 'px')
                    .focus()
                    .select()
                    .nextAll('span')
                    .remove();
            }
            Core.App.Publish('ACL.InitAutocomplete');
        });

        // prevent users from accidentally submitting the form on pressing 'enter'
        $('.ACLStructure').on('keydown', '.LiveEditSelect', function(Event) {
            if (Event.which === 13) {
                return false;
            }
        });

        $('.ACLStructure').on('change blur', '.LiveEditSelect', function() {
            $(this).next('input').select().focus();
        });

        $('.ACLStructure').on('blur keydown', '.LiveEdit', function(Event) {

            var Value;

            if ((Event.type === 'keydown' && Event.which === 13) || Event.type !== 'keydown') {

                Value = $(this).val();

                if (Value) {

                    // avoid wrong behavior when Value is already present
                    if ($(this).next('span').length) {
                        return false;
                    }

                    if ($(this).hasClass('Big')) {

                        $(this)
                            .after('<span>' + Value + '</span>')
                            .parent()
                            .addClass('DataItem')
                            .attr('data-content', Value)
                            .find('.LiveEdit')
                            .remove();
                    }
                    else {

                        // avoid wrong behavior if select is no more present
                        if (!$(this).parent().find('select').length) {
                            return false;
                        }

                        Value = $(this).parent().find('select').val() + Value;

                        $(this)
                            .after('<span>' + Value + '</span>')
                            .nextAll('em')
                            .show()
                            .parent()
                            .addClass('DataItem')
                            .attr('data-content', Value)
                            .find('.LiveEdit, select')
                            .remove();
                    }
                }
                else {

                    if ($(this).hasClass('Big')) {
                        $(this).val($(this).parent().attr('data-content')).blur();
                        return false;
                    }
                    else {
                        $(this)
                            .parent()
                            .remove();
                    }
                }
            }
        });

        $('.ACLStructure').on('change', '.NewDataKeyDropdown', function() {
            var BooleanStr = '';
            if ($(this).hasClass('Boolean')) {
                BooleanStr = 'Boolean';
            }
            TargetNS.AddItem($(this), BooleanStr);
        });

        $('.ACLStructure').on('click', '.DataItem em', function() {
            $(this).parent().fadeOut(300, function() {
                $(this).remove();
            });
        });

        $('.ACLStructure').on('click', '.Icon.RemoveButton', function() {
            var Remove = false;
            if ($(this).nextAll('ul').find('li').length > 1) {
                if (confirm(Core.Language.Translate('This item still contains sub items. Are you sure you want to remove this item including its sub items?'))) {
                    Remove = true;
                }
            }
            else {
                Remove = true;
            }

            if (Remove) {
                $(this).parent().fadeOut(300, function() {
                    $(this).remove();
                });
            }
        });

        $('.ACLStructure').on('change', '.ItemAdd', function() {
            TargetNS.AddItem($(this));
            Core.UI.InputFields.Activate();
        });

        $('#SubmitAndContinue').on('click', function() {
            $('#ContinueAfterSave').val(1);
            $('#Submit').click();
        });

        $('#Submit, #SubmitAndContinue').on('click', function() {

            // collect data from the input areas
            TargetNS.ConfigMatch = TargetNS.CollectACLData($('#ACLMatch'));
            TargetNS.ConfigChange = TargetNS.CollectACLData($('#ACLChange'));

            $('input[name=ConfigMatch]').val(Core.JSON.Stringify(TargetNS.ConfigMatch));
            $('input[name=ConfigChange]').val(Core.JSON.Stringify(TargetNS.ConfigChange));
        });

        TargetNS.RestoreACLData(
            $('input[name=ConfigMatch]'),
            $('#ACLMatch')
        );

        TargetNS.RestoreACLData(
            $('input[name=ConfigChange]'),
            $('#ACLChange')
        );

        Core.App.Subscribe('ACL.InitAutocomplete', function() {

            $('.LiveEdit, .NewDataItem').each(function() {

                // only do it for the 'Action' item (can be extended in the future)
                if ($(this).closest('ul').closest('li').data('content') === 'Action') {

                    // if the element doesn't have an ID, generate one.
                    // this is needed for the autocomplete for work properly, e.g.
                    // to hide the loader icon after the results have been fetched
                    Core.UI.GetID($(this));

                    Core.UI.Autocomplete.Init(
                        $(this),
                        function(Request, Response) {
                            var Data = [],
                                ItemLC = '',
                                PossibleActionsList = Core.Config.Get('PossibleActionsList');

                            if (Request.term === '**') {
                                Data = PossibleActionsList;
                            }
                            else {
                                $.each(PossibleActionsList, function(Index, Item) {
                                    ItemLC = Item.value.toLowerCase();
                                    if (ItemLC.indexOf(Request.term.toLowerCase()) !== -1) {
                                        Data.push(Item);
                                    }
                                });
                            }
                            Response(Data);
                        },
                        function(Event, UI) {
                            $(Event.target).val(UI.item.value);
                        },
                        'ACLOptionsAutocomplete'
                    );
                }
            });


        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.ACL || {}));
