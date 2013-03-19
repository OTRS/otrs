# --
# Kernel/GenericInterface/Operation/Ticket/TicketSearch.pm - GenericInterface Ticket Search operation backend
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation::Ticket::TicketSearch;

use strict;
use warnings;

use Kernel::System::Ticket;
use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;
use Kernel::System::VariableCheck qw( :all );
use Kernel::GenericInterface::Operation::Common;
use Kernel::GenericInterface::Operation::Ticket::Common;

use vars qw(@ISA);

=head1 NAME

Kernel::GenericInterface::Operation::Ticket::TicketSearch - GenericInterface Ticket Search Operation backend

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Operation->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (
        qw(DebuggerObject ConfigObject MainObject LogObject TimeObject DBObject EncodeObject WebserviceID)
        )
    {
        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!"
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

    # create additional objects
    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new(%Param);
    $Self->{DFBackendObject}    = Kernel::System::DynamicField::Backend->new(%Param);
    $Self->{CommonObject}       = Kernel::GenericInterface::Operation::Common->new( %{$Self} );
    $Self->{TicketCommonObject}
        = Kernel::GenericInterface::Operation::Ticket::Common->new( %{$Self} );
    $Self->{TicketObject} = Kernel::System::Ticket->new( %{$Self} );

    # get config for this screen
    $Self->{Config} = $Self->{ConfigObject}->Get('GenericInterface::Operation::TicketCreate');

    return $Self;
}

=item Run()

