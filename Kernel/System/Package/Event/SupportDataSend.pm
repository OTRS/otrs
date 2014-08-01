# --
# Kernel/System/Ticket/Event/SupportDataSend.pm - event handler module for the package manager
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Package::Event::SupportDataSend;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::Log',
    'Kernel::System::Scheduler::TaskManager',
    'Kernel::System::SystemData',
    'Kernel::System::Time',
);
our $ObjectManagerAware = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Data Event Config)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # get system data object
    my $SystemDataObject = $Kernel::OM->Get('Kernel::System::SystemData');

    my $RegistrationState = $SystemDataObject->SystemDataGet(
        Key => 'Registration::State',
    ) || '';

    # do nothing if system is not register
    return 1 if $RegistrationState ne 'registered';

    my $SupportDataSending = $SystemDataObject->SystemDataGet(
        Key => 'Registration::SupportDataSending',
    ) || 'No';

    # return if Data Sending is not activated
    return 1 if $SupportDataSending ne 'Yes';

    # delete cache
    $Kernel::OM->Get('Kernel::System::Cache')->Delete(
        Type => 'SupportDataCollector',
        Key  => 'DataCollect',
    );

    # get time object
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    # calculate due date for next update, 1h
    my $NextUpdateSeconds = 3600;
    my $NewDueTime        = $TimeObject->SystemTime() + $NextUpdateSeconds;
    my $NewDueTimeStamp   = $TimeObject->SystemTime2TimeStamp(
        SystemTime => $NewDueTime,
    );

    # get task manager object
    my $TaskManagerObject = $Kernel::OM->Get('Kernel::System::Scheduler::TaskManager');

    my @TaskList = $TaskManagerObject->TaskList();

    if (@TaskList) {

        TASKITEM:
        for my $TaskItem (@TaskList) {

            if ( !IsHashRefWithData($TaskItem) ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => 'Got invalid task list entry!',
                );

                next TASKITEM;
            }

            if ( !$TaskItem->{Type} ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Task $TaskItem->{ID} has no type set!",
                );

                next TASKITEM;
            }

            next TASKITEM if $TaskItem->{Type} ne 'RegistrationUpdate';

            my $TaskTime = $TimeObject->TimeStamp2SystemTime(
                String => $TaskItem->{DueTime},
            );

            # if the task have a due time more than one hour update it to one hour
            if ( $TaskTime > $NewDueTime ) {
                my $UpdateResult = $TaskManagerObject->TaskUpdate(
                    %{$TaskItem},
                    DueTime => $NewDueTimeStamp,
                );

                if ( !$UpdateResult ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message =>
                            "Error while updating scheduler task for RegistrationUpdate: $TaskItem->{ID}!",
                    );
                    return;
                }

                return 1;
            }

            return 1;
        }
    }

    my $TaskID = $TaskManagerObject->TaskAdd(
        Type    => 'RegistrationUpdate',
        DueTime => $NewDueTimeStamp,
        Data    => {
            ReSchedule   => 1,
            EventTrigger => $Param{Event},

            # run the job as system user
            UserID => 1,
        },
    );

    if ( !$TaskID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Error while registering scheduler task for RegistrationUpdate!",
        );
        return;
    }

    return 1;
}

1;
