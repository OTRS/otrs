# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Notification::DaemonCheck;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Group',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{UserID} = $Param{UserID};

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get the NodeID from the SysConfig settings, this is used on High Availability systems.
    my $NodeID = $ConfigObject->Get('NodeID') || 1;

    # get PID directory
    my $PIDDir  = $ConfigObject->Get('Home') . '/var/run/';
    my $PIDFile = $PIDDir . "Daemon-NodeID-$NodeID.pid";

    my $RunningPID;

    if ( -e $PIDFile ) {

        # read existing PID file
        open my $FH, '<', $PIDFile;    ## no critic
        flock $FH, 1;
        my $RegisteredPID = do { local $/; <$FH> };
        close $FH;

        if ($RegisteredPID) {

            # check if process is running
            $RunningPID = kill 0, $RegisteredPID;
        }
    }

    return '' if $RunningPID;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %NotificationDetails = (
        Priority => 'Error',
        Data     => $LayoutObject->{LanguageObject}->Translate("OTRS Daemon is not running."),
    );

    # check if user needs to be notified
    # get current user groups
    my %Groups = $Kernel::OM->Get('Kernel::System::Group')->PermissionUserGet(
        UserID => $Self->{UserID},
        Type   => 'move_into',
    );

    # reverse groups hash for easy look up
    %Groups = reverse %Groups;

    # check if the user is in the Admin group
    # if that is the case, extend the error with a link
    if ( $Groups{admin} ) {
        $NotificationDetails{Link}      = $LayoutObject->{Baselink} . '#';
        $NotificationDetails{LinkClass} = 'DaemonInfo';
    }

    # if user is not admin, add 'Please contact your administrator' to error message
    else {
        $NotificationDetails{Data} .= " Please contact your administrator!";
    }

    # show error notification
    return $LayoutObject->Notify(
        %NotificationDetails,
    );
}

1;
