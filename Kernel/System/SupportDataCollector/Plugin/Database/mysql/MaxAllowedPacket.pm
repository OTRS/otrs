# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::Database::mysql::MaxAllowedPacket;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

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

    $DBObject->Prepare( SQL => "show variables like 'max_allowed_packet'" );
    while ( my @Row = $DBObject->FetchrowArray() ) {

        if (
            !$Row[1]
            || $Row[1] < 1024 * 1024 * 64
            )
        {
            $Self->AddResultProblem(
                Label => Translatable('Maximum Query Size'),
                Value => $Row[1] / 1024 / 1024 . ' MB',
                Message =>
                    Translatable("The setting 'max_allowed_packet' must be higher than 64 MB."),
            );
        }
        else {
            $Self->AddResultOk(
                Label => Translatable('Maximum Query Size'),
                Value => $Row[1] / 1024 / 1024 . ' MB',
            );
        }
    }

    return $Self->GetResults();
}

1;
