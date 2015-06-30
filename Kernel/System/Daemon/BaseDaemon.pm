# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Daemon::BaseDaemon;

use strict;
use warnings;

=head1 NAME

Kernel::System::Daemon::BaseDaemon - daemon base class

=head1 SYNOPSIS

Base class for daemon modules.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item PreRun()

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

=item Run()

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

=item PostRun()

Perform additional cleanups and wait times after Run().

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

=item Summary()

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
            NoDataMesssage => "Message if there is no data",
        },
    );

Override this method in your daemons.

=cut

sub Summary {
    my ( $Self, %Param ) = @_;

    return ();
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
