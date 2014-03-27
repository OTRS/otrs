# --
# Kernel/System/Stats/Dynamic/TicketList.pm - reporting via ticket lists
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: TicketList.pm,v 1.13.4.1 2012-02-28 09:55:07 jp Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Stats::Dynamic::TicketList;

use strict;
use warnings;

use List::Util qw( first );
use Kernel::System::Queue;
use Kernel::System::Service;
use Kernel::System::SLA;
use Kernel::System::Ticket;
use Kernel::System::Type;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.13.4.1 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(DBObject ConfigObject LogObject UserObject TimeObject MainObject EncodeObject)
        )
    {
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

    return 'Ticketlist';
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

    my %Limit = (
        5         => 5,
        10        => 10,
        20        => 20,
        50        => 50,
        100       => 100,
        unlimited => 'unlimited',
    );

    my %TicketAttributes = %{ $Self->_TicketAttributes() };
    my %OrderBy
        = map { $_ => $TicketAttributes{$_} } grep { $_ ne 'Number' } keys %TicketAttributes;
    my %SortSequence = (
        Up   => 'ascending',
        Down => 'descending',
    );

    my @ObjectAttributes = (
        {
            Name             => 'Attributes to be printed',
            UseAsXvalue      => 1,
            UseAsValueSeries => 0,
            UseAsRestriction => 0,
            Element          => 'TicketAttributes',
            Block            => 'MultiSelectField',
            Translation      => 1,
            Values           => \%TicketAttributes,
            Sort             => 'IndividualKey',
            SortIndividual   => $Self->_SortedAttributes(),

        },
        {
            Name             => 'Order by',
            UseAsXvalue      => 0,
            UseAsValueSeries => 1,
            UseAsRestriction => 0,
            Element          => 'OrderBy',
            Block            => 'SelectField',
            Translation      => 1,
            Values           => \%OrderBy,
            Sort             => 'IndividualKey',
            SortIndividual   => $Self->_SortedAttributes(),
        },
        {
            Name             => 'Sort sequence',
            UseAsXvalue      => 0,
            UseAsValueSeries => 1,
            UseAsRestriction => 0,
            Element          => 'SortSequence',
            Block            => 'SelectField',
            Translation      => 1,
            Values           => \%SortSequence,
        },
        {
            Name             => 'Limit',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'Limit',
            Block            => 'SelectField',
            Translation      => 1,
            Values           => \%Limit,
            Sort             => 'IndividualKey',
            SortIndividual   => [ '5', '10', '20', '50', '100', 'unlimited', ],
        },
        {
            Name             => 'Queue',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'QueueIDs',
            Block            => 'MultiSelectField',
            Translation      => 0,
            Values           => \%QueueList,
        },
        {
            Name             => 'State',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'StateIDs',
            Block            => 'MultiSelectField',
            Values           => \%StateList,
        },
        {
            Name             => 'State Type',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'StateTypeIDs',
            Block            => 'MultiSelectField',
            Values           => \%StateTypeList,
        },
        {
            Name             => 'Priority',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'PriorityIDs',
            Block            => 'MultiSelectField',
            Values           => \%PriorityList,
        },
        {
            Name             => 'Created in Queue',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'CreatedQueueIDs',
            Block            => 'MultiSelectField',
            Translation      => 0,
            Values           => \%QueueList,
        },
        {
            Name             => 'Created Priority',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'CreatedPriorityIDs',
            Block            => 'MultiSelectField',
            Values           => \%PriorityList,
        },
        {
            Name             => 'Created State',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'CreatedStateIDs',
            Block            => 'MultiSelectField',
            Values           => \%StateList,
        },
        {
            Name             => 'Lock',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'LockIDs',
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
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
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
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'CloseTime',
            TimePeriodFormat => 'DateInputFormat',    # 'DateInputFormatLong',
            Block            => 'Time',
            Values           => {
                TimeStart => 'TicketCloseTimeNewerDate',
                TimeStop  => 'TicketCloseTimeOlderDate',
            },
        },
        {
            Name             => 'Escalation',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
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
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
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
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
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
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
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
                Name             => 'Service',
                UseAsXvalue      => 0,
                UseAsValueSeries => 0,
                UseAsRestriction => 1,
                Element          => 'ServiceIDs',
                Block            => 'MultiSelectField',
                Translation      => 0,
                Values           => \%Service,
            },
            {
                Name             => 'SLA',
                UseAsXvalue      => 0,
                UseAsValueSeries => 0,
                UseAsRestriction => 1,
                Element          => 'SLAIDs',
                Block            => 'MultiSelectField',
                Translation      => 0,
                Values           => \%SLA,
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
            Name             => 'Type',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'TypeIDs',
            Block            => 'MultiSelectField',
            Translation      => 0,
            Values           => \%Type,
        );

        unshift @ObjectAttributes, \%ObjectAttribute1;
    }

    if ( $Self->{ConfigObject}->Get('Stats::UseAgentElementInStats') ) {

        my @ObjectAttributeAdd = (
            {
                Name             => 'Agent/Owner',
                UseAsXvalue      => 0,
                UseAsValueSeries => 0,
                UseAsRestriction => 1,
                Element          => 'OwnerIDs',
                Block            => 'MultiSelectField',
                Translation      => 0,
                Values           => \%UserList,
            },
            {
                Name             => 'Created by Agent/Owner',
                UseAsXvalue      => 0,
                UseAsValueSeries => 0,
                UseAsRestriction => 1,
                Element          => 'CreatedUserIDs',
                Block            => 'MultiSelectField',
                Translation      => 0,
                Values           => \%UserList,
            },
            {
                Name             => 'Responsible',
                UseAsXvalue      => 0,
                UseAsValueSeries => 0,
                UseAsRestriction => 1,
                Element          => 'ResponsibleIDs',
                Block            => 'MultiSelectField',
                Translation      => 0,
                Values           => \%UserList,
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
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
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
                Name             => 'TicketFreeKey' . $FreeKey,
                UseAsXvalue      => 0,
                UseAsValueSeries => 0,
                UseAsRestriction => 1,
                Element          => 'TicketFreeKey' . $FreeKey,
                Block            => 'MultiSelectField',
                Values           => $TicketFreeKey,
                Translation      => 0,
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
                Name             => $Name,
                UseAsXvalue      => 0,
                UseAsValueSeries => 0,
                UseAsRestriction => 1,
                Element          => 'TicketFreeText' . $FreeKey,
                Block            => 'MultiSelectField',
                Values           => $TicketFreeText,
                Translation      => 0,
            );

            push @ObjectAttributes, \%ObjectAttribute;
        }
        else {

            my %ObjectAttribute = (
                Name             => $Name,
                UseAsXvalue      => 0,
                UseAsValueSeries => 0,
                UseAsRestriction => 1,
                Element          => 'TicketFreeText' . $FreeKey,
                Block            => 'InputField',
            );

            push @ObjectAttributes, \%ObjectAttribute;
        }
    }

    return @ObjectAttributes;
}

