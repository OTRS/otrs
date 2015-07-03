#!/usr/bin/perl
# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
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

use Kernel::System::Environment;
use Kernel::System::VariableCheck qw( :all );

# on Windows, we only have ANSI support if Win32::Console::ANSI is present
# turn off colors if it is not available
BEGIN {
    if ( $^O eq 'MSWin32' ) {
        ## no critic
        eval 'use Win32::Console::ANSI';
        ## use critic
        $ENV{nocolors} = 1 if $@;
    }
}

use Linux::Distribution;
use ExtUtils::MakeMaker;
use File::Path;
use Getopt::Long;
use Term::ANSIColor;

our %InstTypeToCMD = (

    # [InstType] => {
    #    CMD       => '[cmd to install module]',
    #    UseModule => 1/0,
    # }
    # Set UseModule to 1 if you want to use the
    # cpan module name of the package as replace string.
    # e.g. yum install "perl(Date::Format)"
    # If you set it 0 it will use the name
    # for the InstType of the module
    # e.g. apt-get install -y libtimedate-perl
    # and as fallback the default cpan install command
    # e.g. cpan DBD::Oracle
    aptget => {
        CMD       => 'apt-get install -y %s',
        UseModule => 0,
    },
    emerge => {
        CMD       => 'emerge %s',
        UseModule => 0,
    },
    ppm => {
        CMD       => 'ppm install %s',
        UseModule => 0,
    },
    yum => {
        CMD       => 'yum install "%s"',
        SubCMD    => 'perl(%s)',
        UseModule => 1,
    },
    zypper => {
        CMD       => 'zypper install %s',
        UseModule => 0,
    },
    default => {
        CMD => 'cpan %s',
    },
);

our %DistToInstType = (

    # apt-get
    debian => 'aptget',
    ubuntu => 'aptget',

    # emerge
    # for reasons unknown, some environments return "gentoo" (incl. the quotes)
    '"gentoo"' => 'emerge',
    gentoo     => 'emerge',

    # yum
    centos => 'yum',
    fedora => 'yum',
    rhel   => 'yum',
    redhat => 'yum',

    # zypper
    suse => 'zypper',

    # ppm
    win32as => 'ppm',
);

our $OSDist = Linux::Distribution::distribution_name() || '';

# set win32as if active state perl is installed on windows.
# for windows installations without active state perl we use the default.
if ( _CheckActiveStatePerl() ) {
    $OSDist = 'win32as';
}

my $AllModules;
my $PackageList;
my $Help;
GetOptions(
    all  => \$AllModules,
    list => \$PackageList,
    h    => \$Help
);

# check needed params
if ($Help) {
    print "otrs.CheckModules.pl - OTRS CheckModules\n";
    print "Copyright (C) 2001-2015 OTRS AG, http://otrs.com/\n";
    print "usage: otrs.CheckModules.pl [-list|all] \n";
    print "
   otrs.CheckModules.pl
       Returns all required and optional packages of OTRS.\n";
    print "
   otrs.CheckModules.pl -list
       Returns a install command with all required packages.\n";
    print "
   otrs.CheckModules.pl -all
       Returns all required, optional and bundled packages of OTRS.\n";
    exit 1;
}

my $Options = shift || '';
my $NoColors;

if ( $ENV{nocolors} || $Options =~ m{\A nocolors}msxi ) {
    $NoColors = 1;
}

