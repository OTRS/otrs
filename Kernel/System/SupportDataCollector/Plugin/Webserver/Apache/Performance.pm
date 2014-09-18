# --
# Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm - system data collector plugin
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::Webserver::Apache::Performance;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

our @ObjectDependencies = ();

sub GetDisplayPath {
    return 'Webserver';
}

sub Run {
    my $Self = shift;

    my %Environment = %ENV;

    # No apache webserver, skip this check
    if ( !$ENV{SERVER_SOFTWARE} || $ENV{SERVER_SOFTWARE} !~ m{apache}i ) {
        return $Self->GetResults();
    }

    my @Result;

    # Check for CGI accelerator
    if ( $ENV{MOD_PERL} ) {
        $Self->AddResultOk(
            Identifier => "CGIAcceleratorUsed",
            Label      => 'CGI Accelerator Usage',
            Value      => $ENV{MOD_PERL},
        );
    }
    elsif ( $INC{'CGI/Fast.pm'} || $ENV{FCGI_ROLE} || $ENV{FCGI_SOCKET_PATH} ) {
        $Self->AddResultOk(
            Identifier => "CGIAcceleratorUsed",
            Label      => 'CGI Accelerator Usage',
            Value      => 'fastcgi',
        );
    }
    else {
        $Self->AddResultWarning(
            Identifier => "CGIAcceleratorUsed",
            Label      => 'CGI Accelerator Usage',
            Value      => '',
            Message    => 'You should use FastCGI or mod_perl to increase your performance.',
        );
    }

    if ( $ENV{MOD_PERL} ) {
        my $ModDeflateLoaded =
            Apache2::Module::loaded('mod_deflate.c') || Apache2::Module::loaded('mod_deflate.so');

        if ($ModDeflateLoaded) {
            $Self->AddResultOk(
                Identifier => "ModDeflateLoaded",
                Label      => 'mod_deflate Usage',
                Value      => 'active',
            );
        }
        else {
            $Self->AddResultWarning(
                Identifier => "ModDeflateLoaded",
                Label      => 'mod_deflate Usage',
                Value      => 'not active',
                Message    => 'Please install mod_deflate to improve GUI speed.',
            );
        }

        my $ModHeadersLoaded =
            Apache2::Module::loaded('mod_headers.c') || Apache2::Module::loaded('mod_headers.so');

        if ($ModHeadersLoaded) {
            $Self->AddResultOk(
                Identifier => "ModHeadersLoaded",
                Label      => 'mod_headers Usage',
                Value      => 'active',
            );
        }
        else {
            $Self->AddResultWarning(
                Identifier => "ModHeadersLoaded",
                Label      => 'mod_headers Usage',
                Value      => 'not active',
                Message    => 'Please install mod_headers to improve GUI speed.',
            );
        }

        # check if Apache::Reload is loaded
        my $ApacheReloadUsed = 0;
        for my $Module ( sort keys %INC ) {
            $Module =~ s/\//::/g;
            $Module =~ s/\.pm$//g;
            if ( $Module eq 'Apache::Reload' || $Module eq 'Apache2::Reload' ) {
                $ApacheReloadUsed = $Module;
            }
        }

        if ($ApacheReloadUsed) {
            $Self->AddResultOk(
                Identifier => "ApacheReloadUsed",
                Label      => 'Apache::Reload Usage',
                Value      => 'active',
            );
        }
        else {
            $Self->AddResultWarning(
                Identifier => "ApacheReloadUsed",
                Label      => 'Apache::Reload Usage',
                Value      => 'not active',
                Message =>
                    'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.',
            );
        }

        my $ApacheDBIUsed;
        for my $Module ( sort keys %INC ) {
            $Module =~ s/\//::/g;
            $Module =~ s/\.pm$//g;
            if ( $Module eq 'Apache::DBI' || $Module eq 'Apache2::DBI' ) {
                $ApacheDBIUsed = $Module;
            }
        }

        if ($ApacheDBIUsed) {
            $Self->AddResultOk(
                Identifier => "ApacheDBIUsed",
                Label      => 'Apache2::DBI Usage',
                Value      => 'active',
            );
        }
        else {
            $Self->AddResultWarning(
                Identifier => "ApacheDBIUsed",
                Label      => 'Apache2::DBI Usage',
                Value      => 'not active',
                Message =>
                    'Apache2::DBI should be used to get a better performance  with pre-established database connections.',
            );
        }

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
