#!/usr/bin/perl
# --
# bin/otrs.CheckModules.pl - to check needed cpan framework modules
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
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

use strict;
use warnings;

use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';
use lib dirname($RealBin) . '/Custom';

# on Windows, we only have ANSI support if Win32::Console::ANSI is present
# turn off colors if it is not available
BEGIN {
    if ( $^O eq 'MSWin32' ) {
        ## no critic
        eval "use Win32::Console::ANSI";
        ## use critic
        $ARGV[0] = 'nocolors' if $@;
    }
}

use ExtUtils::MakeMaker;
use File::Path;
use Term::ANSIColor;

use vars qw($VERSION);

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
        Module   => 'Crypt::SSLeay',
        Required => 0,
        Comment  => 'Required for Generic Interface SOAP SSL connections.',
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
        Module       => 'DBD::ODBC',
        Required     => 0,
        NotSupported => [
            {
                Version => '1.23',
                Comment =>
                    'This version is broken and not useable! Please upgrade to a higher version.',
            },
        ],
        Comment => 'Required to connect to a MS-SQL database.',
    },
    {
        Module   => 'DBD::Oracle',
        Required => 0,
        Comment  => 'Required to connect to a Oracle database.',
    },
    {
        Module   => 'DBD::Pg',
        Required => 0,
        Comment  => 'Required to connect to a PostgreSQL database.',
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
        Module   => 'Digest::SHA',
        Required => 0,
        Comment  => 'Recommended for faster xml handling.',
    },
    {
        Module   => 'Encode::HanExtra',
        Version  => '0.23',
        Required => 0,
        Comment  => 'Required to handle mails with several Chinese character sets.',
    },
    {
        Module   => 'Encode::Locale',
        Required => 1,
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
                Comment  => 'Recommended for faster AJAX/JavaScript handling.',
            },
        ],
    },
    {
        Module   => 'Locale::Codes',
        Required => 1,
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
        Module   => 'Mail::IMAPClient',
        Comment  => 'Required for IMAP TLS connections.',
        Required => 0,
        Depends  => [
            {
                Module   => 'IO::Socket::SSL',
                Required => 0,
                Comment  => 'Required for IMAP TLS connections.',
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
    },
    {
        Module   => 'Net::IMAP::Simple',
        Comment  => 'Required for IMAP connections.',
        Required => 0,
        Depends  => [
            {
                Module   => 'IO::Socket::SSL',
                Required => 0,
                Comment  => 'Required for IMAP SSL connections.',
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
        Module   => 'Net::SSL',
        Required => 0,
        Comment  => 'Required for Generic Interface SOAP SSL connections.',
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
        Module   => 'Storable',
        Required => 1,
        Comment  => 'Required serialize and deserialize data structures.',
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
        Depends => [
            {
                Module   => 'version',
                Required => 0,
                Comment  => 'Required for SOAP::Lite.',
            },
            {
                Module   => 'Class::Inspector',
                Required => 0,
                Comment  => 'Required for SOAP::Lite.',
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
                Comment  => 'Recommended for faster CSV handling.',
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
        Comment  => 'Recommended for faster xml handling.',
    },
    {
        Module   => 'HTTP::Message',
        Required => 1,
        Comment  => 'Required for HTTP communication.',
        Depends  => [
            {
                Module       => 'HTTP::Headers',
                Required     => 1,
                Comment      => 'Required for HTTP communication.',
                NotSupported => [
                    {
                        Version => '1.64',
                        Comment =>
                            'This version is broken and not useable! '
                            . 'Please upgrade to a higher version.',
                    },
                ],
            },
        ],
        NotSupported => [
            {
                Version => '1.57',
                Comment =>
                    'This version is broken and not useable! '
                    . 'Please upgrade to a higher version.',
            },
        ],
    },
    {
        Module       => 'URI',
        Required     => 1,
        Comment      => 'Handles encoding and decoding of URLs',
        NotSupported => [
            {
                Version => '1.35',
                Comment =>
                    'This version is broken and not useable! Please upgrade to a higher version.',
            },
        ],
        Depends => [
            {
                Module   => 'URI::Escape',
                Required => 1,
                Comment  => 'Handles encoding and decoding of URLs.',
            },
        ],
    },
    {
        Module   => 'Scalar::Util',
        Required => 1,
    },
    {
        Module   => 'YAML::XS',
        Required => 1,
    },
);

# if we're on Windows we need some additional modules
if ( $^O eq "MSWin32" ) {
    my @WindowsModules = (
        {
            Module   => 'Win32::Daemon',
            Required => 1,
            Comment  => 'For running the OTRS Scheduler Service.',
        },
        {
            Module   => 'Win32::Service',
            Required => 1,
            Comment  => 'For running the OTRS Scheduler Service.',
        },
    );
    push @NeededModules, @WindowsModules;
}

my $Options = shift || '';
my $NoColors;
if ( $Options =~ m{\A nocolors}msxi ) {
    $NoColors = 1;
}

# try to determine module version number
my $Depends = 0;
for my $Module (@NeededModules) {
    _Check( $Module, $Depends, $NoColors );
}

exit;

sub _Check {
    my ( $Module, $Depends, $NoColors ) = @_;

    print "  " x ( $Depends + 1 );
    print "o $Module->{Module}";
    my $Length = 33 - ( length( $Module->{Module} ) + ( $Depends * 2 ) );
    print '.' x $Length;

    my $File = _InstalledFileForModule( $Module->{Module} );
    if ($File) {

        # determine version number by means of ExtUtils::MakeMaker
        my $Version = MM->parse_version($File);

        # cleanup version number
        my $CleanedVersion = _VersionClean(
            Version => $Version,
        );

        my $ErrorMessage;

        # test if all module dependencies are installed by requiring the module
        ## no critic
        if ( !eval "require $Module->{Module}" ) {
            $ErrorMessage .= 'Not all prerequisites for this module correctly installed. ';
        }
        ## use critic

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
                $ErrorMessage .= "Version $Version not supported! $NotSupported ";
            }
        }

        if ( $Module->{Version} ) {

            # cleanup item version number
            my $RequiredModuleVersion = _VersionClean(
                Version => $Module->{Version},
            );

            if ( $CleanedVersion < $RequiredModuleVersion ) {
                $ErrorMessage
                    .= "Version $Version installed but $Module->{Version} or higher is required! ";
            }
        }

        if ($ErrorMessage) {
            if ($NoColors) {
                print "FAILED! $ErrorMessage\n";
            }
            else {
                print color('red') . "FAILED!" . color('reset') . " $ErrorMessage\n";
            }
        }
        else {
            if ($NoColors) {
                print "ok (v$Version)\n";
            }
            else {
                print color('green') . "ok" . color('reset') . " (v$Version)\n";
            }
        }
    }
    else {
        my $Comment  = $Module->{Comment} || '';
        my $Required = $Module->{Required};
        my $Color    = 'yellow';
        if ($Required) {
            $Required = 'required - use "perl -MCPAN -e shell;"';
            $Color    = 'red';
        }
        else {
            $Required = 'optional';
        }
        if ($NoColors) {
            print "Not installed! ($Required - $Comment)\n";
        }
        else {
            print color($Color) . "Not installed!" . color('reset') . " ($Required - $Comment)\n";
        }
    }

    if ( $Module->{Depends} ) {
        for my $ModuleSub ( @{ $Module->{Depends} } ) {
            _Check( $ModuleSub, $Depends + 1, $NoColors );
        }
    }

    return 1;
}

sub _InstalledFileForModule {

    # copied from ExtUtils::MakeMaker; it is not available on the
    # old EU_MM versions that ship with Perl 5.8.
    my $Prereq = shift;
    my $File   = "$Prereq.pm";
    $File =~ s{::}{/}g;

    # traverse @INC to see if the current module is installed in
    # one of these locations
    my $Path;
    PATH:
    for my $Dir (@INC) {
        my $PossibleLocation = File::Spec->catfile( $Dir, $File );
        if ( -r $PossibleLocation ) {
            $Path = $PossibleLocation;
            last PATH;
        }
    }
    return $Path;
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