# config
my @NeededModules = (
    {
        Module    => 'Apache2::Reload',
        Required  => 0,
        Comment   => 'Avoids web server restarts on mod_perl.',
        InstTypes => {
            aptget => 'libapache2-mod-perl2',
            emerge => 'dev-perl/Apache-Reload',
            ppm    => 'mod_perl-2.0',
            zypper => 'apache2-mod_perl',
        },
    },
    {
        Module    => 'Archive::Tar',
        Required  => 1,
        Comment   => 'Required for compressed file generation (in perlcore).',
        InstTypes => {
            emerge => 'perl-core/Archive-Tar',
            zypper => 'perl-Archive-Tar',
        },
    },
    {
        Module    => 'Archive::Zip',                               # required for OTRSBusiness
        Required  => 1,
        Comment   => 'Required for compressed file generation.',
        InstTypes => {
            aptget => 'libarchive-zip-perl',
            emerge => 'dev-perl/Archive-Zip',
            zypper => 'Archive-Zip',
            zypper => 'perl-Archive-Zip',
        },
    },
    {
        Module    => 'Crypt::Eksblowfish::Bcrypt',
        Required  => 0,
        Comment   => 'For strong password hashing.',
        InstTypes => {
            aptget => 'libcrypt-eksblowfish-perl',
            emerge => 'dev-perl/Crypt-Eksblowfish',
            ppm    => 'Crypt-Eksblowfish',
            zypper => 'perl-Crypt-Eksblowfish',
        },
    },
    {
        Module    => 'Crypt::SSLeay',
        Required  => 0,
        Comment   => 'Required for Generic Interface REST transport and SOAP SSL connections.',
        InstTypes => {
            aptget => 'libcrypt-ssleay-perl',
            emerge => 'dev-perl/Crypt-SSLeay',
            ppm    => 'Crypt-SSLeay',
            zypper => 'perl-Crypt-SSLeay',
        },
    },
    {
        Module    => 'Date::Format',
        Required  => 1,
        InstTypes => {
            aptget => 'libtimedate-perl',
            emerge => 'dev-perl/TimeDate',
            ppm    => 'TimeDate',
            zypper => 'perl-TimeDate',
        },
    },
    {
        Module    => 'DBI',
        Required  => 1,
        InstTypes => {
            aptget => 'libdbi-perl',
            emerge => 'dev-perl/DBI',
            ppm    => 'DBI',
            zypper => 'perl-DBI'
        },
    },
    {
        Module    => 'DBD::mysql',
        Required  => 0,
        Comment   => 'Required to connect to a MySQL database.',
        InstTypes => {
            aptget => 'libdbd-mysql-perl',
            emerge => 'dev-perl/DBD-mysql',
            ppm    => 'DBD-mysql',
            zypper => 'perl-DBD-mysql'
        },
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
        Comment   => 'Required to connect to a MS-SQL database.',
        InstTypes => {
            aptget => 'libdbd-odbc-perl',
            emerge => undef,
            ppm    => 'DBD-ODBC',
            yum    => undef,
            zypper => undef,
        },
    },
    {
        Module    => 'DBD::Oracle',
        Required  => 0,
        Comment   => 'Required to connect to a Oracle database.',
        InstTypes => {
            aptget => undef,
            emerge => undef,
            ppm    => 'DBD-Oracle',
            yum    => undef,
            zypper => undef,
        },
    },
    {
        Module    => 'DBD::Pg',
        Required  => 0,
        Comment   => 'Required to connect to a PostgreSQL database.',
        InstTypes => {
            aptget => 'libdbd-pg-perl',
            emerge => 'dev-perl/DBD-Pg',
            ppm    => 'DBD-Pg',
            zypper => 'perl-DBD-Pg',
        },
    },
    {
        Module    => 'Encode::HanExtra',
        Version   => '0.23',
        Required  => 0,
        Comment   => 'Required to handle mails with several Chinese character sets.',
        InstTypes => {
            aptget => 'libencode-hanextra-perl',
            emerge => 'dev-perl/Encode-HanExtra',
            zypper => 'perl-Encode-HanExtra',
        },
    },
    {
        Module    => 'IO::Socket::SSL',
        Required  => 0,
        Comment   => 'Required for SSL connections to web and mail servers.',
        InstTypes => {
            aptget => 'libio-socket-ssl-perl',
            emerge => 'dev-perl/IO-Socket-SSL',
            ppm    => 'IO-Socket-SSL',
            zypper => 'perl-IO-Socket-SSL',
        },
    },
    {
        Module    => 'JSON::XS',
        Required  => 0,
        Comment   => 'Recommended for faster AJAX/JavaScript handling.',
        InstTypes => {
            aptget => 'libjson-xs-perl',
            emerge => 'dev-perl/JSON-XS',
            ppm    => 'JSON-XS',
            zypper => 'perl-JSON-XS',
        },
    },
    {
        Module   => 'List::Util::XS',
        Required => 1,
        Comment =>
            "Do a 'force install Scalar::Util' via cpan shell to fix this problem. Please make sure to have an c compiler and make installed before.",
        InstTypes => {
            aptget => 'libscalar-list-utils-perl',
            emerge => 'perl-core/Scalar-List-Utils',
            ppm    => 'List-UtilsBy-XS',
            zypper => 'perl-Scalar-List-Utils',
        },
    },
    {
        Module    => 'LWP::UserAgent',
        Required  => 1,
        InstTypes => {
            aptget => 'libwww-perl',
            emerge => 'dev-perl/libwww-perl',
            ppm    => 'libwww-perl',
            zypper => 'perl-libwww-perl',
        },
    },
    {
        Module    => 'Mail::IMAPClient',
        Version   => '3.22',
        Comment   => 'Required for IMAP TLS connections.',
        Required  => 0,
        InstTypes => {
            aptget => 'libmail-imapclient-perl',
            emerge => 'dev-perl/Mail-IMAPClient',
            ppm    => 'Mail-IMAPClient',
            zypper => 'perl-Mail-IMAPClient',
        },
        Depends => [
            {
                Module    => 'IO::Socket::SSL',
                Required  => 0,
                Comment   => 'Required for IMAP TLS connections.',
                InstTypes => {
                    aptget => 'libio-socket-ssl-perl',
                    emerge => 'dev-perl/IO-Socket-SSL',
                    ppm    => 'IO-Socket-SSL',
                    zypper => 'perl-IO-Socket-SSL',
                },
            },
        ],
    },
    {
        Module    => 'ModPerl::Util',
        Required  => 0,
        Comment   => 'Improves Performance on Apache webservers dramatically.',
        InstTypes => {
            aptget => 'libapache2-mod-perl2',
            emerge => 'www-apache/mod_perl',
            zypper => 'apache2-mod_perl',
        },
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
        InstTypes => {
            aptget => 'libnet-dns-perl',
            emerge => 'dev-perl/Net-DNS',
            ppm    => 'Net-DNS',
            zypper => 'perl-Net-DNS',
        },
    },
    {
        Module    => 'Net::LDAP',
        Required  => 0,
        Comment   => 'Required for directory authentication.',
        InstTypes => {
            aptget => 'libnet-ldap-perl',
            emerge => 'dev-perl/perl-ldap',
            ppm    => 'Net-LDAP',
            zypper => 'perl-ldap',
        },
    },
    {
        Module    => 'Template',
        Required  => 1,
        Comment   => 'Template::Toolkit, the rendering engine of OTRS.',
        InstTypes => {
            aptget => 'libtemplate-perl',
            emerge => 'dev-perl/Template-Toolkit',
            ppm    => 'Template-Toolkit',
            zypper => 'perl-Template-Toolkit',
        },
    },
    {
        Module    => 'Template::Stash::XS',
        Required  => 1,
        Comment   => 'The fast data stash for Template::Toolkit.',
        InstTypes => {
            aptget => 'libtemplate-perl',
            emerge => 'dev-perl/Template-Toolkit',
            ppm    => 'Template-Toolkit',
            zypper => 'perl-Template-Toolkit',
        },
    },
    {
        Module    => 'Text::CSV_XS',
        Required  => 0,
        Comment   => 'Recommended for faster CSV handling.',
        InstTypes => {
            aptget => 'libtext-csv-xs-perl',
            emerge => 'dev-perl/Text-CSV_XS',
            ppm    => 'Text-CSV_XS',
            zypper => 'perl-Text-CSV_XS',
        },
    },
    {
        Module    => 'Time::HiRes',
        Required  => 1,
        Comment   => 'Required for high resolution timestamps.',
        InstTypes => {
            aptget => 'perl',
            emerge => 'perl-core/Time-HiRes',
            ppm    => 'Time-HiRes',
            zypper => 'perl-Time-HiRes',
        },
    },
    {
        # perlcore
        Module   => 'Time::Piece',
        Required => 1,
        Comment  => 'Required for statistics.',
    },
    {
        Module    => 'XML::LibXML',
        Required  => 0,
        Comment   => 'Required for Generic Interface XSLT mapping module.',
        InstTypes => {
            aptget => 'libxml-libxml-perl',
            ppm    => 'XML-LibXML',
            zypper => 'perl-XML-LibXML',
        },
    },
    {
        Module    => 'XML::LibXSLT',
        Required  => 0,
        Comment   => 'Required for Generic Interface XSLT mapping module.',
        InstTypes => {
            aptget => 'libxml-libxslt-perl',
            ppm    => 'XML-LibXSLT',
            zypper => 'perl-XML-LibXSLT',
        },
    },
    {
        Module    => 'XML::Parser',
        Required  => 0,
        Comment   => 'Recommended for faster xml handling.',
        InstTypes => {
            aptget => 'libxml-parser-perl',
            emerge => 'dev-perl/XML-Parser',
            ppm    => 'XML-Parser',
            zypper => 'perl-XML-Parser',
        },
    },
    {
        Module    => 'YAML::XS',
        Required  => 1,
        Comment   => 'Very important',
        InstTypes => {
            aptget => 'libyaml-libyaml-perl',
            emerge => 'dev-perl/YAML-LibYAML',
            ppm    => 'YAML-XS',
            zypper => 'perl-YAML-LibYAML',
        },
    },
);

