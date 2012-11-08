#!/usr/bin/perl -w
# --
# bin/otrs.CreateApacheStartupFile.pl - create new translation file
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: otrs.CreateApacheStartupFile.pl,v 1.1 2012-11-08 10:13:43 mg Exp $
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

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

use Getopt::Std qw();
use File::Find qw();

use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::Time;
use Kernel::System::DB;
use Kernel::Language;
use Kernel::System::SysConfig;

sub PrintUsage {
    print <<"EOF";

otrs.CreateApacheStartupFile.pl <Revision $VERSION> - update apache startup file for mod_perl
Copyright (C) 2001-2010 OTRS AG, http://otrs.org/

EOF
}

{

    # common objects
    my %CommonObject = ();
    $CommonObject{ConfigObject} = Kernel::Config->new();
    $CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
    $CommonObject{LogObject}    = Kernel::System::Log->new(
        LogPrefix => 'OTRS-otrs.CreateApacheStartupFile.pl',
        %CommonObject,
    );
    $CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);
    $CommonObject{TimeObject} = Kernel::System::Time->new(%CommonObject);
    $CommonObject{DBObject}   = Kernel::System::DB->new(%CommonObject);

    my $Home = $CommonObject{ConfigObject}->Get('Home');

    #
    # Determine used DB backend
    #
    my $DBCode = '';
    my $DBType = $CommonObject{DBObject}->GetDatabaseFunction('Type');
    if ( $DBType eq 'mysql' ) {
        $DBCode .= << 'EOF';
use DBD::mysql ();
use Kernel::System::DB::mysql;
EOF
    }
    elsif ( $DBType =~ /postgresql/smxi ) {
        $DBCode .= << 'EOF';
use DBD::Pg ();
use Kernel::System::DB::postgresql;
EOF
    }
    elsif ( $DBType eq 'oracle' ) {
        $DBCode .= << 'EOF';
use DBD::Oracle ();
use Kernel::System::DB::oracle;
EOF
    }

    #
    # Loop over all general system packages and include them
    #
    my $SystemPackagesCode = '';

    # Directories to check
    my @Directories = (
        "$Home/Kernel/GenericInterface",
        "$Home/Kernel/Language",
        "$Home/Kernel/Modules",
        "$Home/Kernel/Output",
        "$Home/Kernel/System",
    );

    # Ignore patterns. These modules can possibly not be loaded on all systems.
    my @Excludes = (
        "Kernel/System/DB",
        "LDAP",
        "Radius",
        "IMAP",
        "POP3",
        "SMTP",
    );

    my @Files;

    my $Wanted = sub {
        return if $File::Find::name !~ m{\.pm$}smx;
        for my $Exclude (@Excludes) {
            return if $File::Find::name =~ m{\Q$Exclude\E}smx;
        }
        push @Files, $File::Find::name;
    };

    for my $Directory (@Directories) {
        File::Find::find( $Wanted, $Directory );
    }

    FILE:
    foreach my $File (@Files) {
        my $Package = CheckPerlPackage( CommonObject => \%CommonObject, Filename => $File );
        next FILE if !$Package;
        $SystemPackagesCode .= "use $Package;\n";
    }

    #
    # Generate final output
    #
    my $Content = <<"EOF";
#!/usr/bin/perl -w
# -\-
# scripts/apache-perl-startup.pl - to load the modules if mod_perl is used
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# -\-
# \$Id: otrs.CreateApacheStartupFile.pl,v 1.1 2012-11-08 10:13:43 mg Exp $
# -\-
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
# -\-

#
# THIS FILE IS AUTOGENERATED BY otrs.CreateApacheStartupFile.pl
#

use strict;
use warnings;

# make sure we are in a sane environment.
\$ENV{MOD_PERL} =~ /mod_perl/ or die "MOD_PERL not used!";

# switch to unload_package_xs, the PP version is broken in Perl 5.10.1.
# see http://rt.perl.org/rt3//Public/Bug/Display.html?id=72866
BEGIN {
    \$ModPerl::Util::DEFAULT_UNLOAD_METHOD = 'unload_package_xs';
}

use ModPerl::Util;

# set otrs lib path!
use lib "$Home";
use lib "$Home/Kernel/cpan-lib";
use lib "$Home/Custom";

use CGI ();
CGI->compile(':cgi');
use CGI::Carp ();

use Apache::DBI;

$DBCode

use Kernel::Config;

$SystemPackagesCode

1;
EOF

    print "Writing file $Home/scripts/apache2-perl-startup2.pl\n";

    $CommonObject{MainObject}->FileWrite(
        Location => "$Home/scripts/apache2-perl-startup2.pl",
        Content  => \$Content,
    );
}

=item CheckPerlPackage()

checks if a given file is a valid OTRS Perl package.

    my $Package = CheckPerlPackage(
        CommonObject => \%CommonObject,
        Filename => $File
    );

This function will extract the package name, and check if the package
is really defined in the given file.

Returns the package name, if it is valid, undef otherwise.

=cut

sub CheckPerlPackage {
    my %Param        = @_;
    my %CommonObject = %{ $Param{CommonObject} };

    my $Home     = $CommonObject{ConfigObject}->Get('Home');
    my $Filename = $Param{Filename};

    # Generate package name
    my $PackageName = substr( $Filename, length($Home) );
    $PackageName =~ s{^/}{}smxg;
    $PackageName =~ s{/}{::}smxg;
    $PackageName =~ s{\.pm$}{}smxg;

    # Check if the file really contains the package
    my $FileContent = $CommonObject{MainObject}->FileRead(
        Location => $Filename,
    );
    return if !ref $FileContent;
    return if ( ${$FileContent} !~ /^package\s+\Q$PackageName\E/smx );

    return $PackageName;
}

exit 0;
