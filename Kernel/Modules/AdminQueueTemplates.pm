# --
# Kernel/Modules/AdminQueueTemplates.pm - to manage queue <-> templates assignments
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminQueueTemplates;

use strict;
use warnings;

use Kernel::System::Queue;
use Kernel::System::StandardTemplate;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    $Self->{QueueObject}            = Kernel::System::Queue->new(%Param);
    $Self->{StandardTemplateObject} = Kernel::System::StandardTemplate->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # ------------------------------------------------------------ #
    # template <-> queues 1:n
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Template' ) {

        # get template data
        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );
        my %StandardTemplateData
            = $Self->{StandardTemplateObject}->StandardTemplateGet( ID => $ID );

        # get queues
        my %QueueData = $Self->{QueueObject}->QueueList( Valid => 1 );

        # get assigned queues
        my %Member = $Self->{QueueObject}->QueueStandardTemplateMemberList(
            StandardTemplateID => $ID,
        );

        my $StandardTemplateType = $Self->{LayoutObject}->{LanguageObject}->Get(
            $StandardTemplateData{TemplateType},
        );

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Change(
            Selected => \%Member,
            Data     => \%QueueData,
            ID       => $StandardTemplateData{ID},
            Name     => $StandardTemplateType . ' - ' . $StandardTemplateData{Name},
            Type     => 'Template',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # templates <-> Queue n:1
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Queue' ) {

        # get queue data
        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );
        my %QueueData = $Self->{QueueObject}->QueueGet( ID => $ID );

        # get templates
        my %StandardTemplateData = $Self->{StandardTemplateObject}->StandardTemplateList(
            Valid => 1,
        );

        if (%StandardTemplateData) {
            for my $StandardTemplateID ( sort keys %StandardTemplateData ) {
                my %Data = $Self->{StandardTemplateObject}->StandardTemplateGet(
                    ID => $StandardTemplateID
                );
                $StandardTemplateData{$StandardTemplateID}
                    = $Self->{LayoutObject}->{LanguageObject}->Get( $Data{TemplateType} )
                    . ' - '
                    . $Data{Name};
            }
        }

        # get assigned templates
        my %Member = $Self->{QueueObject}->QueueStandardTemplateMemberList(
            QueueID => $ID,
        );

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Change(
            Selected => \%Member,
            Data     => \%StandardTemplateData,
            ID       => $QueueData{QueueID},
            Name     => $QueueData{Name},
            Type     => 'Queue',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add templates to queue
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeQueue' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # get new templates
        my @TemplatesSelected
            = $Self->{ParamObject}->GetArray( Param => 'ItemsSelected' );
        my @TemplatesAll
            = $Self->{ParamObject}->GetArray( Param => 'ItemsAll' );

        my $QueueID = $Self->{ParamObject}->GetParam( Param => 'ID' );

        # create hash with selected templates
        my %TemplatesSelected = map { $_ => 1 } @TemplatesSelected;

        # check all used templates
        for my $TemplateID (@TemplatesAll) {
            my $Active = $TemplatesSelected{$TemplateID} ? 1 : 0;

            # set customer user service member
            $Self->{QueueObject}->QueueStandardTemplateMemberAdd(
                QueueID            => $QueueID,
                StandardTemplateID => $TemplateID,
                Active             => $Active,
                UserID             => $Self->{UserID},
            );
        }
    }

    # ------------------------------------------------------------ #
    # add queues to template
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeTemplate' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # get new queues
        my @QueuesSelected
            = $Self->{ParamObject}->GetArray( Param => 'ItemsSelected' );
        my @QueuesAll
            = $Self->{ParamObject}->GetArray( Param => 'ItemsAll' );

        my $TemplateID = $Self->{ParamObject}->GetParam( Param => 'ID' );

        # create hash with selected queues
        my %QueuesSelected = map { $_ => 1 } @QueuesSelected;

        # check all used queues
        for my $QueueID (@QueuesAll) {
            my $Active = $QueuesSelected{$QueueID} ? 1 : 0;

            # set customer user service member
            $Self->{QueueObject}->QueueStandardTemplateMemberAdd(
                QueueID            => $QueueID,
                StandardTemplateID => $TemplateID,
                Active             => $Active,
                UserID             => $Self->{UserID},
            );
        }

        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Output .= $Self->_Overview();
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

