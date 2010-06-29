# --
# Kernel/Modules/AgentTicketEmail.pm - to compose initial email to customer
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: AgentTicketEmail.pm,v 1.132 2010-06-29 05:23:54 mp Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketEmail;

use strict;
use warnings;

use Kernel::System::SystemAddress;
use Kernel::System::CustomerUser;
use Kernel::System::CheckItem;
use Kernel::System::Web::UploadCache;
use Kernel::System::HTMLUtils;
use Kernel::System::TemplateGenerator;
use Kernel::System::State;
use Mail::Address;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.132 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    $Self->{Debug} = $Param{Debug} || 0;

    # check needed objects
    for (qw(ParamObject DBObject TicketObject LayoutObject LogObject QueueObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    # needed objects
    $Self->{SystemAddress}      = Kernel::System::SystemAddress->new(%Param);
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);
    $Self->{CheckItemObject}    = Kernel::System::CheckItem->new(%Param);
    $Self->{StateObject}        = Kernel::System::State->new(%Param);
    $Self->{UploadCacheObject}  = Kernel::System::Web::UploadCache->new(%Param);
    $Self->{HTMLUtilsObject}    = Kernel::System::HTMLUtils->new(%Param);

    # get form id
    $Self->{FormID} = $Self->{ParamObject}->GetParam( Param => 'FormID' );

    # create form id
    if ( !$Self->{FormID} ) {
        $Self->{FormID} = $Self->{UploadCacheObject}->FormIDCreate();
    }

    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output;

    # store last queue screen
    if ( $Self->{LastScreenOverview} !~ /Action=AgentTicketEmail/ ) {
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastScreenOverview',
            Value     => $Self->{RequestedURL},
        );
    }

    # get params
    my %GetParam;
    for my $Key (
        qw(Year Month Day Hour Minute To Cc Bcc TimeUnits PriorityID Subject Body
        TypeID ServiceID SLAID OwnerAll ResponsibleAll
        NewResponsibleID NewUserID
        NextStateID
        )
        )
    {
        $GetParam{$Key} = $Self->{ParamObject}->GetParam( Param => $Key );
    }

    # get ticket free text params
    for my $Count ( 1 .. 16 ) {
        my $Key  = 'TicketFreeKey' . $Count;
        my $Text = 'TicketFreeText' . $Count;
        $GetParam{$Key}  = $Self->{ParamObject}->GetParam( Param => $Key );
        $GetParam{$Text} = $Self->{ParamObject}->GetParam( Param => $Text );
    }

    # get ticket free time params
    for ( 1 .. 6 ) {
        for my $Type (qw(Used Year Month Day Hour Minute)) {
            $GetParam{ 'TicketFreeTime' . $_ . $Type } = $Self->{ParamObject}->GetParam(
                Param => 'TicketFreeTime' . $_ . $Type,
            );
        }
        $GetParam{ 'TicketFreeTime' . $_ . 'Optional' }
            = $Self->{ConfigObject}->Get( 'TicketFreeTimeOptional' . $_ ) || 0;
        if ( !$Self->{ConfigObject}->Get( 'TicketFreeTimeOptional' . $_ ) ) {
            $GetParam{ 'TicketFreeTime' . $_ . 'Used' } = 1;
        }

        if ( $Self->{Config}->{TicketFreeTime}->{$_} == 2 ) {
            $GetParam{ 'TicketFreeTime' . $_ . 'Required' } = 1;
        }
    }

    # get article free text params
    for my $Count ( 1 .. 3 ) {
        my $Key  = 'ArticleFreeKey' . $Count;
        my $Text = 'ArticleFreeText' . $Count;
        $GetParam{$Key}  = $Self->{ParamObject}->GetParam( Param => $Key );
        $GetParam{$Text} = $Self->{ParamObject}->GetParam( Param => $Text );
    }

    # transform pending time, time stamp based on user time zone
    if (
        defined $GetParam{Year}
        && defined $GetParam{Month}
        && defined $GetParam{Day}
        && defined $GetParam{Hour}
        && defined $GetParam{Minute}
        )
    {
        %GetParam = $Self->{LayoutObject}->TransfromDateSelection(
            %GetParam,
        );
    }

    # transform free time, time stamp based on user time zone
    for my $Count ( 1 .. 6 ) {
        my $Prefix = 'TicketFreeTime' . $Count;
        next if !defined $GetParam{ $Prefix . 'Year' };
        next if !defined $GetParam{ $Prefix . 'Month' };
        next if !defined $GetParam{ $Prefix . 'Day' };
        next if !defined $GetParam{ $Prefix . 'Hour' };
        next if !defined $GetParam{ $Prefix . 'Minute' };
        %GetParam = $Self->{LayoutObject}->TransfromDateSelection(
            %GetParam,
            Prefix => $Prefix
        );
    }

    if ( !$Self->{Subaction} || $Self->{Subaction} eq 'Created' ) {

        # header
        $Output .= $Self->{LayoutObject}->Header(
            Type => 'Small',
        );

        # if there is no ticket id!
        if ( !$Self->{TicketID} || ( $Self->{TicketID} && $Self->{Subaction} eq 'Created' ) ) {

            # notify info
            if ( $Self->{TicketID} ) {
                my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Self->{TicketID} );
                $Output .= $Self->{LayoutObject}->Notify(
                    Info => 'Ticket "%s" created!", "' . $Ticket{TicketNumber},
                    Link => '$Env{"Baselink"}Action=AgentTicketZoom;TicketID=' . $Ticket{TicketID},
                );
            }

            # get split article if given
            # get default selections
            my %TicketFreeDefault;
            for my $Count ( 1 .. 16 ) {
                my $Key  = 'TicketFreeKey' . $Count;
                my $Text = 'TicketFreeText' . $Count;
                $TicketFreeDefault{$Key} = $GetParam{$Key}
                    || $Self->{ConfigObject}->Get( $Key . '::DefaultSelection' );
                $TicketFreeDefault{$Text} = $GetParam{$Text}
                    || $Self->{ConfigObject}->Get( $Text . '::DefaultSelection' );
            }

            # get free text config options
            my %TicketFreeText;
            for my $Count ( 1 .. 16 ) {
                my $Key  = 'TicketFreeKey' . $Count;
                my $Text = 'TicketFreeText' . $Count;
                $TicketFreeText{$Key} = $Self->{TicketObject}->TicketFreeTextGet(
                    TicketID => $Self->{TicketID},
                    Type     => $Key,
                    Action   => $Self->{Action},
                    UserID   => $Self->{UserID},
                );
                $TicketFreeText{$Text} = $Self->{TicketObject}->TicketFreeTextGet(
                    TicketID => $Self->{TicketID},
                    Type     => $Text,
                    Action   => $Self->{Action},
                    UserID   => $Self->{UserID},
                );

                # If Key has value 2, this means that the freetextfield is required
                if ( $Self->{Config}->{TicketFreeText}->{$Count} == 2 ) {
                    $TicketFreeText{Required}->{$Count} = 1;
                }
            }
            my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
                Config => \%TicketFreeText,
                Ticket => {
                    %TicketFreeDefault,
                    $Self->{UserObject}->GetUserData(
                        UserID => $Self->{UserID},
                    ),
                },
            );

            # free time
            my %TicketFreeTimeHTML = $Self->{LayoutObject}->AgentFreeDate(
                %Param,
                Ticket => \%GetParam,
            );

            # get article free text default selections
            my %ArticleFreeDefault;
            for my $Count ( 1 .. 3 ) {
                my $Key  = 'ArticleFreeKey' . $Count;
                my $Text = 'ArticleFreeText' . $Count;
                $ArticleFreeDefault{$Key} = $GetParam{$Key}
                    || $Self->{ConfigObject}->Get( $Key . '::DefaultSelection' );
                $ArticleFreeDefault{$Text} = $GetParam{$Text}
                    || $Self->{ConfigObject}->Get( $Text . '::DefaultSelection' );
            }

            # article free text
            my %ArticleFreeText;
            for my $Count ( 1 .. 3 ) {
                my $Key  = 'ArticleFreeKey' . $Count;
                my $Text = 'ArticleFreeText' . $Count;
                $ArticleFreeText{$Key} = $Self->{TicketObject}->ArticleFreeTextGet(
                    TicketID => $Self->{TicketID},
                    Type     => $Key,
                    Action   => $Self->{Action},
                    UserID   => $Self->{UserID},
                );
                $ArticleFreeText{$Text} = $Self->{TicketObject}->ArticleFreeTextGet(
                    TicketID => $Self->{TicketID},
                    Type     => $Text,
                    Action   => $Self->{Action},
                    UserID   => $Self->{UserID},
                );
            }
            my %ArticleFreeTextHTML = $Self->{LayoutObject}->TicketArticleFreeText(
                Config => \%ArticleFreeText,
                Article => { %GetParam, %ArticleFreeDefault, },
            );

            # run compose modules
            if (
                ref $Self->{ConfigObject}->Get('Ticket::Frontend::ArticleComposeModule') eq
                'HASH'
                )
            {
                my %Jobs
                    = %{ $Self->{ConfigObject}->Get('Ticket::Frontend::ArticleComposeModule') };
                for my $Job ( sort keys %Jobs ) {

                    # load module
                    if ( !$Self->{MainObject}->Require( $Jobs{$Job}->{Module} ) ) {
                        return $Self->{LayoutObject}->FatalError();
                    }

                    my $Object = $Jobs{$Job}->{Module}->new( %{$Self}, Debug => $Self->{Debug}, );

                    # get params
                    my %GetParam;
                    for ( $Object->Option( %GetParam, Config => $Jobs{$Job} ) ) {
                        $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
                    }

                    # run module
                    $Object->Run( %GetParam, Config => $Jobs{$Job} );
                }
            }

            # get and format default subject and body
            my $Subject = $Self->{LayoutObject}->Output(
                Template => $Self->{Config}->{Subject} || '',
            );

            my $Body = $Self->{LayoutObject}->Output(
                Template => $Self->{Config}->{Body} || '',
            );

            # make sure body is rich text
            if ( $Self->{LayoutObject}->{BrowserRichText} ) {
                $Body = $Self->{LayoutObject}->Ascii2RichText(
                    String => $Body,
                );
            }

            # html output
            my $Services = $Self->_GetServices(
                QueueID => $Self->{QueueID} || 1,
            );
            my $SLAs = $Self->_GetSLAs(
                QueueID => $Self->{QueueID} || 1,
                Services => $Services,
                %GetParam,
            );
            $Output .= $Self->_MaskEmailNew(
                QueueID    => $Self->{QueueID},
                NextStates => $Self->_GetNextStates( QueueID => $Self->{QueueID} || 1 ),
                Priorities => $Self->_GetPriorities( QueueID => $Self->{QueueID} || 1 ),
                Types      => $Self->_GetTypes( QueueID => $Self->{QueueID} || 1 ),
                Services   => $Services,
                SLAs       => $SLAs,
                Users            => $Self->_GetUsers( QueueID => $Self->{QueueID} ),
                ResponsibleUsers => $Self->_GetUsers( QueueID => $Self->{QueueID} ),
                FromList => $Self->_GetTos( QueueID => $Self->{QueueID} ),
                To       => '',
                Subject  => $Subject,
                Body     => $Body,
                CustomerID        => '',
                CustomerUser      => '',
                CustomerData      => {},
                TimeUnitsRequired => (
                    $Self->{ConfigObject}->Get('Ticket::Frontend::NeedAccountedTime')
                    ? 'Validate_Required'
                    : ''
                ),
                %TicketFreeTextHTML,
                %TicketFreeTimeHTML,
                %ArticleFreeTextHTML,
            );
        }

        $Output .= $Self->{LayoutObject}->Footer(
            Type => 'Small',
        );
        return $Output;
    }

    # deliver signature
    elsif ( $Self->{Subaction} eq 'Signature' ) {
        my $QueueID = $Self->{ParamObject}->GetParam( Param => 'QueueID' );
        if ( !$QueueID ) {
            my $Dest = $Self->{ParamObject}->GetParam( Param => 'Dest' ) || '';
            ($QueueID) = split( /\|\|/, $Dest );
        }
        my $Signature = $Self->_GetSignature( QueueID => $QueueID || 1 );
        my $MimeType = 'text/plain';
        if ( $Self->{LayoutObject}->{BrowserRichText} ) {
            $MimeType  = 'text/html';
            $Signature = $Self->{LayoutObject}->RichTextDocumentComplete(
                String => $Signature,
            );
        }

        return $Self->{LayoutObject}->Attachment(
            ContentType => $MimeType . '; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $Signature,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # create new ticket and article
    elsif ( $Self->{Subaction} eq 'StoreNew' ) {

        my %Error;
        my $NextStateID = $Self->{ParamObject}->GetParam( Param => 'NextStateID' ) || '';
        my %StateData;
        if ($NextStateID) {
            %StateData = $Self->{TicketObject}->{StateObject}->StateGet( ID => $NextStateID, );
        }
        my $NextState        = $StateData{Name};
        my $NewResponsibleID = $Self->{ParamObject}->GetParam( Param => 'NewResponsibleID' ) || '';
        my $NewUserID        = $Self->{ParamObject}->GetParam( Param => 'NewUserID' ) || '';
        my $Dest             = $Self->{ParamObject}->GetParam( Param => 'Dest' ) || '';
        my ( $NewQueueID, $From ) = split( /\|\|/, $Dest );
        if ( !$NewQueueID ) {
            $GetParam{OwnerAll} = 1;
        }

        # get sender queue from
        my %Queue;
        my $Signature = '';
        if ($NewQueueID) {
            $Signature = $Self->_GetSignature( QueueID => $NewQueueID );
            %Queue = $Self->{QueueObject}->GetSystemAddress( QueueID => $NewQueueID );
        }
        my $CustomerUser = $Self->{ParamObject}->GetParam( Param => 'CustomerUser' )
            || $Self->{ParamObject}->GetParam( Param => 'PreSelectedCustomerUser' )
            || $Self->{ParamObject}->GetParam( Param => 'SelectedCustomerUser' )
            || '';
        my $CustomerID = $Self->{ParamObject}->GetParam( Param => 'CustomerID' ) || '';
        my $SelectedCustomerUser = $Self->{ParamObject}->GetParam( Param => 'SelectedCustomerUser' )
            || '';
        my $ExpandCustomerName = $Self->{ParamObject}->GetParam( Param => 'ExpandCustomerName' )
            || 0;
        $GetParam{From}               = $Queue{Email};
        $GetParam{QueueID}            = $NewQueueID;
        $GetParam{ExpandCustomerName} = $ExpandCustomerName;

        if ( $Self->{ParamObject}->GetParam( Param => 'OwnerAllRefresh' ) ) {
            $GetParam{OwnerAll} = 1;
            $ExpandCustomerName = 3;
        }
        if ( $Self->{ParamObject}->GetParam( Param => 'ResponsibleAllRefresh' ) ) {
            $GetParam{ResponsibleAll} = 1;
            $ExpandCustomerName = 3;
        }
        if ( $Self->{ParamObject}->GetParam( Param => 'ClearTo' ) ) {
            $GetParam{To} = '';
            $ExpandCustomerName = 3;
        }
        for ( 1 .. 2 ) {
            my $Item = $Self->{ParamObject}->GetParam( Param => "ExpandCustomerName$_" ) || 0;
            if ( $_ == 1 && $Item ) {
                $ExpandCustomerName = 1;
            }
            elsif ( $_ == 2 && $Item ) {
                $ExpandCustomerName = 2;
            }
        }

        # get free text config options
        my %TicketFreeText;
        for my $Count ( 1 .. 16 ) {
            my $Key  = 'TicketFreeKey' . $Count;
            my $Text = 'TicketFreeText' . $Count;
            $TicketFreeText{$Key} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID => $Self->{TicketID},
                Type     => $Key,
                Action   => $Self->{Action},
                QueueID  => $NewQueueID || 0,
                UserID   => $Self->{UserID},
            );
            $TicketFreeText{$Text} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID => $Self->{TicketID},
                Type     => $Text,
                Action   => $Self->{Action},
                QueueID  => $NewQueueID || 0,
                UserID   => $Self->{UserID},
            );

            # check required FreeTextField (if configured)
            if (
                $Self->{Config}->{TicketFreeText}->{$Count} == 2
                && $GetParam{"TicketFreeText$Count"} eq ''
                && $ExpandCustomerName == 0
                )
            {
                $Error{"TicketFreeTextField$Count invalid"} = 'invalid';
            }
        }
        my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
            Config => \%TicketFreeText,
            Ticket => \%GetParam,
        );

        # free time
        my %TicketFreeTimeHTML = $Self->{LayoutObject}->AgentFreeDate( Ticket => \%GetParam, );

        # article free text
        my %ArticleFreeText;
        for my $Count ( 1 .. 3 ) {
            my $Key  = 'ArticleFreeKey' . $Count;
            my $Text = 'ArticleFreeText' . $Count;
            $ArticleFreeText{$Key} = $Self->{TicketObject}->ArticleFreeTextGet(
                TicketID => $Self->{TicketID},
                Type     => $Key,
                Action   => $Self->{Action},
                UserID   => $Self->{UserID},
            );
            $ArticleFreeText{$Text} = $Self->{TicketObject}->ArticleFreeTextGet(
                TicketID => $Self->{TicketID},
                Type     => $Text,
                Action   => $Self->{Action},
                UserID   => $Self->{UserID},
            );
        }
        my %ArticleFreeTextHTML = $Self->{LayoutObject}->TicketArticleFreeText(
            Config  => \%ArticleFreeText,
            Article => \%GetParam,
        );

        # attachment delete
        for my $Count ( 1 .. 32 ) {
            my $Delete = $Self->{ParamObject}->GetParam( Param => "AttachmentDelete$Count" );
            next if !$Delete;
            $Error{AttachmentDelete} = 1;
            $Self->{UploadCacheObject}->FormIDRemoveFile(
                FormID => $Self->{FormID},
                FileID => $Count,
            );
        }

        # attachment upload
        if ( $Self->{ParamObject}->GetParam( Param => 'AttachmentUpload' ) ) {
            $Error{AttachmentUpload} = 1;
            my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
                Param  => 'FileUpload',
                Source => 'string',
            );
            $Self->{UploadCacheObject}->FormIDAddFile(
                FormID => $Self->{FormID},
                %UploadStuff,
            );
        }

        # get all attachments meta data
        my @Attachments = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
            FormID => $Self->{FormID},
        );

        # Expand Customer Name
        my %CustomerUserData;
        if ( $ExpandCustomerName == 1 ) {

            # search customer
            my %CustomerUserList;
            %CustomerUserList = $Self->{CustomerUserObject}->CustomerSearch(
                Search => $GetParam{To},
            );

            # check if just one customer user exists
            # if just one, fillup CustomerUserID and CustomerID
            $Param{CustomerUserListCount} = 0;
            for ( keys %CustomerUserList ) {
                $Param{CustomerUserListCount}++;
                $Param{CustomerUserListLast}     = $CustomerUserList{$_};
                $Param{CustomerUserListLastUser} = $_;
            }
            if ( $Param{CustomerUserListCount} == 1 ) {
                $GetParam{To}              = $Param{CustomerUserListLast};
                $Error{ExpandCustomerName} = 1;
                my %CustomerUserData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                    User => $Param{CustomerUserListLastUser},
                );
                if ( $CustomerUserData{UserCustomerID} ) {
                    $CustomerID = $CustomerUserData{UserCustomerID};
                }
                if ( $CustomerUserData{UserLogin} ) {
                    $CustomerUser = $CustomerUserData{UserLogin};
                }
            }

            # if more the one customer user exists, show list
            # and clean CustomerUserID and CustomerID
            else {

                # don't check email syntax on multi customer select
                $Self->{ConfigObject}->Set( Key => 'CheckEmailAddresses', Value => 0 );
                $CustomerID = '';
                $Param{ToOptions} = \%CustomerUserList;

                # clear to if there is no customer found
                if ( !%CustomerUserList ) {
                    $GetParam{To} = '';
                }
                $Error{ExpandCustomerName} = 1;
            }
        }

        # get from and customer id if customer user is given
        elsif ( $ExpandCustomerName == 2 ) {
            %CustomerUserData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                User => $CustomerUser,
            );
            my %CustomerUserList = $Self->{CustomerUserObject}->CustomerSearch(
                UserLogin => $CustomerUser,
            );
            for ( keys %CustomerUserList ) {
                $GetParam{To} = $CustomerUserList{$_};
            }
            if ( $CustomerUserData{UserCustomerID} ) {
                $CustomerID = $CustomerUserData{UserCustomerID};
            }
            if ( $CustomerUserData{UserLogin} ) {
                $CustomerUser = $CustomerUserData{UserLogin};
            }
            $Error{ExpandCustomerName} = 1;
        }

        # if a new destination queue is selected
        elsif ( $ExpandCustomerName == 3 ) {
            $Error{NoSubmit} = 1;
            $CustomerUser = $SelectedCustomerUser;
        }

        # show customer info
        my %CustomerData;
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoCompose') ) {
            if ($CustomerUser) {
                %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                    User => $CustomerUser,
                );
            }
            elsif ($CustomerID) {
                %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                    CustomerID => $CustomerID,
                );
            }
        }

        # check some values
        for my $Line (qw(To Cc Bcc)) {
            next if !$GetParam{$Line};
            for my $Email ( Mail::Address->parse( $GetParam{$Line} ) ) {
                if ( !$Self->{CheckItemObject}->CheckEmail( Address => $Email->address() ) ) {
                    $Error{ "$Line" . "Invalid" } = ' ServerError';
                }
                my $IsLocal = $Self->{SystemAddress}->SystemAddressIsLocalAddress(
                    Address => $Email->address()
                );
                if ($IsLocal) {
                    $Error{ "$Line" . "Invalid" } = ' ServerError';
                }
            }
        }
        if ( !$GetParam{To} && $ExpandCustomerName != 1 && $ExpandCustomerName == 0 ) {
            $Error{'ToInvalid'} = ' ServerError';
        }
        if ( !$GetParam{Subject} && $ExpandCustomerName == 0 ) {
            $Error{'SubjectInvalid'} = ' ServerError';
        }
        if ( !$NewQueueID && $ExpandCustomerName == 0 ) {

            $Error{'DestinationInvalid'} = ' ServerError';
        }
        else {
            $Error{'DestinationInvalid'} = ' ';
        }

        # check if date is valid
        if ( $StateData{TypeName} && $StateData{TypeName} =~ /^pending/i ) {
            if ( !$Self->{TimeObject}->Date2SystemTime( %GetParam, Second => 0 ) ) {
                $Error{'DateInvalid'} = ' ServerError';
            }
            if (
                $Self->{TimeObject}->Date2SystemTime( %GetParam, Second => 0 )
                < $Self->{TimeObject}->SystemTime()
                )
            {
                $Error{'DateInvalid'} = ' ServerError';
            }
            else {
                $Error{'DateInvalid'} = '';
            }
        }
        if (
            $Self->{ConfigObject}->Get('Ticket::Service')
            && $GetParam{SLAID}
            && !$GetParam{ServiceID}
            )
        {
            $Error{'ServiceInvalid'} = 'ServerError';
        }
        else {
            $Error{'ServiceInvalid'} = '';
        }

        # run compose modules
        my %ArticleParam;
        if ( ref $Self->{ConfigObject}->Get('Ticket::Frontend::ArticleComposeModule') eq 'HASH' ) {
            my %Jobs = %{ $Self->{ConfigObject}->Get('Ticket::Frontend::ArticleComposeModule') };
            for my $Job ( sort keys %Jobs ) {

                # load module
                if ( !$Self->{MainObject}->Require( $Jobs{$Job}->{Module} ) ) {
                    return $Self->{LayoutObject}->FatalError();
                }

                my $Object = $Jobs{$Job}->{Module}->new( %{$Self}, Debug => $Self->{Debug}, );

                # get params
                for ( $Object->Option( %GetParam, Config => $Jobs{$Job} ) ) {
                    $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
                }

                # run module
                $Object->Run( %GetParam, Config => $Jobs{$Job} );

                # ticket params
                %ArticleParam = (
                    %ArticleParam,
                    $Object->ArticleOption( %GetParam, Config => $Jobs{$Job} ),
                );

                # get errors
                %Error = (
                    %Error,
                    $Object->Error( %GetParam, Config => $Jobs{$Job} ),
                );
            }
        }

        if (%Error) {

            # get services
            my $Services = $Self->_GetServices(
                %GetParam,
                CustomerUserID => $CustomerUser || '',
                QueueID        => $NewQueueID   || 1,
            );
            my $SLAs = $Self->_GetSLAs(
                QueueID => $NewQueueID || 1,
                Services => $Services,
                %GetParam,
            );

            # reset previous ServiceID to reset SLA-List if no service is selected
            if ( !$GetParam{ServiceID} || !$Services->{ $GetParam{ServiceID} } ) {
                $GetParam{ServiceID} = '';
            }

            # header
            $Output .= $Self->{LayoutObject}->Header(
                Type => 'Small',
            );

            # html output
            $Output .= $Self->_MaskEmailNew(
                QueueID => $Self->{QueueID},
                Users   => $Self->_GetUsers(
                    QueueID  => $NewQueueID,
                    AllUsers => $GetParam{OwnerAll}
                ),
                UserSelected     => $NewUserID,
                ResponsibleUsers => $Self->_GetUsers(
                    QueueID  => $NewQueueID,
                    AllUsers => $GetParam{ResponsibleAll}
                ),
                ResponsibleUsersSelected => $NewResponsibleID,
                NextStates               => $Self->_GetNextStates(
                    %GetParam,
                    CustomerUserID => $CustomerUser || '',
                    QueueID        => $NewQueueID   || 1,
                ),
                NextState  => $NextState,
                Priorities => $Self->_GetPriorities(
                    %GetParam,
                    CustomerUserID => $CustomerUser || '',
                    QueueID        => $NewQueueID   || 1,
                ),
                Types => $Self->_GetTypes(
                    %GetParam,
                    CustomerUserID => $CustomerUser || '',
                    QueueID        => $NewQueueID   || 1,
                ),
                Services          => $Services,
                SLAs              => $SLAs,
                CustomerID        => $Self->{LayoutObject}->Ascii2Html( Text => $CustomerID ),
                CustomerUser      => $CustomerUser,
                CustomerData      => \%CustomerData,
                TimeUnitsRequired => (
                    $Self->{ConfigObject}->Get('Ticket::Frontend::NeedAccountedTime')
                    ? 'Validate_Required'
                    : ''
                ),
                FromList     => $Self->_GetTos(),
                FromSelected => $Dest,
                ToOptions    => $Param{ToOptions},
                Subject      => $Self->{LayoutObject}->Ascii2Html( Text => $GetParam{Subject} ),
                Body         => $Self->{LayoutObject}->Ascii2Html( Text => $GetParam{Body} ),
                Errors       => \%Error,
                Attachments  => \@Attachments,
                Signature    => $Signature,
                %GetParam,
                %TicketFreeTextHTML,
                %TicketFreeTimeHTML,
                %ArticleFreeTextHTML,
            );

            $Output .= $Self->{LayoutObject}->Footer(
                Type => 'Small',
            );
            return $Output;
        }

        # create new ticket, do db insert
        my $TicketID = $Self->{TicketObject}->TicketCreate(
            Title        => $GetParam{Subject},
            QueueID      => $NewQueueID,
            Subject      => $GetParam{Subject},
            Lock         => 'unlock',
            TypeID       => $GetParam{TypeID},
            ServiceID    => $GetParam{ServiceID},
            SLAID        => $GetParam{SLAID},
            StateID      => $NextStateID,
            PriorityID   => $GetParam{PriorityID},
            OwnerID      => 1,
            CustomerID   => $CustomerID,
            CustomerUser => $SelectedCustomerUser,
            UserID       => $Self->{UserID},
        );

        # set ticket free text
        for my $Count ( 1 .. 16 ) {
            my $Key  = 'TicketFreeKey' . $Count;
            my $Text = 'TicketFreeText' . $Count;
            if ( defined $GetParam{$Key} ) {
                $Self->{TicketObject}->TicketFreeTextSet(
                    TicketID => $TicketID,
                    Key      => $GetParam{$Key},
                    Value    => $GetParam{$Text},
                    Counter  => $Count,
                    UserID   => $Self->{UserID},
                );
            }
        }

        # set ticket free time
        for my $Count ( 1 .. 6 ) {
            my $Prefix = 'TicketFreeTime' . $Count;
            next if !defined $GetParam{ $Prefix . 'Year' };
            next if !defined $GetParam{ $Prefix . 'Month' };
            next if !defined $GetParam{ $Prefix . 'Day' };
            next if !defined $GetParam{ $Prefix . 'Hour' };
            next if !defined $GetParam{ $Prefix . 'Minute' };

            # set time stamp to NULL if field is not used/checked
            if ( !$GetParam{ $Prefix . 'Used' } ) {
                $GetParam{ $Prefix . 'Year' }   = 0;
                $GetParam{ $Prefix . 'Month' }  = 0;
                $GetParam{ $Prefix . 'Day' }    = 0;
                $GetParam{ $Prefix . 'Hour' }   = 0;
                $GetParam{ $Prefix . 'Minute' } = 0;
            }

            $Self->{TicketObject}->TicketFreeTimeSet(
                %GetParam,
                Prefix   => 'TicketFreeTime',
                TicketID => $TicketID,
                Counter  => $Count,
                UserID   => $Self->{UserID},
            );
        }

        # get pre loaded attachment
        @Attachments = $Self->{UploadCacheObject}->FormIDGetAllFilesData(
            FormID => $Self->{FormID},
        );

        # get submit attachment
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param  => 'FileUpload',
            Source => 'String',
        );
        if (%UploadStuff) {
            push @Attachments, \%UploadStuff;
        }

        # prepare subject
        my $Tn = $Self->{TicketObject}->TicketNumberLookup( TicketID => $TicketID );
        $GetParam{Subject} = $Self->{TicketObject}->TicketSubjectBuild(
            TicketNumber => $Tn,
            Subject      => $GetParam{Subject} || '',
            Type         => 'New',
        );

        # check if new owner is given (then send no agent notify)
        my $NoAgentNotify = 0;
        if ($NewUserID) {
            $NoAgentNotify = 1;
        }

        my $MimeType = 'text/plain';
        if ( $Self->{LayoutObject}->{BrowserRichText} ) {
            $MimeType = 'text/html';
            $GetParam{Body} .= '<br/><br/>' . $Signature;

            # remove unused inline images
            my @NewAttachmentData;
            for my $Attachment (@Attachments) {
                my $ContentID = $Attachment->{ContentID};
                if ($ContentID) {
                    my $ContentIDHTMLQuote = $Self->{LayoutObject}->Ascii2Html(
                        Text => $ContentID,
                    );
                    next if $GetParam{Body} !~ /(\Q$ContentIDHTMLQuote\E|\Q$ContentID\E)/i;
                }

                # remember inline images and normal attachments
                push @NewAttachmentData, \%{$Attachment};
            }
            @Attachments = @NewAttachmentData;

            # verify html document
            $GetParam{Body} = $Self->{LayoutObject}->RichTextDocumentComplete(
                String => $GetParam{Body},
            );
        }
        else {
            $GetParam{Body} .= "\n\n" . $Signature;
        }

        # send email
        my $ArticleID = $Self->{TicketObject}->ArticleSend(
            NoAgentNotify  => $NoAgentNotify,
            Attachment     => \@Attachments,
            ArticleType    => 'email-external',
            SenderType     => 'agent',
            TicketID       => $TicketID,
            ArticleType    => $Self->{Config}->{ArticleType},
            SenderType     => $Self->{Config}->{SenderType},
            From           => "$Queue{RealName} <$Queue{Email}>",
            To             => $GetParam{To},
            Cc             => $GetParam{Cc},
            Bcc            => $GetParam{Bcc},
            Subject        => $GetParam{Subject},
            Body           => $GetParam{Body},
            Charset        => $Self->{LayoutObject}->{UserCharset},
            MimeType       => $MimeType,
            UserID         => $Self->{UserID},
            HistoryType    => $Self->{Config}->{HistoryType},
            HistoryComment => $Self->{Config}->{HistoryComment}
                || "\%\%$GetParam{To}, $GetParam{Cc}, $GetParam{Bcc}",
            %ArticleParam,
        );
        if ( !$ArticleID ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # set article free text
        for my $Count ( 1 .. 3 ) {
            my $Key  = 'ArticleFreeKey' . $Count;
            my $Text = 'ArticleFreeText' . $Count;
            if ( defined $GetParam{$Key} ) {
                $Self->{TicketObject}->ArticleFreeTextSet(
                    TicketID  => $TicketID,
                    ArticleID => $ArticleID,
                    Key       => $GetParam{$Key},
                    Value     => $GetParam{$Text},
                    Counter   => $Count,
                    UserID    => $Self->{UserID},
                );
            }
        }

        # remove pre submited attachments
        $Self->{UploadCacheObject}->FormIDRemove( FormID => $Self->{FormID} );

        # set owner (if new user id is given)
        if ($NewUserID) {
            $Self->{TicketObject}->TicketOwnerSet(
                TicketID  => $TicketID,
                NewUserID => $NewUserID,
                UserID    => $Self->{UserID},
            );

            # set lock
            $Self->{TicketObject}->TicketLockSet(
                TicketID => $TicketID,
                Lock     => 'lock',
                UserID   => $Self->{UserID},
            );
        }

        # else set owner to current agent but do not lock it
        else {
            $Self->{TicketObject}->TicketOwnerSet(
                TicketID           => $TicketID,
                NewUserID          => $Self->{UserID},
                SendNoNotification => 1,
                UserID             => $Self->{UserID},
            );
        }

        # set responsible (if new user id is given)
        if ($NewResponsibleID) {
            $Self->{TicketObject}->TicketResponsibleSet(
                TicketID  => $TicketID,
                NewUserID => $NewResponsibleID,
                UserID    => $Self->{UserID},
            );
        }

        # time accounting
        if ( $GetParam{TimeUnits} ) {
            $Self->{TicketObject}->TicketAccountTime(
                TicketID  => $TicketID,
                ArticleID => $ArticleID,
                TimeUnit  => $GetParam{TimeUnits},
                UserID    => $Self->{UserID},
            );
        }

        # should i set an unlock?
        if ( $StateData{TypeName} =~ /^close/i ) {

            # set lock
            $Self->{TicketObject}->TicketLockSet(
                TicketID => $TicketID,
                Lock     => 'unlock',
                UserID   => $Self->{UserID},
            );
        }

        # set pending time
        elsif ( $StateData{TypeName} =~ /^pending/i ) {

            # set pending time
            $Self->{TicketObject}->TicketPendingTimeSet(
                UserID   => $Self->{UserID},
                TicketID => $TicketID,
                %GetParam,
            );
        }

        # get redirect screen
        my $NextScreen = $Self->{UserCreateNextMask} || 'AgentTicketEmail';

        # redirect
        return $Self->{LayoutObject}->Redirect(
            OP => "Action=$NextScreen;Subaction=Created;TicketID=$TicketID",
        );
    }
    elsif ( $Self->{Subaction} eq 'AJAXUpdate' ) {
        my $Dest = $Self->{ParamObject}->GetParam( Param => 'Dest' ) || '';
        my $CustomerUser = $Self->{ParamObject}->GetParam( Param => 'SelectedCustomerUser' );

        # get From based on selected queue
        my $QueueID = '';
        if ( $Dest =~ /^(\d{1,100})\|\|.+?$/ ) {
            $QueueID = $1;
            my %Queue = $Self->{QueueObject}->GetSystemAddress( QueueID => $QueueID );
            $GetParam{From} = $Queue{Email};
        }

        # get list type
        my $TreeView = 0;
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::ListType') eq 'tree' ) {
            $TreeView = 1;
        }

        my $Signature = '';
        if ($QueueID) {
            $Signature = $Self->_GetSignature( QueueID => $QueueID );
        }
        my $Users = $Self->_GetUsers(
            QueueID  => $QueueID,
            AllUsers => $GetParam{OwnerAll},
        );
        my $ResponsibleUsers = $Self->_GetUsers(
            QueueID  => $QueueID,
            AllUsers => $GetParam{ResponsibleAll},
        );
        my $NextStates = $Self->_GetNextStates(
            %GetParam,
            CustomerUserID => $CustomerUser || '',
            QueueID        => $QueueID      || 1,
        );
        my $Priorities = $Self->_GetPriorities(
            %GetParam,
            CustomerUserID => $CustomerUser || '',
            QueueID        => $QueueID      || 1,
        );
        my $Services = $Self->_GetServices(
            %GetParam,
            CustomerUserID => $CustomerUser || '',
            QueueID        => $QueueID      || 1,
        );
        my $SLAs = $Self->_GetSLAs(
            %GetParam,
            CustomerUserID => $CustomerUser || '',
            QueueID        => $QueueID      || 1,
            Services       => $Services,
        );

        # get free text config options
        my @ExtendedData;
        for my $Count ( 1 .. 16 ) {
            my $Key       = 'TicketFreeKey' . $Count;
            my $Text      = 'TicketFreeText' . $Count;
            my $ConfigKey = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID => $Self->{TicketID},
                Type     => $Key,
                Action   => $Self->{Action},
                QueueID  => $QueueID || 0,
                UserID   => $Self->{UserID},
            );
            if ($ConfigKey) {
                push(
                    @ExtendedData,
                    {
                        Name        => $Key,
                        Data        => $ConfigKey,
                        SelectedID  => $GetParam{$Key},
                        Translation => 0,
                        Max         => 100,
                    }
                );
            }
            my $ConfigValue = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID => $Self->{TicketID},
                Type     => $Text,
                Action   => $Self->{Action},
                QueueID  => $QueueID || 0,
                UserID   => $Self->{UserID},
            );
            if ($ConfigValue) {
                push(
                    @ExtendedData,
                    {
                        Name        => $Text,
                        Data        => $ConfigValue,
                        SelectedID  => $GetParam{$Text},
                        Translation => 0,
                        Max         => 100,
                    }
                );
            }
        }

        # run compose modules
        if ( ref $Self->{ConfigObject}->Get('Ticket::Frontend::ArticleComposeModule') eq 'HASH' ) {
            my %Jobs = %{ $Self->{ConfigObject}->Get('Ticket::Frontend::ArticleComposeModule') };
            for my $Job ( sort keys %Jobs ) {

                # load module
                next if !$Self->{MainObject}->Require( $Jobs{$Job}->{Module} );

                my $Object = $Jobs{$Job}->{Module}->new( %{$Self}, Debug => $Self->{Debug}, );

                # get params
                for ( $Object->Option( %GetParam, Config => $Jobs{$Job} ) ) {
                    $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
                }

                # run module
                my %Data = $Object->Data( %GetParam, Config => $Jobs{$Job} );

                my $Key = $Object->Option( %GetParam, Config => $Jobs{$Job} );
                if ($Key) {
                    push(
                        @ExtendedData,
                        {
                            Name        => $Key,
                            Data        => \%Data,
                            SelectedID  => $GetParam{$Key},
                            Translation => 1,
                            Max         => 100,
                        }
                    );
                }
            }
        }

        # convert Signature to ASCII, if RichText is on
        if ( $Self->{LayoutObject}->{BrowserRichText} ) {

            #            $Signature = $Self->{HTMLUtilsObject}->ToAscii( String => $Signature, );
        }

        my $JSON = $Self->{LayoutObject}->BuildSelectionJSON(
            [
                {
                    Name         => 'Signature',
                    Data         => $Signature,
                    Translation  => 1,
                    PossibleNone => 1,
                    Max          => 100,
                },
                {
                    Name         => 'NewUserID',
                    Data         => $Users,
                    SelectedID   => $GetParam{NewUserID},
                    Translation  => 0,
                    PossibleNone => 1,
                    Max          => 100,
                },
                {
                    Name         => 'NewResponsibleID',
                    Data         => $ResponsibleUsers,
                    SelectedID   => $GetParam{NewResponsibleID},
                    Translation  => 0,
                    PossibleNone => 1,
                    Max          => 100,
                },
                {
                    Name        => 'NextStateID',
                    Data        => $NextStates,
                    SelectedID  => $GetParam{NextStateID},
                    Translation => 1,
                    Max         => 100,
                },
                {
                    Name        => 'PriorityID',
                    Data        => $Priorities,
                    SelectedID  => $GetParam{PriorityID},
                    Translation => 1,
                    Max         => 100,
                },
                {
                    Name         => 'ServiceID',
                    Data         => $Services,
                    SelectedID   => $GetParam{ServiceID},
                    PossibleNone => 1,
                    Translation  => 0,
                    TreeView     => $TreeView,
                    Max          => 100,
                },
                {
                    Name         => 'SLAID',
                    Data         => $SLAs,
                    SelectedID   => $GetParam{SLAID},
                    PossibleNone => 1,
                    Translation  => 0,
                    Max          => 100,
                },
                @ExtendedData,
            ],
        );
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }
    else {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No Subaction!!',
            Comment => 'Please contact your admin',
        );
    }
}

