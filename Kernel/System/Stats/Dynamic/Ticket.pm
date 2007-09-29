# --
# Kernel/System/Stats/Dynamic/Ticket.pm - all advice functions
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: Ticket.pm,v 1.13 2007-09-29 10:54:07 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Stats::Dynamic::Ticket;

use strict;
use warnings;

use Kernel::System::Queue;
use Kernel::System::Service;
use Kernel::System::SLA;
use Kernel::System::Ticket;
use Kernel::System::Type;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.13 $) [1];

sub new {
    my $Type  = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get common opjects
    for ( keys %Param ) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    for (qw(DBObject ConfigObject LogObject UserObject MainObject)) {
        die "Got no $_" if ( !$Self->{$_} );
    }

    $Self->{QueueObject}    = Kernel::System::Queue->new(%Param);
    $Self->{TicketObject}   = Kernel::System::Ticket->new(%Param);
    $Self->{StateObject}    = Kernel::System::State->new(%Param);
    $Self->{PriorityObject} = Kernel::System::Priority->new(%Param);
    $Self->{LockObject}     = Kernel::System::Lock->new( %{$Self} );
    $Self->{CustomerUser}   = Kernel::System::CustomerUser->new( %{$Self} );
    $Self->{ServiceObject}  = Kernel::System::Service->new(%Param);
    $Self->{SLAObject}      = Kernel::System::SLA->new(%Param);
    $Self->{TypeObject}     = Kernel::System::Type->new(%Param);

    return $Self;
}

sub GetObjectName {
    my $Self  = shift;
    my %Param = @_;
    my $Name  = 'Ticket';
    return $Name;
}