sub GetStatTable {
    my ( $Self, %Param ) = @_;
    my %TicketAttributes = map { $_ => 1 } @{ $Param{XValue}{SelectedValues} };
    my $SortedAttributesRef = $Self->_SortedAttributes();

    # check if a enumeration is requested
    my $AddEnumeration = 0;
    if ( $TicketAttributes{Number} ) {
        $AddEnumeration = 1;
        delete $TicketAttributes{Number};
    }

    # set default values if no sort or order attribute is given
    my $OrderRef = first { $_->{Element} eq 'OrderBy' } @{ $Param{ValueSeries} };
    my $OrderBy = $OrderRef ? $OrderRef->{SelectedValues}[0] : 'Age';
    my $SortRef = first { $_->{Element} eq 'SortSequence' } @{ $Param{ValueSeries} };
    my $Sort = $SortRef ? $SortRef->{SelectedValues}[0] : 'Down';
    my $Limit = $Param{Restrictions}{Limit};

    # check if we can use the sort and order function of TicketSearch
    my $OrderByIsValueOfTicketSearchSort = $Self->_OrderByIsValueOfTicketSearchSort(
        OrderBy => $OrderBy,
    );

    #
    # escape search attributes for ticket search
    #
    my %AttributesToEscape = (
        'CustomerID'       => 1,
        'Title'            => 1,
        'TicketFreeText1'  => 1,
        'TicketFreeText2'  => 1,
        'TicketFreeText3'  => 1,
        'TicketFreeText4'  => 1,
        'TicketFreeText5'  => 1,
        'TicketFreeText6'  => 1,
        'TicketFreeText7'  => 1,
        'TicketFreeText8'  => 1,
        'TicketFreeText9'  => 1,
        'TicketFreeText10' => 1,
        'TicketFreeText11' => 1,
        'TicketFreeText12' => 1,
        'TicketFreeText13' => 1,
        'TicketFreeText14' => 1,
        'TicketFreeText15' => 1,
        'TicketFreeText16' => 1,
    );

    ATTRIBUTE:
    for my $Key ( keys %{ $Param{Restrictions} } ) {

        next ATTRIBUTE if !$AttributesToEscape{$Key};

        if ( ref $Param{Restrictions}->{$Key} ) {
            if ( ref $Param{Restrictions}->{$Key} eq 'ARRAY' ) {
                $Param{Restrictions}->{$Key} = [
                    map { $Self->{DBObject}->QueryStringEscape( QueryString => $_ ) }
                        @{ $Param{Restrictions}->{$Key} }
                ];
            }
        }
        else {
            $Param{Restrictions}->{$Key} = $Self->{DBObject}->QueryStringEscape(
                QueryString => $Param{Restrictions}->{$Key}
            );
        }
    }

    if ($OrderByIsValueOfTicketSearchSort) {

        # don't be irritated of the mixture OrderBy <> Sort and SortBy <> OrderBy
        # the meaning is in TicketSearch is different as in common handling
        $Param{Restrictions}{OrderBy} = $Sort;
        $Param{Restrictions}{SortBy}  = $OrderByIsValueOfTicketSearchSort;
        $Param{Restrictions}{Limit}   = !$Limit || $Limit eq 'unlimited' ? 100_000_000 : $Limit;
    }
    else {
        $Param{Restrictions}{Limit} = 100_000_000;
    }

    # get the involved tickets
    my @TicketIDs = $Self->{TicketObject}->TicketSearch(
        UserID     => 1,
        Result     => 'ARRAY',
        Permission => 'ro',
        %{ $Param{Restrictions} },
    );

    # find out if the extended version of TicketGet is needed,
    my $Extended = $Self->_ExtendedAttributesCheck(
        TicketAttributes => \%TicketAttributes,
    );

    # generate the ticket list
    my @StatArray;
    for my $TicketID (@TicketIDs) {
        my @ResultRow;
        my %Ticket = $Self->{TicketObject}->TicketGet(
            TicketID => $TicketID,
            UserID   => 1,
            Extended => $Extended,
        );

        # add the accounted time if needed
        if ( $TicketAttributes{AccountedTime} ) {
            $Ticket{AccountedTime}
                = $Self->{TicketObject}->TicketAccountedTimeGet( TicketID => $TicketID );
        }

        $Ticket{SolutionTime}                ||= '';
        $Ticket{SolutionDiffInMin}           ||= 0;
        $Ticket{SolutionInMin}               ||= 0;
        $Ticket{FirstResponse}               ||= '';
        $Ticket{FirstResponseDiffInMin}      ||= 0;
        $Ticket{FirstResponseInMin}          ||= 0;
        $Ticket{FirstLock}                   ||= '';
        $Ticket{SolutionTimeDestinationDate} ||= '';
        $Ticket{EscalationDestinationIn}     ||= '';
        $Ticket{EscalationDestinationDate}   ||= '';
        $Ticket{EscalationTimeWorkingTime}   ||= 0;

        ATTRIBUTE:
        for my $Attribute ( @{$SortedAttributesRef} ) {
            next ATTRIBUTE if !$TicketAttributes{$Attribute};
            push @ResultRow, $Ticket{$Attribute};
        }
        push @StatArray, \@ResultRow;
    }

    # use a individual sort if the sort mechanismn of the TicketSearch is not useable
    if ( !$OrderByIsValueOfTicketSearchSort ) {
        @StatArray = $Self->_IndividualResultOrder(
            StatArray          => \@StatArray,
            OrderBy            => $OrderBy,
            Sort               => $Sort,
            SelectedAttributes => \%TicketAttributes,
            Limit              => $Limit,
        );
    }

    # add a enumeration in front of each row
    if ($AddEnumeration) {
        my $Counter = 0;
        for my $Row (@StatArray) {
            unshift @{$Row}, ++$Counter;
        }
    }

    return @StatArray;
}