sub _Change {
    my ( $Self, %Param ) = @_;

    my %Data   = %{ $Param{Data} };
    my $Type   = $Param{Type} || 'Template';
    my $NeType = $Type eq 'Queue' ? 'Template' : 'Queue';

    my %VisibleType = ( Template => 'Template', Queue => 'Queue', );

    my $MyType = $VisibleType{$Type};

    $Self->{LayoutObject}->Block( Name => 'Overview' );
    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionOverview' );
    $Self->{LayoutObject}->Block( Name => 'Filter' );

    #fixed link
    my $QueueTag;

    $QueueTag = $Type eq 'Queue' ? 'Queue' : '';

    $Self->{LayoutObject}->Block(
        Name => 'Change',
        Data => {
            %Param,
            ActionHome    => 'Admin' . $Type,
            NeType        => $NeType,
            VisibleType   => $VisibleType{$Type},
            VisibleNeType => $VisibleType{$NeType},
            Queue         => $QueueTag,

        },
    );

    $Self->{LayoutObject}->Block( Name => "ChangeHeader$VisibleType{$NeType}" );

    $Self->{LayoutObject}->Block(
        Name => 'ChangeHeader',
        Data => {
            %Param,
            Type          => $Type,
            NeType        => $NeType,
            VisibleType   => $VisibleType{$Type},
            VisibleNeType => $VisibleType{$NeType},
        },
    );

    for my $ID ( sort { uc( $Data{$a} ) cmp uc( $Data{$b} ) } keys %Data ) {

        # set output class
        my $Selected = $Param{Selected}->{$ID} ? ' checked="checked"' : '';

        $QueueTag = $Type ne 'Queue' ? 'Queue' : '';

        $Self->{LayoutObject}->Block(
            Name => 'ChangeRow',
            Data => {
                %Param,
                Name          => $Param{Data}->{$ID},
                NeType        => $NeType,
                Type          => $Type,
                ID            => $ID,
                Selected      => $Selected,
                VisibleType   => $VisibleType{$Type},
                VisibleNeType => $VisibleType{$NeType},
                Queue         => $QueueTag,
            },
        );
    }

    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminQueueTemplates',
        Data         => \%Param,
        VisibleType  => $MyType,
    );
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => {},
    );

    # no actions in action list
    #    $Self->{LayoutObject}->Block(Name=>'ActionList');
    $Self->{LayoutObject}->Block( Name => 'FilterTemplate' );
    $Self->{LayoutObject}->Block( Name => 'FilterQueue' );
    $Self->{LayoutObject}->Block( Name => 'OverviewResult' );

    # get std template list
    my %StandardTemplateData = $Self->{StandardTemplateObject}->StandardTemplateList(
        Valid => 1,
    );

    # if there are results to show
    if (%StandardTemplateData) {
        for my $StandardTemplateID ( sort keys %StandardTemplateData ) {
            my %Data = $Self->{StandardTemplateObject}->StandardTemplateGet(
                ID => $StandardTemplateID,
            );
            $StandardTemplateData{$StandardTemplateID}
                = $Self->{LayoutObject}->{LanguageObject}->Get( $Data{TemplateType} )
                . ' - '
                . $Data{Name};
        }
        for my $StandardTemplateID (
            sort { uc( $StandardTemplateData{$a} ) cmp uc( $StandardTemplateData{$b} ) }
            keys %StandardTemplateData
            )
        {

            # set output class
            $Self->{LayoutObject}->Block(
                Name => 'List1n',
                Data => {
                    Name      => $StandardTemplateData{$StandardTemplateID},
                    Subaction => 'Template',
                    ID        => $StandardTemplateID,
                },
            );
        }
    }

    # otherwise it displays a no data found message
    else {
        $Self->{LayoutObject}->Block(
            Name => 'NoTemplatesFoundMsg',
            Data => {},
        );
    }

    # get queue data
    my %QueueData = $Self->{QueueObject}->QueueList( Valid => 1 );

    # if there are results to show
    if (%QueueData) {
        for my $QueueID ( sort { uc( $QueueData{$a} ) cmp uc( $QueueData{$b} ) } keys %QueueData ) {

            # set output class
            $Self->{LayoutObject}->Block(
                Name => 'Listn1',
                Data => {
                    Name      => $QueueData{$QueueID},
                    Subaction => 'Queue',
                    ID        => $QueueID,
                },
            );
        }
    }

    # otherwise it displays a no data found message
    else {
        $Self->{LayoutObject}->Block(
            Name => 'NoQueuesFoundMsg',
            Data => {},
        );
    }

    # return output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminQueueTemplates',
        Data         => \%Param,
    );
}

1;
