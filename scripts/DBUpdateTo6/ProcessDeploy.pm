# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::DBUpdateTo6::ProcessDeploy;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::ProcessManagement::DB::Process',
    'Kernel::System::ProcessManagement::DB::Entity',
);

=head1 NAME

scripts::DBUpdateTo6::ProcessDeploy - Deploy the process management configuration.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Location = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/Kernel/Config/Files/ZZZProcessManagement.pm';

    my $ProcessDump = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process')->ProcessDump(
        ResultType => 'FILE',
        Location   => $Location,
        UserID     => 1,
    );

    if ( !$ProcessDump ) {
        print "\t - There was an error synchronizing the processes.\n\n";
        return;
    }

    my $Success = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Entity')->EntitySyncStatePurge(
        UserID => 1,
    );
    if ( !$Success ) {
        print "\t - There was an error setting the entity sync status.\n\n";
        return;
    }

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
