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
 * @namespace Core.Agent.CustomerUserAddressBook
 * @memberof Core.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the search.
 */
Core.Agent.CustomerUserAddressBook = (function (TargetNS) {

    /**
     * @private
     * @name RecipientUserLoginElementSelector
     * @memberof Core.Agent.CustomerUserAddressBook
     * @member {String}
     * @description
     *      The recipient user login element selector for the checkbox.
     */
    var RecipientUserLoginElementSelector = 'div.Overview table td input[type="checkbox"][name=RecipientUserLogin]';

    /**
     * @private
     * @name CheckForSearchedValues
     * @memberof Core.Agent.CustomerUserAddressBook
     * @function
     * @returns {Boolean} False if no values were found, true if values where there.
     * @description
     *      Checks if any values were entered in the search.
     *      If nothing at all exists, it alerts with translated:
     *      "Please enter at least one search value or * to find anything"
     */
    function CheckForSearchedValues() {
        var SearchValueFlag = false;

        $('#SearchForm label').each(function () {
            var ElementName,
                $Element;

            // Those with ID's are used for searching.
            if ($(this).attr('id')) {
                    // substring "Label" (e.g. first five characters) from the
                    // label id, use the remaining name as name string for accessing
                    // the form input's value
                    ElementName = $(this).attr('id').substring(5);
                    $Element = $('#SearchForm input[name=' + ElementName + ']');
                    // If there's no input element with the selected name
                    // find the next "select" element and use that one for checking
                    if (!$Element.length) {
                        $Element = $(this).next().find('select');
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
     * @name CheckForSearchedValues
     * @memberof Core.Agent.CustomerUserAddressBook
     * @function
     * @description
     *      Adds the given recipients to the ticket for the selected recipient field and close the dialog.
     */
    function AddRecipientsToTicket() {
        var RecipientField = $('#RecipientField').val(),
        Recipients = Core.JSON.Parse($('#RecipientSelectedJSON').val());

        $.each(Recipients, function(UserLogin, CustomerTicketText) {

            if (!CustomerTicketText) {
                return true;
            }

            parent.Core.App.Publish('Event.CustomerUserAddressBook.AddTicketCustomer.Callback.' + RecipientField, [UserLogin, CustomerTicketText]);
        });

        parent.Core.UI.Dialog.CloseDialog($('.Dialog', parent.document));
    }

    /**
     * @private
     * @name ShowWaitingLoader
     * @memberof Core.Agent.CustomerUserAddressBook
     * @function
     * @param {String} Selector - The selector to add the loader icon to the html.
     * @description
     *      Shows waiting loader until search screen is ready.
     */
    function ShowWaitingLoader(Selector) {
        $('.Dialog .Footer', parent.document).html('');
        $(Selector).after('<div class="Spacing Center"><span class="AJAXLoader" title="' + Core.Config.Get('LoadingMsg') + '"></span></div>');
        $(Selector).remove();
    }

    /**
     * @name InitSearchDialog
     * @memberof Core.Agent.CustomerUserAddressBook
     * @function
     * @description
     *      This function init the search dialog.
     */
    TargetNS.InitSearchDialog = function () {

        // move search button to dialog footer
        $('.Dialog .Footer', parent.document).html($('.SearchFormButton').html());
        $('.Dialog .Footer', parent.document).addClass('Center');
        $('.SearchFormButton').remove();

        // hide add template block
        $('#SearchProfileAddBlock').hide();

        // hide save changes in template block
        $('#SaveProfile').parent().hide().prev().hide().prev().hide();

        // search profile is selected
        if ($('#SearchProfile').val() && $('#SearchProfile').val() !== 'last-search') {

            // show delete button
            $('#SearchProfileDelete').show();

            // show save changes in template block
            $('#SaveProfile').parent().show().prev().show().prev().show();

            // set SaveProfile to 0
            $('#SaveProfile').prop('checked', false);
        }

        Core.Agent.Search.AddSearchAttributes();
        Core.Agent.Search.AdditionalAttributeSelectionRebuild();

        Core.UI.InputFields.Activate($('.Dialog:visible'));

        // register add of attribute
        $('#Attribute').on('change', function () {
            var Attribute = $('#Attribute').val();
            Core.Agent.Search.SearchAttributeAdd(Attribute);
            Core.Agent.Search.AdditionalAttributeSelectionRebuild();
            return false;
        });

        // register return key
        $('#SearchForm').off('keypress.FilterInput').on('keypress.FilterInput', function (Event) {
            if ((Event.charCode || Event.keyCode) === 13) {
                if (!CheckForSearchedValues()) {
                    return false;
                }
                else {
                    $('#SearchFormSubmit', parent.document).trigger('click');
                }
                return false;
            }
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
        });

        // Close the dialog.
        $('#FormCancel', parent.document).on('click', function() {
            parent.Core.UI.Dialog.CloseDialog($('.Dialog', parent.document));
        });


        // Register submit for search.
        $('#SearchFormSubmit', parent.document).on('click', function () {
            var ShownAttributes = '',
            ExcludeUserLogins = [];

            // Remember shown attributes.
            $('#SearchInsert label').each(function () {
                if ($(this).attr('id')) {
                    ShownAttributes = ShownAttributes + ';' + $(this).attr('id');
                }
            });
            $('#SearchForm #ShownAttributes').val(ShownAttributes);

            // Check for already added customer users entries.
            $('.CustomerKey', parent.document).each(function() {
                if($(this).val()) {
                    ExcludeUserLogins.push($(this).val());
                }
            });

            if (ExcludeUserLogins) {
                $('#SearchForm #ExcludeUserLogins').val(Core.JSON.Stringify(ExcludeUserLogins));
            }
            if (!CheckForSearchedValues()) {
                return false;
            }
            else {
               $('#SearchForm').submit();
               ShowWaitingLoader('.ContentColumn');
            }
        });

        // load profile
        $('#SearchProfile').on('change', function () {
            var SearchProfile = $('#SearchProfile').val(),
                SearchProfileEmptySearch = $('#EmptySearch').val(),
                SearchProfileAction = $('#SearchAction').val(),
                RecipientType = $('#RecipientType').val(),
                RecipientField = $('#RecipientField').val(),
                RecipientFieldLabel = $('#RecipientFieldLabel').val();

            window.location.href = Core.Config.Get('Baselink') + 'Action=' + SearchProfileAction + ';RecipientType=' + RecipientType + ';RecipientField=' + RecipientField + ';RecipientFieldLabel=' + RecipientFieldLabel + ';Subaction=LoadProfile;EmptySearch=' +
            encodeURIComponent(SearchProfileEmptySearch) + ';Profile=' + encodeURIComponent(SearchProfile);
            return false;
        });

        // show add profile block or not
        $('#SearchProfileNew').on('click', function (Event) {
            $('#SearchProfileAddBlock').toggle();
            $('#SearchProfileAddName').focus();
            Event.preventDefault();
            return false;
        });

        // delete profile
        $('#SearchProfileDelete').on('click', function (Event) {
            var SearchProfileAction = $('#SearchAction').val(),
                RecipientType = $('#RecipientType').val(),
                RecipientField = $('#RecipientField').val(),
                RecipientFieldLabel = $('#RecipientFieldLabel').val();

            Event.preventDefault();

            // strip all already used attributes
            $('#SearchProfile').find('option:selected').each(function () {
                if ($(this).attr('value') !== 'last-search') {
                    window.location.href = Core.Config.Get('Baselink') + 'Action=' + SearchProfileAction + ';RecipientType=' + RecipientType + ';RecipientField=' + RecipientField + ';RecipientFieldLabel=' + RecipientFieldLabel + ';Subaction=DeleteProfile;Profile=' +
                    encodeURIComponent($(this).val());
                    return false;
                }
            });
        });
    };

    /**
     * @name InitRecipientSelection
     * @memberof Core.Agent.CustomerUserAddressBook
     * @function
     * @description
     *      This function init the recipient selection.
     */
    TargetNS.InitRecipientSelection = function () {
        var InitialRecipients = Core.JSON.Parse($('#RecipientSelectedJSON').val());

        // Add the current field label and move recipient selection button in the dialog footer
        //  for the result view, to have the same view in all dialog widgets.
        $('#RecipientSelect span').append(' ' +  $('#RecipientFieldLabel').val() + ' (' + Object.keys(InitialRecipients).length + ')');
        $('.Dialog .Footer', parent.document).html($('.RecipientButton').html());
        $('.RecipientButton').remove();

        if (!Object.keys(InitialRecipients).length) {
            $('#RecipientSelect', parent.document).prop('disabled', true);
            $('#RecipientSelect', parent.document).addClass('Disabled');
        }

        $('#SelectAllCustomerUser').on('click', function () {
            var Status = $(this).prop('checked'),
            Recipients = Core.JSON.Parse($('#RecipientSelectedJSON').val()),
            AddRecipientsButtonHTML = $('#RecipientSelect span', parent.document).html();

            $(RecipientUserLoginElementSelector).prop('checked', Status).triggerHandler('click');

            $(RecipientUserLoginElementSelector).each(function() {
                var UserLogin = $(this).val();

                if (Status) {
                    Recipients[UserLogin] = $(this).data('customer-ticket-text');
                }
                else {
                    delete Recipients[UserLogin];
                }
            });

            // Disable the recipient select button, if no recipient is selected.
            if (!Object.keys(Recipients).length) {
                $('#RecipientSelect', parent.document).prop('disabled', true);
                $('#RecipientSelect', parent.document).addClass('Disabled');
            }
            else {
                $('#RecipientSelect', parent.document).prop('disabled', false);
                $('#RecipientSelect', parent.document).removeClass('Disabled');
            }

            $('#RecipientSelect span', parent.document).html(AddRecipientsButtonHTML.replace(/[ ]?\(?\d*\)?$/, ' (' + Object.keys(Recipients).length + ')'));
            $('#RecipientSelectedJSON').val(Core.JSON.Stringify(Recipients));
        });

        $(RecipientUserLoginElementSelector).on('click', function (Event) {
            var Status = $(this).prop('checked'),
            UserLogin = $(this).val(),
            Recipients = Core.JSON.Parse($('#RecipientSelectedJSON').val()),
            AddRecipientsButtonHTML = $('#RecipientSelect span', parent.document).html();

            Event.stopPropagation();
            Core.Form.SelectAllCheckboxes($(this), $('#SelectAllCustomerUser'));

            if (Status) {
                Recipients[UserLogin] = $(this).data('customer-ticket-text');
            }
            else {
                delete Recipients[UserLogin];
            }

            $('#RecipientSelect span', parent.document).html(AddRecipientsButtonHTML.replace(/[ ]?\(?\d*\)?$/, ' (' + Object.keys(Recipients).length + ')'));

            // Disable the recipient select button, if no recipient is selected.
            if (!Object.keys(Recipients).length) {
                $('#RecipientSelect', parent.document).prop('disabled', true);
                $('#RecipientSelect', parent.document).addClass('Disabled');
            }
            else {
                $('#RecipientSelect', parent.document).prop('disabled', false);
                $('#RecipientSelect', parent.document).removeClass('Disabled');
            }

            $('#RecipientSelectedJSON').val(Core.JSON.Stringify(Recipients));
        });

        $('.MasterAction').off('click').on('click', function () {
            $(this).find('td input[type="checkbox"][name=RecipientUserLogin]').trigger('click');
        });

        // Execute the pagination as a post action instead of get.
        $('span.Pagination a').off('click').on('click', function (Event) {
            var Href = $(this).attr('href'),
            Parts = Href.split('?'),
            URL = Parts[0],
            Params = Parts[1].split(';'),
            Key,
            InputParams,
            InputFields = '';

            Event.stopPropagation();
            Event.preventDefault();

            for (Key in Params) {
                InputParams = Params[Key].split('=');
                InputFields += "<input type='hidden' name='" + InputParams[0] + "' value='" + InputParams[1] + "' />";
            }

            // Get the selected recipients json string from the current page to not lose the selections.
            InputFields += "<input type='hidden' name='" + $('#RecipientSelectedJSON').attr('name') + "' value='" + $('#RecipientSelectedJSON').val() + "' />";

            $("body").append('<form action="' + URL + '" method="post" id="SearchResultPagination">' + InputFields + '</form>');
            $("#SearchResultPagination").submit();
        });

        // Close the dialog.
        $('#FormCancel', parent.document).on('click', function() {
            parent.Core.UI.Dialog.CloseDialog($('.Dialog', parent.document));
        });

        // Register Apply button event.
        $('#RecipientSelect', parent.document).on('click', function () {
            AddRecipientsToTicket();
        });
    };

    /**
     * @name Init
     * @memberof Core.Agent.CustomerUserAddressBook
     * @function
     * @description
     *      This function init the customer user adress book search dialog or the result screen.
     */
    TargetNS.Init = function () {
        var ShowSearchDialog = Core.Config.Get('ShowSearchDialog');

        if (typeof ShowSearchDialog !== 'undefined' && parseInt(ShowSearchDialog, 10) === 1) {
            Core.Agent.CustomerUserAddressBook.InitSearchDialog();
        }
        else {
            Core.Agent.CustomerUserAddressBook.InitRecipientSelection();
        }
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.CustomerUserAddressBook || {}));
