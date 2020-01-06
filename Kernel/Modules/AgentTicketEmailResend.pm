# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentTicketEmailResend;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);
use Mail::Address;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    $Self->{Debug} = $Param{Debug} || 0;

    # Get form ID.
    $Self->{FormID} = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'FormID' );

    # Create new form ID.
    if ( !$Self->{FormID} ) {
        $Self->{FormID} = $Kernel::OM->Get('Kernel::System::Web::UploadCache')->FormIDCreate();
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    if ( !$Self->{TicketID} ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('No TicketID is given!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
    my $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');
    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Email' );

    # Get config for frontend module.
    my $Config = $ConfigObject->Get("Ticket::Frontend::$Self->{Action}");

    # Check permissions.
    my $Access = $TicketObject->TicketPermission(
        Type     => $Config->{Permission},
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID}
    );

    # Error screen, don't show article action.
    if ( !$Access ) {
        return $LayoutObject->NoPermission(
            Message => $LayoutObject->{LanguageObject}->Translate( 'You need %s permissions!', $Config->{Permission} ),
            WithHeader => 'yes',
        );
    }

    # Get ACL restrictions.
    my %PossibleActions = ( 1 => $Self->{Action} );

    my $ACL = $TicketObject->TicketAcl(
        Data          => \%PossibleActions,
        Action        => $Self->{Action},
        TicketID      => $Self->{TicketID},
        ReturnType    => 'Action',
        ReturnSubType => '-',
        UserID        => $Self->{UserID},
    );
    my %AclAction = $TicketObject->TicketAclActionData();

    # Check if ACL restrictions exist.
    if ( $ACL || IsHashRefWithData( \%AclAction ) ) {

        my %AclActionLookup = reverse %AclAction;

        # Show error screen if ACL prohibits this action.
        if ( !$AclActionLookup{ $Self->{Action} } ) {
            return $LayoutObject->NoPermission( WithHeader => 'yes' );
        }
    }

    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Self->{TicketID},
        DynamicFields => 1
    );

    # Get lock state.
    my $TicketBackType = 'TicketBack';
    if ( $Config->{RequiredLock} ) {
        if ( !$TicketObject->TicketLockGet( TicketID => $Self->{TicketID} ) ) {

            my $Lock = $TicketObject->TicketLockSet(
                TicketID => $Self->{TicketID},
                Lock     => 'lock',
                UserID   => $Self->{UserID}
            );

            # Set new owner if ticket owner is different then logged user.
            if ( $Lock && ( $Ticket{OwnerID} != $Self->{UserID} ) ) {

                # Remember previous owner, which will be used to restore ticket owner on undo action.
                $Ticket{PreviousOwner} = $Ticket{OwnerID};

                my $Success = $TicketObject->TicketOwnerSet(
                    TicketID  => $Self->{TicketID},
                    UserID    => $Self->{UserID},
                    NewUserID => $Self->{UserID},
                );

                # Show lock state.
                if ( !$Success ) {
                    return $LayoutObject->FatalError();
                }
            }

            $TicketBackType .= 'Undo';
        }
        else {
            my $AccessOk = $TicketObject->OwnerCheck(
                TicketID => $Self->{TicketID},
                OwnerID  => $Self->{UserID},
            );
            if ( !$AccessOk ) {
                my $Output = $LayoutObject->Header(
                    Value     => $Ticket{Number},
                    Type      => 'Small',
                    BodyClass => 'Popup',
                );
                $Output .= $LayoutObject->Warning(
                    Message => Translatable('Sorry, you need to be the ticket owner to perform this action.'),
                    Comment => Translatable('Please change the owner first.'),
                );
                $Output .= $LayoutObject->Footer(
                    Type => 'Small',
                );
                return $Output;
            }
        }
    }

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    my %GetParam;
    for (
        qw(
        From To Cc Bcc Subject Body InReplyTo References ArticleID
        IsVisibleForCustomerPresent IsVisibleForCustomer TimeUnits FormID
        )
        )
    {
        $GetParam{$_} = $ParamObject->GetParam( Param => $_ );
    }

    if ( !$GetParam{ArticleID} ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('No ArticleID is given!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    # Hash for lookup of duplicated entries.
    my %AddressesList;

    my @MultipleCustomer;
    my $CustomersNumber = $ParamObject->GetParam( Param => 'CustomerTicketCounterToCustomer' ) || 0;
    my $Selected        = $ParamObject->GetParam( Param => 'CustomerSelected' )                || '';

    my $CheckItemObject = $Kernel::OM->Get('Kernel::System::CheckItem');

    if ($CustomersNumber) {

        my $CustomerCounter = 1;
        for my $Count ( 1 ... $CustomersNumber ) {
            my $CustomerElement  = $ParamObject->GetParam( Param => 'CustomerTicketText_' . $Count );
            my $CustomerSelected = ( $Selected eq $Count ? 'checked="checked"' : '' );
            my $CustomerKey      = $ParamObject->GetParam( Param => 'CustomerKey_' . $Count )
                || '';
            my $CustomerQueue = $ParamObject->GetParam( Param => 'CustomerQueue_' . $Count )
                || '';
            if ($CustomerElement) {

                if ( $GetParam{To} ) {
                    $GetParam{To} .= ', ' . $CustomerElement;
                }
                else {
                    $GetParam{To} = $CustomerElement;
                }

                # Check email address.
                my $CustomerErrorMsg = 'CustomerGenericServerErrorMsg';
                my $CustomerError    = '';
                for my $Email ( Mail::Address->parse($CustomerElement) ) {
                    if ( !$CheckItemObject->CheckEmail( Address => $Email->address() ) ) {
                        $CustomerErrorMsg = $CheckItemObject->CheckErrorType()
                            . 'ServerErrorMsg';
                        $CustomerError = 'ServerError';
                    }
                }

                # Check for duplicated entries.
                if ( defined $AddressesList{$CustomerElement} && $CustomerError eq '' ) {
                    $CustomerErrorMsg = 'IsDuplicatedServerErrorMsg';
                    $CustomerError    = 'ServerError';
                }

                my $CustomerDisabled = '';
                my $CountAux         = $CustomerCounter++;
                if ( $CustomerError ne '' ) {
                    $CustomerDisabled = 'disabled="disabled"';
                    $CountAux         = $Count . 'Error';
                }

                if ( $CustomerQueue ne '' ) {
                    $CustomerQueue = $Count;
                }

                push @MultipleCustomer, {
                    Count            => $CountAux,
                    CustomerElement  => $CustomerElement,
                    CustomerSelected => $CustomerSelected,
                    CustomerKey      => $CustomerKey,
                    CustomerError    => $CustomerError,
                    CustomerErrorMsg => $CustomerErrorMsg,
                    CustomerDisabled => $CustomerDisabled,
                    CustomerQueue    => $CustomerQueue,
                };
                $AddressesList{$CustomerElement} = 1;
            }
        }
    }

    my @MultipleCustomerCc;
    my $CustomersNumberCc = $ParamObject->GetParam( Param => 'CustomerTicketCounterCcCustomer' ) || 0;

    if ($CustomersNumberCc) {
        my $CustomerCounterCc = 1;
        for my $Count ( 1 ... $CustomersNumberCc ) {
            my $CustomerElementCc = $ParamObject->GetParam( Param => 'CcCustomerTicketText_' . $Count );
            my $CustomerKeyCc     = $ParamObject->GetParam( Param => 'CcCustomerKey_' . $Count )
                || '';
            my $CustomerQueueCc = $ParamObject->GetParam( Param => 'CcCustomerQueue_' . $Count )
                || '';

            if ($CustomerElementCc) {

                if ( $GetParam{Cc} ) {
                    $GetParam{Cc} .= ', ' . $CustomerElementCc;
                }
                else {
                    $GetParam{Cc} = $CustomerElementCc;
                }

                # check email address
                my $CustomerErrorMsgCc = 'CustomerGenericServerErrorMsg';
                my $CustomerErrorCc    = '';
                for my $Email ( Mail::Address->parse($CustomerElementCc) ) {
                    if ( !$CheckItemObject->CheckEmail( Address => $Email->address() ) ) {
                        $CustomerErrorMsgCc = $CheckItemObject->CheckErrorType()
                            . 'ServerErrorMsg';
                        $CustomerErrorCc = 'ServerError';
                    }
                }

                # check for duplicated entries
                if ( defined $AddressesList{$CustomerElementCc} && $CustomerErrorCc eq '' ) {
                    $CustomerErrorMsgCc = 'IsDuplicatedServerErrorMsg';
                    $CustomerErrorCc    = 'ServerError';
                }

                my $CustomerDisabledCc = '';
                my $CountAuxCc         = $CustomerCounterCc++;
                if ( $CustomerErrorCc ne '' ) {
                    $CustomerDisabledCc = 'disabled="disabled"';
                    $CountAuxCc         = $Count . 'Error';
                }

                if ( $CustomerQueueCc ne '' ) {
                    $CustomerQueueCc = $Count;
                }

                push @MultipleCustomerCc, {
                    Count            => $CountAuxCc,
                    CustomerElement  => $CustomerElementCc,
                    CustomerKey      => $CustomerKeyCc,
                    CustomerError    => $CustomerErrorCc,
                    CustomerErrorMsg => $CustomerErrorMsgCc,
                    CustomerDisabled => $CustomerDisabledCc,
                    CustomerQueue    => $CustomerQueueCc,
                };
                $AddressesList{$CustomerElementCc} = 1;
            }
        }
    }

    my @MultipleCustomerBcc;
    my $CustomersNumberBcc = $ParamObject->GetParam( Param => 'CustomerTicketCounterBccCustomer' ) || 0;

    if ($CustomersNumberBcc) {
        my $CustomerCounterBcc = 1;
        for my $Count ( 1 ... $CustomersNumberBcc ) {
            my $CustomerElementBcc = $ParamObject->GetParam( Param => 'BccCustomerTicketText_' . $Count );
            my $CustomerKeyBcc     = $ParamObject->GetParam( Param => 'BccCustomerKey_' . $Count )
                || '';
            my $CustomerQueueBcc = $ParamObject->GetParam( Param => 'BccCustomerQueue_' . $Count )
                || '';

            if ($CustomerElementBcc) {

                if ( $GetParam{Bcc} ) {
                    $GetParam{Bcc} .= ', ' . $CustomerElementBcc;
                }
                else {
                    $GetParam{Bcc} = $CustomerElementBcc;
                }

                # Check email address.
                my $CustomerErrorMsgBcc = 'CustomerGenericServerErrorMsg';
                my $CustomerErrorBcc    = '';
                for my $Email ( Mail::Address->parse($CustomerElementBcc) ) {
                    if ( !$CheckItemObject->CheckEmail( Address => $Email->address() ) ) {
                        $CustomerErrorMsgBcc = $CheckItemObject->CheckErrorType()
                            . 'ServerErrorMsg';
                        $CustomerErrorBcc = 'ServerError';
                    }
                }

                # Check for duplicated entries.
                if ( defined $AddressesList{$CustomerElementBcc} && $CustomerErrorBcc eq '' ) {
                    $CustomerErrorMsgBcc = 'IsDuplicatedServerErrorMsg';
                    $CustomerErrorBcc    = 'ServerError';
                }

                my $CustomerDisabledBcc = '';
                my $CountAuxBcc         = $CustomerCounterBcc++;
                if ( $CustomerErrorBcc ne '' ) {
                    $CustomerDisabledBcc = 'disabled="disabled"';
                    $CountAuxBcc         = $Count . 'Error';
                }

                if ( $CustomerQueueBcc ne '' ) {
                    $CustomerQueueBcc = $Count;
                }

                push @MultipleCustomerBcc, {
                    Count            => $CountAuxBcc,
                    CustomerElement  => $CustomerElementBcc,
                    CustomerKey      => $CustomerKeyBcc,
                    CustomerError    => $CustomerErrorBcc,
                    CustomerErrorMsg => $CustomerErrorMsgBcc,
                    CustomerDisabled => $CustomerDisabledBcc,
                    CustomerQueue    => $CustomerQueueBcc,
                };
                $AddressesList{$CustomerElementBcc} = 1;
            }
        }
    }

    my $UploadCacheObject = $Kernel::OM->Get('Kernel::System::Web::UploadCache');
    my $MainObject        = $Kernel::OM->Get('Kernel::System::Main');

    # Send email.
    if ( $Self->{Subaction} eq 'SendEmail' ) {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        my %Error;

        my $CheckItemObject = $Kernel::OM->Get('Kernel::System::CheckItem');

        # Check some values.
        LINE:
        for my $Line (qw(To Cc Bcc)) {
            next LINE if !$GetParam{$Line};
            for my $Email ( Mail::Address->parse( $GetParam{$Line} ) ) {
                if ( !$CheckItemObject->CheckEmail( Address => $Email->address() ) ) {
                    $Error{ $Line . 'ErrorType' } = $Line . $CheckItemObject->CheckErrorType() . 'ServerErrorMsg';
                    $Error{ $Line . 'Invalid' }   = 'ServerError';
                }
                my $IsLocal = $Kernel::OM->Get('Kernel::System::SystemAddress')->SystemAddressIsLocalAddress(
                    Address => $Email->address()
                );
                if ($IsLocal) {
                    $Error{ $Line . 'IsLocalAddress' } = 'ServerError';
                }
            }
        }

        if ( $Error{ToIsLocalAddress} ) {
            $LayoutObject->Block(
                Name => 'ToIsLocalAddressServerErrorMsg',
                Data => \%GetParam,
            );
        }

        if ( $Error{CcIsLocalAddress} ) {
            $LayoutObject->Block(
                Name => 'CcIsLocalAddressServerErrorMsg',
                Data => \%GetParam,
            );
        }

        if ( $Error{BccIsLocalAddress} ) {
            $LayoutObject->Block(
                Name => 'BccIsLocalAddressServerErrorMsg',
                Data => \%GetParam,
            );
        }

        # Get all attachments meta data.
        my @Attachments = $UploadCacheObject->FormIDGetAllFilesMeta(
            FormID => $Self->{FormID},
        );

        # Check some values.
        LINE:
        for my $Line (qw(To Cc Bcc)) {
            next LINE if !$GetParam{$Line};
            for my $Email ( Mail::Address->parse( $GetParam{$Line} ) ) {
                if ( !$CheckItemObject->CheckEmail( Address => $Email->address() ) ) {
                    $Error{ $Line . 'Invalid' } = 'ServerError';
                }
            }
        }

        # Check subject.
        if ( !$GetParam{Subject} ) {
            $Error{SubjectInvalid} = ' ServerError';
        }

        # Check body.
        if ( !$GetParam{Body} ) {
            $Error{BodyInvalid} = ' ServerError';
        }

        # Check time units.
        if (
            $ConfigObject->Get('Ticket::Frontend::AccountTime')
            && $ConfigObject->Get('Ticket::Frontend::NeedAccountedTime')
            && $GetParam{TimeUnits} eq ''
            )
        {
            $Error{TimeUnitsInvalid} = 'ServerError';
        }

        # Prepare subject.
        my $Tn = $TicketObject->TicketNumberLookup( TicketID => $Self->{TicketID} );
        $GetParam{Subject} = $TicketObject->TicketSubjectBuild(
            TicketNumber => $Tn,
            Subject      => $GetParam{Subject} || '',
        );

        my %ArticleParam;

        # Run compose modules.
        if ( ref $ConfigObject->Get('Ticket::Frontend::ArticleComposeModule') eq 'HASH' ) {

            # Use ticket QueueID in compose modules.
            $GetParam{QueueID} = $Ticket{QueueID};

            my %Jobs = %{ $ConfigObject->Get('Ticket::Frontend::ArticleComposeModule') };
            for my $Job ( sort keys %Jobs ) {

                # load module
                if ( !$MainObject->Require( $Jobs{$Job}->{Module} ) ) {
                    return $LayoutObject->FatalError();
                }
                my $Object = $Jobs{$Job}->{Module}->new( %{$Self}, Debug => $Self->{Debug} );

                my $Multiple;

                # get params
                PARAMETER:
                for my $Parameter ( $Object->Option( %GetParam, Config => $Jobs{$Job} ) ) {
                    if ( $Jobs{$Job}->{ParamType} && $Jobs{$Job}->{ParamType} ne 'Single' ) {
                        @{ $GetParam{$Parameter} } = $ParamObject->GetArray( Param => $Parameter );
                        $Multiple = 1;
                        next PARAMETER;
                    }

                    $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter );
                }

                # Run module.
                $Object->Run(
                    %GetParam,
                    StoreNew => 1,
                    Config   => $Jobs{$Job},
                );

                # Get options that have been removed from the selection and add them back to the selection so that the
                #   submit will contain options that were hidden from the agent.
                my $Key = $Object->Option( %GetParam, Config => $Jobs{$Job} );

                if ( $Object->can('GetOptionsToRemoveAJAX') ) {
                    my @RemovedOptions = $Object->GetOptionsToRemoveAJAX(%GetParam);
                    if (@RemovedOptions) {
                        if ($Multiple) {
                            for my $RemovedOption (@RemovedOptions) {
                                push @{ $GetParam{$Key} }, $RemovedOption;
                            }
                        }
                        else {
                            $GetParam{$Key} = shift @RemovedOptions;
                        }
                    }
                }

                # Ticket params.
                %ArticleParam = (
                    %ArticleParam,
                    $Object->ArticleOption( %GetParam, %ArticleParam, Config => $Jobs{$Job} ),
                );

                # Get errors.
                %Error = (
                    %Error,
                    $Object->Error( %GetParam, Config => $Jobs{$Job} ),
                );
            }
        }

        # Check if there is an error.
        if (%Error) {

            my $Output = $LayoutObject->Header(
                Value     => $Ticket{TicketNumber},
                Type      => 'Small',
                BodyClass => 'Popup',
            );
            $GetParam{StandardResponse} = $GetParam{Body};
            $Output .= $Self->_Mask(
                TicketID            => $Self->{TicketID},
                Errors              => \%Error,
                MultipleCustomer    => \@MultipleCustomer,
                MultipleCustomerCc  => \@MultipleCustomerCc,
                MultipleCustomerBcc => \@MultipleCustomerBcc,
                Attachments         => \@Attachments,
                GetParam            => \%GetParam,
                TicketBackType      => $TicketBackType,
                %Ticket,
                %GetParam,
            );
            $Output .= $LayoutObject->Footer(
                Type => 'Small',
            );
            return $Output;
        }

        # Get pre-loaded attachments.
        my @AttachmentData = $UploadCacheObject->FormIDGetAllFilesData(
            FormID => $Self->{FormID},
        );

        # Get submit attachment.
        my %UploadStuff = $ParamObject->GetUploadAll(
            Param => 'FileUpload',
        );
        if (%UploadStuff) {
            push @AttachmentData, \%UploadStuff;
        }

        # Get recipients.
        my $Recipients = '';
        LINE:
        for my $Line (qw(To Cc Bcc)) {

            next LINE if !$GetParam{$Line};

            if ($Recipients) {
                $Recipients .= ', ';
            }
            $Recipients .= $GetParam{$Line};
        }

        my $MimeType = 'text/plain';
        if ( $LayoutObject->{BrowserRichText} ) {
            $MimeType = 'text/html';

            # Remove unused inline images.
            my @NewAttachmentData;
            ATTACHMENT:
            for my $Attachment (@AttachmentData) {
                my $ContentID = $Attachment->{ContentID};
                if (
                    $ContentID
                    && ( $Attachment->{ContentType} =~ /image/i )
                    && ( $Attachment->{Disposition} eq 'inline' )
                    )
                {
                    my $ContentIDHTMLQuote = $LayoutObject->Ascii2Html(
                        Text => $ContentID,
                    );

                    # Workaround for link encode of rich text editor, see bug#5053.
                    my $ContentIDLinkEncode = $LayoutObject->LinkEncode($ContentID);
                    $GetParam{Body} =~ s/(ContentID=)$ContentIDLinkEncode/$1$ContentID/g;

                    # Ignore attachment if not linked in body.
                    next ATTACHMENT
                        if $GetParam{Body} !~ /(\Q$ContentIDHTMLQuote\E|\Q$ContentID\E)/i;
                }

                # Remember inline images and normal attachments.
                push @NewAttachmentData, \%{$Attachment};
            }
            @AttachmentData = @NewAttachmentData;

            # Verify HTML document.
            $GetParam{Body} = $LayoutObject->RichTextDocumentComplete(
                String => $GetParam{Body},
            );
        }

        my $IsVisibleForCustomer = $Config->{IsVisibleForCustomerDefault};
        if ( $GetParam{IsVisibleForCustomerPresent} ) {
            $IsVisibleForCustomer = $GetParam{IsVisibleForCustomer} ? 1 : 0;
        }

        # Send email.
        my $ArticleID = $ArticleBackendObject->ArticleSend(
            IsVisibleForCustomer => $IsVisibleForCustomer,
            SenderType           => 'agent',
            TicketID             => $Self->{TicketID},
            HistoryType          => 'EmailResend',
            HistoryComment       => "\%\%$Recipients",
            From                 => $GetParam{From},
            To                   => $GetParam{To},
            Cc                   => $GetParam{Cc},
            Bcc                  => $GetParam{Bcc},
            Subject              => $GetParam{Subject},
            UserID               => $Self->{UserID},
            Body                 => $GetParam{Body},
            InReplyTo            => $GetParam{InReplyTo},
            References           => $GetParam{References},
            Charset              => $LayoutObject->{UserCharset},
            MimeType             => $MimeType,
            Attachment           => \@AttachmentData,
            %ArticleParam,
        );

        # Error page.
        if ( !$ArticleID ) {
            return $LayoutObject->ErrorScreen();
        }

        # Time accounting.
        if ( $GetParam{TimeUnits} ) {
            $TicketObject->TicketAccountTime(
                TicketID  => $Self->{TicketID},
                ArticleID => $ArticleID,
                TimeUnit  => $GetParam{TimeUnits},
                UserID    => $Self->{UserID},
            );
        }

        # Remove pre-submitted attachments.
        $UploadCacheObject->FormIDRemove( FormID => $GetParam{FormID} );

        # Load new URL in parent window and close popup.
        return $LayoutObject->PopupClose(
            URL => "Action=AgentTicketZoom;TicketID=$Self->{TicketID};ArticleID=$ArticleID",
        );
    }

    # Check for SMIME / PGP if customer has changed.
    elsif ( $Self->{Subaction} eq 'AJAXUpdate' ) {

        my @ExtendedData;

        # Run compose modules.
        if ( ref $ConfigObject->Get('Ticket::Frontend::ArticleComposeModule') eq 'HASH' ) {

            # Use ticket QueueID in compose modules.
            $GetParam{QueueID} = $Ticket{QueueID};

            my %Jobs = %{ $ConfigObject->Get('Ticket::Frontend::ArticleComposeModule') };
            JOB:
            for my $Job ( sort keys %Jobs ) {

                # Load module.
                next JOB if !$MainObject->Require( $Jobs{$Job}->{Module} );

                my $Object = $Jobs{$Job}->{Module}->new(
                    %{$Self},
                    Debug => $Self->{Debug},
                );

                my $Multiple;

                PARAMETER:
                for my $Parameter ( $Object->Option( %GetParam, Config => $Jobs{$Job} ) ) {
                    if ( $Jobs{$Job}->{ParamType} && $Jobs{$Job}->{ParamType} ne 'Single' ) {
                        @{ $GetParam{$Parameter} } = $ParamObject->GetArray( Param => $Parameter );
                        $Multiple = 1;
                        next PARAMETER;
                    }

                    $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter );
                }

                # Run module.
                my %Data = $Object->Data( %GetParam, Config => $Jobs{$Job} );

                # Get AJAX param values.
                if ( $Object->can('GetParamAJAX') ) {
                    %GetParam = ( %GetParam, $Object->GetParamAJAX(%GetParam) );
                }

                # Get options that have to be removed from the selection visible to the agent. These options will be
                #   added again on submit.
                if ( $Object->can('GetOptionsToRemoveAJAX') ) {
                    my @OptionsToRemove = $Object->GetOptionsToRemoveAJAX(%GetParam);

                    for my $OptionToRemove (@OptionsToRemove) {
                        delete $Data{$OptionToRemove};
                    }
                }

                my $Key = $Object->Option( %GetParam, Config => $Jobs{$Job} );
                if ($Key) {
                    push(
                        @ExtendedData,
                        {
                            Name         => $Key,
                            Data         => \%Data,
                            SelectedID   => $GetParam{$Key},
                            Translation  => 1,
                            PossibleNone => 1,
                            Multiple     => $Multiple,
                            Max          => 150,
                        }
                    );
                }
            }
        }

        my $JSON = $LayoutObject->BuildSelectionJSON(
            [
                @ExtendedData,
            ],
        );
        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }
    else {
        my $Output = $LayoutObject->Header(
            Value     => $Ticket{TicketNumber},
            Type      => 'Small',
            BodyClass => 'Popup',
        );

        # Get article data.
        my $ArticleBackendObject = $ArticleObject->BackendForArticle(
            TicketID  => $Self->{TicketID},
            ArticleID => $GetParam{ArticleID},
        );
        my %Data = $ArticleBackendObject->ArticleGet(
            TicketID  => $Self->{TicketID},
            ArticleID => $GetParam{ArticleID},
        );

        # Get article to quote.
        $Data{Body} = $LayoutObject->ArticleQuote(
            TicketID           => $Self->{TicketID},
            ArticleID          => $Data{ArticleID},
            FormID             => $Self->{FormID},
            UploadCacheObject  => $UploadCacheObject,
            AttachmentsInclude => 1,
        );

        # Get all attachments meta data.
        my @Attachments = $UploadCacheObject->FormIDGetAllFilesMeta(
            FormID => $Self->{FormID},
        );

        my $SystemAddress = $Kernel::OM->Get('Kernel::System::SystemAddress');

        # Get only email address in 'To' (just 'some@example.com').
        for my $Email ( Mail::Address->parse( $Data{To} ) ) {
            $Data{ToEmail} = $Email->address();
        }

        # Find duplicate addresses.
        my %Recipient;
        for my $Type (qw(To Cc Bcc)) {
            if ( $Data{$Type} ) {
                my $NewLine = '';
                for my $Email ( Mail::Address->parse( $Data{$Type} ) ) {
                    my $Address = lc $Email->address();

                    # Only use email addresses with '@' inside.
                    if ( $Address && $Address =~ /@/ && !$Recipient{$Address} ) {
                        $Recipient{$Address} = 1;
                        my $IsLocal = $SystemAddress->SystemAddressIsLocalAddress(
                            Address => $Address,
                        );
                        if ( !$IsLocal ) {
                            if ($NewLine) {
                                $NewLine .= ', ';
                            }
                            $NewLine .= $Email->format();
                        }
                    }
                }
                $Data{$Type} = $NewLine;
            }
        }

        # Check some values.
        my %Error;
        LINE:
        for my $Line (qw(To Cc Bcc)) {
            next LINE if !$Data{$Line};
            for my $Email ( Mail::Address->parse( $Data{$Line} ) ) {
                if ( !$CheckItemObject->CheckEmail( Address => $Email->address() ) ) {
                    $Error{ $Line . "Invalid" } = " ServerError";
                }
            }
        }
        if ( $Data{From} ) {
            for my $Email ( Mail::Address->parse( $Data{From} ) ) {
                if ( !$CheckItemObject->CheckEmail( Address => $Email->address() ) ) {
                    $Error{"FromInvalid"} .= $CheckItemObject->CheckError();
                }
            }
        }

        # Run compose modules.
        if ( ref $ConfigObject->Get('Ticket::Frontend::ArticleComposeModule') eq 'HASH' ) {

            # use ticket QueueID in compose modules
            $GetParam{QueueID} = $Ticket{QueueID};

            my %Jobs = %{ $ConfigObject->Get('Ticket::Frontend::ArticleComposeModule') };
            for my $Job ( sort keys %Jobs ) {

                # Load module.
                if ( !$MainObject->Require( $Jobs{$Job}->{Module} ) ) {
                    return $LayoutObject->FatalError();
                }
                my $Object = $Jobs{$Job}->{Module}->new( %{$Self}, Debug => $Self->{Debug} );

                PARAMETER:
                for my $Parameter ( $Object->Option( %GetParam, Config => $Jobs{$Job} ) ) {
                    if ( $Jobs{$Job}->{ParamType} && $Jobs{$Job}->{ParamType} ne 'Single' ) {
                        @{ $GetParam{$Parameter} } = $ParamObject->GetArray( Param => $Parameter );
                        next PARAMETER;
                    }

                    $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter );
                }

                # Run module.
                my $NewParams = $Object->Run( %GetParam, Config => $Jobs{$Job} );

                if ($NewParams) {
                    for my $Parameter ( $Object->Option( %GetParam, Config => $Jobs{$Job} ) ) {
                        $GetParam{$Parameter} = $NewParams;
                    }
                }

                # Get errors.
                %Error = (
                    %Error,
                    $Object->Error( %GetParam, Config => $Jobs{$Job} ),
                );
            }
        }

        # Build view.
        $Output .= $Self->_Mask(
            TicketID            => $Self->{TicketID},
            Attachments         => \@Attachments,
            Errors              => \%Error,
            MultipleCustomer    => \@MultipleCustomer,
            MultipleCustomerCc  => \@MultipleCustomerCc,
            MultipleCustomerBcc => \@MultipleCustomerBcc,
            GetParam            => \%GetParam,
            %Ticket,
            %Data,
            TicketBackType => $TicketBackType,
        );
        $Output .= $LayoutObject->Footer(
            Type => 'Small',
        );
        return $Output;
    }
}

