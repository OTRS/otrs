# --
# Kernel/Scheduler/TaskHandler.pm - Scheduler task handler interface
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Scheduler::TaskHandler;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsHashRefWithData IsStringWithData);

use vars qw(@ISA);

=head1 NAME

Kernel::Scheduler::TaskHandler - Scheduler Task Handler interface

=head1 SYNOPSIS

The TaskHandler actually executes the tasks that were queued in the Scheduler.
For each different type of task, there is a separate backend that understands
how to execute this particular task.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object.

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Time;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::Scheduler::TaskHandler;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $OperationObject = Kernel::Scheduler::TaskHandler->new(
        ConfigObject       => $ConfigObject,
        LogObject          => $LogObject,
        DBObject           => $DBObject,
        MainObject         => $MainObject,
        TimeObject         => $TimeObject,
        EncodeObject       => $EncodeObject,

        TaskHandlerType    => 'GenericInterface'    # Type of the TaskHandler backend to use
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (qw(MainObject ConfigObject LogObject EncodeObject TimeObject DBObject)) {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    # check operation
    if ( !IsStringWithData( $Param{TaskHandlerType} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Got no Task Type with content!',
        );
        return;
    }

    # load backend module
    my $GenericModule = 'Kernel::Scheduler::TaskHandler::' . $Param{TaskHandlerType};
    if ( !$Self->{MainObject}->Require($GenericModule) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't load $Param{Type} task handler backend module!",
        );
        return;
    }
    $Self->{BackendObject} = $GenericModule->new( %{$Self} );

    return ( ref $Self->{BackendObject} eq $GenericModule ) ? $Self : undef;
}

=item Run()

performs the selected Task. This will be delegated to the TaskHandler
backend for the specific TaskHandlerType selected in the constructor.

    my $Result = $TaskHandlerObject->Run(
        Data     => {                          # task data, depends on TaskType
            ...
        },
    );

Returns:

    $Result = {
        Success    => 1,                       # 0 or 1
        ReSchedule => 0,                       # 0 or 1, determines if task needs to be re-scheduled
        DueTime    => '2011-01-19 23:59:59',   # (for re-scheduling only) DueTime for new task
        Data       => {                        # (for re-scheduling only) Data for new task
            ...
        },
    };

Note that task handler backends must implement this method with the same signature.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # check data - we need a hash ref
    if ( $Param{Data} && ref $Param{Data} ne 'HASH' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Got no valid Data!',
        );
        return;
    }

    return $Self->{BackendObject}->Run(%Param);
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=cut
