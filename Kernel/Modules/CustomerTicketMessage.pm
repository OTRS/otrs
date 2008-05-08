# --
# Kernel/Modules/CustomerTicketMessage.pm - to handle customer messages
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: CustomerTicketMessage.pm,v 1.32 2008-05-08 09:36:37 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::CustomerTicketMessage;

use strict;
use warnings;

use Kernel::System::Web::UploadCache;
use Kernel::System::SystemAddress;
use Kernel::System::Queue;
use Kernel::System::State;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.32 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject TicketObject LayoutObject LogObject QueueObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    # needed objects
    $Self->{StateObject}      = Kernel::System::State->new(%Param);
    $Self->{SystemAddress}    = Kernel::System::SystemAddress->new(%Param);
    $Self->{QueueObject}      = Kernel::System::Queue->new(%Param);
    $Self->{UploadCachObject} = Kernel::System::Web::UploadCache->new(%Param);

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

    # get params
    my %GetParam = ();
    for (
        qw(
        Subject Body PriorityID TypeID ServiceID SLAID Expand
        AttachmentUpload
        AttachmentDelete1 AttachmentDelete2 AttachmentDelete3 AttachmentDelete4
        AttachmentDelete5 AttachmentDelete6 AttachmentDelete7 AttachmentDelete8
        AttachmentDelete9 AttachmentDelete10 )
        )
    {
        $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
    }

    if ( !$Self->{Subaction} ) {

        # get default selections
        my %TicketFreeDefault = ();
        for ( 1 .. 16 ) {
            $TicketFreeDefault{ 'TicketFreeKey' . $_ }
                = $Self->{ConfigObject}->Get( 'TicketFreeKey' . $_ . '::DefaultSelection' );
            $TicketFreeDefault{ 'TicketFreeText' . $_ }
                = $Self->{ConfigObject}->Get( 'TicketFreeText' . $_ . '::DefaultSelection' );
        }

        # get free text config options
        my %TicketFreeText = ();
        for ( 1 .. 16 ) {
            $TicketFreeText{"TicketFreeKey$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID       => $Self->{TicketID},
                Action         => $Self->{Action},
                Type           => "TicketFreeKey$_",
                CustomerUserID => $Self->{UserID},
            );
            $TicketFreeText{"TicketFreeText$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID       => $Self->{TicketID},
                Action         => $Self->{Action},
                Type           => "TicketFreeText$_",
                CustomerUserID => $Self->{UserID},
            );
        }
        my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
            Config => \%TicketFreeText,
            Ticket => {%TicketFreeDefault},
        );

        # get ticket free time params
        my %TicketFreeTime = ();
        for ( 1 .. 6 ) {
            for my $Type (qw(Used Year Month Day Hour Minute)) {
                $TicketFreeTime{ "TicketFreeTime" . $_ . $Type }
                    = $Self->{ParamObject}->GetParam( Param => "TicketFreeTime" . $_ . $Type );
            }
            $TicketFreeTime{ 'TicketFreeTime' . $_ . 'Optional' }
                = $Self->{ConfigObject}->Get( 'TicketFreeTimeOptional' . $_ ) || 0;
            if ( !$Self->{ConfigObject}->Get( 'TicketFreeTimeOptional' . $_ ) ) {
                $TicketFreeTime{ 'TicketFreeTime' . $_ . 'Used' } = 1;
            }
        }

        # free time
        my %FreeTime
            = $Self->{LayoutObject}->CustomerFreeDate( %Param, Ticket => \%TicketFreeTime, );

        # print form ...
        my $Output .= $Self->{LayoutObject}->CustomerHeader();
        $Output .= $Self->{LayoutObject}->CustomerNavigationBar();
        $Output .= $Self->_MaskNew( %TicketFreeTextHTML, %FreeTime, );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }
    elsif ( $Self->{Subaction} eq 'StoreNew' ) {
        my $NextScreen = $Self->{Config}->{NextScreenAfterNewTicket};
        my %Error      = ();

        # get dest queue
        my $Dest = $Self->{ParamObject}->GetParam( Param => 'Dest' ) || '';
        my ( $NewQueueID, $To ) = split( /\|\|/, $Dest );
        if ( !$To ) {
            $NewQueueID = $Self->{ParamObject}->GetParam( Param => 'NewQueueID' ) || '';
            $To = 'System';
        }

        # fallback, if no dest is given
        if ( !$NewQueueID ) {
            my $Queue = $Self->{ParamObject}->GetParam( Param => 'Queue' ) || '';
            if ($Queue) {
                my $QueueID = $Self->{QueueObject}->QueueLookup( Queue => $Queue );
                $NewQueueID = $QueueID;
                $To         = $Queue;
            }
        }
        my %TicketFree = ();
        for ( 1 .. 16 ) {
            $TicketFree{"TicketFreeKey$_"}
                = $Self->{ParamObject}->GetParam( Param => "TicketFreeKey$_" );
            $TicketFree{"TicketFreeText$_"}
                = $Self->{ParamObject}->GetParam( Param => "TicketFreeText$_" );
        }

        # get free text config options
        my %TicketFreeText = ();
        for ( 1 .. 16 ) {
            $TicketFreeText{"TicketFreeKey$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID       => $Self->{TicketID},
                Action         => $Self->{Action},
                Type           => "TicketFreeKey$_",
                CustomerUserID => $Self->{UserID},
            );
            $TicketFreeText{"TicketFreeText$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID       => $Self->{TicketID},
                Action         => $Self->{Action},
                Type           => "TicketFreeText$_",
                CustomerUserID => $Self->{UserID},
            );

            # check required FreeTextField (if configured)
            if (
                $Self->{Config}{'TicketFreeText'}{$_} == 2
                && $TicketFree{"TicketFreeText$_"} eq ''
                )
            {
                $Error{"TicketFreeTextField$_ invalid"} = '* invalid';
            }
        }
        my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
            Config => \%TicketFreeText,
            Ticket => {%TicketFree},
        );

        # get ticket free time params
        my %TicketFreeTime = ();
        for ( 1 .. 6 ) {
            for my $Type (qw(Used Year Month Day Hour Minute)) {
                $TicketFreeTime{ "TicketFreeTime" . $_ . $Type }
                    = $Self->{ParamObject}->GetParam( Param => "TicketFreeTime" . $_ . $Type );
            }
            $TicketFreeTime{ 'TicketFreeTime' . $_ . 'Optional' }
                = $Self->{ConfigObject}->Get( 'TicketFreeTimeOptional' . $_ ) || 0;
            if ( !$Self->{ConfigObject}->Get( 'TicketFreeTimeOptional' . $_ ) ) {
                $TicketFreeTime{ 'TicketFreeTime' . $_ . 'Used' } = 1;
            }
        }

        # free time
        my %FreeTime
            = $Self->{LayoutObject}->CustomerFreeDate( %Param, Ticket => \%TicketFreeTime, );

        # rewrap body if exists
        if ( $GetParam{Body} ) {
            $GetParam{Body}
                =~ s/(^>.+|.{4,$Self->{ConfigObject}->Get('Ticket::Frontend::TextAreaNote')})(?:\s|\z)/$1\n/gm;
        }

        # attachment delete
        for ( 1 .. 10 ) {
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
        my @Attachments
            = $Self->{UploadCachObject}->FormIDGetAllFilesMeta( FormID => $Self->{FormID}, );

        # check queue
        if ( !$NewQueueID ) {
            $Error{"Queue invalid"} = '* invalid';
        }

        # check subject
        if ( !$GetParam{Subject} ) {
            $Error{"Subject invalid"} = '* invalid';
        }

        # check body
        if ( !$GetParam{Body} ) {
            $Error{"Body invalid"} = '* invalid';
        }
        if ( $GetParam{Expand} ) {
            %Error = ();
            $Error{"Expand"} = 1;
        }
        if (%Error) {

            # html output
            my $Output .= $Self->{LayoutObject}->CustomerHeader();
            $Output    .= $Self->{LayoutObject}->CustomerNavigationBar();
            $Output    .= $Self->_MaskNew(
                Attachments => \@Attachments,
                %GetParam,
                ToSelected => $Dest,
                QueueID    => $NewQueueID,
                %TicketFreeTextHTML,
                %FreeTime,
                Errors => \%Error,
            );
            $Output .= $Self->{LayoutObject}->CustomerFooter();
            return $Output;
        }

        # if customer is not alown to set priority, set it to default
        if ( !$Self->{Config}->{Priority} ) {
            $GetParam{PriorityID} = '';
            $GetParam{Priority}   = $Self->{Config}->{PriorityDefault};
        }

        # create new ticket, do db insert
        my $TicketID = $Self->{TicketObject}->TicketCreate(
            QueueID      => $NewQueueID,
            TypeID       => $GetParam{TypeID} || '',
            ServiceID    => $GetParam{ServiceID} || '',
            SLAID        => $GetParam{SLAID} || '',
            Title        => $GetParam{Subject},
            PriorityID   => $GetParam{PriorityID} || '',
            Priority     => $GetParam{Priority} || '',
            Lock         => 'unlock',
            State        => $Self->{Config}->{StateDefault},
            CustomerID   => $Self->{UserCustomerID},
            CustomerUser => $Self->{UserLogin},
            OwnerID      => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
            UserID       => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
        );

        # set ticket free text
        for ( 1 .. 16 ) {
            if ( defined( $TicketFree{"TicketFreeKey$_"} ) ) {
                $Self->{TicketObject}->TicketFreeTextSet(
                    TicketID => $TicketID,
                    Key      => $TicketFree{"TicketFreeKey$_"},
                    Value    => $TicketFree{"TicketFreeText$_"},
                    Counter  => $_,
                    UserID   => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
                );
            }
        }

        # set ticket free time
        for ( 1 .. 6 ) {
            if (
                defined( $TicketFreeTime{ "TicketFreeTime" . $_ . "Year" } )
                && defined( $TicketFreeTime{ "TicketFreeTime" . $_ . "Month" } )
                && defined( $TicketFreeTime{ "TicketFreeTime" . $_ . "Day" } )
                && defined( $TicketFreeTime{ "TicketFreeTime" . $_ . "Hour" } )
                && defined( $TicketFreeTime{ "TicketFreeTime" . $_ . "Minute" } )
                )
            {
                my %Time;
                $Time{ "TicketFreeTime" . $_ . "Year" }    = 0;
                $Time{ "TicketFreeTime" . $_ . "Month" }   = 0;
                $Time{ "TicketFreeTime" . $_ . "Day" }     = 0;
                $Time{ "TicketFreeTime" . $_ . "Hour" }    = 0;
                $Time{ "TicketFreeTime" . $_ . "Minute" }  = 0;
                $Time{ "TicketFreeTime" . $_ . "Secunde" } = 0;

                if ( $TicketFreeTime{ "TicketFreeTime" . $_ . "Used" } ) {
                    %Time
                        = $Self->{LayoutObject}->TransfromDateSelection(
                        %TicketFreeTime, Prefix => "TicketFreeTime" . $_,
                        );
                }
                $Self->{TicketObject}->TicketFreeTimeSet(
                    %Time,
                    Prefix   => "TicketFreeTime",
                    TicketID => $TicketID,
                    Counter  => $_,
                    UserID   => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
                );
            }
        }

        # create article
        my $From = "$Self->{UserFirstname} $Self->{UserLastname} <$Self->{UserEmail}>";
        if (
            my $ArticleID = $Self->{TicketObject}->ArticleCreate(
                TicketID         => $TicketID,
                ArticleType      => $Self->{Config}->{ArticleType},
                SenderType       => $Self->{Config}->{SenderType},
                From             => $From,
                To               => $To,
                Subject          => $GetParam{Subject},
                Body             => $GetParam{Body},
                ContentType      => "text/plain; charset=$Self->{LayoutObject}->{'UserCharset'}",
                UserID           => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
                HistoryType      => $Self->{Config}->{HistoryType},
                HistoryComment   => $Self->{Config}->{HistoryComment} || '%%',
                AutoResponseType => 'auto reply',
                OrigHeader       => {
                    From    => $From,
                    To      => $Self->{UserLogin},
                    Subject => $GetParam{Subject},
                    Body    => $GetParam{Body},
                },
                Queue => $Self->{QueueObject}->QueueLookup( QueueID => $NewQueueID ),
            )
            )
        {

            # get pre loaded attachment
            my @AttachmentData
                = $Self->{UploadCachObject}->FormIDGetAllFilesData( FormID => $Self->{FormID}, );
            for my $Ref (@AttachmentData) {
                $Self->{TicketObject}->ArticleWriteAttachment(
                    %{$Ref},
                    ArticleID => $ArticleID,
                    UserID    => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
                );
            }

            # get submit attachment
            my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
                Param  => 'file_upload',
                Source => 'String',
            );
            if (%UploadStuff) {
                $Self->{TicketObject}->ArticleWriteAttachment(
                    %UploadStuff,
                    ArticleID => $ArticleID,
                    UserID    => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
                );
            }

            # remove pre submited attachments
            $Self->{UploadCachObject}->FormIDRemove( FormID => $Self->{FormID} );

            # redirect
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=$NextScreen&TicketID=$TicketID",
            );
        }
        else {
            my $Output = $Self->{LayoutObject}->CustomerHeader( Title => 'Error' );
            $Output .= $Self->{LayoutObject}->CustomerError();
            $Output .= $Self->{LayoutObject}->CustomerFooter();
            return $Output;
        }
    }
    else {
        my $Output = $Self->{LayoutObject}->CustomerHeader( Title => 'Error' );
        $Output .= $Self->{LayoutObject}->CustomerError(
            Message => 'No Subaction!!',
            Comment => 'Please contact your admin',
        );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }
}

