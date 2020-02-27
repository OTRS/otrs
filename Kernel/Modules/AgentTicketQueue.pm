# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentTicketQueue;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # set debug
    $Self->{Debug} = 0;

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');

    my $Config = $ConfigObject->Get("Ticket::Frontend::$Self->{Action}");

    my $SortBy = $ParamObject->GetParam( Param => 'SortBy' )
        || $Config->{'SortBy::Default'}
        || 'Age';

    # Determine the default ordering to be used. Observe the QueueSort setting.
    my $DefaultOrderBy = $Config->{'Order::Default'}
        || 'Up';
    if ( $Config->{QueueSort} ) {
        if ( defined $Config->{QueueSort}->{ $Self->{QueueID} } ) {
            if ( $Config->{QueueSort}->{ $Self->{QueueID} } ) {
                $DefaultOrderBy = 'Down';
            }
            else {
                $DefaultOrderBy = 'Up';
            }
        }
    }

    # Set the sort order from the request parameters, or take the default.
    my $OrderBy = $ParamObject->GetParam( Param => 'OrderBy' )
        || $DefaultOrderBy;

    # get session object
    my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

    # store last queue screen
    $SessionObject->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenOverview',
        Value     => $Self->{RequestedURL},
    );

    # store last screen
    $SessionObject->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenView',
        Value     => $Self->{RequestedURL},
    );

    # get user object
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');

    # get filters stored in the user preferences
    my %Preferences = $UserObject->GetPreferences(
        UserID => $Self->{UserID},
    );
    my $StoredFiltersKey = 'UserStoredFilterColumns-' . $Self->{Action};
    my $JSONObject       = $Kernel::OM->Get('Kernel::System::JSON');
    my $StoredFilters    = $JSONObject->Decode(
        Data => $Preferences{$StoredFiltersKey},
    );

    # delete stored filters if needed
    if ( $ParamObject->GetParam( Param => 'DeleteFilters' ) ) {
        $StoredFilters = {};
    }

    # get the column filters from the web request or user preferences
    my %ColumnFilter;
    my %GetColumnFilter;
    COLUMNNAME:
    for my $ColumnName (
        qw(Owner Responsible State Queue Priority Type Lock Service SLA CustomerID CustomerUserID)
        )
    {
        # get column filter from web request
        my $FilterValue = $ParamObject->GetParam( Param => 'ColumnFilter' . $ColumnName )
            || '';

        # if filter is not present in the web request, try with the user preferences
        if ( $FilterValue eq '' ) {
            if ( $ColumnName eq 'CustomerID' ) {
                $FilterValue = $StoredFilters->{$ColumnName}->[0] || '';
            }
            elsif ( $ColumnName eq 'CustomerUserID' ) {
                $FilterValue = $StoredFilters->{CustomerUserLogin}->[0] || '';
            }
            else {
                $FilterValue = $StoredFilters->{ $ColumnName . 'IDs' }->[0] || '';
            }
        }
        next COLUMNNAME if $FilterValue eq '';
        next COLUMNNAME if $FilterValue eq 'DeleteFilter';

        if ( $ColumnName eq 'CustomerID' ) {
            push @{ $ColumnFilter{$ColumnName} }, $FilterValue;
            push @{ $ColumnFilter{ $ColumnName . 'Raw' } }, $FilterValue;
            $GetColumnFilter{$ColumnName} = $FilterValue;
        }
        elsif ( $ColumnName eq 'CustomerUserID' ) {
            push @{ $ColumnFilter{CustomerUserLogin} },    $FilterValue;
            push @{ $ColumnFilter{CustomerUserLoginRaw} }, $FilterValue;
            $GetColumnFilter{$ColumnName} = $FilterValue;
        }
        else {
            push @{ $ColumnFilter{ $ColumnName . 'IDs' } }, $FilterValue;
            $GetColumnFilter{$ColumnName} = $FilterValue;
        }
    }

    # get all dynamic fields
    $Self->{DynamicField} = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => ['Ticket'],
    );

    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
        next DYNAMICFIELD if !$DynamicFieldConfig->{Name};

        # get filter from web request
        my $FilterValue = $ParamObject->GetParam(
            Param => 'ColumnFilterDynamicField_' . $DynamicFieldConfig->{Name}
        );

        # if no filter from web request, try from user preferences
        if ( !defined $FilterValue || $FilterValue eq '' ) {
            $FilterValue = $StoredFilters->{ 'DynamicField_' . $DynamicFieldConfig->{Name} }->{Equals};
        }

        next DYNAMICFIELD if !defined $FilterValue;
        next DYNAMICFIELD if $FilterValue eq '';
        next DYNAMICFIELD if $FilterValue eq 'DeleteFilter';

        $ColumnFilter{ 'DynamicField_' . $DynamicFieldConfig->{Name} } = {
            Equals => $FilterValue,
        };
        $GetColumnFilter{ 'DynamicField_' . $DynamicFieldConfig->{Name} } = $FilterValue;
    }

    # build NavigationBar & to get the output faster!
    my $Refresh = '';
    if ( $Self->{UserRefreshTime} ) {
        $Refresh = 60 * $Self->{UserRefreshTime};
    }

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Output;
    if ( $Self->{Subaction} ne 'AJAXFilterUpdate' ) {
        $Output = $LayoutObject->Header(
            Refresh => $Refresh,
        );
        $Output .= $LayoutObject->NavigationBar();
    }

    # Notify if there are tickets which are not updated.
    $Output .= $LayoutObject->NotifyNonUpdatedTickets() // '';

    # viewable locks
    my @ViewableLockIDs = $Kernel::OM->Get('Kernel::System::Lock')->LockViewableLock( Type => 'ID' );

    # viewable states
    my @ViewableStateIDs = $Kernel::OM->Get('Kernel::System::State')->StateGetStatesByType(
        Type   => 'Viewable',
        Result => 'ID',
    );

    # get permissions
    my $Permission = 'rw';
    if ( $Config->{ViewAllPossibleTickets} ) {
        $Permission = 'ro';
    }

    # sort on default by using both (Priority, Age) else use only one sort argument
    my %Sort;

    # get if search result should be pre-sorted by priority
    my $PreSortByPriority = $Config->{'PreSort::ByPriority'};
    if ( !$PreSortByPriority ) {
        %Sort = (
            SortBy  => $SortBy,
            OrderBy => $OrderBy,
        );
    }
    else {
        %Sort = (
            SortBy  => [ 'Priority', $SortBy ],
            OrderBy => [ 'Down',     $OrderBy ],
        );
    }

    # get custom queues
    my @ViewableQueueIDs;
    if ( !$Self->{QueueID} ) {
        @ViewableQueueIDs = $Kernel::OM->Get('Kernel::System::Queue')->GetAllCustomQueues(
            UserID => $Self->{UserID},
        );
    }
    else {
        @ViewableQueueIDs = ( $Self->{QueueID} );
    }

    # get subqueue display setting
    my $UseSubQueues = $ParamObject->GetParam( Param => 'UseSubQueues' ) // $Config->{UseSubQueues} || 0;

    my %Filters = (
        All => {
            Name   => Translatable('All tickets'),
            Prio   => 1000,
            Search => {
                StateIDs => \@ViewableStateIDs,
                QueueIDs => \@ViewableQueueIDs,
                %Sort,
                Permission   => $Permission,
                UserID       => $Self->{UserID},
                UseSubQueues => $UseSubQueues,
            },
        },
        Unlocked => {
            Name   => Translatable('Available tickets'),
            Prio   => 1001,
            Search => {
                LockIDs  => \@ViewableLockIDs,
                StateIDs => \@ViewableStateIDs,
                QueueIDs => \@ViewableQueueIDs,
                %Sort,
                Permission   => $Permission,
                UserID       => $Self->{UserID},
                UseSubQueues => $UseSubQueues,
            },
        },
    );

    my $Filter = $ParamObject->GetParam( Param => 'Filter' ) || 'Unlocked';

    # check if filter is valid
    if ( !$Filters{$Filter} ) {
        $LayoutObject->FatalError(
            Message => $LayoutObject->{LanguageObject}->Translate( 'Invalid Filter: %s!', $Filter ),
        );
    }

    my $View = $ParamObject->GetParam( Param => 'View' ) || '';

    # lookup latest used view mode
    if ( !$View && $Self->{ 'UserTicketOverview' . $Self->{Action} } ) {
        $View = $Self->{ 'UserTicketOverview' . $Self->{Action} };
    }

    # otherwise use Preview as default as in LayoutTicket
    $View ||= 'Preview';

    # Check if selected view is available.
    my $Backends = $ConfigObject->Get('Ticket::Frontend::Overview');
    if ( !$Backends->{$View} ) {

        # Try to find fallback, take first configured view mode.
        KEY:
        for my $Key ( sort keys %{$Backends} ) {
            $View = $Key;
            last KEY;
        }
    }

    # get personal page shown count
    my $PageShownPreferencesKey = 'UserTicketOverview' . $View . 'PageShown';
    my $PageShown               = $Self->{$PageShownPreferencesKey} || 10;

    # do shown tickets lookup
    my $Limit = 10_000;

    my $ElementChanged = $ParamObject->GetParam( Param => 'ElementChanged' ) || '';
    my $HeaderColumn   = $ElementChanged;
    $HeaderColumn =~ s{\A ColumnFilter }{}msxg;

    # get data (viewable tickets...)
    # search all tickets
    my @ViewableTickets;
    my @OriginalViewableTickets;

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    if (@ViewableQueueIDs) {

        # get ticket values
        if (
            !IsStringWithData($HeaderColumn)
            || (
                IsStringWithData($HeaderColumn)
                && (
                    $ConfigObject->Get('OnlyValuesOnTicket') ||
                    $HeaderColumn eq 'CustomerID' ||
                    $HeaderColumn eq 'CustomerUserID'
                )
            )
            )
        {
            @OriginalViewableTickets = $TicketObject->TicketSearch(
                %{ $Filters{$Filter}->{Search} },
                Limit  => $Limit,
                Result => 'ARRAY',
            );

            my $Start = $ParamObject->GetParam( Param => 'StartHit' ) || 1;

            @ViewableTickets = $TicketObject->TicketSearch(
                %{ $Filters{$Filter}->{Search} },
                %ColumnFilter,
                Limit  => $Start + $PageShown - 1,
                Result => 'ARRAY',
            );
        }

    }

    if ( $Self->{Subaction} eq 'AJAXFilterUpdate' ) {

        my $FilterContent = $LayoutObject->TicketListShow(
            FilterContentOnly   => 1,
            HeaderColumn        => $HeaderColumn,
            ElementChanged      => $ElementChanged,
            OriginalTicketIDs   => \@OriginalViewableTickets,
            Action              => 'AgentTicketQueue',
            Env                 => $Self,
            View                => $View,
            EnableColumnFilters => 1,
            UseSubQueues        => $UseSubQueues,
        );

        if ( !$FilterContent ) {
            $LayoutObject->FatalError(
                Message => $LayoutObject->{LanguageObject}
                    ->Translate( 'Can\'t get filter content data of %s!', $HeaderColumn ),
            );
        }

        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
            Content     => $FilterContent,
            Type        => 'inline',
            NoCache     => 1,
        );
    }
    else {

        # store column filters
        my $StoredFilters = \%ColumnFilter;

        my $StoredFiltersKey = 'UserStoredFilterColumns-' . $Self->{Action};
        $UserObject->SetPreferences(
            UserID => $Self->{UserID},
            Key    => $StoredFiltersKey,
            Value  => $JSONObject->Encode( Data => $StoredFilters ),
        );
    }

    my $CountTotal = 0;
    my %NavBarFilter;
    for my $FilterColumn ( sort keys %Filters ) {
        my $Count = 0;
        if (@ViewableQueueIDs) {
            $Count = $TicketObject->TicketSearch(
                %{ $Filters{$FilterColumn}->{Search} },
                %ColumnFilter,
                Result => 'COUNT',
            ) || 0;
        }

        if ( $FilterColumn eq $Filter ) {
            $CountTotal = $Count;
        }

        $NavBarFilter{ $Filters{$FilterColumn}->{Prio} } = {
            Count  => $Count,
            Filter => $FilterColumn,
            %{ $Filters{$FilterColumn} },
        };
    }

    my $ColumnFilterLink = '';
    COLUMNNAME:
    for my $ColumnName ( sort keys %GetColumnFilter ) {
        next COLUMNNAME if !$ColumnName;
        next COLUMNNAME if !defined $GetColumnFilter{$ColumnName};
        next COLUMNNAME if $GetColumnFilter{$ColumnName} eq '';
        $ColumnFilterLink
            .= ';' . $LayoutObject->Ascii2Html( Text => 'ColumnFilter' . $ColumnName )
            . '=' . $LayoutObject->LinkEncode( $GetColumnFilter{$ColumnName} );
    }

    my $SubQueueLink = '';
    if ( !$Config->{UseSubQueues} && $UseSubQueues ) {
        $SubQueueLink = ';UseSubQueues=1';
    }
    elsif ( $Config->{UseSubQueues} && !$UseSubQueues ) {
        $SubQueueLink = ';UseSubQueues=0';
    }

    my $LinkPage = 'QueueID='
        . $LayoutObject->Ascii2Html( Text => $Self->{QueueID} )
        . ';Filter='
        . $LayoutObject->Ascii2Html( Text => $Filter )
        . ';View=' . $LayoutObject->Ascii2Html( Text => $View )
        . ';SortBy=' . $LayoutObject->Ascii2Html( Text => $SortBy )
        . ';OrderBy=' . $LayoutObject->Ascii2Html( Text => $OrderBy )
        . $SubQueueLink
        . $ColumnFilterLink
        . ';';

    my $LinkSort = 'QueueID='
        . $LayoutObject->Ascii2Html( Text => $Self->{QueueID} )
        . ';View=' . $LayoutObject->Ascii2Html( Text => $View )
        . ';Filter='
        . $LayoutObject->Ascii2Html( Text => $Filter )
        . $SubQueueLink
        . $ColumnFilterLink
        . ';';

    my $LinkFilter = 'QueueID='
        . $LayoutObject->Ascii2Html( Text => $Self->{QueueID} )
        . ';SortBy=' . $LayoutObject->Ascii2Html( Text => $SortBy )
        . ';OrderBy=' . $LayoutObject->Ascii2Html( Text => $OrderBy )
        . ';View=' . $LayoutObject->Ascii2Html( Text => $View )
        . $SubQueueLink
        . ';';

    my $LastColumnFilter = $ParamObject->GetParam( Param => 'LastColumnFilter' ) || '';

    if ( !$LastColumnFilter && $ColumnFilterLink ) {

        # is planned to have a link to go back here
        $LastColumnFilter = 1;
    }

    my %NavBar = $Self->BuildQueueView(
        QueueIDs     => \@ViewableQueueIDs,
        Filter       => $Filter,
        UseSubQueues => $UseSubQueues,
    );

    my $SubQueueIndicatorTitle = '';
    if ( !$Config->{UseSubQueues} && $UseSubQueues ) {
        $SubQueueIndicatorTitle = ' (' . $LayoutObject->{LanguageObject}->Translate('including subqueues') . ')';
    }
    elsif ( $Config->{UseSubQueues} && !$UseSubQueues ) {
        $SubQueueIndicatorTitle = ' (' . $LayoutObject->{LanguageObject}->Translate('excluding subqueues') . ')';
    }

    # show tickets
    $Output .= $LayoutObject->TicketListShow(
        Filter  => $Filter,
        Filters => \%NavBarFilter,

        DataInTheMiddle => $LayoutObject->Output(
            TemplateFile => 'AgentTicketQueue',
            Data         => \%NavBar,
        ),

        TicketIDs => \@ViewableTickets,

        OriginalTicketIDs => \@OriginalViewableTickets,
        GetColumnFilter   => \%GetColumnFilter,
        LastColumnFilter  => $LastColumnFilter,
        Action            => 'AgentTicketQueue',
        Total             => $CountTotal,
        RequestedURL      => $Self->{RequestedURL},

        NavBar => \%NavBar,
        View   => $View,

        Bulk       => 1,
        TitleName  => Translatable('QueueView'),
        TitleValue => $NavBar{SelectedQueue} . $SubQueueIndicatorTitle,

        Env        => $Self,
        LinkPage   => $LinkPage,
        LinkSort   => $LinkSort,
        LinkFilter => $LinkFilter,

        OrderBy             => $OrderBy,
        SortBy              => $SortBy,
        EnableColumnFilters => 1,
        ColumnFilterForm    => {
            QueueID => $Self->{QueueID} || '',
            Filter  => $Filter          || '',
        },
        UseSubQueues => $UseSubQueues,

        # do not print the result earlier, but return complete content
        Output => 1,
    );

    # get page footer
    $Output .= $LayoutObject->Footer() if $Self->{Subaction} ne 'AJAXFilterUpdate';
    return $Output;
}

