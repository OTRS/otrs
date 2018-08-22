# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::Database::mysql::Version;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

sub GetDisplayPath {
    return 'Database';
}

sub Run {
    my $Self = shift;

    if ( $Self->{DBObject}->GetDatabaseFunction('Type') ne 'mysql' ) {
        return $Self->GetResults();
    }

    # version check
    my $Version = $Self->{DBObject}->Version();

    if ( $Version =~ /^(MySQL|MariaDB) (\d{1,3})\.(\d{1,3}).*/ ) {
        if ( $2 >= 5 ) {
            $Self->AddResultOk(
                Label => 'Database Version',
                Value => $Version,
            );
        }
        else {
            $Self->AddResultProblem(
                Label   => 'Database Version',
                Value   => $Version,
                Message => "MySQL 5.x or higher is required.",
            );
        }
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

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut

1;
