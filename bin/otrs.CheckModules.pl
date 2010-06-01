#!/usr/bin/perl -w
# --
# bin/otrs.CheckModules.pl - to check needed cpan framework modules
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: otrs.CheckModules.pl,v 1.2 2010-06-01 13:56:56 mg Exp $
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
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
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
        Version  => 3.33,
        Required => 1,
    },
    {
        Module   => 'Date::Pcalc',
        Required => 1,
    },
    {
        Module   => 'Date::Format',
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
        Module   => 'CSS::Minifier',
        Required => 1,
    },
    {
        Module   => 'Crypt::PasswdMD5',
        Required => 1,
    },
    {
        Module   => 'LWP::UserAgent',
        Required => 1,
    },
    {
        Module   => 'Encode::HanExtra',
        Version  => 0.23,
        Required => 0,
        Comment  => 'Required to handle mails with several Chinese character sets.',
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
        Required => 1,
    },
    {
        Module   => 'MIME::Base64',
        Required => 1,
    },
    {
        Module   => 'Mail::Internet',
        Required => 1,
    },
    {
        Module   => 'MIME::Tools',
        Required => 1,
        Version  => '5.427',
    },
    {
        Module       => 'Net::DNS',
        Required     => 1,
        NotSupported => [
            {
                Version => 0.60,
                Comment =>
                    'This version is broken and not useable, please upgrade to a higher version!',
            },
        ],
    },
    {
        Module   => 'Net::POP3',
        Comment  => 'for POP3 connections',
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
        Module   => 'Mail::POP3Client',
        Comment  => 'for POP3 SSL connections',
        Required => 0,
        Depends  => [
            {
                Module   => 'IO::Socket::SSL',
                Required => 0,
                Comment  => 'for POP3 SSL connections',
            },
        ],
    },
    {
        Module   => 'Net::IMAP::Simple',
        Comment  => 'for IMAP connections',
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
        ],
    },
    {
        Module   => 'Net::LDAP',
        Required => 0,
        Comment  => 'Required for directory authentication.',
    },
    {
        Module   => 'GD',
        Required => 0,
        Comment  => 'for stats',
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
        Module       => 'PDF::API2',
        Version      => 0.57,
        Required     => 0,
        Comment      => 'Required for PDF output.',
        NotSupported => [
            {
                Version => '0.71.001',
                Comment =>
                    'This version is broken and not useable, please upgrade to a higher version!',
            },
            {
                Version => '0.72.001',
                Comment =>
                    'This version is broken and not useable, please upgrade to a higher version!',
            },
            {
                Version => '0.72.002',
                Comment =>
                    'This version is broken and not useable, please upgrade to a higher version!',
            },
            {
                Version => '0.72.003',
                Comment =>
                    'This version is broken and not useable, please upgrade to a higher version!',
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
        Module   => 'SOAP::Lite',
        Required => 0,
        Comment  => 'Required for the SOAP interface.',
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
