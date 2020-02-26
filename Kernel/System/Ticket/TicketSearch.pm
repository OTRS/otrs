# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Ticket::TicketSearch;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsArrayRefWithData IsStringWithData);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::System::Ticket::TicketSearch - ticket search lib

=head1 DESCRIPTION

All ticket search functions.


=head2 TicketSearch()

To find tickets in your system.

    my @TicketIDs = $TicketObject->TicketSearch(
        # result (required)
        Result => 'ARRAY' || 'HASH' || 'COUNT',

        # result limit
        Limit => 100,

        # Use TicketSearch as a ticket filter on a single ticket,
        # or a predefined ticket list
        TicketID     => 1234,
        TicketID     => [1234, 1235],

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

        # CustomerIDRaw (optional) as STRING or as ARRAYREF
        # CustomerID without QueryCondition checking
        #The raw value will be used if is set this parameter
        CustomerIDRaw => '123 + 345',
        CustomerIDRaw => ['123', 'ABC','123 && 456','ABC % efg'],

        # CustomerUserLogin (optional) as STRING as ARRAYREF
        CustomerUserLogin => 'uid123',
        CustomerUserLogin => ['uid123', 'uid777'],

        # CustomerUserLoginRaw (optional) as STRING as ARRAYREF
        #The raw value will be used if is set this parameter
        CustomerUserLoginRaw => 'uid',
        CustomerUserLoginRaw => 'uid + 123',
        CustomerUserLoginRaw => ['uid  -  123', 'uid # 777 + 321'],

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
            Empty             => 1,                       # will return dynamic fields without a value
                                                          # set to 0 to search fields with a value present
            Equals            => 123,
            Like              => 'value*',                # "equals" operator with wildcard support
            GreaterThan       => '2001-01-01 01:01:01',
            GreaterThanEquals => '2001-01-01 01:01:01',
            SmallerThan       => '2002-02-02 02:02:02',
            SmallerThanEquals => '2002-02-02 02:02:02',
        }

        # User ID for searching tickets by ticket flags (defaults to UserID)
        TicketFlagUserID => 1,

        # search for ticket flags
        TicketFlag => {
            Seen => 1,
        }

        # search for ticket flag that is absent, or a different value than the
        # one given:
        NotTicketFlag => {
            Seen => 1,
        },

        # User ID for searching tickets by article flags (defaults to UserID)
        ArticleFlagUserID => 1,


        # search for tickets by the presence of flags on articles
        ArticleFlag => {
            Important => 1,
        },

        # article stuff (optional)
        MIMEBase_From    => '%spam@example.com%',
        MIMEBase_To      => '%service@example.com%',
        MIMEBase_Cc      => '%client@example.com%',
        MIMEBase_Subject => '%VIRUS 32%',
        MIMEBase_Body    => '%VIRUS 32%',

        # attachment stuff (optional, applies only for ArticleStorageDB)
        AttachmentName => '%anyfile.txt%',

        # use full article text index if configured (optional, default off)
        FullTextIndex => 1,

        # article content search (AND or OR for From, To, Cc, Subject and Body) (optional)
        ContentSearch => 'AND',

        # article content search prefix (for From, To, Cc, Subject and Body) (optional)
        ContentSearchPrefix => '*',

        # article content search suffix (for From, To, Cc, Subject and Body) (optional)
        ContentSearchSuffix => '*',

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

        # ticket history entries that created more than 60 minutes ago (optional)
        TicketChangeTimeOlderMinutes => 60,
        # ticket history entries that created less than 120 minutes ago (optional)
        TicketChangeTimeNewerMinutes => 120,

        # ticket history entry create time after ... (ticket history entries newer than this date) (optional)
        TicketChangeTimeNewerDate => '2006-01-09 00:00:01',
        # ticket history entry create time before ... (ticket history entries older than this date) (optional)
        TicketChangeTimeOlderDate => '2006-01-19 23:59:59',

        # tickets changed more than 60 minutes ago (optional)
        TicketLastChangeTimeOlderMinutes => 60,
        # tickets changed less than 120 minutes ago (optional)
        TicketLastChangeTimeNewerMinutes => 120,

        # tickets with changed time after ... (ticket changed newer than this date) (optional)
        TicketLastChangeTimeNewerDate => '2006-01-09 00:00:01',
        # tickets with changed time before ... (ticket changed older than this date) (optional)
        TicketLastChangeTimeOlderDate => '2006-01-19 23:59:59',

        # tickets closed more than 60 minutes ago (optional)
        TicketCloseTimeOlderMinutes => 60,
        # tickets closed less than 120 minutes ago (optional)
        TicketCloseTimeNewerMinutes => 120,

        # tickets with closed time after ... (ticket closed newer than this date) (optional)
        TicketCloseTimeNewerDate => '2006-01-09 00:00:01',
        # tickets with closed time before ... (ticket closed older than this date) (optional)
        TicketCloseTimeOlderDate => '2006-01-19 23:59:59',

        # tickets with last close time more than 60 minutes ago (optional)
        TicketLastCloseTimeOlderMinutes => 60,
        # tickets with last close time less than 120 minutes ago (optional)
        TicketLastCloseTimeNewerMinutes => 120,

        # tickets with last close time after ... (ticket last close newer than this date) (optional)
        TicketLastCloseTimeNewerDate => '2006-01-09 00:00:01',
        # tickets with last close time before ... (ticket last close older than this date) (optional)
        TicketLastCloseTimeOlderDate => '2006-01-19 23:59:59',

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
        # if archiving is on, if not specified the search processes unarchived only
        # 'y' searches archived tickets, 'n' searches unarchived tickets
        # if specified together all tickets are searched
        ArchiveFlags => ['y', 'n'],

        # OrderBy and SortBy (optional)
        OrderBy => 'Down',  # Down|Up
        SortBy  => 'Age',   # Created|Owner|Responsible|CustomerID|State|TicketNumber|Queue|Priority|Age|Type|Lock
                            # Changed|Title|Service|SLA|PendingTime|EscalationTime
                            # EscalationUpdateTime|EscalationResponseTime|EscalationSolutionTime
                            # DynamicField_FieldNameX

        # OrderBy and SortBy as ARRAY for sub sorting (optional)
        OrderBy => ['Down', 'Up'],
        SortBy  => ['Priority', 'Age'],

        # user search (UserID is required)
        UserID     => 123,
        Permission => 'ro' || 'rw',

        # customer search (CustomerUserID is required)
        CustomerUserID => 123,
        Permission     => 'ro' || 'rw',

        # CacheTTL, cache search result in seconds (optional)
        CacheTTL => 60 * 15,
    );

Returns:

Result: 'ARRAY'

    @TicketIDs = ( 1, 2, 3 );

Result: 'HASH'

    %TicketIDs = (
        1 => '2010102700001',
        2 => '2010102700002',
        3 => '2010102700003',
    );

Result: 'COUNT'

    $TicketIDs = 123;

=cut

