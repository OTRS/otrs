# --
# Kernel/Output/HTML/DashboardTicketGeneric.pm
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: DashboardTicketGeneric.pm,v 1.13 2009-07-13 23:23:53 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::DashboardTicketGeneric;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.13 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for (
        qw(Config Name ConfigObject LogObject DBObject LayoutObject ParamObject TicketObject UserID)
        )
    {
        die "Got no $_!" if ( !$Self->{$_} );
    }

    # get current filter
    my $Name           = $Self->{ParamObject}->GetParam( Param => 'Name' ) || '';
    my $PreferencesKey = 'UserDashboardTicketGenericFilter' . $Self->{Name};
    if ( $Self->{Name} eq $Name ) {
        $Self->{Filter} = $Self->{ParamObject}->GetParam( Param => 'Filter' ) || '';
    }

    # remember filter
    if ($Self->{Filter}) {
        # update ssession
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => $PreferencesKey,
            Value     => $Self->{Filter},
        );

        # update preferences
        if ( !$Self->{ConfigObject}->Get('DemoSystem') ) {
            $Self->{UserObject}->SetPreferences(
                UserID => $Self->{UserID},
                Key       => $PreferencesKey,
                Value     => $Self->{Filter},
            );
        }
    }

    if ( !$Self->{Filter} ) {
        $Self->{Filter} = $Self->{$PreferencesKey} || $Self->{Config}->{Filter} || 'All';
    }

    $Self->{PrefKey} = 'UserDashboardPref' . $Self->{Name} . '-Shown';

    $Self->{CacheKey} =  $Self->{Name} . '-' . $Self->{UserID};

    return $Self;
}

sub Preferences {
    my ( $Self, %Param ) = @_;

    my @Params = (
        {
            Desc  => 'Shown Tickets',
            Name  => $Self->{PrefKey},
            Block => 'Option',
#            Block => 'Input',
            Data  => {
                5  => ' 5',
                10 => '10',
                15 => '15',
                20 => '20',
                25 => '25',
            },
            SelectedID => $Self->{LayoutObject}->{ $Self->{PrefKey} } || $Self->{Config}->{Limit},
        },
    );

    return @Params;
}

sub Config {
    my ( $Self, %Param ) = @_;

    # check if frontend module of link is used
    if ( $Self->{Config}->{Link} && $Self->{Config}->{Link} =~ /Action=(.+?)(&.+?|)$/ ) {
        my $Action = $1;
        if ( !$Self->{ConfigObject}->Get('Frontend::Module')->{$Action} ) {
            $Self->{Config}->{Link} = '';
        }
    }

    return (
        %{ $Self->{Config} },
        CacheKey => undef,
    );
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get all search base attributes
    my %TicketSearch;
    my @Params = split /;/, $Self->{Config}->{Attributes};
    for my $String (@Params) {
        next if !$String;
        my ( $Key, $Value ) = split /=/, $String;

        if ( $Key eq 'StateType' ) {
            push @{ $TicketSearch{$Key} }, $Value;
        }
        elsif ( !defined $TicketSearch{$Key} ) {
            $TicketSearch{$Key} = $Value;
        }
        elsif ( !ref $TicketSearch{$Key} ) {
            my $ValueTmp = $TicketSearch{$Key};
            $TicketSearch{$Key} = [$ValueTmp];
        }
        else {
            push @{ $TicketSearch{$Key} }, $Value;
        }
    }
    %TicketSearch = (
        %TicketSearch,
        Permission => $Self->{Config}->{Permission} || 'ro',
        UserID     => $Self->{UserID},
    );

    # define filter attributes
    my %TicketSearchSummary = (
        Locked => {
            OwnerIDs => [ $Self->{UserID}, ],
            Locks    => ['lock'],
        },
        All => {
            OwnerIDs => undef,
            Locks    => undef,
        },
    );

    # check cache
    my $TicketIDs = $Self->{CacheObject}->Get(
        Type => 'Dashboard',
        Key  => $Self->{CacheKey} . '-' . $Self->{Filter} . '-List',
    );

    # find and show ticket list
    my $TicketIDsCache = 1;
    if ( !$TicketIDs ) {
        $TicketIDsCache = 0;
        my @TicketIDsArray = $Self->{TicketObject}->TicketSearch(
            Result => 'ARRAY',
            %TicketSearch,
            %{ $TicketSearchSummary{ $Self->{Filter} } },
            Limit => $Self->{LayoutObject}->{ $Self->{PrefKey} } || $Self->{Config}->{Limit},
        );
        $TicketIDs = \@TicketIDsArray;
    }

    # check cache
    my $Summary = $Self->{CacheObject}->Get(
        Type => 'Dashboard',
        Key  => $Self->{CacheKey} . '-Summary',
    );

    # if no cache ot new list result, do count lookup
    if ( !$Summary || !$TicketIDsCache ) {
        for my $Type ( sort keys %TicketSearchSummary ) {
            next if !$TicketSearchSummary{$Type};
            $Summary->{$Type} = $Self->{TicketObject}->TicketSearch(
                Result     => 'COUNT',
                %TicketSearch,
                %{ $TicketSearchSummary{$Type} },
            );
        }
    }

    # set cache
    if ( $Self->{Config}->{CacheTTL} ) {
        $Self->{CacheObject}->Set(
            Type  => 'Dashboard',
            Key   => $Self->{CacheKey} . '-Summary',
            Value => $Summary,
            TTL   => $Self->{Config}->{CacheTTL} * 60,
        );
        $Self->{CacheObject}->Set(
            Type  => 'Dashboard',
            Key   => $Self->{CacheKey} . '-' . $Self->{Filter} . '-List',
            Value => $TicketIDs,
            TTL   => $Self->{Config}->{CacheTTL} * 60,
        );
    }

    # get filter ticket counts
    $Self->{LayoutObject}->SetEnv(
        Key   => 'Color',
        Value => 'searchactive',
    );
    $Summary->{ $Self->{Filter} . '::Style' } = 'text-decoration:none';
    $Self->{LayoutObject}->Block(
        Name => 'ContentLargeTicketGenericFilter',
        Data         => {
            %{ $Self->{Config} },
            Name => $Self->{Name},
            %{ $Summary },
        },
    );

    for my $TicketID ( @{ $TicketIDs } ) {
        my %Ticket = $Self->{TicketObject}->TicketGet(
            TicketID => $TicketID,
            UserID   => $Self->{UserID},
        );

        # create human age
        if ( $Self->{Config}->{Time} ne 'Age' ) {
            $Ticket{Time} = $Self->{LayoutObject}->CustomerAgeInHours(
                Age   => $Ticket{ $Self->{Config}->{Time} },
                Space => ' ',
            );
        }
        else {
            $Ticket{Time} = $Self->{LayoutObject}->CustomerAge(
                Age   => $Ticket{ $Self->{Config}->{Time} },
                Space => ' ',
            );
        }

        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeTicketGenericRow',
            Data => \%Ticket,
        );
    }

    if ( !$TicketIDs || !@{ $TicketIDs } ) {
        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeTicketGenericNone',
            Data => {},
        );
    }

    my $Content = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentDashboardTicketGeneric',
        Data         => {
            %{ $Self->{Config} },
            Name => $Self->{Name},
            %{ $Summary },
        },
    );

    return $Content;
}

1;
