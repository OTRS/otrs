# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::Database::mysql::Version;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::System::DB',
);

sub GetDisplayPath {
    return Translatable('Database');
}

sub Run {
    my $Self = shift;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    if ( $DBObject->GetDatabaseFunction('Type') ne 'mysql' ) {
        return $Self->GetResults();
    }

    # version check
    my $Version = $DBObject->Version();

    if ( $Version =~ /^(MySQL|MariaDB) (\d{1,3})\.(\d{1,3}).*/ ) {
        if ( $2 >= 5 ) {
            $Self->AddResultOk(
                Label => Translatable('Database Version'),
                Value => $Version,
            );
        }
        else {
            $Self->AddResultProblem(
                Label   => Translatable('Database Version'),
                Value   => $Version,
                Message => Translatable("MySQL 5.x or higher is required."),
            );
        }
    }
    else {
        $Self->AddResultProblem(
            Label   => Translatable('Database Version'),
            Value   => $Version,
            Message => Translatable("Could not determine database version."),
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
