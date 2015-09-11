// --
// Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.UI = Core.UI || {};

/**
 * @namespace Core.UI.InputFields
 * @memberof Core.UI
 * @author OTRS AG
 * @description
 *      Unified input fields.
 */
Core.UI.InputFields = (function (TargetNS) {

    /**
     * @private
     * @name Config
     * @memberof Core.UI.InputFields
     * @member {Object}
     * @description
     *      Configuration object.
    */
    var Config = {
        InputFieldPadding: 3,
        SelectionBoxOffsetLeft: 5,
        SelectionBoxOffsetRight: 5,
        ErrorClass: 'Error',
        ServerErrorClass: 'ServerError',
        FadeDuration: 150,
        SelectionNotAvailable: ' -',
        ResizeEvent: 'onorientationchange' in window ? 'orientationchange' : 'resize',
        ResizeTimeout: 0,
        Diacritics: {
            "\u24B6":"A", "\uFF21":"A", "\u00C0":"A", "\u00C1":"A", "\u00C2":"A", "\u1EA6":"A",
            "\u1EA4":"A", "\u1EAA":"A", "\u1EA8":"A", "\u00C3":"A", "\u0100":"A", "\u0102":"A",
            "\u1EB0":"A", "\u1EAE":"A", "\u1EB4":"A", "\u1EB2":"A", "\u0226":"A", "\u01E0":"A",
            "\u00C4":"A", "\u01DE":"A", "\u1EA2":"A", "\u00C5":"A", "\u01FA":"A", "\u01CD":"A",
            "\u0200":"A", "\u0202":"A", "\u1EA0":"A", "\u1EAC":"A", "\u1EB6":"A", "\u1E00":"A",
            "\u0104":"A", "\u023A":"A", "\u2C6F":"A", "\uA732":"AA", "\u00C6":"AE", "\u01FC":"AE",
            "\u01E2":"AE", "\uA734":"AO", "\uA736":"AU", "\uA738":"AV", "\uA73A":"AV", "\uA73C":"AY",
            "\u24B7":"B", "\uFF22":"B", "\u1E02":"B", "\u1E04":"B", "\u1E06":"B", "\u0243":"B",
            "\u0182":"B", "\u0181":"B", "\u24B8":"C", "\uFF23":"C", "\u0106":"C", "\u0108":"C",
            "\u010A":"C", "\u010C":"C", "\u00C7":"C", "\u1E08":"C", "\u0187":"C", "\u023B":"C",
            "\uA73E":"C", "\u24B9":"D", "\uFF24":"D", "\u1E0A":"D", "\u010E":"D", "\u1E0C":"D",
            "\u1E10":"D", "\u1E12":"D", "\u1E0E":"D", "\u0110":"D", "\u018B":"D", "\u018A":"D",
            "\u0189":"D", "\uA779":"D", "\u01F1":"DZ", "\u01C4":"DZ", "\u01F2":"Dz", "\u01C5":"Dz",
            "\u24BA":"E", "\uFF25":"E", "\u00C8":"E", "\u00C9":"E", "\u00CA":"E", "\u1EC0":"E",
            "\u1EBE":"E", "\u1EC4":"E", "\u1EC2":"E", "\u1EBC":"E", "\u0112":"E", "\u1E14":"E",
            "\u1E16":"E", "\u0114":"E", "\u0116":"E", "\u00CB":"E", "\u1EBA":"E", "\u011A":"E",
            "\u0204":"E", "\u0206":"E", "\u1EB8":"E", "\u1EC6":"E", "\u0228":"E", "\u1E1C":"E",
            "\u0118":"E", "\u1E18":"E", "\u1E1A":"E", "\u0190":"E", "\u018E":"E", "\u24BB":"F",
            "\uFF26":"F", "\u1E1E":"F", "\u0191":"F", "\uA77B":"F", "\u24BC":"G", "\uFF27":"G",
            "\u01F4":"G", "\u011C":"G", "\u1E20":"G", "\u011E":"G", "\u0120":"G", "\u01E6":"G",
            "\u0122":"G", "\u01E4":"G", "\u0193":"G", "\uA7A0":"G", "\uA77D":"G", "\uA77E":"G",
            "\u24BD":"H", "\uFF28":"H", "\u0124":"H", "\u1E22":"H", "\u1E26":"H", "\u021E":"H",
            "\u1E24":"H", "\u1E28":"H", "\u1E2A":"H", "\u0126":"H", "\u2C67":"H", "\u2C75":"H",
            "\uA78D":"H", "\u24BE":"I", "\uFF29":"I", "\u00CC":"I", "\u00CD":"I", "\u00CE":"I",
            "\u0128":"I", "\u012A":"I", "\u012C":"I", "\u0130":"I", "\u00CF":"I", "\u1E2E":"I",
            "\u1EC8":"I", "\u01CF":"I", "\u0208":"I", "\u020A":"I", "\u1ECA":"I", "\u012E":"I",
            "\u1E2C":"I", "\u0197":"I", "\u24BF":"J", "\uFF2A":"J", "\u0134":"J", "\u0248":"J",
            "\u24C0":"K", "\uFF2B":"K", "\u1E30":"K", "\u01E8":"K", "\u1E32":"K", "\u0136":"K",
            "\u1E34":"K", "\u0198":"K", "\u2C69":"K", "\uA740":"K", "\uA742":"K", "\uA744":"K",
            "\uA7A2":"K", "\u24C1":"L", "\uFF2C":"L", "\u013F":"L", "\u0139":"L", "\u013D":"L",
            "\u1E36":"L", "\u1E38":"L", "\u013B":"L", "\u1E3C":"L", "\u1E3A":"L", "\u0141":"L",
            "\u023D":"L", "\u2C62":"L", "\u2C60":"L", "\uA748":"L", "\uA746":"L", "\uA780":"L",
            "\u01C7":"LJ", "\u01C8":"Lj", "\u24C2":"M", "\uFF2D":"M", "\u1E3E":"M", "\u1E40":"M",
            "\u1E42":"M", "\u2C6E":"M", "\u019C":"M", "\u24C3":"N", "\uFF2E":"N", "\u01F8":"N",
            "\u0143":"N", "\u00D1":"N", "\u1E44":"N", "\u0147":"N", "\u1E46":"N", "\u0145":"N",
            "\u1E4A":"N", "\u1E48":"N", "\u0220":"N", "\u019D":"N", "\uA790":"N", "\uA7A4":"N",
            "\u01CA":"NJ", "\u01CB":"Nj", "\u24C4":"O", "\uFF2F":"O", "\u00D2":"O", "\u00D3":"O",
            "\u00D4":"O", "\u1ED2":"O", "\u1ED0":"O", "\u1ED6":"O", "\u1ED4":"O", "\u00D5":"O",
            "\u1E4C":"O", "\u022C":"O", "\u1E4E":"O", "\u014C":"O", "\u1E50":"O", "\u1E52":"O",
            "\u014E":"O", "\u022E":"O", "\u0230":"O", "\u00D6":"O", "\u022A":"O", "\u1ECE":"O",
            "\u0150":"O", "\u01D1":"O", "\u020C":"O", "\u020E":"O", "\u01A0":"O", "\u1EDC":"O",
            "\u1EDA":"O", "\u1EE0":"O", "\u1EDE":"O", "\u1EE2":"O", "\u1ECC":"O", "\u1ED8":"O",
            "\u01EA":"O", "\u01EC":"O", "\u00D8":"O", "\u01FE":"O", "\u0186":"O", "\u019F":"O",
            "\uA74A":"O", "\uA74C":"O", "\u0152":"OE", "\u01A2":"OI", "\uA74E":"OO", "\u0222":"OU",
            "\u24C5":"P", "\uFF30":"P", "\u1E54":"P", "\u1E56":"P", "\u01A4":"P", "\u2C63":"P",
            "\uA750":"P", "\uA752":"P", "\uA754":"P", "\u24C6":"Q", "\uFF31":"Q", "\uA756":"Q",
            "\uA758":"Q", "\u024A":"Q", "\u24C7":"R", "\uFF32":"R", "\u0154":"R", "\u1E58":"R",
            "\u0158":"R", "\u0210":"R", "\u0212":"R", "\u1E5A":"R", "\u1E5C":"R", "\u0156":"R",
            "\u1E5E":"R", "\u024C":"R", "\u2C64":"R", "\uA75A":"R", "\uA7A6":"R", "\uA782":"R",
            "\u24C8":"S", "\uFF33":"S", "\u015A":"S", "\u1E64":"S", "\u015C":"S", "\u1E60":"S",
            "\u0160":"S", "\u1E66":"S", "\u1E62":"S", "\u1E68":"S", "\u0218":"S", "\u015E":"S",
            "\u2C7E":"S", "\uA7A8":"S", "\uA784":"S", "\u1E9E":"SS", "\u24C9":"T", "\uFF34":"T",
            "\u1E6A":"T", "\u0164":"T", "\u1E6C":"T", "\u021A":"T", "\u0162":"T", "\u1E70":"T",
            "\u1E6E":"T", "\u0166":"T", "\u01AC":"T", "\u01AE":"T", "\u023E":"T", "\uA786":"T",
            "\uA728":"TZ", "\u24CA":"U", "\uFF35":"U", "\u00D9":"U", "\u00DA":"U", "\u00DB":"U",
            "\u0168":"U", "\u1E78":"U", "\u016A":"U", "\u1E7A":"U", "\u016C":"U", "\u00DC":"U",
            "\u01DB":"U", "\u01D7":"U", "\u01D5":"U", "\u01D9":"U", "\u1EE6":"U", "\u016E":"U",
            "\u0170":"U", "\u01D3":"U", "\u0214":"U", "\u0216":"U", "\u01AF":"U", "\u1EEA":"U",
            "\u1EE8":"U", "\u1EEE":"U", "\u1EEC":"U", "\u1EF0":"U", "\u1EE4":"U", "\u1E72":"U",
            "\u0172":"U", "\u1E76":"U", "\u1E74":"U", "\u0244":"U", "\u24CB":"V", "\uFF36":"V",
            "\u1E7C":"V", "\u1E7E":"V", "\u01B2":"V", "\uA75E":"V", "\u0245":"V", "\uA760":"VY",
            "\u24CC":"W", "\uFF37":"W", "\u1E80":"W", "\u1E82":"W", "\u0174":"W", "\u1E86":"W",
            "\u1E84":"W", "\u1E88":"W", "\u2C72":"W", "\u24CD":"X", "\uFF38":"X", "\u1E8A":"X",
            "\u1E8C":"X", "\u24CE":"Y", "\uFF39":"Y", "\u1EF2":"Y", "\u00DD":"Y", "\u0176":"Y",
            "\u1EF8":"Y", "\u0232":"Y", "\u1E8E":"Y", "\u0178":"Y", "\u1EF6":"Y", "\u1EF4":"Y",
            "\u01B3":"Y", "\u024E":"Y", "\u1EFE":"Y", "\u24CF":"Z", "\uFF3A":"Z", "\u0179":"Z",
            "\u1E90":"Z", "\u017B":"Z", "\u017D":"Z", "\u1E92":"Z", "\u1E94":"Z", "\u01B5":"Z",
            "\u0224":"Z", "\u2C7F":"Z", "\u2C6B":"Z", "\uA762":"Z", "\u24D0":"a", "\uFF41":"a",
            "\u1E9A":"a", "\u00E0":"a", "\u00E1":"a", "\u00E2":"a", "\u1EA7":"a", "\u1EA5":"a",
            "\u1EAB":"a", "\u1EA9":"a", "\u00E3":"a", "\u0101":"a", "\u0103":"a", "\u1EB1":"a",
            "\u1EAF":"a", "\u1EB5":"a", "\u1EB3":"a", "\u0227":"a", "\u01E1":"a", "\u00E4":"a",
            "\u01DF":"a", "\u1EA3":"a", "\u00E5":"a", "\u01FB":"a", "\u01CE":"a", "\u0201":"a",
            "\u0203":"a", "\u1EA1":"a", "\u1EAD":"a", "\u1EB7":"a", "\u1E01":"a", "\u0105":"a",
            "\u2C65":"a", "\u0250":"a", "\uA733":"aa", "\u00E6":"ae", "\u01FD":"ae", "\u01E3":"ae",
            "\uA735":"ao", "\uA737":"au", "\uA739":"av", "\uA73B":"av", "\uA73D":"ay", "\u24D1":"b",
            "\uFF42":"b", "\u1E03":"b", "\u1E05":"b", "\u1E07":"b", "\u0180":"b", "\u0183":"b",
            "\u0253":"b", "\u24D2":"c", "\uFF43":"c", "\u0107":"c", "\u0109":"c", "\u010B":"c",
            "\u010D":"c", "\u00E7":"c", "\u1E09":"c", "\u0188":"c", "\u023C":"c", "\uA73F":"c",
            "\u2184":"c", "\u24D3":"d", "\uFF44":"d", "\u1E0B":"d", "\u010F":"d", "\u1E0D":"d",
            "\u1E11":"d", "\u1E13":"d", "\u1E0F":"d", "\u0111":"d", "\u018C":"d", "\u0256":"d",
            "\u0257":"d", "\uA77A":"d", "\u01F3":"dz", "\u01C6":"dz", "\u24D4":"e", "\uFF45":"e",
            "\u00E8":"e", "\u00E9":"e", "\u00EA":"e", "\u1EC1":"e", "\u1EBF":"e", "\u1EC5":"e",
            "\u1EC3":"e", "\u1EBD":"e", "\u0113":"e", "\u1E15":"e", "\u1E17":"e", "\u0115":"e",
            "\u0117":"e", "\u00EB":"e", "\u1EBB":"e", "\u011B":"e", "\u0205":"e", "\u0207":"e",
            "\u1EB9":"e", "\u1EC7":"e", "\u0229":"e", "\u1E1D":"e", "\u0119":"e", "\u1E19":"e",
            "\u1E1B":"e", "\u0247":"e", "\u025B":"e", "\u01DD":"e", "\u24D5":"f", "\uFF46":"f",
            "\u1E1F":"f", "\u0192":"f", "\uA77C":"f", "\u24D6":"g", "\uFF47":"g", "\u01F5":"g",
            "\u011D":"g", "\u1E21":"g", "\u011F":"g", "\u0121":"g", "\u01E7":"g", "\u0123":"g",
            "\u01E5":"g", "\u0260":"g", "\uA7A1":"g", "\u1D79":"g", "\uA77F":"g", "\u24D7":"h",
            "\uFF48":"h", "\u0125":"h", "\u1E23":"h", "\u1E27":"h", "\u021F":"h", "\u1E25":"h",
            "\u1E29":"h", "\u1E2B":"h", "\u1E96":"h", "\u0127":"h", "\u2C68":"h", "\u2C76":"h",
            "\u0265":"h", "\u0195":"hv", "\u24D8":"i", "\uFF49":"i", "\u00EC":"i", "\u00ED":"i",
            "\u00EE":"i", "\u0129":"i", "\u012B":"i", "\u012D":"i", "\u00EF":"i", "\u1E2F":"i",
            "\u1EC9":"i", "\u01D0":"i", "\u0209":"i", "\u020B":"i", "\u1ECB":"i", "\u012F":"i",
            "\u1E2D":"i", "\u0268":"i", "\u0131":"i", "\u24D9":"j", "\uFF4A":"j", "\u0135":"j",
            "\u01F0":"j", "\u0249":"j", "\u24DA":"k", "\uFF4B":"k", "\u1E31":"k", "\u01E9":"k",
            "\u1E33":"k", "\u0137":"k", "\u1E35":"k", "\u0199":"k", "\u2C6A":"k", "\uA741":"k",
            "\uA743":"k", "\uA745":"k", "\uA7A3":"k", "\u24DB":"l", "\uFF4C":"l", "\u0140":"l",
            "\u013A":"l", "\u013E":"l", "\u1E37":"l", "\u1E39":"l", "\u013C":"l", "\u1E3D":"l",
            "\u1E3B":"l", "\u0142":"l", "\u019A":"l", "\u026B":"l", "\u2C61":"l", "\uA749":"l",
            "\uA781":"l", "\uA747":"l", "\u01C9":"lj", "\u24DC":"m", "\uFF4D":"m", "\u1E3F":"m",
            "\u1E41":"m", "\u1E43":"m", "\u0271":"m", "\u026F":"m", "\u24DD":"n", "\uFF4E":"n",
            "\u01F9":"n", "\u0144":"n", "\u00F1":"n", "\u1E45":"n", "\u0148":"n", "\u1E47":"n",
            "\u0146":"n", "\u1E4B":"n", "\u1E49":"n", "\u019E":"n", "\u0272":"n", "\u0149":"n",
            "\uA791":"n", "\uA7A5":"n", "\u01CC":"nj", "\u24DE":"o", "\uFF4F":"o", "\u00F2":"o",
            "\u00F3":"o", "\u00F4":"o", "\u1ED3":"o", "\u1ED1":"o", "\u1ED7":"o", "\u1ED5":"o",
            "\u00F5":"o", "\u1E4D":"o", "\u022D":"o", "\u1E4F":"o", "\u014D":"o", "\u1E51":"o",
            "\u1E53":"o", "\u014F":"o", "\u022F":"o", "\u0231":"o", "\u00F6":"o", "\u022B":"o",
            "\u1ECF":"o", "\u0151":"o", "\u01D2":"o", "\u020D":"o", "\u020F":"o", "\u01A1":"o",
            "\u1EDD":"o", "\u1EDB":"o", "\u1EE1":"o", "\u1EDF":"o", "\u1EE3":"o", "\u1ECD":"o",
            "\u1ED9":"o", "\u01EB":"o", "\u01ED":"o", "\u00F8":"o", "\u01FF":"o", "\u0254":"o",
            "\uA74B":"o", "\uA74D":"o", "\u0275":"o", "\u0153":"oe", "\u0276":"oe", "\u01A3":"oi",
            "\u0223":"ou", "\uA74F":"oo", "\u24DF":"p", "\uFF50":"p", "\u1E55":"p", "\u1E57":"p",
            "\u01A5":"p", "\u1D7D":"p", "\uA751":"p", "\uA753":"p", "\uA755":"p", "\u24E0":"q",
            "\uFF51":"q", "\u024B":"q", "\uA757":"q", "\uA759":"q", "\u24E1":"r", "\uFF52":"r",
            "\u0155":"r", "\u1E59":"r", "\u0159":"r", "\u0211":"r", "\u0213":"r", "\u1E5B":"r",
            "\u1E5D":"r", "\u0157":"r", "\u1E5F":"r", "\u024D":"r", "\u027D":"r", "\uA75B":"r",
            "\uA7A7":"r", "\uA783":"r", "\u24E2":"s", "\uFF53":"s", "\u015B":"s", "\u1E65":"s",
            "\u015D":"s", "\u1E61":"s", "\u0161":"s", "\u1E67":"s", "\u1E63":"s", "\u1E69":"s",
            "\u0219":"s", "\u015F":"s", "\u023F":"s", "\uA7A9":"s", "\uA785":"s", "\u017F":"s",
            "\u1E9B":"s", "\u00DF":"ss", "\u24E3":"t", "\uFF54":"t", "\u1E6B":"t", "\u1E97":"t",
            "\u0165":"t", "\u1E6D":"t", "\u021B":"t", "\u0163":"t", "\u1E71":"t", "\u1E6F":"t",
            "\u0167":"t", "\u01AD":"t", "\u0288":"t", "\u2C66":"t", "\uA787":"t", "\uA729":"tz",
            "\u24E4":"u", "\uFF55":"u", "\u00F9":"u", "\u00FA":"u", "\u00FB":"u", "\u0169":"u",
            "\u1E79":"u", "\u016B":"u", "\u1E7B":"u", "\u016D":"u", "\u00FC":"u", "\u01DC":"u",
            "\u01D8":"u", "\u01D6":"u", "\u01DA":"u", "\u1EE7":"u", "\u016F":"u", "\u0171":"u",
            "\u01D4":"u", "\u0215":"u", "\u0217":"u", "\u01B0":"u", "\u1EEB":"u", "\u1EE9":"u",
            "\u1EEF":"u", "\u1EED":"u", "\u1EF1":"u", "\u1EE5":"u", "\u1E73":"u", "\u0173":"u",
            "\u1E77":"u", "\u1E75":"u", "\u0289":"u", "\u24E5":"v", "\uFF56":"v", "\u1E7D":"v",
            "\u1E7F":"v", "\u028B":"v", "\uA75F":"v", "\u028C":"v", "\uA761":"vy", "\u24E6":"w",
            "\uFF57":"w", "\u1E81":"w", "\u1E83":"w", "\u0175":"w", "\u1E87":"w", "\u1E85":"w",
            "\u1E98":"w", "\u1E89":"w", "\u2C73":"w", "\u24E7":"x", "\uFF58":"x", "\u1E8B":"x",
            "\u1E8D":"x", "\u24E8":"y", "\uFF59":"y", "\u1EF3":"y", "\u00FD":"y", "\u0177":"y",
            "\u1EF9":"y", "\u0233":"y", "\u1E8F":"y", "\u00FF":"y", "\u1EF7":"y", "\u1E99":"y",
            "\u1EF5":"y", "\u01B4":"y", "\u024F":"y", "\u1EFF":"y", "\u24E9":"z", "\uFF5A":"z",
            "\u017A":"z", "\u1E91":"z", "\u017C":"z", "\u017E":"z", "\u1E93":"z", "\u1E95":"z",
            "\u01B6":"z", "\u0225":"z", "\u0240":"z", "\u2C6C":"z", "\uA763":"z", "\uFF10":"0",
            "\u2080":"0", "\u24EA":"0", "\u2070":"0",  "\u00B9":"1", "\u2474":"1", "\u2081":"1",
            "\u2776":"1", "\u24F5":"1", "\u2488":"1", "\u2460":"1", "\uFF11":"1",  "\u00B2":"2",
            "\u2777":"2", "\u2475":"2", "\uFF12":"2", "\u2082":"2", "\u24F6":"2", "\u2461":"2",
            "\u2489":"2", "\u00B3":"3", "\uFF13":"3", "\u248A":"3", "\u2476":"3", "\u2083":"3",
            "\u2778":"3", "\u24F7":"3", "\u2462":"3", "\u24F8":"4", "\u2463":"4", "\u248B":"4",
            "\uFF14":"4", "\u2074":"4", "\u2084":"4", "\u2779":"4", "\u2477":"4", "\u248C":"5",
            "\u2085":"5", "\u24F9":"5", "\u2478":"5", "\u277A":"5", "\u2464":"5", "\uFF15":"5",
            "\u2075":"5", "\u2479":"6", "\u2076":"6", "\uFF16":"6", "\u277B":"6", "\u2086":"6",
            "\u2465":"6", "\u24FA":"6", "\u248D":"6", "\uFF17":"7", "\u2077":"7", "\u277C":"7",
            "\u24FB":"7", "\u248E":"7", "\u2087":"7", "\u247A":"7", "\u2466":"7", "\u2467":"8",
            "\u248F":"8", "\u24FC":"8", "\u247B":"8", "\u2078":"8", "\uFF18":"8", "\u277D":"8",
            "\u2088":"8", "\u24FD":"9", "\uFF19":"9", "\u2490":"9", "\u277E":"9", "\u247C":"9",
            "\u2089":"9", "\u2468":"9", "\u2079":"9"
        }
    };

    /**
     * @name Activate
     * @memberof Core.UI.InputFields
     * @param {jQueryObject} [$Context] - jQuery object for context (optional)
     * @description
     *      Activate the feature on all applicable fields in supplied context.
     */
    TargetNS.Activate = function ($Context) {

        // Initialize select fields on all applicable fields
        TargetNS.InitSelect($('select.Modernize', $Context));
    };

    /**
     * @name Deactivate
     * @memberof Core.UI.InputFields
     * @param {jQueryObject} [$Context] - jQuery object for context (optional)
     * @description
     *      Deactivate the feature on all applicable fields in supplied context
     *      and restore original fields.
     */
    TargetNS.Deactivate = function ($Context) {

        // Restore select fields
        $('select.Modernize', $Context).each(function (Index, SelectObj) {
            var $SelectObj = $(SelectObj),
                $SearchObj = $('#' + $SelectObj.data('modernized')),
                $ShowTreeObj = $SelectObj.next('.ShowTreeSelection');

            if ($SelectObj.data('modernized')) {
                $SearchObj.parents('.InputField_Container')
                    .blur()
                    .remove();
                $SelectObj.show()
                    .removeData('modernized');
                $ShowTreeObj.show();
            }
        });
    };

    /**
     * @private
     * @name InitCallback
     * @memberof Core.UI.InputFields
     * @function
     * @description
     *      Initialization callback function.
     */
    function InitCallback() {

        // Check SysConfig
        if (Core.Config.Get('InputFieldsActivated') === 1) {

            // Activate the feature
            TargetNS.Activate();
        }
    }

    /**
     * @name Init
     * @memberof Core.UI.InputFields
     * @function
     * @description
     *      This function initializes all input field types.
     */
    TargetNS.Init = function () {
        InitCallback();
        Core.App.Subscribe('Event.UI.ToggleWidget', InitCallback);
    };

    /**
     * @private
     * @name CheckAvailability
     * @memberof Core.UI.InputFields
     * @param {jQueryObject} $SelectObj - Original select field
     * @param {jQueryObject} $SearchObj - Search input field
     * @description
     *      Checks if there are available options for selection in the supplied field
     *      and disabled the field if that is not the case.
     */
    function CheckAvailability($SelectObj, $SearchObj) {

        // Check if there are only empty and disabled options
        if ($SelectObj.find('option')
                .not("[value='']")
                .not("[value='-||']")
                .not('[disabled]')
                .length === 0
            )
        {

            // Disable the field, add the tooltip and dash string
            $SearchObj.attr('disabled', 'disabled')
                .data('disabled', true)
                .attr('title', Core.Config.Get('InputFieldsNotAvailable'))
                .val(Config.SelectionNotAvailable);
        }
        else {

            // Enable the field, remove the tooltip and dash string
            $SearchObj.removeAttr('disabled')
                .removeData('disabled')
                .removeAttr('title')
                .val('');
        }
    }

    /**
     * @private
     * @name ValidateFormElement
     * @memberof Core.UI.InputFields
     * @param {jQueryObject} $SelectObj - Select field to validate
     * @description
     *      Trigger supplied select field validation if part of appropriate form.
     */
    function ValidateFormElement($SelectObj) {

        // Get form object
        var $FormObj = $SelectObj.closest('form');

        // Check if form supports validation
        if ($FormObj.hasClass('Validate')) {
            Core.Form.Validate.ValidateElement($SelectObj);
        }
    }

    /**
     * @private
     * @name ShowSelectionBoxes
     * @memberof Core.UI.InputFields
     * @param {jQueryObject} $SelectObj - Original select field
     * @param {JQueryObject} $InputContainerObj - Container for associated input field
     * @description
     *      Creates and displays selection boxes in available width,
     *      and lists number of additional selected values.
     */
    function ShowSelectionBoxes($SelectObj, $InputContainerObj) {
        var Selection,
            SelectionLength,
            i = 0,
            OffsetLeft = 0,
            OffsetRight = Config.SelectionBoxOffsetRight,
            MoreBox = false,
            Multiple = ($SelectObj.attr('multiple') !== '' && $SelectObj.attr('multiple') !== undefined) ? true : false,
            PossibleNone = false,
            MoreString = Core.Config.Get('InputFieldsMore'),
            MaxWidth,
            $TempMoreObj;

        // Remove any existing boxes in supplied container
        $InputContainerObj.find('.InputField_Selection').remove();
        $InputContainerObj.find('.InputField_More').remove();

        $SelectObj.find('option').each(function (Index, Option) {
            if ($(Option).attr('value') === '' || $(Option).attr('value') === '||-') {
                PossibleNone = true;
                return true;
            }
        });

        // Check if we have a selection at all
        if ($SelectObj.val()) {

            // Maximum available width for boxes
            MaxWidth = $InputContainerObj.find('.InputField_Search').width();

            // Check which kind of selection we are dealing with
            if ($.isArray($SelectObj.val())) {
                Selection = $.unique($SelectObj.val());
                SelectionLength = Selection.length;
            } else {
                Selection = [ $SelectObj.val() ];
                SelectionLength = 1;
            }

            // Calculate width for hypothetical more string
            if (SelectionLength > 1) {
                $TempMoreObj = $('<div />').hide()
                    .addClass('InputField_More')
                    .text(MoreString.replace(/%s/, '##'))
                    .appendTo($InputContainerObj);

                // Save place for string
                MaxWidth -= $TempMoreObj.outerWidth();

                // Remove temporary more string
                $TempMoreObj.remove();
            }

            // Iterate through all selected values
            $.each(Selection, function (Index, Value) {
                var $SelectionObj,
                    Text,
                    $TextObj,
                    $RemoveObj;

                // Skip empty value
                if (Value === '' || Value === '||-') {
                    return true;
                }

                // Selection box container
                $SelectionObj = $('<div />').appendTo($InputContainerObj);
                $SelectionObj.addClass('InputField_Selection')
                    .data('value', Value);

                // Textual representation of selected value
                Text = $SelectObj.find('option[value="' + Value + '"]').first().text().trim();
                $TextObj = $('<div />').appendTo($SelectionObj);
                $TextObj.addClass('Text')
                    .text(Text)
                    .off('click.InputField').on('click.InputField', function () {
                        $InputContainerObj.find('.InputField_Search')
                            .trigger('focus');
                    });

                // Remove button
                if (PossibleNone || Multiple) {
                    $RemoveObj = $('<div />').appendTo($SelectionObj);
                    $RemoveObj.addClass('Remove')
                        .append(
                            $('<a />').attr('href', '#')
                                .attr('title', Core.Config.Get('InputFieldsRemoveSelection'))
                                .text('x')
                                .attr('role', 'button')
                                .attr(
                                    'aria-label',
                                    Core.Config.Get('InputFieldsRemoveSelection') + ': ' + Text
                                )
                                .off('click.InputField').on('click.InputField', function () {
                                    var HasEmptyElement = $SelectObj.find('option[value=""]').length === 0 ? false : true,
                                        SelectedValue = $(this).parents('.InputField_Selection')
                                            .data('value');
                                    Selection.splice(Selection.indexOf(SelectedValue), 1);
                                    if (HasEmptyElement && Selection.length === 0) {
                                        $SelectObj.val('');
                                    }
                                    else {
                                        $SelectObj.val(Selection);
                                    }
                                    ShowSelectionBoxes($SelectObj, $InputContainerObj);
                                    setTimeout(function () {
                                        $SelectObj.trigger('change');
                                        ValidateFormElement($SelectObj);
                                    }, 0);
                                    return false;
                                })
                        );
                }

                // Indent first box from the left
                if (OffsetLeft === 0) {
                    OffsetLeft = Config.SelectionBoxOffsetLeft;
                }

                // Check if we exceed available width of the container
                if (OffsetLeft + $SelectionObj.outerWidth() < MaxWidth) {

                    // Offset the box and show it
                    if ($('body').hasClass('RTL')) {
                        $SelectionObj.css('right', OffsetLeft + 'px')
                            .show();
                    }
                    else {
                        $SelectionObj.css('left', OffsetLeft + 'px')
                            .show();
                    }

                } else {

                    // If first selection, we must shorten it in order to display it
                    if (i === 0) {
                        while (OffsetLeft + $SelectionObj.outerWidth() >= MaxWidth) {
                            $TextObj.text(
                                $TextObj.text().substring(0, $TextObj.text().length - 4)
                                + '...'
                            );
                        }

                        // Offset the box and show it
                        if ($('body').hasClass('RTL')) {
                            $SelectionObj.css('right', OffsetLeft + 'px')
                                .show();
                        }
                        else {
                            $SelectionObj.css('left', OffsetLeft + 'px')
                                .show();
                        }
                    }

                    else {

                        // Check if we already displayed more box
                        if (!MoreBox) {
                            $SelectionObj.after(
                                $('<div />').addClass('InputField_More')
                                .css(
                                    ($('body').hasClass('RTL') ? 'right' : 'left'),
                                    OffsetLeft + 'px'
                                )
                                .text(
                                    MoreString.replace(/%s/, SelectionLength - i)
                                )
                                .on('click.InputField', function () {
                                    $InputContainerObj.find('.InputField_Search')
                                        .trigger('focus');
                                })
                            );
                            MoreBox = true;
                        }

                        // Remove superfluous box
                        $SelectionObj.remove();

                        // Break each loop
                        return false;
                    }
                }

                // Increment the offset with the width of box and right margin
                OffsetLeft += $SelectionObj.outerWidth() + OffsetRight;

                i++;
            });

        }

    }

    /**
     * @private
     * @name HideSelectList
     * @memberof Core.UI.InputFields
     * @param {jQueryObject} $SelectObj - Original select field
     * @param {JQueryObject} $InputContainerObj - Container for associated input field
     * @param {JQueryObject} $SearchObj - Search input field
     * @param {JQueryObject} $ListContainerObj - List container
     * @param {JQueryObject} $TreeContainerObj - Container for jsTree list
     * @description
     *      Remove complete jsTree list and action buttons.
     */
    function HideSelectList($SelectObj, $InputContainerObj, $SearchObj, $ListContainerObj, $TreeContainerObj) {

        // Remove jsTree if it exists
        if ($ListContainerObj && $TreeContainerObj) {
            $ListContainerObj.fadeOut(Config.FadeDuration, function () {
                $TreeContainerObj.find('.jstree')
                    .jstree('destroy')
                    .remove();
                $(this).remove();
                Core.App.Publish('Event.UI.InputFields.Closed', $SearchObj);
            });
            $InputContainerObj.find('.InputField_ClearSearch')
                .remove();
            $SearchObj.removeAttr('aria-expanded');
        }

        // Clear search field
        if ($SearchObj.val() !== Config.SelectionNotAvailable && !$SearchObj.attr('disabled')) {
            $SearchObj.val('');
        }

        // Show selection boxes
        ShowSelectionBoxes($SelectObj, $InputContainerObj);

        // Trigger change event on original field (see bug#11419)
        if ($SelectObj.data('changed')) {
            $SelectObj.removeData('changed');
            setTimeout(function () {
                $SelectObj.trigger('change');
                ValidateFormElement($SelectObj);
            }, 0);
        }
    }

    /**
     * @private
     * @name RegisterActionEvent
     * @memberof Core.UI.InputFields
     * @param {jQueryObject} $TreeObj - Tree view object
     * @param {jQueryObject} $ActionObj - Action link object
     * @param {String} ActionType - Type of the action
     * @description
     *      Register click handler for supplied action.
     */
    function RegisterActionEvent($TreeObj, $ActionObj, ActionType) {

        switch (ActionType) {

            case 'SelectAll':
                $ActionObj.off('click.InputField').on('click.InputField', function () {

                    // Make sure subtrees of all nodes are expanded
                    $TreeObj.jstree('open_all');

                    // Select all nodes
                    $TreeObj.find('li')
                        .not('.jstree-clicked,.Disabled')
                        .each(function () {
                            $TreeObj.jstree('select_node', this);
                        });

                    return false;

                // Prevent clicks on action to steal focus from search field
                }).on('mousedown.InputField', function () {
                    return false;
                });
                break;

            case 'SelectAll_Search':
                $ActionObj.off('click.InputField').on('click.InputField', function () {

                    // Select only matched values
                    $TreeObj.find('li:visible .jstree-search')
                        .not('.jstree-clicked,.Disabled')
                        .each(function () {
                            $TreeObj.jstree('select_node', this);
                        });
                });
                break;

            case 'ClearAll':
                $ActionObj.off('click.InputField').on('click.InputField', function () {

                    // Clear selection
                    $TreeObj.jstree('deselect_node', $TreeObj.jstree('get_selected'));

                    return false;

                // Prevent clicks on action to steal focus from search field
                }).on('mousedown.InputField', function () {
                    return false;
                });
                break;

            case 'ClearAll_Search':
                $ActionObj.off('click.InputField').on('click.InputField', function () {

                    // Deselect only matched values
                    var SelectedNodesIDs = $TreeObj.jstree('get_selected');
                    $.each(SelectedNodesIDs, function () {
                        var $Node = $('#' + this);
                        if ($Node.is(':visible')) {
                            $TreeObj.jstree('deselect_node', this);
                        }
                    });
                });
                break;

            case 'Confirm':
                $ActionObj.off('click.InputField').on('click.InputField', function () {

                    // Hide the list
                    $TreeObj.blur();

                    return false;

                });
                break;
        }
    }

    /**
     * @private
     * @name ApplyFilter
     * @memberof Core.UI.InputFields
     * @param {jQueryObject} $SelectObj - Select object
     * @param {jQueryObject} $ToolbarContainerObj - Container for toolbar actions
     * @description
     *      Apply active filter on select field.
     */
    function ApplyFilter($SelectObj, $ToolbarContainerObj) {
        var Selection,
            FilterIndex;

        // Save selection
        if ($SelectObj.val()) {

            // Check which kind of selection we are dealing with
            if ($.isArray($SelectObj.val())) {
                Selection = $SelectObj.val();
            } else {
                Selection = [ $SelectObj.val() ];
            }

            $SelectObj.data('selection', Selection);
        }

        $SelectObj.empty();

        if ($SelectObj.data('filtered') && $SelectObj.data('filtered') !== '0') {
            FilterIndex = parseInt($SelectObj.data('filtered'), 10) - 1;

            // Insert filtered data
            $.each($SelectObj.data('filters').Filters[FilterIndex].Data, function (Index, Option) {
                var $OptionObj = $('<option />');
                $OptionObj.attr('value', Option.Key)
                    .text(Option.Value);
                if (Option.Disabled) {
                    $OptionObj.attr('disabled', true);
                }
                if (Option.Selected) {
                    $OptionObj.attr('selected', true);
                }
                $SelectObj.append($OptionObj);
            });

            // Add class
            if ($ToolbarContainerObj) {
                if (
                    !$ToolbarContainerObj.find('.InputField_Filters')
                        .hasClass('Active')
                    )
                {
                    $ToolbarContainerObj.find('.InputField_Filters')
                        .addClass('Active')
                        .prepend('<i class="fa fa-filter" /> ');
                }
            }
        }
        else {

            // Remove class
            if ($ToolbarContainerObj) {
                $ToolbarContainerObj.find('.InputField_Filters')
                    .removeClass('Active')
                    .find('.fa.fa-filter')
                    .remove();
            }

            // Restore original data
            $SelectObj.append($SelectObj.data('original'));
        }

        // Restore selection
        if ($SelectObj.data('selection')) {
            $SelectObj.val($SelectObj.data('selection'));
            $SelectObj.removeData('selection');
        }
    }

    /**
     * @private
     * @name RegisterFilterEvent
     * @memberof Core.UI.InputFields
     * @param {jQueryObject} $SelectObj - Select object
     * @param {jQueryObject} $InputContainerObj - Container object for associated input field
     * @param {jQueryObject} $ToolbarContainerObj - Container for toolbar actions
     * @param {jQueryObject} $FilterObj - Filter object
     * @param {String} ActionType - Type of the action
     * @description
     *      Register click handler for supplied action.
     */
    function RegisterFilterEvent($SelectObj, $InputContainerObj, $ToolbarContainerObj, $FilterObj, ActionType) {
        var $SearchObj;

        switch (ActionType) {

            case 'ShowFilters':
                $FilterObj.off('click.InputField').on('click.InputField', function () {
                    var $FiltersListObj = $ToolbarContainerObj.find('.InputField_FiltersList');

                    // Hide filter list
                    if ($FiltersListObj.is(':visible')) {
                        $FiltersListObj.hide();
                    }

                    // Show filter list
                    else {
                        $FiltersListObj.show();
                    }

                    return false;

                // Prevent clicks on action to steal focus from search field
                }).on('mousedown.InputField', function () {
                    return false;
                });
                break;

            case 'Filter':
                $FilterObj.off('click.InputField').on('click.InputField', function () {

                    // Allow selection of only one filter
                    $FilterObj.siblings('input').each(function (Index, Filter) {
                        if ($(Filter).attr('id') !== $FilterObj.attr('id')) {
                            $(Filter).attr('checked', false);
                        }
                    });
                })

                // Handle checkbox change
                .off('change.InputField').on('change.InputField', function () {

                    // Set filter
                    if (this.checked) {
                        $SelectObj.data('filtered', $FilterObj.data('index'));
                    }

                    // Clear filter
                    else {
                        $SelectObj.data('filtered', '0');
                    }

                    // Apply filter
                    ApplyFilter($SelectObj, $ToolbarContainerObj);

                    // Refresh the field and get focus
                    $SearchObj = $('#' + $SelectObj.data('modernized'));
                    $SearchObj.width($SelectObj.outerWidth())
                        .trigger('blur');
                    CheckAvailability($SelectObj, $SearchObj);
                    setTimeout(function () {
                        $SearchObj.focus();
                    }, 0);
                })

                // Prevent clicks on action to steal focus from search field
                .on('mousedown.InputField', function () {
                    return false;
                });
                break;
        }
    }

    /**
     * @private
     * @name FocusNextElement
     * @memberof Core.UI.InputFields
     * @param {jQueryObject} $Element - Form element
     * @description
     *      Focus next element in form.
     */
    function FocusNextElement($Element) {

        // Get all tabbable and visible elements in the same form
        var $TabbableElements = $Element.closest('form')
            .find(':tabbable:visible');

        // Advance index for one element and trigger focus
        setTimeout(function () {
            $TabbableElements.eq($TabbableElements.index($Element) + 1)
                .focus();
        }, 0);
    }

    /**
     * @name RemoveDiacritics
     * @memberof Core.UI.InputFields
     * @function
     * @returns {String} String with removed diacritic characters
     * @param {String} Str - String from which to remove diacritic characters
     * @description
     *      Remove all diacritic characters from supplied string (accent folding).
     *      Taken from https://gist.github.com/instanceofme/1731620
     */
     TargetNS.RemoveDiacritics = function (Str) {
        var Chars = Str.split(''),
            i = Chars.length - 1,
            Alter = false,
            Ch;
        for (; i >= 0; i--) {
            Ch = Chars[i];
            if (Config.Diacritics.hasOwnProperty(Ch)) {
                Chars[i] = Config.Diacritics[Ch];
                Alter = true;
            }
        }
        if (Alter) {
            Str = Chars.join('');
        }
        return Str;
    }

    /**
     * @name InitSelect
     * @memberof Core.UI.InputFields
     * @function
     * @returns {Boolean} Returns true if successfull, false otherwise
     * @param {jQueryObject} $SelectFields - Fields to initialize.
     * @description
     *      This function initializes select input fields, based on supplied CSS selector.
     */
    TargetNS.InitSelect = function ($SelectFields) {

        // Give up if no select fields are found
        if (!$SelectFields.length) {
            return false;
        }

        // Iterate over all found fields
        $SelectFields.each(function (Index, SelectObj) {

            // Global variables
            var $ToolbarContainerObj,
                $InputContainerObj,
                $TreeContainerObj,
                $ListContainerObj,
                $ContainerObj,
                $ToolbarObj,
                $SearchObj,
                $SelectObj,
                $LabelObj,
                Multiple,
                TreeView,
                Focused,
                TabFocus,
                SearchID,
                SkipFocus,
                Searching,
                Filterable,
                SelectWidth,
                SearchLabel,
                $FiltersObj,
                $ShowTreeObj,
                $FiltersListObj;

            // Only initialize new elements if original field is valid and visible
            if ($(SelectObj).is(':visible')) {

                // Initialize variables
                $SelectObj = $(SelectObj);
                Multiple = ($SelectObj.attr('multiple') !== '' && $SelectObj.attr('multiple') !== undefined) ? true : false;
                Filterable = ($SelectObj.data('filters') !== '' && $SelectObj.data('filters') !== undefined) ? true : false;
                TreeView = false;
                SkipFocus = false;
                TabFocus = false;
                Searching = false;
                Focused = null;

                // Get width now, since we will hide the element
                SelectWidth = $SelectObj.outerWidth();

                // Hide original field
                $SelectObj.hide();

                // Check to see if tree view should be displayed
                $ShowTreeObj = $SelectObj.next('.ShowTreeSelection');
                if ($ShowTreeObj.length) {
                    $ShowTreeObj.hide();
                    TreeView = true;
                }

                // Create main container
                $ContainerObj = $('<div />').insertBefore($SelectObj);
                $ContainerObj.addClass('InputField_Container')
                    .attr('tabindex', '-1');

                // Container for input field
                $InputContainerObj = $('<div />').appendTo($ContainerObj);
                $InputContainerObj.addClass('InputField_InputContainer');

                // Deduce ID of original field
                SearchID = $SelectObj.attr('id');

                // If invalid, create generic one
                if (!SearchID) {
                    SearchID = Core.UI.GetID($SelectObj);
                }

                // Make ID unique
                SearchID += '_Search';

                // Flag the element as modernized
                $SelectObj.data('modernized', SearchID);

                // Create new input field to substitute original one
                $SearchObj = $('<input />').appendTo($InputContainerObj);
                $SearchObj.attr('id', SearchID)
                    .addClass('InputField_Search')
                    .attr('type', 'text')
                    .attr('role', 'search')
                    .attr('autocomplete', 'off');

                // Set width of search field to that of the select field
                $SearchObj.width(SelectWidth);

                // Subscribe on window resize event
                Core.App.Subscribe('Event.UI.InputFields.Resize', function() {

                    // Set width of search field to that of the select field
                    $SearchObj.blur().hide();
                    SelectWidth = $SelectObj.show().outerWidth();
                    $SelectObj.hide();
                    $SearchObj.width(SelectWidth).show();
                });

                // Handle clicks on related label
                if ($SelectObj.attr('id')) {
                    $LabelObj = $('label[for="' + $SelectObj.attr('id') + '"]');
                    if ($LabelObj.length > 0) {
                        $LabelObj.on('click.InputField', function () {
                            $SearchObj.focus();
                        });
                        $SearchObj.attr('aria-label', $LabelObj.text());
                    }
                }

                // Set the earch field label attribute if there was no label element.
                if (!$LabelObj || $LabelObj.length === 0) {
                    if ($SelectObj.attr('aria-label')) {
                        SearchLabel = $SelectObj.attr('aria-label');
                    }
                    else if ($SelectObj.attr('title')) {
                        SearchLabel = $SelectObj.attr('title');
                    }
                    else {
                        // Fallback: use sanitized ID to provide at least some information.
                        SearchLabel = SearchID.replace(/_/g, ' ');
                    }
                    $SearchObj.attr('aria-label', SearchLabel);
                }

                // Check error classes
                if ($SelectObj.hasClass(Config.ErrorClass)) {
                    $SearchObj.addClass(Config.ErrorClass);
                }
                if ($SelectObj.hasClass(Config.ServerErrorClass)) {
                    $SearchObj.addClass(Config.ServerErrorClass);
                }

                if (Filterable) {

                    // Preserve original data
                    $SelectObj.data('original', $SelectObj.children());

                    // Apply active filter
                    if (
                        $SelectObj.data('filtered')
                        && $SelectObj.data('filtered') !== '0'
                        )
                    {
                        ApplyFilter($SelectObj, $ToolbarContainerObj);
                    }
                }

                // Show selection boxes
                ShowSelectionBoxes($SelectObj, $InputContainerObj);

                // Disable field if no selection available
                CheckAvailability($SelectObj, $SearchObj);

                // Handle form disabling
                Core.App.Subscribe('Event.Form.DisableForm', function ($Form) {
                    if ($Form.find($SearchObj).attr('readonly')) {
                        $SearchObj.attr('disabled', 'disabled');
                    }
                });

                // Handle form enabling
                Core.App.Subscribe('Event.Form.EnableForm', function ($Form) {
                    if (
                        !$Form.find($SearchObj).attr('readonly')
                        && !$SearchObj.data('disabled')
                       )
                    {
                        $SearchObj.removeAttr('disabled');
                    }
                });

                // Register handler for on focus event
                $SearchObj.off('focus.InputField')
                    .on('focus.InputField', function () {

                    var TreeID,
                        $TreeObj,
                        SelectedID,
                        Elements,
                        SelectedNodes,
                        $ClearAllObj,
                        $SelectAllObj,
                        $ConfirmObj;

                    // Show error tooltip if needed
                    if ($SelectObj.attr('id')) {
                        if ($SelectObj.hasClass(Config.ErrorClass)) {
                            Core.Form.ErrorTooltips.ShowTooltip(
                                $SearchObj, $('#' + $SelectObj.attr('id') + Config.ErrorClass).html(), 'TongueTop'
                            );
                        }
                        if ($SelectObj.hasClass(Config.ServerErrorClass)) {
                            Core.Form.ErrorTooltips.ShowTooltip(
                                $SearchObj, $('#' + $SelectObj.attr('id') + Config.ServerErrorClass).html(), 'TongueTop'
                            );
                        }
                    }

                    // Focus tracking
                    Focused = this;
                    SkipFocus = false;

                    // Do nothing if already expanded
                    if ($SearchObj.attr('aria-expanded')) {
                        return false;
                    }

                    // Set ARIA flag if expanded
                    $SearchObj.attr('aria-expanded', true);

                    // Remove any existing selection boxes in container
                    $InputContainerObj.find('.InputField_Selection').remove();
                    $InputContainerObj.find('.InputField_More').remove();

                    // Create list container
                    $ListContainerObj = $('<div />').insertAfter($InputContainerObj);
                    $ListContainerObj.addClass('InputField_ListContainer')
                        .attr('tabindex', '-1');

                    // Create container for jsTree code
                    $TreeContainerObj = $('<div />').appendTo($ListContainerObj);
                    $TreeContainerObj.addClass('InputField_TreeContainer')
                        .attr('tabindex', '-1');

                    // Calculate width for tree container
                    $TreeContainerObj.width($SearchObj.width()
                        + Config.InputFieldPadding * 2
                    );

                    // Deduce ID of original field
                    TreeID = $SelectObj.attr('id');

                    // If invalid, create generic one
                    if (!TreeID) {
                        TreeID = Core.UI.GetID($SelectObj);
                    }

                    // Make ID unique
                    TreeID += '_Select';

                    // jsTree init
                    $TreeObj = $('<div id="' + TreeID + '"><ul></ul></div>');
                    SelectedID = $SelectObj.val();
                    Elements = {};
                    SelectedNodes = [];

                    // Generate JSON structure based on select field options
                    // Sort the list by default if tree view is active
                    Elements = Core.UI.TreeSelection.BuildElementsArray($SelectObj, TreeView);

                    // Force no tree view if structure has only root level
                    if (Elements.HighestLevel === 0) {
                        TreeView = false;
                    }

                    // Initialize jsTree
                    /* eslint-disable camelcase */
                    $TreeObj.jstree({
                        core: {
                            animation: 70,
                            data: Elements,
                            multiple: Multiple,
                            expand_selected_onload: true,
                            check_callback: true,
                            themes: {
                                name: 'InputField',
                                variant: (TreeView) ? 'Tree' : 'NoTree',
                                icons: false,
                                dots: false,
                                url: false
                            }
                        },
                        search: {
                            show_only_matches: true,
                            show_only_matches_children: true,
                            search_callback: function (Search, Node) {
                                var SearchString = TargetNS.RemoveDiacritics(Search),
                                    NodeString = TargetNS.RemoveDiacritics(Node.text);
                                return (NodeString.toLowerCase().indexOf(SearchString.toLowerCase()) !== -1);
                            }
                        },
                        plugins: [ 'multiselect', 'search', 'wholerow' ]
                    })

                    // Handle focus event for tree item
                    .on('focus.jstree', '.jstree-anchor', function () {
                        if (!SkipFocus) {
                            Focused = this;
                        } else {
                            SkipFocus = false;
                        }
                    })

                    // Handle focus event for tree list
                    .on('focus.jstree', function () {
                        if (!SkipFocus) {
                            Focused = this;
                        } else {
                            SkipFocus = false;
                        }

                        // Focus first available tree item
                        if (TabFocus) {
                            $($TreeObj.find('a.jstree-anchor:visible')
                                .not('.jstree-disabled')
                                .get(0)
                            ).trigger('focus.jstree');
                            TabFocus = false;
                        }
                    })

                    // Handle blur event for tree item
                    .on('blur.jstree', '.jstree-anchor', function () {
                        Focused = null;

                        setTimeout(function () {
                            if (!Focused) {
                                HideSelectList($SelectObj, $InputContainerObj, $SearchObj, $ListContainerObj, $TreeContainerObj);
                            }
                        }, 0);
                    })

                    // Handle blur event for tree list
                    .on('blur.jstree', function () {
                        Focused = null;

                        setTimeout(function () {
                            if (!Focused) {
                                HideSelectList($SelectObj, $InputContainerObj, $SearchObj, $ListContainerObj, $TreeContainerObj);
                            }
                        }, 0);
                    })

                    // Handle node selection in tree list
                    // Skip eslint check on next line for unused vars (it's actually event)
                    .on('select_node.jstree', function (Node, Selected, Event) {  //eslint-disable-line no-unused-vars
                        var $SelectedNode = $('#' + Selected.node.id),
                            SelectedNodesIDs;

                        // Do not select disabled nodes
                        if ($SelectedNode.hasClass('Disabled') || !$SelectedNode.is(':visible')) {
                            $TreeObj.jstree('deselect_node', Selected.node);
                        }

                        // Reset selected nodes list
                        SelectedNodes = [];

                        // Get selected nodes
                        SelectedNodesIDs = $TreeObj.jstree('get_selected');
                        $.each(SelectedNodesIDs, function () {
                            var $Node = $('#' + this);
                            SelectedNodes.push($Node.data('id'));
                        });

                        // Set selected nodes as selected in initial select box
                        // (which is hidden but is still used for the action)
                        $SelectObj.val(SelectedNodes);

                        // If single select, lose the focus and hide the list
                        if (!Multiple) {
                            SkipFocus = true;
                            $TreeObj.blur();
                        }

                        // Delay triggering change event on original field (see bug#11419)
                        $SelectObj.data('changed', true);
                    })

                    // Handle node deselection in tree list
                    .on('deselect_node.jstree', function (Node, Selected) {

                        var SelectedNodesIDs,
                            HasEmptyElement = $SelectObj.find('option[value=""]').length === 0 ? false : true;

                        if (Multiple) {

                            // Reset selected nodes list
                            SelectedNodes = [];

                            // Get selected nodes
                            SelectedNodesIDs = $TreeObj.jstree('get_selected');
                            $.each(SelectedNodesIDs, function () {
                                var $Node = $('#' + this);
                                SelectedNodes.push($Node.data('id'));
                            });

                            // Set selected nodes as selected in initial select box
                            // (which is hidden but is still used for the action)
                            if (HasEmptyElement && SelectedNodes.length === 0) {
                                $SelectObj.val('');
                            }
                            else {
                                $SelectObj.val(SelectedNodes);
                            }

                            // Delay triggering change event on original field (see bug#11419)
                            $SelectObj.data('changed', true);
                        } else {
                            $TreeObj.jstree('select_node', Selected.node);
                        }
                    })

                    // Handle double clicks on node rows in tree list
                    .on('dblclick.jstree', '.jstree-wholerow', function (Event) {

                        var Node;

                        // Expand node if we are in tree view
                        if (TreeView) {
                            Node = $(Event.target).closest('li');
                            $TreeObj.jstree('toggle_node', Node);
                        }
                    })

                    // Keydown handler for tree list
                    .keydown(function (Event) {

                        var $HoveredNode;

                        switch (Event.which) {

                            // Enter
                            case $.ui.keyCode.ENTER:
                                Event.preventDefault();
                                if (!Multiple) {
                                    FocusNextElement($SearchObj);
                                }
                                break;

                            // Escape
                            case $.ui.keyCode.ESCAPE:
                                Event.preventDefault();
                                $TreeObj.blur();
                                break;

                            // Space
                            case $.ui.keyCode.SPACE:
                                Event.preventDefault();
                                $HoveredNode = $TreeObj.find('.jstree-hovered');
                                if ($HoveredNode.hasClass('jstree-clicked')) {
                                    $TreeObj.jstree('deselect_node', $HoveredNode.get(0));
                                }
                                else {
                                    if (!Multiple) {
                                        $TreeObj.jstree('deselect_all');
                                    }
                                    $TreeObj.jstree('select_node', $HoveredNode.get(0));
                                }
                                break;

                            // Ctrl (Cmd) + A
                            case 65:
                                if (Event.ctrlKey || Event.metaKey) {
                                    Event.preventDefault();
                                    $ListContainerObj.find('.InputField_SelectAll')
                                        .click();
                                }
                                break;

                            // Ctrl (Cmd) + D
                            case 68:
                                if (Event.ctrlKey || Event.metaKey) {
                                    Event.preventDefault();
                                    $ListContainerObj.find('.InputField_ClearAll')
                                        .click();
                                }
                                break;

                            // Ctrl (Cmd) + F
                            case 70:
                                if (Event.ctrlKey || Event.metaKey) {
                                    Event.preventDefault();
                                    $ListContainerObj.find('.InputField_Filters')
                                        .click();
                                }
                                break;
                        }

                    })

                    // Initialize existing selection
                    .on('loaded.jstree', function () {
                        if (SelectedID) {
                            if (typeof SelectedID === 'object') {
                                $.each(SelectedID, function (NodeIndex, Data) {
                                    $TreeObj.jstree('select_node', $TreeObj.find('li[data-id="' + Data + '"]'));
                                });
                            }
                            else {
                                $TreeObj.jstree('select_node', $TreeObj.find('li[data-id="' + SelectedID + '"]'));
                            }
                        }
                        Core.App.Publish('Event.UI.InputFields.Expanded', $SearchObj);
                    });

                    // Prevent loss of focus when using scrollbar
                    $TreeContainerObj.on('focus.InputField', function () {
                        if (!SkipFocus) {
                            Focused = this;
                        } else {
                            SkipFocus = false;
                        }
                    }).on('blur.jstree', function () {
                        Focused = null;

                        setTimeout(function () {
                            if (!Focused) {
                                HideSelectList($SelectObj, $InputContainerObj, $SearchObj, $ListContainerObj, $TreeContainerObj);
                            }
                        }, 0);
                    });

                    // Append tree code to the container and show it
                    $TreeObj
                        .appendTo($TreeContainerObj)
                        .show();

                    $ToolbarContainerObj = $('<div />').appendTo($ListContainerObj);
                    $ToolbarContainerObj.addClass('InputField_ToolbarContainer')
                        .attr('tabindex', '-1')
                        .width($TreeContainerObj.width());

                    $ToolbarObj = $('<ul />').appendTo($ToolbarContainerObj)
                        .attr('tabindex', '-1')
                        .on('focus.InputField', function () {
                            if (!SkipFocus) {
                                Focused = this;
                            } else {
                                SkipFocus = false;
                            }
                        }).on('blur.InputField', function () {
                            Focused = null;

                            setTimeout(function () {
                                if (!Focused) {
                                    HideSelectList($SelectObj, $InputContainerObj, $SearchObj, $ListContainerObj, $TreeContainerObj);
                                }
                            }, 0);
                        });

                    if (Multiple) {

                        // Select all action selects all values in tree
                        $SelectAllObj = $('<a />').addClass('InputField_SelectAll')
                            .attr('href', '#')
                            .attr('role', 'button')
                            .attr('tabindex', '-1')
                            .text(Core.Config.Get('InputFieldsSelectAll'))
                            .attr('aria-label', Core.Config.Get('InputFieldsSelectAll'))
                            .appendTo($ToolbarObj)
                            .wrap('<li />');
                        RegisterActionEvent($TreeObj, $SelectAllObj, 'SelectAll');

                        // Clear all action deselects all selected values in tree
                        $ClearAllObj = $('<a />').addClass('InputField_ClearAll')
                            .attr('href', '#')
                            .attr('role', 'button')
                            .attr('tabindex', '-1')
                            .text(Core.Config.Get('InputFieldsClearAll'))
                            .attr('aria-label', Core.Config.Get('InputFieldsClearAll'))
                            .appendTo($ToolbarObj)
                            .wrap('<li />');
                        RegisterActionEvent($TreeObj, $ClearAllObj, 'ClearAll');
                    }

                    if (Filterable) {

                        // Filters action button
                        $FiltersObj = $('<a />').addClass('InputField_Filters')
                            .attr('href', '#')
                            .attr('role', 'button')
                            .attr('tabindex', '-1')
                            .text(Core.Config.Get('InputFieldsFilters'))
                            .attr('aria-label', Core.Config.Get('InputFieldsFilters'))
                            .appendTo($ToolbarObj)
                            .wrap('<li />');
                        RegisterFilterEvent($SelectObj, $InputContainerObj, $ToolbarContainerObj, $FiltersObj, 'ShowFilters');

                        if (!$SelectObj.data('filtered')) {
                            $SelectObj.data('filtered', '0');
                        } else if ($SelectObj.data('filtered') !== '0') {
                            $FiltersObj.addClass('Active')
                                .prepend('<i class="fa fa-filter" /> ');
                        }

                        // Filters list
                        $FiltersListObj = $('<div />').appendTo($ToolbarContainerObj);
                        $FiltersListObj.addClass('InputField_FiltersList')
                            .attr('tabindex', '-1');

                        // Hide the filters list if no parameter is supplied
                        if (
                            !$SelectObj.data('expand-filters')
                            && $SelectObj.data('expand-filters') !== '0'
                            )
                        {
                            $FiltersListObj.hide();
                        }

                        // Filters checkboxes
                        $.each($SelectObj.data('filters').Filters, function (FilterIndex, Filter) {
                            var $FilterObj = $('<input />').appendTo($FiltersListObj),
                                $SpanObj = $('<span />').appendTo($FiltersListObj);
                            $FilterObj.attr('type', 'checkbox')
                                .attr('tabindex', '-1')
                                .data('index', FilterIndex + 1);
                            if (
                                $SelectObj.data('filtered')
                                && parseInt($SelectObj.data('filtered'), 10) === FilterIndex + 1
                                )
                            {
                                $FilterObj.attr('checked', true);
                            }
                            if (
                                Filter.Data.length === 1
                                && (Filter.Data[0].Key === '' || Filter.Data[0].Key === '||-')
                                )
                            {
                                $FilterObj.attr('disabled', true);
                            }
                            Core.UI.GetID($FilterObj);
                            $SpanObj.text(Filter.Name);
                            $SpanObj.on('click', function () {
                                $FilterObj.click();
                            });
                            $('<br />').appendTo($FiltersListObj);
                            RegisterFilterEvent($SelectObj, $InputContainerObj, $ToolbarContainerObj, $FilterObj, 'Filter');
                        });

                    }

                    if (Multiple) {

                        // Confirm action exits the field
                        $ConfirmObj = $('<a />').addClass('InputField_Confirm')
                            .attr('href', '#')
                            .attr('role', 'button')
                            .attr('tabindex', '-1')
                            .text(Core.Config.Get('InputFieldsConfirm'))
                            .attr('aria-label', Core.Config.Get('InputFieldsConfirm'))
                            .appendTo($ToolbarObj)
                            .prepend('<i class="fa fa-check-square-o" /> ')
                            .wrap('<li />');
                        RegisterActionEvent($TreeObj, $ConfirmObj, 'Confirm');
                    }

                    if ($ToolbarObj.children().length === 0) {
                        $ToolbarContainerObj.hide();
                    }

                    // Set up jsTree search function for input search field
                    $SearchObj.off('keyup.InputField').on('keyup.InputField', function () {

                        var SearchValue = $SearchObj.val().trim(),
                            NoMatchNodeJSON,
                            $ClearSearchObj;

                        // Abandon search if empty string
                        if (SearchValue === '') {
                            $TreeObj.jstree('delete_node', $TreeObj.find('.jstree-no-match'));
                            $TreeObj.jstree('clear_search');
                            Searching = false;
                            $SearchObj.siblings('.InputField_ClearSearch')
                                .remove();

                            if (Multiple) {

                                // Reset select all and clear all functions to original behavior
                                $SelectAllObj.off('click.InputField').on('click.InputField', function () {

                                    // Make sure subtrees of all nodes are expanded
                                    $TreeObj.jstree('open_all');

                                    // Select all nodes
                                    $TreeObj.find('li')
                                        .not('.jstree-clicked,.Disabled')
                                        .each(function () {
                                            $TreeObj.jstree('select_node', this);
                                        });

                                    return false;
                                });
                                $ClearAllObj.off('click.InputField').on('click.InputField', function () {

                                    // Clear selection
                                    $TreeObj.jstree('deselect_node', $TreeObj.jstree('get_selected'));

                                    return false;
                                });

                            }
                            return false;
                        }

                        // Remove no match entry if existing from previous search
                        $TreeObj.jstree('delete_node', $TreeObj.find('.jstree-no-match'));

                        // Start jsTree search
                        $TreeObj.jstree('search', Core.App.EscapeHTML(SearchValue));
                        Searching = true;

                        if (Multiple) {

                            // Change select all action to select only matched values
                            RegisterActionEvent($TreeObj, $SelectAllObj, 'SelectAll_Search');

                            // Change clear all action to deselect only matched values
                            RegisterActionEvent($TreeObj, $ClearAllObj, 'ClearAll_Search');

                        }

                        // No match
                        if ($TreeObj.find('.jstree-search').length === 0) {

                            // Add no match node
                            NoMatchNodeJSON = {
                                text: Core.Config.Get('InputFieldsNoMatchMsg'),
                                state: {
                                    disabled: true
                                },
                                'li_attr': {
                                    class: 'Disabled jstree-no-match'
                                }
                            };
                            $TreeObj.jstree('create_node', $TreeObj, NoMatchNodeJSON);

                            // Hide all other nodes
                            $TreeObj.find('li:visible')
                                .not('.jstree-no-match')
                                .hide();
                        }

                        // Check if we are searching for something
                        if ($SearchObj.siblings('.InputField_ClearSearch').length === 0) {

                            // Clear search action stops search
                            $ClearSearchObj = $('<a />').insertAfter($SearchObj);
                            $ClearSearchObj.addClass('InputField_Action InputField_ClearSearch')
                                .attr('href', '#')
                                .attr('title', Core.Config.Get('InputFieldsClearSearch'))
                                .css(($('body').hasClass('RTL') ? 'left' : 'right'), Config.SelectionBoxOffsetRight + 'px')
                                .append($('<i />').addClass('fa fa-times-circle'))
                                .attr('role', 'button')
                                .attr('tabindex', '-1')
                                .attr('aria-label', Core.Config.Get('InputFieldsClearSearch'))
                                .off('click.InputField').on('click.InputField', function () {

                                    // Reset the search field
                                    $SearchObj.val('');

                                    // Clear search from jsTree and remove no match node
                                    $TreeObj.jstree('delete_node', $TreeObj.find('.jstree-no-match'));
                                    $TreeObj.jstree('clear_search');
                                    Searching = false;

                                    if (Multiple) {

                                        // Reset select all and clear all functions to original behavior
                                        RegisterActionEvent($TreeObj, $SelectAllObj, 'SelectAll');
                                        RegisterActionEvent($TreeObj, $ClearAllObj, 'ClearAll');

                                    }

                                    // Remove the action icon
                                    $(this).remove();

                                    return false;

                                // Prevent clicks on action to steal focus from search field
                                }).on('mousedown.InputField', function () {
                                    return false;
                            });
                        }

                    });

                    // Show list container
                    $ListContainerObj.fadeIn(Config.FadeDuration, function () {

                        // Scroll into view if in dialog
                        if ($ListContainerObj.parents('.Dialog').length > 0) {
                            this.scrollIntoView(false);
                        }
                    });
                })

                // Out of focus handler removes complete jsTree and action buttons
                .off('blur.InputField').on('blur.InputField', function () {
                    Focused = null;
                    setTimeout(function () {
                        if (!Focused) {
                            HideSelectList($SelectObj, $InputContainerObj, $SearchObj, $ListContainerObj, $TreeContainerObj);
                        }
                    }, 0);
                    Core.Form.ErrorTooltips.HideTooltip();
                })

                // Keydown handler provides keyboard shortcuts for navigating the tree
                .keydown(function (Event) {

                    var $TreeObj = $TreeContainerObj.find('.jstree');

                    switch (Event.which) {

                        // Tab
                        case $.ui.keyCode.TAB:
                            if (!Event.shiftKey) {
                                TabFocus = true;
                            }
                            break;

                        // Escape
                        case $.ui.keyCode.ESCAPE:
                            Event.preventDefault();
                            $SearchObj.blur();
                            break;

                        // ArrowDown
                        case $.ui.keyCode.DOWN:
                            Event.preventDefault();
                            $($TreeObj.find('a.jstree-anchor:visible')
                                .not('.jstree-disabled')
                                .get(0)
                            ).trigger('focus.jstree');
                            break;

                        // Ctrl (Cmd) + A
                        case 65:
                            if (Event.ctrlKey || Event.metaKey) {
                                if (!Searching) {
                                    Event.preventDefault();
                                    $ListContainerObj.find('.InputField_SelectAll')
                                        .click();
                                }
                            }
                            break;

                        // Ctrl (Cmd) + D
                        case 68:
                            if (Event.ctrlKey || Event.metaKey) {
                                Event.preventDefault();
                                $ListContainerObj.find('.InputField_ClearAll')
                                    .click();
                            }
                            break;

                        // Ctrl (Cmd) + F
                        case 70:
                            if (Event.ctrlKey || Event.metaKey) {
                                Event.preventDefault();
                                $ListContainerObj.find('.InputField_Filters')
                                    .click();
                            }
                            break;
                    }

                });

                // Handle custom redraw event on original select field
                // to update values when changed via AJAX calls
                $SelectObj.off('redraw.InputField').on('redraw.InputField', function () {
                    if (Filterable) {
                        $SelectObj.data('original', $SelectObj.children());
                        ApplyFilter($SelectObj, $ToolbarContainerObj, true);
                    }
                    CheckAvailability($SelectObj, $SearchObj);
                    $SearchObj.width($SelectObj.outerWidth());
                    ShowSelectionBoxes($SelectObj, $InputContainerObj);
                })

                // Handle custom error event on original select field
                // to add error classes to search field if needed
                .off('error.InputField').on('error.InputField', function () {
                    if ($SelectObj.hasClass(Config.ErrorClass)) {
                        $SearchObj.addClass(Config.ErrorClass);
                    }
                    else {
                        $SearchObj.removeClass(Config.ErrorClass);
                    }
                    if ($SelectObj.hasClass(Config.ServerErrorClass)) {
                        $SearchObj.addClass(Config.ServerErrorClass);
                    }
                    else {
                        $SearchObj.removeClass(Config.ServerErrorClass);
                    }
                });

            }
        });

        return true;

    };

    /**
     * @name IsEnabled
     * @memberof Core.UI.InputFields
     * @function
     * @returns {Boolean} True/false value depending whether the Input Field has been initialized.
     * @param {jQueryObject} $Element - The jQuery object of the element that is being tested.
     * @description
     *      This function check if Input Field is initialized for the supplied element,
     *      and returns appropriate boolean value.
     */
    TargetNS.IsEnabled = function ($Element) {
        if ($Element.data('modernized') && $Element.data('modernized') !== '') {
            return true;
        }
        return false;
    };

    // jsTree plugin for multi selection without modifier key
    // Skip ESLint check below for no camelcase property, we are overriding an existing one!
    $.jstree.defaults.multiselect = {};
    $.jstree.plugins.multiselect = function (options, parent) {
        this.activate_node = function (obj, e) { //eslint-disable-line camelcase
            e.ctrlKey = true;
            parent.activate_node.call(this, obj, e);
        };
    };

    // Handle window resize event
    $(window).on(Config.ResizeEvent + '.InputField', function () {
        clearTimeout(Config.ResizeTimeout);
        Config.ResizeTimeout = setTimeout(function () {
            Core.App.Publish('Event.UI.InputFields.Resize');
        }, 100);
    });

    return TargetNS;
}(Core.UI.InputFields || {}));
