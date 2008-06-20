# --
# Kernel/Modules/AgentTicketEmail.pm - to compose initial email to customer
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AgentTicketEmail.pm,v 1.63 2008-06-20 19:34:20 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AgentTicketEmail;

use strict;
use warnings;

use Kernel::System::SystemAddress;
use Kernel::System::CustomerUser;
use Kernel::System::CheckItem;
use Kernel::System::Web::UploadCache;
use Kernel::System::State;
use Mail::Address;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.63 $) [1];

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
    $Self->{UploadCachObject}   = Kernel::System::Web::UploadCache->new(%Param);

    # get form id
    $Self->{FormID} = $Self->{ParamObject}->GetParam( Param => 'FormID' );

    # create form id
    if ( !$Self->{FormID} ) {
        $Self->{FormID} = $Self->{UploadCachObject}->FormIDCreate();
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
    my %GetParam = ();
    for (
        qw(AttachmentUpload
        Year Month Day Hour Minute To Cc Bcc TimeUnits PriorityID Subject Body
        TypeID ServiceID SLAID OwnerAll ResponsibleAll
        NewResponsibleID NewUserID
        NextStateID
        AttachmentDelete1 AttachmentDelete2 AttachmentDelete3 AttachmentDelete4
        AttachmentDelete5 AttachmentDelete6 AttachmentDelete7 AttachmentDelete8
        AttachmentDelete9 AttachmentDelete10 AttachmentDelete11 AttachmentDelete12
        AttachmentDelete13 AttachmentDelete14 AttachmentDelete15 AttachmentDelete16
        )
        )
    {
        $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
    }

    # get ticket free text params
    for ( 1 .. 16 ) {
        $GetParam{"TicketFreeKey$_"} = $Self->{ParamObject}->GetParam( Param => "TicketFreeKey$_" );
        $GetParam{"TicketFreeText$_"}
            = $Self->{ParamObject}->GetParam( Param => "TicketFreeText$_" );
    }

    # get ticket free time params
    for ( 1 .. 6 ) {
        for my $Type (qw(Used Year Month Day Hour Minute)) {
            $GetParam{ "TicketFreeTime" . $_ . $Type } = $Self->{ParamObject}->GetParam(
                Param => "TicketFreeTime" . $_ . $Type,
            );
        }
        $GetParam{ 'TicketFreeTime' . $_ . 'Optional' }
            = $Self->{ConfigObject}->Get( 'TicketFreeTimeOptional' . $_ ) || 0;
        if ( !$Self->{ConfigObject}->Get( 'TicketFreeTimeOptional' . $_ ) ) {
            $GetParam{ 'TicketFreeTime' . $_ . 'Used' } = 1;
        }
    }

    # get article free text params
    for ( 1 .. 3 ) {
        $GetParam{"ArticleFreeKey$_"}
            = $Self->{ParamObject}->GetParam( Param => "ArticleFreeKey$_" );
        $GetParam{"ArticleFreeText$_"}
            = $Self->{ParamObject}->GetParam( Param => "ArticleFreeText$_" );
    }

    if ( !$Self->{Subaction} || $Self->{Subaction} eq 'Created' ) {

        # header
        $Output .= $Self->{LayoutObject}->Header();

        # if there is no ticket id!
        if ( !$Self->{TicketID} || ( $Self->{TicketID} && $Self->{Subaction} eq 'Created' ) ) {

            # navigation bar
            $Output .= $Self->{LayoutObject}->NavigationBar();

            # notify info
            if ( $Self->{TicketID} ) {
                my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Self->{TicketID} );
                $Output .= $Self->{LayoutObject}->Notify(
                    Info => 'Ticket "%s" created!", "' . $Ticket{TicketNumber},
                    Link => '$Env{"Baselink"}Action=AgentTicketZoom&TicketID=' . $Ticket{TicketID},
                );
            }

            # get split article if given
            # get default selections
            my %TicketFreeDefault = ();
            for ( 1 .. 16 ) {
                $TicketFreeDefault{ 'TicketFreeKey' . $_ } = $GetParam{ 'TicketFreeKey' . $_ }
                    || $Self->{ConfigObject}->Get( 'TicketFreeKey' . $_ . '::DefaultSelection' );
                $TicketFreeDefault{ 'TicketFreeText' . $_ } = $GetParam{ 'TicketFreeText' . $_ }
                    || $Self->{ConfigObject}->Get( 'TicketFreeText' . $_ . '::DefaultSelection' );
            }

            # get free text config options
            my %TicketFreeText = ();
            for ( 1 .. 16 ) {
                $TicketFreeText{"TicketFreeKey$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                    TicketID => $Self->{TicketID},
                    Type     => "TicketFreeKey$_",
                    Action   => $Self->{Action},
                    UserID   => $Self->{UserID},
                );
                $TicketFreeText{"TicketFreeText$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                    TicketID => $Self->{TicketID},
                    Type     => "TicketFreeText$_",
                    Action   => $Self->{Action},
                    UserID   => $Self->{UserID},
                );
            }
            my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
                Config => \%TicketFreeText,
                Ticket => {
                    %TicketFreeDefault,
                    $Self->{UserObject}->GetUserData(
                        UserID => $Self->{UserID},
                        Cached => 1,
                    ),
                    }
            );

            # free time
            my %TicketFreeTimeHTML
                = $Self->{LayoutObject}->AgentFreeDate( %Param, Ticket => \%GetParam, );

            # get article free text default selections
            my %ArticleFreeDefault = ();
            for ( 1 .. 3 ) {
                $ArticleFreeDefault{ 'ArticleFreeKey' . $_ } = $GetParam{ 'ArticleFreeKey' . $_ }
                    || $Self->{ConfigObject}->Get( 'ArticleFreeKey' . $_ . '::DefaultSelection' );
                $ArticleFreeDefault{ 'ArticleFreeText' . $_ } = $GetParam{ 'ArticleFreeText' . $_ }
                    || $Self->{ConfigObject}->Get( 'ArticleFreeText' . $_ . '::DefaultSelection' );
            }

            # article free text
            my %ArticleFreeText = ();
            for ( 1 .. 3 ) {
                $ArticleFreeText{"ArticleFreeKey$_"} = $Self->{TicketObject}->ArticleFreeTextGet(
                    TicketID => $Self->{TicketID},
                    Type     => "ArticleFreeKey$_",
                    Action   => $Self->{Action},
                    UserID   => $Self->{UserID},
                );
                $ArticleFreeText{"ArticleFreeText$_"} = $Self->{TicketObject}->ArticleFreeTextGet(
                    TicketID => $Self->{TicketID},
                    Type     => "ArticleFreeText$_",
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
                ref( $Self->{ConfigObject}->Get('Ticket::Frontend::ArticleComposeModule') ) eq
                'HASH'
                )
            {
                my %Jobs
                    = %{ $Self->{ConfigObject}->Get('Ticket::Frontend::ArticleComposeModule') };
                for my $Job ( sort keys %Jobs ) {

                    # load module
                    if ( $Self->{MainObject}->Require( $Jobs{$Job}->{Module} ) ) {
                        my $Object
                            = $Jobs{$Job}->{Module}->new( %{$Self}, Debug => $Self->{Debug}, );

                        # get params
                        my %GetParam;
                        for ( $Object->Option( %GetParam, Config => $Jobs{$Job} ) ) {
                            $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
                        }

                        # run module
                        $Object->Run( %GetParam, Config => $Jobs{$Job} );
                    }
                    else {
                        return $Self->{LayoutObject}->FatalError();
                    }
                }
            }

            # html output
            $Output .= $Self->_MaskEmailNew(
                QueueID    => $Self->{QueueID},
                NextStates => $Self->_GetNextStates( QueueID => 1 ),
                Priorities => $Self->_GetPriorities( QueueID => 1 ),
                Types      => $Self->_GetTypes( QueueID => 1 ),
                Services   => $Self->_GetServices( QueueID => 1, ),
                SLAs       => $Self->_GetSLAs( QueueID => 1, %GetParam ),
                Users      => $Self->_GetUsers(),
                FromList   => $Self->_GetTos(),
                To         => '',
                Subject => $Self->{LayoutObject}->Output( Template => $Self->{Config}->{Subject} ),
                Body    => $Self->{LayoutObject}->Output( Template => $Self->{Config}->{Body} ),
                CustomerID   => '',
                CustomerUser => '',
                CustomerData => {},
                %TicketFreeTextHTML,
                %TicketFreeTimeHTML,
                %ArticleFreeTextHTML,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # create new ticket and article
    elsif ( $Self->{Subaction} eq 'StoreNew' ) {
        my %Error       = ();
        my $NextStateID = $Self->{ParamObject}->GetParam( Param => 'NextStateID' ) || '';
        my %StateData   = ();
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
        my %Queue     = ();
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
        my %TicketFreeText = ();
        for ( 1 .. 16 ) {
            $TicketFreeText{"TicketFreeKey$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID => $Self->{TicketID},
                Type     => "TicketFreeKey$_",
                Action   => $Self->{Action},
                QueueID  => $NewQueueID || 0,
                UserID   => $Self->{UserID},
            );
            $TicketFreeText{"TicketFreeText$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID => $Self->{TicketID},
                Type     => "TicketFreeText$_",
                Action   => $Self->{Action},
                QueueID  => $NewQueueID || 0,
                UserID   => $Self->{UserID},
            );

            # check required FreeTextField (if configured)
            if (
                $Self->{Config}{'TicketFreeText'}{$_} == 2
                && $GetParam{"TicketFreeText$_"} eq ''
                && $ExpandCustomerName == 0
                )
            {
                $Error{"TicketFreeTextField$_ invalid"} = 'invalid';
            }
        }
        my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
            Config => \%TicketFreeText,
            Ticket => \%GetParam,
        );

        # free time
        my %TicketFreeTimeHTML = $Self->{LayoutObject}->AgentFreeDate( Ticket => \%GetParam, );

        # article free text
        my %ArticleFreeText = ();
        for ( 1 .. 3 ) {
            $ArticleFreeText{"ArticleFreeKey$_"} = $Self->{TicketObject}->ArticleFreeTextGet(
                TicketID => $Self->{TicketID},
                Type     => "ArticleFreeKey$_",
                Action   => $Self->{Action},
                UserID   => $Self->{UserID},
            );
            $ArticleFreeText{"ArticleFreeText$_"} = $Self->{TicketObject}->ArticleFreeTextGet(
                TicketID => $Self->{TicketID},
                Type     => "ArticleFreeText$_",
                Action   => $Self->{Action},
                UserID   => $Self->{UserID},
            );
        }
        my %ArticleFreeTextHTML = $Self->{LayoutObject}->TicketArticleFreeText(
            Config  => \%ArticleFreeText,
            Article => \%GetParam,
        );

        # attachment delete
        for ( 1 .. 16 ) {
            if ( $GetParam{"AttachmentDelete$_"} ) {
                $Error{AttachmentDelete} = 1;
                $Self->{UploadCachObject}->FormIDRemoveFile(
                    FormID => $Self->{FormID},
                    FileID => $_,
                );
            }
        }

        # attachment upload
        if ( $GetParam{AttachmentUpload} ) {
            $Error{AttachmentUpload} = 1;
            my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
                Param  => "file_upload",
                Source => 'string',
            );
            $Self->{UploadCachObject}->FormIDAddFile(
                FormID => $Self->{FormID},
                %UploadStuff,
            );
        }

        # get all attachments meta data
        my @Attachments = $Self->{UploadCachObject}->FormIDGetAllFilesMeta(
            FormID => $Self->{FormID},
        );

        # Expand Customer Name
        my %CustomerUserData = ();
        if ( $ExpandCustomerName == 1 ) {

            # search customer
            my %CustomerUserList = ();
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
                $GetParam{To} = $Param{CustomerUserListLast};
                $Error{"ExpandCustomerName"} = 1;
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
                $Param{"ToOptions"} = \%CustomerUserList;

                # clear to if there is no customer found
                if ( !%CustomerUserList ) {
                    $GetParam{To} = '';
                }
                $Error{"ExpandCustomerName"} = 1;
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
            $Error{"ExpandCustomerName"} = 1;
        }

        # if a new destination queue is selected
        elsif ( $ExpandCustomerName == 3 ) {
            $Error{NoSubmit} = 1;
            $CustomerUser = $SelectedCustomerUser;
        }

        # show customer info
        my %CustomerData = ();
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
        for (qw(To Cc Bcc)) {
            if ( $GetParam{$_} ) {
                for my $Email ( Mail::Address->parse( $GetParam{$_} ) ) {
                    if ( !$Self->{CheckItemObject}->CheckEmail( Address => $Email->address() ) ) {
                        $Error{"$_ invalid"} .= $Self->{CheckItemObject}->CheckError();
                    }
                }
            }
        }
        if ( !$GetParam{To} && $ExpandCustomerName != 1 && $ExpandCustomerName == 0 ) {
            $Error{'To invalid'} = 'invalid';
        }
        if ( !$GetParam{Subject} && $ExpandCustomerName == 0 ) {
            $Error{'Subject invalid'} = 'invalid';
        }
        if ( !$NewQueueID && $ExpandCustomerName == 0 ) {
            $Error{'Destination invalid'} = 'invalid';
        }

        # check if date is valid
        if ( $StateData{TypeName} && $StateData{TypeName} =~ /^pending/i ) {
            if ( !$Self->{TimeObject}->Date2SystemTime( %GetParam, Second => 0 ) ) {
                $Error{'Date invalid'} = 'invalid';
            }
            if (
                $Self->{TimeObject}->Date2SystemTime( %GetParam, Second => 0 )
                < $Self->{TimeObject}->SystemTime()
                )
            {
                $Error{'Date invalid'} = 'invalid';
            }
        }
        if (
            $Self->{ConfigObject}->Get('Ticket::Service')
            && $GetParam{SLAID}
            && !$GetParam{ServiceID}
            )
        {
            $Error{'Service invalid'} = 'invalid';
        }

        # run compose modules
        my %ArticleParam = ();
        if ( ref $Self->{ConfigObject}->Get('Ticket::Frontend::ArticleComposeModule') eq 'HASH' ) {
            my %Jobs = %{ $Self->{ConfigObject}->Get('Ticket::Frontend::ArticleComposeModule') };
            for my $Job ( sort keys %Jobs ) {

                # load module
                if ( $Self->{MainObject}->Require( $Jobs{$Job}->{Module} ) ) {
                    my $Object = $Jobs{$Job}->{Module}->new( %{$Self}, Debug => $Self->{Debug}, );

                    # get params
                    for ( $Object->Option( %GetParam, Config => $Jobs{$Job} ) ) {
                        $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
                    }

                    # run module
                    $Object->Run( %GetParam, Config => $Jobs{$Job} );

                    # ticket params
                    %ArticleParam = (
                        %ArticleParam, $Object->ArticleOption( %GetParam, Config => $Jobs{$Job} )
                    );

                    # get errors
                    %Error = ( %Error, $Object->Error( %GetParam, Config => $Jobs{$Job} ) );
                }
                else {
                    return $Self->{LayoutObject}->FatalError();
                }
            }
        }

        if (%Error) {

            # get services
            my $Services = $Self->_GetServices(
                CustomerUserID => $CustomerUser || '',
                QueueID        => $NewQueueID   || 1,
            );

            # reset previous ServiceID to reset SLA-List if no service is selected
            if ( !$Services->{ $GetParam{ServiceID} } ) {
                $GetParam{ServiceID} = '';
            }

            # header
            $Output .= $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();

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
                NextStates               => $Self->_GetNextStates( QueueID => $NewQueueID || 1 ),
                NextState                => $NextState,
                Priorities               => $Self->_GetPriorities( QueueID => $NewQueueID || 1 ),
                Types                    => $Self->_GetTypes( QueueID => $NewQueueID || 1 ),
                Services                 => $Services,
                SLAs => $Self->_GetSLAs( QueueID => $NewQueueID || 1, %GetParam ),
                CustomerID => $Self->{LayoutObject}->Ascii2Html( Text => $CustomerID ),
                CustomerUser => $CustomerUser,
                CustomerData => \%CustomerData,
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

            # show customer tickets
            my @TicketIDs = ();
            if ( $CustomerUser && $Self->{Config}->{ShownCustomerTickets} ) {

                # get secondary customer ids
                my @CustomerIDs = $Self->{CustomerUserObject}->CustomerIDs( User => $CustomerUser );

                # get own customer id
                my %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                    User => $CustomerUser,
                );
                if ( $CustomerData{UserCustomerID} ) {
                    push( @CustomerIDs, $CustomerData{UserCustomerID} );
                }
                if (@CustomerIDs) {
                    @TicketIDs = $Self->{TicketObject}->TicketSearch(
                        Result     => 'ARRAY',
                        Limit      => $Self->{Config}->{ShownCustomerTickets},
                        CustomerID => \@CustomerIDs,
                        UserID     => $Self->{UserID},
                        Permission => 'ro',
                    );
                }
            }
            for my $TicketID (@TicketIDs) {
                my %Article = $Self->{TicketObject}->ArticleLastCustomerArticle(
                    TicketID => $TicketID,
                );

                # get acl actions
                $Self->{TicketObject}->TicketAcl(
                    Data          => '-',
                    Action        => $Self->{Action},
                    TicketID      => $Article{TicketID},
                    ReturnType    => 'Action',
                    ReturnSubType => '-',
                    UserID        => $Self->{UserID},
                );
                my %AclAction = $Self->{TicketObject}->TicketAclActionData();

                # ticket title
                if ( $Self->{ConfigObject}->Get('Ticket::Frontend::Title') ) {
                    $Self->{LayoutObject}->Block(
                        Name => 'Title',
                        Data => { %Param, %Article },
                    );
                }

                # run ticket menu modules
                if (
                    ref( $Self->{ConfigObject}->Get('Ticket::Frontend::PreMenuModule') ) eq 'HASH'
                    )
                {
                    my %Menus = %{ $Self->{ConfigObject}->Get('Ticket::Frontend::PreMenuModule') };
                    my $Counter = 0;
                    for my $Menu ( sort keys %Menus ) {

                        # load module
                        if ( $Self->{MainObject}->Require( $Menus{$Menu}->{Module} ) ) {
                            my $Object = $Menus{$Menu}->{Module}->new(
                                %{$Self},
                                TicketID => $Self->{TicketID},
                            );

                            # run module
                            $Counter = $Object->Run(
                                %Param,
                                TicketID => $TicketID,
                                Ticket   => \%Article,
                                Counter  => $Counter,
                                ACL      => \%AclAction,
                                Config   => $Menus{$Menu},
                            );
                        }
                        else {
                            return $Self->{LayoutObject}->FatalError();
                        }
                    }
                }
                for (qw(From To Cc Subject)) {
                    if ( $Article{$_} ) {
                        $Self->{LayoutObject}->Block(
                            Name => 'Row',
                            Data => {
                                Key   => $_,
                                Value => $Article{$_},
                            },
                        );
                    }
                }
                for ( 1 .. 3 ) {
                    if ( $Article{"FreeText$_"} ) {
                        $Self->{LayoutObject}->Block(
                            Name => 'ArticleFreeText',
                            Data => {
                                Key   => $Article{"FreeKey$_"},
                                Value => $Article{"FreeText$_"},
                            },
                        );
                    }
                }
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AgentTicketQueueTicketViewLite',
                    Data         => {
                        %AclAction,
                        %Article,
                        Age => $Self->{LayoutObject}->CustomerAge(
                            Age   => $Article{Age},
                            Space => ' '
                        ),
                        }
                );
            }
            $Output .= $Self->{LayoutObject}->Footer();
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
        for ( 1 .. 16 ) {
            if ( defined( $GetParam{"TicketFreeKey$_"} ) ) {
                $Self->{TicketObject}->TicketFreeTextSet(
                    TicketID => $TicketID,
                    Key      => $GetParam{"TicketFreeKey$_"},
                    Value    => $GetParam{"TicketFreeText$_"},
                    Counter  => $_,
                    UserID   => $Self->{UserID},
                );
            }
        }

        # set ticket free time
        for ( 1 .. 6 ) {
            if (
                defined( $GetParam{ 'TicketFreeTime' . $_ . 'Year' } )
                && defined( $GetParam{ 'TicketFreeTime' . $_ . 'Month' } )
                && defined( $GetParam{ 'TicketFreeTime' . $_ . 'Day' } )
                && defined( $GetParam{ 'TicketFreeTime' . $_ . 'Hour' } )
                && defined( $GetParam{ 'TicketFreeTime' . $_ . 'Minute' } )
                )
            {
                my %Time;
                $Time{ 'TicketFreeTime' . $_ . 'Year' }    = 0;
                $Time{ 'TicketFreeTime' . $_ . 'Month' }   = 0;
                $Time{ 'TicketFreeTime' . $_ . 'Day' }     = 0;
                $Time{ 'TicketFreeTime' . $_ . 'Hour' }    = 0;
                $Time{ 'TicketFreeTime' . $_ . 'Minute' }  = 0;
                $Time{ 'TicketFreeTime' . $_ . 'Secunde' } = 0;

                if ( $GetParam{ 'TicketFreeTime' . $_ . 'Used' } ) {
                    %Time = $Self->{LayoutObject}->TransfromDateSelection(
                        %GetParam,
                        Prefix => 'TicketFreeTime' . $_,
                    );
                }
                $Self->{TicketObject}->TicketFreeTimeSet(
                    %Time,
                    Prefix   => 'TicketFreeTime',
                    TicketID => $TicketID,
                    Counter  => $_,
                    UserID   => $Self->{UserID},
                );
            }
        }

        # get pre loaded attachment
        @Attachments = $Self->{UploadCachObject}->FormIDGetAllFilesData(
            FormID => $Self->{FormID},
        );

        # get submit attachment
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param  => 'file_upload',
            Source => 'String',
        );
        if (%UploadStuff) {
            push( @Attachments, \%UploadStuff );
        }

        # prepare subject
        my $Tn = $Self->{TicketObject}->TicketNumberLookup( TicketID => $TicketID );
        $GetParam{Subject} = $Self->{TicketObject}->TicketSubjectBuild(
            TicketNumber => $Tn,
            Subject      => $GetParam{Subject} || '',
            Type         => 'New',
        );
        $GetParam{Body} .= "\n\n" . $Signature;

        # check if new owner is given (then send no agent notify)
        my $NoAgentNotify = 0;
        if ($NewUserID) {
            $NoAgentNotify = 1;
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
            Type           => 'text/plain',
            UserID         => $Self->{UserID},
            HistoryType    => $Self->{Config}->{HistoryType},
            HistoryComment => $Self->{Config}->{HistoryComment}
                || "\%\%$GetParam{To}, $GetParam{Cc}, $GetParam{Bcc}",
            %ArticleParam,
        );
        if ($ArticleID) {

            # set article free text
            for ( 1 .. 3 ) {
                if ( defined( $GetParam{"ArticleFreeKey$_"} ) ) {
                    $Self->{TicketObject}->ArticleFreeTextSet(
                        TicketID  => $TicketID,
                        ArticleID => $ArticleID,
                        Key       => $GetParam{"ArticleFreeKey$_"},
                        Value     => $GetParam{"ArticleFreeText$_"},
                        Counter   => $_,
                        UserID    => $Self->{UserID},
                    );
                }
            }

            # remove pre submited attachments
            $Self->{UploadCachObject}->FormIDRemove( FormID => $Self->{FormID} );

            # set owner (if new user id is given)
            if ($NewUserID) {
                $Self->{TicketObject}->OwnerSet(
                    TicketID  => $TicketID,
                    NewUserID => $NewUserID,
                    UserID    => $Self->{UserID},
                );

                # set lock
                $Self->{TicketObject}->LockSet(
                    TicketID => $TicketID,
                    Lock     => 'lock',
                    UserID   => $Self->{UserID},
                );
            }

            # else set owner to current agent but do not lock it
            else {
                $Self->{TicketObject}->OwnerSet(
                    TicketID           => $TicketID,
                    NewUserID          => $Self->{UserID},
                    SendNoNotification => 1,
                    UserID             => $Self->{UserID},
                );
            }

            # set responsible (if new user id is given)
            if ($NewResponsibleID) {
                $Self->{TicketObject}->ResponsibleSet(
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
            my %StateData = $Self->{StateObject}->StateGet( ID => $NextStateID );
            if ( $StateData{TypeName} =~ /^close/i ) {
                $Self->{TicketObject}->LockSet(
                    TicketID => $TicketID,
                    Lock     => 'unlock',
                    UserID   => $Self->{UserID},
                );
            }

            # set pending time
            elsif ( $StateData{TypeName} =~ /^pending/i ) {
                $Self->{TicketObject}->TicketPendingTimeSet(
                    UserID   => $Self->{UserID},
                    TicketID => $TicketID,
                    %GetParam,
                );
            }

            # get redirect screen
            my $NextScreen = $Self->{UserCreateNextMask}
                || $Self->{ConfigObject}->Get('PreferencesGroups')->{CreateNextMask}->{DataSelected}
                || 'AgentTicketEmail';

            # redirect
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=$NextScreen&Subaction=Created&TicketID=$TicketID",
            );
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    elsif ( $Self->{Subaction} eq 'AJAXUpdate' ) {
        my $Dest         = $Self->{ParamObject}->GetParam( Param => 'Dest' );
        my $CustomerUser = $Self->{ParamObject}->GetParam( Param => 'SelectedCustomerUser' );
        my $QueueID      = '';
        if ( $Dest =~ /^(\d{1,100})\|\|.+?$/ ) {
            $QueueID = $1;
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
        my $NextStates = $Self->_GetNextStates( QueueID => $QueueID || 1 );
        my $Priorities = $Self->_GetPriorities( QueueID => $QueueID || 1 );
        my $Services = $Self->_GetServices(
            CustomerUserID => $CustomerUser || '',
            QueueID        => $QueueID      || 1,
        );
        my $SLAs = $Self->_GetSLAs( QueueID => $QueueID || 1, %GetParam );

        # get free text config options
        my @TicketFreeTextConfig = ();
        for ( 1 .. 16 ) {
            my $ConfigKey = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID => $Self->{TicketID},
                Type     => "TicketFreeKey$_",
                Action   => $Self->{Action},
                QueueID  => $QueueID || 0,
                UserID   => $Self->{UserID},
            );
            if ($ConfigKey) {
                push(
                    @TicketFreeTextConfig,
                    {
                        Name        => "TicketFreeKey$_",
                        Data        => $ConfigKey,
                        SelectedID  => $GetParam{"TicketFreeKey$_"},
                        Translation => 0,
                        Max         => 100,
                    }
                );
            }
            my $ConfigValue = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID => $Self->{TicketID},
                Type     => "TicketFreeText$_",
                Action   => $Self->{Action},
                QueueID  => $QueueID || 0,
                UserID   => $Self->{UserID},
            );
            if ($ConfigValue) {
                push(
                    @TicketFreeTextConfig,
                    {
                        Name        => "TicketFreeText$_",
                        Data        => $ConfigValue,
                        SelectedID  => $GetParam{"TicketFreeText$_"},
                        Translation => 0,
                        Max         => 100,
                    }
                );
            }
        }
        my $JSON = $Self->{LayoutObject}->BuildJSON(
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
                    Translation  => 1,
                    PossibleNone => 1,
                    Max          => 100,
                },
                {
                    Name         => 'NewResponsibleID',
                    Data         => $ResponsibleUsers,
                    SelectedID   => $GetParam{NewResponsibleID},
                    Translation  => 1,
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
                    Translation  => 1,
                    Max          => 100,
                },
                {
                    Name         => 'SLAID',
                    Data         => $SLAs,
                    SelectedID   => $GetParam{SLAID},
                    PossibleNone => 1,
                    Translation  => 1,
                    Max          => 100,
                },
                @TicketFreeTextConfig,
            ],
        );
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/plain; charset=' . $Self->{LayoutObject}->{Charset},
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

    my %NextStates = ();
    if ( $Param{QueueID} || $Param{TicketID} ) {
        %NextStates = $Self->{TicketObject}->StateList(
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
    my %ShownUsers       = ();
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
            Cached  => 1,
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

    my %Priorities = ();

    # get priority
    if ( $Param{QueueID} || $Param{TicketID} ) {
        %Priorities = $Self->{TicketObject}->PriorityList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%Priorities;
}

sub _GetTypes {
    my ( $Self, %Param ) = @_;

    my %Type = ();

    # get priority
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

    my %Service = ();

    # get priority
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

    my %SLA = ();

    # get priority
    if ( $Param{ServiceID} ) {
        %SLA = $Self->{TicketObject}->TicketSLAList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%SLA;
}

sub _GetTos {
    my ( $Self, %Param ) = @_;

    # check own selection
    my %NewTos = ();
    if ( $Self->{ConfigObject}->{'Ticket::Frontend::NewQueueOwnSelection'} ) {
        %NewTos = %{ $Self->{ConfigObject}->{'Ticket::Frontend::NewQueueOwnSelection'} };
    }
    else {

        # SelectionType Queue or SystemAddress?
        my %Tos = ();
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
            Cached => 1,
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

    # adde empty selection
    $NewTos{''} = '-';
    return \%NewTos;
}

sub _GetSignature {
    my ( $Self, %Param ) = @_;

    my $Signature = '';
    my %Queue = $Self->{QueueObject}->GetSystemAddress( QueueID => $Param{QueueID} );

    # prepare signature
    $Signature = $Self->{QueueObject}->GetSignature( QueueID => $Param{QueueID} );
    $Signature =~ s/<OTRS_FIRST_NAME>/$Self->{UserFirstname}/g;
    $Signature =~ s/<OTRS_LAST_NAME>/$Self->{UserLastname}/g;

    # current user
    my %User = $Self->{UserObject}->GetUserData(
        UserID => $Self->{UserID},
        Cached => 1,
    );
    for my $UserKey ( keys %User ) {
        if ( $User{$UserKey} ) {
            $Signature =~ s/<OTRS_Agent_$UserKey>/$User{$UserKey}/gi;
            $Signature =~ s/<OTRS_CURRENT_$UserKey>/$User{$UserKey}/gi;
        }
    }

    # replace other needed stuff
    $Signature =~ s/<OTRS_FIRST_NAME>/$Self->{UserFirstname}/g;
    $Signature =~ s/<OTRS_LAST_NAME>/$Self->{UserLastname}/g;

    # cleanup
    $Signature =~ s/<OTRS_Agent_.+?>/-/gi;
    $Signature =~ s/<OTRS_CURRENT_.+?>/-/gi;

    # replace config options
    $Signature =~ s{<OTRS_CONFIG_(.+?)>}{$Self->{ConfigObject}->Get($1)}egx;
    $Signature =~ s/<OTRS_CONFIG_.+?>/-/gi;
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

    # build string
    $Param{Users}->{''} = '-';
    $Param{'OptionStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data       => $Param{Users},
        SelectedID => $Param{UserSelected},
        Name       => 'NewUserID',
    );

    # build next states string
    $Param{'NextStatesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data     => $Param{NextStates},
        Name     => 'NextStateID',
        Selected => $Param{NextState} || $Self->{Config}->{StateDefault},
    );

    # build from string
    if ( $Param{ToOptions} && %{ $Param{ToOptions} } ) {
        $Param{'CustomerUserStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => $Param{ToOptions},
            Name => 'CustomerUser',
            Max  => 70,
        );
    }

    # build so string
    my %NewTo = ();
    if ( $Param{FromList} ) {
        for ( keys %{ $Param{FromList} } ) {
            $NewTo{"$_||$Param{FromList}->{$_}"} = $Param{FromList}->{$_};
        }
    }
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::NewQueueSelectionType') eq 'Queue' ) {
        $Param{'FromStrg'} = $Self->{LayoutObject}->AgentQueueListOption(
            Data           => \%NewTo,
            Multiple       => 0,
            Size           => 0,
            Name           => 'Dest',
            SelectedID     => $Param{FromSelected},
            OnChangeSubmit => 0,
            OnChange =>
                "document.compose.ExpandCustomerName.value='3'; document.compose.submit(); return false;",
            Ajax => {
                Update => [
                    'Signature',
                    'NewUserID',
                    'NewResponsibleID',
                    'NextStateID',
                    'PriorityID',
                    'ServiceID',
                    'SLAID',
                    'TicketFreeText1',
                    'TicketFreeText2',
                    'TicketFreeText3',
                    'TicketFreeText4',
                    'TicketFreeText5',
                    'TicketFreeText6',
                    'TicketFreeText7',
                    'TicketFreeText8',
                    'TicketFreeText9',
                    'TicketFreeText10',
                    'TicketFreeText11',
                    'TicketFreeText12',
                    'TicketFreeText13',
                    'TicketFreeText14',
                    'TicketFreeText15',
                    'TicketFreeText16',
                ],
                Depend => [
                    'Dest',
                    'SelectedCustomerUser',
                    'NextStateID',
                    'PriorityID',
                    'ServiceID',
                    'SLAID',
                    'OwnerAll',
                    'ResponsibleAll',
                    'TicketFreeText1',
                    'TicketFreeText2',
                    'TicketFreeText3',
                    'TicketFreeText4',
                    'TicketFreeText5',
                    'TicketFreeText6',
                    'TicketFreeText7',
                    'TicketFreeText8',
                    'TicketFreeText9',
                    'TicketFreeText10',
                    'TicketFreeText11',
                    'TicketFreeText12',
                    'TicketFreeText13',
                    'TicketFreeText14',
                    'TicketFreeText15',
                    'TicketFreeText16',
                ],
                Subaction => 'AJAXUpdate',
            },
        );
    }
    else {
        $Param{'FromStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data       => \%NewTo,
            Name       => 'Dest',
            SelectedID => $Param{FromSelected},
            OnChange =>
                "document.compose.ExpandCustomerName.value='3'; document.compose.submit(); return false;",
            Ajax => {
                Update => [
                    'Signature',
                    'NewUserID',
                    'NewResponsibleID',
                    'NextStateID',
                    'PriorityID',
                    'ServiceID',
                    'SLAID',
                    'TicketFreeText1',
                    'TicketFreeText2',
                    'TicketFreeText3',
                    'TicketFreeText4',
                    'TicketFreeText5',
                    'TicketFreeText6',
                    'TicketFreeText7',
                    'TicketFreeText8',
                    'TicketFreeText9',
                    'TicketFreeText10',
                    'TicketFreeText11',
                    'TicketFreeText12',
                    'TicketFreeText13',
                    'TicketFreeText14',
                    'TicketFreeText15',
                    'TicketFreeText16',
                ],
                Depend => [
                    'Dest',
                    'SelectedCustomerUser',
                    'NextStateID',
                    'PriorityID',
                    'ServiceID',
                    'SLAID',
                    'OwnerAll',
                    'ResponsibleAll',
                    'TicketFreeText1',
                    'TicketFreeText2',
                    'TicketFreeText3',
                    'TicketFreeText4',
                    'TicketFreeText5',
                    'TicketFreeText6',
                    'TicketFreeText7',
                    'TicketFreeText8',
                    'TicketFreeText9',
                    'TicketFreeText10',
                    'TicketFreeText11',
                    'TicketFreeText12',
                    'TicketFreeText13',
                    'TicketFreeText14',
                    'TicketFreeText15',
                    'TicketFreeText16',
                ],
                Subaction => 'AJAXUpdate',
            },
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
            $Param{$_} = '* ' . $Self->{LayoutObject}->Ascii2Html( Text => $Param{Errors}->{$_} );
        }
    }

    # build type string
    if ( $Self->{ConfigObject}->Get('Ticket::Type') ) {
        $Param{'TypeStrg'} = $Self->{LayoutObject}->BuildSelection(
            Data         => $Param{Types},
            Name         => 'TypeID',
            SelectedID   => $Param{TypeID},
            PossibleNone => 1,
            Sort         => 'AlphanumericValue',
            Translation  => 0,
            OnChange =>
                "document.compose.ExpandCustomerName.value='3'; document.compose.submit(); return false;",
            Ajax => {
                Update => [
                    'NewUserID',
                    'NewResponsibleID',
                    'NextStateID',
                    'PriorityID',
                    'ServiceID',
                    'SLAID',
                    'TicketFreeText1',
                    'TicketFreeText2',
                    'TicketFreeText3',
                    'TicketFreeText4',
                    'TicketFreeText5',
                    'TicketFreeText6',
                    'TicketFreeText7',
                    'TicketFreeText8',
                    'TicketFreeText9',
                    'TicketFreeText10',
                    'TicketFreeText11',
                    'TicketFreeText12',
                    'TicketFreeText13',
                    'TicketFreeText14',
                    'TicketFreeText15',
                    'TicketFreeText16',
                ],
                Depend => [
                    'Dest',
                    'SelectedCustomerUser',
                    'NextStateID',
                    'PriorityID',
                    'ServiceID',
                    'SLAID',
                    'OwnerAll',
                    'ResponsibleAll',
                    'TicketFreeText1',
                    'TicketFreeText2',
                    'TicketFreeText3',
                    'TicketFreeText4',
                    'TicketFreeText5',
                    'TicketFreeText6',
                    'TicketFreeText7',
                    'TicketFreeText8',
                    'TicketFreeText9',
                    'TicketFreeText10',
                    'TicketFreeText11',
                    'TicketFreeText12',
                    'TicketFreeText13',
                    'TicketFreeText14',
                    'TicketFreeText15',
                    'TicketFreeText16',
                ],
                Subaction => 'AJAXUpdate',
                }
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketType',
            Data => {%Param},
        );
    }

    # build service string
    if ( $Self->{ConfigObject}->Get('Ticket::Service') ) {
        $Param{'ServiceStrg'} = $Self->{LayoutObject}->BuildSelection(
            Data         => $Param{Services},
            Name         => 'ServiceID',
            SelectedID   => $Param{ServiceID},
            PossibleNone => 1,
            TreeView     => $TreeView,
            Sort         => 'TreeView',
            Translation  => 0,
            Max          => 200,
            OnChange =>
                "document.compose.ExpandCustomerName.value='3'; document.compose.submit(); return false;",
            Ajax => {
                Update => [
                    'NewUserID',
                    'NewResponsibleID',
                    'NextStateID',
                    'PriorityID',
                    'ServiceID',
                    'SLAID',
                    'TicketFreeText1',
                    'TicketFreeText2',
                    'TicketFreeText3',
                    'TicketFreeText4',
                    'TicketFreeText5',
                    'TicketFreeText6',
                    'TicketFreeText7',
                    'TicketFreeText8',
                    'TicketFreeText9',
                    'TicketFreeText10',
                    'TicketFreeText11',
                    'TicketFreeText12',
                    'TicketFreeText13',
                    'TicketFreeText14',
                    'TicketFreeText15',
                    'TicketFreeText16',
                ],
                Depend => [
                    'Dest',
                    'SelectedCustomerUser',
                    'NextStateID',
                    'PriorityID',
                    'ServiceID',
                    'SLAID',
                    'OwnerAll',
                    'ResponsibleAll',
                    'TicketFreeText1',
                    'TicketFreeText2',
                    'TicketFreeText3',
                    'TicketFreeText4',
                    'TicketFreeText5',
                    'TicketFreeText6',
                    'TicketFreeText7',
                    'TicketFreeText8',
                    'TicketFreeText9',
                    'TicketFreeText10',
                    'TicketFreeText11',
                    'TicketFreeText12',
                    'TicketFreeText13',
                    'TicketFreeText14',
                    'TicketFreeText15',
                    'TicketFreeText16',
                ],
                Subaction => 'AJAXUpdate',
            },
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketService',
            Data => {%Param},
        );
        $Param{'SLAStrg'} = $Self->{LayoutObject}->BuildSelection(
            Data         => $Param{SLAs},
            Name         => 'SLAID',
            SelectedID   => $Param{SLAID},
            PossibleNone => 1,
            Sort         => 'AlphanumericValue',
            Translation  => 0,
            Max          => 200,
            OnChange =>
                "document.compose.ExpandCustomerName.value='3'; document.compose.submit(); return false;",
            Ajax => {
                Update => [
                    'NewUserID',
                    'NewResponsibleID',
                    'NextStateID',
                    'PriorityID',
                    'ServiceID',
                    'SLAID',
                    'TicketFreeText1',
                    'TicketFreeText2',
                    'TicketFreeText3',
                    'TicketFreeText4',
                    'TicketFreeText5',
                    'TicketFreeText6',
                    'TicketFreeText7',
                    'TicketFreeText8',
                    'TicketFreeText9',
                    'TicketFreeText10',
                    'TicketFreeText11',
                    'TicketFreeText12',
                    'TicketFreeText13',
                    'TicketFreeText14',
                    'TicketFreeText15',
                    'TicketFreeText16',
                ],
                Depend => [
                    'Dest',
                    'SelectedCustomerUser',
                    'NextStateID',
                    'PriorityID',
                    'ServiceID',
                    'SLAID',
                    'OwnerAll',
                    'ResponsibleAll',
                    'TicketFreeText1',
                    'TicketFreeText2',
                    'TicketFreeText3',
                    'TicketFreeText4',
                    'TicketFreeText5',
                    'TicketFreeText6',
                    'TicketFreeText7',
                    'TicketFreeText8',
                    'TicketFreeText9',
                    'TicketFreeText10',
                    'TicketFreeText11',
                    'TicketFreeText12',
                    'TicketFreeText13',
                    'TicketFreeText14',
                    'TicketFreeText15',
                    'TicketFreeText16',
                ],
                Subaction => 'AJAXUpdate',
            },
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
    $Param{'PriorityStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data       => $Param{Priorities},
        Name       => 'PriorityID',
        SelectedID => $Param{PriorityID},
        Selected   => $Param{Priority},
    );

    # pending data string
    $Param{PendingDateString} = $Self->{LayoutObject}->BuildDateSelection(
        %Param,
        Format => 'DateInputFormatLong',
        DiffTime => $Self->{ConfigObject}->Get('Ticket::Frontend::PendingDiffTime') || 0,
    );

    # from update
    if ( !$Self->{LayoutObject}->{BrowserJavaScriptSupport} ) {
        $Self->{LayoutObject}->Block(
            Name => 'FromUpdateSubmit',
            Data => \%Param,
        );
    }

    # show owner selection
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::NewOwnerSelection') ) {
        $Self->{LayoutObject}->Block(
            Name => 'OwnerSelection',
            Data => \%Param,
        );
        if ( $Self->{LayoutObject}->{BrowserJavaScriptSupport} ) {
            $Self->{LayoutObject}->Block(
                Name => 'OwnerSelectionAllJS',
                Data => {},
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'OwnerSelectionAllSubmit',
                Data => {},
            );
        }
    }

    # show responsible selection
    if (
        $Self->{ConfigObject}->Get('Ticket::Responsible')
        && $Self->{ConfigObject}->Get('Ticket::Frontend::NewResponsibleSelection')
        )
    {
        $Param{ResponsibleUsers}->{''} = '-';
        $Param{'ResponsibleOptionStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data       => $Param{ResponsibleUsers},
            SelectedID => $Param{ResponsibleUsersSelected},
            Name       => 'NewResponsibleID',
        );
        $Self->{LayoutObject}->Block(
            Name => 'ResponsibleSelection',
            Data => \%Param,
        );
        if ( $Self->{LayoutObject}->{BrowserJavaScriptSupport} ) {
            $Self->{LayoutObject}->Block(
                Name => 'ResponsibleSelectionAllJS',
                Data => {},
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'ResponsibleSelectionAllSubmit',
                Data => {},
            );
        }
    }

    # ticket free text
    for my $Count ( 1 .. 16 ) {
        if ( $Self->{Config}->{'TicketFreeText'}->{$Count} ) {
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
    }
    for my $Count ( 1 .. 6 ) {
        if ( $Self->{Config}->{'TicketFreeTime'}->{$Count} ) {
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
    }

    # article free text
    for my $Count ( 1 .. 3 ) {
        if ( $Self->{Config}->{'ArticleFreeText'}->{$Count} ) {
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
    }

    # show time accounting box
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::AccountTime') ) {
        $Self->{LayoutObject}->Block(
            Name => 'TimeUnitsJs',
            Data => \%Param,
        );
        $Self->{LayoutObject}->Block(
            Name => 'TimeUnits',
            Data => \%Param,
        );
    }

    # show spell check
    if (
        $Self->{ConfigObject}->Get('SpellChecker')
        && $Self->{LayoutObject}->{BrowserJavaScriptSupport}
        )
    {
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

    # show attachments
    for my $DataRef ( @{ $Param{Attachments} } ) {
        $Self->{LayoutObject}->Block(
            Name => 'Attachment',
            Data => $DataRef,
        );
    }

    # java script check for required free text fields by form submit
    for my $Key ( keys %{ $Self->{Config}->{TicketFreeText} } ) {
        if ( $Self->{Config}->{TicketFreeText}->{$Key} == 2 ) {
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeTextCheckJs',
                Data => {
                    TicketFreeTextField => "TicketFreeText$Key",
                    TicketFreeKeyField  => "TicketFreeKey$Key",
                },
            );
        }
    }

    # java script check for required free time fields by form submit
    for my $Key ( keys %{ $Self->{Config}->{TicketFreeTime} } ) {
        if ( $Self->{Config}->{TicketFreeTime}->{$Key} == 2 ) {
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeTimeCheckJs',
                Data => {
                    TicketFreeTimeCheck => 'TicketFreeTime' . $Key . 'Used',
                    TicketFreeTimeField => 'TicketFreeTime' . $Key,
                    TicketFreeTimeKey   => $Self->{ConfigObject}->Get( 'TicketFreeTimeKey' . $Key ),
                },
            );
        }
    }

    # get output back
    return $Self->{LayoutObject}->Output( TemplateFile => 'AgentTicketEmail', Data => \%Param );
}

1;
