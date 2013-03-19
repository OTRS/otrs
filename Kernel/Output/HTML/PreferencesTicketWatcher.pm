# --
# Kernel/Output/HTML/PreferencesTicketWatcher.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::PreferencesTicketWatcher;

use strict;
use warnings;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject LayoutObject UserID ParamObject ConfigItem)) {
        die "Got no $_!" if !$Self->{$_};
    }

    return $Self;
}

sub Param {
    my ( $Self, %Param ) = @_;

    # check if feature is active
    return if !$Self->{ConfigObject}->Get('Ticket::Watcher');

    # check access
    my @Groups;
    if ( $Self->{ConfigObject}->Get('Ticket::WatcherGroup') ) {
        @Groups = @{ $Self->{ConfigObject}->Get('Ticket::WatcherGroup') };
    }
    my $Access = 0;
    if ( !@Groups ) {
        $Access = 1;
    }
    else {
        for my $Group (@Groups) {
            next if !$Self->{LayoutObject}->{"UserIsGroup[$Group]"};
            if ( $Self->{LayoutObject}->{"UserIsGroup[$Group]"} eq 'Yes' ) {
                $Access = 1;
                last;
            }
        }
    }

    # return on no access
    return if !$Access;

    my $SelectedID = $Param{UserData}->{UserSendWatcherNotification};
    $SelectedID = $Self->{ConfigItem}->{DataSelected} if !defined $SelectedID;
    $SelectedID = 0 if !defined $SelectedID;

    my @Params = (
        {
            %Param,
            Name       => $Self->{ConfigItem}->{PrefKey},
            SelectedID => $SelectedID,
            Block      => 'Option',
        },
    );
    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    for my $Key ( sort keys %{ $Param{GetParam} } ) {
        my @Array = @{ $Param{GetParam}->{$Key} };
        for (@Array) {

            # pref update db
            if ( !$Self->{ConfigObject}->Get('DemoSystem') ) {
                $Self->{UserObject}->SetPreferences(
                    UserID => $Param{UserData}->{UserID},
                    Key    => $Key,
                    Value  => $_,
                );
            }

            # update SessionID
            if ( $Param{UserData}->{UserID} eq $Self->{UserID} ) {
                $Self->{SessionObject}->UpdateSessionID(
                    SessionID => $Self->{SessionID},
                    Key       => $Key,
                    Value     => $_,
                );
            }
        }
    }

    $Self->{Message} = 'Preferences updated successfully!';
    return 1;
}

sub Error {
    my ( $Self, %Param ) = @_;

    return $Self->{Error} || '';
}

sub Message {
    my ( $Self, %Param ) = @_;

    return $Self->{Message} || '';
}

1;
