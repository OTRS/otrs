# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OS::PerlModules;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
);

sub GetDisplayPath {
    return Translatable('Operating System');
}

sub Run {
    my $Self = shift;

    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    my $Output;
    open( my $FH, "-|", "perl $Home/bin/otrs.CheckModules.pl nocolors --all" );

    while (<$FH>) {
        $Output .= $_;
    }
    close($FH);

    if (
        $Output =~ m{Not \s installed! \s \(required}ismx
        || $Output =~ m{failed!}ismx
        )
    {
        $Self->AddResultProblem(
            Label   => Translatable('Perl Modules'),
            Value   => $Output,
            Message => Translatable('Not all required Perl modules are correctly installed.'),
        );
    }
    else {
        $Self->AddResultOk(
            Label => Translatable('Perl Modules'),
            Value => $Output,
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