sub _Mask {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $Config = $ConfigObject->Get("Ticket::Frontend::$Self->{Action}");

    my $IsVisibleForCustomer = $Param{IsVisibleForCustomer};
    if ( $Param{GetParam}->{IsVisibleForCustomerPresent} ) {
        $IsVisibleForCustomer = $Param{GetParam}->{IsVisibleForCustomer} ? 1 : 0;
    }

    $LayoutObject->Block(
        Name => 'IsVisibleForCustomer',
        Data => {
            IsVisibleForCustomer => $IsVisibleForCustomer,
        },
    );

    # Prepare errors for the output.
    if ( $Param{Errors} ) {
        for my $Error ( sort keys %{ $Param{Errors} } ) {
            $Param{$Error} = $LayoutObject->Ascii2Html(
                Text => $Param{Errors}->{$Error},
            );
        }
    }

    # Handle multiple autocomplete in recipient fields.
    $Param{To} = ( scalar @{ $Param{MultipleCustomer} } ? '' : $Param{To} );
    if ( defined $Param{To} && $Param{To} ne '' ) {
        $Param{ToInvalid} = '';
    }
    $Param{Cc} = ( scalar @{ $Param{MultipleCustomerCc} } ? '' : $Param{Cc} );
    if ( defined $Param{Cc} && $Param{Cc} ne '' ) {
        $Param{CcInvalid} = '';
    }
    $Param{Bcc} = ( scalar @{ $Param{MultipleCustomerBcc} } ? '' : $Param{Bcc} );
    if ( defined $Param{Bcc} && $Param{Bcc} ne '' ) {
        $Param{BccInvalid} = '';
    }

    # Process the 'Cc' field.
    my $CustomerCounterCc = 0;
    if ( $Param{MultipleCustomerCc} ) {
        for my $Item ( @{ $Param{MultipleCustomerCc} } ) {
            $LayoutObject->Block(
                Name => 'CcMultipleCustomer',
                Data => $Item,
            );
            $LayoutObject->Block(
                Name => 'Cc' . $Item->{CustomerErrorMsg},
                Data => $Item,
            );
            if ( $Item->{CustomerError} ) {
                $LayoutObject->Block(
                    Name => 'CcCustomerErrorExplantion',
                );
            }
            $CustomerCounterCc++;
        }
    }

    if ( !$CustomerCounterCc ) {
        $Param{CcCustomerHiddenContainer} = 'Hidden';
    }

    # Set customer counter.
    $LayoutObject->Block(
        Name => 'CcMultipleCustomerCounter',
        Data => {
            CustomerCounter => $CustomerCounterCc,
        },
    );

    # Process the 'Bcc' field.
    my $CustomerCounterBcc = 0;
    if ( $Param{MultipleCustomerBcc} ) {
        for my $Item ( @{ $Param{MultipleCustomerBcc} } ) {
            $LayoutObject->Block(
                Name => 'BccMultipleCustomer',
                Data => $Item,
            );
            $LayoutObject->Block(
                Name => 'Bcc' . $Item->{CustomerErrorMsg},
                Data => $Item,
            );
            if ( $Item->{CustomerError} ) {
                $LayoutObject->Block(
                    Name => 'BccCustomerErrorExplantion',
                );
            }
            $CustomerCounterBcc++;
        }
    }

    if ( !$CustomerCounterBcc ) {
        $Param{BccCustomerHiddenContainer} = 'Hidden';
    }

    # Set customer counter.
    $LayoutObject->Block(
        Name => 'BccMultipleCustomerCounter',
        Data => {
            CustomerCounter => $CustomerCounterBcc,
        },
    );

    # Process the 'To' field.
    my $CustomerCounter = 0;
    if ( $Param{MultipleCustomer} ) {
        for my $Item ( @{ $Param{MultipleCustomer} } ) {
            $LayoutObject->Block(
                Name => 'MultipleCustomer',
                Data => $Item,
            );
            $LayoutObject->Block(
                Name => $Item->{CustomerErrorMsg},
                Data => $Item,
            );
            if ( $Item->{CustomerError} ) {
                $LayoutObject->Block(
                    Name => 'CustomerErrorExplantion',
                );
            }
            $CustomerCounter++;
        }
    }

    if ( !$CustomerCounter ) {
        $Param{CustomerHiddenContainer} = 'Hidden';
    }

    # Set customer counter.
    $LayoutObject->Block(
        Name => 'MultipleCustomerCounter',
        Data => {
            CustomerCounter => $CustomerCounter,
        },
    );

    if ( $Param{ToInvalid} && $Param{Errors} ) {
        $LayoutObject->Block(
            Name => 'ToServerErrorMsg',
        );
    }

    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

    # Set preselected values for 'Bcc' field.
    if ( $Param{Bcc} && $Param{Bcc} ne '' && !$CustomerCounterBcc ) {

        # split Cc values
        my @EmailAddressesBcc;
        for my $Email ( Mail::Address->parse( $Param{Bcc} ) ) {

            my %CustomerSearch = $CustomerUserObject->CustomerSearch(
                PostMasterSearch => $Email->address(),
                Limit            => 1,
            );

            if (%CustomerSearch) {
                for my $CustomerUserID ( sort keys %CustomerSearch ) {
                    push @EmailAddressesBcc, {
                        CustomerKey        => $CustomerUserID,
                        CustomerTicketText => $CustomerSearch{$CustomerUserID},
                    };
                }
            }
            else {
                push @EmailAddressesBcc, {
                    CustomerKey        => '',
                    CustomerTicketText => $Email->[0] ? "$Email->[0] <$Email->[1]>" : "$Email->[1]",
                };
            }
        }

        $LayoutObject->AddJSData(
            Key   => 'EmailAddressesBcc',
            Value => \@EmailAddressesBcc,
        );

        $Param{Bcc} = '';
    }

    # set preselected values for Cc field
    if ( $Param{Cc} && $Param{Cc} ne '' && !$CustomerCounterCc ) {

        # split Cc values
        my @EmailAddressesCc;
        for my $Email ( Mail::Address->parse( $Param{Cc} ) ) {

            my %CustomerSearch = $CustomerUserObject->CustomerSearch(
                PostMasterSearch => $Email->address(),
                Limit            => 1,
            );

            if (%CustomerSearch) {
                for my $CustomerUserID ( sort keys %CustomerSearch ) {
                    push @EmailAddressesCc, {
                        CustomerKey        => $CustomerUserID,
                        CustomerTicketText => $CustomerSearch{$CustomerUserID},
                    };
                }
            }
            else {
                push @EmailAddressesCc, {
                    CustomerKey        => '',
                    CustomerTicketText => $Email->[0] ? "$Email->[0] <$Email->[1]>" : "$Email->[1]",
                };
            }
        }

        $LayoutObject->AddJSData(
            Key   => 'EmailAddressesCc',
            Value => \@EmailAddressesCc,
        );

        $Param{Cc} = '';
    }

    # set preselected values for To field
    if ( defined $Param{To} && $Param{To} ne '' && !$CustomerCounter ) {

        # split To values
        my @EmailAddressesTo;
        for my $Email ( Mail::Address->parse( $Param{To} ) ) {

            my %CustomerSearch = $CustomerUserObject->CustomerSearch(
                PostMasterSearch => $Email->address(),
                Limit            => 1,
            );

            if (%CustomerSearch) {
                for my $CustomerUserID ( sort keys %CustomerSearch ) {
                    push @EmailAddressesTo, {
                        CustomerKey        => $CustomerUserID,
                        CustomerTicketText => $CustomerSearch{$CustomerUserID},
                    };
                }
            }
            else {
                push @EmailAddressesTo, {
                    CustomerKey        => '',
                    CustomerTicketText => $Email->[0] ? "$Email->[0] <$Email->[1]>" : "$Email->[1]",
                };
            }
        }

        $LayoutObject->AddJSData(
            Key   => 'EmailAddressesTo',
            Value => \@EmailAddressesTo,
        );

        $Param{To} = '';
    }

    $LayoutObject->Block(
        Name => $Param{TicketBackType},
        Data => {
            %Param,
        },
    );

    # Show time accounting box.
    if ( $ConfigObject->Get('Ticket::Frontend::AccountTime') ) {
        if ( $ConfigObject->Get('Ticket::Frontend::NeedAccountedTime') ) {
            $LayoutObject->Block(
                Name => 'TimeUnitsLabelMandatory',
                Data => \%Param,
            );
            $Param{TimeUnitsRequired} = 'Validate_Required';
        }
        else {
            $LayoutObject->Block(
                Name => 'TimeUnitsLabel',
                Data => \%Param,
            );
            $Param{TimeUnitsRequired} = '';
        }
        $LayoutObject->Block(
            Name => 'TimeUnits',
            Data => \%Param,
        );
    }

    # Show the customer user address book if the module is registered and java script support is available.
    if (
        $ConfigObject->Get('Frontend::Module')->{AgentCustomerUserAddressBook}
        && $LayoutObject->{BrowserJavaScriptSupport}
        )
    {
        $Param{OptionCustomerUserAddressBook} = 1;
    }

    # Add rich text editor.
    if ( $LayoutObject->{BrowserRichText} ) {

        # Use height/width defined for this screen.
        $Param{RichTextHeight} = $Config->{RichTextHeight} || 0;
        $Param{RichTextWidth}  = $Config->{RichTextWidth}  || 0;

        # Set up rich text editor.
        $LayoutObject->SetRichTextParameters(
            Data => \%Param,
        );
    }

    # Show attachments.
    ATTACHMENT:
    for my $Attachment ( @{ $Param{Attachments} } ) {
        if (
            $Attachment->{ContentID}
            && $LayoutObject->{BrowserRichText}
            && ( $Attachment->{ContentType} =~ /image/i )
            && ( $Attachment->{Disposition} eq 'inline' )
            )
        {
            next ATTACHMENT;
        }

        push @{ $Param{AttachmentList} }, $Attachment;
    }

    # Create & return output.
    return $LayoutObject->Output(
        TemplateFile => 'AgentTicketEmailResend',
        Data         => {
            FormID => $Self->{FormID},
            %Param,
        },
    );
}

1;
