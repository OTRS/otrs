# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentTicketService;

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
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');

    # check if feature is active
    my $Access = $ConfigObject->Get('Ticket::Service');

    if ( !$Access ) {
        $LayoutObject->FatalError(
            Message => Translatable('Feature not enabled!'),
        );
    }

    # get config param
    my $Config = $ConfigObject->Get("Ticket::Frontend::$Self->{Action}");

    my $SortBy = $ParamObject->GetParam( Param => 'SortBy' )
        || $Config->{'SortBy::Default'}
        || 'Age';
    my $OrderBy = $ParamObject->GetParam( Param => 'OrderBy' )
        || $Config->{'Order::Default'}
        || 'Up';

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

    # get service param
    my $ServiceID = $ParamObject->GetParam( Param => 'ServiceID' ) || 0;

    # if we have only one service, check if there
    # is a setting in Config.pm for sorting
    if ( !$OrderBy ) {
        if ( $Config->{ServiceSort} ) {
            if ( defined $Config->{ServiceSort}->{$ServiceID} ) {
                if ( $Config->{ServiceSort}->{$ServiceID} ) {
                    $OrderBy = 'Down';
                }
                else {
                    $OrderBy = 'Up';
                }
            }
        }
    }
    if ( !$OrderBy ) {
        $OrderBy = $Config->{'Order::Default'} || 'Up';
    }

    # build NavigationBar & to get the output faster!
    my $Refresh = '';
    if ( $Self->{UserRefreshTime} ) {
        $Refresh = 60 * $Self->{UserRefreshTime};
    }

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

    # get all queues the agent is allowed to see
    my %ViewableQueues = $Kernel::OM->Get('Kernel::System::Queue')->GetAllQueues(
        UserID => $Self->{UserID},
        Type   => 'ro',
    );
    my @ViewableQueueIDs = sort keys %ViewableQueues;

    # get service object
    my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');

    # get custom services
    my @MyServiceIDs = $ServiceObject->GetAllCustomServices( UserID => $Self->{UserID} );

    my @ViewableServiceIDs;
    if ( !$ServiceID ) {
        @ViewableServiceIDs = @MyServiceIDs;
    }
    else {
        @ViewableServiceIDs = ($ServiceID);
    }

    my %Filters = (
        All => {
            Name   => Translatable('All tickets'),
            Prio   => 1000,
            Search => {
                StateIDs   => \@ViewableStateIDs,
                QueueIDs   => \@ViewableQueueIDs,
                ServiceIDs => \@ViewableServiceIDs,
                %Sort,
                Permission => $Permission,
                UserID     => $Self->{UserID},
            },
        },
        Unlocked => {
            Name   => Translatable('Available tickets'),
            Prio   => 1001,
            Search => {
                LockIDs    => \@ViewableLockIDs,
                StateIDs   => \@ViewableStateIDs,
                QueueIDs   => \@ViewableQueueIDs,
                ServiceIDs => \@ViewableServiceIDs,
                %Sort,
                Permission => $Permission,
                UserID     => $Self->{UserID},
            },
        },
    );

    # get filter param
    my $Filter = $ParamObject->GetParam( Param => 'Filter' ) || 'Unlocked';

    # check if filter is valid
    if ( !$Filters{$Filter} ) {
        $LayoutObject->FatalError(
            Message => $LayoutObject->{LanguageObject}->Translate( 'Invalid Filter: %s!', $Filter ),
        );
    }

    # get view param
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

    if ( @ViewableQueueIDs && @ViewableServiceIDs ) {

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

            # get start param
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
            Action              => 'AgentTicketService',
            Env                 => $Self,
            View                => $View,
            EnableColumnFilters => 1,
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
        if ( @ViewableQueueIDs && @ViewableServiceIDs ) {
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

    my $LinkPage = 'ServiceID='
        . $LayoutObject->Ascii2Html( Text => $ServiceID )
        . ';Filter='
        . $LayoutObject->Ascii2Html( Text => $Filter )
        . ';View=' . $LayoutObject->Ascii2Html( Text => $View )
        . ';SortBy=' . $LayoutObject->Ascii2Html( Text => $SortBy )
        . ';OrderBy=' . $LayoutObject->Ascii2Html( Text => $OrderBy )
        . $ColumnFilterLink
        . ';';
    my $LinkSort = 'ServiceID='
        . $LayoutObject->Ascii2Html( Text => $ServiceID )
        . ';View=' . $LayoutObject->Ascii2Html( Text => $View )
        . ';Filter='
        . $LayoutObject->Ascii2Html( Text => $Filter )
        . $ColumnFilterLink
        . ';';

    my $LinkFilter = 'ServiceID='
        . $LayoutObject->Ascii2Html( Text => $ServiceID )
        . ';SortBy=' . $LayoutObject->Ascii2Html( Text => $SortBy )
        . ';OrderBy=' . $LayoutObject->Ascii2Html( Text => $OrderBy )
        . ';View=' . $LayoutObject->Ascii2Html( Text => $View )
        . ';';

    # get all services
    my %AllServices = $ServiceObject->ServiceList(
        Valid  => 0,
        UserID => $Self->{UserID},
    );

    # store the ticket count data for each service
    my %Data;

    my $Count = 0;

    # get the agent custom services count
    if (@MyServiceIDs) {

        $Count = $TicketObject->TicketSearch(
            LockIDs    => \@ViewableLockIDs,
            StateIDs   => \@ViewableStateIDs,
            QueueIDs   => \@ViewableQueueIDs,
            ServiceIDs => \@MyServiceIDs,
            Permission => $Permission,
            UserID     => $Self->{UserID},
            Result     => 'COUNT',
        ) || 0;
    }

    # add the count for the custom services
    push @{ $Data{Services} }, {
        Count     => $Count,
        Service   => 'CustomService',
        ServiceID => 0,
    };

    # remember the number shown tickets for the custom services
    $Data{TicketsShown} = $Count || 0;

    # Get ticket count for all services.
    my @ServiceIDs           = sort { $AllServices{$a} cmp $AllServices{$b} } keys %AllServices;
    my @AllServicesTicketIDs = $TicketObject->TicketSearch(
        LockIDs    => \@ViewableLockIDs,
        StateIDs   => \@ViewableStateIDs,
        QueueIDs   => \@ViewableQueueIDs,
        ServiceIDs => \@ServiceIDs,
        Permission => $Permission,
        UserID     => $Self->{UserID},
        Limit      => 20_000,
        Result     => 'ARRAY',
    );

    my $TicketCountByServiceID = $TicketObject->TicketCountByAttribute(
        Attribute => 'ServiceID',
        TicketIDs => \@AllServicesTicketIDs,
    );

    SERVICEID:
    for my $ServiceIDItem (@ServiceIDs) {
        my $ServiceIDCount = $TicketCountByServiceID->{$ServiceIDItem};

        next SERVICEID if !$ServiceIDCount;

        push @{ $Data{Services} }, {
            Count     => $ServiceIDCount,
            Service   => $AllServices{$ServiceIDItem},
            ServiceID => $ServiceIDItem,
        };

        # Remember the number of shown tickets for the selected service.
        next SERVICEID if !$ServiceID;
        next SERVICEID if $ServiceID ne $ServiceIDItem;

        $Data{TicketsShown} = $ServiceIDCount;
    }

    my $LastColumnFilter = $ParamObject->GetParam( Param => 'LastColumnFilter' ) || '';

    if ( !$LastColumnFilter && $ColumnFilterLink ) {

        # is planned to have a link to go back here
        $LastColumnFilter = 1;
    }

    my %NavBar = $Self->_MaskServiceView(
        %Data,
        ServiceID   => $ServiceID,
        AllServices => \%AllServices,
    );

    # show tickets
    $Output .= $LayoutObject->TicketListShow(
        Filter  => $Filter,
        Filters => \%NavBarFilter,

        DataInTheMiddle => $LayoutObject->Output(
            TemplateFile => 'AgentTicketService',
            Data         => \%NavBar,
        ),

        TicketIDs => \@ViewableTickets,

        OriginalTicketIDs => \@OriginalViewableTickets,
        GetColumnFilter   => \%GetColumnFilter,
        LastColumnFilter  => $LastColumnFilter,
        Action            => 'AgentTicketService',
        Total             => $CountTotal,
        RequestedURL      => $Self->{RequestedURL},

        NavBar => \%NavBar,
        View   => $View,

        Bulk       => 1,
        TitleName  => Translatable('Service View'),
        TitleValue => $NavBar{SelectedService},

        Env        => $Self,
        LinkPage   => $LinkPage,
        LinkSort   => $LinkSort,
        LinkFilter => $LinkFilter,

        OrderBy             => $OrderBy,
        SortBy              => $SortBy,
        EnableColumnFilters => 1,
        ColumnFilterForm    => {
            ServiceID => $ServiceID || '',
            Filter    => $Filter    || '',
        },

        # do not print the result earlier, but return complete content
        Output => 1,
    );

    # get page footer
    $Output .= $LayoutObject->Footer() if $Self->{Subaction} ne 'AJAXFilterUpdate';
    return $Output;
}

sub _MaskServiceView {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $CustomService
        = $LayoutObject->{LanguageObject}->Translate( $ConfigObject->Get('Ticket::CustomService') || 'My Services' );
    my $Config = $ConfigObject->Get("Ticket::Frontend::$Self->{Action}");

    my $ServiceID   = $Param{ServiceID} || 0;
    my @ServicesNew = @{ $Param{Services} };
    my %AllServices = %{ $Param{AllServices} };
    my %Counter;
    my %UsedService;
    my @ListedServices;
    my $Level = 0;

    $Self->{HighlightAge1} = $Config->{HighlightAge1};
    $Self->{HighlightAge2} = $Config->{HighlightAge2};
    $Self->{Blink}         = $Config->{Blink};

    $Param{SelectedService} = $AllServices{$ServiceID} || $CustomService;
    my @MetaService = split /::/, $Param{SelectedService};
    $Level = $#MetaService + 2;

    # prepare shown Services (short names)
    # - get Service total count -
    for my $ServiceRef (@ServicesNew) {
        push @ListedServices, $ServiceRef;
        my %Service = %$ServiceRef;
        my @Service = split /::/, $Service{Service};

        # remember counted/used Services
        $UsedService{ $Service{Service} } = 1;

        # move to short Service names
        my $ServiceName = '';
        for my $Index ( 0 .. $#Service ) {
            if ( !$ServiceName ) {
                $ServiceName .= $Service[$Index];
            }
            else {
                $ServiceName .= '::' . $Service[$Index];
            }
            if ( !$Counter{$ServiceName} ) {
                $Counter{$ServiceName} = 0;
            }
            $Counter{$ServiceName} = $Counter{$ServiceName} + $Service{Count};
            if ( $Counter{$ServiceName} && !$Service{$ServiceName} && !$UsedService{$ServiceName} )
            {
                my %Hash;
                $Hash{Service} = $ServiceName;
                $Hash{Count}   = $Counter{$ServiceName};
                for my $ServiceID ( sort keys %AllServices ) {
                    if ( $AllServices{$ServiceID} eq $ServiceName ) {
                        $Hash{ServiceID} = $ServiceID;
                    }
                }

                push @ListedServices, \%Hash;
                $UsedService{$ServiceName} = 1;
            }
        }
    }

    # build Service string
    for my $ServiceRef (@ListedServices) {
        my $ServiceStrg = '';
        my %Service     = %$ServiceRef;

        # replace name of CustomService
        if ( $Service{Service} eq 'CustomService' ) {
            $Counter{$CustomService} = $Counter{ $Service{Service} };
            $Service{Service} = $CustomService;
        }
        my @ServiceName      = split /::/, $Service{Service};
        my $ShortServiceName = $ServiceName[-1];
        $Service{ServiceID} = 0 if ( !$Service{ServiceID} );

        # get view param
        my $View = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'View' ) || '';

        $ServiceStrg
            .= "<li><a href=\"$LayoutObject->{Baselink}Action=AgentTicketService;ServiceID=$Service{ServiceID}";
        $ServiceStrg .= ';View=' . $LayoutObject->Ascii2Html( Text => $View ) . '"';

        $ServiceStrg .= ' class="';

        # should i highlight this Service
        if ( $Param{SelectedService} =~ /^\Q$ServiceName[0]\E/ && $Level - 1 >= $#ServiceName ) {
            if (
                $#ServiceName == 0
                && $#MetaService >= 0
                && $Service{Service} =~ /^\Q$MetaService[0]\E$/
                )
            {
                $ServiceStrg .= ' Active';
            }
            if (
                $#ServiceName == 1
                && $#MetaService >= 1
                && $Service{Service} =~ /^\Q$MetaService[0]::$MetaService[1]\E$/
                )
            {
                $ServiceStrg .= ' Active';
            }
            if (
                $#ServiceName == 2
                && $#MetaService >= 2
                && $Service{Service} =~ /^\Q$MetaService[0]::$MetaService[1]::$MetaService[2]\E$/
                )
            {
                $ServiceStrg .= ' Active';
            }
            if (
                $#ServiceName == 3
                && $#MetaService >= 3
                && $Service{Service}
                =~ /^\Q$MetaService[0]::$MetaService[1]::$MetaService[2]::$MetaService[3]\E$/
                )
            {
                $ServiceStrg .= ' Active';
            }
        }

        $ServiceStrg .= '">';

        # remember to selected Service info
        if ( $ServiceID eq $Service{ServiceID} ) {
            $Param{SelectedService} = $Service{Service};
            $Param{AllSubTickets}   = $Counter{ $Service{Service} };
        }

        # ServiceStrg
        $ServiceStrg .= $LayoutObject->Ascii2Html( Text => $ShortServiceName )
            . " ($Counter{$Service{Service}})";

        $ServiceStrg .= '</a></li>';

        if ( $#ServiceName == 0 ) {
            $Param{ServiceStrg1} .= $ServiceStrg;
        }
        elsif ( $#ServiceName == 1 && $Level >= 2 && $Service{Service} =~ /^\Q$MetaService[0]::\E/ )
        {
            $Param{ServiceStrg2} .= $ServiceStrg;
        }
        elsif (
            $#ServiceName == 2
            && $Level >= 3
            && $Service{Service} =~ /^\Q$MetaService[0]::$MetaService[1]::\E/
            )
        {
            $Param{ServiceStrg3} .= $ServiceStrg;
        }
        elsif (
            $#ServiceName == 3
            && $Level >= 4
            && $Service{Service} =~ /^\Q$MetaService[0]::$MetaService[1]::$MetaService[2]::\E/
            )
        {
            $Param{ServiceStrg4} .= $ServiceStrg;
        }
        elsif (
            $#ServiceName == 4
            && $Level >= 5
            && $Service{Service}
            =~ /^\Q$MetaService[0]::$MetaService[1]::$MetaService[2]::$MetaService[3]::\E/
            )
        {
            $Param{ServiceStrg5} .= $ServiceStrg;
        }
    }

    LEVEL:
    for my $Level ( 1 .. 5 ) {
        next LEVEL if !$Param{ 'ServiceStrg' . $Level };
        $Param{ServiceStrg}
            .= '<ul class="ServiceOverviewList Level_' . $Level . '">' . $Param{ 'ServiceStrg' . $Level } . '</ul>';
    }

    return (
        MainName        => 'Services',
        SelectedService => $Param{SelectedService},
        MainContent     => $Param{ServiceStrg},
        Total           => $Param{TicketsShown},
    );
}

1;