sub TicketSearch {
    my ( $Self, %Param ) = @_;

    my $Result  = $Param{Result}  || 'HASH';
    my $OrderBy = $Param{OrderBy} || 'Down';
    my $SortBy  = $Param{SortBy}  || 'Age';
    my $Limit   = $Param{Limit}   || 10000;

    if ( !$Param{ContentSearch} ) {
        $Param{ContentSearch} = 'AND';
    }

    my %SortOptions = (
        Owner                  => 'st.user_id',
        Responsible            => 'st.responsible_user_id',
        CustomerID             => 'st.customer_id',
        State                  => 'st.ticket_state_id',
        Lock                   => 'st.ticket_lock_id',
        Ticket                 => 'st.tn',
        TicketNumber           => 'st.tn',
        Title                  => 'st.title',
        Queue                  => 'sq.name',
        Type                   => 'st.type_id',
        Priority               => 'st.ticket_priority_id',
        Age                    => 'st.create_time',
        Created                => 'st.create_time',
        Changed                => 'st.change_time',
        Service                => 'st.service_id',
        SLA                    => 'st.sla_id',
        PendingTime            => 'st.until_time',
        TicketEscalation       => 'st.escalation_time',
        EscalationTime         => 'st.escalation_time',
        EscalationUpdateTime   => 'st.escalation_update_time',
        EscalationResponseTime => 'st.escalation_response_time',
        EscalationSolutionTime => 'st.escalation_solution_time',
    );

    # check required params
    if ( !$Param{UserID} && !$Param{CustomerUserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID or CustomerUserID params for permission check!',
        );
        return;
    }

    # check types of given arguments
    ARGUMENT:
    for my $Key (
        qw(
        Types TypeIDs CreatedTypes CreatedTypeIDs States StateIDs CreatedStates CreatedStateIDs StateTypeIDs
        Locks LockIDs OwnerIDs ResponsibleIDs CreatedUserIDs Queues QueueIDs CreatedQueues CreatedQueueIDs
        Priorities PriorityIDs CreatedPriorities CreatedPriorityIDs Services ServiceIDs SLAs SLAIDs WatchUserIDs
        )
        )
    {
        next ARGUMENT if !$Param{$Key};
        next ARGUMENT if ref $Param{$Key} eq 'ARRAY' && @{ $Param{$Key} };

        # log error
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "The given param '$Key' is invalid or an empty array reference!",
        );
        return;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # quote id array elements
    ARGUMENT:
    for my $Key (
        qw(
        TypeIDs CreatedTypeIDs StateIDs CreatedStateIDs StateTypeIDs LockIDs OwnerIDs ResponsibleIDs CreatedUserIDs
        QueueIDs CreatedQueueIDs PriorityIDs CreatedPriorityIDs ServiceIDs SLAIDs WatchUserIDs
        )
        )
    {
        next ARGUMENT if !$Param{$Key};

        # quote elements
        for my $Element ( @{ $Param{$Key} } ) {
            if ( !defined $DBObject->Quote( $Element, 'Integer' ) ) {

                # log error
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "The given param '$Element' in '$Key' is invalid!",
                );
                return;
            }
        }
    }

    my $TicketDynamicFields  = [];
    my $ArticleDynamicFields = [];
    my %ValidDynamicFieldParams;
    my %TicketDynamicFieldName2Config;
    my %ArticleDynamicFieldName2Config;

    # Only fetch DynamicField data if a field was requested for searching or sorting
    my $ParamCheckString = ( join '', keys %Param ) || '';

    if ( ref $Param{SortBy} eq 'ARRAY' ) {
        $ParamCheckString .= ( join '', @{ $Param{SortBy} } );
    }
    elsif ( ref $Param{SortBy} ne 'HASH' ) {
        $ParamCheckString .= $Param{SortBy} || '';
    }

    if ( $ParamCheckString =~ m/DynamicField_/smx ) {

        # get dynamic field object
        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

        # Check all configured ticket dynamic fields
        $TicketDynamicFields = $DynamicFieldObject->DynamicFieldListGet(
            ObjectType => 'Ticket',
        );

        for my $DynamicField ( @{$TicketDynamicFields} ) {
            $ValidDynamicFieldParams{ "DynamicField_" . $DynamicField->{Name} } = 1;
            $TicketDynamicFieldName2Config{ $DynamicField->{Name} } = $DynamicField;
        }

        # Check all configured article dynamic fields
        $ArticleDynamicFields = $DynamicFieldObject->DynamicFieldListGet(
            ObjectType => 'Article',
        );

        for my $DynamicField ( @{$ArticleDynamicFields} ) {
            $ValidDynamicFieldParams{ "DynamicField_" . $DynamicField->{Name} } = 1;
            $ArticleDynamicFieldName2Config{ $DynamicField->{Name} } = $DynamicField;
        }
    }

    # check sort/order by options
    my @SortByArray       = ( ref $SortBy eq 'ARRAY' ? @{$SortBy} : ($SortBy) );
    my %LookupSortByArray = map { $_ => 1 } @SortByArray;
    my @OrderByArray      = ( ref $OrderBy eq 'ARRAY' ? @{$OrderBy} : ($OrderBy) );

    for my $Count ( 0 .. $#SortByArray ) {
        if (
            !$SortOptions{ $SortByArray[$Count] }
            && !$ValidDynamicFieldParams{ $SortByArray[$Count] }
            )
        {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Need valid SortBy (' . $SortByArray[$Count] . ')!',
            );
            return;
        }
        if ( $OrderByArray[$Count] ne 'Down' && $OrderByArray[$Count] ne 'Up' ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Need valid OrderBy (' . $OrderByArray[$Count] . ')!',
            );
            return;
        }
    }

    # create sql
    my $SQLSelect;
    if ( $Result eq 'COUNT' ) {
        $SQLSelect = 'SELECT COUNT(DISTINCT(st.id))';
    }
    else {
        $SQLSelect = 'SELECT DISTINCT st.id, st.tn';
    }

    my $SQLFrom = ' FROM ticket st ';

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    # check for needed article table join
    my $ArticleTableJoined = 0;

    # check for needed article search index table join
    if ( $ArticleObject->ArticleSearchIndexSQLJoinNeeded( SearchParams => \%Param ) ) {
        $SQLFrom .= ' INNER JOIN article art ON st.id = art.ticket_id ';
        $SQLFrom .= $ArticleObject->ArticleSearchIndexSQLJoin( SearchParams => \%Param );
        $ArticleTableJoined = 1;
    }

    # Use also history table if required
    # Create a inner join for each param and register it.
    my %TicketHistoryJoins = ();
    ARGUMENT:
    for my $Key ( sort keys %Param ) {
        if (
            $Param{$Key}
            && $Key =~ /^(Ticket(Last)?(Close|Change)Time(Newer|Older)(Date|Minutes)|Created.+?)/
            )
        {
            my $THRef = $Self->_TicketHistoryReferenceForSearchArgument(
                Argument => $Key,
            );
            return if !$THRef;

            next ARGUMENT if $TicketHistoryJoins{$THRef};

            $TicketHistoryJoins{$THRef} = 1;
            $SQLFrom .= sprintf
                'INNER JOIN ticket_history %s ON st.id = %s.ticket_id ',
                $THRef, $THRef;
        }
    }

    # add ticket watcher table
    if ( $Param{WatchUserIDs} ) {
        $SQLFrom .= 'INNER JOIN ticket_watcher tw ON st.id = tw.ticket_id ';
    }

    my $SQLExt = ' WHERE 1=1';

    # Limit the search to just one (or a list) TicketID (used by the GenericAgent
    #   to filter for events on single tickets with the job's ticket filter).
    if ( IsStringWithData( $Param{TicketID} ) || IsArrayRefWithData( $Param{TicketID} ) ) {

        my $SQLQueryInCondition = $Kernel::OM->Get('Kernel::System::DB')->QueryInCondition(
            Key       => 'st.id',
            Values    => ref $Param{TicketID} eq 'ARRAY' ? $Param{TicketID} : [ $Param{TicketID} ],
            QuoteType => 'Integer',
            BindMode  => 0,
        );
        $SQLExt .= ' AND ( ' . $SQLQueryInCondition . ' ) ';
    }

    # add ticket flag table
    if ( $Param{TicketFlag} ) {
        my $Index = 1;
        for my $Key ( sort keys %{ $Param{TicketFlag} } ) {
            $SQLFrom .= "INNER JOIN ticket_flag tf$Index ON st.id = tf$Index.ticket_id ";
            $Index++;
        }
    }

    # add article and article_flag tables
    if ( $Param{ArticleFlag} ) {
        my $Index = 1;
        for my $Key ( sort keys %{ $Param{ArticleFlag} } ) {
            $SQLFrom .= "INNER JOIN article ataf$Index ON st.id = ataf$Index.ticket_id ";
            $SQLFrom .=
                "INNER JOIN article_flag taf$Index ON ataf$Index.id = taf$Index.article_id ";
            $Index++;
        }
    }

    if ( $Param{NotTicketFlag} ) {
        my $TicketFlagUserID = $Param{TicketFlagUserID} || $Param{UserID};
        return if !defined $TicketFlagUserID;

        my $Index = 1;
        for my $Key ( sort keys %{ $Param{NotTicketFlag} } ) {
            $SQLFrom .= "LEFT JOIN ticket_flag ntf$Index ON st.id = ntf$Index.ticket_id  "
                . " AND ntf$Index.ticket_key = '" . $DBObject->Quote($Key) . "'"
                . " AND ntf$Index.create_by = "
                . $DBObject->Quote( $TicketFlagUserID, 'Integer' )
                . ' ';
            $Index++;
        }
    }

    # current type lookup
    if ( $Param{Types} ) {

        # get type object
        my $TypeObject = $Kernel::OM->Get('Kernel::System::Type');

        for my $Type ( @{ $Param{Types} } ) {

            # lookup type id
            my $TypeID = $TypeObject->TypeLookup(
                Type => $Type,
            );
            return if !$TypeID;
            push @{ $Param{TypeIDs} }, $TypeID;
        }
    }

    # type ids
    if ( $Param{TypeIDs} ) {
        my $SQLQueryInCondition = $Kernel::OM->Get('Kernel::System::DB')->QueryInCondition(
            Key       => 'st.type_id',
            Values    => $Param{TypeIDs},
            QuoteType => 'Integer',
            BindMode  => 0,
        );
        $SQLExt .= ' AND ( ' . $SQLQueryInCondition . ' ) ';
    }

    # created types lookup
    if ( $Param{CreatedTypes} ) {

        # get type object
        my $TypeObject = $Kernel::OM->Get('Kernel::System::Type');

        for my $Type ( @{ $Param{CreatedTypes} } ) {

            # lookup type id
            my $TypeID = $TypeObject->TypeLookup(
                Type => $Type,
            );

            return if !$TypeID;

            push @{ $Param{CreatedTypeIDs} }, $TypeID;
        }
    }

    # created type ids
    if ( $Param{CreatedTypeIDs} ) {

        # lookup history type id
        my $HistoryTypeID = $Self->HistoryTypeLookup(
            Type => 'NewTicket',
        );

        if ($HistoryTypeID) {
            my $THRef = $Self->_TicketHistoryReferenceForSearchArgument(
                Argument => 'CreatedTypeIDs',
            );
            return if !$THRef;

            my $SQLQueryInCondition = $Kernel::OM->Get('Kernel::System::DB')->QueryInCondition(
                Key       => "${ THRef }.type_id",
                Values    => $Param{CreatedTypeIDs},
                QuoteType => 'Integer',
                BindMode  => 0,
            );
            $SQLExt .= ' AND ( ' . $SQLQueryInCondition . ' ) ';
            $SQLExt .= " AND ${ THRef }.history_type_id = $HistoryTypeID ";
        }
    }

    # current state lookup
    if ( $Param{States} ) {

        # get state object
        my $StateObject = $Kernel::OM->Get('Kernel::System::State');

        for my $State ( @{ $Param{States} } ) {

            # get state data
            my %StateData = $StateObject->StateGet(
                Name => $State,
            );

            return if !%StateData;

            push @{ $Param{StateIDs} }, $StateData{ID};
        }
    }

    # state ids
    if ( $Param{StateIDs} ) {
        my $SQLQueryInCondition = $Kernel::OM->Get('Kernel::System::DB')->QueryInCondition(
            Key       => 'st.ticket_state_id',
            Values    => $Param{StateIDs},
            QuoteType => 'Integer',
            BindMode  => 0,
        );
        $SQLExt .= ' AND ( ' . $SQLQueryInCondition . ' ) ';
    }

    # created states lookup
    if ( $Param{CreatedStates} ) {

        # get state object
        my $StateObject = $Kernel::OM->Get('Kernel::System::State');

        for my $State ( @{ $Param{CreatedStates} } ) {

            # get state data
            my %StateData = $StateObject->StateGet(
                Name => $State,
            );

            return if !%StateData;

            push @{ $Param{CreatedStateIDs} }, $StateData{ID};
        }
    }

    # created state ids
    if ( $Param{CreatedStateIDs} ) {

        # lookup history type id
        my $HistoryTypeID = $Self->HistoryTypeLookup(
            Type => 'NewTicket',
        );

        if ($HistoryTypeID) {
            my $THRef = $Self->_TicketHistoryReferenceForSearchArgument(
                Argument => 'CreatedStateIDs',
            );
            return if !$THRef;

            my $SQLQueryInCondition = $Kernel::OM->Get('Kernel::System::DB')->QueryInCondition(
                Key       => "${ THRef }.state_id",
                Values    => $Param{CreatedStateIDs},
                QuoteType => 'Integer',
                BindMode  => 0,
            );
            $SQLExt .= ' AND ( ' . $SQLQueryInCondition . ' ) ';

            $SQLExt .= " AND ${ THRef }.history_type_id = $HistoryTypeID ";
        }
    }

    # current ticket state type
    # NOTE: Open and Closed are not valid state types. It's for compat.
    # Open   -> All states which are grouped as open (new, open, pending, ...)
    # Closed -> All states which are grouped as closed (closed successful, closed unsuccessful)
    if ( $Param{StateType} && $Param{StateType} eq 'Open' ) {
        my @ViewableStateIDs = $Kernel::OM->Get('Kernel::System::State')->StateGetStatesByType(
            Type   => 'Viewable',
            Result => 'ID',
        );
        $SQLExt .= " AND st.ticket_state_id IN ( ${\(join ', ', sort @ViewableStateIDs)} ) ";
    }
    elsif ( $Param{StateType} && $Param{StateType} eq 'Closed' ) {
        my @ViewableStateIDs = $Kernel::OM->Get('Kernel::System::State')->StateGetStatesByType(
            Type   => 'Viewable',
            Result => 'ID',
        );
        $SQLExt .= " AND st.ticket_state_id NOT IN ( ${\(join ', ', sort @ViewableStateIDs)} ) ";
    }

    # current ticket state type
    elsif ( $Param{StateType} ) {
        my @StateIDs = $Kernel::OM->Get('Kernel::System::State')->StateGetStatesByType(
            StateType => $Param{StateType},
            Result    => 'ID',
        );
        return if !$StateIDs[0];
        $SQLExt .= " AND st.ticket_state_id IN ( ${\(join ', ', sort {$a <=> $b} @StateIDs)} ) ";
    }

    if ( $Param{StateTypeIDs} ) {

        # get state object
        my $StateObject = $Kernel::OM->Get('Kernel::System::State');

        my %StateTypeList = $StateObject->StateTypeList(
            UserID => $Param{UserID} || 1,
        );
        my @StateTypes = map { $StateTypeList{$_} } @{ $Param{StateTypeIDs} };
        my @StateIDs   = $StateObject->StateGetStatesByType(
            StateType => \@StateTypes,
            Result    => 'ID',
        );

        return if !$StateIDs[0];

        $SQLExt .= " AND st.ticket_state_id IN ( ${\(join ', ', sort {$a <=> $b} @StateIDs)} ) ";
    }

    # current lock lookup
    if ( $Param{Locks} ) {

        for my $Lock ( @{ $Param{Locks} } ) {

            # lookup lock id
            my $LockID = $Kernel::OM->Get('Kernel::System::Lock')->LockLookup(
                Lock => $Lock,
            );

            return if !$LockID;

            push @{ $Param{LockIDs} }, $LockID;
        }
    }

    # lock ids
    if ( $Param{LockIDs} ) {
        my $SQLQueryInCondition = $Kernel::OM->Get('Kernel::System::DB')->QueryInCondition(
            Key       => 'st.ticket_lock_id',
            Values    => $Param{LockIDs},
            QuoteType => 'Integer',
            BindMode  => 0,
        );
        $SQLExt .= ' AND ( ' . $SQLQueryInCondition . ' ) ';
    }

    # current owner user ids
    if ( $Param{OwnerIDs} ) {
        my $SQLQueryInCondition = $Kernel::OM->Get('Kernel::System::DB')->QueryInCondition(
            Key       => 'st.user_id',
            Values    => $Param{OwnerIDs},
            QuoteType => 'Integer',
            BindMode  => 0,
        );
        $SQLExt .= ' AND ( ' . $SQLQueryInCondition . ' ) ';
    }

    # current responsible user ids
    if ( $Param{ResponsibleIDs} ) {
        my $SQLQueryInCondition = $Kernel::OM->Get('Kernel::System::DB')->QueryInCondition(
            Key       => 'st.responsible_user_id',
            Values    => $Param{ResponsibleIDs},
            QuoteType => 'Integer',
            BindMode  => 0,
        );
        $SQLExt .= ' AND ( ' . $SQLQueryInCondition . ' ) ';
    }

    # created user ids
    if ( $Param{CreatedUserIDs} ) {

        # lookup history type id
        my $HistoryTypeID = $Self->HistoryTypeLookup(
            Type => 'NewTicket',
        );

        if ($HistoryTypeID) {
            my $THRef = $Self->_TicketHistoryReferenceForSearchArgument(
                Argument => 'CreatedUserIDs',
            );
            return if !$THRef;

            my $SQLQueryInCondition = $Kernel::OM->Get('Kernel::System::DB')->QueryInCondition(
                Key       => "${ THRef }.create_by",
                Values    => $Param{CreatedUserIDs},
                QuoteType => 'Integer',
                BindMode  => 0,
            );
            $SQLExt .= ' AND ( ' . $SQLQueryInCondition . ' ) ';

            $SQLExt .= " AND ${ THRef }.history_type_id = $HistoryTypeID ";
        }
    }

    # current queue lookup
    if ( $Param{Queues} ) {

        # get queue object
        my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

        for my $Queue ( @{ $Param{Queues} } ) {

            # lookup queue id
            my $QueueID = $QueueObject->QueueLookup(
                Queue => $Queue,
            );

            return if !$QueueID;

            push @{ $Param{QueueIDs} }, $QueueID;
        }
    }

    # current sub queue ids
    if ( $Param{UseSubQueues} && $Param{QueueIDs} ) {

        # get queue object
        my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

        my @SubQueueIDs;
        my %Queues = $QueueObject->GetAllQueues();

        for my $QueueID ( @{ $Param{QueueIDs} } ) {

            my $Queue = $QueueObject->QueueLookup( QueueID => $QueueID );

            for my $QueuesID ( sort keys %Queues ) {
                if ( $Queues{$QueuesID} =~ /^\Q$Queue\E::/i ) {
                    push @SubQueueIDs, $QueuesID;
                }
            }
        }

        push @{ $Param{QueueIDs} }, @SubQueueIDs;
    }

    # current queue ids
    if ( $Param{QueueIDs} ) {

        my $SQLQueryInCondition = $Kernel::OM->Get('Kernel::System::DB')->QueryInCondition(
            Key       => 'st.queue_id',
            Values    => $Param{QueueIDs},
            QuoteType => 'Integer',
            BindMode  => 0,
        );
        $SQLExt .= ' AND ( ' . $SQLQueryInCondition . ' ) ';
    }

    # created queue lookup
    if ( $Param{CreatedQueues} ) {

        # get queue object
        my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

        for my $Queue ( @{ $Param{CreatedQueues} } ) {

            # lookup queue id
            my $QueueID = $QueueObject->QueueLookup(
                Queue => $Queue,
            );

            return if !$QueueID;

            push @{ $Param{CreatedQueueIDs} }, $QueueID;
        }
    }

    # created queue ids
    if ( $Param{CreatedQueueIDs} ) {

        # lookup history type id
        my $HistoryTypeID = $Self->HistoryTypeLookup(
            Type => 'NewTicket',
        );

        if ($HistoryTypeID) {
            my $THRef = $Self->_TicketHistoryReferenceForSearchArgument(
                Argument => 'CreatedQueueIDs',
            );
            return if !$THRef;

            my $SQLQueryInCondition = $Kernel::OM->Get('Kernel::System::DB')->QueryInCondition(
                Key       => "${ THRef }.queue_id",
                Values    => $Param{CreatedQueueIDs},
                QuoteType => 'Integer',
                BindMode  => 0,
            );
            $SQLExt .= ' AND ( ' . $SQLQueryInCondition . ' ) ';

            $SQLExt .= " AND ${ THRef }.history_type_id = $HistoryTypeID ";
        }
    }

    my %GroupList;

    # user groups
    if ( $Param{UserID} && $Param{UserID} != 1 ) {

        # get users groups
        %GroupList = $Kernel::OM->Get('Kernel::System::Group')->PermissionUserGet(
            UserID => $Param{UserID},
            Type   => $Param{Permission} || 'ro',
        );

        # return if we have no permissions
        return if !%GroupList;

        # add groups to query
        $SQLExt .= ' AND sq.group_id IN (' . join( ',', sort keys %GroupList ) . ') ';
    }

    # customer groups
    if ( $Param{CustomerUserID} ) {

        %GroupList = $Kernel::OM->Get('Kernel::System::CustomerGroup')->GroupMemberList(
            UserID => $Param{CustomerUserID},
            Type   => $Param{Permission} || 'ro',
            Result => 'HASH',
        );

        # return if we have no permissions
        return if !%GroupList;

        # get all customer ids
        my @CustomerIDs = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerIDs(
            User => $Param{CustomerUserID},
        );

        # prepare combination of customer<->group access

        # add default combination first ( CustomerIDs + CustomerUserID <-> rw access groups )
        # this group will always be added (ensures previous behavior)
        my @CustomerGroupPermission;
        push @CustomerGroupPermission, {
            CustomerIDs    => \@CustomerIDs,
            CustomerUserID => $Param{CustomerUserID},
            GroupIDs       => [ sort keys %GroupList ],
        };

        # add all combinations based on group access for other CustomerIDs (if available)
        # only active if customer group support and extra permission context are enabled
        my $CustomerGroupObject    = $Kernel::OM->Get('Kernel::System::CustomerGroup');
        my $ExtraPermissionContext = $CustomerGroupObject->GroupContextNameGet(
            SysConfigName => '100-CustomerID-other',
        );
        if ( $Kernel::OM->Get('Kernel::Config')->Get('CustomerGroupSupport') && $ExtraPermissionContext ) {

            # add lookup for CustomerID
            my %CustomerIDsLookup = map { $_ => $_ } @CustomerIDs;

            # for all CustomerIDs get groups with access to other CustomerIDs
            my %ExtraPermissionGroups;
            CUSTOMERID:
            for my $CustomerID (@CustomerIDs) {
                my %CustomerIDExtraPermissionGroups = $CustomerGroupObject->GroupCustomerList(
                    CustomerID => $CustomerID,
                    Type       => $Param{Permission} || 'ro',
                    Context    => $ExtraPermissionContext,
                    Result     => 'HASH',
                );
                next CUSTOMERID if !%CustomerIDExtraPermissionGroups;

                # add to groups
                %ExtraPermissionGroups = (
                    %ExtraPermissionGroups,
                    %CustomerIDExtraPermissionGroups,
                );
            }

            # add all unique accessible Group<->Customer combinations to query
            # for performance reasons all groups corresponsing with a unique customer id combination
            #   will be combined into one part
            my %CustomerIDCombinations;
            GROUPID:
            for my $GroupID ( sort keys %ExtraPermissionGroups ) {
                my @ExtraCustomerIDs = $CustomerGroupObject->GroupCustomerList(
                    GroupID => $GroupID,
                    Type    => $Param{Permission} || 'ro',
                    Result  => 'ID',
                );
                next GROUPID if !@ExtraCustomerIDs;

                # exclude own CustomerIDs for performance reasons
                my @MergedCustomerIDs = grep { !$CustomerIDsLookup{$_} } @ExtraCustomerIDs;
                next GROUPID if !@MergedCustomerIDs;

                # remember combination
                my $CustomerIDString = join ',', sort @MergedCustomerIDs;
                if ( !$CustomerIDCombinations{$CustomerIDString} ) {
                    $CustomerIDCombinations{$CustomerIDString} = {
                        CustomerIDs => \@MergedCustomerIDs,
                    };
                }
                push @{ $CustomerIDCombinations{$CustomerIDString}->{GroupIDs} }, $GroupID;
            }

            # add to query combinations
            push @CustomerGroupPermission, sort values %CustomerIDCombinations;
        }

        # prepare LOWER call depending on database
        my $Lower = '';
        if ( $DBObject->GetDatabaseFunction('CaseSensitive') ) {
            $Lower = 'LOWER';
        }

        # now add all combinations to query:
        # this will compile a search restriction based on customer_id/customer_user_id and group
        #   and will match if any of the permission combination is met
        # a permission combination could be:
        #     ( <CustomerUserID> OR <CUSTOMERID1> ) AND ( <GROUPID1> )
        # or
        #     ( <CustomerID1> OR <CUSTOMERID2> OR <CUSTOMERID3> ) AND ( <GROUPID1> OR <GROUPID2> )
        $SQLExt .= ' AND (';
        my $CustomerGroupSQL = '';
        ENTRY:
        for my $Entry (@CustomerGroupPermission) {
            $CustomerGroupSQL .= $CustomerGroupSQL ? ' OR (' : '(';

            my $CustomerIDsSQL;
            if ( IsArrayRefWithData( $Entry->{CustomerIDs} ) ) {
                $CustomerIDsSQL =
                    $Lower . '(st.customer_id) IN ('
                    . join(
                    ',',
                    map {
                        "$Lower('" . $DBObject->Quote($_) . "')"
                        } @{
                        $Entry->{CustomerIDs}
                        }
                    )
                    . ')';
            }

            my $CustomerUserIDSQL;
            if ( $Entry->{CustomerUserID} ) {
                $CustomerUserIDSQL = 'st.customer_user_id = ' . "'" . $DBObject->Quote( $Param{CustomerUserID} ) . "'";
            }

            if ( $CustomerIDsSQL && $CustomerUserIDSQL ) {
                $CustomerGroupSQL .= '( ' . $CustomerIDsSQL . ' OR ' . $CustomerUserIDSQL . ' )';
            }
            elsif ($CustomerIDsSQL) {
                $CustomerGroupSQL .= $CustomerIDsSQL;
            }
            elsif ($CustomerUserIDSQL) {
                $CustomerGroupSQL .= $CustomerUserIDSQL;
            }
            else {
                next ENTRY;
            }

            $CustomerGroupSQL .= ' AND sq.group_id IN (' . join( ',', @{ $Entry->{GroupIDs} } ) . ') )';
        }
        $SQLExt .= $CustomerGroupSQL . ') ';
    }

    # current priority lookup
    if ( $Param{Priorities} ) {

        # get priority object
        my $PriorityObject = $Kernel::OM->Get('Kernel::System::Priority');

        for my $Priority ( @{ $Param{Priorities} } ) {

            # lookup priority id
            my $PriorityID = $PriorityObject->PriorityLookup(
                Priority => $Priority,
            );

            return if !$PriorityID;

            push @{ $Param{PriorityIDs} }, $PriorityID;
        }
    }

    # priority ids
    if ( $Param{PriorityIDs} ) {

        my $SQLQueryInCondition = $Kernel::OM->Get('Kernel::System::DB')->QueryInCondition(
            Key       => 'st.ticket_priority_id',
            Values    => $Param{PriorityIDs},
            QuoteType => 'Integer',
            BindMode  => 0,
        );
        $SQLExt .= ' AND ( ' . $SQLQueryInCondition . ' ) ';
    }

    # created priority lookup
    if ( $Param{CreatedPriorities} ) {

        # get priority object
        my $PriorityObject = $Kernel::OM->Get('Kernel::System::Priority');

        for my $Priority ( @{ $Param{CreatedPriorities} } ) {

            # lookup priority id
            my $PriorityID = $PriorityObject->PriorityLookup(
                Priority => $Priority,
            );

            return if !$PriorityID;

            push @{ $Param{CreatedPriorityIDs} }, $PriorityID;
        }
    }

    # created priority ids
    if ( $Param{CreatedPriorityIDs} ) {

        # lookup history type id
        my $HistoryTypeID = $Self->HistoryTypeLookup(
            Type => 'NewTicket',
        );

        if ($HistoryTypeID) {
            my $THRef = $Self->_TicketHistoryReferenceForSearchArgument(
                Argument => 'CreatedPriorityIDs',
            );
            return if !$THRef;

            my $SQLQueryInCondition = $Kernel::OM->Get('Kernel::System::DB')->QueryInCondition(
                Key       => "${ THRef }.priority_id",
                Values    => $Param{CreatedPriorityIDs},
                QuoteType => 'Integer',
                BindMode  => 0,
            );
            $SQLExt .= ' AND ( ' . $SQLQueryInCondition . ' ) ';

            $SQLExt .= " AND ${ THRef }.history_type_id = $HistoryTypeID ";
        }
    }

    # current service lookup
    if ( $Param{Services} ) {

        # get service object
        my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');

        for my $Service ( @{ $Param{Services} } ) {

            # lookup service id
            my $ServiceID = $ServiceObject->ServiceLookup(
                Name => $Service,
            );

            return if !$ServiceID;

            push @{ $Param{ServiceIDs} }, $ServiceID;
        }
    }

    # service ids
    if ( $Param{ServiceIDs} ) {
        my $SQLQueryInCondition = $Kernel::OM->Get('Kernel::System::DB')->QueryInCondition(
            Key       => 'st.service_id',
            Values    => $Param{ServiceIDs},
            QuoteType => 'Integer',
            BindMode  => 0,
        );
        $SQLExt .= ' AND ( ' . $SQLQueryInCondition . ' ) ';
    }

    # current sla lookup
    if ( $Param{SLAs} ) {

        # get sla object
        my $SLAObject = $Kernel::OM->Get('Kernel::System::SLA');

        for my $SLA ( @{ $Param{SLAs} } ) {

            # lookup sla id
            my $SLAID = $SLAObject->SLALookup(
                Name => $SLA,
            );

            return if !$SLAID;

            push @{ $Param{SLAIDs} }, $SLAID;
        }
    }

    # sla ids
    if ( $Param{SLAIDs} ) {
        my $SQLQueryInCondition = $Kernel::OM->Get('Kernel::System::DB')->QueryInCondition(
            Key       => 'st.sla_id',
            Values    => $Param{SLAIDs},
            QuoteType => 'Integer',
            BindMode  => 0,
        );
        $SQLExt .= ' AND ( ' . $SQLQueryInCondition . ' ) ';
    }

    # watch user ids
    if ( $Param{WatchUserIDs} ) {
        my $SQLQueryInCondition = $Kernel::OM->Get('Kernel::System::DB')->QueryInCondition(
            Key       => 'tw.user_id',
            Values    => $Param{WatchUserIDs},
            QuoteType => 'Integer',
            BindMode  => 0,
        );
        $SQLExt .= ' AND ( ' . $SQLQueryInCondition . ' ) ';
    }

    # add ticket flag extension
    if ( $Param{TicketFlag} ) {

        my $TicketFlagUserID = $Param{TicketFlagUserID} || $Param{UserID};
        return if !defined $TicketFlagUserID;

        my $Index = 1;
        for my $Key ( sort keys %{ $Param{TicketFlag} } ) {
            my $Value = $Param{TicketFlag}->{$Key};
            return if !defined $Value;

            $SQLExt .= " AND tf$Index.ticket_key = '" . $DBObject->Quote($Key) . "'";
            $SQLExt .= " AND tf$Index.ticket_value = '" . $DBObject->Quote($Value) . "'";
            $SQLExt .= " AND tf$Index.create_by = "
                . $DBObject->Quote( $TicketFlagUserID, 'Integer' );

            $Index++;
        }
    }

    # add article flag extension
    if ( $Param{ArticleFlag} ) {
        my $ArticleFlagUserID = $Param{ArticleFlagUserID} || $Param{UserID};
        return if !defined $ArticleFlagUserID;

        my $Index = 1;
        for my $Key ( sort keys %{ $Param{ArticleFlag} } ) {
            my $Value = $Param{ArticleFlag}->{$Key};
            return if !defined $Value;

            $SQLExt .= " AND taf$Index.article_key = '" . $DBObject->Quote($Key) . "'";
            $SQLExt .= " AND taf$Index.article_value = '" . $DBObject->Quote($Value) . "'";
            $SQLExt .= " AND taf$Index.create_by = "
                . $DBObject->Quote( $ArticleFlagUserID, 'Integer' );

            $Index++;
        }
    }

    if ( $Param{NotTicketFlag} ) {
        my $Index = 1;
        for my $Key ( sort keys %{ $Param{NotTicketFlag} } ) {
            my $Value = $Param{NotTicketFlag}->{$Key};
            return if !defined $Value;

            $SQLExt .= " AND (ntf$Index.ticket_value IS NULL "
                . "OR ntf$Index.ticket_value <> '" . $DBObject->Quote($Value) . "')";

            $Index++;
        }
    }

    # other ticket stuff
    my %FieldSQLMap = (
        TicketNumber         => 'st.tn',
        Title                => 'st.title',
        CustomerID           => 'st.customer_id',
        CustomerIDRaw        => 'st.customer_id',
        CustomerUserLogin    => 'st.customer_user_id',
        CustomerUserLoginRaw => 'st.customer_user_id',
    );

    ATTRIBUTE:
    for my $Key ( sort keys %FieldSQLMap ) {

        next ATTRIBUTE if !defined $Param{$Key};

        next ATTRIBUTE if ( ( $Key eq 'CustomerID' ) && ( defined $Param{CustomerIDRaw} ) );
        next ATTRIBUTE
            if ( ( $Key eq 'CustomerUserLogin' ) && ( defined $Param{CustomerUserLoginRaw} ) );

        # if it's no ref, put it to array ref
        if ( ref $Param{$Key} eq '' ) {
            $Param{$Key} = [ $Param{$Key} ];
        }

        # proccess array ref
        my $Used = 0;

        VALUE:
        for my $Value ( @{ $Param{$Key} } ) {

            next VALUE if !defined $Value || !length $Value;

            # replace wild card search
            if (
                $Key ne 'CustomerIDRaw'
                && $Key ne 'CustomerUserLoginRaw'
                )
            {
                $Value =~ s/\*/%/gi;
            }

            # check search attribute, we do not need to search for *
            next VALUE if $Value =~ /^\%{1,3}$/;

            if ( !$Used ) {
                $SQLExt .= ' AND (';
                $Used = 1;
            }
            else {
                $SQLExt .= ' OR ';
            }

            # add * to prefix/suffix on title search
            my %ConditionFocus;
            if ( $Param{ConditionInline} && $Key eq 'Title' ) {
                $ConditionFocus{Extended} = 1;
                if ( $Param{ContentSearchPrefix} ) {
                    $ConditionFocus{SearchPrefix} = $Param{ContentSearchPrefix};
                }
                if ( $Param{ContentSearchSuffix} ) {
                    $ConditionFocus{SearchSuffix} = $Param{ContentSearchSuffix};
                }
            }

            if ( $Key eq 'CustomerIDRaw' || $Key eq 'CustomerUserLoginRaw' ) {
                $SQLExt .= " $FieldSQLMap{$Key}= '" . $DBObject->Quote($Value) . "'";
            }
            else {

                # use search condition extension
                $SQLExt .= $DBObject->QueryCondition(
                    Key   => $FieldSQLMap{$Key},
                    Value => $Value,
                    %ConditionFocus,
                );
            }
        }
        if ($Used) {
            $SQLExt .= ')';
        }
    }

    # Search article attributes.
    if ($ArticleTableJoined) {

        $SQLExt .= $ArticleObject->ArticleSearchIndexWhereCondition( SearchParams => \%Param );

        # Restrict search from customers to only customer articles.
        if ( $Param{CustomerUserID} ) {
            $SQLExt .= ' AND art.is_visible_for_customer = 1 ';
        }
    }

    # Remember already joined tables for sorting.
    my %DynamicFieldJoinTables;
    my $DynamicFieldJoinCounter = 1;

    # get dynamic field backend object
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    DYNAMIC_FIELD:
    for my $DynamicField ( @{$TicketDynamicFields}, @{$ArticleDynamicFields} ) {
        my $SearchParam = delete $Param{ "DynamicField_" . $DynamicField->{Name} };

        next DYNAMIC_FIELD if ( !$SearchParam );
        next DYNAMIC_FIELD if ( ref $SearchParam ne 'HASH' );

        my $NeedJoin;
        my $QueryForEmptyValues = 0;

        for my $Operator ( sort keys %{$SearchParam} ) {

            my @SearchParams = ( ref $SearchParam->{$Operator} eq 'ARRAY' )
                ? @{ $SearchParam->{$Operator} }
                : ( $SearchParam->{$Operator} );

            my $SQLExtSub = ' AND (';
            my $Counter   = 0;
            TEXT:
            for my $Text (@SearchParams) {
                next TEXT if ( !defined $Text || $Text eq '' );

                $Text =~ s/\*/%/gi;

                # check search attribute, we do not need to search for *
                next TEXT if $Text =~ /^\%{1,3}$/;

                # skip validation for empty values
                if ( $Operator ne 'Empty' ) {

                    # validate data type
                    my $ValidateSuccess = $DynamicFieldBackendObject->ValueValidate(
                        DynamicFieldConfig => $DynamicField,
                        Value              => $Text,
                        NoValidateRegex    => 1,
                        UserID             => $Param{UserID} || 1,
                    );
                    if ( !$ValidateSuccess ) {
                        $Kernel::OM->Get('Kernel::System::Log')->Log(
                            Priority => 'error',
                            Message =>
                                "Search not executed due to invalid value '"
                                . $Text
                                . "' on field '"
                                . $DynamicField->{Name}
                                . "'!",
                        );
                        return;
                    }
                }

                if ($Counter) {
                    $SQLExtSub .= ' OR ';
                }

                # Empty => 1 requires a LEFT JOIN.
                if ( $Operator eq 'Empty' && $Text ) {
                    $SQLExtSub .= $DynamicFieldBackendObject->SearchSQLGet(
                        DynamicFieldConfig => $DynamicField,
                        TableAlias         => "dfvEmpty$DynamicFieldJoinCounter",
                        Operator           => $Operator,
                        SearchTerm         => $Text,
                    );
                    $QueryForEmptyValues = 1;
                }
                else {
                    $SQLExtSub .= $DynamicFieldBackendObject->SearchSQLGet(
                        DynamicFieldConfig => $DynamicField,
                        TableAlias         => "dfv$DynamicFieldJoinCounter",
                        Operator           => $Operator,
                        SearchTerm         => $Text,
                    );
                }

                $Counter++;
            }
            $SQLExtSub .= ')';
            if ($Counter) {
                $SQLExt .= $SQLExtSub;
                $NeedJoin = 1;
            }
        }

        if ($NeedJoin) {

            # Join the table for this dynamic field
            if ( $DynamicField->{ObjectType} eq 'Ticket' ) {

                if ($QueryForEmptyValues) {

                    # Use LEFT JOIN to allow for null values.
                    $SQLFrom .= "LEFT JOIN dynamic_field_value dfvEmpty$DynamicFieldJoinCounter
                        ON (st.id = dfvEmpty$DynamicFieldJoinCounter.object_id
                            AND dfvEmpty$DynamicFieldJoinCounter.field_id = " .
                        $DBObject->Quote( $DynamicField->{ID}, 'Integer' ) . ") ";
                }
                else {
                    $SQLFrom .= "INNER JOIN dynamic_field_value dfv$DynamicFieldJoinCounter
                        ON (st.id = dfv$DynamicFieldJoinCounter.object_id
                            AND dfv$DynamicFieldJoinCounter.field_id = " .
                        $DBObject->Quote( $DynamicField->{ID}, 'Integer' ) . ") ";
                }
            }
            elsif ( $DynamicField->{ObjectType} eq 'Article' ) {

                if ( !$ArticleTableJoined ) {
                    $SQLFrom .= ' INNER JOIN article art ON st.id = art.ticket_id ';
                    $ArticleTableJoined = 1;
                }

                if ($QueryForEmptyValues) {

                    # Use LEFT JOIN to allow for null values.
                    $SQLFrom .= "LEFT JOIN dynamic_field_value dfvEmpty$DynamicFieldJoinCounter
                        ON (art.id = dfvEmpty$DynamicFieldJoinCounter.object_id
                            AND dfvEmpty$DynamicFieldJoinCounter.field_id = " .
                        $DBObject->Quote( $DynamicField->{ID}, 'Integer' ) . ") ";
                }
                else {
                    $SQLFrom .= "INNER JOIN dynamic_field_value dfv$DynamicFieldJoinCounter
                        ON (art.id = dfv$DynamicFieldJoinCounter.object_id
                            AND dfv$DynamicFieldJoinCounter.field_id = " .
                        $DBObject->Quote( $DynamicField->{ID}, 'Integer' ) . ") ";
                }

            }

            $DynamicFieldJoinTables{ $DynamicField->{Name} } = "dfv$DynamicFieldJoinCounter";

            $DynamicFieldJoinCounter++;
        }
    }

    # catch searches for non-existing dynamic fields
    PARAMS:
    for my $Key ( sort keys %Param ) {

        # Only look at fields which start with DynamicField_ and contain a substructure that is meant for searching.
        #   It could happen that similar scalar parameters are sent to this method, that should be ignored
        #   (see bug#13412).
        next PARAMS if !ref $Param{$Key};
        next PARAMS if $Key !~ /^DynamicField_(.*)$/;

        my $DynamicFieldName = $1;
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'Error',
            Message  => qq[No such dynamic field "$DynamicFieldName" (or it is inactive)],
        );

        return;
    }

    # get time object
    # remember current time to prevent searches for future timestamps
    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

    # get articles created older/newer than x minutes or older/newer than a date
    my %ArticleTime = (
        ArticleCreateTime => "art.create_time",
    );
    for my $Key ( sort keys %ArticleTime ) {

        # get articles created older than x minutes
        if ( defined $Param{ $Key . 'OlderMinutes' } ) {

            $Param{ $Key . 'OlderMinutes' } ||= 0;

            my $Time = $Kernel::OM->Create('Kernel::System::DateTime');
            $Time->Subtract( Minutes => $Param{ $Key . 'OlderMinutes' } );

            $SQLExt .= sprintf( " AND ( %s <= '%s' )", $ArticleTime{$Key}, $Time->ToString() );
        }

        # get articles created newer than x minutes
        if ( defined $Param{ $Key . 'NewerMinutes' } ) {

            $Param{ $Key . 'NewerMinutes' } ||= 0;

            my $Time = $Kernel::OM->Create('Kernel::System::DateTime');
            $Time->Subtract( Minutes => $Param{ $Key . 'NewerMinutes' } );

            $SQLExt .= sprintf( " AND ( %s >= '%s' )", $ArticleTime{$Key}, $Time->ToString() );
        }

        # get articles created older than xxxx-xx-xx xx:xx date
        my $CompareOlderNewerDate;
        if ( $Param{ $Key . 'OlderDate' } ) {
            if (
                $Param{ $Key . 'OlderDate' }
                !~ /(\d\d\d\d)-(\d\d|\d)-(\d\d|\d) (\d\d|\d):(\d\d|\d):(\d\d|\d)/
                )
            {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Invalid time format '" . $Param{ $Key . 'OlderDate' } . "'!",
                );
                return;
            }

            my $SystemTime = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    Year   => $1,
                    Month  => $2,
                    Day    => $3,
                    Hour   => $4,
                    Minute => $5,
                    Second => $6,
                }
            );

            if ( !$SystemTime ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message =>
                        "Search not executed due to invalid time '"
                        . $Param{ $Key . 'OlderDate' } . "'!",
                );
                return;
            }
            $CompareOlderNewerDate = $SystemTime;

            $SQLExt .= " AND ($ArticleTime{$Key} <= '" . $Param{ $Key . 'OlderDate' } . "')";

        }

        # get articles created newer than xxxx-xx-xx xx:xx date
        if ( $Param{ $Key . 'NewerDate' } ) {
            if (
                $Param{ $Key . 'NewerDate' }
                !~ /(\d\d\d\d)-(\d\d|\d)-(\d\d|\d) (\d\d|\d):(\d\d|\d):(\d\d|\d)/
                )
            {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Invalid time format '" . $Param{ $Key . 'NewerDate' } . "'!",
                );
                return;
            }

            # convert param date to system time
            my $SystemTime = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {

                    Year   => $1,
                    Month  => $2,
                    Day    => $3,
                    Hour   => $4,
                    Minute => $5,
                    Second => $6,
                }
            );
            if ( !$SystemTime ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message =>
                        "Search not executed due to invalid time '"
                        . $Param{ $Key . 'NewerDate' } . "'!",
                );
                return;
            }

            # don't execute queries if newer date is after current date
            return if $SystemTime > $DateTimeObject;

            # don't execute queries if older/newer date restriction show now valid timeframe
            return if $CompareOlderNewerDate && $SystemTime > $CompareOlderNewerDate;

            $SQLExt .= " AND ($ArticleTime{$Key} >= '" . $Param{ $Key . 'NewerDate' } . "')";
        }
    }

    # get tickets created/escalated older/newer than x minutes
    my %TicketTime = (
        TicketCreateTime             => 'st.create_time',
        TicketEscalationTime         => 'st.escalation_time',
        TicketEscalationUpdateTime   => 'st.escalation_update_time',
        TicketEscalationResponseTime => 'st.escalation_response_time',
        TicketEscalationSolutionTime => 'st.escalation_solution_time',
    );
    for my $Key ( sort keys %TicketTime ) {

        # get tickets created or escalated older than x minutes
        if ( defined $Param{ $Key . 'OlderMinutes' } ) {

            $Param{ $Key . 'OlderMinutes' } ||= 0;

            # exclude tickets with no escalation
            if ( $Key =~ m{ \A TicketEscalation }xms ) {
                $SQLExt .= " AND $TicketTime{$Key} != 0";
            }

            my $Time = $DateTimeObject->Clone();
            $Time->Subtract( Minutes => $Param{ $Key . 'OlderMinutes' } );

            my $TargetTime = $Key eq 'TicketCreateTime' ? $Time->ToString() : $Time->ToEpoch();

            $SQLExt .= sprintf( " AND ( %s <= '%s' )", $TicketTime{$Key}, $TargetTime );
        }

        # get tickets created or escalated newer than x minutes
        if ( defined $Param{ $Key . 'NewerMinutes' } ) {

            $Param{ $Key . 'NewerMinutes' } ||= 0;

            # exclude tickets with no escalation
            if ( $Key =~ m{ \A TicketEscalation }xms ) {
                $SQLExt .= " AND $TicketTime{$Key} != 0";
            }

            my $Time = $Kernel::OM->Create('Kernel::System::DateTime');
            $Time->Subtract( Minutes => $Param{ $Key . 'NewerMinutes' } );

            my $TargetTime = $Key eq 'TicketCreateTime' ? $Time->ToString() : $Time->ToEpoch();

            $SQLExt .= sprintf( " AND ( %s >= '%s' )", $TicketTime{$Key}, $TargetTime );
        }
    }

    # get tickets created/escalated older/newer than xxxx-xx-xx xx:xx date
    for my $Key ( sort keys %TicketTime ) {

        # get tickets created/escalated older than xxxx-xx-xx xx:xx date
        my $CompareOlderNewerDate;
        if ( $Param{ $Key . 'OlderDate' } ) {

            # check time format
            if (
                $Param{ $Key . 'OlderDate' }
                !~ /\d\d\d\d-(\d\d|\d)-(\d\d|\d) (\d\d|\d):(\d\d|\d):(\d\d|\d)/
                )
            {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Invalid time format '" . $Param{ $Key . 'OlderDate' } . "'!",
                );
                return;
            }

            # exclude tickets with no escalation
            if ( $Key =~ m{ \A TicketEscalation }xms ) {
                $SQLExt .= " AND $TicketTime{$Key} != 0";
            }
            my $Time = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $Param{ $Key . 'OlderDate' },
                }
            );

            if ( !$Time ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message =>
                        "Search not executed due to invalid time '"
                        . $Param{ $Key . 'OlderDate' } . "'!",
                );
                return;
            }
            $CompareOlderNewerDate = $Time;

            my $TargetTime = $Key eq 'TicketCreateTime' ? $Time->ToString() : $Time->ToEpoch();

            $SQLExt .= sprintf( " AND ( %s <= '%s' )", $TicketTime{$Key}, $TargetTime );
        }

        # get tickets created/escalated newer than xxxx-xx-xx xx:xx date
        if ( $Param{ $Key . 'NewerDate' } ) {
            if (
                $Param{ $Key . 'NewerDate' }
                !~ /\d\d\d\d-(\d\d|\d)-(\d\d|\d) (\d\d|\d):(\d\d|\d):(\d\d|\d)/
                )
            {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Invalid time format '" . $Param{ $Key . 'NewerDate' } . "'!",
                );
                return;
            }

            # exclude tickets with no escalation
            if ( $Key =~ m{ \A TicketEscalation }xms ) {
                $SQLExt .= " AND $TicketTime{$Key} != 0";
            }
            my $Time = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $Param{ $Key . 'NewerDate' },
                }
            );
            if ( !$Time ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message =>
                        "Search not executed due to invalid time '"
                        . $Param{ $Key . 'NewerDate' } . "'!",
                );
                return;
            }

            # don't execute queries if newer date is after current date
            return if $Time > $DateTimeObject;

            # don't execute queries if older/newer date restriction show now valid timeframe
            return if $CompareOlderNewerDate && $Time > $CompareOlderNewerDate;

            my $TargetTime = $Key eq 'TicketCreateTime' ? $Time->ToString() : $Time->ToEpoch();

            $SQLExt .= sprintf( " AND ( %s >= '%s' )", $TicketTime{$Key}, $TargetTime );
        }
    }

    # get tickets changed older than x minutes
    if ( defined $Param{TicketChangeTimeOlderMinutes} ) {

        $Param{TicketChangeTimeOlderMinutes} ||= 0;

        my $TimeStamp = $Kernel::OM->Create('Kernel::System::DateTime');
        $TimeStamp->Subtract( Minutes => $Param{TicketChangeTimeOlderMinutes} );

        $Param{TicketChangeTimeOlderDate} = $TimeStamp->ToString();
    }

    # get tickets changed newer than x minutes
    if ( defined $Param{TicketChangeTimeNewerMinutes} ) {

        $Param{TicketChangeTimeNewerMinutes} ||= 0;

        my $TimeStamp = $Kernel::OM->Create('Kernel::System::DateTime');
        $TimeStamp->Subtract( Minutes => $Param{TicketChangeTimeNewerMinutes} );

        $Param{TicketChangeTimeNewerDate} = $TimeStamp->ToString();
    }

    # get tickets based on ticket history changed older than xxxx-xx-xx xx:xx date
    my $CompareChangeTimeOlderNewerDate;
    if ( $Param{TicketChangeTimeOlderDate} ) {

        # check time format
        if (
            $Param{TicketChangeTimeOlderDate}
            !~ /\d\d\d\d-(\d\d|\d)-(\d\d|\d) (\d\d|\d):(\d\d|\d):(\d\d|\d)/
            )
        {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Invalid time format '$Param{TicketChangeTimeOlderDate}'!",
            );
            return;
        }

        my $Time = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Param{TicketChangeTimeOlderDate},
            }
        );

        if ( !$Time ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message =>
                    "Search not executed due to invalid time '"
                    . $Param{TicketChangeTimeOlderDate} . "'!",
            );
            return;
        }
        $CompareChangeTimeOlderNewerDate = $Time;

        my $THRef = $Self->_TicketHistoryReferenceForSearchArgument(
            Argument => 'TicketChangeTimeOlderDate',
        );
        return if !$THRef;

        $SQLExt .= " AND ${ THRef }.create_time <= '"
            . $DBObject->Quote( $Param{TicketChangeTimeOlderDate} ) . "'";
    }

    # get tickets based on ticket history changed newer than xxxx-xx-xx xx:xx date
    if ( $Param{TicketChangeTimeNewerDate} ) {
        if (
            $Param{TicketChangeTimeNewerDate}
            !~ /\d\d\d\d-(\d\d|\d)-(\d\d|\d) (\d\d|\d):(\d\d|\d):(\d\d|\d)/
            )
        {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Invalid time format '$Param{TicketChangeTimeNewerDate}'!",
            );
            return;
        }

        my $Time = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Param{TicketChangeTimeNewerDate},
            }
        );

        if ( !$Time ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message =>
                    "Search not executed due to invalid time '"
                    . $Param{TicketChangeTimeNewerDate} . "'!",
            );
            return;
        }

        # don't execute queries if newer date is after current date
        return if $Time > $DateTimeObject;

        # don't execute queries if older/newer date restriction show now valid timeframe
        return if $CompareChangeTimeOlderNewerDate && $Time > $CompareChangeTimeOlderNewerDate;

        my $THRef = $Self->_TicketHistoryReferenceForSearchArgument(
            Argument => 'TicketChangeTimeNewerDate',
        );
        return if !$THRef;

        $SQLExt .= " AND ${ THRef }.create_time >= '"
            . $DBObject->Quote( $Param{TicketChangeTimeNewerDate} ) . "'";
    }

    # get tickets changed older than x minutes
    if ( defined $Param{TicketLastChangeTimeOlderMinutes} ) {

        $Param{TicketLastChangeTimeOlderMinutes} ||= 0;

        my $TimeStamp = $DateTimeObject->Clone();
        $TimeStamp->Subtract( Minutes => $Param{TicketLastChangeTimeOlderMinutes} );

        $Param{TicketLastChangeTimeOlderDate} = $TimeStamp->ToString();
    }

    # get tickets changed newer than x minutes
    if ( defined $Param{TicketLastChangeTimeNewerMinutes} ) {

        $Param{TicketLastChangeTimeNewerMinutes} ||= 0;

        my $TimeStamp = $DateTimeObject->Clone();
        $TimeStamp->Subtract( Minutes => $Param{TicketLastChangeTimeNewerMinutes} );

        $Param{TicketLastChangeTimeNewerDate} = $TimeStamp->ToString();
    }

    # get tickets changed older than xxxx-xx-xx xx:xx date
    my $CompareLastChangeTimeOlderNewerDate;
    if ( $Param{TicketLastChangeTimeOlderDate} ) {

        # check time format
        if (
            $Param{TicketLastChangeTimeOlderDate}
            !~ /\d\d\d\d-(\d\d|\d)-(\d\d|\d) (\d\d|\d):(\d\d|\d):(\d\d|\d)/
            )
        {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Invalid time format '$Param{TicketLastChangeTimeOlderDate}'!",
            );
            return;
        }

        my $Time = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Param{TicketLastChangeTimeOlderDate},
            }
        );

        if ( !$Time ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message =>
                    "Search not executed due to invalid time '"
                    . $Param{TicketLastChangeTimeOlderDate} . "'!",
            );
            return;
        }
        $CompareLastChangeTimeOlderNewerDate = $Time;

        $SQLExt .= " AND st.change_time <= '"
            . $DBObject->Quote( $Param{TicketLastChangeTimeOlderDate} ) . "'";
    }

    # get tickets changed newer than xxxx-xx-xx xx:xx date
    if ( $Param{TicketLastChangeTimeNewerDate} ) {
        if (
            $Param{TicketLastChangeTimeNewerDate}
            !~ /\d\d\d\d-(\d\d|\d)-(\d\d|\d) (\d\d|\d):(\d\d|\d):(\d\d|\d)/
            )
        {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Invalid time format '$Param{TicketLastChangeTimeNewerDate}'!",
            );
            return;
        }

        my $Time = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Param{TicketLastChangeTimeNewerDate},
            }
        );

        if ( !$Time ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message =>
                    "Search not executed due to invalid time '"
                    . $Param{TicketLastChangeTimeNewerDate} . "'!",
            );
            return;
        }

        # don't execute queries if newer date is after current date
        return if $Time > $DateTimeObject;

        # don't execute queries if older/newer date restriction show now valid timeframe
        return
            if $CompareLastChangeTimeOlderNewerDate && $Time > $CompareLastChangeTimeOlderNewerDate;

        $SQLExt .= " AND st.change_time >= '"
            . $DBObject->Quote( $Param{TicketLastChangeTimeNewerDate} ) . "'";
    }

    # get tickets closed older than x minutes
    if ( defined $Param{TicketCloseTimeOlderMinutes} ) {

        $Param{TicketCloseTimeOlderMinutes} ||= 0;

        my $TimeStamp = $DateTimeObject->Clone();
        $TimeStamp->Subtract( Minutes => $Param{TicketCloseTimeOlderMinutes} );

        $Param{TicketCloseTimeOlderDate} = $TimeStamp->ToString();
    }

    # get tickets closed newer than x minutes
    if ( defined $Param{TicketCloseTimeNewerMinutes} ) {

        $Param{TicketCloseTimeNewerMinutes} ||= 0;

        my $TimeStamp = $DateTimeObject->Clone();
        $TimeStamp->Subtract( Minutes => $Param{TicketCloseTimeNewerMinutes} );

        $Param{TicketCloseTimeNewerDate} = $TimeStamp->ToString();
    }

    # get tickets closed older than xxxx-xx-xx xx:xx date
    my $CompareCloseTimeOlderNewerDate;
    if ( $Param{TicketCloseTimeOlderDate} ) {
        my $THRef = $Self->_TicketHistoryReferenceForSearchArgument(
            Argument => 'TicketCloseTimeOlderDate',
        );
        return if !$THRef;

        # check time format
        if (
            $Param{TicketCloseTimeOlderDate}
            !~ /\d\d\d\d-(\d\d|\d)-(\d\d|\d) (\d\d|\d):(\d\d|\d):(\d\d|\d)/
            )
        {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Invalid time format '$Param{TicketCloseTimeOlderDate}'!",
            );
            return;
        }

        my $Time = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Param{TicketCloseTimeOlderDate},
            }
        );

        if ( !$Time ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message =>
                    "Search not executed due to invalid time '"
                    . $Param{TicketCloseTimeOlderDate} . "'!",
            );
            return;
        }
        $CompareCloseTimeOlderNewerDate = $Time;

        # get close state ids
        my @List = $Kernel::OM->Get('Kernel::System::State')->StateGetStatesByType(
            StateType => ['closed'],
            Result    => 'ID',
        );
        my @StateID = ( $Self->HistoryTypeLookup( Type => 'NewTicket' ) );
        push( @StateID, $Self->HistoryTypeLookup( Type => 'StateUpdate' ) );
        if (@StateID) {
            $SQLExt .= sprintf(
                " AND %s.history_type_id IN (%s) AND %s.state_id IN (%s) AND %s.create_time <= '%s'",
                $THRef,
                ( join ', ', sort @StateID ),
                $THRef,
                ( join ', ', sort @List ),
                $THRef,
                $DBObject->Quote( $Param{TicketCloseTimeOlderDate} )
            );
        }
    }

    # get tickets closed newer than xxxx-xx-xx xx:xx date
    if ( $Param{TicketCloseTimeNewerDate} ) {
        my $THRef = $Self->_TicketHistoryReferenceForSearchArgument(
            Argument => 'TicketCloseTimeNewerDate',
        );
        return if !$THRef;

        if (
            $Param{TicketCloseTimeNewerDate}
            !~ /\d\d\d\d-(\d\d|\d)-(\d\d|\d) (\d\d|\d):(\d\d|\d):(\d\d|\d)/
            )
        {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Invalid time format '$Param{TicketCloseTimeNewerDate}'!",
            );
            return;
        }

        my $Time = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Param{TicketCloseTimeNewerDate},
            }
        );

        if ( !$Time ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message =>
                    "Search not executed due to invalid time '"
                    . $Param{TicketCloseTimeNewerDate} . "'!",
            );
            return;
        }

        # don't execute queries if newer date is after current date
        return if $Time > $DateTimeObject;

        # don't execute queries if older/newer date restriction show now valid timeframe
        return if $CompareCloseTimeOlderNewerDate && $Time > $CompareCloseTimeOlderNewerDate;

        # get close state ids
        my @List = $Kernel::OM->Get('Kernel::System::State')->StateGetStatesByType(
            StateType => ['closed'],
            Result    => 'ID',
        );
        my @StateID = ( $Self->HistoryTypeLookup( Type => 'NewTicket' ) );
        push( @StateID, $Self->HistoryTypeLookup( Type => 'StateUpdate' ) );
        if (@StateID) {
            $SQLExt .= sprintf(
                " AND %s.history_type_id IN (%s) AND %s.state_id IN (%s) AND %s.create_time >= '%s'",
                $THRef,
                ( join ', ', sort @StateID ),
                $THRef,
                ( join ', ', sort @List ),
                $THRef,
                $DBObject->Quote( $Param{TicketCloseTimeNewerDate} )
            );
        }
    }

    # Get tickets last closed older than x minutes.
    if ( defined $Param{TicketLastCloseTimeOlderMinutes} ) {

        $Param{TicketLastCloseTimeOlderMinutes} ||= 0;

        my $TimeStamp = $DateTimeObject->Clone();
        $TimeStamp->Subtract( Minutes => $Param{TicketLastCloseTimeOlderMinutes} );

        $Param{TicketLastCloseTimeOlderDate} = $TimeStamp->ToString();
    }

    # Get tickets last closed newer than x minutes.
    if ( defined $Param{TicketLastCloseTimeNewerMinutes} ) {

        $Param{TicketLastCloseTimeNewerMinutes} ||= 0;

        my $TimeStamp = $DateTimeObject->Clone();
        $TimeStamp->Subtract( Minutes => $Param{TicketLastCloseTimeNewerMinutes} );

        $Param{TicketLastCloseTimeNewerDate} = $TimeStamp->ToString();
    }

    # Get tickets last closed older than xxxx-xx-xx xx:xx date.
    my $CompareLastCloseTimeOlderNewerDate;
    if ( $Param{TicketLastCloseTimeOlderDate} ) {
        my $THRef = $Self->_TicketHistoryReferenceForSearchArgument(
            Argument => 'TicketLastCloseTimeOlderDate',
        );
        return if !$THRef;

        # Check time format.
        if (
            $Param{TicketLastCloseTimeOlderDate}
            !~ /\d\d\d\d-(\d\d|\d)-(\d\d|\d) (\d\d|\d):(\d\d|\d):(\d\d|\d)/
            )
        {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Invalid time format '$Param{TicketLastCloseTimeOlderDate}'!",
            );
            return;
        }

        my $Time = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Param{TicketLastCloseTimeOlderDate},
            }
        );

        if ( !$Time ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message =>
                    "Search not executed due to invalid time '"
                    . $Param{TicketLastCloseTimeOlderDate} . "'!",
            );
            return;
        }
        $CompareLastCloseTimeOlderNewerDate = $Time;

        # Get close state ids.
        my @List = $Kernel::OM->Get('Kernel::System::State')->StateGetStatesByType(
            StateType => ['closed'],
            Result    => 'ID',
        );
        my @StateID = ( $Self->HistoryTypeLookup( Type => 'NewTicket' ) );
        push( @StateID, $Self->HistoryTypeLookup( Type => 'StateUpdate' ) );
        if (@StateID) {
            $SQLExt .= sprintf(
                " AND %s.history_type_id IN (%s) AND %s.state_id IN (%s) AND "
                    . "%s.create_time <= '%s' AND "
                    . "%s.create_time IN "
                    . "("
                    . "SELECT lco1.create_time "
                    . "FROM ticket_history lco1 "
                    . "INNER JOIN "
                    . "("
                    . "SELECT ticket_id, MAX(create_time) AS max_time "
                    . "FROM ticket_history "
                    . "WHERE history_type_id IN (%s) AND state_id IN (%s) "
                    . "GROUP BY ticket_id "
                    . ") lco2 "
                    . "ON lco1.ticket_id = lco2.ticket_id "
                    . "AND lco1.create_time = lco2.max_time "
                    . ") ",
                $THRef,
                ( join ', ', sort @StateID ),
                $THRef,
                ( join ', ', sort @List ),
                $THRef,
                $DBObject->Quote( $Param{TicketLastCloseTimeOlderDate} ),
                $THRef,
                ( join ', ', sort @StateID ),
                ( join ', ', sort @List )
            );
        }
    }

    # Get tickets last closed newer than xxxx-xx-xx xx:xx date.
    if ( $Param{TicketLastCloseTimeNewerDate} ) {
        my $THRef = $Self->_TicketHistoryReferenceForSearchArgument(
            Argument => 'TicketLastCloseTimeNewerDate',
        );
        return if !$THRef;

        if (
            $Param{TicketLastCloseTimeNewerDate}
            !~ /\d\d\d\d-(\d\d|\d)-(\d\d|\d) (\d\d|\d):(\d\d|\d):(\d\d|\d)/
            )
        {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Invalid time format '$Param{TicketLastCloseTimeNewerDate}'!",
            );
            return;
        }

        my $Time = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Param{TicketLastCloseTimeNewerDate},
            }
        );

        if ( !$Time ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message =>
                    "Search not executed due to invalid time '"
                    . $Param{TicketLastCloseTimeNewerDate} . "'!",
            );
            return;
        }

        # Don't execute queries if newer date is after current date.
        return if $Time > $DateTimeObject;

        # Don't execute queries if older/newer date restriction show now valid timeframe.
        return if $CompareLastCloseTimeOlderNewerDate && $Time > $CompareLastCloseTimeOlderNewerDate;

        # Get close state ids.
        my @List = $Kernel::OM->Get('Kernel::System::State')->StateGetStatesByType(
            StateType => ['closed'],
            Result    => 'ID',
        );
        my @StateID = ( $Self->HistoryTypeLookup( Type => 'NewTicket' ) );
        push( @StateID, $Self->HistoryTypeLookup( Type => 'StateUpdate' ) );
        if (@StateID) {
            $SQLExt .= sprintf(
                " AND %s.history_type_id IN (%s) AND %s.state_id IN (%s) AND "
                    . "%s.create_time >= '%s' AND "
                    . "%s.create_time IN "
                    . "("
                    . "SELECT lcn1.create_time "
                    . "FROM ticket_history lcn1 "
                    . "INNER JOIN "
                    . "("
                    . "SELECT ticket_id, MAX(create_time) AS max_time "
                    . "FROM ticket_history "
                    . "WHERE history_type_id IN (%s) AND state_id IN (%s) "
                    . "GROUP BY ticket_id "
                    . ") lcn2 "
                    . "ON lcn1.ticket_id = lcn2.ticket_id "
                    . "AND lcn1.create_time = lcn2.max_time "
                    . ") ",
                $THRef,
                ( join ', ', sort @StateID ),
                $THRef,
                ( join ', ', sort @List ),
                $THRef,
                $DBObject->Quote( $Param{TicketLastCloseTimeNewerDate} ),
                $THRef,
                ( join ', ', sort @StateID ),
                ( join ', ', sort @List )
            );
        }
    }

    # check if only pending states are used
    if (
        defined $Param{TicketPendingTimeOlderMinutes}
        || defined $Param{TicketPendingTimeNewerMinutes}
        || $Param{TicketPendingTimeOlderDate}
        || $Param{TicketPendingTimeNewerDate}
        )
    {

        # get pending state ids
        my @List = $Kernel::OM->Get('Kernel::System::State')->StateGetStatesByType(
            StateType => [ 'pending reminder', 'pending auto' ],
            Result    => 'ID',
        );
        if (@List) {
            $SQLExt .= " AND st.ticket_state_id IN (${\(join ', ', sort @List)}) ";
        }
    }

    # get tickets pending older than x minutes
    if ( defined $Param{TicketPendingTimeOlderMinutes} ) {

        $Param{TicketPendingTimeOlderMinutes} ||= 0;

        my $TimeStamp = $Kernel::OM->Create('Kernel::System::DateTime');

        $TimeStamp->Subtract( Minutes => $Param{TicketPendingTimeOlderMinutes} );

        $Param{TicketPendingTimeOlderDate} = $TimeStamp->ToString();
    }

    # get tickets pending newer than x minutes
    if ( defined $Param{TicketPendingTimeNewerMinutes} ) {

        $Param{TicketPendingTimeNewerMinutes} ||= 0;

        my $TimeStamp = $DateTimeObject->Clone();
        $TimeStamp->Subtract( Minutes => $Param{TicketPendingTimeNewerMinutes} );

        $Param{TicketPendingTimeNewerDate} = $TimeStamp->ToString();
    }

    # get pending tickets older than xxxx-xx-xx xx:xx date
    my $ComparePendingTimeOlderNewerDate;
    if ( $Param{TicketPendingTimeOlderDate} ) {

        # check time format
        if (
            $Param{TicketPendingTimeOlderDate}
            !~ /\d\d\d\d-(\d\d|\d)-(\d\d|\d) (\d\d|\d):(\d\d|\d):(\d\d|\d)/
            )
        {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Invalid time format '$Param{TicketPendingTimeOlderDate}'!",
            );
            return;
        }

        my $TimeStamp = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Param{TicketPendingTimeOlderDate},
            }
        );

        if ( !$TimeStamp ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message =>
                    "Search not executed due to invalid time '"
                    . $Param{TicketPendingTimeOlderDate} . "'!",
            );
            return;
        }
        $ComparePendingTimeOlderNewerDate = $TimeStamp;

        $SQLExt .= " AND st.until_time <= " . $TimeStamp->ToEpoch();
    }

    # get pending tickets newer than xxxx-xx-xx xx:xx date
    if ( $Param{TicketPendingTimeNewerDate} ) {
        if (
            $Param{TicketPendingTimeNewerDate}
            !~ /\d\d\d\d-(\d\d|\d)-(\d\d|\d) (\d\d|\d):(\d\d|\d):(\d\d|\d)/
            )
        {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Invalid time format '$Param{TicketPendingTimeNewerDate}'!",
            );
            return;
        }

        my $TimeStamp = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Param{TicketPendingTimeNewerDate},
            }
        );

        if ( !$TimeStamp ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message =>
                    "Search not executed due to invalid time '"
                    . $Param{TicketPendingTimeNewerDate} . "'!",
            );
            return;
        }

        # don't execute queries if older/newer date restriction show now valid timeframe
        return
            if $ComparePendingTimeOlderNewerDate && $TimeStamp > $ComparePendingTimeOlderNewerDate;

        $SQLExt .= " AND st.until_time >= " . $TimeStamp->ToEpoch();
    }

    # archive flag
    if ( $Kernel::OM->Get('Kernel::Config')->Get('Ticket::ArchiveSystem') ) {

        # if no flag is given, only search for not archived ticket
        if ( !$Param{ArchiveFlags} ) {
            $Param{ArchiveFlags} = ['n'];
        }

        # prepare search with archive flags, check arguments
        if ( ref $Param{ArchiveFlags} ne 'ARRAY' ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Invalid attribute ArchiveFlags '$Param{ArchiveFlags}'!",
            );
            return;
        }

        # prepare options
        my %Options;
        for my $Key ( @{ $Param{ArchiveFlags} } ) {
            $Options{$Key} = 1;
        }

        # search for archived
        if ( $Options{y} && !$Options{n} ) {
            $SQLExt .= ' AND archive_flag = 1';
        }

        # search for not archived
        elsif ( !$Options{y} && $Options{n} ) {
            $SQLExt .= ' AND archive_flag = 0';
        }
    }

    # database query for sort/order by option
    if ( $Result ne 'COUNT' ) {
        $SQLExt .= ' ORDER BY';
        for my $Count ( 0 .. $#SortByArray ) {
            if ( $Count > 0 ) {
                $SQLExt .= ',';
            }

            # sort by dynamic field
            if ( $ValidDynamicFieldParams{ $SortByArray[$Count] } ) {
                my ($DynamicFieldName) = $SortByArray[$Count] =~ m/^DynamicField_(.*)$/smx;

                my $DynamicField = $TicketDynamicFieldName2Config{$DynamicFieldName} ||
                    $ArticleDynamicFieldName2Config{$DynamicFieldName};

                # If the table was already joined for searching, we reuse it.
                if ( !$DynamicFieldJoinTables{$DynamicFieldName} ) {

                    if ( $TicketDynamicFieldName2Config{$DynamicFieldName} ) {

                        # Join the table for this dynamic field; use a left outer join in this case.
                        # With an INNER JOIN we'd limit the result set to tickets which have an entry
                        #   for the DF which is used for sorting.
                        $SQLFrom
                            .= " LEFT OUTER JOIN dynamic_field_value dfv$DynamicFieldJoinCounter
                            ON (st.id = dfv$DynamicFieldJoinCounter.object_id
                                AND dfv$DynamicFieldJoinCounter.field_id = " .
                            $DBObject->Quote( $DynamicField->{ID}, 'Integer' ) . ") ";
                    }
                    elsif ( $ArticleDynamicFieldName2Config{$DynamicFieldName} ) {
                        if ( !$ArticleTableJoined ) {
                            $SQLFrom .= ' INNER JOIN article art ON st.id = art.ticket_id ';
                            $ArticleTableJoined = 1;
                        }

                        $SQLFrom
                            .= " LEFT OUTER JOIN dynamic_field_value dfv$DynamicFieldJoinCounter
                            ON (art.id = dfv$DynamicFieldJoinCounter.object_id
                                AND dfv$DynamicFieldJoinCounter.field_id = " .
                            $DBObject->Quote( $DynamicField->{ID}, 'Integer' ) . ") ";
                    }

                    $DynamicFieldJoinTables{ $DynamicField->{Name} } = "dfv$DynamicFieldJoinCounter";

                    $DynamicFieldJoinCounter++;
                }

                my $SQLOrderField = $DynamicFieldBackendObject->SearchSQLOrderFieldGet(
                    DynamicFieldConfig => $DynamicField,
                    TableAlias         => $DynamicFieldJoinTables{$DynamicFieldName},
                );

                $SQLSelect .= ", $SQLOrderField ";
                $SQLExt    .= " $SQLOrderField ";
            }
            elsif (
                $SortByArray[$Count] eq 'Owner'
                || $SortByArray[$Count] eq 'Responsible'
                )
            {
                # Include first name, last name and login in select.
                $SQLSelect
                    .= ', ' . $SortOptions{ $SortByArray[$Count] }
                    . ', u.first_name, u.last_name, u.login ';

                # Join the users table on user's ID.
                $SQLFrom
                    .= ' JOIN users u '
                    . ' ON ' . $SortOptions{ $SortByArray[$Count] } . ' = u.id ';

                my $FirstnameLastNameOrder = $Kernel::OM->Get('Kernel::Config')->Get('FirstnameLastnameOrder') || 0;
                my $OrderBySuffix          = $OrderByArray[$Count] eq 'Up' ? 'ASC' : 'DESC';

                # Sort by configured first and last name order.
                if ( $FirstnameLastNameOrder eq '1' || $FirstnameLastNameOrder eq '6' ) {
                    $SQLExt .= " u.last_name $OrderBySuffix, u.first_name ";
                }
                elsif ( $FirstnameLastNameOrder eq '2' ) {
                    $SQLExt .= " u.first_name $OrderBySuffix, u.last_name $OrderBySuffix, u.login ";
                }
                elsif ( $FirstnameLastNameOrder eq '3' || $FirstnameLastNameOrder eq '7' ) {
                    $SQLExt .= " u.last_name $OrderBySuffix, u.first_name $OrderBySuffix, u.login ";
                }
                elsif ( $FirstnameLastNameOrder eq '4' ) {
                    $SQLExt .= " u.login $OrderBySuffix, u.first_name $OrderBySuffix, u.last_name ";
                }
                elsif ( $FirstnameLastNameOrder eq '5' || $FirstnameLastNameOrder eq '8' ) {
                    $SQLExt .= " u.login $OrderBySuffix, u.last_name $OrderBySuffix, u.first_name ";
                }
                else {
                    $SQLExt .= " u.first_name $OrderBySuffix, u.last_name ";
                }
            }
            elsif (
                $SortByArray[$Count] eq 'EscalationUpdateTime'
                || $SortByArray[$Count] eq 'EscalationResponseTime'
                || $SortByArray[$Count] eq 'EscalationSolutionTime'
                || $SortByArray[$Count] eq 'EscalationTime'
                || $SortByArray[$Count] eq 'PendingTime'
                )
            {

                # Tickets with no Escalation or Pending time have '0' as value in the according ticket columns.
                # When sorting by these columns always place ticket's with '0' value on the end, no matter order by.
                if ( $Kernel::OM->Get('Kernel::System::DB')->{'DB::Type'} eq 'mysql' ) {

                    # For MySQL create SQL order by query 'ORDER BY column_value = 0, column_value ASC/DESC'.
                    $SQLSelect .= ', ' . $SortOptions{ $SortByArray[$Count] };
                    $SQLExt
                        .= ' ' . $SortOptions{ $SortByArray[$Count] };
                }
                else {

                    # For PostgreSQL and Oracle transform selected 0 values to NULL and use 'NULLS LAST'
                    #   in the end of SQL query.
                    $SQLSelect .= ', ' . $SortOptions{ $SortByArray[$Count] } . ' AS order_value ';
                    $SQLExt    .= ' order_value ';
                }
            }
            else {

                # Regular sort.
                $SQLSelect .= ', ' . $SortOptions{ $SortByArray[$Count] };
                $SQLExt    .= ' ' . $SortOptions{ $SortByArray[$Count] };
            }

            if ( $OrderByArray[$Count] eq 'Up' ) {
                $SQLExt .= ' ASC';
            }
            else {
                $SQLExt .= ' DESC';
            }
        }
    }

    # Add only the sql join for the queue table, if columns from the queue table exists in the sql statement.
    if ( %GroupList || $LookupSortByArray{Queue} ) {
        $SQLFrom .= ' INNER JOIN queue sq ON sq.id = st.queue_id ';
    }

    # check cache
    my $CacheObject;
    if ( ( $ArticleTableJoined && $Param{FullTextIndex} ) || $Param{CacheTTL} ) {
        $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
        my $CacheData = $CacheObject->Get(
            Type => 'TicketSearch',
            Key  => $SQLSelect . $SQLFrom . $SQLExt . $Result . $Limit,
        );

        if ( defined $CacheData ) {
            if ( ref $CacheData eq 'HASH' ) {
                return %{$CacheData};
            }
            elsif ( ref $CacheData eq 'ARRAY' ) {
                return @{$CacheData};
            }
            elsif ( ref $CacheData eq '' ) {
                return $CacheData;
            }
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Invalid ref ' . ref($CacheData) . '!'
            );
            return;
        }
    }

    # database query
    my %Tickets;
    my @TicketIDs;
    my $Count;

    return if !$DBObject->Prepare(
        SQL   => $SQLSelect . $SQLFrom . $SQLExt,
        Limit => $Limit
    );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Count = $Row[0];
        $Tickets{ $Row[0] } = $Row[1];
        push @TicketIDs, $Row[0];
    }

    # return COUNT
    if ( $Result eq 'COUNT' ) {
        if ($CacheObject) {
            $CacheObject->Set(
                Type  => 'TicketSearch',
                Key   => $SQLSelect . $SQLFrom . $SQLExt . $Result . $Limit,
                Value => $Count,
                TTL   => $Param{CacheTTL} || 60 * 4,
            );
        }
        return $Count;
    }

    # return HASH
    elsif ( $Result eq 'HASH' ) {
        if ($CacheObject) {
            $CacheObject->Set(
                Type  => 'TicketSearch',
                Key   => $SQLSelect . $SQLFrom . $SQLExt . $Result . $Limit,
                Value => \%Tickets,
                TTL   => $Param{CacheTTL} || 60 * 4,
            );
        }
        return %Tickets;
    }

    # return ARRAY
    else {
        if ($CacheObject) {
            $CacheObject->Set(
                Type  => 'TicketSearch',
                Key   => $SQLSelect . $SQLFrom . $SQLExt . $Result . $Limit,
                Value => \@TicketIDs,
                TTL   => $Param{CacheTTL} || 60 * 4,
            );
        }
        return @TicketIDs;
    }
}