perform TicketSearch Operation. This will return a Ticket ID list.

    my $Result = $OperationObject->Run(
        # ticket number (optional) as STRING or as ARRAYREF
        TicketNumber => '%123546%',
        TicketNumber => ['%123546%', '%123666%'],

        # ticket title (optional) as STRING or as ARRAYREF
        Title => '%SomeText%',
        Title => ['%SomeTest1%', '%SomeTest2%'],

        Queues   => ['system queue', 'other queue'],
        QueueIDs => [1, 42, 512],

        # use also sub queues of Queue|Queues in search
        UseSubQueues => 0,

        # You can use types like normal, ...
        Types   => ['normal', 'change', 'incident'],
        TypeIDs => [3, 4],

        # You can use states like new, open, pending reminder, ...
        States   => ['new', 'open'],
        StateIDs => [3, 4],

        # (Open|Closed) tickets for all closed or open tickets.
        StateType => 'Open',

        # You also can use real state types like new, open, closed,
        # pending reminder, pending auto, removed and merged.
        StateType    => ['open', 'new'],
        StateTypeIDs => [1, 2, 3],

        Priorities  => ['1 very low', '2 low', '3 normal'],
        PriorityIDs => [1, 2, 3],

        Services   => ['Service A', 'Service B'],
        ServiceIDs => [1, 2, 3],

        SLAs   => ['SLA A', 'SLA B'],
        SLAIDs => [1, 2, 3],

        Locks   => ['unlock'],
        LockIDs => [1, 2, 3],

        OwnerIDs => [1, 12, 455, 32]

        ResponsibleIDs => [1, 12, 455, 32]

        WatchUserIDs => [1, 12, 455, 32]

        # CustomerID (optional) as STRING or as ARRAYREF
        CustomerID => '123',
        CustomerID => ['123', 'ABC'],

        # CustomerUserLogin (optional) as STRING as ARRAYREF
        CustomerUserLogin => 'uid123',
        CustomerUserLogin => ['uid123', 'uid777'],

        # create ticket properties (optional)
        CreatedUserIDs     => [1, 12, 455, 32]
        CreatedTypes       => ['normal', 'change', 'incident'],
        CreatedTypeIDs     => [1, 2, 3],
        CreatedPriorities  => ['1 very low', '2 low', '3 normal'],
        CreatedPriorityIDs => [1, 2, 3],
        CreatedStates      => ['new', 'open'],
        CreatedStateIDs    => [3, 4],
        CreatedQueues      => ['system queue', 'other queue'],
        CreatedQueueIDs    => [1, 42, 512],

        # DynamicFields
        #   At least one operator must be specified. Operators will be connected with AND,
        #       values in an operator with OR.
        #   You can also pass more than one argument to an operator: ['value1', 'value2']
        DynamicField_FieldNameX => {
            Equals            => 123,
            Like              => 'value*',                # "equals" operator with wildcard support
            GreaterThan       => '2001-01-01 01:01:01',
            GreaterThanEquals => '2001-01-01 01:01:01',
            SmallerThan       => '2002-02-02 02:02:02',
            SmallerThanEquals => '2002-02-02 02:02:02',
        }

        # article stuff (optional)
        From    => '%spam@example.com%',
        To      => '%support@example.com%',
        Cc      => '%client@example.com%',
        Subject => '%VIRUS 32%',
        Body    => '%VIRUS 32%',

        # use full article text index if configured (optional, default off)
        FullTextIndex => 1,

        # article content search (AND or OR for From, To, Cc, Subject and Body) (optional)
        ContentSearch => 'AND',

        # content conditions for From,To,Cc,Subject,Body
        # Title,CustomerID and CustomerUserLogin (all optional)
        ConditionInline => 1,

        # articles created more than 60 minutes ago (article older than 60 minutes) (optional)
        ArticleCreateTimeOlderMinutes => 60,
        # articles created less than 120 minutes ago (article newer than 60 minutes) (optional)
        ArticleCreateTimeNewerMinutes => 120,

        # articles with create time after ... (article newer than this date) (optional)
        ArticleCreateTimeNewerDate => '2006-01-09 00:00:01',
        # articles with created time before ... (article older than this date) (optional)
        ArticleCreateTimeOlderDate => '2006-01-19 23:59:59',

        # tickets created more than 60 minutes ago (ticket older than 60 minutes)  (optional)
        TicketCreateTimeOlderMinutes => 60,
        # tickets created less than 120 minutes ago (ticket newer than 120 minutes) (optional)
        TicketCreateTimeNewerMinutes => 120,

        # tickets with create time after ... (ticket newer than this date) (optional)
        TicketCreateTimeNewerDate => '2006-01-09 00:00:01',
        # tickets with created time before ... (ticket older than this date) (optional)
        TicketCreateTimeOlderDate => '2006-01-19 23:59:59',

        # tickets changed more than 60 minutes ago (optional)
        TicketChangeTimeOlderMinutes => 60,
        # tickets changed less than 120 minutes ago (optional)
        TicketChangeTimeNewerMinutes => 120,

        # tickets with changed time after ... (ticket changed newer than this date) (optional)
        TicketChangeTimeNewerDate => '2006-01-09 00:00:01',
        # tickets with changed time before ... (ticket changed older than this date) (optional)
        TicketChangeTimeOlderDate => '2006-01-19 23:59:59',

        # tickets closed more than 60 minutes ago (optional)
        TicketCloseTimeOlderMinutes => 60,
        # tickets closed less than 120 minutes ago (optional)
        TicketCloseTimeNewerMinutes => 120,

        # tickets with closed time after ... (ticket closed newer than this date) (optional)
        TicketCloseTimeNewerDate => '2006-01-09 00:00:01',
        # tickets with closed time before ... (ticket closed older than this date) (optional)
        TicketCloseTimeOlderDate => '2006-01-19 23:59:59',

        # tickets with pending time of more than 60 minutes ago (optional)
        TicketPendingTimeOlderMinutes => 60,
        # tickets with pending time of less than 120 minutes ago (optional)
        TicketPendingTimeNewerMinutes => 120,

        # tickets with pending time after ... (optional)
        TicketPendingTimeNewerDate => '2006-01-09 00:00:01',
        # tickets with pending time before ... (optional)
        TicketPendingTimeOlderDate => '2006-01-19 23:59:59',

        # you can use all following escalation options with this four different ways of escalations
        # TicketEscalationTime...
        # TicketEscalationUpdateTime...
        # TicketEscalationResponseTime...
        # TicketEscalationSolutionTime...

        # ticket escalation time of more than 60 minutes ago (optional)
        TicketEscalationTimeOlderMinutes => -60,
        # ticket escalation time of less than 120 minutes ago (optional)
        TicketEscalationTimeNewerMinutes => -120,

        # tickets with escalation time after ... (optional)
        TicketEscalationTimeNewerDate => '2006-01-09 00:00:01',
        # tickets with escalation time before ... (optional)
        TicketEscalationTimeOlderDate => '2006-01-09 23:59:59',

        # search in archive (optional)
        ArchiveFlags => ['y', 'n'],

        # OrderBy and SortBy (optional)
        OrderBy => 'Down',  # Down|Up
        SortBy  => 'Age',   # Owner|Responsible|CustomerID|State|TicketNumber|Queue|Priority|Age|Type|Lock
                            # Changed|Title|Service|SLA|PendingTime|EscalationTime
                            # EscalationUpdateTime|EscalationResponseTime|EscalationSolutionTime
                            # DynamicField_FieldNameX
                            # TicketFreeTime1-6|TicketFreeKey1-16|TicketFreeText1-16

        # OrderBy and SortBy as ARRAY for sub sorting (optional)
        OrderBy => ['Down', 'Up'],
        SortBy  => ['Priority', 'Age'],
        },
    );

    $Result = {
        Success      => 1,                                # 0 or 1
        ErrorMessage => '',                               # In case of an error
        Data         => {
            TicketID => [ 1, 2, 3, 4 ],
        },
    };

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my ( $UserID, $UserType ) = $Self->{CommonObject}->Auth(
        %Param
    );

    return $Self->{TicketCommonObject}->ReturnError(
        ErrorCode    => 'TicketSearch.AuthFail',
        ErrorMessage => "TicketSearch: Authorization failing!",
    ) if !$UserID;

    # all needed variables
    $Self->{SearchLimit} = $Self->{Config}->{SearchLimit} || 500;
    $Self->{SortBy} = $Param{Data}->{SortBy}
        || $Self->{Config}->{'SortBy::Default'}
        || 'Age';
    $Self->{OrderBy} = $Param{Data}->{OrderBy}
        || $Self->{Config}->{'Order::Default'}
        || 'Down';
    $Self->{FullTextIndex} = $Param{Data}->{FullTextIndex} || 0;

    # get parameter from data
    my %GetParam = $Self->_GetParams( %{ $Param{Data} } );

    # create time settings
    %GetParam = $Self->_CreateTimeSettings(%GetParam);

    # get dynamic fields
    my %DynamicFieldSearchParameters = $Self->_GetDynamicFields( %{ $Param{Data} } );

    # perform ticket search
    my @TicketIDs = $Self->{TicketObject}->TicketSearch(
        %GetParam,
        %DynamicFieldSearchParameters,
        Result              => 'ARRAY',
        SortBy              => $Self->{SortBy},
        OrderBy             => $Self->{OrderBy},
        Limit               => $Self->{SearchLimit},
        UserID              => $UserID,
        ConditionInline     => $Self->{Config}->{ExtendedSearchCondition},
        ContentSearchPrefix => '*',
        ContentSearchSuffix => '*',
        FullTextIndex       => $Self->{FullTextIndex},
    );

    if (@TicketIDs) {

        return {
            Success => 1,
            Data    => {
                TicketID => \@TicketIDs,
            },
        };
    }

    # return result
    return {
        Success => 1,
        Data    => {},
    };
}