if ($PackageList) {
    my %PackageList = _PackageList( \@NeededModules );

    if ( IsArrayRefWithData( $PackageList{Packages} ) ) {

        my $CMD = $PackageList{CMD};

        for my $Package ( @{ $PackageList{Packages} } ) {
            if ( $PackageList{SubCMD} ) {
                $Package = sprintf $PackageList{SubCMD}, $Package;
            }
        }
        printf $CMD, join( ' ', @{ $PackageList{Packages} } );
        print "\n";
    }
}
else {
    # try to determine module version number
    my $Depends = 0;

    for my $Module (@NeededModules) {
        _Check( $Module, $Depends, $NoColors );
    }

    if ($AllModules) {
        print "\nBundled modules:\n\n";

        my %PerlInfo = Kernel::System::Environment->PerlInfoGet(
            BundledModules => 1,
        );

        for my $Module ( sort keys %{ $PerlInfo{Modules} } ) {
            _Check(
                {
                    Module   => $Module,
                    Required => 1,
                },
                $Depends,
                $NoColors
            );
        }
    }
}

sub _Check {
    my ( $Module, $Depends, $NoColors ) = @_;

    # if we're on Windows we don't need to see Apache + mod_perl modules
    if ( $^O eq 'MSWin32' ) {
        return if $Module->{Module} =~ m{\A Apache }xms;
        return if $Module->{Module} =~ m{\A ModPerl }xms;
    }

    print "  " x ( $Depends + 1 );
    print "o $Module->{Module}";
    my $Length = 33 - ( length( $Module->{Module} ) + ( $Depends * 2 ) );
    print '.' x $Length;

    my $Version = Kernel::System::Environment->ModuleVersionGet( Module => $Module->{Module} );
    if ($Version) {

        # cleanup version number
        my $CleanedVersion = _VersionClean(
            Version => $Version,
        );

        my $ErrorMessage;

        # Test if all module dependencies are installed by requiring the module.
        #   Don't do this for Net::DNS as it seems to take very long (>20s) in a
        #   mod_perl environment sometimes.
        my %DontRequire = (
            'Net::DNS'     => 1,
            'Email::Valid' => 1,    # uses Net::DNS internally
        );

        ## no critic
        if ( !$DontRequire{ $Module->{Module} } && !eval "require $Module->{Module}" ) {
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
                print color('red') . 'FAILED!' . color('reset') . " $ErrorMessage\n";
            }
        }
        else {
            my $OutputVersion = $Version;

            if ( $OutputVersion =~ m{ [0-9.] }xms ) {
                $OutputVersion = 'v' . $OutputVersion;
            }

            if ($NoColors) {
                print "ok ($OutputVersion)\n";
            }
            else {
                print color('green') . 'ok' . color('reset') . " ($OutputVersion)\n";
            }
        }
    }
    else {
        my $Comment  = $Module->{Comment} ? ' - ' . $Module->{Comment} : '';
        my $Required = $Module->{Required};
        my $Color    = 'yellow';

        # OS Install Command
        my %InstallCommand = _GetInstallCommand($Module);

        # create example installation string for module
        my $InstallText = '';
        if ( IsHashRefWithData( \%InstallCommand ) ) {
            my $CMD = $InstallCommand{CMD};
            if ( $InstallCommand{SubCMD} ) {
                $CMD = sprintf $InstallCommand{CMD}, $InstallCommand{SubCMD};
            }

            $InstallText = " Use: '" . sprintf( $CMD, $InstallCommand{Package} ) . "'";
        }

        if ($Required) {
            $Required = 'required';
            $Color    = 'red';
        }
        else {
            $Required = 'optional';
        }
        if ($NoColors) {
            print "Not installed! ($Required $Comment)\n";
        }
        else {
            print color($Color)
                . 'Not installed!'
                . color('reset')
                . "$InstallText ($Required$Comment)\n";
        }
    }

    if ( $Module->{Depends} ) {
        for my $ModuleSub ( @{ $Module->{Depends} } ) {
            _Check( $ModuleSub, $Depends + 1, $NoColors );
        }
    }

    return 1;
}

