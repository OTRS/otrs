// --
// Core.Agent.Admin.ACL.js - provides the special module functions for the ACL administration interface
// Copyright (C) 2003-2013 OTRS AG, http://otrs.org/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};
Core.Agent.Admin = Core.Agent.Admin || {};

/**
 * @namespace
 * @exports TargetNS as Core.Agent.Admin.ACL
 * @description
 *      This namespace contains the special module functions for the ACL module.
 */
Core.Agent.Admin.ACL = (function (TargetNS) {

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
                   Label: TargetNS.Localization.CancelMsg,
                   Class: 'Primary',
                   Function: function () {
                       Core.UI.Dialog.CloseDialog($('.Dialog'));
                   }
               },
               {
                   Label: TargetNS.Localization.DeleteMsg,
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

    TargetNS.RestoreACLData = function($DataObj, $TargetObj) {

        var JSONString = $DataObj.val(),
            Data,
            Level1Key,
            Level2Key,
            Level3Key,
            Level4Key,
            $ItemObjLevel1,
            $ItemObjLevel2,
            $ItemObjLevel3,
            $ItemObjLevel4,
            $TempObjLevel2,
            $TempObjLevel3,
            $TempObjLevel4,
            SelectHTML,
            Value,
            Class,
            Bool;

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
                    .text(Level1Key)
                    .next('ul')
                    .find('.Icon.Add')
                    .after($('#' + Level1Key).parent().html());

                if (typeof Data[Level1Key] === 'object') {

                    $TempObjLevel2 = $('<div />');

                    for (Level2Key in Data[Level1Key]) {

                        if (Data[Level1Key].hasOwnProperty(Level2Key)) {

                            if (Level2Key === 'ActivityDialog') {
                                $ItemObjLevel2 = $('#TemplateLevel2Last > li').clone();
                            }
                            else {
                                $ItemObjLevel2 = $('#TemplateLevel2 > li').clone();
                            }

                            $ItemObjLevel2
                                .attr('data-content', Level2Key)
                                .find('strong')
                                .text(Level2Key)
                                .next('ul')
                                .find('.Icon.Add')
                                .next('input')
                                .attr('data-parent', Level2Key);

                            if ( Level2Key === 'DynamicField' || Level2Key === 'Action' ) {
                                SelectHTML = $('#' + Level2Key).parent().html();
                                SelectHTML += '<span class="AddAll">' + Core.Agent.Admin.ACL.Localization.AddAll + '</span>';

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

                            if (Level2Key === 'ActivityDialog') {

                                $ItemObjLevel2.find('ul').addClass('LastLevel');

                                $TempObjLevel3 = $('<div />');

                                for (Level3Key in Data[Level1Key][Level2Key]) {

                                    if (Data[Level1Key][Level2Key].hasOwnProperty(Level3Key)) {

                                        Value = Data[Level1Key][Level2Key][Level3Key];

                                        $ItemObjLevel3 = $('#TemplateLevel4 > li').clone();
                                        $ItemObjLevel3
                                            .attr('data-content', Value)
                                            .find('em')
                                            .before('<span>' + Value + '</span>');

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
                                                .after('<span>' + Level3Key + '</span>' + ':');

                                            if (typeof Data[Level1Key][Level2Key][Level3Key] !== 'object') {

                                                Class = 'True';
                                                Bool  = parseInt(Data[Level1Key][Level2Key][Level3Key], 10);

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
                                                            .before('<span>' + Value + '</span>');

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

    TargetNS.AddItem = function($Object, Type) {

        var AlreadyAdded = false,
            Value = $Object.val(),
            Level = parseInt($Object.attr('data-level'), 10),
            $LevelObj, $Target, $TriggerObj,
            Prefix, SelectHTML;

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
                    .text(Value)
                    .next('ul')
                    .find('.Icon.Add')
                    .after($('#' + Value).parent().html());
                $Target.append($LevelObj);
            }
            else {
                alert(Core.Agent.Admin.ACL.Localization.AlreadyAdded);
            }
            $Object.blur().val('');
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

                if (Value === 'ActivityDialog') {
                    $LevelObj = $('#TemplateLevel2Last > li').clone();
                    $TriggerObj = $LevelObj.find('.Add');
                }
                else {
                    $LevelObj = $('#TemplateLevel2 > li').clone();
                }

                $LevelObj
                    .attr('data-content', Value)
                    .find('strong')
                    .text(Value)
                    .next('ul')
                    .find('.Icon.Add')
                    .next('input')
                    .attr('data-parent', Value);

                if ( Value === 'DynamicField' || Value === 'Action' ) {
                    SelectHTML = $('#' + Value).parent().html();
                    SelectHTML += '<span class="AddAll">' + Core.Agent.Admin.ACL.Localization.AddAll + '</span>';

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

                if (Value === 'ActivityDialog') {
                    $TriggerObj.click();
                }
            }
            else {
                alert(Core.Agent.Admin.ACL.Localization.AlreadyAdded);
            }
            $Object.blur().val('');
        }
        else if (Level === 3) {

            $LevelObj = $('#TemplateLevel3 > li').clone();
            $TriggerObj = $LevelObj.find('.Add');

            if (Value) {
                $LevelObj
                    .attr('data-content', Value)
                    .children('.Icon')
                    .after('<span>' + Value + '</span>' + ':');
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

            if ( Value && Type !== 'Boolean' ) {
                $TriggerObj.click();
            }
        }
        else if (Level === 4) {

            $LevelObj   = $('#TemplateLevel4 > li').clone();
            $TriggerObj = $Object.next('.Add');

            if (Value) {

                Prefix = $Object.prev('select').val();
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
                .prev('select')
                .addClass('Hidden')
                .next('input')
                .remove();

            if (Value) {
                $TriggerObj.click();
            }
        }
    };

    TargetNS.CollectACLData = function($ItemObj, Type) {

        var Structure = {},
            $SubItemsObj,
            ItemNameLevel1,
            ItemNameLevel2,
            ItemNameLevel3,
            ItemNameLevel4;

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

    TargetNS.InitACLEdit = function () {

        $('#ACLDelete').bind('click.ACLDelete', function (Event) {
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
                Boolean = '';

            if ($SelectObj.hasClass('Boolean')) {
                Boolean = 'Boolean';
            }

            $SelectObj.find('option').each(function() {
                $SelectObj.val($(this).attr('value'));
                TargetNS.AddItem($SelectObj, Boolean);
            });
        });

        $('.ACLStructure').on('click', '.AddDataItem', function() {
            $(this)
                .before('<input type="text" class="NewDataItem" data-level="4" />')
                .prevAll('select')
                .removeClass('Hidden');
            $('.NewDataItem').prev('select').focus();
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

            // only apply on right spans
            if ($(this).hasClass('Icon')) {
                return false;
            }

            // only apply if not of type "boolean"
            if ($(this).nextAll('ul').hasClass('Boolean')) {
                return false;
            }

            var $Obj = $(this),
                Value = $Obj.text(),
                Width = $Obj.width() + 3,
                $SelectObj = $('#TemplateLevel3').find('select'),
                $SelectObjClone = $SelectObj.clone(),
                Regex,
                RegexResult,
                LastLevel = true;

            // decide if we are already on the last level
            if (!$(this).next('em').length) {
                LastLevel = false;
            }


            if (LastLevel) {

                // get contents of the 'prefixes' selectbox to decide wether or not we
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

            if ((Event.type === 'keydown' && Event.which === 13) || Event.type !== 'keydown') {

                var Value = $(this).val();

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
            var Boolean = '';
            if ($(this).hasClass('Boolean')) {
                Boolean = 'Boolean';
            }
            TargetNS.AddItem($(this), Boolean);
        });

        $('.ACLStructure').on('click', '.DataItem em', function() {
            $(this).parent().fadeOut(300, function() {
                $(this).remove();
            });
        });

        $('.ACLStructure').on('click', '.Icon.Remove', function() {
            var Remove = false;
            if ($(this).nextAll('ul').find('li').length > 1) {
                if (confirm(Core.Agent.Admin.ACL.Localization.ConfirmRemoval)) {
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
        });

        $('#SubmitAndContinue').bind('click', function() {
            $('#ContinueAfterSave').val(1);
            $('#Submit').click();
        });

        $('#Submit, #SubmitAndContinue').bind('click', function(Event) {

            // collect data from the input areas
            TargetNS.ConfigMatch  = TargetNS.CollectACLData($('#ACLMatch'));
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
    };

    return TargetNS;
}(Core.Agent.Admin.ACL || {}));
