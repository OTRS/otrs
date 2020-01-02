# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Daemon::BaseDaemon;

use strict;
use warnings;

=head1 NAME

Kernel::System::Daemon::BaseDaemon - daemon base class

=head1 DESCRIPTION

Base class for daemon modules.

=head1 PUBLIC INTERFACE

=head2 PreRun()

Perform additional validations/preparations and wait times before Run().

Override this method in your daemons.

If this method returns true, execution will be continued. If it returns false,
the main daemon aborts at this point, and Run() will not be called and the complete
daemon module dies waiting to be recreated again in the next loop.

=cut

sub PreRun {
    my ( $Self, %Param ) = @_;

    return 1;
}

=head2 Run()

Runs the daemon.

Override this method in your daemons.

If this method returns true, execution will be continued. If it returns false, the
main daemon aborts at this point, and PostRun() will not be called and the complete
daemon module dies waiting to be recreated again in the next loop.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    return 1;
}

=head2 PostRun()

Perform additional clean-ups and wait times after Run().

Override this method in your daemons.

If this method returns true, execution will be continued. If it returns false, the
main daemon aborts at this point, and PreRun() will not be called again and the
complete daemon module dies waiting to be recreated again in the next loop.

=cut

sub PostRun {
    my ( $Self, %Param ) = @_;

    sleep 1;

    return 1;
}

=head2 Summary()

Provides a summary of what is the daemon doing in the current time, the summary is in form of tabular
data and it must contain a header, the definition of the columns, the data, and a message if there
was no data.

    my @Summary = $DaemonObject->Summary();

returns

    @Summary = (
        {
            Header => 'Header Message',
            Column => [
                {
                    Name        => 'somename',
                    DisplayName => 'some name',
                    Size        => 40,
                },
                # ...
            ],
            Data => [
                {
                    somename => $ScalarValue,
                    # ...
                },
                # ...
            ],
            NoDataMessage => "Show this message if there is no data.",
        },
    );

Override this method in your daemons.

=cut

sub Summary {
    my ( $Self, %Param ) = @_;

    return ();
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