=head2 TicketCountByAttribute()

Returns count of tickets per value for a specific attribute.

    my $TicketCount = $TicketObject->TicketCountByAttribute(
        Attribute => 'ServiceID',
        TicketIDs => [ 1, 2, 3 ],
    );

Returns:

    $TicketCount = {
        Attribute_Value_1 => 1,
        Attribute_Value_2 => 3,
        ...
    };

=cut

sub TicketCountByAttribute {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Attribute} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Attribute!',
        );
        return;
    }

    # Check supported attributes.
    my $Attribute           = $Param{Attribute};
    my %AttributeToDatabase = (
        Lock       => 'ticket_lock_id',
        LockID     => 'ticket_lock_id',
        Queue      => 'queue_id',
        QueueID    => 'queue_id',
        Priority   => 'ticket_priority_id',
        PriorityID => 'ticket_priority_id',
        Service    => 'service_id',
        ServiceID  => 'service_id',
        SLA        => 'sla_id',
        SLAID      => 'sla_id',
        State      => 'ticket_state_id',
        StateID    => 'ticket_state_id',
        Type       => 'type_id',
        TypeID     => 'type_id',
    );
    if ( !$AttributeToDatabase{$Attribute} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No matching database colum found for Attribute '$Attribute'!",
        );
        return;
    }
    my $DatabaseColumn = $AttributeToDatabase{$Attribute};

    # Nothing to do.
    return {} if !IsArrayRefWithData( $Param{TicketIDs} );
    my @BindTicketIDs = map { \$_ } @{ $Param{TicketIDs} };

    # Prepare value-type attributes.
    my %AttributeValueLookup;
    if ( $Attribute eq 'Lock' ) {
        %AttributeValueLookup = $Kernel::OM->Get('Kernel::System::Lock')->LockList( UserID => 1 );
    }
    elsif ( $Attribute eq 'Queue' ) {
        %AttributeValueLookup = $Kernel::OM->Get('Kernel::System::Queue')->QueueList( Valid => 0 );
    }
    elsif ( $Attribute eq 'Priority' ) {
        %AttributeValueLookup = $Kernel::OM->Get('Kernel::System::Priority')->PriorityList( Valid => 0 );
    }
    elsif ( $Attribute eq 'Service' ) {
        %AttributeValueLookup = $Kernel::OM->Get('Kernel::System::Service')->ServiceList(
            Valid  => 0,
            UserID => 1,
        );
    }
    elsif ( $Attribute eq 'SLA' ) {
        %AttributeValueLookup = $Kernel::OM->Get('Kernel::System::SLA')->SLAList(
            Valid  => 0,
            UserID => 1,
        );
    }
    elsif ( $Attribute eq 'State' ) {
        %AttributeValueLookup = $Kernel::OM->Get('Kernel::System::State')->StateList(
            Valid  => 0,
            UserID => 1,
        );
    }
    elsif ( $Attribute eq 'Type' ) {
        %AttributeValueLookup = $Kernel::OM->Get('Kernel::System::Type')->TypeList( Valid => 0 );
    }
    my $AttributeType = %AttributeValueLookup ? 'Value' : 'ID';

    # Split IN statement with more than 900 elements in more statements combined with OR
    # because Oracle doesn't support more than 1000 elements in one IN statement.
    my @TicketIDs = @BindTicketIDs;
    my @SQLStrings;
    while ( scalar @TicketIDs ) {

        # Remove section in the array.
        my @TicketIDsPart = splice @TicketIDs, 0, 900;

        my $TicketIDString = join ',', ('?') x scalar @TicketIDsPart;

        # Add new statement.
        push @SQLStrings, "id IN ($TicketIDString)";
    }

    my $SQLString = join ' OR ', @SQLStrings;

    # Get count from database.
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    return if !$DBObject->Prepare(
        SQL =>
            'SELECT COUNT(*), ' . $DatabaseColumn
            . ' FROM ticket'
            . ' WHERE ' . $SQLString
            . ' AND ' . $DatabaseColumn . ' IS NOT NULL'
            . ' GROUP BY ' . $DatabaseColumn,
        Bind  => \@BindTicketIDs,
        Limit => 10_000,
    );
    my %AttributeCount;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $AttributeCount{ $Row[1] } = $Row[0];
    }

    # No conversion necessary.
    return \%AttributeCount if $AttributeType eq 'ID';

    # Convert database IDs to values, skip entries with unknown value lookup.
    my %AttributeCountConverted = map { $AttributeValueLookup{$_} => $AttributeCount{$_} }
        grep { $AttributeValueLookup{$_} } sort keys %AttributeCount;
    return \%AttributeCountConverted;
}

