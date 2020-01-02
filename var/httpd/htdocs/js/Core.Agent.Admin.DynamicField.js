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
 * @namespace Core.Agent.Admin.DynamicField
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the DynamicField module.
 */
Core.Agent.Admin.DynamicField = (function (TargetNS) {

    /**
     * @private
     * @name SerializeData
     * @memberof Core.Agent.Admin.DynamicField
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
     * @name Redirect
     * @memberof Core.Agent.Admin.DynamicField
     * @function
     * @param {String} FieldType - Type of DynamicField.
     * @param {String} ObjectType
     * @description
     *      Redirect to URL based on DynamicField config.
     */
    TargetNS.Redirect = function(FieldType, ObjectType) {
        var DynamicFieldsConfig, Action, URL, FieldOrder;

        // get configuration
        DynamicFieldsConfig = Core.Config.Get('DynamicFields');

        // get action
        Action = DynamicFieldsConfig[ FieldType ];

        // get field order
        FieldOrder = parseInt($('#MaxFieldOrder').val(), 10) + 1;

        // redirect to correct url
        URL = Core.Config.Get('Baselink') + 'Action=' + Action + ';Subaction=Add' + ';ObjectType=' + ObjectType + ';FieldType=' + FieldType + ';FieldOrder=' + FieldOrder;
        URL += SerializeData(Core.App.GetSessionInformation());
        window.location = URL;
    };

    /**
     * @name ValidationInit
     * @memberof Core.Agent.Admin.DynamicField
     * @function
     * @description
     *      Adds specific validation rules to the frontend module.
     */
    TargetNS.ValidationInit = function() {
        Core.Form.Validate.AddRule("Validate_Alphanumeric", {
            /*eslint-disable camelcase */
            Validate_Alphanumeric: true
            /*eslint-enable camelcase */
        });
        Core.Form.Validate.AddMethod("Validate_Alphanumeric", function (Value) {
            return (/^[a-zA-Z0-9]+$/.test(Value));
        }, "");

        Core.Form.Validate.AddRule("Validate_PositiveNegativeNumbers", {
            /*eslint-disable camelcase */
            Validate_PositiveNegativeNumbers: true
            /*eslint-enable camelcase */
        });
        Core.Form.Validate.AddMethod("Validate_PositiveNegativeNumbers", function (Value) {
            return (/^-?[0-9]+$/.test(Value));
        }, "");
    };

    /**
     * @name DynamicFieldAddAction
     * @memberof Core.Agent.Admin.DynamicField
     * @function
     * @description
     *      Bind event on dynamic field add action field.
     */
    TargetNS.DynamicFieldAddAction = function () {
        var ObjectType = Core.Config.Get('ObjectTypes'),
            Key;

        // Bind event on dynamic field add action
        function FieldAddAction(Type) {
            $('#' + Type + 'DynamicField').on('change', function() {
                if ($(this).val() !== null && $(this).val() !== '') {
                    Core.Agent.Admin.DynamicField.Redirect($(this).val(), Type);

                    // reset select value to none
                    $(this).val('');
                }

                // Show OTRSBusiness upgrade dialog.
                else if (!parseInt(Core.Config.Get('OTRSBusinessIsInstalled'), 10)) {
                    Core.Agent.ShowOTRSBusinessRequiredDialog();
                }

                return false;
            });
        }
        for (Key in ObjectType) {
            FieldAddAction(ObjectType[Key]);
        }
    };

    /**
     * @name ShowContextSettingsDialog
     * @memberof Core.Agent.Admin.DynamicField
     * @function
     * @description
     *      Bind event on Setting button.
     */
    TargetNS.ShowContextSettingsDialog = function() {
        $('#ShowContextSettingsDialog').on('click', function (Event) {
            Core.UI.Dialog.ShowContentDialog($('#ContextSettingsDialogContainer'), Core.Language.Translate("Settings"), '20%', 'Center', true,
                [
                    {
                        Label: Core.Language.Translate("Save"),
                        Type: 'Submit',
                        Class: 'Primary'}
                ]);
            Event.preventDefault();
            Event.stopPropagation();
            return false;
        });
    }

    /**
     * @name DynamicFieldDelete
     * @memberof Core.Agent.Admin.DynamicField
     * @function
     * @description
     *      Bind event on dynamic field delete button.
     */
    TargetNS.DynamicFieldDelete = function() {
        $('.DynamicFieldDelete').on('click', function (Event) {

            if (window.confirm(Core.Language.Translate("Do you really want to delete this dynamic field? ALL associated data will be LOST!"))) {

                Core.UI.Dialog.ShowDialog({
                    Title: Core.Language.Translate("Delete field"),
                    HTML: Core.Language.Translate("Deleting the field and its data. This may take a while..."),
                    Modal: true,
                    CloseOnClickOutside: false,
                    CloseOnEscape: false,
                    PositionTop: '20%',
                    PositionLeft: 'Center',
                    Buttons: []
                });

                Core.AJAX.FunctionCall(
                    Core.Config.Get('Baselink'),
                    $(this).data('query-string') + 'Confirmed=1;',
                    function() {
                        window.location.reload();
                    }
                );
            }

            // don't interfere with MasterAction
            Event.stopPropagation();
            Event.preventDefault();
            return false;
        });
    };

    /**
     * @name Init
     * @memberof Core.Agent.Admin.DynamicField
     * @function
     * @description
     *       Initialize module functionality
     */
    TargetNS.Init = function () {

        // Initialize JS functions
        TargetNS.ValidationInit();
        TargetNS.DynamicFieldAddAction();
        TargetNS.ShowContextSettingsDialog();
        TargetNS.DynamicFieldDelete();

        // Initialize dynamic field filter
        Core.UI.Table.InitTableFilter($('#FilterDynamicFields'), $('#DynamicFieldsTable'));

        Core.Config.Set('EntityType', 'DynamicField');

    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.DynamicField || {}));
