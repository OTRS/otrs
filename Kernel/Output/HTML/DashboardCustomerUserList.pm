# --
# Kernel/Output/HTML/DashboardCustomerUserList.pm
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: DashboardCustomerUserList.pm,v 1.2 2012-09-14 08:52:19 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::DashboardCustomerUserList;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

use Kernel::System::CustomerUser;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for (
        qw(Config Name ConfigObject LogObject DBObject LayoutObject TicketObject ParamObject UserID)
        )
    {
        die "Got no $_!" if ( !$Self->{$_} );
    }

    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new( %{$Self} );

    # get current filter
    my $Name = $Self->{ParamObject}->GetParam( Param => 'Name' ) || '';
    my $PreferencesKey = 'UserDashboardCustomerUserListFilter' . $Self->{Name};

    $Self->{PrefKey} = 'UserDashboardPref' . $Self->{Name} . '-Shown';

    $Self->{PageShown} = $Self->{LayoutObject}->{ $Self->{PrefKey} } || $Self->{Config}->{Limit};
    $Self->{StartHit} = int( $Self->{ParamObject}->GetParam( Param => 'StartHit' ) || 1 );

    return $Self;
}

sub Preferences {
    my ( $Self, %Param ) = @_;

    my @Params = (
        {
            Desc  => 'Shown customer users',
            Name  => $Self->{PrefKey},
            Block => 'Option',

            #            Block => 'Input',
            Data => {
                5  => ' 5',
                10 => '10',
                15 => '15',
                20 => '20',
                25 => '25',
            },
            SelectedID  => $Self->{PageShown},
            Translation => 0,
        },
    );

    return @Params;
}

sub Config {
    my ( $Self, %Param ) = @_;

    #    # check if frontend module of link is used
    #    if ( $Self->{Config}->{Link} && $Self->{Config}->{Link} =~ /Action=(.+?)([&;].+?|)$/ ) {
    #        my $Action = $1;
    #        if ( !$Self->{ConfigObject}->Get('Frontend::Module')->{$Action} ) {
    #            $Self->{Config}->{Link} = '';
    #        }
    #    }

    return (
        %{ $Self->{Config} },

        # remember, do not allow to use page cache
        # (it's not working because of internal filter)
        CacheTTL => undef,
        CacheKey => undef,
    );
}

sub Run {
    my ( $Self, %Param ) = @_;

    return if !$Param{CustomerID};

    my $CacheKey = $Self->{Name} . '-'
        . $Self->{PageShown} . '-'
        . $Self->{StartHit} . '-'
        . $Self->{CustomerID};

    # check cache
    my $CustomerIDs = $Self->{CacheObject}->Get(
        Type => 'Dashboard',
        Key  => $CacheKey,
    );

    if ( ref $CustomerIDs ne 'HASH' ) {
        $CustomerIDs
            = { $Self->{CustomerUserObject}->CustomerSearch( CustomerID => $Param{CustomerID} ) };

        if ( $Self->{Config}->{CacheTTLLocal} ) {
            $Self->{CacheObject}->Set(
                Type  => 'Dashboard',
                Key   => $CacheKey,
                Value => $CustomerIDs,
                TTL   => $Self->{Config}->{CacheTTLLocal} * 60,
            );
        }
    }

    # add page nav bar
    my $Total = scalar keys %{$CustomerIDs};

    my $LinkPage
        = 'Subaction=Element;Name='
        . $Self->{Name} . ';'
        . 'CustomerID='
        . $Self->{LayoutObject}->LinkEncode( $Param{CustomerID} ) . ';';

    my %PageNav = $Self->{LayoutObject}->PageNavBar(
        StartHit       => $Self->{StartHit},
        PageShown      => $Self->{PageShown},
        AllHits        => $Total || 1,
        Action         => 'Action=' . $Self->{LayoutObject}->{Action},
        Link           => $LinkPage,
        AJAXReplace    => 'Dashboard' . $Self->{Name},
        IDPrefix       => 'Dashboard' . $Self->{Name},
        KeepScriptTags => $Param{AJAX},
    );

    $Self->{LayoutObject}->Block(
        Name => 'ContentLargeCustomerUserListNavBar',
        Data => {
            %{ $Self->{Config} },
            Name => $Self->{Name},
            %PageNav,
        },
    );

    my @CustomerKeys
        = sort { lc( $CustomerIDs->{$a} ) cmp lc( $CustomerIDs->{$b} ) } keys %{$CustomerIDs};
    @CustomerKeys = splice @CustomerKeys, $Self->{StartHit} - 1, $Self->{PageShown};

    for my $CustomerKey (@CustomerKeys) {
        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeCustomerUserListRow',
            Data => {
                %Param,
                CustomerKey       => $CustomerKey,
                CustomerListEntry => $CustomerIDs->{$CustomerKey},
            },
        );

        my $CustomerKeySQL = $Self->{DBObject}->QueryStringEscape( QueryString => $CustomerKey );

        my $TicketCountOpen = $Self->{TicketObject}->TicketSearch(
            StateType         => 'Open',
            CustomerUserLogin => $CustomerKeySQL,
            Result            => 'COUNT',
            UserID            => $Self->{UserID},
            CacheTTL          => $Self->{Config}->{CacheTTLLocal} * 60,
        );

        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeCustomerUserListRowCustomerUserTicketsOpen',
            Data => {
                %Param,
                Count          => $TicketCountOpen,
                CustomerKey    => $CustomerKey,
                CustomerKeySQL => $CustomerKeySQL,
            },
        );

        my $TicketCountClosed = $Self->{TicketObject}->TicketSearch(
            StateType         => 'Closed',
            CustomerUserLogin => $CustomerKeySQL,
            Result            => 'COUNT',
            UserID            => $Self->{UserID},
            CacheTTL          => $Self->{Config}->{CacheTTLLocal} * 60,
        );

        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeCustomerUserListRowCustomerUserTicketsClosed',
            Data => {
                %Param,
                Count          => $TicketCountClosed,
                CustomerKey    => $CustomerKey,
                CustomerKeySQL => $CustomerKeySQL,
            },
        );
    }

    # show "none" if no ticket is available
    if ( !%{$CustomerIDs} ) {
        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeCustomerUserListNone',
            Data => {},
        );
    }

    my $Content = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentDashboardCustomerUserList',
        Data         => {
            %{ $Self->{Config} },
            Name => $Self->{Name},
        },
        KeepScriptTags => $Param{AJAX},
    );

    return $Content;
}

1;
