# --
# Kernel/System/Stats/Dynamic/TicketAccountedTime.pm - stats for accounted ticket time
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: TicketAccountedTime.pm,v 1.1 2009-03-19 16:59:52 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Stats::Dynamic::TicketAccountedTime;

use strict;
use warnings;

use Kernel::System::Queue;
use Kernel::System::Service;
use Kernel::System::SLA;
use Kernel::System::Ticket;
use Kernel::System::Type;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

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

    return 'TicketAccountedTime';
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
            Name             => 'Art der Auswertung',
            UseAsXvalue      => 1,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'KindsOfReporting',
            Block            => 'MultiSelectField',
            Translation      => 0, # because of current sorting problems with AgentStats_ColumnAndRowTranslation
            Sort             => 'IndividualKey',
            SortIndividual   => $Self->_SortedKindsOfReporting(),
            Values           => $Self->_KindsOfReporting(),
        },
        {
            Name             => 'Queue',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'QueueIDs',
            Block            => 'MultiSelectField',
            Translation      => 0,
            Values           => \%QueueList,
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
            Name             => 'Created in Queue',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'CreatedQueueIDs',
            Block            => 'MultiSelectField',
            Translation      => 0,
            Values           => \%QueueList,
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
            Name             => 'Ticket/Article Accounted Time',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'ArticleAccountedTime',
            TimePeriodFormat => 'DateInputFormat',    # 'DateInputFormatLong',
            Block            => 'Time',
            Values           => {
                TimeStart => 'ArticleAccountedTimeNewerDate',
                TimeStop  => 'ArticleAccountedTimeOlderDate',
            },
        },
        {
            Name             => 'Ticket Create Time',
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
            Name             => 'Ticket Close Time',
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
                Name             => 'Service',
                UseAsXvalue      => 1,
                UseAsValueSeries => 1,
                UseAsRestriction => 1,
                Element          => 'ServiceIDs',
                Block            => 'MultiSelectField',
                Translation      => 0,
                Values           => \%Service,
            },
            {
                Name             => 'SLA',
                UseAsXvalue      => 1,
                UseAsValueSeries => 1,
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
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
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
                Name             => 'Accounted by Agent/Owner',
                UseAsXvalue      => 1,
                UseAsValueSeries => 1,
                UseAsRestriction => 1,
                Element          => 'AccountedByOwner',
                Block            => 'MultiSelectField',
                Translation      => 0,
                Values           => \%UserList,
            },
            {
                Name             => 'Agent/Owner',
                UseAsXvalue      => 1,
                UseAsValueSeries => 1,
                UseAsRestriction => 1,
                Element          => 'OwnerIDs',
                Block            => 'MultiSelectField',
                Translation      => 0,
                Values           => \%UserList,
            },
            {
                Name             => 'Created by Agent/Owner',
                UseAsXvalue      => 1,
                UseAsValueSeries => 1,
                UseAsRestriction => 1,
                Element          => 'CreatedUserIDs',
                Block            => 'MultiSelectField',
                Translation      => 0,
                Values           => \%UserList,
            },
            {
                Name             => 'Responsible',
                UseAsXvalue      => 1,
                UseAsValueSeries => 1,
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
                Name             => 'TicketFreeKey' . $FreeKey,
                UseAsXvalue      => 1,
                UseAsValueSeries => 1,
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
                UseAsXvalue      => 1,
                UseAsValueSeries => 1,
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
    my @StatArray = ();
    if ( $Param{XValue}{Element} && $Param{XValue}{Element} eq 'KindsOfReporting' ) {

        # search the total sum of each row
        for my $Row (sort keys %{$Param{TableStructure}}) {
            my @ResultRow      = ($Row);
            my %SearchAttributes = ( %{$Param{TableStructure}{$Row}[0]} );

            my %Reporting = $Self->_ReportingValues(
                SearchAttributes => \%SearchAttributes,
                SelectedKindsOfReporting => $Param{XValue}{SelectedValues},
            );

            KIND:
            for my $Kind (@{ $Self->_SortedKindsOfReporting() }) {
                next KIND if !defined $Reporting{$Kind};
                push @ResultRow, $Reporting{$Kind};
            }

            push @StatArray, \@ResultRow;
        }
    }
    else {
        my $KindsOfReportingRef = $Self->_KindsOfReporting();

        if (!$Param{Restrictions}{KindsOfReporting}) {
            $Param{Restrictions}{KindsOfReporting} = [];
        }

        my $NumberOfReportingKinds = scalar @{$Param{Restrictions}{KindsOfReporting}};
        my $SelectedKindsOfReporting = $Param{Restrictions}{KindsOfReporting};
        if (!$NumberOfReportingKinds) {
            push @{$SelectedKindsOfReporting}, 'Total';
        }
        delete $Param{Restrictions}{KindsOfReporting};

        # search the total sum of each row
        for my $Row (sort keys %{$Param{TableStructure}}) {
            my @ResultRow      = ($Row);

            for my $Cell ( @{$Param{TableStructure}{$Row}} ) {
                my %SearchAttributes = %{$Cell};

                my %Reporting = $Self->_ReportingValues(
                    SearchAttributes => \%SearchAttributes,
                    SelectedKindsOfReporting => $SelectedKindsOfReporting,
                );

                my $CellContent = '';

                if (!$NumberOfReportingKinds || $NumberOfReportingKinds == 1 ) {
                    my @Values = values %Reporting;
                    $CellContent = $Values[0];
                }
                else {

                    KIND:
                    for my $Kind (@{ $Self->_SortedKindsOfReporting() }) {
                        next KIND if !defined $Reporting{$Kind};
                        $CellContent .= "$Reporting{$Kind} (" . $KindsOfReportingRef->{$Kind} . "), ";
                    }
                }
                push @ResultRow, $CellContent;
            }
            push @StatArray, \@ResultRow;
        }
    }
    return @StatArray;
}