=begin Internal:

=item _GetParams()

get search parameters.

    my %GetParam = _GetParams(
        %Params,                          # all ticket parameters
    );

    returns:

    %GetParam = {
        AllowedParams => 'WithContent', # return not empty parameters for search
    }

=cut

sub _GetParams {
    my ( $Self, %Param ) = @_;

    # get single params
    my %GetParam;

    for my $Item (
        qw(TicketNumber Title From To Cc Subject Body
        Agent ResultForm TimeSearchType ChangeTimeSearchType CloseTimeSearchType UseSubQueues
        ArticleTimeSearchType SearchInArchive
        Fulltext ShownAttributes
        )
        )
    {

        # get search string params (get submitted params)
        if ( IsStringWithData( $Param{$Item} ) ) {

            $GetParam{$Item} = $Param{$Item};

            # remove white space on the start and end
            $GetParam{$Item} =~ s/\s+$//g;
            $GetParam{$Item} =~ s/^\s+//g;
        }
    }

    # get array params
    for my $Item (
        qw( StateIDs StateTypeIDs QueueIDs PriorityIDs OwnerIDs
        CreatedUserIDs WatchUserIDs ResponsibleIDs
        TypeIDs ServiceIDs SLAIDs LockIDs Queues Types States
        Priorities Services SLAs Locks
        CreatedTypes CreatedTypeIDs CreatedPriorities
        CreatedPriorityIDs CreatedStates CreatedStateIDs
        CreatedQueues CreatedQueueIDs StateType CustomerID
        CustomerUserLogin )
        )
    {

        # get search array params
        my @Values;
        if ( IsArrayRefWithData( $Param{$Item} ) ) {
            @Values = @{ $Param{$Item} };
        }
        elsif ( IsStringWithData( $Param{$Item} ) ) {
            @Values = ( $Param{$Item} );
        }
        $GetParam{$Item} = \@Values if scalar @Values;
    }

    # get escalation times
    my %EscalationTimes = (
        1 => '',
        2 => 'Update',
        3 => 'Response',
        4 => 'Solution',
    );

    for my $Index ( sort keys %EscalationTimes ) {
        for my $PostFix (qw( OlderMinutes NewerMinutes NewerDate OlderDate )) {
            my $Item = 'TicketEscalation' . $EscalationTimes{$Index} . $PostFix;

            # get search string params (get submitted params)
            if ( IsStringWithData( $Param{$Item} ) ) {
                $GetParam{$Item} = $Param{$Item};

                # remove white space on the start and end
                $GetParam{$Item} =~ s/\s+$//g;
                $GetParam{$Item} =~ s/^\s+//g;
            }
        }
    }

    my @Prefixes = (
        'TicketCreateTime',
        'TicketChangeTime',
        'TicketCloseTime',
        'TicketPendingTime',
        'ArticleCreateTime',
    );

    my @Postfixes = (
        'Point',
        'PointFormat',
        'PointStart',
        'Start',
        'StartDay',
        'StartMonth',
        'StartYear',
        'Stop',
        'StopDay',
        'StopMonth',
        'StopYear',
        'OlderMinutes',
        'NewerMinutes',
        'OlderDate',
        'NewerDate',
    );

    for my $Prefix (@Prefixes) {

        # get search string params (get submitted params)
        if ( IsStringWithData( $Param{$Prefix} ) ) {
            $GetParam{$Prefix} = $Param{$Prefix};

            # remove white space on the start and end
            $GetParam{$Prefix} =~ s/\s+$//g;
            $GetParam{$Prefix} =~ s/^\s+//g;
        }

        for my $Postfix (@Postfixes) {
            my $Item = $Prefix . $Postfix;

            # get search string params (get submitted params)
            if ( IsStringWithData( $Param{$Item} ) ) {
                $GetParam{$Item} = $Param{$Item};

                # remove white space on the start and end
                $GetParam{$Item} =~ s/\s+$//g;
                $GetParam{$Item} =~ s/^\s+//g;
            }
        }
    }

    return %GetParam;

}

