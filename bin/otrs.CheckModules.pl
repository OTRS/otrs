#!/usr/bin/perl -w
# --
# bin/otrs.CheckModules.pl - to check needed cpan framework modules
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: otrs.CheckModules.pl,v 1.14.2.4 2012-12-11 16:04:25 mg Exp $
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU AFFERO General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';

# config
my @NeededModules = (
    {
        Module   => 'CGI',
        Version  => '3.33',
        Required => 1,
    },
    {
        Module   => 'Crypt::PasswdMD5',
        Required => 1,
    },
    {
        Module   => 'CSS::Minifier',
        Required => 1,
    },
    {
        Module   => 'Date::Format',
        Required => 1,
    },
    {
        Module   => 'Date::Pcalc',
        Required => 1,
    },
    {
        Module   => 'DBI',
        Required => 1,
    },
    {
        Module   => 'DBD::mysql',
        Required => 0,
        Comment  => 'Required to connect to a MySQL database.',
    },
    {
        Module   => 'Digest::MD5',
        Required => 1,
    },
    {
        Module   => 'Digest::SHA::PurePerl',
        Version  => '5.48',
        Required => 1,
        Comment  => 'Required to authenticate users and customers using SHA-1 or SHA-2 methods',
    },
    {
        Module   => 'Encode::HanExtra',
        Version  => '0.23',
        Required => 0,
        Comment  => 'Required to handle mails with several Chinese character sets.',
    },
    {
        Module   => 'GD',
        Required => 0,
        Comment  => 'Required for stats',
        Depends  => [
            {
                Module   => 'GD::Text',
                Required => 0,
                Comment  => 'Required for stats.',
            },
            {
                Module   => 'GD::Graph',
                Required => 0,
                Comment  => 'Required for stats.',
            },
            {
                Module   => 'GD::Graph::lines',
                Required => 0,
                Comment  => 'Required for stats.',
            },
            {
                Module   => 'GD::Text::Align',
                Required => 0,
                Comment  => 'Required for stats.',
            },
        ],
    },
    {
        Module   => 'IO::Scalar',
        Required => 1,
    },
    {
        Module   => 'IO::Wrap',
        Required => 1,
    },
    {
        Module   => 'JavaScript::Minifier',
        Version  => '1.05',
        Required => 1,
    },
    {
        Module   => 'JSON',
        Version  => '2.21',
        Required => 1,
        Comment  => 'Required for AJAX/JavaScript handling.',
        Depends  => [
            {
                Module   => 'JSON::PP',
                Version  => '2.27003',
                Required => 1,
                Comment  => 'Required for AJAX/JavaScript handling.',
            },
            {
                Module   => 'JSON::XS',
                Required => 0,
                Comment  => 'Install it for faster AJAX/JavaScript handling.',
            },
        ],
    },
    {
        Module   => 'LWP::UserAgent',
        Required => 1,
    },
    {
        Module   => 'Mail::Internet',
        Required => 1,
    },
    {
        Module   => 'Mail::POP3Client',
        Comment  => 'Required for POP3 SSL connections.',
        Required => 0,
        Depends  => [
            {
                Module   => 'IO::Socket::SSL',
                Required => 0,
                Comment  => 'Required for POP3 SSL connections.',
            },
        ],
    },
    {
        Module   => 'MIME::Base64',
        Required => 1,
    },
    {
        Module   => 'MIME::Tools',
        Version  => '5.427',
        Required => 1,
    },
    {
        Module   => 'ModPerl::Util',
        Required => 0,
        Comment  => 'Improves Performance on Apache webservers dramatically.',
        Depends  => [
            {
                Module   => 'Apache::DBI',
                Required => 0,
                Comment =>
                    'Improves performance on Apache webservers with mod_perl by establishing persistent database connections.'
            },
            {
                Module   => 'Apache2::Reload',
                Required => 0,
                Comment =>
                    'Should be installed on mod_perl based installations to automatically reload changed Perl files and configuration data.'
            },
        ],
    },
    {
        Module       => 'Net::DNS',
        Required     => 1,
        NotSupported => [
            {
                Version => '0.60',
                Comment =>
                    'This version is broken and not useable! Please upgrade to a higher version.',
            },
        ],
    },
    {
        Module   => 'Net::POP3',
        Comment  => 'Required for POP3 connections.',
        Required => 1,

        # Moved to Mail::POP3Client because of SSL problems
        #        Depends  => [
        #            {
        #                Module   => 'Net::POP3::SSLWrapper',
        #                Required => 0,
        #                Comment  => 'Required for SSL connections.',
        #            },
        #        ],
    },
    {
        Module   => 'Net::IMAP::Simple',
        Comment  => 'Required for IMAP connections.',
        Required => 0,
        Depends  => [
            {
                Module   => 'Net::IMAP::Simple::SSL',
                Required => 0,
                Comment  => 'Required for SSL connections.',
            },
        ],
    },
    {
        Module   => 'Net::SMTP',
        Required => 0,
        Comment  => 'Required for SMTP connections.',
        Depends  => [
            {
                Module   => 'Authen::SASL',
                Required => 0,
                Comment  => 'Required for SMTP backend.',
            },
            {
                Module   => 'Net::SMTP::SSL',
                Required => 0,
                Comment  => 'Required for SSL/SMTPS connections.',
            },
            {
                Module   => 'Net::SMTP::TLS::ButMaintained',
                Required => 0,
                Comment  => 'Required for TLS/SMTP connections.',
            },
        ],
    },
    {
        Module   => 'Net::LDAP',
        Required => 0,
        Comment  => 'Required for directory authentication.',
    },
    {
        Module       => 'PDF::API2',
        Version      => '0.57',
        Required     => 0,
        Comment      => 'Required for PDF output.',
        NotSupported => [
            {
                Version => '0.71.001',
                Comment =>
                    'This version is broken and not useable! Please upgrade to a higher version.',
            },
            {
                Version => '0.72.001',
                Comment =>
                    'This version is broken and not useable! Please upgrade to a higher version.',
            },
            {
                Version => '0.72.002',
                Comment =>
                    'This version is broken and not useable! Please upgrade to a higher version.',
            },
            {
                Version => '0.72.003',
                Comment =>
                    'This version is broken and not useable! Please upgrade to a higher version.',
            },
        ],
        Depends => [
            {
                Module   => 'Compress::Zlib',
                Required => 0,
                Comment  => 'Required for PDF output.',
            },
        ],
    },
    {
        Module       => 'SOAP::Lite',
        Required     => 0,
        Comment      => 'Required for the SOAP interface.',
        NotSupported => [
            {
                Version => '0.710',
                Comment =>
                    'This version is broken and not useable! Please use another version.',
            },
            {
                Version => '0.711',
                Comment =>
                    'This version is broken and not useable! Please use another version.',
            },
            {
                Version => '0.712',
                Comment =>
                    'This version is broken and not useable! Please use another version.',
            },
        ],
    },
    {
        Module   => 'Text::CSV',
        Required => 1,
        Comment  => 'Required for CSV handling.',
        Depends  => [
            {
                Module   => 'Text::CSV_PP',
                Required => 1,
                Comment  => 'Required for CSV handling.',
            },
            {
                Module   => 'Text::CSV_XS',
                Required => 0,
                Comment  => 'Optional, install it for faster CSV handling.',
            },
        ],
    },
    {
        Module   => 'Time::HiRes',
        Required => 1,
        Comment  => 'Required for high resolution timestamps.',
    },
    {
        Module   => 'XML::Parser',
        Required => 0,
        Comment  => 'Required for faster xml handling.'
    },
);

