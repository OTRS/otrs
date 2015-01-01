# --
# Kernel/System/SupportDataCollector/Plugin/Database/oracle/Version.pm - system data collector plugin
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::Database::oracle::Version;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

sub GetDisplayPath {
    return 'Database';
}

sub Run {
    my $Self = shift;

    if ( $Self->{DBObject}->GetDatabaseFunction('Type') ne 'oracle' ) {
        return $Self->GetResults();
    }

    # version check
    my $Version = $Self->{DBObject}->Version();

    if ($Version) {
        $Self->AddResultInformation(
            Label => 'Database Version',
            Value => $Version,
        );
    }
    else {
        $Self->AddResultProblem(
            Label   => 'Database Version',
            Value   => $Version,
            Message => "Could not determine database version.",
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
