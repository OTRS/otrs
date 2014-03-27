# --
# Kernel/Output/HTML/DashboardUserOnline.pm
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: DashboardUserOnline.pm,v 1.19 2010-11-04 14:48:31 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::DashboardUserOnline;

use strict;
use warnings;

use Kernel::System::AuthSession;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.19 $) [1];

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

    $Self->{SessionObject} = Kernel::System::AuthSession->new(%Param);

    # get current filter
    my $Name = $Self->{ParamObject}->GetParam( Param => 'Name' ) || '';
    my $PreferencesKey = 'UserDashboardUserOnlineFilter' . $Self->{Name};
    if ( $Self->{Name} eq $Name ) {
        $Self->{Filter} = $Self->{ParamObject}->GetParam( Param => 'Filter' ) || '';
    }

    # remember filter
    if ( $Self->{Filter} ) {

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
                Key    => $PreferencesKey,
                Value  => $Self->{Filter},
            );
        }
    }

    if ( !$Self->{Filter} ) {
        $Self->{Filter} = $Self->{$PreferencesKey} || $Self->{Config}->{Filter} || 'Agent';
    }

    $Self->{PrefKey} = 'UserDashboardPref' . $Self->{Name} . '-Shown';

    $Self->{PageShown} = $Self->{LayoutObject}->{ $Self->{PrefKey} } || $Self->{Config}->{Limit};

    $Self->{StartHit} = int( $Self->{ParamObject}->GetParam( Param => 'StartHit' ) || 1 );

    $Self->{CacheKey} = $Self->{Name};

    return $Self;
}

sub Preferences {
    my ( $Self, %Param ) = @_;

    my @Params = (
        {
            Desc  => 'Shown',
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
            SelectedID => $Self->{PageShown},
        },
    );

    return @Params;
}

sub Config {
    my ( $Self, %Param ) = @_;

    return (
        %{ $Self->{Config} },

        # remember, do not allow to use page cache
        # (it's not working because of internal filter)
        CacheKey => undef,
        CacheTTL => undef,
    );
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get config settings
    my $IdleMinutes = $Self->{Config}->{IdleMinutes} || 60;
    my $SortBy      = $Self->{Config}->{SortBy}      || 'UserLastname';

    # check cache
    my $Online = $Self->{CacheObject}->Get(
        Type => 'Dashboard',
        Key  => $Self->{CacheKey},
    );

    # get session info
    my $CacheUsed = 1;
    if ( !$Online ) {
        $CacheUsed = 0;
        $Online    = {
            User => {
                Agent    => {},
                Customer => {},
            },
            UserCount => {
                Agent    => 0,
                Customer => 0,
            },
            UserData => {
                Agent    => {},
                Customer => {},
            },
        };
        my @Sessions = $Self->{SessionObject}->GetAllSessionIDs();
        for (@Sessions) {
            my %Data = $Self->{SessionObject}->GetSessionIDData( SessionID => $_ );

            # use agent instead of user
            if ( $Data{UserType} eq 'User' ) {
                $Data{UserType} = 'Agent';
            }

            # only show if not already shown
            next if $Online->{User}->{ $Data{UserType} }->{ $Data{UserID} };

            # check last request time / idle time out
            next if !$Data{UserLastRequest};
            next
                if $Data{UserLastRequest} + ( $IdleMinutes * 60 )
                < $Self->{TimeObject}->SystemTime();

            # remember user and data
            $Online->{User}->{ $Data{UserType} }->{ $Data{UserID} } = $Data{$SortBy};
            $Online->{UserCount}->{ $Data{UserType} }++;
            $Online->{UserData}->{ $Data{UserType} }->{ $Data{UserID} } = \%Data;
        }
    }

    # set cache
    if ( !$CacheUsed && $Self->{Config}->{CacheTTLLocal} ) {
        $Self->{CacheObject}->Set(
            Type  => 'Dashboard',
            Key   => $Self->{CacheKey},
            Value => $Online,
            TTL   => $Self->{Config}->{CacheTTLLocal} * 60,
        );
    }

    # set css class
    my %Summary;
    $Summary{ $Self->{Filter} . '::Selected' } = 'Selected';

    # filter bar
    $Self->{LayoutObject}->Block(
        Name => 'ContentSmallUserOnlineFilter',
        Data => {
            %{ $Self->{Config} },
            Name => $Self->{Name},
            %{ $Online->{UserCount} },
            %Summary,
        },
    );

    # add page nav bar
    my $Total    = $Online->{UserCount}->{ $Self->{Filter} } || 0;
    my $LinkPage = 'Subaction=Element;Name=' . $Self->{Name} . ';Filter=' . $Self->{Filter} . ';';
    my %PageNav  = $Self->{LayoutObject}->PageNavBar(
        StartHit       => $Self->{StartHit},
        PageShown      => $Self->{PageShown},
        AllHits        => $Total || 1,
        Action         => 'Action=' . $Self->{LayoutObject}->{Action},
        Link           => $LinkPage,
        WindowSize     => 5,
        AJAXReplace    => 'Dashboard' . $Self->{Name},
        IDPrefix       => 'Dashboard' . $Self->{Name},
        KeepScriptTags => $Param{AJAX},
    );
    $Self->{LayoutObject}->Block(
        Name => 'ContentSmallTicketGenericFilterNavBar',
        Data => {
            %{ $Self->{Config} },
            Name => $Self->{Name},
            %PageNav,
        },
    );

    # show agent/customer
    my %OnlineUser = %{ $Online->{User}->{ $Self->{Filter} } };
    my %OnlineData = %{ $Online->{UserData}->{ $Self->{Filter} } };
    my $Count      = 0;
    my $Limit      = $Self->{LayoutObject}->{ $Self->{PrefKey} } || $Self->{Config}->{Limit};

    for my $UserID ( sort { $OnlineUser{$a} cmp $OnlineUser{$b} } keys %OnlineUser ) {
        $Count++;
        next if $Count < $Self->{StartHit};
        last if $Count >= ( $Self->{StartHit} + $Self->{PageShown} );
        $Self->{LayoutObject}->Block(
            Name => 'ContentSmallUserOnlineRow',
            Data => $OnlineData{$UserID},
        );
        if ( $Self->{Config}->{ShowEmail} ) {
            $Self->{LayoutObject}->Block(
                Name => 'ContentSmallUserOnlineRowEmail',
                Data => $OnlineData{$UserID},
            );
        }
    }

    if ( !%OnlineUser ) {
        $Self->{LayoutObject}->Block(
            Name => 'ContentSmallUserOnlineNone',
            Data => {},
        );
    }

    my $Content = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentDashboardUserOnline',
        Data         => {
            %{ $Self->{Config} },
            Name => $Self->{Name},
        },
        KeepScriptTags => $Param{AJAX},
    );

    return $Content;
}

1;
