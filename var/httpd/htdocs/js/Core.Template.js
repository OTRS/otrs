// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

/*global nunjucks */

"use strict";

var Core = Core || {};

/**
 * @namespace Core.Template
 * @memberof Core
 * @author OTRS AG
 * @description
 *      This namespace contains initialization functionalities.
 */
Core.Template = (function (TargetNS) {

    /**
     * @private
     * @name Templates
     * @memberof Core.Template
     * @member {Object}
     * @description
     *      Contains all templates
     */
    var Templates = {},
        NunjucksEnvironment;

    /**
     * @name Load
     * @memberof Core.Template
     * @function
     * @param {Object} TemplateData - contains the objectified template data as provided by the loader
     * @description
     *      Load all template files for later use.
     */
    TargetNS.Load = function(TemplateData) {

        if (typeof TemplateData !== 'object') {
            return;
        }

        Templates = TemplateData;
    };

    /**
     * @name Render
     * @memberof Core.Template
     * @function
     * @param {String} TemplateName - The name of the templated which should be used for rendering as of Core.Template.LoadTemplates()
     * @param {Object} Data - the data which should be used for rendering (optional)
     * @returns {String} - the rendering result
     * @description
     *      Render a template with the given data.
     * @example
     *
     *   Core.Template.Render('MetaFloater', {
     *       'Variable' : 'String',
     *       'Another'  : 'Another String'
     *   });
     *
     * For more examples and possibilities, see the Nunjucks documentation.
     *
     */
    TargetNS.Render = function(TemplateName, Data) {

        var Template;

        if (typeof TemplateName === 'undefined' || typeof Templates[TemplateName] === 'undefined') {
            return;
        }

        Template = Templates[TemplateName];

        return NunjucksEnvironment.renderString(Template, Data);
    };

    /**
     * @name RenderString
     * @memberof Core.Template
     * @function
     * @param {String} TemplateString - The string which should be used for rendering as of Core.Template.LoadTemplates()
     * @param {Object} Data - the data which should be used for rendering
     * @returns {String} - the rendering result
     * @description
     *      Render a string with the given data.
     */
    TargetNS.RenderString = function(TemplateString, Data) {

        if (typeof TemplateString === 'undefined' || typeof Data === 'undefined') {
            return;
        }

        return NunjucksEnvironment.renderString(TemplateString, Data);
    };


    /**
     * @name Init
     * @memberof Core.Template
     * @function
     * @description
     *      Init the engine environment.
     */
    TargetNS.Init = function() {

        NunjucksEnvironment = new nunjucks.Environment();

        // translation
        NunjucksEnvironment.addFilter('Translate', function() {
            return Core.Language.Translate.apply(window, arguments);
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_GLOBAL_EARLY');

    return TargetNS;
}(Core.Template || {}));
