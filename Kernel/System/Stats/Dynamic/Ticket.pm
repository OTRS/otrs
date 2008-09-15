# --
# Kernel/System/Stats/Dynamic/Ticket.pm - all advice functions
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: Ticket.pm,v 1.21 2008-09-15 11:02:31 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::Stats::Dynamic::Ticket;

use strict;
use warnings;

use Kernel::System::Queue;
use Kernel::System::Service;
use Kernel::System::SLA;
use Kernel::System::Ticket;
use Kernel::System::Type;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.21 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(DBObject ConfigObject LogObject UserObject TimeObject MainObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }
    $Self->{QueueObject}    = Kernel::System::Queue->new( %{$Self} );
    $Self->{TicketObject}   = Kernel::System::Ticket->new( %{$Self} );
    $Self->{StateObject}    = Kernel::System::State->new( %{$Self} );
    $Self->{PriorityObject} = Kernel::System::Priority->new( %{$Self} );
    $Self->{LockObject}     = Kernel::System::Lock->new( %{$Self} );
    $Self->{CustomerUser}   = Kernel::System::CustomerUser->new( %{$Self} );
    $Self->{ServiceObject}  = Kernel::System::Service->new( %{$Self} );
    $Self->{SLAObject}      = Kernel::System::SLA->new( %{$Self} );
    $Self->{TypeObject}     = Kernel::System::Type->new( %{$Self} );

    return $Self;
}

sub GetObjectName {
    my ( $Self, %Param ) = @_;

    return 'Ticket';
}

