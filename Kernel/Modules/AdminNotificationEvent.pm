# --
# Kernel/Modules/AdminNotificationEvent.pm - to add/update/delete state
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: AdminNotificationEvent.pm,v 1.5.2.1 2009-11-16 08:46:38 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminNotificationEvent;

use strict;
use warnings;

use Kernel::System::NotificationEvent;
use Kernel::System::Priority;
use Kernel::System::Lock;
use Kernel::System::Service;
use Kernel::System::SLA;
use Kernel::System::State;
use Kernel::System::Type;
use Kernel::System::Valid;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5.2.1 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(ParamObject DBObject LayoutObject ConfigObject LogObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    $Self->{NotificationEventObject} = Kernel::System::NotificationEvent->new(%Param);

    $Self->{PriorityObject} = Kernel::System::Priority->new(%Param);
    $Self->{StateObject}    = Kernel::System::State->new(%Param);
    $Self->{LockObject}     = Kernel::System::Lock->new(%Param);
    $Self->{ServiceObject}  = Kernel::System::Service->new(%Param);
    $Self->{SLAObject}      = Kernel::System::SLA->new(%Param);
    $Self->{TypeObject}     = Kernel::System::Type->new(%Param);
    $Self->{ValidObject}    = Kernel::System::Valid->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {
        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' ) || '';
        my %Data = $Self->{NotificationEventObject}->NotificationGet( ID => $ID );
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_Edit(
            Action => 'Change',
            %Data,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminNotificationEventForm',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # change action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        #        $Self->{LayoutObject}->ChallengeTokenCheck();

        my %GetParam;
        for (qw(ID Name Subject Body Type Charset ValidID)) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) || '';
        }
        for (
            qw(Recipients RecipientAgents RecipientEmail Events StateID QueueID PriorityID LockID TypeID ServiceID SLAID CustomerID CustomerUserID ArticleTypeID ArticleSubjectMatch ArticleBodyMatch ArticleAttachmentInclude)
            )
        {
            my @Data = $Self->{ParamObject}->GetArray( Param => $_ );
            next if !@Data;
            $GetParam{Data}->{$_} = \@Data;
        }

        # get free field params
        for my $Count ( 1 .. 16 ) {
            my $Key = "TicketFreeKey$Count";
            my @Keys = $Self->{ParamObject}->GetArray( Param => $Key );
            if (@Keys) {
                $GetParam{Data}->{$Key} = \@Keys;
            }
            my $Value = "TicketFreeText$Count";
            my @Values = $Self->{ParamObject}->GetArray( Param => $Value );
            if (@Values) {
                $GetParam{Data}->{$Value} = \@Values;
            }
        }

        # update
        my $Ok = $Self->{NotificationEventObject}->NotificationUpdate(
            %GetParam,
            Charset => $Self->{LayoutObject}->{UserCharset},
            Type    => 'text/plain',
            UserID  => $Self->{UserID},
        );
        if ($Ok) {
            $Self->_Overview();
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Notify( Info => 'Updated!' );
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminNotificationEventForm',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        else {
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Notify( Priority => 'Error' );
            $Self->_Edit(
                Action => 'Change',
                %GetParam,
            );
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminNotificationEventForm',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }

    # ------------------------------------------------------------ #
    # add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Add' ) {
        my %GetParam = ();
        for (qw(Name)) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
        }
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_Edit(
            Action => 'Add',
            %GetParam,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminNotificationEventForm',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # challenge token check for write action
        #        $Self->{LayoutObject}->ChallengeTokenCheck();

        my %GetParam;
        for (qw(Name Subject Body ValidID)) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) || '';
        }
        for (
            qw(Recipients RecipientAgents RecipientEmail Events StateID QueueID PriorityID LockID TypeID ServiceID SLAID CustomerID CustomerUserID ArticleTypeID ArticleSubjectMatch ArticleBodyMatch ArticleAttachmentInclude)
            )
        {
            my @Data = $Self->{ParamObject}->GetArray( Param => $_ );
            next if !@Data;
            $GetParam{Data}->{$_} = \@Data;
        }

        # get free field params
        for my $Count ( 1 .. 16 ) {
            my $Key = "TicketFreeKey$Count";
            my @Keys = $Self->{ParamObject}->GetArray( Param => $Key );
            if (@Keys) {
                $GetParam{Data}->{$Key} = \@Keys;
            }
            my $Value = "TicketFreeText$Count";
            my @Values = $Self->{ParamObject}->GetArray( Param => $Value );
            if (@Values) {
                $GetParam{Data}->{$Value} = \@Values;
            }
        }

        # add
        my $ID = $Self->{NotificationEventObject}->NotificationAdd(
            %GetParam,
            Charset => $Self->{LayoutObject}->{UserCharset},
            Type    => 'text/plain',
            UserID  => $Self->{UserID},
        );
        if ($ID) {
            $Self->_Overview();
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Notify( Info => 'Added!' );
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminNotificationEventForm',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        else {
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Notify( Priority => 'Error' );
            $Self->_Edit(
                Action => 'Add',
                %GetParam,
            );
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminNotificationEventForm',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }

    # ------------------------------------------------------------ #
    # delete
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Delete' ) {

        my %GetParam;
        for (qw(ID)) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) || '';
        }

        my $Delete = $Self->{NotificationEventObject}->NotificationDelete(
            ID     => $GetParam{ID},
            UserID => $Self->{UserID},
        );
        if ( !$Delete ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }
        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------
    # overview
    # ------------------------------------------------------------
    else {
        $Self->_Overview();
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminNotificationEventForm',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

}