sub _ReportingValues {
    my ( $Self, %Param ) = @_;
    my $SearchAttributes = $Param{SearchAttributes};
    my @Where = ();

    # get ticket search relevant attributes
    my %TicketSearch = ();
    ATTRIBUTE:
    for my $Attribute ( @{$Self->_AllowedTicketSearchAttributes()} ) {
        next ATTRIBUTE if !$SearchAttributes->{$Attribute};
        $TicketSearch{$Attribute} = $SearchAttributes->{$Attribute};
    }

    if ( %TicketSearch ) {
        # get the involved tickets
        my @TicketIDs =  $Self->{TicketObject}->TicketSearch(
            UserID                  => 1,
            Result                  => 'ARRAY',
            Permission              => 'ro',
            Limit                   => 100_000_000,
            %TicketSearch,
        );

        # do nothing, if there are no tickets
        if (!@TicketIDs) {
            my %Reporting = ();
            for my $Kind (@{$Param{SelectedKindsOfReporting}}) {
                $Reporting{$Kind} = 0;
            }
            return %Reporting;
        }

        my $TicketString =  join ', ', @TicketIDs;
        push @Where, "ticket_id IN ( $TicketString )";
    }

    if ($SearchAttributes->{AccountedByOwner} ) {
        my @AccountedByOwner = map {$Self->{DBObject}->Quote( $_, 'Integer' )} @{$SearchAttributes->{AccountedByOwner}};
        my $String = join ', ', @AccountedByOwner;
        push @Where, "create_by IN ( $String )";
    }

    if ($SearchAttributes->{ArticleAccountedTimeOlderDate} && $SearchAttributes->{ArticleAccountedTimeNewerDate} ) {
        my $Start = $Self->{DBObject}->Quote( $SearchAttributes->{ArticleAccountedTimeNewerDate} );
        my $Stop  = $Self->{DBObject}->Quote( $SearchAttributes->{ArticleAccountedTimeOlderDate} );
        push @Where, "create_time >= '$Start' AND create_time <= '$Stop'";
    }
    my $WhereString = '';
    if (@Where) {
        $WhereString = 'WHERE ' . join ' AND ', @Where;
    }

    # ask only for the needed kinds to get a better performance
    my %SelectedKindsOfReporting = map {$_ => 1} @{$Param{SelectedKindsOfReporting}};
    my %Reporting = ();

    if ( $SelectedKindsOfReporting{Total} ) {
        # db query
        $Self->{DBObject}->Prepare(
            SQL  => "SELECT SUM(time_unit) FROM time_accounting $WhereString"
        );

        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $Reporting{Total} = $Row[0] ? int ($Row[0] * 100) / 100 : 0;
        }
    }
    if (   !$SelectedKindsOfReporting{AveragePerTicket}
        && !$SelectedKindsOfReporting{MinPerTicket}
        && !$SelectedKindsOfReporting{MaxPerTicket}
        && !$SelectedKindsOfReporting{NumberOfTickets}
        && !$SelectedKindsOfReporting{AveragePerArticle}
        && !$SelectedKindsOfReporting{MinPerArticle}
        && !$SelectedKindsOfReporting{MaxPerArticle}
        && !$SelectedKindsOfReporting{NumberOfArticle}
    ) {
        return %Reporting;
    }

    # db query
    $Self->{DBObject}->Prepare(
        SQL  => "SELECT ticket_id, article_id, time_unit FROM time_accounting $WhereString"
    );

    my %TicketID = ();
    my %ArticleID = ();
    my $Time = 0;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $TicketID {$Row[0]} += $Row[2];
        $ArticleID{$Row[1]} += $Row[2];
        $Time += $Row[2];
    }

    my @TicketTimeLine  = sort { $a <=> $b} values %TicketID;
    my @ArticleTimeLine = sort { $a <=> $b} values %ArticleID;

    if ($SelectedKindsOfReporting{AveragePerTicket} ) {
        my $NumberOfTickets = scalar keys %TicketID;
        my $Average = $NumberOfTickets ? $Time / $NumberOfTickets : 0;
        $Reporting{AveragePerTicket} = sprintf("%.2f", $Average);
    }
    if ( $SelectedKindsOfReporting{MinPerTicket} ) {
        $Reporting{MinPerTicket} = $TicketTimeLine[0] || 0;
    }
    if ( $SelectedKindsOfReporting{MaxPerTicket} ) {
        $Reporting{MaxPerTicket} = $TicketTimeLine[-1] || 0;
    }
    if ( $SelectedKindsOfReporting{NumberOfTickets} ) {
        $Reporting{NumberOfTickets} = scalar keys %TicketID;
    }
    if ( $SelectedKindsOfReporting{AveragePerArticle} ) {
        my $NumberOfArticles = scalar keys %ArticleID;
        my $Average = $NumberOfArticles ? $Time / $NumberOfArticles : 0;
        $Reporting{AveragePerArticle} = sprintf("%.2f", $Average);
    }
    if ( $SelectedKindsOfReporting{MinPerArticle} ) {
        $Reporting{MinPerArticle} = $ArticleTimeLine[0] || 0;
    }
    if ( $SelectedKindsOfReporting{MaxPerArticle} ) {
        $Reporting{MaxPerArticle} = $ArticleTimeLine[-1] || 0;
    }
    if ( $SelectedKindsOfReporting{NumberOfArticle} ) {
        $Reporting{NumberOfArticle} = scalar keys %ArticleID;
    }

    return %Reporting;
}