sub GetObjectAttributes {
    my ( $Self, %Param ) = @_;

    # get user list
    my %UserList = $Self->{UserObject}->UserList(
        Type  => 'Long',
        Valid => 0,
    );

    # get state list
    my %StateList = $Self->{StateObject}->StateList(
        UserID => 1,
    );

    # get state type list
    my %StateTypeList = $Self->{StateObject}->StateTypeList(
        UserID => 1,
    );

    # get queue list
    my %QueueList = $Self->{QueueObject}->GetAllQueues();

    # get priority list
    my %PriorityList = $Self->{PriorityObject}->PriorityList(
        UserID => 1,
    );

    # get lock list
    my %LockList = $Self->{LockObject}->LockList(
        UserID => 1,
    );

    my @ObjectAttributes = (
        {
            Name                => 'Queue',
            UseAsXvalue         => 1,
            UseAsValueSeries    => 1,
            UseAsRestriction    => 1,
            Element             => 'QueueIDs',
            Block               => 'MultiSelectField',
            LanguageTranslation => 0,
            Values              => \%QueueList,
        },
        {
            Name             => 'State',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'StateIDs',
            Block            => 'MultiSelectField',
            Values           => \%StateList,
        },
        {
            Name             => 'State Type',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'StateTypeIDs',
            Block            => 'MultiSelectField',
            Values           => \%StateTypeList,
        },
        {
            Name             => 'Priority',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'PriorityIDs',
            Block            => 'MultiSelectField',
            Values           => \%PriorityList,
        },
        {
            Name                => 'Created in Queue',
            UseAsXvalue         => 1,
            UseAsValueSeries    => 1,
            UseAsRestriction    => 1,
            Element             => 'CreatedQueueIDs',
            Block               => 'MultiSelectField',
            LanguageTranslation => 0,
            Values              => \%QueueList,
        },
        {
            Name             => 'Created Priority',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'CreatedPriorityIDs',
            Block            => 'MultiSelectField',
            Values           => \%PriorityList,
        },
        {
            Name             => 'Created State',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'CreatedStateIDs',
            Block            => 'MultiSelectField',
            Values           => \%StateList,
        },
        {
            Name             => 'Lock',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'LocksIDs',
            Block            => 'MultiSelectField',
            Values           => \%LockList,
        },
        {
            Name             => 'Title',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'Title',
            Block            => 'InputField',
        },
        {
            Name             => 'CustomerUserLogin',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'CustomerUserLogin',
            Block            => 'InputField',
        },
        {
            Name             => 'From',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'From',
            Block            => 'InputField',
        },
        {
            Name             => 'To',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'To',
            Block            => 'InputField',
        },
        {
            Name             => 'Cc',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'Cc',
            Block            => 'InputField',
        },
        {
            Name             => 'Subject',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'Subject',
            Block            => 'InputField',
        },
        {
            Name             => 'Text',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'Body',
            Block            => 'InputField',
        },
        {
            Name             => 'Create Time',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'CreateTime',
            TimePeriodFormat => 'DateInputFormat',    # 'DateInputFormatLong',
            Block            => 'Time',
            Values           => {
                TimeStart => 'TicketCreateTimeNewerDate',
                TimeStop  => 'TicketCreateTimeOlderDate',
            },
        },
        {
            Name             => 'Close Time',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'CloseTime2',
            TimePeriodFormat => 'DateInputFormat',    # 'DateInputFormatLong',
            Block            => 'Time',
            Values           => {
                TimeStart => 'TicketCloseTimeNewerDate',
                TimeStop  => 'TicketCloseTimeOlderDate',
            },
        },
        {
            Name             => 'Escalation',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'EscalationTime',
            TimePeriodFormat => 'DateInputFormatLong',    # 'DateInputFormat',
            Block            => 'Time',
            Values           => {
                TimeStart => 'TicketEscalationTimeNewerDate',
                TimeStop  => 'TicketEscalationTimeOlderDate',
            },
        },
        {
            Name             => 'Escalation - First Response Time',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'EscalationResponseTime',
            TimePeriodFormat => 'DateInputFormatLong',                # 'DateInputFormat',
            Block            => 'Time',
            Values           => {
                TimeStart => 'TicketEscalationResponseTimeNewerDate',
                TimeStop  => 'TicketEscalationResponseTimeOlderDate',
            },
        },
        {
            Name             => 'Escalation - Update Time',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'EscalationUpdateTime',
            TimePeriodFormat => 'DateInputFormatLong',        # 'DateInputFormat',
            Block            => 'Time',
            Values           => {
                TimeStart => 'TicketEscalationUpdateTimeNewerDate',
                TimeStop  => 'TicketEscalationUpdateTimeOlderDate',
            },
        },
        {
            Name             => 'Escalation - Solution Time',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'EscalationSolutionTime',
            TimePeriodFormat => 'DateInputFormatLong',          # 'DateInputFormat',
            Block            => 'Time',
            Values           => {
                TimeStart => 'TicketEscalationSolutionTimeNewerDate',
                TimeStop  => 'TicketEscalationSolutionTimeOlderDate',
            },
        },
    );

    if ( $Self->{ConfigObject}->Get('Ticket::Service') ) {

        # get service list
        my %Service = $Self->{ServiceObject}->ServiceList(
            UserID => 1,
        );

        # get sla list
        my %SLA = $Self->{SLAObject}->SLAList(
            UserID => 1,
        );

        my @ObjectAttributeAdd = (
            {
                Name                => 'Service',
                UseAsXvalue         => 1,
                UseAsValueSeries    => 1,
                UseAsRestriction    => 1,
                Element             => 'ServiceIDs',
                Block               => 'MultiSelectField',
                LanguageTranslation => 0,
                Values              => \%Service,
            },
            {
                Name                => 'SLA',
                UseAsXvalue         => 1,
                UseAsValueSeries    => 1,
                UseAsRestriction    => 1,
                Element             => 'SLAIDs',
                Block               => 'MultiSelectField',
                LanguageTranslation => 0,
                Values              => \%SLA,
            },
        );

        unshift @ObjectAttributes, @ObjectAttributeAdd;
    }

    if ( $Self->{ConfigObject}->Get('Ticket::Type') ) {

        # get ticket type list
        my %Type = $Self->{TypeObject}->TypeList(
            UserID => 1,
        );

        my %ObjectAttribute1 = (
            Name                => 'Type',
            UseAsXvalue         => 1,
            UseAsValueSeries    => 1,
            UseAsRestriction    => 1,
            Element             => 'TypeIDs',
            Block               => 'MultiSelectField',
            LanguageTranslation => 0,
            Values              => \%Type,
        );

        unshift @ObjectAttributes, \%ObjectAttribute1;
    }

    if ( $Self->{ConfigObject}->Get('Stats::UseAgentElementInStats') ) {

        my @ObjectAttributeAdd = (
            {
                Name                => 'Agent/Owner',
                UseAsXvalue         => 1,
                UseAsValueSeries    => 1,
                UseAsRestriction    => 1,
                Element             => 'OwnerIDs',
                Block               => 'MultiSelectField',
                LanguageTranslation => 0,
                Values              => \%UserList,
            },
            {
                Name                => 'Created by Agent/Owner',
                UseAsXvalue         => 1,
                UseAsValueSeries    => 1,
                UseAsRestriction    => 1,
                Element             => 'CreatedUserIDs',
                Block               => 'MultiSelectField',
                LanguageTranslation => 0,
                Values              => \%UserList,
            },
            {
                Name                => 'Responsible',
                UseAsXvalue         => 1,
                UseAsValueSeries    => 1,
                UseAsRestriction    => 1,
                Element             => 'ResponsibleIDs',
                Block               => 'MultiSelectField',
                LanguageTranslation => 0,
                Values              => \%UserList,
            },
        );

        push @ObjectAttributes, @ObjectAttributeAdd;
    }

    if ( $Self->{ConfigObject}->Get('Stats::CustomerIDAsMultiSelect') ) {

        # Get CustomerID
        # (This way also can be the solution for the CustomerUserID)
        $Self->{DBObject}->Prepare(
            SQL => "SELECT DISTINCT customer_id FROM ticket",
        );

        # fetch the result
        my %CustomerID;
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            if ( $Row[0] ) {
                $CustomerID{ $Row[0] } = $Row[0];
            }
        }

        my %ObjectAttribute = (
            Name             => 'CustomerID',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'CustomerID',
            Block            => 'MultiSelectField',
            Values           => \%CustomerID,
        );

        push @ObjectAttributes, \%ObjectAttribute;
    }
    else {

        my %ObjectAttribute = (
            Name             => 'CustomerID',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'CustomerID',
            Block            => 'InputField',
        );

        push @ObjectAttributes, \%ObjectAttribute;
    }

    FREEKEY:
    for my $FreeKey ( 1 .. 16 ) {

        # get ticket free key config
        my $TicketFreeKey = $Self->{ConfigObject}->Get( 'TicketFreeKey' . $FreeKey );

        next FREEKEY if ref $TicketFreeKey ne 'HASH';

        my @FreeKey = keys %{$TicketFreeKey};
        my $Name    = '';

        if ( scalar @FreeKey == 1 ) {
            $Name = $TicketFreeKey->{ $FreeKey[0] };
        }
        else {
            $Name = 'TicketFreeText' . $FreeKey;

            my %ObjectAttribute = (
                Name                => 'TicketFreeKey' . $FreeKey,
                UseAsXvalue         => 1,
                UseAsValueSeries    => 1,
                UseAsRestriction    => 1,
                Element             => 'TicketFreeKey' . $FreeKey,
                Block               => 'MultiSelectField',
                Values              => $TicketFreeKey,
                LanguageTranslation => 0,
            );

            push @ObjectAttributes, \%ObjectAttribute;
        }

        # get ticket free text
        my $TicketFreeText = $Self->{TicketObject}->TicketFreeTextGet(
            Type   => 'TicketFreeText' . $FreeKey,
            Action => 'AgentStats',
            FillUp => 1,
            UserID => 1,
        );

        if ($TicketFreeText) {

            my %ObjectAttribute = (
                Name                => $Name,
                UseAsXvalue         => 1,
                UseAsValueSeries    => 1,
                UseAsRestriction    => 1,
                Element             => 'TicketFreeText' . $FreeKey,
                Block               => 'MultiSelectField',
                Values              => $TicketFreeText,
                LanguageTranslation => 0,
            );

            push @ObjectAttributes, \%ObjectAttribute;
        }
        else {

            my %ObjectAttribute = (
                Name             => $Name,
                UseAsXvalue      => 0,
                UseAsValueSeries => 0,
                UseAsRestriction => 1,
                Element          => 'TicketFreeText' . $FreeKey,,
                Block            => 'InputField',
            );

            push @ObjectAttributes, \%ObjectAttribute;
        }
    }

    return @ObjectAttributes;
}