# try to load modules
my $Depends = 0;
foreach my $Module (@NeededModules) {
    _Check( $Module, $Depends );
}
exit;

sub _Check {
    my ( $Module, $Depends ) = @_;

    for ( 0 .. $Depends ) {
        print "   ";
    }
    print "o $Module->{Module}";
    my $Length = length( $Module->{Module} ) + ( $Depends * 3 );
    for ( $Length .. 30 ) {
        print ".";
    }
    if ( eval "require $Module->{Module}" ) {

        # some strange CPAN module do not export VERSION
        my $Version = eval "\$$Module->{Module}::Version::VERSION";

        # ask for CPAN module VERSION
        if ( !$Version ) {
            $Version = eval "\$$Module->{Module}::VERSION";
        }

        # cleanup version number
        my $CleanedVersion = _VersionClean(
            Version => $Version,
        );

        if ( $Module->{NotSupported} ) {

            my $NotSupported = 0;
            ITEM:
            for my $Item ( @{ $Module->{NotSupported} } ) {

                # cleanup item version number
                my $ItemVersion = _VersionClean(
                    Version => $Item->{Version},
                );

                if ( $CleanedVersion == $ItemVersion ) {
                    $NotSupported = $Item->{Comment};
                    last ITEM;
                }
            }

            if ($NotSupported) {
                print "failed!!! Version $Version not supported! $NotSupported\n";
                return;
            }
        }

        if ( $Module->{Version} ) {

            # cleanup item version number
            my $ModuleVersion = _VersionClean(
                Version => $Module->{Version},
            );

            if ( $CleanedVersion >= $ModuleVersion ) {
                print "ok (v$Version)\n";
            }
            else {
                print
                    "failed!!! Version $Version installed but $Module->{Version} or higher is required!\n";
            }
        }
        else {
            print "ok (v$Version)\n";
        }
    }
    else {
        my $Comment = $Module->{Comment} || '';
        my $Required = $Module->{Required};
        if ($Required) {
            $Required = 'Required - use "perl -MCPAN -e shell;"';
        }
        else {
            $Required = 'Optional';
        }
        print "Not installed! ($Required - $Comment)\n";
    }

    if ( $Module->{Depends} ) {
        for my $ModuleSub ( @{ $Module->{Depends} } ) {
            _Check( $ModuleSub, $Depends + 1 );
        }
    }

    return 1;
}

sub _VersionClean {
    my (%Param) = @_;

    return 0 if !$Param{Version};

    # replace all special characters with an dot
    $Param{Version} =~ s{ [_-] }{.}xmsg;

    my @VersionParts = split q{\.}, $Param{Version};

    my $CleanedVersion = '';
    for my $Count ( 0 .. 4 ) {
        $VersionParts[$Count] ||= 0;
        $CleanedVersion .= sprintf "%04d", $VersionParts[$Count];
    }

    return int $CleanedVersion;
}

exit 0;
