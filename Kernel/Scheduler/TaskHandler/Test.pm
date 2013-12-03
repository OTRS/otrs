# --
# Kernel/Scheduler/TaskHandler/Test.pm - Scheduler task handler test backend
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Scheduler::TaskHandler::Test;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsHashRefWithData IsStringWithData);

=head1 NAME

Kernel::Scheduler::TaskHandler::Test - test backend of the TaskHandler for the Scheduler

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

usually, you want to create an instance of this
by using Kernel::Scheduler::TaskHandler->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (qw(MainObject ConfigObject LogObject DBObject TimeObject)) {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    return $Self;
}

=item Run()

performs the selected test task.

    my $Result = $TaskHandlerObject->Run(
        Data     => {
            File              => $Filename,        # optional, create file $FileName
            Success           => 1,                # 0 or 1, controls return value
            ReSchedule        => $ReSchedule,      # 0 or 1, controls re-scheduling
            ReScheduleDueTime => $TimeStamp,
            ReScheduleData    => $Data,
        },
    );

Returns:

    $Result = {
        Success    => 1,                     # 0 or 1
        ReSchedule => $ReSchedule,
        DueTime    => $TimeStamp,
        Data       => $Data
    };

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # check data - we need a hash ref
    if ( $Param{Data} && ref $Param{Data} ne 'HASH' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Got no valid Data!',
        );

        return {
            Success => 0,
        };
    }

    # create tmp file
    if ( $Param{Data}->{File} ) {
        my $Content = 123;
        return if !$Self->{MainObject}->FileWrite(
            Location => $Param{Data}->{File},
            Content  => \$Content,
        );
    }

    # re schedule with new time
    return {
        Success    => $Param{Data}->{Success},
        ReSchedule => $Param{Data}->{ReSchedule},
        DueTime    => $Param{Data}->{ReScheduleDueTime},
        Data       => $Param{Data}->{ReScheduleData},
    };
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