sub GetStatElement {
    my ( $Self, %Param ) = @_;

    # search tickets
    my @TicketIDs = $Self->{TicketObject}->TicketSearch(
        UserID     => 1,
        Result     => 'ARRAY',
        Permission => 'ro',
        Limit      => 100_000_000,
        %Param,
    );

    return scalar @TicketIDs;
}

sub ExportWrapper {
    my ( $Self, %Param ) = @_;

    # wrap ids to used spelling
    for my $Use (qw(UseAsValueSeries UseAsRestriction UseAsXvalue)) {
        for my $Element ( @{ $Param{$Use} } ) {
            if ( $Element && $Element->{SelectedValues} ) {
                if ( $Element->{Element} eq 'QueueIDs' || $Element->{Element} eq 'CreatedQueueIDs' )
                {
                    for my $ID ( @{ $Element->{SelectedValues} } ) {
                        if ($ID) {
                            $ID->{Content}
                                = $Self->{QueueObject}->QueueLookup( QueueID => $ID->{Content} );
                        }
                    }
                }
                elsif (
                    $Element->{Element} eq 'StateIDs'
                    || $Element->{Element} eq 'CreatedStateIDs'
                    )
                {
                    my %StateList = $Self->{StateObject}->StateList( UserID => 1 );
                    for my $ID ( @{ $Element->{SelectedValues} } ) {
                        if ($ID) {
                            $ID->{Content} = $StateList{ $ID->{Content} };
                        }
                    }
                }
                elsif (
                    $Element->{Element} eq 'PriorityIDs'
                    || $Element->{Element} eq 'CreatedPriorityIDs'
                    )
                {
                    my %PriorityList = $Self->{PriorityObject}->PriorityList( UserID => 1 );
                    for my $ID ( @{ $Element->{SelectedValues} } ) {
                        if ($ID) {
                            $ID->{Content} = $PriorityList{ $ID->{Content} };
                        }
                    }
                }
                elsif (
                    $Element->{Element}    eq 'OwnerIDs'
                    || $Element->{Element} eq 'CreatedUserIDs'
                    || $Element->{Element} eq 'ResponsibleIDs'
                    )
                {
                    for my $ID ( @{ $Element->{SelectedValues} } ) {
                        if ($ID) {
                            $ID->{Content}
                                = $Self->{UserObject}->UserLookup( UserID => $ID->{Content} );
                        }
                    }
                }

                # Locks and statustype don't have to wrap because they are never different
            }
        }
    }

    return \%Param;
}