sub _Edit {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $Param{RecipientsStrg} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {

            #            Agent                 => 'Agent',
            AgentOwner            => 'Agent (Owner)',
            AgentResponsible      => 'Agent (Responsible)',
            AgentWritePermissions => 'Agent (All with write permissions)',
            Customer              => 'Customer',
        },
        Name               => 'Recipients',
        Multiple           => 1,
        Size               => 4,
        SelectedIDRefArray => $Param{Data}->{Recipients},
    );

    my %AllAgents = $Self->{UserObject}->UserList(
        Type  => 'Long',
        Valid => 1,
    );
    $Param{RecipientAgentsStrg} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data               => \%AllAgents,
        Name               => 'RecipientAgents',
        Multiple           => 1,
        Size               => 4,
        SelectedIDRefArray => $Param{Data}->{RecipientAgents},
    );

    $Param{EventsStrg} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            TicketStateUpdate         => 'TicketStateUpdate',
            TicketQueueUpdate         => 'TicketQueueUpdate',
            TicketCreate              => 'TicketCreate',
            TicketTitleUpdate         => 'TicketTitleUpdate',
            TicketTypeUpdate          => 'TicketTypeUpdate',
            TicketServiceUpdate       => 'TicketServiceUpdate',
            TicketSLAUpdate           => 'TicketSLAUpdate',
            TicketDelete              => 'TicketDelete',
            TicketUnlockTimeoutUpdate => 'TicketUnlockTimeoutUpdate',
            TicketCustomerUpdate      => 'TicketCustomerUpdate',
            TicketFreeTextUpdate      => 'TicketFreeTextUpdate',
            TicketFreeTimeUpdate      => 'TicketFreeTimeUpdate',
            TicketPendingTimeUpdate   => 'TicketPendingTimeUpdate',
            TicketLockUpdate          => 'TicketLockUpdate',
            TicketOwnerUpdate         => 'TicketOwnerUpdate',
            TicketResponsibleUpdate   => 'TicketResponsibleUpdate',
            TicketPriorityUpdate      => 'TicketPriorityUpdate',
            TicketSubscribe           => 'TicketSubscribe',
            TicketUnsubscribe         => 'TicketUnsubscribe',
            TicketAccountTime         => 'TicketAccountTime',
            TicketMerge               => 'TicketMerge',
            ArticleCreate             => 'ArticleCreate',
            ArticleFreeTextUpdate     => 'ArticleFreeTextUpdate',
            ArticleSend               => 'ArticleSend',
            ArticleBounce             => 'ArticleBounce',
        },
        Name               => 'Events',
        Multiple           => 1,
        Size               => 5,
        SelectedIDRefArray => $Param{Data}->{Events},
    );

    $Param{StatesStrg} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            $Self->{StateObject}->StateList(
                UserID => 1,
                Action => $Self->{Action},
            ),
        },
        Name               => 'StateID',
        Multiple           => 1,
        Size               => 5,
        SelectedIDRefArray => $Param{Data}->{StateID},
    );

    $Param{QueuesStrg} = $Self->{LayoutObject}->AgentQueueListOption(
        Data               => { $Self->{QueueObject}->GetAllQueues(), },
        Size               => 5,
        Multiple           => 1,
        Name               => 'QueueID',
        SelectedIDRefArray => $Param{Data}->{QueueID},
        OnChangeSubmit     => 0,
    );

    $Param{PrioritiesStrg} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            $Self->{PriorityObject}->PriorityList(
                UserID => 1,
                Action => $Self->{Action},
            ),
        },
        Name               => 'PriorityID',
        Multiple           => 1,
        Size               => 5,
        SelectedIDRefArray => $Param{Data}->{PriorityID},
    );

    $Param{LocksStrg} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            $Self->{LockObject}->LockList(
                UserID => 1,
                Action => $Self->{Action},
            ),
        },
        Name               => 'LockID',
        Multiple           => 1,
        Size               => 3,
        SelectedIDRefArray => $Param{Data}->{LockID},
    );

    $Param{ValidOption} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data       => { $Self->{ValidObject}->ValidList(), },
        Name       => 'ValidID',
        SelectedID => $Param{ValidID},
    );
    $Self->{LayoutObject}->Block(
        Name => 'OverviewUpdate',
        Data => \%Param,
    );

    # build type string
    if ( $Self->{ConfigObject}->Get('Ticket::Type') ) {
        my %Type = $Self->{TypeObject}->TypeList( UserID => $Self->{UserID}, );
        $Param{TypesStrg} = $Self->{LayoutObject}->BuildSelection(
            Data        => \%Type,
            Name        => 'TypeID',
            SelectedID  => $Param{Data}->{TypeID},
            Sort        => 'AlphanumericValue',
            Size        => 3,
            Multiple    => 1,
            Translation => 0,
        );
        $Self->{LayoutObject}->Block(
            Name => 'OverviewUpdateType',
            Data => \%Param,
        );
    }

    # build service string
    if ( $Self->{ConfigObject}->Get('Ticket::Service') ) {

        # get list type
        my $TreeView = 0;
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::ListType') eq 'tree' ) {
            $TreeView = 1;
        }
        my %Service = $Self->{ServiceObject}->ServiceList( UserID => $Self->{UserID}, );
        $Param{ServicesStrg} = $Self->{LayoutObject}->BuildSelection(
            Data        => \%Service,
            Name        => 'ServiceID',
            SelectedID  => $Param{Data}->{ServiceID},
            TreeView    => $TreeView,
            Sort        => 'TreeView',
            Size        => 5,
            Multiple    => 1,
            Translation => 0,
            Max         => 200,
        );
        my %SLA = $Self->{SLAObject}->SLAList( UserID => $Self->{UserID}, );
        $Param{SLAsStrg} = $Self->{LayoutObject}->BuildSelection(
            Data        => \%SLA,
            Name        => 'SLAID',
            SelectedID  => $Param{Data}->{SLAID},
            Sort        => 'AlphanumericValue',
            Size        => 5,
            Multiple    => 1,
            Translation => 0,
            Max         => 200,
        );
        $Self->{LayoutObject}->Block(
            Name => 'OverviewUpdateService',
            Data => \%Param,
        );
    }

    # get free text config options
    my %TicketFreeText;
    my %TicketFreeTextData;
    for my $Count ( 1 .. 16 ) {
        $TicketFreeText{ 'TicketFreeKey' . $Count } = $Self->{TicketObject}->TicketFreeTextGet(
            Type   => 'TicketFreeKey' . $Count,
            FillUp => 1,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
        $TicketFreeText{ 'TicketFreeText' . $Count } = $Self->{TicketObject}->TicketFreeTextGet(
            Type   => 'TicketFreeText' . $Count,
            FillUp => 1,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
        $TicketFreeTextData{ 'TicketFreeKey' . $Count }
            = $Param{Data}->{ 'TicketFreeKey' . $Count };
        $TicketFreeTextData{ 'TicketFreeText' . $Count }
            = $Param{Data}->{ 'TicketFreeText' . $Count };
    }

    # generate the free text fields
    my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
        Config     => \%TicketFreeText,
        Ticket     => \%TicketFreeTextData,
        NullOption => 1,
    );

    # Free field settings
    for my $Count ( 1 .. 16 ) {

        next if ref $Self->{ConfigObject}->Get( 'TicketFreeKey' . $Count ) ne 'HASH';

        # output free text field
        $Self->{LayoutObject}->Block(
            Name => 'OverviewUpdateTicketFreeFieldElement',
            Data => {
                TicketFreeKey  => $TicketFreeTextHTML{ 'TicketFreeKeyField' . $Count },
                TicketFreeText => $TicketFreeTextHTML{ 'TicketFreeTextField' . $Count },
            },
        );
    }

    $Param{ArticleTypesStrg} = $Self->{LayoutObject}->BuildSelection(
        Data => { $Self->{TicketObject}->ArticleTypeList( Result => 'HASH' ), },
        Name => 'ArticleTypeID',
        SelectedID  => $Param{Data}->{ArticleTypeID},
        Size        => 5,
        Multiple    => 1,
        Translation => 1,
        Max         => 200,
    );

    $Param{ArticleAttachmentIncludeStrg} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            0 => 'No',
            1 => 'Yes',
        },
        Name        => 'ArticleAttachmentInclude',
        SelectedID  => $Param{Data}->{ArticleAttachmentInclude} || 0,
        Translation => 1,
        Max         => 200,
    );

    # take over data fields
    for my $Key (qw(RecipientEmail CustomerID CustomerUserID ArticleSubjectMatch ArticleBodyMatch))
    {
        next if !$Param{Data}->{$Key};
        next if !defined $Param{Data}->{$Key}->[0];
        $Param{$Key} = $Param{Data}->{$Key}->[0];
    }

    return 1;
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );
    $Self->{LayoutObject}->Block(
        Name => 'OverviewResult',
        Data => \%Param,
    );
    my %List = $Self->{NotificationEventObject}->NotificationList();

    # get valid list
    my %ValidList = $Self->{ValidObject}->ValidList();
    my $CssClass  = '';
    for ( sort { $List{$a} cmp $List{$b} } keys %List ) {

        # set output class
        if ( $CssClass && $CssClass eq 'searchactive' ) {
            $CssClass = 'searchpassive';
        }
        else {
            $CssClass = 'searchactive';
        }
        my %Data = $Self->{NotificationEventObject}->NotificationGet( ID => $_, );
        $Self->{LayoutObject}->Block(
            Name => 'OverviewResultRow',
            Data => {
                Valid    => $ValidList{ $Data{ValidID} },
                CssClass => $CssClass,
                %Data,
            },
        );
    }
    return 1;
}

1;