sub GetObjectAttributes {
    my $Self  = shift;
    my %Param = @_;

    my %User = $Self->{UserObject}->UserList( Type => 'Long', Valid => 0 );
    my %State        = $Self->{StateObject}->StateList( UserID       => 1 );
    my %StateTypeIDs = $Self->{StateObject}->StateTypeList( UserID   => 1 );
    my %Queues       = $Self->{QueueObject}->GetAllQueues();
    my %PriorityIDs  = $Self->{PriorityObject}->PriorityList( UserID => 1 );
    my %LockIDs      = $Self->{LockObject}->LockList( UserID         => 1 );
    my @ObjectAttributes = (
        {   Name                => 'Queue',
            UseAsXvalue         => 1,
            UseAsValueSeries    => 1,
            UseAsRestriction    => 1,
            Element             => 'QueueIDs',
            Block               => 'MultiSelectField',
            LanguageTranslation => 0,
            Values              => \%Queues,
        },
        {   Name             => 'State',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'StateIDs',
            Block            => 'MultiSelectField',
            Values           => \%State,
        },
        {   Name             => 'State Type',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'StateTypeIDs',
            Block            => 'MultiSelectField',
            Values           => \%StateTypeIDs,
        },
        {   Name             => 'Priority',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'PriorityIDs',
            Block            => 'MultiSelectField',
            Values           => \%PriorityIDs,
        },
        {   Name                => 'Created in Queue',
            UseAsXvalue         => 1,
            UseAsValueSeries    => 1,
            UseAsRestriction    => 1,
            Element             => 'CreatedQueueIDs',
            Block               => 'MultiSelectField',
            LanguageTranslation => 0,
            Values              => \%Queues,
        },
        {   Name             => 'Created Priority',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'CreatedPriorityIDs',
            Block            => 'MultiSelectField',
            Values           => \%PriorityIDs,
        },
        {   Name             => 'Created State',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'CreatedStateIDs',
            Block            => 'MultiSelectField',
            Values           => \%State,
        },
        {   Name             => 'Lock',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'LocksIDs',
            Block            => 'MultiSelectField',
            Values           => \%LockIDs,
        },
        {   Name             => 'Title',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'Title',
            Block            => 'InputField',
        },
        {   Name             => 'CustomerUserLogin',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'CustomerUserLogin',
            Block            => 'InputField',
        },
        {   Name             => 'From',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'From',
            Block            => 'InputField',
        },
        {   Name             => 'To',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'To',
            Block            => 'InputField',
        },
        {   Name             => 'Cc',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'Cc',
            Block            => 'InputField',
        },
        {   Name             => 'Subject',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'Subject',
            Block            => 'InputField',
        },
        {   Name             => 'Text',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'Body',
            Block            => 'InputField',
        },
        {   Name             => 'Create Time',
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
        {   Name             => 'Close Time',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'CloseTime2',
            TimePeriodFormat => 'DateInputFormat',    #'DateInputFormat', # 'DateInputFormatLong',
            Block            => 'Time',
            Values           => {
                TimeStart => 'TicketCloseTimeNewerDate',
                TimeStop  => 'TicketCloseTimeOlderDate',
            },
        },
    );

    if ( $Self->{ConfigObject}->Get('Ticket::Service') ) {
        my %SLA     = $Self->{SLAObject}->SLAList( UserID         => $Self->{UserID}, );
        my %Service = $Self->{ServiceObject}->ServiceList( UserID => $Self->{UserID}, );
        my %ObjectAttribute2 = (
            Name                => 'SLA',
            UseAsXvalue         => 1,
            UseAsValueSeries    => 1,
            UseAsRestriction    => 1,
            Element             => 'SLAIDs',
            Block               => 'MultiSelectField',
            LanguageTranslation => 0,
            Values              => \%SLA,
        );
        unshift( @ObjectAttributes, \%ObjectAttribute2 );

        my %ObjectAttribute1 = (
            Name                => 'Service',
            UseAsXvalue         => 1,
            UseAsValueSeries    => 1,
            UseAsRestriction    => 1,
            Element             => 'ServiceIDs',
            Block               => 'MultiSelectField',
            LanguageTranslation => 0,
            Values              => \%Service,
        );
        unshift( @ObjectAttributes, \%ObjectAttribute1 );
    }

    if ( $Self->{ConfigObject}->Get('Ticket::Type') ) {
        my %Type = $Self->{TypeObject}->TypeList( UserID => $Self->{UserID}, );
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
        unshift( @ObjectAttributes, \%ObjectAttribute1 );
    }

    if ( $Self->{ConfigObject}->Get('Stats::UseAgentElementInStats') ) {
        my %ObjectAttribute1 = (
            Name                => 'Agent/Owner',
            UseAsXvalue         => 1,
            UseAsValueSeries    => 1,
            UseAsRestriction    => 1,
            Element             => 'OwnerIDs',
            Block               => 'MultiSelectField',
            LanguageTranslation => 0,
            Values              => \%User,
        );
        push( @ObjectAttributes, \%ObjectAttribute1 );

        my %ObjectAttribute2 = (
            Name                => 'Created by Agent/Owner',
            UseAsXvalue         => 1,
            UseAsValueSeries    => 1,
            UseAsRestriction    => 1,
            Element             => 'CreatedUserIDs',
            Block               => 'MultiSelectField',
            LanguageTranslation => 0,
            Values              => \%User,
        );

        push( @ObjectAttributes, \%ObjectAttribute2 );

        my %ObjectAttribute3 = (
            Name                => 'Responsible',
            UseAsXvalue         => 1,
            UseAsValueSeries    => 1,
            UseAsRestriction    => 1,
            Element             => 'ResponsibleIDs',
            Block               => 'MultiSelectField',
            LanguageTranslation => 0,
            Values              => \%User,
        );
        push( @ObjectAttributes, \%ObjectAttribute3 );
    }

    if ( $Self->{ConfigObject}->Get('Stats::CustomerIDAsMultiSelect') ) {

        # Get CustomerID
        # (This way also can be the solution for the CustomerUserID)
        my %CustomerID = ();
        $Self->{DBObject}->Prepare( SQL => "SELECT DISTINCT customer_id FROM ticket" );

        # fetch Data
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
        push( @ObjectAttributes, \%ObjectAttribute );
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
        push( @ObjectAttributes, \%ObjectAttribute );
    }
    for my $ID ( 1 .. 16 ) {
        if ( ref( $Self->{ConfigObject}->Get( 'TicketFreeKey' . $ID ) ) eq 'HASH' ) {
            my %TicketFreeKey = %{ $Self->{ConfigObject}->Get( 'TicketFreeKey' . $ID ) };
            my @FreeKey       = keys %TicketFreeKey;
            my $Name          = '';
            if ( $#FreeKey == 0 ) {
                $Name = $TicketFreeKey{ $FreeKey[0] };
            }
            else {
                $Name = 'TicketFreeText' . $ID;
                my %ObjectAttribute = (
                    Name                => 'TicketFreeKey' . $ID,
                    UseAsXvalue         => 1,
                    UseAsValueSeries    => 1,
                    UseAsRestriction    => 1,
                    Element             => 'TicketFreeKey' . $ID,
                    Block               => 'MultiSelectField',
                    Values              => \%TicketFreeKey,
                    LanguageTranslation => 0,
                );
                push( @ObjectAttributes, \%ObjectAttribute );
            }
            if ($Self->{TicketObject}->TicketFreeTextGet(
                    Type   => 'TicketFreeText' . $ID,
                    UserID => 1
                )
                )
            {
                my %TicketFreeText = %{
                    $Self->{TicketObject}->TicketFreeTextGet(
                        Type   => 'TicketFreeText' . $ID,
                        UserID => 1,
                    )
                    };
                my %ObjectAttribute = (
                    Name                => $Name,
                    UseAsXvalue         => 1,
                    UseAsValueSeries    => 1,
                    UseAsRestriction    => 1,
                    Element             => 'TicketFreeText' . $ID,
                    Block               => 'MultiSelectField',
                    Values              => \%TicketFreeText,
                    LanguageTranslation => 0,

                );
                push( @ObjectAttributes, \%ObjectAttribute );
            }
            else {
                my %ObjectAttribute = (
                    Name             => $Name,
                    UseAsXvalue      => 0,
                    UseAsValueSeries => 0,
                    UseAsRestriction => 1,
                    Element          => 'TicketFreeText' . $ID,
                    ,
                    Block => 'InputField',
                );
                push( @ObjectAttributes, \%ObjectAttribute );
            }
        }
    }
    return @ObjectAttributes;
}

sub GetStatElement {
    my $Self      = shift;
    my %Param     = @_;
    my @TicketIDs = $Self->{TicketObject}->TicketSearch(
        UserID     => 1,
        Result     => 'ARRAY',
        Permission => 'rw',
        Limit      => 100000000,
        %Param,
    );
    return ( $#TicketIDs + 1 );
}

sub ExportWrapper {
    my $Self  = shift;
    my %Param = @_;

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
                elsif ($Element->{Element} eq 'StateIDs'
                    || $Element->{Element} eq 'CreatedStateIDs' )
                {
                    my %StateList = $Self->{StateObject}->StateList( UserID => 1 );
                    for my $ID ( @{ $Element->{SelectedValues} } ) {
                        if ($ID) {
                            $ID->{Content} = $StateList{ $ID->{Content} };
                        }
                    }
                }
                elsif ($Element->{Element} eq 'PriorityIDs'
                    || $Element->{Element} eq 'CreatedPriorityIDs' )
                {
                    my %PriorityList = $Self->{PriorityObject}->PriorityList( UserID => 1 );
                    for my $ID ( @{ $Element->{SelectedValues} } ) {
                        if ($ID) {
                            $ID->{Content} = $PriorityList{ $ID->{Content} };
                        }
                    }
                }
                elsif ($Element->{Element} eq 'OwnerIDs'
                    || $Element->{Element} eq 'CreatedUserIDs'
                    || $Element->{Element} eq 'ResponsibleIDs' )
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
    my $Self  = shift;
    my %Param = @_;

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
                elsif ($Element->{Element} eq 'StateIDs'
                    || $Element->{Element} eq 'CreatedStateIDs' )
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
                elsif ($Element->{Element} eq 'PriorityIDs'
                    || $Element->{Element} eq 'CreatedPriorityIDs' )
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
                elsif ($Element->{Element} eq 'OwnerIDs'
                    || $Element->{Element} eq 'CreatedUserIDs'
                    || $Element->{Element} eq 'ResponsibleIDs' )
                {
                    for my $ID ( @{ $Element->{SelectedValues} } ) {
                        if ($ID) {
                            if ( $Self->{UserObject}->UserLookup( UserLogin => $ID->{Content} ) ) {
                                $ID->{Content} = $Self->{UserObject}
                                    ->UserLookup( UserLogin => $ID->{Content} );
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