sub ImportWrapper {
    my ( $Self, %Param ) = @_;

    # wrap used spelling to ids
    for my $Use (qw(UseAsValueSeries UseAsRestriction UseAsXvalue)) {
        for my $Element ( @{ $Param{$Use} } ) {
            if ( $Element && $Element->{SelectedValues} ) {
                if ( $Element->{Element} eq 'QueueIDs' || $Element->{Element} eq 'CreatedQueueIDs' )
                {
                    for my $ID ( @{ $Element->{SelectedValues} } ) {
                        if ($ID) {
                            if ( $Self->{QueueObject}->QueueLookup( Queue => $ID->{Content} ) ) {
                                $ID->{Content}
                                    = $Self->{QueueObject}->QueueLookup( Queue => $ID->{Content} );
                            }
                            else {
                                $Self->{LogObject}->Log(
                                    Priority => 'error',
                                    Message  => "Import: Can' find the queue $ID->{Content}!"
                                );
                                $ID = undef;
                            }
                        }
                    }
                }
                elsif (
                    $Element->{Element} eq 'StateIDs'
                    || $Element->{Element} eq 'CreatedStateIDs'
                    )
                {
                    for my $ID ( @{ $Element->{SelectedValues} } ) {
                        if ($ID) {
                            my %State = $Self->{StateObject}->StateGet(
                                Name  => $ID->{Content},
                                Cache => 1,
                            );
                            if ( $State{ID} ) {
                                $ID->{Content} = $State{ID};
                            }
                            else {
                                $Self->{LogObject}->Log(
                                    Priority => 'error',
                                    Message  => "Import: Can' find state $ID->{Content}!"
                                );
                                $ID = undef;
                            }
                        }
                    }
                }
                elsif (
                    $Element->{Element} eq 'PriorityIDs'
                    || $Element->{Element} eq 'CreatedPriorityIDs'
                    )
                {
                    my %PriorityList = $Self->{PriorityObject}->PriorityList( UserID => 1 );
                    my %PriorityIDs = ();
                    for my $Key ( keys %PriorityList ) {
                        $PriorityIDs{ $PriorityList{$Key} } = $Key;
                    }
                    for my $ID ( @{ $Element->{SelectedValues} } ) {
                        if ($ID) {
                            if ( $PriorityIDs{ $ID->{Content} } ) {
                                $ID->{Content} = $PriorityIDs{ $ID->{Content} };
                            }
                            else {
                                $Self->{LogObject}->Log(
                                    Priority => 'error',
                                    Message  => "Import: Can' find priority $ID->{Content}!"
                                );
                                $ID = undef;
                            }
                        }
                    }
                }
                elsif (
                    $Element->{Element}    eq 'OwnerIDs'
                    || $Element->{Element} eq 'CreatedUserIDs'
                    || $Element->{Element} eq 'ResponsibleIDs'
                    )
                {
                    for my $ID ( @{ $Element->{SelectedValues} } ) {
                        if ($ID) {
                            if ( $Self->{UserObject}->UserLookup( UserLogin => $ID->{Content} ) ) {
                                $ID->{Content} = $Self->{UserObject}->UserLookup(
                                    UserLogin => $ID->{Content}
                                );
                            }
                            else {
                                $Self->{LogObject}->Log(
                                    Priority => 'error',
                                    Message  => "Import: Can' find user $ID->{Content}!"
                                );
                                $ID = undef;
                            }
                        }
                    }
                }

                # Locks and statustype don't have to wrap because they are never different
            }
        }
    }

    return \%Param;
}

1;
