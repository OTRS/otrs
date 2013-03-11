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
use Kernel::System::GenericInterface::Webservice;

use Kernel::System::VariableCheck qw(:all);

use vars qw($VERSION);

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
    $Self->{GroupObject}      = Kernel::System::Group->new( %{$Self} );
    $Self->{PIDObject}        = Kernel::System::PID->new( %{$Self} );
    $Self->{WebserviceObject} = Kernel::System::GenericInterface::Webservice->new( %{$Self} );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # TODO OTRS v3.1 will only use scheduler to handle GI Tasks, then it only make sense to
    # provide this alert is  if at least one valid web service is registered in the configuration
    # for further versions of OTRS this check can be removed if scheduler is used for other tasks

    # get valid web services list
    my $WebserviceList = $Self->{WebserviceObject}->WebserviceList( Valid => 1 );

    # return if the list is empty
    if ( !IsHashRefWithData($WebserviceList) ) {
        return '';
    }

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

    # cycle trough all registered groups
    GROUP:
    for my $Group ( sort keys %{ $Param{Config}->{NotifyGroups} } ) {
        next GROUP if !$Param{Config}->{NotifyGroups}->{$Group};

        # check if registered groups match one of the user groups
        if ( $Groups{$Group} ) {

            # show error notification, if scheduler is not running
            return $Self->{LayoutObject}->Notify(
                %NotificationDetails,
                Link      => '$Env{"Baselink"}Action=AdminScheduler',
                LinkClass => 'StartScheduler',
            );
            last GROUP;
        }
    }

    # return if no group matches
    return '';

}

1;
