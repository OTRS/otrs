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

/**
 * @namespace Core.Agent.LinkObject
 * @memberof Core.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for LinkObject.
 */
Core.Agent.LinkObject = (function (TargetNS) {

    /**
     * @private
     * @name InitInstantLinkDelete
     * @memberof Core.Agent.LinkObject
     * @function
     * @description
     *      Initializes the instant link delete buttons.
     */
    function InitInstantLinkDelete() {
        $('.InstantLinkDelete').off('click.InstantLinkDelete').on('click.InstantLinkDelete', function () {
            var Data,
                $TriggerObj = $(this);

            if (!window.confirm(Core.Language.Translate('Do you really want to delete this link?'))) {
               return false;
            }

            Data = {
                Action: 'AgentLinkObject',
                Subaction: 'InstantLinkDelete',
                SourceObject: $(this).data('delete-link-sourceobject'),
                SourceKey: $(this).data('delete-link-sourcekey'),
                TargetIdentifier: $(this).data('delete-link-targetidentifier')
            };

            Core.AJAX.FunctionCall(
                Core.Config.Get('Baselink'),
                Data,
                function(Response) {
                    if (parseInt(Response.Success, 10)) {

                        // check if the current item is the only item in the sorrounding table
                        if ($TriggerObj.closest('tbody').find('tr').length == 1) {
                            $TriggerObj.closest('.WidgetSimple').fadeOut(function() {
                                $(this).remove();
                            });
                        }
                        // otherwise, just remove the current item
                        else {
                            $TriggerObj.closest('tr').fadeOut(function() {
                                $(this).remove();
                            });
                        }
                    }
                }
            );
            return false;
        });
    }

    /**
     * @name RegisterUpdatePreferences
     * @memberof Core.Agent.LinkObject
     * @function
     * @param {jQueryObject} $ClickedElement - The jQuery object of the element(s) that get the event listener.
     * @param {string} ElementID - The ID of the element whose content should be updated with the server answer.
     * @param {jQueryObject} $Form - The jQuery object of the form with the data for the server request.
     * @description
     *      This function binds a click event on an html element to update the preferences of the given linked object widget
     */
    TargetNS.RegisterUpdatePreferences = function ($ClickedElement, ElementID, $Form) {
        if (isJQueryObject($ClickedElement) && $ClickedElement.length) {
            $ClickedElement.click(function () {
                var URL = Core.Config.Get('Baselink') + Core.AJAX.SerializeForm($Form);

                Core.AJAX.ContentUpdate($('#' + ElementID), URL, function () {
                    var Regex = new RegExp('^Widget(.*?)$'),
                        Name = ElementID.match(Regex)[1];

                    Core.Agent.TableFilters.SetAllocationList(Name);
                    RegisterActions(Name);
                });
            });
        }

        InitInstantLinkDelete();
        Core.UI.InitWidgetActionToggle();
    };

    /**
     * @name Init
     * @memberof Core.Agent.LinkObject
     * @function
     * @description
     *      This function initializes module functionality.
     */
    TargetNS.Init = function () {

        var LinkObjectTables = Core.Config.Get('LinkObjectTables'),
            ArrayIndex;

        // If there are no link object complex tables dont't do anything.
        if (typeof LinkObjectTables === 'undefined') return;

        for (ArrayIndex in LinkObjectTables) {

            // Events for link object complex table.
            if (typeof LinkObjectTables[ArrayIndex] !== 'undefined') {
                RegisterActions(Core.App.EscapeSelector(LinkObjectTables[ArrayIndex]));
            }
        }

        // Initialize allocation list.
        Core.Agent.TableFilters.SetAllocationList();

        InitInstantLinkDelete();
    };

    /**
     * @private
     * @name RegisterActions
     * @memberof Core.Agent.LinkObject
     * @function
     * @param {string} Name - Widget name (like Ticket, FAQ,...)
     * @description
     *      This function registers necesary events and initializes LinkedObject widget.
     */
    function RegisterActions(Name) {
        // Update preferences and load linked table via AJAX
        TargetNS.RegisterUpdatePreferences(
            $('#linkobject-' + Name + '_submit'),
            'Widget' + Name,
            $('#linkobject-' + Name + '_setting_form')
        );

        // register click on settings button
        Core.UI.RegisterToggleTwoContainer(
            $('#linkobject-' + Name + '-toggle'),
            $('#linkobject-' + Name + '-setting'),
            $('#' + Name)
        );

        // toggle two containers when user press Cancel
        Core.UI.RegisterToggleTwoContainer(
            $('#linkobject-' + Name + '_cancel'),
            $('#linkobject-' + Name + '-setting'),
            $('#' + Name)
        );
    }

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.LinkObject || {}));