sub GetHeaderLine {
    my ( $Self, %Param ) = @_;
    my %SelectedAttributes = map { $_ => 1 } @{ $Param{XValue}{SelectedValues} };

    my $TicketAttributes    = $Self->_TicketAttributes();
    my $SortedAttributesRef = $Self->_SortedAttributes();
    my @HeaderLine;

    ATTRIBUTE:
    for my $Attribute ( @{$SortedAttributesRef} ) {
        next ATTRIBUTE if !$SelectedAttributes{$Attribute};
        push @HeaderLine, $TicketAttributes->{$Attribute};
    }
    return \@HeaderLine;
}

sub ExportWrapper {
    my ( $Self, %Param ) = @_;

    # wrap ids to used spelling
    for my $Use (qw(UseAsValueSeries UseAsRestriction UseAsXvalue)) {
        ELEMENT:
        for my $Element ( @{ $Param{$Use} } ) {
            next ELEMENT if !$Element || !$Element->{SelectedValues};
            my $ElementName = $Element->{Element};
            my $Values      = $Element->{SelectedValues};

            if ( $ElementName eq 'QueueIDs' || $ElementName eq 'CreatedQueueIDs' ) {
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;
                    $ID->{Content} = $Self->{QueueObject}->QueueLookup( QueueID => $ID->{Content} );
                }
            }
            elsif ( $ElementName eq 'StateIDs' || $ElementName eq 'CreatedStateIDs' ) {
                my %StateList = $Self->{StateObject}->StateList( UserID => 1 );
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;
                    $ID->{Content} = $StateList{ $ID->{Content} };
                }
            }
            elsif ( $ElementName eq 'PriorityIDs' || $ElementName eq 'CreatedPriorityIDs' ) {
                my %PriorityList = $Self->{PriorityObject}->PriorityList( UserID => 1 );
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;
                    $ID->{Content} = $PriorityList{ $ID->{Content} };
                }
            }
            elsif (
                $ElementName eq 'OwnerIDs'
                || $ElementName eq 'CreatedUserIDs'
                || $ElementName eq 'ResponsibleIDs'
                )
            {
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;
                    $ID->{Content} = $Self->{UserObject}->UserLookup( UserID => $ID->{Content} );
                }
            }

            # Locks and statustype don't have to wrap because they are never different
        }
    }
    return \%Param;
}

