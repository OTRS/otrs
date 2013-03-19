# --
# Kernel/Output/HTML/DashboardUserOutOfOffice.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::DashboardUserOutOfOffice;

use strict;
use warnings;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for (
        qw(Config Name ConfigObject LogObject DBObject LayoutObject ParamObject TicketObject UserObject UserID)
        )
    {
        die "Got no $_!" if ( !$Self->{$_} );
    }

    # get current starthit and preferences
    my $Name = $Self->{ParamObject}->GetParam( Param => 'Name' ) || '';
    my $PreferencesKey = 'UserDashboardUserOutOfOffice' . $Self->{Name};

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
            Data  => {
                5  => ' 5',
                10 => '10',
                15 => '15',
                20 => '20',
                25 => '25',
                30 => '30',
                35 => '35',
                40 => '40',
                45 => '45',
                50 => '50',
            },
            SelectedID  => $Self->{PageShown},
            Translation => 0,
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
    my $SortBy = $Self->{Config}->{SortBy} || 'UserLastname';

    # check cache
    my $OutOfOffice = $Self->{CacheObject}->Get(
        Type => 'Dashboard',
        Key  => $Self->{CacheKey},
    );

    # get session info
    my $CacheUsed = 1;
    if ( !$OutOfOffice ) {

        $CacheUsed   = 0;
        $OutOfOffice = {
            User      => {},
            UserCount => 0,
            UserData  => {},
        };

        my %UserList = $Self->{UserObject}->SearchPreferences(
            Key   => 'OutOfOffice',
            Value => 1,
        );

        USERID:
        for my $UserID ( sort keys %UserList ) {

            next USERID if !$UserID;

            # get user data
            my %Data = $Self->{UserObject}->GetUserData(
                UserID        => $UserID,
                NoOutOfOffice => 1,
            );

            next USERID if !%Data;

            my $Time  = $Self->{TimeObject}->SystemTime();
            my $Start = sprintf(
                "%04d-%02d-%02d 00:00:00",
                $Data{OutOfOfficeStartYear}, $Data{OutOfOfficeStartMonth},
                $Data{OutOfOfficeStartDay}
            );
            my $TimeStart = $Self->{TimeObject}->TimeStamp2SystemTime(
                String => $Start,
            );
            my $End = sprintf(
                "%04d-%02d-%02d 23:59:59",
                $Data{OutOfOfficeEndYear}, $Data{OutOfOfficeEndMonth}, $Data{OutOfOfficeEndDay}
            );
            my $TimeEnd = $Self->{TimeObject}->TimeStamp2SystemTime(
                String => $End,
            );

            next USERID if $TimeStart > $Time || $TimeEnd < $Time;

            $Data{OutOfOfficeUntil} = $End;

            # remember user and data
            $OutOfOffice->{User}->{ $Data{UserID} } = $Data{$SortBy};
            $OutOfOffice->{UserCount}++;
            $OutOfOffice->{UserData}->{ $Data{UserID} } = \%Data;
        }
    }

    # do not show widget if there are no users out-of-office
    return if !$OutOfOffice->{UserCount};

    # set cache
    if ( !$CacheUsed && $Self->{Config}->{CacheTTLLocal} ) {
        $Self->{CacheObject}->Set(
            Type  => 'Dashboard',
            Key   => $Self->{CacheKey},
            Value => $OutOfOffice,
            TTL   => $Self->{Config}->{CacheTTLLocal} * 60,
        );
    }

    # add page nav bar if needed
    my $Total = $OutOfOffice->{UserCount} || 0;
    if ( $OutOfOffice->{UserCount} > $Self->{PageShown} ) {

        my $LinkPage = 'Subaction=Element;Name=' . $Self->{Name} . ';';
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
            Name => 'ContentSmallTicketGenericNavBar',
            Data => {
                %{ $Self->{Config} },
                Name => $Self->{Name},
                %PageNav,
            },
        );
    }

    # show data
    my %OutOfOfficeUser = %{ $OutOfOffice->{User} };
    my %OutOfOfficeData = %{ $OutOfOffice->{UserData} };
    my $Count           = 0;
    my $Limit           = $Self->{LayoutObject}->{ $Self->{PrefKey} } || $Self->{Config}->{Limit};

    USERID:
    for my $UserID ( sort { $OutOfOfficeUser{$a} cmp $OutOfOfficeUser{$b} } keys %OutOfOfficeUser )
    {

        $Count++;

        next USERID if !$UserID;
        next USERID if $Count < $Self->{StartHit};
        last USERID if $Count >= ( $Self->{StartHit} + $Self->{PageShown} );

        $Self->{LayoutObject}->Block(
            Name => 'ContentSmallUserOutOfOfficeRow',
            Data => $OutOfOfficeData{$UserID},
        );
    }

    my $Content = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentDashboardUserOutOfOffice',
        Data         => {
            %{ $Self->{Config} },
            Name => $Self->{Name},
        },
        KeepScriptTags => $Param{AJAX},
    );

    return $Content;
}

1;