sub _PackageList {
    my ($PackageList) = @_;

    my $CMD;
    my $SubCMD;
    my @Packages;

    # if we're on Windows we don't need to see Apache + mod_perl modules
    MODULE:
    for my $Module ( @{$PackageList} ) {
        if ( $^O eq 'MSWin32' ) {
            return if $Module->{Module} =~ m{\A Apache }xms;
            return if $Module->{Module} =~ m{\A ModPerl }xms;
        }

        my $Required = $Module->{Required};
        my $Version = Kernel::System::Environment->ModuleVersionGet( Module => $Module->{Module} );
        if ( !$Version ) {
            my %InstallCommand = _GetInstallCommand($Module);

            if ( $Module->{Depends} ) {

                MODULESUB:
                for my $ModuleSub ( @{ $Module->{Depends} } ) {
                    my $Required          = $Module->{Required};
                    my %InstallCommandSub = _GetInstallCommand($ModuleSub);

                    next MODULESUB if !IsHashRefWithData( \%InstallCommandSub );
                    next MODULESUB if !$Required;

                    push @Packages, $InstallCommandSub{Package};
                }
            }

            next MODULE if !IsHashRefWithData( \%InstallCommand );
            next MODULE if !$Required;

            $CMD    = $InstallCommand{CMD};
            $SubCMD = $InstallCommand{SubCMD};
            push @Packages, $InstallCommand{Package};
        }
    }

    return (
        CMD      => $CMD,
        SubCMD   => $SubCMD,
        Packages => \@Packages,
    );
}

