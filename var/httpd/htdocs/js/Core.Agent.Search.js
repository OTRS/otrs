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
 * @namespace Core.Agent.Search
 * @memberof Core.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the search.
 */
Core.Agent.Search = (function (TargetNS) {

    var AJAXStopWordCheckRunning = false;

    /**
     * @name AdditionalAttributeSelectionRebuild
     * @memberof Core.Agent.Search
     * @function
     * @returns {Boolean} Returns true.
     * @description
     *      This function rebuilds attribute selection, only show available attributes.
     */
    TargetNS.AdditionalAttributeSelectionRebuild = function () {

        // get original selection with all possible fields and clone it
        var $AttributeClone = $('#AttributeOrig option').clone(),
            $AttributeSelection = $('#Attribute').empty();

        // strip all already used attributes
        $AttributeClone.each(function () {
            if (!$('#SearchInsert label#Label' + $(this).attr('value')).length) {
                $AttributeSelection.append($(this));
            }
        });

        $AttributeSelection.trigger('redraw.InputField');

        return true;
    };

    /**
     * @name SearchAttributeAdd
     * @memberof Core.Agent.Search
     * @function
     * @returns {Boolean} Returns false.
     * @param {String} Attribute - Name of attribute to add.
     * @description
     *      This function adds one attributes for search.
     */
    TargetNS.SearchAttributeAdd = function (Attribute) {
        var $Label = $('#SearchAttributesHidden label#Label' + Attribute);

        if ($Label.length) {
            $Label.prev().clone().appendTo('#SearchInsert');
            $Label.clone().appendTo('#SearchInsert');
            $Label.next().clone().appendTo('#SearchInsert')

                // bind click function to remove button now
                .find('.RemoveButton').on('click', function () {
                    var $Element = $(this).parent();
                    TargetNS.SearchAttributeRemove($Element);

                    // rebuild selection
                    TargetNS.AdditionalAttributeSelectionRebuild();

                    return false;
                });

            $('.CustomerAutoCompleteSimple').each(function() {
                Core.Agent.CustomerSearch.InitSimple($(this));
            });

            // Register event for tree selection dialog
            Core.UI.TreeSelection.InitTreeSelection();

            // Modernize fields
            Core.UI.InputFields.Activate($('#SearchInsert'));

            // Initially display dynamic fields with TreeMode = 1 correctly
            Core.UI.TreeSelection.InitDynamicFieldTreeViewRestore();
        }

        return false;
    };

    /**
     * @name SearchAttributeRemove
     * @memberof Core.Agent.Search
     * @function
     * @param {jQueryObject} $Element - The jQuery object of the form or any element within this form check.
     * @description
     *      This function removes attributes from an element.
     */
    TargetNS.SearchAttributeRemove = function ($Element) {
        $Element.prev().prev().remove();
        $Element.prev().remove();
        $Element.remove();
    };

    /**
     * @private
     * @name SearchProfileDelete
     * @memberof Core.Agent.Search
     * @function
     * @param {String} Profile - The profile name that will be delete.
     * @param {String} SearchProfileAction - The action of search profile delete module.
     * @description
     *      Delete a profile via an ajax requests.
     */
    function SearchProfileDelete(Profile, SearchProfileAction) {
        var Data = {
            Action: SearchProfileAction,
            Subaction: 'AJAXProfileDelete',
            Profile: Profile
        };
        Core.AJAX.FunctionCall(
            Core.Config.Get('CGIHandle'),
            Data,
            function () {}
        );
    }

    /**
     * @private
     * @name CheckForSearchedValues
     * @memberof Core.Agent.Search
     * @function
     * @returns {Boolean} False if no values were found, true if values where there.
     * @description
     *      Checks if any values were entered in the search.
     *      If nothing at all exists, it alerts with translated:
     *      "Please enter at least one search value or * to find anything"
     */
    function CheckForSearchedValues() {
        // loop through the SerachForm labels
        var SearchValueFlag = false;
        $('#SearchForm label').each(function () {
            var ElementName,
                $Element,
                $LabelElement = $(this),
                $FieldElement = $LabelElement.next('.Field');
            // those with ID's are used for searching
            if ($(this).attr('id')) {

                // substring "Label" (e.g. first five characters ) from the
                // label id, use the remaining name as name string for accessing
                // the form input's value
                ElementName = $(this).attr('id').substring(5);
                $Element = $('#SearchForm input[name=' + Core.App.EscapeSelector(ElementName) + ']');

                // If there's no input element with the selected name
                // find the next "select" element and use that one for checking
                if (!$Element.length) {
                    $Element = $(this).next().find('select');
                }

                // Fix for bug#10845: make sure time slot fields with TimeInputFormat
                // 'Input' set are being considered correctly, too. As this is only
                // relevant for search type 'TimeSlot', we check for the first
                // input type=text elment in the corresponding field element.
                // All time field elements have to be filled in, but if only one
                // is missing, we treat the whole field as invalid.
                if ($FieldElement.find('input[name$="SearchType"]').val() === 'TimeSlot' && !$FieldElement.find('select').length) {
                    $Element = $FieldElement.find('input[type=text]').first();
                }

                if ($Element.length) {
                    if ($Element.val() && $Element.val() !== '') {
                        SearchValueFlag = true;
                    }
                }
            }
        });
        if (!SearchValueFlag) {
           alert(Core.Language.Translate('Please enter at least one search value or * to find anything.'));
        }
        return SearchValueFlag;
    }

    /**
     * @private
     * @name ShowWaitingDialog
     * @memberof Core.Agent.Search
     * @function
     * @description
     *      Shows waiting dialog until search screen is ready.
     */
    function ShowWaitingDialog(){
        Core.UI.Dialog.ShowContentDialog('<div class="Spacing Center"><span class="AJAXLoader" title="' + Core.Language.Translate('Loading...') + '"></span></div>', Core.Language.Translate('Loading...'), '10px', 'Center', true);
    }

    /**
     * @function
     * @private
     * @param {Array} Search strings to check for stop words.
     * @param {Function} Callback function to execute if stop words were found.
     * @param {Function} Callback function to execute if no stop words were found.
     * @return nothing
     * @description Checks if the given search strings contain stop words.
     */

    function AJAXStopWordCheck(SearchStrings, CallbackStopWordsFound, CallbackNoStopWordsFound) {
        var StopWordCheckData = {
                Action: 'AgentTicketSearch',
                Subaction: 'AJAXStopWordCheck',
                SearchStrings: SearchStrings
            },
            MIMEBaseElements = {
                'MIMEBase_From': 1,
                'MIMEBase_To': 1,
                'MIMEBase_Cc': 1,
                'MIMEBase_Subject': 1,
                'MIMEBase_Body': 1
            };

        // Prevent multiple stop word checks
        if (AJAXStopWordCheckRunning) {
            return;
        }
        AJAXStopWordCheckRunning = true;
        Core.Form.DisableForm($('#SearchForm'));

        Core.AJAX.FunctionCall(
            Core.Config.Get('CGIHandle'),
            StopWordCheckData,
            function (Result) {
                var FoundStopWords = '';

                $.each(Result.FoundStopWords, function (Key, StopWords) {
                    var TranslatedKey = Core.Config.Get('FieldTitle' + Key);

                    if (!StopWords.length) {
                        return;
                    }

                    if (!TranslatedKey) {
                        TranslatedKey = Key;
                    }

                    // Substring 'MIMEBase_' for clearer alert description.
                    if (MIMEBaseElements[TranslatedKey]) {
                        TranslatedKey = TranslatedKey.replace('MIMEBase_', '');
                    }

                    FoundStopWords += TranslatedKey + ': ' + StopWords.join(', ') + "\n";
                });

                AJAXStopWordCheckRunning = false;
                Core.Form.EnableForm($('#SearchForm'));

                if (FoundStopWords.length) {
                     CallbackStopWordsFound(FoundStopWords);
                }
                else {
                    CallbackNoStopWordsFound();
                }
            }
        );
    }

    /**
     * @private
     * @name CheckSearchStringsForStopWords
     * @memberof Core.Agent.Search
     * @function
     * @param {Function} Callback - function to execute, if no stop words were found.
     * @description Checks if specific values of the search form contain stop words.
     *              If stop words are present, a warning will be displayed.
     *              If stop words are not present, the given callback will be executed.
     */
    function CheckSearchStringsForStopWords(Callback) {
        var SearchStrings = {},
            SearchStringsFound = 0,
            RelevantElementNames = {
                'MIMEBase_From': 1,
                'MIMEBase_To': 1,
                'MIMEBase_Cc': 1,
                'MIMEBase_Subject': 1,
                'MIMEBase_Body': 1,
                'Fulltext': 1
            };

        if (!Core.Config.Get('CheckSearchStringsForStopWords')) {
            Callback();
            return;
        }

        $('#SearchForm label').each(function () {
            var ElementName,
                $Element;

            // those with ID's are used for searching
            if ($(this).attr('id')) {

                // substring "Label" (e.g. first five characters ) from the
                // label id, use the remaining name as name string for accessing
                // the form input's value
                ElementName = $(this).attr('id').substring(5);
                if (!RelevantElementNames[ElementName]) {
                    return;
                }

                $Element = $('#SearchForm input[name=' + ElementName + ']');

                if ($Element.length) {
                    if ($Element.val() && $Element.val() !== '') {
                        SearchStrings[ElementName] = $Element.val();
                        SearchStringsFound = 1;
                    }
                }
            }
        });

        // Check if stop words are present.
        if (!SearchStringsFound) {
            Callback();
            return;
        }

        AJAXStopWordCheck(
            SearchStrings,
            function (FoundStopWords) {
                alert(Core.Language.Translate('Please remove the following words from your search as they cannot be searched for:') + "\n" + FoundStopWords);
            },
            Callback
        );
    }

    /**
     * @name OpenSearchDialog
     * @memberof Core.Agent.Search
     * @function
     * @param {String} Action - Action which is used in framework right now.
     * @param {String} Profile - Used profile name.
     * @param {Boolean} EmptySearch
     * @description
     *      This function open the search dialog after clicking on "search" button in nav bar.
     */
    TargetNS.OpenSearchDialog = function (Action, Profile, EmptySearch) {

        var Referrer = Core.Config.Get('Action'),
            Data;

        if (!Action) {
            Action = 'AgentSearch';
        }

        Data = {
            Action: Action,
            Referrer: Referrer,
            Profile: Profile,
            EmptySearch: EmptySearch,
            Subaction: 'AJAX'
        };

        ShowWaitingDialog();

        Core.AJAX.FunctionCall(
            Core.Config.Get('CGIHandle'),
            Data,
            function (HTML) {
                // if the waiting dialog was cancelled, do not show the search
                //  dialog as well
                if (!$('.Dialog:visible').length) {
                    return;
                }

                Core.UI.Dialog.ShowDialog({
                    HTML: HTML,
                    Title: Core.Language.Translate('Search'),
                    Modal: true,
                    CloseOnClickOutside: false,
                    CloseOnEscape: true,
                    PositionTop: '10px',
                    PositionLeft: 'Center',
                    AllowAutoGrow: true
                });

                // hide add template block
                $('#SearchProfileAddBlock').hide();

                // hide save changes in template block
                $('#SaveProfile').parent().hide().prev().hide().prev().hide();

                // search profile is selected
                if ($('#SearchProfile').val() && $('#SearchProfile').val() !== 'last-search') {

                    // show delete button
                    $('#SearchProfileDelete').show();

                    // show profile link
                    $('#SearchProfileAsLink').show();

                    // show save changes in template block
                    $('#SaveProfile').parent().show().prev().show().prev().show();

                    // set SaveProfile to 0
                    $('#SaveProfile').prop('checked', false);
                }

                Core.UI.InputFields.Activate($('.Dialog:visible'));

                // register add of attribute
                $('#Attribute').on('change', function () {
                    var Attribute = $('#Attribute').val();
                    TargetNS.SearchAttributeAdd(Attribute);
                    TargetNS.AdditionalAttributeSelectionRebuild();

                    // Register event for tree selection dialog
                    $('.ShowTreeSelection').off('click').on('click', function () {
                        Core.UI.TreeSelection.ShowTreeSelection($(this));
                        return false;
                    });

                    return false;
                });

                // register return key
                $('#SearchForm').off('keypress.FilterInput').on('keypress.FilterInput', function (Event) {
                    if ((Event.charCode || Event.keyCode) === 13) {
                        if (!CheckForSearchedValues()) {
                            return false;
                        }
                        else {
                            $('#SearchFormSubmit').trigger('click');
                        }
                        return false;
                    }
                });

                // register submit
                $('#SearchFormSubmit').on('click', function () {

                    var ShownAttributes = [];

                    if ($('#SearchProfileAddAction, #SearchProfileAddName').is(':visible') && $('#SearchProfileAddName').val()) {
                        $('#SearchProfileAddAction').trigger('click');
                    }

                    // remember shown attributes
                    $('#SearchInsert label').each(function () {
                        if ($(this).attr('id')) {
                            ShownAttributes.push($(this).attr('id'));
                        }
                    });
                    $('#SearchForm #ShownAttributes').val(ShownAttributes.join(';'));

                    // Normal results mode will return HTML in the same window
                    if ($('#SearchForm #ResultForm').val() === 'Normal') {

                        if (!CheckForSearchedValues()) {
                            return false;
                        }
                        else {
                            CheckSearchStringsForStopWords(function () {
                                $('#SearchForm').submit();
                                return false;
                           });
                        }
                    }
                    else { // Print and CSV should open in a new window, no waiting dialog
                        $('#SearchForm').attr('target', 'SearchResultPage');
                        if (!CheckForSearchedValues()) {
                            return false;
                        }
                        else {
                            CheckSearchStringsForStopWords(function () {
                                $('#SearchForm').submit();
                                $('#SearchForm').attr('target', '');
                            });
                        }
                    }
                    return false;
                });

                Core.Form.Validate.Init();
                Core.Form.Validate.SetSubmitFunction($('#SearchForm'), function (Form) {
                    Form.submit();

                    // Show only a waiting dialog for Normal results mode, because this result
                    //  will return the HTML in the same window.
                    if ($('#SearchForm #ResultForm').val() === 'Normal') {
                        ShowWaitingDialog();
                    }
                });

                // load profile
                $('#SearchProfile').on('change', function () {
                    var SearchProfile = $('#SearchProfile').val(),
                        SearchProfileEmptySearch = $('#EmptySearch').val(),
                        SearchProfileAction = $('#SearchAction').val();

                    TargetNS.OpenSearchDialog(SearchProfileAction, SearchProfile, SearchProfileEmptySearch);
                    return false;
                });

                // show add profile block or not
                $('#SearchProfileNew').on('click', function (Event) {
                    $('#SearchProfileAddBlock').toggle();
                    $('#SearchProfileAddName').focus();
                    Event.preventDefault();
                    return false;
                });

                // add new profile
                $('#SearchProfileAddAction').on('click', function () {
                    var ProfileName, $Element1;

                    // get name
                    ProfileName = $('#SearchProfileAddName').val();

                    // check name
                    if (!ProfileName.length || ProfileName.length < 2) {
                        return;
                    }

                    // add name to profile selection
                    $Element1 = $('#SearchProfile').children().first().clone();
                    $Element1.text(ProfileName);
                    $Element1.attr('value', ProfileName);
                    $Element1.prop('selected', true);
                    $('#SearchProfile').append($Element1).trigger('redraw.InputField');

                    // set input box to empty
                    $('#SearchProfileAddName').val('');

                    // hide add template block
                    $('#SearchProfileAddBlock').hide();

                    // hide save changes in template block
                    $('#SaveProfile').parent().hide().prev().hide().prev().hide();

                    // set SaveProfile to 1
                    $('#SaveProfile').prop('checked', true);

                    // show delete button
                    $('#SearchProfileDelete').show();

                    // show profile link
                    $('#SearchProfileAsLink').show();
                });

                // direct link to profile
                $('#SearchProfileAsLink').on('click', function () {
                    var SearchProfile = $('#SearchProfile').val(),
                        SearchProfileAction = $('#SearchAction').val();

                    window.location.href = Core.Config.Get('Baselink') + 'Action=' + SearchProfileAction +
                    ';Subaction=Search;TakeLastSearch=1;SaveProfile=1;Profile=' + encodeURIComponent(SearchProfile);
                    return false;
                });

                // delete profile
                $('#SearchProfileDelete').on('click', function (Event) {
                    var SearchProfileAction = $('#SearchAction').val();

                    // strip all already used attributes
                    $('#SearchProfile').find('option:selected').each(function () {
                        if ($(this).attr('value') !== 'last-search') {

                            // rebuild attributes
                            $('#SearchInsert').text('');

                            // remove remote
                            SearchProfileDelete($(this).val(), SearchProfileAction);

                            // remove local
                            $(this).remove();

                            // show fulltext
                            TargetNS.SearchAttributeAdd('Fulltext');

                            // rebuild selection
                            TargetNS.AdditionalAttributeSelectionRebuild();
                        }
                    });
                    $('#SearchProfile').trigger('change');

                    if ($('#SearchProfile').val() && $('#SearchProfile').val() === 'last-search') {

                        // hide delete link
                        $('#SearchProfileDelete').hide();

                        // show profile link
                        $('#SearchProfileAsLink').hide();

                    }

                    Event.preventDefault();
                    return false;
                });

                window.setTimeout(function (){
                    TargetNS.AddSearchAttributes();
                    TargetNS.AdditionalAttributeSelectionRebuild();
                }, 0);

            }, 'html'
        );
    };

    /**
     * @function
     * @return nothing
     * @description Inits toolbar fulltext search.
     */

    TargetNS.InitToolbarFulltextSearch = function () {

        // register return key
        $('#ToolBar li.Extended.SearchFulltext form[name="SearchFulltext"]').off('keypress.FilterInput').on('keypress.FilterInput', function (Event) {
            var SearchString;

            if ((Event.charCode || Event.keyCode) === 13) {
                SearchString = $('#Fulltext').val();

                if (!SearchString.length || !Core.Config.Get('CheckSearchStringsForStopWords')) {
                    return true;
                }

                AJAXStopWordCheck(
                    { Fulltext: SearchString },
                    function (FoundStopWords) {
                        alert(Core.Language.Translate('Please remove the following words from your search as they cannot be searched for:') + "\n" + FoundStopWords);
                    },
                    function () {
                        $('#ToolBar li.Extended.SearchFulltext form[name="SearchFulltext"]').submit();
                    }
                );

                return false;
            }
        });
    };

    /**
     * @name AddSearchAttributes
     * @memberof Core.Agent.Search
     * @function
     * @description
     *      This function determines and adds attributes for using in filter.
     */
    TargetNS.AddSearchAttributes = function () {
        var i,
            SearchAttributes = Core.Config.Get('SearchAttributes');

        if (typeof SearchAttributes !== 'undefined' && SearchAttributes.length > 0) {
            for (i = 0; i < SearchAttributes.length; i++) {
                Core.Agent.Search.SearchAttributeAdd(SearchAttributes[i]);
            }
        }
    };

    /**
     * @name Init
     * @memberof Core.Agent.Search
     * @function
     * @description
     *      This function opens search dialog only on empty page
     *      (when it opens via '...Action=AgentTicketSearch' from location bar).
     */
    TargetNS.Init = function () {
        var NonAJAXSearch = Core.Config.Get('NonAJAXSearch');

        if (typeof NonAJAXSearch !== 'undefined' && parseInt(NonAJAXSearch, 10) === 1) {
            Core.Agent.Search.OpenSearchDialog(Core.Config.Get('Action'), Core.Config.Get('Profile'));
        }
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Search || {}));
