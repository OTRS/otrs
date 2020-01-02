# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OS::PerlModulesAudit;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::System::Console::Command::Dev::Code::CPANAudit',
    'Kernel::System::Log',
);

sub GetDisplayPath {
    return Translatable('Operating System');
}

sub Run {
    my $Self = shift;

    my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Dev::Code::CPANAudit');

    my ( $CommandOutput, $ExitCode );

    {
        local *STDOUT;
        open STDOUT, '>:utf8', \$CommandOutput;    ## no critic
        $ExitCode = $CommandObject->Execute();
    }

    if ( $ExitCode != 0 ) {
        $Self->AddResultWarning(
            Label   => Translatable('Perl Modules Audit'),
            Value   => $CommandOutput,
            Message => Translatable(
                'CPAN::Audit reported that one or more installed Perl modules have known vulnerabilities. Please note that there might be false positives for distributions patching Perl modules without changing their version number.'
            ),
        );
    }
    else {
        $Self->AddResultOk(
            Label => Translatable('Perl Modules Audit'),
            Value => '',
            Message =>
                Translatable('CPAN::Audit did not report any known vulnerabilities in the installed Perl modules.'),
        );
    }

    return $Self->GetResults();
}

1;
