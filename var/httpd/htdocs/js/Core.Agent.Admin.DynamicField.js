// --
// Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
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

    return TargetNS;
}(Core.Agent.Admin.DynamicField || {}));
