# --
# Kernel/Output/HTML/DashboardUserOnline.pm
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: DashboardUserOnline.pm,v 1.3 2009-07-13 23:23:53 martin Exp $
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
$VERSION = qw($Revision: 1.3 $) [1];

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
    my $Name           = $Self->{ParamObject}->GetParam( Param => 'Name' ) || '';
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
                Key       => $PreferencesKey,
                Value     => $Self->{Filter},
            );
        }
    }

    if ( !$Self->{Filter} ) {
        $Self->{Filter} = $Self->{$PreferencesKey} || $Self->{Config}->{Filter} || 'Agent';
    }

    $Self->{PrefKey} = 'UserDashboardPref' . $Self->{Name} . '-Shown';

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

    return (
        %{ $Self->{Config} },
        CacheKey => undef,
    );
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get config settings
    my $IdleMinutes = $Self->{Config}->{IdleMinutes} || 60;
    my $SortBy      = $Self->{Config}->{SortBy} || 'UserLastname';

    # check cache
    my $Online = $Self->{CacheObject}->Get(
        Type => 'Dashboard',
        Key  => $Self->{Name},
    );

    # get session info
    if ( !$Online ) {
        $Online = {
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

            # use agent instand of user
            if ( $Data{UserType} eq 'User' ) {
                $Data{UserType} = 'Agent';
            }

            # only show if not already shown
            next if $Online->{User}->{ $Data{UserType} }->{ $Data{UserID} };

            # check last request time / idle time out
            next if !$Data{UserLastRequest};
            next if $Data{UserLastRequest} + ( $IdleMinutes * 60 ) < $Self->{TimeObject}->SystemTime();

            # remember user and data
            $Online->{User}->{ $Data{UserType} }->{ $Data{UserID} } = $Data{$SortBy};
            $Online->{UserCount}->{ $Data{UserType} }++;
            $Online->{UserData}->{ $Data{UserType} }->{ $Data{UserID} } = \%Data;
        }
    }

    # set cache
    if ( $Self->{Config}->{CacheTTL} ) {
        $Self->{CacheObject}->Set(
            Type  => 'Dashboard',
            Key   => $Self->{Name},
            Value => $Online,
            TTL   => $Self->{Config}->{CacheTTL} * 60,
        );
    }

    # filter bar
    $Self->{LayoutObject}->SetEnv(
        Key   => 'Color',
        Value => 'searchactive',
    );
    my %Summary;
    $Summary{ $Self->{Filter} . '::Style' } = 'text-decoration:none';

    $Self->{LayoutObject}->Block(
        Name => 'ContentSmallUserOnlineFilter',
        Data => {
            %{ $Self->{Config} },
            Name => $Self->{Name},
            %{ $Online->{UserCount} },
            %Summary,
        },
    );

    # show agent/customer
    my %OnlineUser = %{ $Online->{User}->{ $Self->{Filter} } };
    my %OnlineData = %{ $Online->{UserData}->{ $Self->{Filter} } };
    my $Count      = 0;
    my $Limit      = $Self->{LayoutObject}->{ $Self->{PrefKey} } || $Self->{Config}->{Limit};

    for my $UserID ( sort { $OnlineUser{$a} cmp $OnlineUser{$b} } keys %OnlineUser ) {

        $Count++;
        if ( $Count > $Limit ) {
            $Self->{LayoutObject}->Block(
                Name => 'ContentSmallUserOnlineRowMore',
                Data => $OnlineData{$UserID},
            );
            last;
        }
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
    );

    return $Content;
}

1;
