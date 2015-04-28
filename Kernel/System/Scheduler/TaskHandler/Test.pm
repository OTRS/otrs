# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Scheduler::TaskHandler::Test;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::Main',
);

=head1 NAME

Kernel::System::Scheduler::TaskHandler::Test - test backend of the TaskHandler for the Scheduler

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

usually, you want to create an instance of this
by using Kernel::System::Scheduler::TaskHandler->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
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
        return if !$Kernel::OM->Get('Kernel::System::Main')->FileWrite(
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