=item _GetDynamicFields()

get search parameters.

    my %DynamicFieldSearchParameters = _GetDynamicFields(
        %Params,                          # all ticket parameters
    );

    returns:

    %DynamicFieldSearchParameters = {
        'AllAllowedDF' => 'WithData',   # return not empty parameters for search
    }

=cut

sub _GetDynamicFields {
    my ( $Self, %Param ) = @_;

    # dynamic fields search parameters for ticket search
    my %DynamicFieldSearchParameters;

    # get single params
    my %AttributeLookup;

    # get the dynamic fields for ticket object
    $Self->{DynamicField} = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => ['Ticket'],
    );

    for my $ParameterName ( sort keys %Param ) {
        if ( $ParameterName =~ m{\A DynamicField_ ( [a-zA-Z\d]+ ) \z}xms ) {

            # loop over the dynamic fields configured
            DYNAMICFIELD:
            for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
                next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
                next DYNAMICFIELD if !$DynamicFieldConfig->{Name};

                # skip all fields that does not match with current field name ($1)
                # without the 'DynamicField_' prefix
                next DYNAMICFIELD if $DynamicFieldConfig->{Name} ne $1;

                # get new search parameter
                my $SearchParameter
                    = $Self->{DFBackendObject}->CommonSearchFieldParameterBuild(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Value              => $Param{$ParameterName},
                    );

                # add new search parameter
                # set search parameter
                if ( defined $SearchParameter ) {
                    $DynamicFieldSearchParameters{ 'DynamicField_' . $DynamicFieldConfig->{Name} }
                        = $Param{ 'DynamicField_' . $DynamicFieldConfig->{Name} };
                }
            }
        }
    }

    # allow free fields

    return %DynamicFieldSearchParameters;

}

