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

use Kernel::Scheduler;
use Kernel::System::SystemData;
use Kernel::System::Scheduler::TaskManager;
use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Item (
        qw(ConfigObject LogObject DBObject MainObject EncodeObject TimeObject)
        )
    {
        $Self->{$Item} = $Param{$Item} || die "Got no $Item!";
    }

    # create extra objects
    $Self->{SchedulerObject}   = Kernel::Scheduler->new( %{$Self} );
    $Self->{TaskManagerObject} = Kernel::System::Scheduler::TaskManager->new( %{$Self} );
    $Self->{SystemDataObject}  = Kernel::System::SystemData->new(%Param);

    $Self->{RegistrationState} = $Self->{SystemDataObject}->SystemDataGet(
        Key => 'Registration::State',
    ) || '';
    $Self->{SupportDataSending} = $Self->{SystemDataObject}->SystemDataGet(
        Key => 'Registration::SupportDataSending',
    ) || 'No';

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Data Event Config)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # do nothing if system is not register
    return 1 if $Self->{RegistrationState} ne 'registered';

    # return if Data Sending is not activated
    return 1 if $Self->{SupportDataSending} ne 'Yes';

    # delete cache of data collector
    # in order to refresh packages list
    my $CacheModule = 'Kernel::System::Cache';

    # check if backend field exists
    if ( !$Self->{MainObject}->Require($CacheModule) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't load $CacheModule!",
        );
        return;
    }

    # create a cache object
    my $CacheObject = $CacheModule->new( %{$Self} );
    $CacheObject->Delete(
        Type => 'SupportDataCollector',
        Key  => 'DataCollect',
    );

    # calculate due date for next update, 1h
    my $NextUpdateSeconds = 3600;
    my $NewDueTime        = $Self->{TimeObject}->SystemTime() + $NextUpdateSeconds;
    my $NewDueTimeStamp   = $Self->{TimeObject}->SystemTime2TimeStamp(
        SystemTime => $NewDueTime,
    );

    my @TaskList = $Self->{TaskManagerObject}->TaskList();

    if (@TaskList) {

        TASKITEM:
        for my $TaskItem (@TaskList) {

            if ( !IsHashRefWithData($TaskItem) ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => 'Got invalid task list entry!',
                );

                next TASKITEM;
            }

            if ( !$TaskItem->{Type} ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Task $TaskItem->{ID} has no type set!",
                );

                next TASKITEM;
            }

            next TASKITEM if $TaskItem->{Type} ne 'RegistrationUpdate';

            my $TaskTime = $Self->{TimeObject}->TimeStamp2SystemTime(
                String => $TaskItem->{DueTime},
            );

            # if the task have a due time more than one hour update it to one hour
            if ( $TaskTime > $NewDueTime ) {
                my $UpdateResult = $Self->{TaskManagerObject}->TaskUpdate(
                    %{$TaskItem},
                    DueTime => $NewDueTimeStamp,
                );

                if ( !$UpdateResult ) {
                    $Self->{LogObject}->Log(
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

    my $TaskID = $Self->{TaskManagerObject}->TaskAdd(
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
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Error while registering scheduler task for RegistrationUpdate!",
        );
        return;
    }

    return 1;
}

1;
