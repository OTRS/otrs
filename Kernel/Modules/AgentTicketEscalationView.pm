# --
# Kernel/Modules/AgentTicketEscalationView.pm - status for all open tickets
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketEscalationView;

use strict;
use warnings;

use Kernel::System::JSON;
use Kernel::System::DynamicField;
use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject UserObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    # create additional objects
    $Self->{JSONObject}         = Kernel::System::JSON->new( %{$Self} );
    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new(%Param);

    # get params
    $Self->{SortBy} = $Self->{ParamObject}->GetParam( Param => 'SortBy' )
        || $Self->{Config}->{'SortBy::Default'}
        || 'EscalationTime';
    $Self->{OrderBy} = $Self->{ParamObject}->GetParam( Param => 'OrderBy' )
        || $Self->{Config}->{'Order::Default'}
        || 'Up';

    # viewable tickets a page
    $Self->{Limit} = $Self->{ParamObject}->GetParam( Param => 'Limit' ) || 2000;

    $Self->{Filter} = $Self->{ParamObject}->GetParam( Param => 'Filter' ) || 'Today';
    $Self->{View}   = $Self->{ParamObject}->GetParam( Param => 'View' )   || '';

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

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

    # get the column filters from the web request
    my %ColumnFilter;
    my %GetColumnFilter;
    COLUMNNAME:
    for my $ColumnName (
        qw(Owner Responsible State Queue Priority Type Lock Service SLA CustomerID CustomerUserID)
        )
    {
        my $FilterValue = $Self->{ParamObject}->GetParam( Param => 'ColumnFilter' . $ColumnName )
            || '';
        next COLUMNNAME if $FilterValue eq '';

        if (
            $FilterValue eq 'DeleteFilter'
            && (
                $ColumnName eq 'CustomerID'
                || $ColumnName eq 'CustomerUserID'
                || $ColumnName eq 'Owner'
                || $ColumnName eq 'Responsible'
            )
            )
        {
            next COLUMNNAME;
        }

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

        my $FilterValue = $Self->{ParamObject}->GetParam(
            Param => 'ColumnFilterDynamicField_' . $DynamicFieldConfig->{Name}
        );

        next DYNAMICFIELD if !defined $FilterValue;
        next DYNAMICFIELD if $FilterValue eq '';

        $ColumnFilter{ 'DynamicField_' . $DynamicFieldConfig->{Name} } = {
            Equals => $FilterValue,
        };
        $GetColumnFilter{ 'DynamicField_' . $DynamicFieldConfig->{Name} } = $FilterValue;
    }

    # starting with page ...
    my $Refresh = '';
    if ( $Self->{UserRefreshTime} ) {
        $Refresh = 60 * $Self->{UserRefreshTime};
    }
    my $Output;
    if ( $Self->{Subaction} ne 'AJAXFilterUpdate' ) {
        $Output = $Self->{LayoutObject}->Header( Refresh => $Refresh, );
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->{LayoutObject}->Print( Output => \$Output );
        $Output = '';
    }

    my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $Self->{TimeObject}->SystemTime2Date(
        SystemTime => $Self->{TimeObject}->SystemTime() + 60 * 60 * 24 * 7,
    );
    my $TimeStampNextWeek = "$Year-$Month-$Day 23:59:59";

    ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $Self->{TimeObject}->SystemTime2Date(
        SystemTime => $Self->{TimeObject}->SystemTime() + 60 * 60 * 24,
    );
    my $TimeStampTomorrow = "$Year-$Month-$Day 23:59:59";

    ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $Self->{TimeObject}->SystemTime2Date(
        SystemTime => $Self->{TimeObject}->SystemTime(),
    );
    my $TimeStampToday = "$Year-$Month-$Day 23:59:59";

    my %Filters = (
        Today => {
            Name   => 'Today',
            Prio   => 1000,
            Search => {
                TicketEscalationTimeOlderDate => $TimeStampToday,
                OrderBy                       => $Self->{OrderBy},
                SortBy                        => $Self->{SortBy},
                UserID                        => $Self->{UserID},
                Permission                    => $Self->{Config}->{'TicketPermission'},
            },
        },
        Tomorrow => {
            Name   => 'Tomorrow',
            Prio   => 2000,
            Search => {
                TicketEscalationTimeOlderDate => $TimeStampTomorrow,
                OrderBy                       => $Self->{OrderBy},
                SortBy                        => $Self->{SortBy},
                UserID                        => $Self->{UserID},
                Permission                    => $Self->{Config}->{'TicketPermission'},
            },
        },
        NextWeek => {
            Name   => 'Next week',
            Prio   => 3000,
            Search => {
                TicketEscalationTimeOlderDate => $TimeStampNextWeek,
                OrderBy                       => $Self->{OrderBy},
                SortBy                        => $Self->{SortBy},
                UserID                        => $Self->{UserID},
                Permission                    => $Self->{Config}->{'TicketPermission'},
            },
        },
    );

    # check if filter is valid
    if ( !$Filters{ $Self->{Filter} } ) {
        $Self->{LayoutObject}->FatalError( Message => "Invalid Filter: $Self->{Filter}!" );
    }

    # do shown tickets lookup
    my $Limit = 10_000;

    my $ElementChanged = $Self->{ParamObject}->GetParam( Param => 'ElementChanged' ) || '';
    my $HeaderColumn = $ElementChanged;
    $HeaderColumn =~ s{\A ColumnFilter }{}msxg;
    my @OriginalViewableTickets;
    my @ViewableTickets;
    my $ViewableTicketCount = 0;

    # get ticket values
    if (
        !IsStringWithData($HeaderColumn) ||
        (
            IsStringWithData($HeaderColumn) &&
            (
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
            Result => 'ARRAY',
            Limit  => $Self->{Limit},
        );
    }

    if ( $Self->{Subaction} eq 'AJAXFilterUpdate' ) {

        my $FilterContent = $Self->{LayoutObject}->TicketListShow(
            FilterContentOnly => 1,
            HeaderColumn      => $HeaderColumn,
            ElementChanged    => $ElementChanged,
            OriginalTicketIDs => \@OriginalViewableTickets,
            Action            => 'AgentTicketStatusView',
            Env               => $Self,
            View              => $Self->{View},
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

        my $DeleteFilters = $Self->{ParamObject}->GetParam( Param => 'DeleteFilters' ) || '';

        # store column filters
        my $StoredFilters = \%ColumnFilter;
        if ( !IsArrayRefWithData( \@ViewableTickets ) || $DeleteFilters ) {
            $StoredFilters = {};
        }
        my $StoredFiltersKey = 'UserStoredFilterColumns-' . $Self->{Action};
        $Self->{UserObject}->SetPreferences(
            UserID => $Self->{UserID},
            Key    => $StoredFiltersKey,
            Value  => $Self->{JSONObject}->Encode( Data => $StoredFilters ),
        );
    }

    my %NavBarFilter;
    for my $Filter ( sort keys %Filters ) {
        my @ViewableTickets = $Self->{TicketObject}->TicketSearch(
            %{ $Filters{$Filter}->{Search} },
            %ColumnFilter,
            Result => 'ARRAY',
            Limit  => $Self->{Limit},
        );
        $NavBarFilter{ $Filters{$Filter}->{Prio} } = {
            Count  => scalar @ViewableTickets,
            Filter => $Filter,
            %{ $Filters{$Filter} },
        };
    }

    my $ColumnFilterLink = '';
    COLUMNNAME:
    for my $ColumnName ( keys %GetColumnFilter ) {
        next COLUMNNAME if !$ColumnName;
        next COLUMNNAME if !$GetColumnFilter{$ColumnName};
        $ColumnFilterLink
            .= ';' . $Self->{LayoutObject}->Ascii2Html( Text => 'ColumnFilter' . $ColumnName )
            . '=' . $Self->{LayoutObject}->Ascii2Html( Text => $GetColumnFilter{$ColumnName} )
    }

    # show ticket's
    my $LinkPage = 'Filter='
        . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Filter} )
        . ';View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
        . ';SortBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{SortBy} )
        . ';OrderBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{OrderBy} )
        . $ColumnFilterLink
        . ';';
    my $LinkSort = 'Filter='
        . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Filter} )
        . ';View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
        . $ColumnFilterLink
        . ';';
    my $LinkFilter = 'SortBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{SortBy} )
        . ';OrderBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{OrderBy} )
        . ';View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
        . ';';

    my $LastColumnFilter = $Self->{ParamObject}->GetParam( Param => 'LastColumnFilter' ) || '';

    if ( !$LastColumnFilter && $ColumnFilterLink ) {

        # is planned to have a link to go back here
        $LastColumnFilter = 1;
    }

    $Output .= $Self->{LayoutObject}->TicketListShow(
        TicketIDs         => \@ViewableTickets,
        OriginalTicketIDs => \@OriginalViewableTickets,
        GetColumnFilter   => \%GetColumnFilter,
        LastColumnFilter  => $LastColumnFilter,
        Action            => 'AgentTicketEscalationView',
        RequestedURL      => $Self->{RequestedURL},

        Total => scalar @ViewableTickets,

        View => $Self->{View},

        Filter     => $Self->{Filter},
        Filters    => \%NavBarFilter,
        FilterLink => $LinkFilter,

        TitleName  => 'Ticket Escalation View',
        TitleValue => $Filters{ $Self->{Filter} }->{Name},
        Bulk       => 1,

        Env      => $Self,
        LinkPage => $LinkPage,
        LinkSort => $LinkSort,

        OrderBy => $Self->{OrderBy},
        SortBy  => $Self->{SortBy},

        Escalation => 1,
    );

    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

1;