sub BuildQueueView {
    my ( $Self, %Param ) = @_;

    my %Data = $Kernel::OM->Get('Kernel::System::Ticket')->TicketAcceleratorIndex(
        UserID        => $Self->{UserID},
        QueueID       => $Self->{QueueID},
        ShownQueueIDs => $Param{QueueIDs},
    );

    # build output ...
    my %AllQueues = $Kernel::OM->Get('Kernel::System::Queue')->QueueList( Valid => 0 );
    return $Self->_MaskQueueView(
        %Data,
        QueueID         => $Self->{QueueID},
        AllQueues       => \%AllQueues,
        ViewableTickets => $Self->{ViewableTickets},
        UseSubQueues    => $Param{UseSubQueues},
    );
}

sub _MaskQueueView {
    my ( $Self, %Param ) = @_;

    my $QueueID         = $Param{QueueID} || 0;
    my @QueuesNew       = @{ $Param{Queues} };
    my $QueueIDOfMaxAge = $Param{QueueIDOfMaxAge} || -1;
    my %AllQueues       = %{ $Param{AllQueues} };
    my %Counter;
    my %Totals;
    my $HaveTotals = 0;    # flag for "Total" in index backend
    my %UsedQueue;
    my @ListedQueues;
    my $Level        = 0;
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $CustomQueues = $ConfigObject->Get('Ticket::CustomQueue') || '???';
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $CustomQueue  = $LayoutObject->{LanguageObject}->Translate($CustomQueues);
    my $Config       = $ConfigObject->Get("Ticket::Frontend::$Self->{Action}");
    $Self->{HighlightAge1} = $Config->{HighlightAge1};
    $Self->{HighlightAge2} = $Config->{HighlightAge2};
    $Self->{Blink}         = $Config->{Blink};

    $Param{SelectedQueue} = $AllQueues{$QueueID} || $CustomQueue;
    my @MetaQueue = split /::/, $Param{SelectedQueue};
    $Level = $#MetaQueue + 2;

    # prepare shown queues (short names)
    # - get queue total count -
    for my $QueueRef (@QueuesNew) {
        push @ListedQueues, $QueueRef;
        my %Queue = %$QueueRef;
        my @Queue = split /::/, $Queue{Queue};
        $HaveTotals ||= exists $Queue{Total};

        # remember counted/used queues
        $UsedQueue{ $Queue{Queue} } = 1;

        # move to short queue names
        my $QueueName = '';
        for ( 0 .. $#Queue ) {
            if ( !$QueueName ) {
                $QueueName .= $Queue[$_];
            }
            else {
                $QueueName .= '::' . $Queue[$_];
            }
            if ( !exists $Counter{$QueueName} ) {
                $Counter{$QueueName} = 0;    # init
                $Totals{$QueueName}  = 0;
            }
            my $Total = $Queue{Total} || 0;
            $Counter{$QueueName} += $Queue{Count};
            $Totals{$QueueName}  += $Total;
            if (
                ( $Counter{$QueueName} || $Totals{$QueueName} )
                && !$Queue{$QueueName}
                && !$UsedQueue{$QueueName}
                )
            {
                # IMHO, this is purely pathological--TicketAcceleratorIndex
                # sorts queues by name, so we should never stumble across one
                # that we have not seen before!
                my %Hash = ();
                $Hash{Queue} = $QueueName;
                $Hash{Count} = $Counter{$QueueName};
                $Hash{Total} = $Total;
                for ( sort keys %AllQueues ) {
                    if ( $AllQueues{$_} eq $QueueName ) {
                        $Hash{QueueID} = $_;
                    }
                }
                $Hash{MaxAge} = 0;
                push( @ListedQueues, \%Hash );
                $UsedQueue{$QueueName} = 1;
            }
        }
    }

    # build queue string
    QUEUE:
    for my $QueueRef (@ListedQueues) {
        my $QueueStrg = '';
        my %Queue     = %$QueueRef;

        # replace name of CustomQueue
        if ( $Queue{Queue} eq 'CustomQueue' ) {
            $Counter{$CustomQueue} = $Counter{ $Queue{Queue} };
            $Totals{$CustomQueue}  = $Totals{ $Queue{Queue} };
            $Queue{Queue}          = $CustomQueue;
        }
        my @QueueName      = split /::/, $Queue{Queue};
        my $ShortQueueName = $QueueName[-1];
        $Queue{MaxAge}  = $Queue{MaxAge} / 60;
        $Queue{QueueID} = 0 if ( !$Queue{QueueID} );

        # skip empty Queues (or only locked tickets)
        if (
            # only check when setting is set
            $Config->{HideEmptyQueues}

            # empty or locked only
            && $Counter{ $Queue{Queue} } < 1

            # always show 'my queues'
            && $Queue{QueueID} != 0
            )
        {
            # TODO: check what 'Ticket::ViewableLocks' affects
            next QUEUE;
        }

        my $View   = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'View' )   || '';
        my $Filter = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'Filter' ) || 'Unlocked';

        $QueueStrg
            .= "<li><a href=\"$LayoutObject->{Baselink}Action=AgentTicketQueue;QueueID=$Queue{QueueID}";
        $QueueStrg .= ';View=' . $LayoutObject->Ascii2Html( Text => $View );
        $QueueStrg .= ';Filter=' . $LayoutObject->Ascii2Html( Text => $Filter );
        if ( $QueueID eq $Queue{QueueID} && $Config->{UseSubQueues} eq $Param{UseSubQueues} ) {
            $QueueStrg .= ';UseSubQueues=';
            $QueueStrg .= $Param{UseSubQueues} ? 0 : 1;
        }
        $QueueStrg .= '" class="';

        # Primary control is Visual Alarms and, if disabled, will turn off all highlights.
        # Secondary control highlights individual queues depending on age.
        if ( $Config->{VisualAlarms} ) {
            if ( $Queue{QueueID} == $QueueIDOfMaxAge && $Self->{Blink} ) {
                $QueueStrg .= 'Oldest';
            }
            elsif ( $Queue{MaxAge} >= $Self->{HighlightAge2} ) {
                $QueueStrg .= 'OlderLevel2';
            }
            elsif ( $Queue{MaxAge} >= $Self->{HighlightAge1} ) {
                $QueueStrg .= 'OlderLevel1';
            }
        }

        # display the current and all its lower levels in bold
        my $CheckQueueName;
        if (
            $Level > scalar @QueueName
            && scalar @MetaQueue >= scalar @QueueName
            && $Param{SelectedQueue} =~ m{ \A \Q$QueueName[0]\E }xms
            )
        {
            my $CheckLevel = 0;
            CHECKLEVEL:
            for ( $CheckLevel = 0; $CheckLevel < scalar @QueueName; ++$CheckLevel ) {
                if ($CheckQueueName) {
                    $CheckQueueName .= '::';
                }
                $CheckQueueName .= $MetaQueue[$CheckLevel];
            }
        }

        # should i display this queue in bold?
        if ( $CheckQueueName && $Queue{Queue} =~ m{ \A \Q$CheckQueueName\E \z }xms ) {
            $QueueStrg .= ' Active';
        }

        $QueueStrg .= '">';

        # remember to selected queue info
        if ( $QueueID eq $Queue{QueueID} ) {
            $Param{SelectedQueue} = $Queue{Queue};
            $Param{AllSubTickets} = $Counter{ $Queue{Queue} };
        }

        # QueueStrg
        $QueueStrg .= $LayoutObject->Ascii2Html( Text => $ShortQueueName );

        # If the index backend supports totals, we show total tickets
        # as well as unlocked ones in the form  "QueueName (total / unlocked)"
        if ( $HaveTotals && ( $Totals{ $Queue{Queue} } != $Counter{ $Queue{Queue} } ) ) {
            $QueueStrg .= " ($Totals{$Queue{Queue}}/$Counter{$Queue{Queue}})";
        }
        else {
            $QueueStrg .= " ($Counter{$Queue{Queue}})";
        }

        $QueueStrg .= '</a></li>';

        if ( scalar @QueueName eq 1 ) {
            $Param{QueueStrg} .= $QueueStrg;
        }
        elsif ( $Level >= scalar @QueueName ) {
            my $CheckQueueStrgName = '';
            for ( my $LevelCount = 0; $LevelCount < scalar @QueueName - 1; ++$LevelCount ) {
                $CheckQueueStrgName .= $MetaQueue[$LevelCount] . '::';
            }
            if ( $Queue{Queue} =~ m{ \A \Q$CheckQueueStrgName\E }xms ) {

                $Param{ 'QueueStrg' . scalar @QueueName - 1 } .= $QueueStrg;
            }
        }
    }

    my $Counter = 0;
    KEYS:
    for my $Keys ( sort keys %Param ) {
        if ( $Keys !~ /^QueueStrg/ ) {
            next KEYS;
        }
        my $Class = $Counter;
        if ( $Counter > 10 ) {
            $Class = 'X';
        }

        $Param{QueueStrgLevel}
            .= '<ul class="QueueOverviewList Level_' . $Class . '">' . $Param{$Keys} . '</ul>';
        $Counter++;
    }

    return (
        MainName      => 'Queues',
        SelectedQueue => $Param{SelectedQueue},
        MainContent   => $Param{QueueStrgLevel},
        Total         => $Param{TicketsShown},
    );
}

1;
