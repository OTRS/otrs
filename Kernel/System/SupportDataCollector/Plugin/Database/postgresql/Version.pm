# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::Database::postgresql::Version;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

our @ObjectDependencies = (
    'Kernel::System::DB',
);

sub GetDisplayPath {
    return 'Database';
}

sub Run {
    my $Self = shift;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    if ( $DBObject->GetDatabaseFunction('Type') !~ m{^postgresql} ) {
        return $Self->GetResults();
    }

    my $Version = $DBObject->Version();
    if ( $Version =~ /^PostgreSQL (\d{1,3}).*$/ ) {
        if ( $1 > 7 ) {
            $Self->AddResultOk(
                Label => 'Database Version',
                Value => $Version,
            );
        }
        else {
            $Self->AddResultProblem(
                Label   => 'Database Version',
                Value   => $Version,
                Message => 'PostgreSQL 8.x or higher is required.'
            );
        }
    }
    else {
        $Self->AddResultProblem(
            Label   => 'Database Version',
            Value   => $Version,
            Message => 'Could not determine database version.'
        );
    }

    return $Self->GetResults();
}

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut

1;