sub _MaskNew {
    my ( $Self, %Param ) = @_;

    $Param{FormID} = $Self->{FormID};

    # get list type
    my $TreeView = 0;
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

    # check own selection
    my %NewTos = ( '', '-' );
    my $Module = $Self->{ConfigObject}->Get('CustomerPanel::NewTicketQueueSelectionModule')
        || 'Kernel::Output::HTML::CustomerNewTicketQueueSelectionGeneric';
    if ( $Self->{MainObject}->Require($Module) ) {
        my $Object = $Module->new( %{$Self}, Debug => $Self->{Debug}, );

        # log loaded module
        if ( $Self->{Debug} > 1 ) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message  => "Module: $Module loaded!",
            );
        }
        %NewTos = ( $Object->Run( Env => $Self ), ( '', => '-' ) );
    }
    else {
        return $Self->{LayoutObject}->FatalError();
    }

    # build to string
    if (%NewTos) {
        for ( keys %NewTos ) {
            $NewTos{"$_||$NewTos{$_}"} = $NewTos{$_};
            delete $NewTos{$_};
        }
    }
    $Param{'ToStrg'} = $Self->{LayoutObject}->AgentQueueListOption(
        Data       => \%NewTos,
        Multiple   => 0,
        Size       => 0,
        Name       => 'Dest',
        SelectedID => $Param{ToSelected},
        OnChange   => "document.compose.Expand.value='3'; document.compose.submit(); return false;",
    );

    # get priority
    if ( $Self->{Config}->{Priority} ) {
        my %Priorities = $Self->{TicketObject}->PriorityList(
            CustomerUserID => $Self->{UserID},
            Action         => $Self->{Action},
        );

        # build priority string
        my %PrioritySelected = ();
        if ( $Param{PriorityID} ) {
            $PrioritySelected{SelectedID} = $Param{PriorityID};
        }
        else {
            $PrioritySelected{Selected} = $Self->{Config}->{PriorityDefault} || '3 normal';
        }
        $Param{'PriorityStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => \%Priorities,
            Name => 'PriorityID',
            %PrioritySelected,
        );
        $Self->{LayoutObject}->Block(
            Name => 'Priority',
            Data => { %Param, },
        );
    }

    # types
    if ( $Self->{ConfigObject}->Get('Ticket::Type') ) {
        my %Type = $Self->{TicketObject}->TicketTypeList(
            %Param,
            Action         => $Self->{Action},
            CustomerUserID => $Self->{UserID},
        );
        $Param{'TypeStrg'} = $Self->{LayoutObject}->BuildSelection(
            Data         => \%Type,
            Name         => 'TypeID',
            SelectedID   => $Param{TypeID},
            PossibleNone => 1,
            Sort         => 'AlphanumericValue',
            Translation  => 0,
            OnChange =>
                "document.compose.Expand.value='3'; document.compose.submit(); return false;",
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketType',
            Data => {%Param},
        );
    }

    # services
    if ( $Self->{ConfigObject}->Get('Ticket::Service') ) {
        my %Service = ();
        if ( $Param{QueueID} || $Param{TicketID} ) {
            %Service = $Self->{TicketObject}->TicketServiceList(
                %Param,
                Action         => $Self->{Action},
                CustomerUserID => $Self->{UserID},
                UserID         => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
            );
        }
        $Param{'ServiceStrg'} = $Self->{LayoutObject}->BuildSelection(
            Data         => \%Service,
            Name         => 'ServiceID',
            SelectedID   => $Param{ServiceID},
            PossibleNone => 1,
            TreeView     => $TreeView,
            Sort         => 'TreeView',
            Translation  => 0,
            Max          => 200,
            OnChange =>
                "document.compose.Expand.value='3'; document.compose.submit(); return false;",
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketService',
            Data => {%Param},
        );
        my %SLA = ();
        if ( $Param{ServiceID} ) {
            %SLA = $Self->{TicketObject}->TicketSLAList(
                %Param,
                Action         => $Self->{Action},
                CustomerUserID => $Self->{UserID},
            );
        }
        $Param{'SLAStrg'} = $Self->{LayoutObject}->BuildSelection(
            Data         => \%SLA,
            Name         => 'SLAID',
            SelectedID   => $Param{SLAID},
            PossibleNone => 1,
            Sort         => 'AlphanumericValue',
            Translation  => 0,
            Max          => 200,
            OnChange =>
                "document.compose.Expand.value='3'; document.compose.submit(); return false;",
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketSLA',
            Data => {%Param},
        );
    }

    # prepare errors!
    if ( $Param{Errors} ) {
        for ( keys %{ $Param{Errors} } ) {
            $Param{$_} = $Self->{LayoutObject}->Ascii2Html( Text => $Param{Errors}->{$_} );
        }
    }

    # ticket free text
    for my $Count ( 1 .. 16 ) {
        if ( $Self->{Config}->{'TicketFreeText'}->{$Count} ) {
            $Self->{LayoutObject}->Block(
                Name => 'FreeText',
                Data => {
                    TicketFreeKeyField  => $Param{ 'TicketFreeKeyField' . $Count },
                    TicketFreeTextField => $Param{ 'TicketFreeTextField' . $Count },
                    Count               => $Count,
                    %Param,
                },
            );
            $Self->{LayoutObject}->Block(
                Name => 'FreeText' . $Count,
                Data => { %Param, Count => $Count, },
            );
        }
    }
    for my $Count ( 1 .. 6 ) {
        if ( $Self->{Config}->{'TicketFreeTime'}->{$Count} ) {
            $Self->{LayoutObject}->Block(
                Name => 'FreeTime',
                Data => {
                    TicketFreeTimeKey => $Self->{ConfigObject}->Get( 'TicketFreeTimeKey' . $Count ),
                    TicketFreeTime    => $Param{ 'TicketFreeTime' . $Count },
                    Count             => $Count,
                },
            );
            $Self->{LayoutObject}->Block(
                Name => 'FreeTime' . $Count,
                Data => { %Param, Count => $Count, },
            );
        }
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
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'CustomerTicketMessage',
        Data         => \%Param,
    );
}

1;