sub _GetNextStates {
    my ( $Self, %Param ) = @_;

    my %NextStates;
    if ( $Param{QueueID} || $Param{TicketID} ) {
        %NextStates = $Self->{TicketObject}->TicketStateList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%NextStates;
}

sub _GetUsers {
    my ( $Self, %Param ) = @_;

    # get users
    my %ShownUsers;
    my %AllGroupsMembers = $Self->{UserObject}->UserList(
        Type  => 'Long',
        Valid => 1,
    );

    # just show only users with selected custom queue
    if ( $Param{QueueID} && !$Param{AllUsers} ) {
        my @UserIDs = $Self->{TicketObject}->GetSubscribedUserIDsByQueueID(%Param);
        for ( keys %AllGroupsMembers ) {
            my $Hit = 0;
            for my $UID (@UserIDs) {
                if ( $UID eq $_ ) {
                    $Hit = 1;
                }
            }
            if ( !$Hit ) {
                delete $AllGroupsMembers{$_};
            }
        }
    }

    # check show users
    if ( $Self->{ConfigObject}->Get('Ticket::ChangeOwnerToEveryone') ) {
        %ShownUsers = %AllGroupsMembers;
    }

    # show all users who are rw in the queue group
    elsif ( $Param{QueueID} ) {
        my $GID = $Self->{QueueObject}->GetQueueGroupID( QueueID => $Param{QueueID} );
        my %MemberList = $Self->{GroupObject}->GroupMemberList(
            GroupID => $GID,
            Type    => 'rw',
            Result  => 'HASH',
        );
        for ( keys %MemberList ) {
            if ( $AllGroupsMembers{$_} ) {
                $ShownUsers{$_} = $AllGroupsMembers{$_};
            }
        }
    }
    return \%ShownUsers;
}

sub _GetPriorities {
    my ( $Self, %Param ) = @_;

    # get priority
    my %Priorities;
    if ( $Param{QueueID} || $Param{TicketID} ) {
        %Priorities = $Self->{TicketObject}->TicketPriorityList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%Priorities;
}

sub _GetTypes {
    my ( $Self, %Param ) = @_;

    # get type
    my %Type;
    if ( $Param{QueueID} || $Param{TicketID} ) {
        %Type = $Self->{TicketObject}->TicketTypeList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%Type;
}

sub _GetServices {
    my ( $Self, %Param ) = @_;

    # get service
    my %Service;
    if ( ( $Param{QueueID} || $Param{TicketID} ) && $Param{CustomerUserID} ) {
        %Service = $Self->{TicketObject}->TicketServiceList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%Service;
}

sub _GetSLAs {
    my ( $Self, %Param ) = @_;

    # get sla
    my %SLA;
    if ( $Param{ServiceID} && $Param{Services} && %{ $Param{Services} } ) {
        if ( $Param{Services}->{ $Param{ServiceID} } ) {
            %SLA = $Self->{TicketObject}->TicketSLAList(
                %Param,
                Action => $Self->{Action},
                UserID => $Self->{UserID},
            );
        }
    }
    return \%SLA;
}

sub _GetTos {
    my ( $Self, %Param ) = @_;

    # check own selection
    my %NewTos;
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::NewQueueOwnSelection') ) {
        %NewTos = %{ $Self->{ConfigObject}->Get('Ticket::Frontend::NewQueueOwnSelection') };
    }
    else {

        # SelectionType Queue or SystemAddress?
        my %Tos;
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::NewQueueSelectionType') eq 'Queue' ) {
            %Tos = $Self->{TicketObject}->MoveList(
                Type   => 'create',
                Action => $Self->{Action},
                UserID => $Self->{UserID},
            );
        }
        else {
            %Tos = $Self->{DBObject}->GetTableData(
                Table => 'system_address',
                What  => 'queue_id, id',
                Valid => 1,
                Clamp => 1,
            );
        }

        # get create permission queues
        my %UserGroups = $Self->{GroupObject}->GroupMemberList(
            UserID => $Self->{UserID},
            Type   => 'create',
            Result => 'HASH',
        );

        # build selection string
        for my $QueueID ( keys %Tos ) {
            my %QueueData = $Self->{QueueObject}->QueueGet( ID => $QueueID );

            # permission check, can we create new tickets in queue
            next if !$UserGroups{ $QueueData{GroupID} };

            my $String = $Self->{ConfigObject}->Get('Ticket::Frontend::NewQueueSelectionString')
                || '<Realname> <<Email>> - Queue: <Queue>';
            $String =~ s/<Queue>/$QueueData{Name}/g;
            $String =~ s/<QueueComment>/$QueueData{Comment}/g;
            if ( $Self->{ConfigObject}->Get('Ticket::Frontend::NewQueueSelectionType') ne 'Queue' )
            {
                my %SystemAddressData = $Self->{SystemAddress}->SystemAddressGet(
                    ID => $Tos{$QueueID},
                );
                $String =~ s/<Realname>/$SystemAddressData{Realname}/g;
                $String =~ s/<Email>/$SystemAddressData{Name}/g;
            }
            $NewTos{$QueueID} = $String;
        }
    }

    # add empty selection
    $NewTos{''} = '-';
    return \%NewTos;
}

sub _GetSignature {
    my ( $Self, %Param ) = @_;

    # prepare signature
    my $TemplateGenerator = Kernel::System::TemplateGenerator->new( %{$Self} );
    my $Signature         = $TemplateGenerator->Signature(
        QueueID => $Param{QueueID},
        Data    => \%Param,
        UserID  => $Self->{UserID},
    );

    return $Signature;
}

sub _MaskEmailNew {
    my ( $Self, %Param ) = @_;

    $Param{FormID} = $Self->{FormID};

    # get list type
    my $TreeView = 0;
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

    # build customer search autocomplete field
    my $AutoCompleteConfig
        = $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerSearchAutoComplete');
    $Self->{LayoutObject}->Block(
        Name => 'CustomerSearchAutoComplete',
        Data => {
            ActiveAutoComplete  => $AutoCompleteConfig->{Active},
            minQueryLength      => $AutoCompleteConfig->{MinQueryLength} || 2,
            queryDelay          => $AutoCompleteConfig->{QueryDelay} || 0.1,
            typeAhead           => $AutoCompleteConfig->{TypeAhead} || 'false',
            maxResultsDisplayed => $AutoCompleteConfig->{MaxResultsDisplayed} || 20,
        },
    );

    # build string
    $Param{Users}->{''} = '-';
    $Param{OptionStrg} = $Self->{LayoutObject}->BuildSelection(
        Data       => $Param{Users},
        SelectedID => $Param{UserSelected},
        Name       => 'NewUserID',
    );

    # build next states string
    $Param{NextStatesStrg} = $Self->{LayoutObject}->BuildSelection(
        Data          => $Param{NextStates},
        Name          => 'NextStateID',
        Translation   => 1,
        SelectedValue => $Param{NextState} || $Self->{Config}->{StateDefault},
    );

    # build from string

    if ( $Param{ToOptions} && %{ $Param{ToOptions} } ) {
        $Param{CustomerUserStrg} = $Self->{LayoutObject}->BuildSelection(
            Data => $Param{ToOptions},
            Name => 'CustomerUser',
            Max  => 70,
        );

        if ( $Param{CustomerUserStrg} ne "" ) {
            $Self->{LayoutObject}->Block( Name => 'TakeCustomerButton', );
        }
    }

    # build to string
    my %NewTo;
    if ( $Param{FromList} ) {
        for ( keys %{ $Param{FromList} } ) {
            $NewTo{"$_||$Param{FromList}->{$_}"} = $Param{FromList}->{$_};
        }
    }
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::NewQueueSelectionType') eq 'Queue' ) {
        $Param{FromStrg} = $Self->{LayoutObject}->AgentQueueListOption(
            Data           => \%NewTo,
            Multiple       => 0,
            Size           => 0,
            Class          => 'Validate_Required' . $Param{Errors}->{DestinationInvalid},
            Name           => 'Dest',
            SelectedID     => $Param{FromSelected},
            OnChangeSubmit => 0,

        );
    }
    else {
        $Param{FromStrg} = $Self->{LayoutObject}->BuildSelection(
            Data       => \%NewTo,
            Class      => 'Validate_Required' . $Param{Errors}->{DestinationInvalid},
            Name       => 'Dest',
            SelectedID => $Param{FromSelected},
        );
    }

    # customer info string
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoCompose') ) {
        $Param{CustomerTable} = $Self->{LayoutObject}->AgentCustomerViewTable(
            Data => $Param{CustomerData},
            Max  => $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoComposeMaxSize'),
        );
        $Self->{LayoutObject}->Block(
            Name => 'CustomerTable',
            Data => \%Param,
        );
    }

    # prepare errors!
    if ( $Param{Errors} ) {
        for ( keys %{ $Param{Errors} } ) {
            $Param{$_} = $Self->{LayoutObject}->Ascii2Html( Text => $Param{Errors}->{$_} );
        }
    }

    # build type string
    if ( $Self->{ConfigObject}->Get('Ticket::Type') ) {
        $Param{TypeStrg} = $Self->{LayoutObject}->BuildSelection(
            Data         => $Param{Types},
            Name         => 'TypeID',
            Class        => 'Validate_RequiredDropdown',
            SelectedID   => $Param{TypeID},
            PossibleNone => 1,
            Sort         => 'AlphanumericValue',
            Translation  => 0,
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketType',
            Data => {%Param},
        );
    }

    # build service string
    if ( $Self->{ConfigObject}->Get('Ticket::Service') ) {
        $Param{ServiceStrg} = $Self->{LayoutObject}->BuildSelection(
            Data         => $Param{Services},
            Name         => 'ServiceID',
            Class        => $Param{Errors}->{ServiceInvalid},
            SelectedID   => $Param{ServiceID},
            PossibleNone => 1,
            TreeView     => $TreeView,
            Sort         => 'TreeView',
            Translation  => 0,
            Max          => 200,
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketService',
            Data => {%Param},
        );
        $Param{SLAStrg} = $Self->{LayoutObject}->BuildSelection(
            Data         => $Param{SLAs},
            Name         => 'SLAID',
            Class        => '',
            SelectedID   => $Param{SLAID},
            PossibleNone => 1,
            Sort         => 'AlphanumericValue',
            Translation  => 0,
            Max          => 200,
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketSLA',
            Data => {%Param},
        );
    }

    # build priority string
    if ( !$Param{PriorityID} ) {
        $Param{Priority} = $Self->{Config}->{Priority};
    }
    $Param{PriorityStrg} = $Self->{LayoutObject}->BuildSelection(
        Data          => $Param{Priorities},
        Name          => 'PriorityID',
        SelectedID    => $Param{PriorityID},
        SelectedValue => $Param{Priority},
        Translation   => 1,
    );

    # pending data string
    $Param{PendingDateString} = $Self->{LayoutObject}->BuildDateSelection(
        %Param,
        Format           => 'DateInputFormatLong',
        YearPeriodPast   => 0,
        YearPeriodFuture => 5,
        DiffTime         => $Self->{ConfigObject}->Get('Ticket::Frontend::PendingDiffTime') || 0,
        Validate         => 1,
        Class            => $Param{Errors}->{DateInvalid},
    );

    # show owner selection
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::NewOwnerSelection') ) {
        $Self->{LayoutObject}->Block(
            Name => 'OwnerSelection',
            Data => \%Param,
        );
    }

    # show responsible selection
    if (
        $Self->{ConfigObject}->Get('Ticket::Responsible')
        && $Self->{ConfigObject}->Get('Ticket::Frontend::NewResponsibleSelection')
        )
    {
        $Param{ResponsibleUsers}->{''} = '-';
        $Param{ResponsibleOptionStrg} = $Self->{LayoutObject}->BuildSelection(
            Data       => $Param{ResponsibleUsers},
            SelectedID => $Param{ResponsibleUsersSelected},
            Name       => 'NewResponsibleID',
        );
        $Self->{LayoutObject}->Block(
            Name => 'ResponsibleSelection',
            Data => \%Param,
        );
    }

    # ticket free text
    for my $Count ( 1 .. 16 ) {
        next if !$Self->{Config}->{TicketFreeText}->{$Count};
        $Self->{LayoutObject}->Block(
            Name => 'TicketFreeText',
            Data => {
                TicketFreeKeyField  => $Param{ 'TicketFreeKeyField' . $Count },
                TicketFreeTextField => $Param{ 'TicketFreeTextField' . $Count },
                Count               => $Count,
                %Param,
            },
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketFreeText' . $Count,
            Data => { %Param, Count => $Count, },
        );
    }
    for my $Count ( 1 .. 6 ) {
        next if !$Self->{Config}->{TicketFreeTime}->{$Count};
        $Self->{LayoutObject}->Block(
            Name => 'TicketFreeTime',
            Data => {
                TicketFreeTimeKey => $Self->{ConfigObject}->Get( 'TicketFreeTimeKey' . $Count ),
                TicketFreeTime    => $Param{ 'TicketFreeTime' . $Count },
                Count             => $Count,
            },
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketFreeTime' . $Count,
            Data => { %Param, Count => $Count, },
        );
    }

    # article free text
    for my $Count ( 1 .. 3 ) {
        next if !$Self->{Config}->{ArticleFreeText}->{$Count};
        $Self->{LayoutObject}->Block(
            Name => 'ArticleFreeText',
            Data => {
                ArticleFreeKeyField  => $Param{ 'ArticleFreeKeyField' . $Count },
                ArticleFreeTextField => $Param{ 'ArticleFreeTextField' . $Count },
                Count                => $Count,
            },
        );
        $Self->{LayoutObject}->Block(
            Name => 'ArticleFreeText' . $Count,
            Data => { %Param, Count => $Count, },
        );
    }

    # show time accounting box
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::AccountTime') ) {
        $Self->{LayoutObject}->Block(
            Name => 'TimeUnits',
            Data => \%Param,
        );
    }

    # show spell check
    if ( $Self->{LayoutObject}->{BrowserSpellChecker} ) {
        $Self->{LayoutObject}->Block(
            Name => 'SpellCheck',
            Data => {},
        );
    }

    # show address book
    if ( $Self->{LayoutObject}->{BrowserJavaScriptSupport} ) {
        $Self->{LayoutObject}->Block(
            Name => 'AddressBook',
            Data => {},
        );
    }

    # show customer edit link
    my $OptionCustomer = $Self->{LayoutObject}->Permission(
        Action => 'AdminCustomerUser',
        Type   => 'rw',
    );
    if ($OptionCustomer) {
        $Self->{LayoutObject}->Block(
            Name => 'OptionCustomer',
            Data => {},
        );
    }

    # show attachments
    for my $Attachment ( @{ $Param{Attachments} } ) {
        next if $Attachment->{ContentID} && $Self->{LayoutObject}->{BrowserRichText};
        $Self->{LayoutObject}->Block(
            Name => 'Attachment',
            Data => $Attachment,
        );
    }

    # add rich text editor
    if ( $Self->{LayoutObject}->{BrowserRichText} ) {
        $Self->{LayoutObject}->Block(
            Name => 'RichText',
            Data => \%Param,
        );
    }

    # get output back
    return $Self->{LayoutObject}->Output( TemplateFile => 'AgentTicketEmail', Data => \%Param );
}

1;
