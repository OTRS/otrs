// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --
// nofilter(TidyAll::Plugin::OTRS::JavaScript::UnloadEvent)

"use strict";

var Core = Core || {};

/**
 * @namespace Core.Init
 * @memberof Core
 * @author OTRS AG
 * @description
 *      This namespace contains initialization functionalities.
 */
Core.Init = (function (TargetNS) {
    /**
     * @private
     * @name Namespaces
     * @memberof Core.Init
     * @member {Object}
     * @description
     *      Contains all registered JS namespaces,
     *      organized in initialization blocks.
     */
    var Namespaces = {};

    /**
     * @name RegisterNamespace
     * @memberof Core.Init
     * @function
     * @param {Object} NewNamespace - The new namespace to register
     * @param {String} InitializationBlock - The name of the initialization block in which the namespace should be registered
     * @description
     *      Register a new JavaScript namespace for the OTRS app.
     *      Parameters define, when the init function of the registered namespace
     *      should be executed.
     */
    TargetNS.RegisterNamespace = function (NewNamespace, InitializationBlock) {
        // all three parameters must be defined
        if (typeof NewNamespace === 'undefined' || typeof InitializationBlock === 'undefined') {
            return;
        }

        // if initialization block does not exist (yet), create it
        if (typeof Namespaces[InitializationBlock] === 'undefined') {
            Namespaces[InitializationBlock] = [];
        }

        // register namespace
        Namespaces[InitializationBlock].push({Namespace: NewNamespace});
    };

    /**
     * @name ExecuteInit
     * @memberof Core.Init
     * @function
     * @param {String} InitializationBlock - The block of registered namespaces that should be initialized
     * @description
     *      Initialize the OTRS app. Call all init function of all
     *      previously registered JS namespaces.
     *      Parameter defines, which initialization block should be executed.
     */
    TargetNS.ExecuteInit = function (InitializationBlock) {
        // initialization block must be defined
        if (typeof InitializationBlock === 'undefined') {
            return;
        }

        // initialization block must exist
        if (typeof Namespaces[InitializationBlock] === 'undefined') {
            return;
        }

        // initialization block must contain namespaces
        if (Namespaces[InitializationBlock].length < 1) {
            return;
        }

        $.each(Namespaces[InitializationBlock], function () {
            if ($.isFunction(this.Namespace.Init)) {
                this.Namespace.Init();
            }
        });
    };

    return TargetNS;
}(Core.Init || {}));
