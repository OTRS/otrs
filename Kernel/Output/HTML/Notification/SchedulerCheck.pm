# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Notification::SchedulerCheck;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::PID',
    'Kernel::Output::HTML::Layout',
    'Kernel::Config',
    'Kernel::System::Group',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get UserID param
    $Self->{UserID} = $Param{UserID} || die "Got no UserID!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # try to get scheduler PID
    my %PID = $Kernel::OM->Get('Kernel::System::PID')->PIDGet(
        Name => 'otrs.Scheduler',
    );

    my %NotificationDetails;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check if scheduler process is registered in the DB
    if (%PID) {

        # get the PID update time
        my $PIDUpdateTime = $Kernel::OM->Get('Kernel::Config')->Get('Scheduler::PIDUpdateTime') || 600;

        # get current time
        my $Time = time();

        # calculate time difference
        my $DeltaTime = $Time - $PID{Changed};

        # return if scheduler is running
        if ( $DeltaTime <= 2 * $PIDUpdateTime ) {
            return '';
        }

        # check if scheduler is not running and process is still registered
        # send error notification if update time is 4 times bigger than it should be, this means
        # that scheduler must not be running
        if ( $DeltaTime >= 4 * $PIDUpdateTime ) {
            %NotificationDetails = (
                Priority => 'Error',
                Data     => $LayoutObject->{LanguageObject}
                    ->Translate("Scheduler process is registered but might not be running."),
            );
        }

        # otherwise send just a warning
        else {
            %NotificationDetails = (
                Priority => 'Info',
                Data =>
                    $LayoutObject->{LanguageObject}
                    ->Translate("Scheduler process is registered but might not be running."),
            );
        }
    }

    # otherwise scheduler is not running
    else {
        %NotificationDetails = (
            Priority => 'Error',
            Data     => $LayoutObject->{LanguageObject}->Translate("Scheduler is not running."),
        );
    }

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
        $NotificationDetails{Link}      = '#';
        $NotificationDetails{LinkClass} = 'SchedulerInfo';
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
