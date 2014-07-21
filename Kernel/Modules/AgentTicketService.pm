# --
# Kernel/Modules/AgentTicketService.pm - the service view of all tickets
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketService;

use strict;
use warnings;

use Kernel::System::DynamicField;
use Kernel::System::JSON;
use Kernel::System::Lock;
use Kernel::System::Service;
use Kernel::System::State;

use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # set debug
    $Self->{Debug} = 0;

    # check all needed objects
    for my $Needed (
        qw(ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject UserObject)
        )
    {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
        }
    }

    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    # some new objects
    $Self->{JSONObject}         = Kernel::System::JSON->new( %{$Self} );
    $Self->{StateObject}        = Kernel::System::State->new(%Param);
    $Self->{LockObject}         = Kernel::System::Lock->new(%Param);
    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new(%Param);
    $Self->{ServiceObject}      = Kernel::System::Service->new(%Param);

    # get config data
    $Self->{CustomService} = $Self->{ConfigObject}->Get('Ticket::CustomService') || 'My Services';

    # get params
    $Self->{ViewAll}   = $Self->{ParamObject}->GetParam( Param => 'ViewAll' )   || 0;
    $Self->{Start}     = $Self->{ParamObject}->GetParam( Param => 'StartHit' )  || 1;
    $Self->{Filter}    = $Self->{ParamObject}->GetParam( Param => 'Filter' )    || 'Unlocked';
    $Self->{View}      = $Self->{ParamObject}->GetParam( Param => 'View' )      || '';
    $Self->{ServiceID} = $Self->{ParamObject}->GetParam( Param => 'ServiceID' ) || 0;

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check if feature is active
    my $Access = $Self->{ConfigObject}->Get('Ticket::Service');

    if ( !$Access ) {
        $Self->{LayoutObject}->FatalError( Message => 'Feature not enabled!' );
    }

    my $SortBy = $Self->{ParamObject}->GetParam( Param => 'SortBy' )
        || $Self->{Config}->{'SortBy::Default'}
        || 'Age';
    my $OrderBy = $Self->{ParamObject}->GetParam( Param => 'OrderBy' )
        || $Self->{Config}->{'Order::Default'}
        || 'Up';

    # store last queue screen
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenOverview',
        Value     => $Self->{RequestedURL},
    );

    # store last screen
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenView',
        Value     => $Self->{RequestedURL},
    );

    # get filters stored in the user preferences
    my %Preferences = $Self->{UserObject}->GetPreferences(
        UserID => $Self->{UserID},
    );
    my $StoredFiltersKey = 'UserStoredFilterColumns-' . $Self->{Action};
    my $StoredFilters    = $Self->{JSONObject}->Decode(
        Data => $Preferences{$StoredFiltersKey},
    );

    # delete stored filters if needed
    if ( $Self->{ParamObject}->GetParam( Param => 'DeleteFilters' ) ) {
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
        my $FilterValue = $Self->{ParamObject}->GetParam( Param => 'ColumnFilter' . $ColumnName )
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
            $GetColumnFilter{$ColumnName} = $FilterValue;
        }
        elsif ( $ColumnName eq 'CustomerUserID' ) {
            push @{ $ColumnFilter{CustomerUserLogin} }, $FilterValue;
            $GetColumnFilter{$ColumnName} = $FilterValue;
        }
        else {
            push @{ $ColumnFilter{ $ColumnName . 'IDs' } }, $FilterValue;
            $GetColumnFilter{$ColumnName} = $FilterValue;
        }
    }

    # get all dynamic fields
    $Self->{DynamicField} = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => ['Ticket'],
    );

    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
        next DYNAMICFIELD if !$DynamicFieldConfig->{Name};

        # get filter from web request
        my $FilterValue = $Self->{ParamObject}->GetParam(
            Param => 'ColumnFilterDynamicField_' . $DynamicFieldConfig->{Name}
        );

        # if no filter from web request, try from user preferences
        if ( !defined $FilterValue || $FilterValue eq '' ) {
            $FilterValue
                = $StoredFilters->{ 'DynamicField_' . $DynamicFieldConfig->{Name} }->{Equals};
        }

        next DYNAMICFIELD if !defined $FilterValue;
        next DYNAMICFIELD if $FilterValue eq '';
        next DYNAMICFIELD if $FilterValue eq 'DeleteFilter';

        $ColumnFilter{ 'DynamicField_' . $DynamicFieldConfig->{Name} } = {
            Equals => $FilterValue,
        };
        $GetColumnFilter{ 'DynamicField_' . $DynamicFieldConfig->{Name} } = $FilterValue;
    }

    # if we have only one service, check if there
    # is a setting in Config.pm for sorting
    if ( !$OrderBy ) {
        if ( $Self->{Config}->{ServiceSort} ) {
            if ( defined $Self->{Config}->{ServiceSort}->{ $Self->{ServiceID} } ) {
                if ( $Self->{Config}->{ServiceSort}->{ $Self->{ServiceID} } ) {
                    $OrderBy = 'Down';
                }
                else {
                    $OrderBy = 'Up';
                }
            }
        }
    }
    if ( !$OrderBy ) {
        $OrderBy = $Self->{Config}->{'Order::Default'} || 'Up';
    }

    # build NavigationBar & to get the output faster!
    my $Refresh = '';
    if ( $Self->{UserRefreshTime} ) {
        $Refresh = 60 * $Self->{UserRefreshTime};
    }

    my $Output;
    if ( $Self->{Subaction} ne 'AJAXFilterUpdate' ) {
        $Output = $Self->{LayoutObject}->Header( Refresh => $Refresh, );
        $Output .= $Self->{LayoutObject}->NavigationBar();
    }

    # viewable locks
    my @ViewableLockIDs = $Self->{LockObject}->LockViewableLock( Type => 'ID' );

    # viewable states
    my @ViewableStateIDs = $Self->{StateObject}->StateGetStatesByType(
        Type   => 'Viewable',
        Result => 'ID',
    );

    # get permissions
    my $Permission = 'rw';
    if ( $Self->{Config}->{ViewAllPossibleTickets} ) {
        $Permission = 'ro';
    }

    # sort on default by using both (Priority, Age) else use only one sort argument
    my %Sort;

    # get if search result should be pre-sorted by priority
    my $PreSortByPriority = $Self->{Config}->{'PreSort::ByPriority'};
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
    my %ViewableQueues = $Self->{QueueObject}->GetAllQueues(
        UserID => $Self->{UserID},
        Type   => 'ro',
    );
    my @ViewableQueueIDs = sort keys %ViewableQueues;

    # get custom services
    my @MyServiceIDs = $Self->{ServiceObject}->GetAllCustomServices( UserID => $Self->{UserID} );

    my @ViewableServiceIDs;
    if ( !$Self->{ServiceID} ) {
        @ViewableServiceIDs = @MyServiceIDs;
    }
    else {
        @ViewableServiceIDs = ( $Self->{ServiceID} );
    }

    my %Filters = (
        All => {
            Name   => 'All tickets',
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
            Name   => 'Available tickets',
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

    # check if filter is valid
    if ( !$Filters{ $Self->{Filter} } ) {
        $Self->{LayoutObject}->FatalError( Message => "Invalid Filter: $Self->{Filter}!" );
    }

    # lookup latest used view mode
    if ( !$Self->{View} && $Self->{ 'UserTicketOverview' . $Self->{Action} } ) {
        $Self->{View} = $Self->{ 'UserTicketOverview' . $Self->{Action} };
    }

    # otherwise use Preview as default as in LayoutTicket
    $Self->{View} ||= 'Preview';

    # get personal page shown count
    my $PageShownPreferencesKey = 'UserTicketOverview' . $Self->{View} . 'PageShown';
    my $PageShown = $Self->{$PageShownPreferencesKey} || 10;

    # do shown tickets lookup
    my $Limit = 10_000;

    my $ElementChanged = $Self->{ParamObject}->GetParam( Param => 'ElementChanged' ) || '';
    my $HeaderColumn = $ElementChanged;
    $HeaderColumn =~ s{\A ColumnFilter }{}msxg;

    # get data (viewable tickets...)
    # search all tickets
    my @ViewableTickets;
    my @OriginalViewableTickets;

    if ( @ViewableQueueIDs && @ViewableServiceIDs ) {

        # get ticket values
        if (
            !IsStringWithData($HeaderColumn)
            || (
                IsStringWithData($HeaderColumn)
                && (
                    $Self->{ConfigObject}->Get('OnlyValuesOnTicket') ||
                    $HeaderColumn eq 'CustomerID' ||
                    $HeaderColumn eq 'CustomerUserID'
                )
            )
            )
        {
            @OriginalViewableTickets = $Self->{TicketObject}->TicketSearch(
                %{ $Filters{ $Self->{Filter} }->{Search} },
                Limit  => $Limit,
                Result => 'ARRAY',
            );

            @ViewableTickets = $Self->{TicketObject}->TicketSearch(
                %{ $Filters{ $Self->{Filter} }->{Search} },
                %ColumnFilter,
                Limit  => $Self->{Start} + $PageShown - 1,
                Result => 'ARRAY',
            );
        }

    }

    if ( $Self->{Subaction} eq 'AJAXFilterUpdate' ) {

        my $FilterContent = $Self->{LayoutObject}->TicketListShow(
            FilterContentOnly   => 1,
            HeaderColumn        => $HeaderColumn,
            ElementChanged      => $ElementChanged,
            OriginalTicketIDs   => \@OriginalViewableTickets,
            Action              => 'AgentTicketService',
            Env                 => $Self,
            View                => $Self->{View},
            EnableColumnFilters => 1,
        );

        if ( !$FilterContent ) {
            $Self->{LayoutObject}->FatalError(
                Message => "Can't get filter content data of $HeaderColumn!",
            );
        }

        return $Self->{LayoutObject}->Attachment(
            ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $FilterContent,
            Type        => 'inline',
            NoCache     => 1,
        );
    }
    else {

        # store column filters
        my $StoredFilters = \%ColumnFilter;

        my $StoredFiltersKey = 'UserStoredFilterColumns-' . $Self->{Action};
        $Self->{UserObject}->SetPreferences(
            UserID => $Self->{UserID},
            Key    => $StoredFiltersKey,
            Value  => $Self->{JSONObject}->Encode( Data => $StoredFilters ),
        );
    }

    my $CountTotal = 0;
    my %NavBarFilter;
    for my $Filter ( sort keys %Filters ) {
        my $Count = 0;
        if ( @ViewableQueueIDs && @ViewableServiceIDs ) {
            $Count = $Self->{TicketObject}->TicketSearch(
                %{ $Filters{$Filter}->{Search} },
                %ColumnFilter,
                Result => 'COUNT',
            );
        }

        if ( $Filter eq $Self->{Filter} ) {
            $CountTotal = $Count;
        }

        $NavBarFilter{ $Filters{$Filter}->{Prio} } = {
            Count  => $Count,
            Filter => $Filter,
            %{ $Filters{$Filter} },
        };
    }

    my $ColumnFilterLink = '';
    COLUMNNAME:
    for my $ColumnName ( sort keys %GetColumnFilter ) {
        next COLUMNNAME if !$ColumnName;
        next COLUMNNAME if !defined $GetColumnFilter{$ColumnName};
        next COLUMNNAME if $GetColumnFilter{$ColumnName} eq '';
        $ColumnFilterLink
            .= ';' . $Self->{LayoutObject}->Ascii2Html( Text => 'ColumnFilter' . $ColumnName )
            . '=' . $Self->{LayoutObject}->Ascii2Html( Text => $GetColumnFilter{$ColumnName} )
    }

    my $LinkPage = 'ServiceID='
        . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{ServiceID} )
        . ';Filter='
        . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Filter} )
        . ';View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
        . ';SortBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $SortBy )
        . ';OrderBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $OrderBy )
        . $ColumnFilterLink
        . ';';
    my $LinkSort = 'ServiceID='
        . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{ServiceID} )
        . ';View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
        . ';Filter='
        . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Filter} )
        . $ColumnFilterLink
        . ';';

    my $LinkFilter = 'ServiceID='
        . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{ServiceID} )
        . ';SortBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $SortBy )
        . ';OrderBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $OrderBy )
        . ';View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
        . ';';

    # get all services
    my %AllServices = $Self->{ServiceObject}->ServiceList(
        Valid  => 1,
        UserID => $Self->{UserID},
    );

    # store the ticket count data for each service
    my %Data;

    my $Count = 0;

    # get the agent custom services count
    if (@MyServiceIDs) {

        $Count = $Self->{TicketObject}->TicketSearch(
            LockIDs    => \@ViewableLockIDs,
            StateIDs   => \@ViewableStateIDs,
            QueueIDs   => \@ViewableQueueIDs,
            ServiceIDs => \@MyServiceIDs,
            Permission => $Permission,
            UserID     => $Self->{UserID},
            Result     => 'COUNT',
        );
    }

    # add the count for the custom services
    push @{ $Data{Services} }, {
        Count     => $Count,
        Service   => 'CustomService',
        ServiceID => 0,
    };

    # remember the number shown tickets for the custom services
    $Data{TicketsShown} = $Count || 0;

    SERVICEID:
    for my $ServiceID ( sort { $AllServices{$a} cmp $AllServices{$b} } keys %AllServices ) {

        $Count = $Self->{TicketObject}->TicketSearch(
            LockIDs    => \@ViewableLockIDs,
            StateIDs   => \@ViewableStateIDs,
            QueueIDs   => \@ViewableQueueIDs,
            ServiceIDs => [$ServiceID],
            Permission => $Permission,
            UserID     => $Self->{UserID},
            Result     => 'COUNT',
        );

        next SERVICEID if !$Count;

        push @{ $Data{Services} }, {
            Count     => $Count,
            Service   => $AllServices{$ServiceID},
            ServiceID => $ServiceID,
        };

        # remember the number shown tickets for the selected service
        if ( $Self->{ServiceID} && $Self->{ServiceID} eq $ServiceID ) {
            $Data{TicketsShown} = $Count || 0;
        }
    }

    my $LastColumnFilter = $Self->{ParamObject}->GetParam( Param => 'LastColumnFilter' ) || '';

    if ( !$LastColumnFilter && $ColumnFilterLink ) {

        # is planned to have a link to go back here
        $LastColumnFilter = 1;
    }

    my %NavBar = $Self->_MaskServiceView(
        %Data,
        ServiceID   => $Self->{ServiceID},
        AllServices => \%AllServices,
    );

    # show tickets
    $Output .= $Self->{LayoutObject}->TicketListShow(
        Filter     => $Self->{Filter},
        Filters    => \%NavBarFilter,
        FilterLink => $LinkFilter,

        DataInTheMiddle => $Self->{LayoutObject}->Output(
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
        View   => $Self->{View},

        Bulk       => 1,
        TitleName  => 'ServiceView',
        TitleValue => $NavBar{SelectedService},

        Env        => $Self,
        LinkPage   => $LinkPage,
        LinkSort   => $LinkSort,
        LinkFilter => $LinkFilter,

        OrderBy             => $OrderBy,
        SortBy              => $SortBy,
        EnableColumnFilters => 1,
        ColumnFilterForm    => {
            ServiceID => $Self->{ServiceID} || '',
            Filter    => $Self->{Filter}    || '',
        },

        # do not print the result earlier, but return complete content
        Output => 1,
    );

    # get page footer
    $Output .= $Self->{LayoutObject}->Footer() if $Self->{Subaction} ne 'AJAXFilterUpdate';
    return $Output;
}