sub ImportWrapper {
    my ( $Self, %Param ) = @_;

    # wrap used spelling to ids
    for my $Use (qw(UseAsValueSeries UseAsRestriction UseAsXvalue)) {
        ELEMENT:
        for my $Element ( @{ $Param{$Use} } ) {
            next ELEMENT if !$Element || !$Element->{SelectedValues};
            my $ElementName = $Element->{Element};
            my $Values      = $Element->{SelectedValues};

            if ( $ElementName eq 'QueueIDs' || $ElementName eq 'CreatedQueueIDs' ) {
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;
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
            elsif ( $ElementName eq 'StateIDs' || $ElementName eq 'CreatedStateIDs' ) {
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;

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
            elsif ( $ElementName eq 'PriorityIDs' || $ElementName eq 'CreatedPriorityIDs' ) {
                my %PriorityList = $Self->{PriorityObject}->PriorityList( UserID => 1 );
                my %PriorityIDs;
                for my $Key ( keys %PriorityList ) {
                    $PriorityIDs{ $PriorityList{$Key} } = $Key;
                }
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;

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
            elsif (
                $ElementName eq 'OwnerIDs'
                || $ElementName eq 'CreatedUserIDs'
                || $ElementName eq 'ResponsibleIDs'
                )
            {
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;

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

            # Locks and statustype don't have to wrap because they are never different
        }
    }
    return \%Param;
}

sub _TicketAttributes {
    my $Self = shift;

    my %TicketAttributes = (
        Number => 'Number',    # only a counter for a better readability
        TicketNumber => $Self->{ConfigObject}->Get('Ticket::Hook'),

        #TicketID       => 'TicketID',
        Age   => 'Age',
        Title => 'Title',
        Queue => 'Queue',

        #QueueID        => 'QueueID',
        State => 'State',

        #StateID        => 'StateID',
        Priority => 'Priority',

        #PriorityID     => 'PriorityID',
        CustomerID => 'CustomerID',
        Changed    => 'Changed',
        Created    => 'Created',

        #CreateTimeUnix => 'CreateTimeUnix',
        CustomerUserID => 'Customer User',
        Lock           => 'lock',

        #LockID         => 'LockID',
        UnlockTimeout       => 'UnlockTimeout',
        AccountedTime       => 'Accounted time',       # the same wording is in AgentTicketPrint.dtl
        RealTillTimeNotUsed => 'RealTillTimeNotUsed',

        #GroupID        => 'GroupID',
        StateType => 'StateType',
        UntilTime => 'UntilTime',
        Closed    => 'Close Time',
        FirstLock => 'First Lock',

        EscalationResponseTime => 'EscalationResponseTime',
        EscalationUpdateTime   => 'EscalationUpdateTime',
        EscalationSolutionTime => 'EscalationSolutionTime',

        EscalationDestinationIn => 'EscalationDestinationIn',

        # EscalationDestinationTime => 'EscalationDestinationTime',
        EscalationDestinationDate => 'EscalationDestinationDate',
        EscalationTimeWorkingTime => 'EscalationTimeWorkingTime',
        EscalationTime            => 'EscalationTime',

        FirstResponse                    => 'FirstResponse',
        FirstResponseInMin               => 'FirstResponseInMin',
        FirstResponseDiffInMin           => 'FirstResponseDiffInMin',
        FirstResponseTimeWorkingTime     => 'FirstResponseTimeWorkingTime',
        FirstResponseTimeEscalation      => 'FirstResponseTimeEscalation',
        FirstResponseTimeNotification    => 'FirstResponseTimeNotification',
        FirstResponseTimeDestinationTime => 'FirstResponseTimeDestinationTime',
        FirstResponseTimeDestinationDate => 'FirstResponseTimeDestinationDate',
        FirstResponseTime                => 'FirstResponseTime',

        UpdateTimeEscalation      => 'UpdateTimeEscalation',
        UpdateTimeNotification    => 'UpdateTimeNotification',
        UpdateTimeDestinationTime => 'UpdateTimeDestinationTime',
        UpdateTimeDestinationDate => 'UpdateTimeDestinationDate',
        UpdateTimeWorkingTime     => 'UpdateTimeWorkingTime',
        UpdateTime                => 'UpdateTime',

        SolutionTime                => 'SolutionTime',
        SolutionInMin               => 'SolutionInMin',
        SolutionDiffInMin           => 'SolutionDiffInMin',
        SolutionTimeWorkingTime     => 'SolutionTimeWorkingTime',
        SolutionTimeEscalation      => 'SolutionTimeEscalation',
        SolutionTimeNotification    => 'SolutionTimeNotification',
        SolutionTimeDestinationTime => 'SolutionTimeDestinationTime',
        SolutionTimeDestinationDate => 'SolutionTimeDestinationDate',
        SolutionTimeWorkingTime     => 'SolutionTimeWorkingTime',
    );

    if ( $Self->{ConfigObject}->Get('Ticket::Service') ) {
        $TicketAttributes{Service} = 'Service';

        #$TicketAttributes{ServiceID} = 'ServiceID',
        $TicketAttributes{SLA}   = 'SLA';
        $TicketAttributes{SLAID} = 'SLAID';
    }

    if ( $Self->{ConfigObject}->Get('Ticket::Type') ) {
        $TicketAttributes{Type} = 'Type';

        #$TicketAttributes{TypeID} = 'TypeID';
    }

    if ( $Self->{ConfigObject}->Get('Stats::UseAgentElementInStats') ) {
        $TicketAttributes{Owner} = 'Agent/Owner';

        #$TicketAttributes{OwnerID}        = 'OwnerID';
        # ? $TicketAttributes{CreatedUserIDs}  = 'Created by Agent/Owner';
        $TicketAttributes{Responsible} = 'Responsible';

        #$TicketAttributes{ResponsibleID}  = 'ResponsibleID';
    }

    # get free text fields
    FREEKEY:
    for my $FreeKey ( 1 .. 16 ) {

        # get ticket free key config
        my $TicketFreeKey = $Self->{ConfigObject}->Get( 'TicketFreeKey' . $FreeKey );

        next FREEKEY if ref $TicketFreeKey ne 'HASH';

        my @FreeKey = keys %{$TicketFreeKey};

        if ( scalar @FreeKey == 1 ) {
            $TicketAttributes{ 'TicketFreeText' . $FreeKey } = $TicketFreeKey->{ $FreeKey[0] };
        }
        else {
            $TicketAttributes{ 'TicketFreeKey' . $FreeKey }  = 'TicketFreeKey' . $FreeKey;
            $TicketAttributes{ 'TicketFreeText' . $FreeKey } = 'TicketFreeText' . $FreeKey;
        }
    }

    # get free time fields
    FREETIME:
    for my $FreeTime ( 1 .. 6 ) {
        my $TicketFreeTimeKey = $Self->{ConfigObject}->Get( 'TicketFreeTimeKey' . $FreeTime );
        $TicketAttributes{ 'TicketFreeTime' . $FreeTime } = $TicketFreeTimeKey;
    }

    return \%TicketAttributes;
}

sub _SortedAttributes {
    my $Self = shift;

    my @SortedAttributes = qw(
        Number
        TicketNumber
        Age
        Title
        Created
        Changed
        Closed
        Queue
        State
        Priority
        CustomerUserID
        CustomerID
        Service
        SLA
        Type
        Owner
        Responsible
        AccountedTime
        EscalationDestinationIn
        EscalationDestinationTime
        EscalationDestinationDate
        EscalationTimeWorkingTime
        EscalationTime

        FirstResponse
        FirstResponseInMin
        FirstResponseDiffInMin
        FirstResponseTimeWorkingTime
        FirstResponseTimeEscalation
        FirstResponseTimeNotification
        FirstResponseTimeDestinationTime
        FirstResponseTimeDestinationDate
        FirstResponseTime

        UpdateTimeEscalation
        UpdateTimeNotification
        UpdateTimeDestinationTime
        UpdateTimeDestinationDate
        UpdateTimeWorkingTime
        UpdateTime

        SolutionTime
        SolutionInMin
        SolutionDiffInMin
        SolutionTimeWorkingTime
        SolutionTimeEscalation
        SolutionTimeNotification
        SolutionTimeDestinationTime
        SolutionTimeDestinationDate
        SolutionTimeWorkingTime

        FirstLock
        Lock
        StateType
        UntilTime
        UnlockTimeout
        EscalationResponseTime
        EscalationSolutionTime
        EscalationUpdateTime
        RealTillTimeNotUsed
    );

    for my $FreeKey ( 1 .. 16 ) {
        push @SortedAttributes, 'TicketFreeKey' . $FreeKey, 'TicketFreeText' . $FreeKey;
    }

    for my $FreeTime ( 1 .. 6 ) {
        push @SortedAttributes, 'TicketFreeTime' . $FreeTime,
    }

    return \@SortedAttributes;
}

sub _ExtendedAttributesCheck {
    my ( $Self, %Param ) = @_;

    my @ExtendedAttributes = qw(
        FirstResponse
        FirstResponseInMin
        FirstResponseDiffInMin
        FirstResponseTimeWorkingTime
        Closed
        SolutionTime
        SolutionInMin
        SolutionDiffInMin
        SolutionTimeWorkingTime
        FirstLock
    );

    ATTRIBUTE:
    for my $Attribute (@ExtendedAttributes) {
        return 1 if $Param{TicketAttributes}{$Attribute};
    }

    return;
}

sub _OrderByIsValueOfTicketSearchSort {
    my ( $Self, %Param ) = @_;

    my %SortOptions = (
        Age                    => 'Age',
        Created                => 'Age',
        CustomerID             => 'CustomerID',
        EscalationResponseTime => 'EscalationResponseTime',
        EscalationSolutionTime => 'EscalationSolutionTime',
        EscalationTime         => 'EscalationTime',
        EscalationUpdateTime   => 'EscalationUpdateTime',
        Lock                   => 'Lock',
        Owner                  => 'Owner',
        Priority               => 'Priority',
        Queue                  => 'Queue',
        Responsible            => 'Responsible',
        SLA                    => 'SLA',
        Service                => 'Service',
        State                  => 'State',
        TicketNumber           => 'Ticket',
        TicketEscalation       => 'TicketEscalation',
        TicketFreeKey1         => 'TicketFreeKey1',
        TicketFreeKey10        => 'TicketFreeKey10',
        TicketFreeKey11        => 'TicketFreeKey11',
        TicketFreeKey12        => 'TicketFreeKey12',
        TicketFreeKey13        => 'TicketFreeKey13',
        TicketFreeKey14        => 'TicketFreeKey14',
        TicketFreeKey15        => 'TicketFreeKey15',
        TicketFreeKey16        => 'TicketFreeKey16',
        TicketFreeKey2         => 'TicketFreeKey2',
        TicketFreeKey3         => 'TicketFreeKey3',
        TicketFreeKey4         => 'TicketFreeKey4',
        TicketFreeKey5         => 'TicketFreeKey5',
        TicketFreeKey6         => 'TicketFreeKey6',
        TicketFreeKey7         => 'TicketFreeKey7',
        TicketFreeKey8         => 'TicketFreeKey8',
        TicketFreeKey9         => 'TicketFreeKey9',
        TicketFreeText1        => 'TicketFreeText1',
        TicketFreeText10       => 'TicketFreeText10',
        TicketFreeText11       => 'TicketFreeText11',
        TicketFreeText12       => 'TicketFreeText12',
        TicketFreeText13       => 'TicketFreeText13',
        TicketFreeText14       => 'TicketFreeText14',
        TicketFreeText15       => 'TicketFreeText15',
        TicketFreeText16       => 'TicketFreeText16',
        TicketFreeText2        => 'TicketFreeText2',
        TicketFreeText3        => 'TicketFreeText3',
        TicketFreeText4        => 'TicketFreeText4',
        TicketFreeText5        => 'TicketFreeText5',
        TicketFreeText6        => 'TicketFreeText6',
        TicketFreeText7        => 'TicketFreeText7',
        TicketFreeText8        => 'TicketFreeText8',
        TicketFreeText9        => 'TicketFreeText9',
        TicketFreeTime1        => 'TicketFreeTime1',
        TicketFreeTime2        => 'TicketFreeTime2',
        TicketFreeTime3        => 'TicketFreeTime3',
        TicketFreeTime4        => 'TicketFreeTime4',
        TicketFreeTime5        => 'TicketFreeTime5',
        TicketFreeTime6        => 'TicketFreeTime6',
        Title                  => 'Title',
        Type                   => 'Type',
    );

    return $SortOptions{ $Param{OrderBy} } if $SortOptions{ $Param{OrderBy} };
    return;
}

sub _IndividualResultOrder {
    my ( $Self, %Param ) = @_;
    my @Unsorted = @{ $Param{StatArray} };
    my @Sorted;

    # find out the positon of the values which should be
    # used for the order
    my $Counter          = 0;
    my $SortedAttributes = $Self->_SortedAttributes();

    ATTRIBUTE:
    for my $Attribute ( @{$SortedAttributes} ) {
        next ATTRIBUTE if !$Param{SelectedAttributes}{$Attribute};
        last ATTRIBUTE if $Attribute eq $Param{OrderBy};
        $Counter++;
    }

    # order after a individual attribute
    if ( $Param{OrderBy} eq 'AccountedTime' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'SolutionTime' ) {
        @Sorted = sort { $a->[$Counter] cmp $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'SolutionDiffInMin' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'SolutionInMin' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'SolutionTimeWorkingTime' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'FirstResponse' ) {
        @Sorted = sort { $a->[$Counter] cmp $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'FirstResponseDiffInMin' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'FirstResponseInMin' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'FirstResponseTimeWorkingTime' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'FirstLock' ) {
        @Sorted = sort { $a->[$Counter] cmp $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'StateType' ) {
        @Sorted = sort { $a->[$Counter] cmp $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'UntilTime' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'UnlockTimeout' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'EscalationResponseTime' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'EscalationUpdateTime' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'EscalationSolutionTime' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'RealTillTimeNotUsed' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'EscalationTimeWorkingTime' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message =>
                "There is no possibility to order the stats by $Param{OrderBy}! Sort it alpha numerical",
        );
        @Sorted = sort { $a->[$Counter] cmp $b->[$Counter] } @Unsorted;
    }

    # make a reverse sort if needed
    if ( $Param{Sort} eq 'Down' ) {
        @Sorted = reverse @Sorted;
    }

    # take care about the limit
    if ( $Param{Limit} && $Param{Limit} ne 'unlimited' ) {
        my $Count = 0;
        @Sorted = grep { ++$Count <= $Param{Limit} } @Sorted;
    }

    return @Sorted;
}

1;
