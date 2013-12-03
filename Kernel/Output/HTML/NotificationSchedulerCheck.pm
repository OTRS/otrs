# --
# Kernel/Output/HTML/NotificationSchedulerCheck.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::NotificationSchedulerCheck;

use strict;
use warnings;

use Kernel::System::Group;
use Kernel::System::PID;

use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject LayoutObject MainObject EncodeObject TimeObject UserID))
    {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # create additional objects
    $Self->{GroupObject} = Kernel::System::Group->new( %{$Self} );
    $Self->{PIDObject}   = Kernel::System::PID->new( %{$Self} );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # try to get scheduler PID
    my %PID = $Self->{PIDObject}->PIDGet(
        Name => 'otrs.Scheduler',
    );

    my %NotificationDetails;

    # check if scheduler process is registered in the DB
    if (%PID) {

        # get the PID update time
        my $PIDUpdateTime = $Self->{ConfigObject}->Get('Scheduler::PIDUpdateTime') || 60.0;

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
                Data     => '$Text{"Scheduler process is registered but might not be running."}',
            );
        }

        # otherwise send just a warning
        else {
            %NotificationDetails = (
                Priority => 'Info',
                Data =>
                    '$Text{"Scheduler process is registered but might not be running."}',
            );
        }
    }

    # otherwise scheduler is not running
    else {
        %NotificationDetails = (
            Priority => 'Error',
            Data     => '$Text{"Scheduler is not running."}',
        );
    }

    # check if user needs to be notified
    # get current user groups
    my %Groups = $Self->{GroupObject}->GroupMemberList(
        UserID => $Self->{UserID},
        Type   => 'move_into',
        Result => 'HASH',
    );

    # reverse groups hash for easy look up
    %Groups = reverse %Groups;

    # check if the user is in the Admin group
    # if that is the case, extend the error with a link
    if ( $Groups{admin} ) {
        $NotificationDetails{Link}      = '$Env{"Baselink"}Action=AdminScheduler';
        $NotificationDetails{LinkClass} = 'StartScheduler';
    }

    # if user is not admin, add 'Please contact your administrator' to error message
    else {
        $NotificationDetails{Data} .= " Please contact your administrator!";
    }

    # show error notification
    return $Self->{LayoutObject}->Notify(
        %NotificationDetails,
    );

}

1;
