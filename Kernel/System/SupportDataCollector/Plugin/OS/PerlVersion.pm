# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OS::PerlVersion;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::System::Main',
);

sub GetDisplayPath {
    return Translatable('Operating System');
}

sub Run {
    my $Self = shift;

    my $Version = sprintf "%vd", $^V;
    my $OS = $^O;

    $Self->AddResultInformation(
        Label => Translatable('Perl Version'),
        Value => "$Version ($OS)",
    );

    return $Self->GetResults();
}

1;