sub _MaskServiceView {
    my ( $Self, %Param ) = @_;

    my $ServiceID = $Param{ServiceID} || 0;
    my @ServicesNew = @{ $Param{Services} };

    my %AllServices = %{ $Param{AllServices} };
    my %Counter;
    my %UsedService;
    my @ListedServices;
    my $Level = 0;
    my $CustomService
        = $Self->{LayoutObject}->{LanguageObject}->Translate( $Self->{CustomService} );
    $Self->{HighlightAge1} = $Self->{Config}->{HighlightAge1};
    $Self->{HighlightAge2} = $Self->{Config}->{HighlightAge2};
    $Self->{Blink}         = $Self->{Config}->{Blink};

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
        my @ServiceName = split /::/, $Service{Service};
        my $ShortServiceName = $ServiceName[-1];
        $Service{ServiceID} = 0 if ( !$Service{ServiceID} );

        $ServiceStrg
            .= "<li><a href=\"$Self->{LayoutObject}->{Baselink}Action=AgentTicketService;ServiceID=$Service{ServiceID}";
        $ServiceStrg .= ';View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} ) . '"';

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
        $ServiceStrg .= $Self->{LayoutObject}->Ascii2Html( Text => $ShortServiceName )
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
            .= '<ul class="ServiceOverviewList">' . $Param{ 'ServiceStrg' . $Level } . '</ul>';
    }

    return (
        MainName        => 'Services',
        SelectedService => $Param{SelectedService},
        MainContent     => $Param{ServiceStrg},
        Total           => $Param{TicketsShown},
    );
}

1;
