# --
# Kernel/Modules/AdminNotificationEvent.pm - to manage event-based notifications
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# $Id: AdminNotificationEvent.pm,v 1.28.2.2 2011-05-24 11:46:16 mb Exp $
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
$VERSION = qw($Revision: 1.28.2.2 $) [1];

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
            TemplateFile => 'AdminNotificationEvent',
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
        for (qw(ID Name Subject Body Type Charset Comment ValidID Events)) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) || '';
        }
        for (
            qw(Recipients RecipientAgents RecipientGroups RecipientRoles RecipientEmail Events StateID QueueID PriorityID LockID TypeID ServiceID SLAID CustomerID CustomerUserID ArticleTypeID ArticleSubjectMatch ArticleBodyMatch ArticleAttachmentInclude NotificationArticleTypeID)
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
                TemplateFile => 'AdminNotificationEvent',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        else {
            for (qw(Name Events Subject Body)) {
                $GetParam{ $_ . "ServerError" } = "";
                if ( $GetParam{$_} eq '' ) {
                    $GetParam{ $_ . "ServerError" } = "ServerError";
                }
            }
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Notify( Priority => 'Error' );
            $Self->_Edit(
                Action => 'Change',
                %GetParam,
            );
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminNotificationEvent',
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
            TemplateFile => 'AdminNotificationEvent',
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
        for (qw(Name Subject Body Comment ValidID Events)) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) || '';
        }
        for (
            qw(Recipients RecipientRoles RecipientGroups RecipientAgents RecipientEmail Events StateID QueueID PriorityID LockID TypeID ServiceID SLAID CustomerID CustomerUserID ArticleTypeID ArticleSubjectMatch ArticleBodyMatch ArticleAttachmentInclude NotificationArticleTypeID)
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
                TemplateFile => 'AdminNotificationEvent',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        else {
            for (qw(Name Events Subject Body)) {
                $GetParam{ $_ . "ServerError" } = "";
                if ( $GetParam{$_} eq '' ) {
                    $GetParam{ $_ . "ServerError" } = "ServerError";
                }
            }
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Notify( Priority => 'Error' );
            $Self->_Edit(
                Action => 'Add',
                %GetParam,
            );
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminNotificationEvent',
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
            TemplateFile => 'AdminNotificationEvent',
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

    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionOverview' );

    $Param{RecipientsStrg} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            AgentOwner            => 'Agent (Owner)',
            AgentResponsible      => 'Agent (Responsible)',
            AgentWritePermissions => 'Agent (All with write permissions)',
            Customer              => 'Customer',
        },
        Name       => 'Recipients',
        Multiple   => 1,
        Size       => 4,
        SelectedID => $Param{Data}->{Recipients},
    );

    my %AllAgents = $Self->{UserObject}->UserList(
        Type  => 'Long',
        Valid => 1,
    );
    $Param{RecipientAgentsStrg} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%AllAgents,
        Name       => 'RecipientAgents',
        Multiple   => 1,
        Size       => 4,
        SelectedID => $Param{Data}->{RecipientAgents},
    );
    $Param{RecipientGroupsStrg} = $Self->{LayoutObject}->BuildSelection(
        Data => { $Self->{GroupObject}->GroupList( Valid => 1 ) },
        Size => 6,
        Name => 'RecipientGroups',
        Multiple   => 1,
        SelectedID => $Param{Data}->{RecipientGroups},
    );
    $Param{RecipientRolesStrg} = $Self->{LayoutObject}->BuildSelection(
        Data => { $Self->{GroupObject}->RoleList( Valid => 1 ) },
        Size => 6,
        Name => 'RecipientRoles',
        Multiple   => 1,
        SelectedID => $Param{Data}->{RecipientRoles},
    );

    # Set class name for event string...
    my $EventClass = 'Validate_Required';
    if ( $Param{EventsServerError} ) {
        $EventClass .= ' ' . $Param{EventsServerError};
    }

    # Build the list...
    $Param{EventsStrg} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            TicketStateUpdate         => 'TicketStateUpdate',
            TicketQueueUpdate         => 'TicketQueueUpdate',
            TicketCreate              => 'TicketCreate',
            TicketTitleUpdate         => 'TicketTitleUpdate',
            TicketTypeUpdate          => 'TicketTypeUpdate',
            TicketServiceUpdate       => 'TicketServiceUpdate',
            TicketSLAUpdate           => 'TicketSLAUpdate',
            TicketUnlockTimeoutUpdate => 'TicketUnlockTimeoutUpdate',
            TicketCustomerUpdate      => 'TicketCustomerUpdate',
            TicketFreeTextUpdate1     => 'TicketFreeTextUpdate1',
            TicketFreeTextUpdate2     => 'TicketFreeTextUpdate2',
            TicketFreeTextUpdate3     => 'TicketFreeTextUpdate3',
            TicketFreeTextUpdate4     => 'TicketFreeTextUpdate4',
            TicketFreeTextUpdate5     => 'TicketFreeTextUpdate5',
            TicketFreeTextUpdate6     => 'TicketFreeTextUpdate6',
            TicketFreeTextUpdate7     => 'TicketFreeTextUpdate7',
            TicketFreeTextUpdate8     => 'TicketFreeTextUpdate8',
            TicketFreeTextUpdate9     => 'TicketFreeTextUpdate9',
            TicketFreeTextUpdate10    => 'TicketFreeTextUpdate10',
            TicketFreeTextUpdate11    => 'TicketFreeTextUpdate11',
            TicketFreeTextUpdate12    => 'TicketFreeTextUpdate12',
            TicketFreeTextUpdate13    => 'TicketFreeTextUpdate13',
            TicketFreeTextUpdate14    => 'TicketFreeTextUpdate14',
            TicketFreeTextUpdate15    => 'TicketFreeTextUpdate15',
            TicketFreeTextUpdate16    => 'TicketFreeTextUpdate16',
            TicketFreeTimeUpdate1     => 'TicketFreeTimeUpdate1',
            TicketFreeTimeUpdate2     => 'TicketFreeTimeUpdate2',
            TicketFreeTimeUpdate3     => 'TicketFreeTimeUpdate3',
            TicketFreeTimeUpdate4     => 'TicketFreeTimeUpdate4',
            TicketFreeTimeUpdate5     => 'TicketFreeTimeUpdate5',
            TicketFreeTimeUpdate6     => 'TicketFreeTimeUpdate6',
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
        Name       => 'Events',
        Multiple   => 1,
        Size       => 5,
        Class      => $EventClass,
        SelectedID => $Param{Data}->{Events},
    );

    $Param{StatesStrg} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            $Self->{StateObject}->StateList(
                UserID => 1,
                Action => $Self->{Action},
            ),
        },
        Name       => 'StateID',
        Multiple   => 1,
        Size       => 5,
        SelectedID => $Param{Data}->{StateID},
    );

    $Param{QueuesStrg} = $Self->{LayoutObject}->AgentQueueListOption(
        Data               => { $Self->{QueueObject}->GetAllQueues(), },
        Size               => 5,
        Multiple           => 1,
        Name               => 'QueueID',
        SelectedIDRefArray => $Param{Data}->{QueueID},
        OnChangeSubmit     => 0,
    );

    $Param{PrioritiesStrg} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            $Self->{PriorityObject}->PriorityList(
                UserID => 1,
                Action => $Self->{Action},
            ),
        },
        Name       => 'PriorityID',
        Multiple   => 1,
        Size       => 5,
        SelectedID => $Param{Data}->{PriorityID},
    );

    $Param{LocksStrg} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            $Self->{LockObject}->LockList(
                UserID => 1,
                Action => $Self->{Action},
            ),
        },
        Name       => 'LockID',
        Multiple   => 1,
        Size       => 3,
        SelectedID => $Param{Data}->{LockID},
    );

    # get valid list
    my %ValidList        = $Self->{ValidObject}->ValidList();
    my %ValidListReverse = reverse %ValidList;

    $Param{ValidOption} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $Param{ValidID} || $ValidListReverse{valid},
    );
    $Self->{LayoutObject}->Block(
        Name => 'OverviewUpdate',
        Data => \%Param,
    );

    # shows header
    if ( $Param{Action} eq 'Change' ) {
        $Self->{LayoutObject}->Block( Name => 'HeaderEdit' );
    }
    else {
        $Self->{LayoutObject}->Block( Name => 'HeaderAdd' );
    }

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
        my %Service = $Self->{ServiceObject}->ServiceList( UserID => $Self->{UserID}, );
        $Param{ServicesStrg} = $Self->{LayoutObject}->BuildSelection(
            Data        => \%Service,
            Name        => 'ServiceID',
            SelectedID  => $Param{Data}->{ServiceID},
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
                ID             => 'TicketFreeText' . $Count,
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

    # Display article types for article creation if notification is sent
    # only use 'email-notification-*'-type articles
    my %NotificationArticleTypes = $Self->{TicketObject}->ArticleTypeList( Result => 'HASH' );
    for my $NotifArticleTypeID ( keys %NotificationArticleTypes ) {
        if ( $NotificationArticleTypes{$NotifArticleTypeID} !~ /^email-notification-/ ) {
            delete $NotificationArticleTypes{$NotifArticleTypeID};
        }
    }
    $Param{NotificationArticleTypesStrg} = $Self->{LayoutObject}->BuildSelection(
        Data        => \%NotificationArticleTypes,
        Name        => 'NotificationArticleTypeID',
        Translation => 1,
        SelectedID  => $Param{Data}->{NotificationArticleTypeID},
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

    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionAdd' );

    $Self->{LayoutObject}->Block(
        Name => 'OverviewResult',
        Data => \%Param,
    );
    my %List = $Self->{NotificationEventObject}->NotificationList();

    # if there are any notifications, they are shown
    if (%List) {

        # get valid list
        my %ValidList = $Self->{ValidObject}->ValidList();
        for ( sort { $List{$a} cmp $List{$b} } keys %List ) {

            my %Data = $Self->{NotificationEventObject}->NotificationGet( ID => $_, );
            $Self->{LayoutObject}->Block(
                Name => 'OverviewResultRow',
                Data => {
                    Valid => $ValidList{ $Data{ValidID} },
                    %Data,
                },
            );
        }
    }

    # otherwise a no data found msg is displayed
    else {
        $Self->{LayoutObject}->Block(
            Name => 'NoDataFoundMsg',
            Data => {},
        );
    }
    return 1;
}

1;
