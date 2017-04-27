# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::DBUpdateTo6::MigrateGenericAgentJobs;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::GenericAgent',
);

=head1 NAME

scripts::DBUpdateTo6::MigrateGenericAgentJobs - Migrate GA job configurations to new ticket search article field names.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $GenericAgentObject = $Kernel::OM->Get('Kernel::System::GenericAgent');

    my %Jobs = $GenericAgentObject->JobList();

    my $JobsUpdated;

    JOB:
    for my $JobName ( sort keys %Jobs ) {
        my %Job = $GenericAgentObject->JobGet( Name => $JobName );

        my $UpdateNeeded;

        # Rename old-style article fields in search parameters.
        my %KeyMap = (
            Body    => 'MIMEBase_Body',
            Cc      => 'MIMEBase_Cc',
            From    => 'MIMEBase_From',
            Subject => 'MIMEBase_Subject',
            To      => 'MIMEBase_To',
        );
        KEY:
        for my $Key ( sort keys %KeyMap ) {
            next KEY if !$KeyMap{$Key};

            $Job{ $KeyMap{$Key} } = $Job{$Key};
            delete $Job{$Key};

            $UpdateNeeded = 1;
        }

        next JOB if !$UpdateNeeded;

        # First, delete the old job configuration.
        my $Success = $GenericAgentObject->JobDelete(
            Name   => $JobName,
            UserID => 1,
        );
        if ( !$Success ) {
            print "\nCould not delete generic agent job '$JobName'.\n";
            return;
        }

        # Then, re-add the job configuration.
        $Success = $GenericAgentObject->JobAdd(
            Name   => $JobName,
            Data   => \%Job,
            UserID => 1,
        );
        if ( !$Success ) {
            print "\nCould not update generic agent job '$JobName'.\n";
            return;
        }

        $JobsUpdated = 1;
    }

    # Delete generic agent cache if at least one job was updated.
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'GenericAgent' ) if $JobsUpdated;

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