sub _KindsOfReporting {
    my $Self = shift;
    my %KindsOfReporting = (
        Total           => 'Total',
        AveragePerTicket=> 'Average per Ticket',
        MinPerTicket    => 'Min per Ticket',
        MaxPerTicket    => 'Max per Ticket',
        NumberOfTickets => 'NumberOfTickets',
        AveragePerArticle => 'Average per Article',
        MinPerArticle    => 'Min per Article',
        MaxPerArticle    => 'Max per Article',
        NumberOfArticle  => 'NumberOfArticle',
    );
    return \%KindsOfReporting;
}

sub _SortedKindsOfReporting {
    my $Self = shift;
    my @SortedKindsOfReporting = qw(
        Total
        AveragePerTicket
        MinPerTicket
        MaxPerTicket
        NumberOfTickets
        AveragePerArticle
        MinPerArticle
        MaxPerArticle
        NumberOfArticle
    );
    return \@SortedKindsOfReporting;
}

sub _AllowedTicketSearchAttributes {
    my $Self = shift;
    my @Attributes = (
        'QueueIDs',
        'StateIDs',
        'State Type',
        'StateTypeIDs',
        'PriorityIDs',
        'CreatedQueueIDs',
        'CreatedPriorityIDs',
        'CreatedStateIDs',
        'LockIDs',
        'Title',
        'CustomerUserLogin',
        'From',
        'To',
        'Cc',
        'Subject',
        'Body',
        'CreateTime',
        'CloseTime',
        'EscalationTime',
        'EscalationResponseTime',
        'EscalationUpdateTime',
        'EscalationSolutionTime',
        'ServiceIDs',
        'SLAIDs',
        'TypeIDs',
        'OwnerIDs',
        'CreatedUserIDs',
        'ResponsibleIDs',
        'CustomerID',
    );

    FREEKEY:
    for my $FreeKey ( 1 .. 16 ) {
        push @Attributes, 'TicketFreeKey' . $FreeKey, 'TicketFreeText' . $FreeKey;
    }

    return \@Attributes;
}
1;
