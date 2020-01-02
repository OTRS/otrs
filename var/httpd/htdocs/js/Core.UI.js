// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var Core = Core || {};

/**
 * @namespace Core.UI
 * @memberof Core
 * @author OTRS AG
 * @description
 *      This namespace contains all UI functions.
 */
Core.UI = (function (TargetNS) {

    /**
     * @private
     * @name IDGeneratorCount
     * @memberof Core.UI
     * @member {Number}
     * @description
     *      Counter for automatic HTML element ID generation.
     */
    var IDGeneratorCount = 0;

    /**
     * @name InitWidgetActionToggle
     * @memberof Core.UI
     * @function
     * @description
     *      This function initializes the toggle mechanism for all widgets with a WidgetAction toggle icon.
     */
    TargetNS.InitWidgetActionToggle = function () {
        $(".WidgetAction.Toggle > a")
            .each(function () {
                var $WidgetElement = $(this).closest("div.Header").parent('div'),
                    ContentDivID = TargetNS.GetID($WidgetElement.children('.Content'));

                // fallback to Expanded if default state was not given
                if (!$WidgetElement.hasClass('Expanded') && !$WidgetElement.hasClass('Collapsed')){
                    $WidgetElement.addClass('Expanded');
                }

                $(this)
                    .attr('aria-controls', ContentDivID)
                    .attr('aria-expanded', $WidgetElement.hasClass('Expanded'));
            })
            .off('click.WidgetToggle')
            .on('click.WidgetToggle', function (Event) {
                var $WidgetElement = $(this).closest("div.Header").parent('div'),
                    Animate = $WidgetElement.hasClass('Animate'),
                    $that = $(this);

                function ToggleWidget() {
                    $WidgetElement
                        .toggleClass('Collapsed')
                        .toggleClass('Expanded')
                        .end()
                        .end()
                        .attr('aria-expanded', $that.closest("div.Header").parent('div').hasClass('Expanded'));
                        Core.App.Publish('Event.UI.ToggleWidget', [$WidgetElement]);
                }

                if (Animate) {
                    $WidgetElement.addClass('AnimationRunning').find('.Content').slideToggle("fast", function () {
                        ToggleWidget();
                        $WidgetElement.removeClass('AnimationRunning');
                    });
                } else {
                    ToggleWidget();
                }

                Event.preventDefault();
            });
    };

    /**
     * @name WidgetOverlayShow
     * @memberof Core.UI
     * @function
     * @param {jQueryObject} $Widget - Widget element
     * @param {String} Type - type of icon which should be displayed (currently only 'Loading' is possible)
     * @description
     *      This function covers a given widget with an overlay
     */
    TargetNS.WidgetOverlayShow = function ($Widget, Type) {

        var IconClass = 'fa-check'
        if (Type || Type == 'Loading') {
            IconClass = 'fa-circle-o-notch fa-spin'
        }

        $Widget
            .addClass('HasOverlay')
            .find('.Content')
            .prepend('<div class="Overlay" style="display: none;"><i class="fa ' + IconClass + '"></i></div>')
            .children('.Overlay')
            .fadeIn();
    };

    /**
     * @name InitWidgetTabs
     * @memberof Core.UI
     * @function
     * @description
     *      Initializes tab functions (e.g. link navigation) on widgets with class 'Tabs'.
     */
    TargetNS.InitWidgetTabs = function() {

        function ActivateTab($TriggerObj) {

            var $ContainerObj = $TriggerObj.closest('.WidgetSimple'),
                TargetID      = $TriggerObj.attr('href').replace('#', ''),
                $TargetObj    = $ContainerObj.find('div[data-id="' + TargetID + '"]');

            if ($TriggerObj.hasClass('Disabled')) {
                return false;
            }

            // if tab doesnt exist or is already active, do nothing
            if ($TargetObj.length && !$TargetObj.hasClass('Active')) {

                $ContainerObj.find('.Header > a').removeClass('Active');
                $TriggerObj.addClass('Active');
                $ContainerObj.find('.Content > div.Active').hide().removeClass('Active');
                $TargetObj.fadeIn(function() {
                    $(this).addClass('Active');

                    // activate any modern input fields on the active tab
                    Core.UI.InputFields.Activate($TargetObj);
                });
            }
        }

        // check if the url contains a tab id anchor and jump directly
        // to this tab if it's the case.
        $('.WidgetSimple.Tabs .Header a').each(function() {
            var TargetID = $(this).attr('href');
            if (window.location.href.indexOf(TargetID) > -1) {
                ActivateTab($(this));
                return false;
            }
        });

        $('.WidgetSimple.Tabs .Header a').on('click', function(Event) {

            if ($(this).hasClass('Disabled')) {
                Event.stopPropagation();
                Event.preventDefault();
                return false;
            }

            ActivateTab($(this));
        });
    };

    /**
     * @name WidgetOverlayHide
     * @memberof Core.UI
     * @function
     * @param {jQueryObject} $Widget - Widget element
     * @param {Boolean} Switch - Whether the overlay should show a success icon before being removed
     * @description
     *      This function removes an overlay from a given widget
     */
    TargetNS.WidgetOverlayHide = function ($Widget, Switch) {

        if (Switch) {
            $Widget
                .find('.Overlay i')
                .fadeOut()
                .parent()
                .append('<i class="fa fa-check" style="display: none;" />')
                .find('i:last-child')
                .fadeIn()
                .parent()
                .delay(1000)
                .fadeOut(function() {
                    $(this).remove();
                    $Widget.removeClass('HasOverlay');
                });
        }
        else {
            $Widget
                .find('.Overlay')
                .fadeOut(function() {
                    $(this).remove();
                    $Widget.removeClass('HasOverlay');
                });
        }
    };

    /**
     * @name InitMessageBoxClose
     * @memberof Core.UI
     * @function
     * @description
     *      This function initializes the close buttons for the message boxes that show server messages.
     */
    TargetNS.InitMessageBoxClose = function () {
        $(".MessageBox > a.Close")
            .off('click.MessageBoxClose')
            .on('click.MessageBoxClose', function (Event) {
                $(this).parent().remove();
                Event.preventDefault();
            });
    };

    /**
     * @name GetID
     * @memberof Core.UI
     * @function
     * @returns {String} ID of the element
     * @param {jQueryObject} $Element - The HTML element
     * @description
     *      Returns the ID of the Element and creates one for it if nessessary.
     */
    TargetNS.GetID = function ($Element) {
        var ID;

        function GenerateID() {
            return 'Core_UI_AutogeneratedID_' + IDGeneratorCount++;
        }

        if ($Element) {
            if ($Element.attr('id')) {
                ID = $Element.attr('id');
            }
            else {
                ID = GenerateID();
                $Element.attr('id', ID);
            }
        }
        else {
            ID = GenerateID();
        }

        return ID;
    };

    /**
     * @name ToggleTwoContainer
     * @memberof Core.UI
     * @function
     * @param {jQueryObject} $Element1 - First container element.
     * @param {jQueryObject} $Element2 - Second container element.
     * @description
     *      This functions toggles two Containers with a nice slide effect.
     */
    TargetNS.ToggleTwoContainer = function ($Element1, $Element2) {
        if (isJQueryObject($Element1, $Element2) && $Element1.length && $Element2.length) {
            $Element1.slideToggle('fast', function () {
                $Element2.slideToggle('fast', function() {
                    Core.UI.InputFields.InitSelect($Element2.find('.Modernize'));
                });
                Core.UI.InputFields.InitSelect($Element1.find('.Modernize'));
            });
        }
    };

    /**
     * @name RegisterToggleTwoContainer
     * @memberof Core.UI
     * @function
     * @param {jQueryObject} $ClickedElement
     * @param {jQueryObject} $Element1 - First container element.
     * @param {jQueryObject} $Element2 - Second container element.
     * @description
     *      Registers click event to toggle the container.
     */
    TargetNS.RegisterToggleTwoContainer = function ($ClickedElement, $Element1, $Element2) {
        if (isJQueryObject($ClickedElement) && $ClickedElement.length) {
            $ClickedElement.click(function () {
                var $ContainerObj = $(this).closest('.WidgetSimple').find('.AllocationListContainer'),
                    FieldName,
                    Data = {};

                if ($Element1.is(':visible')) {
                    TargetNS.ToggleTwoContainer($Element1, $Element2);
                }
                else {
                    TargetNS.ToggleTwoContainer($Element2, $Element1);
                }

                Data.Columns = {};
                Data.Order = [];

                // Get initial columns order (see bug#10683).
                $ContainerObj.find('.AvailableFields').find('li').each(function() {
                    FieldName = $(this).attr('data-fieldname');
                    Data.Columns[FieldName] = 0;
                });

                $ContainerObj.find('.AssignedFields').find('li').each(function() {
                    FieldName = $(this).attr('data-fieldname');
                    Data.Columns[FieldName] = 1;
                    Data.Order.push(FieldName);
                });
                $ContainerObj.closest('form').find('.ColumnsJSON').val(Core.JSON.Stringify(Data));

                return false;
            });
        }
    };

    /**
     * @name ScrollTo
     * @memberof Core.UI
     * @function
     * @param {jQueryObject} $Element
     * @description
     *      Scrolls the active window until an element is visible.
     */
    TargetNS.ScrollTo = function ($Element) {
        if (isJQueryObject($Element) && $Element.length) {
            window.scrollTo(0, $Element.offset().top);
        }
    };

    /**
     * @name ShowNotification
     * @memberof Core.UI
     * @function
     * @param {String} Text the text which should be shown in the notification (untranslated)
     * @param {String} Type Error|Notice (default)
     * @param {String} Link the (internal) URL to which the notification text should point
     * @param {Function} Callback function which should be executed once the notification was hidden
     * @param {String} ID The id for the newly created notification (default: no ID)
     * @param {String} Icon Class of a fontawesome icon which will be added before the text (optional)
     * @returns {Boolean} true or false depending on if the notification could be shown or not
     * @description
     *      Displays a notification on top of the page.
     */
    TargetNS.ShowNotification = function (Text, Type, Link, Callback, ID, Icon) {

        var $ExistingNotifications,
            $NotificationObj;

        if (!Text) {
            return false;
        }

        if (!Type) {
            Type = 'Notice';
        }

        // check if a similar notification is already shown,
        // in this case do nothing
        $ExistingNotifications = $('.MessageBox').filter(
            function() {
                var Match = 0;
                if ($(this).find('a').text().indexOf(Text) > 0 && $(this).hasClass(Type)) {
                    Match = 1;
                }
                return Match;
            }
        );

        if ($ExistingNotifications.length) {
            return false;
        }

        if (Link) {
            Link = Core.Config.Get('Baselink') + Link;
        }

        // render the notification
        $NotificationObj = $(
            Core.Template.Render("Agent/Notification", {
                Class: Type,
                URL: Link,
                ID: ID,
                Icon: Icon,
                Text: Text
            })
        );

        // hide it initially
        $NotificationObj.hide();

        // if there are other notifications, append the new on the bottom
        if ($('.MessageBox:visible').length) {
            $NotificationObj.insertAfter('.MessageBox:visible:last');
        }
        // otherwise insert it on top
        else {
            $NotificationObj.insertAfter('#NavigationContainer');
        }

        // show it finally with animation and execute possible callbacks
        $NotificationObj.slideDown(function() {
            if ($.isFunction(Callback)) {
                Callback();
            }
        });

        return true;
    };

    /**
     * @name HideNotification
     * @memberof Core.UI
     * @function
     * @param {String} Text the text by which the notification can be recognized (untranslated).
     * @param {String} Type Error|Notice
     * @param {Function} Callback function which should be executed once the notification was hidden
     * @returns {Boolean} true or false depending on if the notification could be removed or not
     * @description
     *      Hides a certain notification.
     */
    TargetNS.HideNotification = function (Text, Type, Callback) {

        if (!Text || !Type) {
            return false;
        }

        $('.MessageBox').filter(
            function() {
                if ($(this).find('a').text().indexOf(Text) > 0 && $(this).hasClass(Type)) {
                    $(this).slideUp(function() {
                        $(this).remove();
                        if ($.isFunction(Callback)) {
                            Callback();
                        }
                    })
                }
            }
        );

        return true;
    }

    /**
     * @name InitCheckboxSelection
     * @memberof Core.UI
     * @function
     * @param {jQueryObject} $Element - The element selector which describes the element(s) which surround the checkboxes.
     * @description
     *      This function initializes a click event for tables / divs with checkboxes.
     *      If you click in the table cell / div around the checkbox the checkbox will be selected.
     *      A possible MasterAction will not be executed.
     */
    TargetNS.InitCheckboxSelection = function ($Element) {
        if (!$Element.length) {
            return;
        }

        // e.g. 'table td.Checkbox' or 'div.Checkbox'
        $Element.off('click.CheckboxSelection').on('click.CheckboxSelection', function (Event) {
            var $Checkbox = $(this).find('input[type="checkbox"]');

            if (!$Checkbox.length) {
                return;
            }

            if ($(Event.target).is('input[type="checkbox"]')) {
                return;
            }

            Event.stopPropagation();

            $Checkbox
                .prop('checked', !$Checkbox.prop('checked'))
                .triggerHandler('click');


        });
    };

    /**
     * @name Animate
     * @memberof Core.UI
     * @function
     * @param {jQueryObject} $Element - The element to animate.
     * @param {String} Type - The animation type as defined in Core.Animations.css, e.g. 'Shake'
     * @description
     *      Animate an element on demand using a css-based animation of the given type
     */
    TargetNS.Animate = function ($Element, Type) {
        if (!$Element.length || !Type) {
            return;
        }
        $Element.addClass('Animation' + Type);
    };

    /**
     * @name InitMasterAction
     * @memberof Core.UI
     * @function
     * @description
     *      Extend click event to the whole table row.
     */
    TargetNS.InitMasterAction = function () {
        $('.MasterAction').click(function (Event) {
            var $MasterActionLink = $(this).find('.MasterActionLink');

            // only act if the link was not clicked directly
            if (Event.target !== $MasterActionLink.get(0)) {
                window.location = $MasterActionLink.attr('href');
                return false;
            }
        });
    };

    /**
     * @name InitAjaxDnDUpload
     * @memberof Core.UI
     * @function
     * @description
     *      Init drag & drop ajax upload on relevant input fields of type "file"
     */
    TargetNS.InitAjaxDnDUpload = function () {

        function UploadFiles(SelectedFiles, $DropObj) {

            var $ContainerObj = $DropObj.closest('.Field'),
                $FileuploadFieldObj = $ContainerObj.find('.AjaxDnDUpload'),
                FormID = $FileuploadFieldObj.data('form-id') ? $FileuploadFieldObj.data('form-id') : $DropObj.closest('form').find('input[name=FormID]').val(),
                ChallengeToken = $DropObj.closest('form').find('input[name=ChallengeToken]').val(),
                IsMultiple = ($FileuploadFieldObj.attr('multiple') == 'multiple'),
                MaxFiles = $FileuploadFieldObj.data('max-files'),
                MaxSizePerFile = $FileuploadFieldObj.data('max-size-per-file'),
                MaxSizePerFileHR = $FileuploadFieldObj.data('max-size-per-file-hr'),
                FileTypes = $FileuploadFieldObj.data('file-types'),
                Upload,
                XHRObj,
                FileTypeNotAllowed = [],
                FileTypeNotAllowedText,
                FilesTooBig = [],
                FilesTooBigText,
                AttemptedToUploadAgain = [],
                AttemptedToUploadAgainText,
                NoSpaceLeft = [],
                NoSpaceLeftText,
                UsedSpace = 0,
                WebMaxFileUpload = Core.Config.Get('WebMaxFileUpload'),
                CGIHandle = Core.Config.Get('CGIHandle'),
                SessionToken = '',
                SessionName;

            if (!FormID || !SelectedFiles || !$DropObj || !ChallengeToken) {
                return false;
            }

            // If SessionUseCookie is disabled use Session cookie in AjaxAttachment. See bug#14432.
            if (Core.Config.Get('SessionUseCookie') === '0') {
                if (CGIHandle.indexOf('index') > -1) {
                    SessionName =  Core.Config.Get('SessionName');
                }
                else if (CGIHandle.indexOf('customer') > -1) {
                    SessionName =  Core.Config.Get('CustomerPanelSessionName');
                }
                SessionToken = ';' + SessionName + '=' + $DropObj.closest('form').find('input[name=' + SessionName + ']').val();
            }

            // if the original upload field doesn't have the multiple attribute,
            // prevent uploading of more than one file
            if (!IsMultiple && SelectedFiles.length > 1) {
                alert(Core.Language.Translate("Please only select one file for upload."));
                return false;
            }

            // if multiple is not allowed and a file has already been uploaded, don't allow uploading more
            if (!IsMultiple && $FileuploadFieldObj.closest('.Field').find('.AttachmentList tbody tr').length > 0) {
                alert(Core.Language.Translate("Sorry, you can only upload one file here."));
                return false;
            }

            if (MaxFiles && $FileuploadFieldObj.closest('.Field').find('.AttachmentList tbody tr').length >= MaxFiles) {
                alert(Core.Language.Translate("Sorry, you can only upload %s files.", [ MaxFiles ]));
                return false;
            }

            if (MaxFiles && SelectedFiles.length > MaxFiles) {
                alert(Core.Language.Translate("Please only select at most %s files for upload.", [ MaxFiles ]));
                return false;
            }

            // check for allowed file types
            if (FileTypes) {
                FileTypes = FileTypes.split(',');
            }

            $DropObj.prev('input[type=file]').removeClass('Error');

            // collect size of already uploaded files
            $.each($FileuploadFieldObj.closest('.Field').find('.AttachmentList tbody tr td.Filesize'), function() {
                var FileSize = parseFloat($(this).attr('data-file-size'));

                if (FileSize) {
                    UsedSpace += FileSize;
                }
            });

            $.each(SelectedFiles, function(index, File) {

                var $CurrentRowObj,
                    FileExtension = File.name.slice((File.name.lastIndexOf(".") - 1 >>> 0) + 2),
                    AttachmentItem = Core.Template.Render('AjaxDnDUpload/AttachmentItemUploading', {
                        'Filename' : File.name,
                        'Filetype' : File.type
                    }),
                    FileExist;

                // check uploaded file size
                if (File.size > (WebMaxFileUpload - UsedSpace)) {
                    NoSpaceLeft.push(
                        File.name + ' (' + Core.App.HumanReadableDataSize(File.size) + ')'
                    );
                    return true;
                }
                UsedSpace += File.size;

                // check for allowed file types
                if (typeof FileTypes === 'object' && FileTypes.indexOf(FileExtension) < 0) {
                    FileTypeNotAllowed.push(File.name);
                    return true;
                }

                // check for max file size per file
                if (MaxSizePerFile && File.size > MaxSizePerFile) {
                    FilesTooBig.push(File.name);
                    return true;
                }

                // don't allow uploading multiple files with the same name
                FileExist = $ContainerObj.find('.AttachmentList tbody tr td.Filename').filter(function() {
                    if ($(this).text() === File.name) {
                        return $(this);
                    }
                });
                if (FileExist.length) {
                    AttemptedToUploadAgain.push(File.name);
                    return true;
                }

                $DropObj.addClass('Uploading');
                $ContainerObj.find('.AttachmentList').show();

                $(AttachmentItem).prependTo($ContainerObj.find('.AttachmentList tbody')).fadeIn();
                $CurrentRowObj = $ContainerObj.find('.AttachmentList tbody tr:first-child');

                Upload = new FormData();
                Upload.append('Files', File);

                $.ajax({
                    url: Core.Config.Get('CGIHandle') + '?Action=AjaxAttachment;Subaction=Upload;FormID=' + FormID + ';ChallengeToken=' + ChallengeToken + SessionToken,
                    type: 'post',
                    data: Upload,
                    xhr: function() {
                        XHRObj = $.ajaxSettings.xhr();
                        if(XHRObj.upload){
                            XHRObj.upload.addEventListener(
                                'progress',
                                function(Upload) {
                                    var Percentage = (Upload.loaded * 100) / Upload.total;
                                    $CurrentRowObj.find('.Progress').animate({
                                        'width': Percentage + '%'
                                    });
                                    if (Percentage === 100) {
                                        $CurrentRowObj.find('.Progress').delay(1000).fadeOut(function() {
                                            $(this).remove();
                                        });
                                    }
                                },
                                false
                            );
                        }
                        return XHRObj;
                    },
                    dataType: 'json',
                    cache: false,
                    contentType: false,
                    processData: false,
                    success: function(Response) {

                        $.each(Response, function(index, Attachment) {

                            // walk through the list to see if we can update an entry
                            var AttachmentItem,
                                $ExistingItemObj = $ContainerObj.find('.AttachmentList tbody tr td.Filename').filter(function() {
                                    if ($(this).text() === Attachment.Filename) {
                                        return $(this);
                                    }
                                }),
                                $TargetObj;

                            // update the existing item if one exists
                            if ($ExistingItemObj.length) {

                                $TargetObj = $ExistingItemObj.closest('tr');

                                if ($TargetObj.find('a').data('file-id')) {
                                    return;
                                }

                                $TargetObj
                                    .find('.Filetype')
                                    .text(Attachment.ContentType)
                                    .closest('tr')
                                    .find('.Filesize')
                                    .text(Attachment.HumanReadableDataSize)
                                    .attr('data-file-size', Attachment.Filesize)
                                    .next('td')
                                    .find('a')
                                    .removeClass('Hidden')
                                    .data('file-id', Attachment.FileID);
                            }
                            else {

                                AttachmentItem = Core.Template.Render('AjaxDnDUpload/AttachmentItem', {
                                    'Filename' : Attachment.Filename,
                                    'Filetype' : Attachment.ContentType,
                                    'Filesize' : Attachment.Filesize,
                                    'FileID'   : Attachment.FileID,
                                });

                                $(AttachmentItem).prependTo($ContainerObj.find('.AttachmentList tbody')).fadeIn();
                            }

                            // Append input field for validation (see bug#13081).
                            if (!$('#AttachmentExists').length) {
                                $('.AttachmentListContainer').append('<input type="hidden" id="AttachmentExists" name="AttachmentExists" value="1" />');
                            }
                        });

                        // we need to empty the relevant file upload field because it would otherwise
                        // transfer the selected files again (only on click select, not on drag & drop)
                        $DropObj.prev('input[type=file]').val('');
                        $DropObj.removeClass('Uploading');
                    },
                    error: function() {
                        // TODO: show an error tooltip?
                        $DropObj.removeClass('Uploading');
                    }
                });
            });

            if (FileTypeNotAllowed.length || FilesTooBig.length || NoSpaceLeft.length || AttemptedToUploadAgain.length) {

                FileTypeNotAllowedText = '';
                FilesTooBigText = '';
                AttemptedToUploadAgainText = '';
                NoSpaceLeftText = '';

                if (FileTypeNotAllowed.length) {
                    FileTypeNotAllowedText =
                        Core.Language.Translate(
                            'The following files are not allowed to be uploaded: %s',
                            '<br>' + FileTypeNotAllowed.join(',<br>') + '<br><br>'
                        );
                }

                if (FilesTooBig.length) {
                    FilesTooBigText =
                        Core.Language.Translate(
                            'The following files exceed the maximum allowed size per file of %s and were not uploaded: %s',
                            MaxSizePerFileHR,
                            '<br>' + FilesTooBig.join(',<br>') + '<br><br>'
                        );
                }

                if (AttemptedToUploadAgain.length) {
                    AttemptedToUploadAgainText =
                        Core.Language.Translate(
                            'The following files were already uploaded and have not been uploaded again: %s',
                            '<br>' + AttemptedToUploadAgain.join(',<br>') + '<br><br>'
                        );
                }

                if (NoSpaceLeft.length) {
                    NoSpaceLeftText =
                        Core.Language.Translate(
                            'No space left for the following files: %s',
                            '<br>' + NoSpaceLeft.join(',<br>')
                        )
                        + '<br><br>'
                        + Core.Language.Translate(
                            'Available space %s of %s.',
                            Core.App.HumanReadableDataSize(WebMaxFileUpload - UsedSpace),
                            Core.App.HumanReadableDataSize(WebMaxFileUpload)
                        );
                }
                Core.UI.Dialog.ShowAlert(Core.Language.Translate('Upload information'), FileTypeNotAllowedText + FilesTooBigText + AttemptedToUploadAgainText + NoSpaceLeftText);
            }
        }

        $('.AttachmentList').each(function() {
            if ($(this).find('tbody tr').length) {
                $(this).show();
            }
        });

        // Attachment deletion
        $('.AttachmentList').off('click').on('click', '.AttachmentDelete', function() {

            var $TriggerObj = $(this),
                $AttachmentListContainerObj = $TriggerObj.closest('.AttachmentListContainer'),
                $UploadFieldObj = $AttachmentListContainerObj.next('.AjaxDnDUpload'),
                FormID = $UploadFieldObj.data('form-id') ? $UploadFieldObj.data('form-id') : $(this).closest('form').find('input[name=FormID]').val(),
                Data = {
                    Action: $(this).data('delete-action') ? $(this).data('delete-action') : 'AjaxAttachment',
                    Subaction: 'Delete',
                    FileID: $(this).data('file-id'),
                    FormID: FormID,
                    ObjectID: $(this).data('object-id'),
                    FieldID: $(this).data('field-id'),
                };

            $TriggerObj.closest('.AttachmentListContainer').find('.Busy').fadeIn();

            Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {
                if (Response && Response.Message && Response.Message == 'Success') {
                    $TriggerObj.closest('tr').fadeOut(function() {

                        $(this).remove();

                        if (Response.Data && Response.Data.length) {

                            // go through all attachments and update the FileIDs
                            $.each(Response.Data, function(index, Attachment) {
                                $AttachmentListContainerObj.find('.AttachmentList td:contains(' + Attachment.Filename + ')').closest('tr').find('a').data('file-id', Attachment.FileID);
                            });
                            $AttachmentListContainerObj.find('.Busy').fadeOut();
                        }
                        else {
                            $AttachmentListContainerObj.find('.AttachmentList').hide();
                            $AttachmentListContainerObj.find('.Busy').hide();

                            // Remove input field because validation is not needed when there is no attachments (see bug#13081).
                            $('#AttachmentExists').remove();
                        }
                    });
                }
                else {
                    alert(Core.Language.Translate('An unknown error occurred when deleting the attachment. Please try again. If the error persists, please contact your system administrator.'));
                    $AttachmentListContainerObj.find('.Busy').hide();
                }
            });

            return false;
        });

        $('input[type=file].AjaxDnDUpload').each(function() {

            var IsMultiple = ($(this).attr('multiple') == 'multiple'),
                UploadContainer = Core.Template.Render('AjaxDnDUpload/UploadContainer', {
                    'IsMultiple': IsMultiple
                });

            // Only initialize events once per attachment field.
            if ($(this).next().hasClass('AjaxDnDUploadReady')) {
                return;
            }

            $(this)
                .val('')
                .hide()
                .on('change', function(Event) {
                    UploadFiles(Event.target.files, $(this).next('.DnDUpload'));
                })
                .after($(UploadContainer))
                .next('.DnDUpload')
                .on('click keydown', function(Event) {

                    if (Event.keyCode && Event.keyCode == 9) {
                        return true;
                    }

                    // The file selection dialog should also appear on focusing the element and pressing enter/space.
                    if (Event.keyCode && (Event.keyCode != 13 && Event.keyCode != 32)) {
                        return false;
                    }

                    // If this certain upload field does not allow uploading more than one file and a file has
                    // already been uploaded, prevent the user from uploading more files.
                    if (!IsMultiple && $(this).closest('.Field').find('.AttachmentList tbody tr').length > 0) {
                        alert(Core.Language.Translate("Sorry, you can only upload one file here."));
                        return false;
                    }

                    $(this).prev('input.AjaxDnDUpload').trigger('click');
                })
                .on('drag dragstart dragend dragover dragenter dragleave drop', function(Event) {
                    Event.preventDefault();
                    Event.stopPropagation();
                })
                .on('dragover dragenter', function() {
                    $(this).addClass('DragOver');
                })
                .on('dragleave dragend drop', function() {
                    $(this).removeClass('DragOver');
                })
                .on('drop', function(Event) {
                    UploadFiles(Event.originalEvent.dataTransfer.files, $(this));
                })
                .addClass('AjaxDnDUploadReady');
        });
    };

    /**
     * @name InitStickyWidget
     * @memberof Core.UI
     * @function
     * @param {jQueryObject} $Element - The element to animate.
     * @param {String} Type - The animation type as defined in Core.Animations.css, e.g. 'Shake'
     * @description
     *      Animate an element on demand using a css-based animation of the given type
     */
    TargetNS.InitStickyElement = function () {

        var Position = $('.StickyElement').offset(),
            Width = $('.StickyElement').outerWidth(),
            $Element = $('.StickyElement'),
            Visible = $('.StickyElement').is(':visible');

        if (!Visible) {
            return;
        }

        // if we are on a mobile environment, don't use sticky elements
        if (Core.App.Responsive.IsSmallerOrEqual(Core.App.Responsive.GetScreenSize(), 'ScreenL')) {
            return;
        }

        if (!$Element.length || $Element.length > 1) {
            return;
        }

        if ($Element.hasClass('IsSticky')) {
            return;
        }

        function RepositionElement($Element, Width) {
            if ($(window).scrollTop() > Position.top) {

                if ($Element.hasClass('IsSticky')) {
                    return false;
                }

                $Element.css({
                    'position' : 'fixed',
                    'top'      : '9px',
                    'width'    : Width
                }).addClass('IsSticky');
            }
            else {
                $Element.css('position', 'static').removeClass('IsSticky');
            }
        }

        RepositionElement($Element, Width);
        $(window).off('scroll.StickyElement').on('scroll.StickyElement', function() {
            RepositionElement($Element, Width);
        });
    };

    /**
     * @name Init
     * @memberof Core.UI
     * @function
     * @description
     *      Initializes the namespace.
     */
    TargetNS.Init = function() {
        Core.UI.InitWidgetActionToggle();
        Core.UI.InitWidgetTabs();
        Core.UI.InitMessageBoxClose();
        Core.UI.InitMasterAction();
        Core.UI.InitAjaxDnDUpload();
        Core.UI.InitStickyElement();
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_GLOBAL');

    return TargetNS;
}(Core.UI || {}));
