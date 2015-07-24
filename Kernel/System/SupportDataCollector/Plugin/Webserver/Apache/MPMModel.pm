# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::Webserver::Apache::MPMModel;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = ();

sub GetDisplayPath {
    return Translatable('Webserver');
}

sub Run {
    my $Self = shift;

    my %Environment = %ENV;

    # No apache webserver with mod_perl, skip this check
    if ( !$ENV{SERVER_SOFTWARE} || $ENV{SERVER_SOFTWARE} !~ m{apache}i || !$ENV{MOD_PERL} ) {
        return $Self->GetResults();
    }

    my $MPMModel;
    my %KnownModels = (
        'worker.c'  => 1,
        'prefork.c' => 1,
        'event.c'   => 1,
    );

    MODULE:
    for ( my $Module = Apache2::Module::top_module(); $Module; $Module = $Module->next() ) {
        if ( $KnownModels{ $Module->name() } ) {
            $MPMModel = $Module->name();
        }
    }

    if ( $MPMModel eq 'prefork.c' ) {
        $Self->AddResultOk(
            Identifier => 'MPMModel',
            Label      => Translatable('MPM model'),
            Value      => $MPMModel,
        );
    }
    else {
        $Self->AddResultProblem(
            Identifier => 'MPMModel',
            Label      => Translatable('MPM model'),
            Value      => $MPMModel,
            Message    => Translatable("OTRS requires apache to be run with the 'prefork' MPM model."),
        );
    }

    return $Self->GetResults()
}

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

1;