=item _CreateTimeSettings()

get search parameters.

    my %GetParam = _CreateTimeSettings(
        %Params,                          # all ticket parameters
    );

    returns:

    %GetParam = {
        AllowedTimeSettings => 'WithData',   # return not empty parameters for search
    }

=cut

sub _CreateTimeSettings {
    my ( $Self, %Param ) = @_;

    # get single params
    my %GetParam = %Param;

    # get close time settings
    if ( !$GetParam{ChangeTimeSearchType} ) {

        # do nothing on time stuff
    }
    elsif ( $GetParam{ChangeTimeSearchType} eq 'TimeSlot' ) {
        for (qw(Month Day)) {
            $GetParam{"TicketChangeTimeStart$_"}
                = sprintf( "%02d", $GetParam{"TicketChangeTimeStart$_"} );
        }
        for (qw(Month Day)) {
            $GetParam{"TicketChangeTimeStop$_"}
                = sprintf( "%02d", $GetParam{"TicketChangeTimeStop$_"} );
        }
        if (
            $GetParam{TicketChangeTimeStartDay}
            && $GetParam{TicketChangeTimeStartMonth}
            && $GetParam{TicketChangeTimeStartYear}
            )
        {
            $GetParam{TicketChangeTimeNewerDate}
                = $GetParam{TicketChangeTimeStartYear} . '-'
                . $GetParam{TicketChangeTimeStartMonth} . '-'
                . $GetParam{TicketChangeTimeStartDay}
                . ' 00:00:00';
        }
        if (
            $GetParam{TicketChangeTimeStopDay}
            && $GetParam{TicketChangeTimeStopMonth}
            && $GetParam{TicketChangeTimeStopYear}
            )
        {
            $GetParam{TicketChangeTimeOlderDate}
                = $GetParam{TicketChangeTimeStopYear} . '-'
                . $GetParam{TicketChangeTimeStopMonth} . '-'
                . $GetParam{TicketChangeTimeStopDay}
                . ' 23:59:59';
        }
    }
    elsif ( $GetParam{ChangeTimeSearchType} eq 'TimePoint' ) {
        if (
            $GetParam{TicketChangeTimePoint}
            && $GetParam{TicketChangeTimePointStart}
            && $GetParam{TicketChangeTimePointFormat}
            )
        {
            my $Time = 0;
            if ( $GetParam{TicketChangeTimePointFormat} eq 'minute' ) {
                $Time = $GetParam{TicketChangeTimePoint};
            }
            elsif ( $GetParam{TicketChangeTimePointFormat} eq 'hour' ) {
                $Time = $GetParam{TicketChangeTimePoint} * 60;
            }
            elsif ( $GetParam{TicketChangeTimePointFormat} eq 'day' ) {
                $Time = $GetParam{TicketChangeTimePoint} * 60 * 24;
            }
            elsif ( $GetParam{TicketChangeTimePointFormat} eq 'week' ) {
                $Time = $GetParam{TicketChangeTimePoint} * 60 * 24 * 7;
            }
            elsif ( $GetParam{TicketChangeTimePointFormat} eq 'month' ) {
                $Time = $GetParam{TicketChangeTimePoint} * 60 * 24 * 30;
            }
            elsif ( $GetParam{TicketChangeTimePointFormat} eq 'year' ) {
                $Time = $GetParam{TicketChangeTimePoint} * 60 * 24 * 365;
            }
            if ( $GetParam{TicketChangeTimePointStart} eq 'Before' ) {
                $GetParam{TicketChangeTimeOlderMinutes} = $Time;
            }
            else {
                $GetParam{TicketChangeTimeNewerMinutes} = $Time;
            }
        }
    }

    # get close time settings
    if ( !$GetParam{CloseTimeSearchType} ) {

        # do nothing on time stuff
    }
    elsif ( $GetParam{CloseTimeSearchType} eq 'TimeSlot' ) {
        for (qw(Month Day)) {
            $GetParam{"TicketCloseTimeStart$_"}
                = sprintf( "%02d", $GetParam{"TicketCloseTimeStart$_"} );
        }
        for (qw(Month Day)) {
            $GetParam{"TicketCloseTimeStop$_"}
                = sprintf( "%02d", $GetParam{"TicketCloseTimeStop$_"} );
        }
        if (
            $GetParam{TicketCloseTimeStartDay}
            && $GetParam{TicketCloseTimeStartMonth}
            && $GetParam{TicketCloseTimeStartYear}
            )
        {
            $GetParam{TicketCloseTimeNewerDate}
                = $GetParam{TicketCloseTimeStartYear} . '-'
                . $GetParam{TicketCloseTimeStartMonth} . '-'
                . $GetParam{TicketCloseTimeStartDay}
                . ' 00:00:00';
        }
        if (
            $GetParam{TicketCloseTimeStopDay}
            && $GetParam{TicketCloseTimeStopMonth}
            && $GetParam{TicketCloseTimeStopYear}
            )
        {
            $GetParam{TicketCloseTimeOlderDate}
                = $GetParam{TicketCloseTimeStopYear} . '-'
                . $GetParam{TicketCloseTimeStopMonth} . '-'
                . $GetParam{TicketCloseTimeStopDay}
                . ' 23:59:59';
        }
    }
    elsif ( $GetParam{CloseTimeSearchType} eq 'TimePoint' ) {
        if (
            $GetParam{TicketCloseTimePoint}
            && $GetParam{TicketCloseTimePointStart}
            && $GetParam{TicketCloseTimePointFormat}
            )
        {
            my $Time = 0;
            if ( $GetParam{TicketCloseTimePointFormat} eq 'minute' ) {
                $Time = $GetParam{TicketCloseTimePoint};
            }
            elsif ( $GetParam{TicketCloseTimePointFormat} eq 'hour' ) {
                $Time = $GetParam{TicketCloseTimePoint} * 60;
            }
            elsif ( $GetParam{TicketCloseTimePointFormat} eq 'day' ) {
                $Time = $GetParam{TicketCloseTimePoint} * 60 * 24;
            }
            elsif ( $GetParam{TicketCloseTimePointFormat} eq 'week' ) {
                $Time = $GetParam{TicketCloseTimePoint} * 60 * 24 * 7;
            }
            elsif ( $GetParam{TicketCloseTimePointFormat} eq 'month' ) {
                $Time = $GetParam{TicketCloseTimePoint} * 60 * 24 * 30;
            }
            elsif ( $GetParam{TicketCloseTimePointFormat} eq 'year' ) {
                $Time = $GetParam{TicketCloseTimePoint} * 60 * 24 * 365;
            }
            if ( $GetParam{TicketCloseTimePointStart} eq 'Before' ) {
                $GetParam{TicketCloseTimeOlderMinutes} = $Time;
            }
            else {
                $GetParam{TicketCloseTimeNewerMinutes} = $Time;
            }
        }
    }

    # prepare full text search
    if ( $GetParam{Fulltext} ) {
        $GetParam{ContentSearch} = 'OR';
        for (qw(From To Cc Subject Body)) {
            $GetParam{$_} = $GetParam{Fulltext};
        }
    }

    # prepare archive flag
    if ( $Self->{ConfigObject}->Get('Ticket::ArchiveSystem') ) {

        $GetParam{SearchInArchive} ||= '';
        if ( $GetParam{SearchInArchive} eq 'AllTickets' ) {
            $GetParam{ArchiveFlags} = [ 'y', 'n' ];
        }
        elsif ( $GetParam{SearchInArchive} eq 'ArchivedTickets' ) {
            $GetParam{ArchiveFlags} = ['y'];
        }
        else {
            $GetParam{ArchiveFlags} = ['n'];
        }
    }

    return %GetParam;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=cut
