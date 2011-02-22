# --
# Kernel/Scheduler/TaskHandler/Test.pm - Scheduler task handler test backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Test.pm,v 1.10 2011-02-22 23:45:56 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Scheduler::TaskHandler::Test;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsHashRefWithData IsStringWithData);

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.10 $) [1];

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
            File => $Filename,              # optional, create file $FileName
            Success => 1,                   # 0 or 1, controls return value
        },
    );

Returns:

    $Result = {
        Success    => 1,                       # 0 or 1
        ReSchedule => 0,                       # 0 or 1 # if task need to be re scheduled
        DueTime    => '2011-01-19 23:59:59',   # only apply if ReSchedule is equals to 1
        Data       => {                        # optional only apply if ReSchedule is equals to 1
            ...
        },
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
            Success    => 0,
            ReSchedule => 0,
            DueTime    => '',
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

    if ( $Param{Data}->{ReSchedule} ) {

        # log and exit succesfully
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => 'Test task execuded correctly with ReSchedule!',
        );

        # to store system time
        my $SystemTime = $Self->{TimeObject}->SystemTime();

        # to store new DueTime
        my $DueTime = $Self->{TimeObject}->SystemTime2TimeStamp(
            SystemTime => $SystemTime + 60,
        );

        # re schedule with new time
        return {
            Success    => 0,
            ReSchedule => 1,
            DueTime    => $DueTime,
            Data       => {},
        };
    }

    if ( !$Param{Data}->{Success} ) {

        # log and exit succesfully
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => 'Test task execuded correctly with false!',
        );
        return {
            Success    => 0,
            ReSchedule => 0,
            DueTime    => '',
        };
    }

    # log and exit succesfully
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message  => 'Test task execuded correctly with true!',
    );
    return {
        Success => 1,
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

=head1 VERSION

$Revision: 1.10 $ $Date: 2011-02-22 23:45:56 $

=cut