sub _VersionClean {
    my (%Param) = @_;

    return 0 if !$Param{Version};
    return 0 if $Param{Version} eq 'undef';

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

sub _GetInstallCommand {
    my ($Module) = @_;
    my $CMD;
    my $SubCMD;
    my $Package;

    # returns the installation type e.g. ppm
    my $InstType     = $DistToInstType{$OSDist};
    my $OuputInstall = 1;

    if ($InstType) {

        # gets the install command for installation type
        # e.g. ppm install %s
        # default is the cpan install command
        # e.g. cpan %s
        $CMD    = $InstTypeToCMD{$InstType}->{CMD};
        $SubCMD = $InstTypeToCMD{$InstType}->{SubCMD};

        # gets the target package
        if (
            exists $Module->{InstTypes}->{$InstType}
            && !defined $Module->{InstTypes}->{$InstType}
            )
        {
            # if we a hash key for the installation type but a undefined value
            # then we prevent the output for the installation command
            $OuputInstall = 0;
        }
        elsif ( $InstTypeToCMD{$InstType}->{UseModule} ) {

            # default is the cpan module name
            $Package = $Module->{Module};
        }
        else {
            # if the package name is defined for the installation type
            # e.g. ppm then we use this as package name
            $Package = $Module->{InstTypes}->{$InstType};
        }
    }

    return if !$OuputInstall;

    if ( !$CMD || !$Package ) {
        $CMD     = $InstTypeToCMD{default}->{CMD};
        $SubCMD  = $InstTypeToCMD{default}->{SubCMD};
        $Package = $Module->{Module};
    }

    return (
        CMD     => $CMD,
        SubCMD  => $SubCMD,
        Package => $Package,
    );
}

sub _CheckActiveStatePerl {

    # checks if active state perl on windows is activated
    ## no critic
    my $ActiveStatePerl = eval 'use Win32; return Win32::BuildNumber();';
    ## use critic

    return $ActiveStatePerl ? 1 : 0;
}

exit 0;