=head1 PRIVATE INTERFACE

=head2 _TicketHistoryReferenceForSearchArgument

Returns the ticket history reference to the given search argument.

    my $Self->_TicketHistoryReferenceForSearchArgument(
        Argument => '...' # argument name
    );

Result
    C<undef> - in case the argument is not mapped
    string   - the ticket history reference name

=cut

sub _TicketHistoryReferenceForSearchArgument {
    my ( $Self, %Param ) = @_;

    # Column to TicketHistory table reference map
    my %ArgumentTableMap = (

        # Ticket create columns reference.
        CreatedStates      => 'th0',
        CreatedStateIDs    => 'th0',
        CreatedQueues      => 'th0',
        CreatedQueueIDs    => 'th0',
        CreatedPriorities  => 'th0',
        CreatedPriorityIDs => 'th0',
        CreatedTypes       => 'th0',
        CreatedTypeIDs     => 'th0',
        CreatedUserIDs     => 'th0',

        # Ticket change columns reference.
        TicketChangeTimeNewerDate        => 'th1',
        TicketChangeTimeNewerMinutes     => 'th1',
        TicketChangeTimeOlderDate        => 'th1',
        TicketChangeTimeOlderMinutes     => 'th1',
        TicketLastChangeTimeNewerDate    => 'th1',
        TicketLastChangeTimeNewerMinutes => 'th1',
        TicketLastChangeTimeOlderDate    => 'th1',
        TicketLastChangeTimeOlderMinutes => 'th1',

        # Ticket close columns reference.
        TicketCloseTimeNewerDate        => 'th2',
        TicketCloseTimeNewerMinutes     => 'th2',
        TicketCloseTimeOlderDate        => 'th2',
        TicketCloseTimeOlderMinutes     => 'th2',
        TicketLastCloseTimeNewerDate    => 'th2',
        TicketLastCloseTimeNewerMinutes => 'th2',
        TicketLastCloseTimeOlderDate    => 'th2',
        TicketLastCloseTimeOlderMinutes => 'th2',
    );

    my $Argument = $Param{Argument};

    # Check if the column is mapped
    my $Table = $ArgumentTableMap{$Argument};
    if ( !$Table ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Message  => "TicketSearch :: no table_history map for argument '${ Argument }'",
            Priority => 'error',
        );
        return;
    }

    return $Table;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
