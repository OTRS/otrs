# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Preferences::TicketWatcher;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Web::Request',
    'Kernel::Config',
    'Kernel::System::User',
    'Kernel::System::AuthSession',
    'Kernel::Output::HTML::Layout',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    for my $Needed (qw( UserID  ConfigItem)) {
        die "Got no $Needed!" if !$Self->{$Needed};
    }

    return $Self;
}

sub Param {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # check if feature is active
    return if !$ConfigObject->Get('Ticket::Watcher');

    # check access
    my @Groups;
    if ( $ConfigObject->Get('Ticket::WatcherGroup') ) {
        @Groups = @{ $ConfigObject->Get('Ticket::WatcherGroup') };
    }
    my $Access = 0;
    if ( !@Groups ) {
        $Access = 1;
    }
    else {
        GROUP:
        for my $Group (@Groups) {

            # get layout object
            my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

            next GROUP if !$LayoutObject->{"UserIsGroup[$Group]"};
            if ( $LayoutObject->{"UserIsGroup[$Group]"} eq 'Yes' ) {
                $Access = 1;
                last GROUP;
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
            if ( !$Kernel::OM->Get('Kernel::Config')->Get('DemoSystem') ) {
                $Kernel::OM->Get('Kernel::System::User')->SetPreferences(
                    UserID => $Param{UserData}->{UserID},
                    Key    => $Key,
                    Value  => $_,
                );
            }

            # update SessionID
            if ( $Param{UserData}->{UserID} eq $Self->{UserID} ) {
                $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
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
