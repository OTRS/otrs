#!/usr/bin/perl
# --
# bin/otrs.WebserviceConfig.pl - script to read/write/list webservice config
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

use Getopt::Std;
use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::Time;
use Kernel::System::DB;
use Kernel::System::GenericInterface::Webservice;

use Kernel::System::YAML;

# get options
my %Opts;
getopt( 'hiafn', \%Opts );
if ( $Opts{h} ) {
    print "otrs.WebserviceConfig.pl - read/write/list webservice config\n";
    print "Copyright (C) 2001-2013 OTRS AG, http://otrs.com/\n";
    print
        "usage: otrs.WebserviceConfig.pl -a read  -i \$ID                         (read config, print to STDOUT)\n";
    print
        "                                -a write -n \$name -f /path/to/yaml/file (create a new config)\n";
    print
        "                                -a write -i \$ID -f /path/to/yaml/file   (update config)\n";
    print
        "                                -a list                                  (list available config)\n";
    print
        "                                -a delete  -i \$ID                       (delete config)\n";
    exit 1;
}

# create common objects
my %CommonObject;

$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-otrs.WebserviceConfig.pl',
    %CommonObject,
);
$CommonObject{TimeObject} = Kernel::System::Time->new(%CommonObject);
$CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);
$CommonObject{DBObject}   = Kernel::System::DB->new(%CommonObject);

# create needed objects
$CommonObject{WebserviceObject} = Kernel::System::GenericInterface::Webservice->new(%CommonObject);
$CommonObject{YAMLObject}       = Kernel::System::YAML->new(%CommonObject);

# validate -a param
if ( !$Opts{a} ) {
    print STDERR "ERROR: Need action (-a) param!\n";
    exit 1;
}
if ( lc( $Opts{a} ) !~ /^(read|write|list|delete)$/ ) {
    print STDERR "ERROR: Unknown action '$Opts{a}'\n";
    exit 1;
}

# list webservices
if ( lc( $Opts{a} ) eq 'list' ) {
    print "List Config: (ID:Name)\n";
    my $List = $CommonObject{WebserviceObject}->WebserviceList();
    for my $ID ( sort keys %{$List} ) {
        print "$ID:$List->{$ID}\n";
    }
    exit 0;
}

# write webservice
if ( lc( $Opts{a} ) eq 'write' ) {

    # validate file
    if ( !$Opts{f} ) {
        print STDERR "ERROR: Need file (-f) param!\n";
        exit 1;
    }
    elsif ( !-f $Opts{f} ) {
        print STDERR "ERROR: File (-f '$Opts{f}') is no file!\n";
        exit 1;
    }

    # read config
    my $Content = $CommonObject{MainObject}->FileRead(
        Location => $Opts{f},
    );
    if ( !$Content ) {
        print STDERR "ERROR: No content in file (-f '$Opts{f}')!\n";
        exit 1;
    }
    my $Config = $CommonObject{YAMLObject}->Load( Data => ${$Content} );

    if ( !$Config ) {
        print STDERR "ERROR: Unable to read config file: $! (-f '$Opts{f}')!\n";
        exit 1;
    }

    # webservice lookup
    if ( $Opts{i} ) {
        my $List = $CommonObject{WebserviceObject}->WebserviceList();
        if ( !$List->{ $Opts{i} } ) {
            print STDERR "ERROR: No such webservice with id (-i '$Opts{i}')!\n";
            exit 1;
        }
        my $Webservice = $CommonObject{WebserviceObject}->WebserviceGet( ID => $Opts{i} );
        if ( !$Webservice ) {
            print STDERR "ERROR: No such webservice with id (-i '$Opts{i}')!\n";
            exit 1;
        }

        # update webservice
        my $Success = $CommonObject{WebserviceObject}->WebserviceUpdate(
            ID      => $Webservice->{ID},
            Name    => $Webservice->{Name},
            Config  => $Config,
            ValidID => 1,
            UserID  => 1,
        );
        if ( !$Success ) {
            print STDERR "ERROR: Unable to update webservice!\n";
            exit 1;
        }
        print "NOTICE: Webservice updated (ID:$Webservice->{ID})!\n";
        exit 0;
    }

    # webservice add
    my $ID = $CommonObject{WebserviceObject}->WebserviceAdd(
        Name    => $Opts{n},
        Config  => $Config,
        ValidID => 1,
        UserID  => 1,
    );
    if ( !$ID ) {
        print STDERR "ERROR: Unable to create webservice!\n";
        exit 1;
    }
    print "NOTICE: Webservice created (ID:$ID)!\n";
    exit 0;
}

# read webservice
if ( lc( $Opts{a} ) eq 'read' ) {

    # validate file
    if ( !$Opts{i} ) {
        print STDERR "ERROR: Need id (-i) param!\n";
        exit 1;
    }

    # webservice lookup
    my $List = $CommonObject{WebserviceObject}->WebserviceList();
    if ( !$List->{ $Opts{i} } ) {
        print STDERR "ERROR: No such webservice with id (-i '$Opts{i}')!\n";
        exit 1;
    }

    # get webservice
    my $Webservice = $CommonObject{WebserviceObject}->WebserviceGet( ID => $Opts{i} );
    if ( !$Webservice ) {
        print STDERR "ERROR: No such webservice with id (-i '$Opts{i}')!\n";
        exit 1;
    }

    # dump config as string
    my $Config = $CommonObject{YAMLObject}->Dump( Data => $Webservice->{Config} );
    print "$Config\n";
    exit 0;
}

# delete webservice
if ( lc( $Opts{a} ) eq 'delete' ) {

    # validate file
    if ( !$Opts{i} ) {
        print STDERR "ERROR: Need id (-i) param!\n";
        exit 1;
    }

    # get webservice
    my $Webservice = $CommonObject{WebserviceObject}->WebserviceGet( ID => $Opts{i} );
    if ( !$Webservice ) {
        print STDERR "ERROR: No such webservice with id (-i '$Opts{i}')!\n";
        exit 1;
    }

    # webservice lookup
    my $Success = $CommonObject{WebserviceObject}->WebserviceDelete(
        ID     => $Opts{i},
        UserID => 1,
    );
    if ( !$Success ) {
        print STDERR "ERROR: No such webservice with id (-i '$Opts{i}')!\n";
        exit 1;
    }

    print "NOTICE: Webservice deleted (ID:$Opts{i})!\n";

}
exit 0;
