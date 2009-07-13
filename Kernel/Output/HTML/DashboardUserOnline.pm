# --
# Kernel/Output/HTML/DashboardUserOnline.pm
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: DashboardUserOnline.pm,v 1.2 2009-07-13 06:09:02 martin Exp $
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
$VERSION = qw($Revision: 1.2 $) [1];

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

    return $Self;
}

sub Preferences {
    my ( $Self, %Param ) = @_;

    my $Key = $Self->{LayoutObject}->{UserLanguage} . '-' . $Self->{Filter} . '-' . $Self->{Name};

    return (
        %{ $Self->{Config} },
        CacheKey => 'UserOnline' . '-' . $Key,
    );
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get session info
    my %OnlineUser = (
        Agent    => {},
        Customer => {},
    );
    my %OnlineUserCount = (
        Agent    => 0,
        Customer => 0,
    );
    my %OnlineUserData = (
        Agent    => {},
        Customer => {},
    );
    my $IdleMinutes = $Self->{Config}->{IdleMinutes} || 60;
    my $SortBy      = $Self->{Config}->{SortBy} || 'UserLastname';
    my @Sessions    = $Self->{SessionObject}->GetAllSessionIDs();
    for (@Sessions) {
        my %Data = $Self->{SessionObject}->GetSessionIDData( SessionID => $_ );

        # use agent instand of user
        if ( $Data{UserType} eq 'User' ) {
            $Data{UserType} = 'Agent';
        }

        # only show if not already shown
        next if $OnlineUser{ $Data{UserType} }->{ $Data{UserID} };

        # check last request time / idle time out
        next if !$Data{UserLastRequest};
        next if $Data{UserLastRequest} + ( $IdleMinutes * 60 ) < $Self->{TimeObject}->SystemTime();

        # remember user and data
        $OnlineUser{ $Data{UserType} }->{ $Data{UserID} }     = $Data{$SortBy};
        $OnlineUserCount{ $Data{UserType} }++;
        $OnlineUserData{ $Data{UserType} }->{ $Data{UserID} } = \%Data;
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
            %OnlineUserCount,
            %Summary,
        },
    );

    # show agent/customer
    my %Online     = %{ $OnlineUser{ $Self->{Filter} } };
    my %OnlineData = %{ $OnlineUserData{ $Self->{Filter} } };
    my $Count      = 0;
    for my $UserID ( sort { $Online{$a} cmp $Online{$b} } keys %Online ) {

        $Count++;
        if ( $Count > $Self->{Config}->{Limit} ) {
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

    if ( !%Online ) {
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
