# --
# Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm - system data collector plugin
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::Database::postgresql::Version;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

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

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

1;
