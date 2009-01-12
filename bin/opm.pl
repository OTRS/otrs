#!/usr/bin/perl -w
# --
# opm.pl - otrs package manager cmd version
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: opm.pl,v 1.28 2009-01-12 12:49:43 mh Exp $
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
# --

use strict;
use warnings;

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . "/Kernel/cpan-lib";

use Getopt::Std;
use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::DB;
use Kernel::System::Time;
use Kernel::System::Package;

# get file version
use vars qw($VERSION);
$VERSION = qw($Revision: 1.28 $) [1];

# common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-opm',
    %CommonObject,
);
$CommonObject{MainObject}    = Kernel::System::Main->new(%CommonObject);
$CommonObject{TimeObject}    = Kernel::System::Time->new(%CommonObject);
$CommonObject{DBObject}      = Kernel::System::DB->new(%CommonObject);
$CommonObject{PackageObject} = Kernel::System::Package->new(%CommonObject);

# get options
my %Opts = ();
getopt( 'hapofd', \%Opts );

# set defaults
if ( !$Opts{o} ) {
    $Opts{o} = '/tmp/';
}
if ( !$Opts{f} ) {
    $Opts{f} = 0;
}
if ( !$Opts{a} ) {
    $Opts{h} = 1;
}
if ( $Opts{a} && ( $Opts{a} !~ /^list/ && !$Opts{p} ) ) {
    $Opts{h} = 1;
}
if ( $Opts{a} && ( $Opts{a} eq 'exportfile' && ( !$Opts{p} || !$Opts{d} ) ) ) {
    $Opts{h} = 1;
}
if ( $Opts{a} && $Opts{a} eq 'index' ) {
    $Opts{h} = 0;
}

# check needed params
if ( $Opts{h} ) {
    print "opm.pl <Revision $VERSION> - OTRS Package Manager\n";
    print "Copyright (c) 2001-2008 OTRS AG, http//otrs.org/\n";
    print
        "usage: opm.pl -a list|install|upgrade|uninstall|reinstall|list-repository|file|build|index \n";
    print
        "        [-p package.opm|package.sopm|package|package-version] [-o OUTPUTDIR] [-f FORCE]\n";
    print "   user (local):\n";
    print "       opm.pl -a list\n";
    print "       opm.pl -a install -p /path/to/Package-1.0.0.opm\n";
    print "       opm.pl -a upgrade -p /path/to/Package-1.0.1.opm\n";
    print "       opm.pl -a reinstall -p Package\n";
    print "       opm.pl -a uninstall -p Package\n";
    print "       opm.pl -a file -p Kernel/System/File.pm (find package of file)\n";
    print
        "       opm.pl -a exportfile -p Kernel/System/File.opm -d /export/to/path/ (export files of package)\n";
    print "   user (remote):\n";
    print "       opm.pl -a list-repository\n";
    print "       opm.pl -a install -p online:Package\n";
    print "       opm.pl -a install -p http://ftp.otrs.org/pub/otrs/packages/:Package-1.0.0.opm\n";
    print "       opm.pl -a upgrade -p online:Package\n";
    print "       opm.pl -a upgrade -p http://ftp.otrs.org/pub/otrs/packages/:Package-1.0.0.opm\n";
    print "   developer: \n";
    print "       opm.pl -a build -p /path/to/Package-1.0.0.sopm\n";
    print "       opm.pl -a build -p /path/to/Package-1.0.0.sopm -d module-home-path\n";
    print "       opm.pl -a index -d /path/to/repository/\n";
    exit 1;
}
my $FileString = '';
if ( $Opts{a} !~ /^(list|file)/ && $Opts{p} ) {
    if ( -e $Opts{'p'} ) {
        my $ContentRef = $CommonObject{MainObject}->FileRead(
            Location => $Opts{p},
            Mode     => 'utf8',      # optional - binmode|utf8
            Result   => 'SCALAR',    # optional - SCALAR|ARRAY
        );
        if ($ContentRef) {
            $FileString = ${$ContentRef};
        }
        else {
            die "ERROR: Can't open: $Opts{p}: $!";
        }
    }
    elsif ( $Opts{p} =~ /^(online|.*):(.+?)$/ ) {
        my $URL         = $1;
        my $PackageName = $2;
        if ( $URL eq 'online' ) {
            my %List = %{ $CommonObject{ConfigObject}->Get('Package::RepositoryList') };
            %List = ( %List, $CommonObject{PackageObject}->PackageOnlineRepositories() );
            for ( sort keys %List ) {
                if ( $List{$_} =~ /^\[-Master-\]/ ) {
                    $URL = $_;
                }
            }
        }
        if ( $PackageName !~ /^.+?.opm$/ ) {
            my @Packages = $CommonObject{PackageObject}->PackageOnlineList(
                URL  => $URL,
                Lang => $CommonObject{ConfigObject}->Get('DefaultLanguage'),
            );
            for my $Package (@Packages) {
                if ( $Package->{Name} eq $PackageName ) {
                    $PackageName = $Package->{File};
                    last;
                }
            }
        }
        $FileString = $CommonObject{PackageObject}->PackageOnlineGet(
            Source => $URL,
            File   => $PackageName,
        );
        if ( !$FileString ) {
            die "ERROR: No such file '$Opts{p}' in $URL!";
        }
    }
    else {
        if ( $Opts{p} =~ /^(.*)\-(\d{1,4}\.\d{1,4}\.\d{1,4})$/ ) {
            $FileString = $CommonObject{PackageObject}->RepositoryGet(
                Name    => $1,
                Version => $2,
            );
        }
        else {
            for my $Package ( $CommonObject{PackageObject}->RepositoryList() ) {
                if ( $Opts{p} eq $Package->{Name}->{Content} ) {
                    $FileString = $CommonObject{PackageObject}->RepositoryGet(
                        Name    => $Package->{Name}->{Content},
                        Version => $Package->{Version}->{Content},
                    );
                    last;
                }
            }
        }
        if ( !$FileString ) {
            die "ERROR: No such file '$Opts{p}' or invalid 'package-version'!";
        }
    }
}

# file
if ( $Opts{a} eq 'file' ) {
    $Opts{p} =~ s/\/\//\//g;
    my $Hit = 0;
    for my $Package ( $CommonObject{PackageObject}->RepositoryList() ) {
        for my $File ( @{ $Package->{Filelist} } ) {
            if ( $Opts{p} =~ /^\Q$File->{Location}\E$/ ) {
                print
                    "+----------------------------------------------------------------------------+\n";
                print "| File:        $File->{Location}!\n";
                print "| Name:        $Package->{Name}->{Content}\n";
                print "| Version:     $Package->{Version}->{Content}\n";
                print "| Vendor:      $Package->{Vendor}->{Content}\n";
                print "| URL:         $Package->{URL}->{Content}\n";
                print "| License:     $Package->{License}->{Content}\n";
                print
                    "+----------------------------------------------------------------------------+\n";
                $Hit = 1;
            }
        }
    }
    if ($Hit) {
        exit;
    }
    else {
        print STDERR "ERROR: no package for file $Opts{p} found!\n";
        exit 1;
    }
}

# exportfile
if ( $Opts{a} eq 'exportfile' ) {
    $Opts{p} =~ s/\/\//\//g;
    my $String = '';

    # read package
    if ( -e $Opts{p} ) {
        my $ContentRef = $CommonObject{MainObject}->FileRead(
            Location => $Opts{p},
            Mode     => 'utf8',      # optional - binmode|utf8
            Result   => 'SCALAR',    # optional - SCALAR|ARRAY
        );
        if ($ContentRef) {
            if ( ${$ContentRef} ) {
                $String = ${$ContentRef};
            }
            else {
                print STDERR "ERROR: File $Opts{p} is empty!\n";
                exit 1;
            }
        }
        else {
            print STDERR "ERROR: no such package $Opts{p}: $! !\n";
            exit 1;
        }
    }
    else {
        print STDERR "ERROR: no package for file $Opts{p} found!\n";
        exit 1;
    }

    # export it
    print "+----------------------------------------------------------------------------+\n";
    print "| Export files of:\n";
    print "| Package: $Opts{p}\n";
    print "| To:      $Opts{'d'}\n";
    print "+----------------------------------------------------------------------------+\n";
    $CommonObject{PackageObject}->PackageExport(
        String => $String,
        Home   => $Opts{d},
    );
    exit;
}

# build
if ( $Opts{a} eq 'build' ) {
    my %Structure = $CommonObject{PackageObject}->PackageParse( String => $FileString, );
    if ( !-e $Opts{o} ) {
        print STDERR "ERROR: $Opts{o} doesn't exist!\n";
        exit 1;
    }

    # build from given package directory, if any (otherwise default to OTRS home)
    if ( $Opts{d} ) {
        if ( !-d $Opts{d} ) {
            print STDERR "ERROR: $Opts{d} doesn't exist!\n";
            exit 1;
        }
        $Structure{Home} = $Opts{d};
    }

    my $Filename = $Structure{Name}->{Content} . '-' . $Structure{Version}->{Content} . '.opm';
    my $Content  = $CommonObject{PackageObject}->PackageBuild(%Structure);
    my $File     = $CommonObject{MainObject}->FileWrite(
        Location   => $Opts{'o'} . '/' . $Filename,
        Content    => \$Content,
        Mode       => 'utf8',                         # binmode|utf8
        Type       => 'Local',                        # optional - Local|Attachment|MD5
        Permission => '644',                          # unix file permissions
    );
    if ($File) {
        print "Writing $File\n";
        exit;
    }
    else {
        print STDERR "ERROR: Can't write $File\n";
        exit 1;
    }
}
elsif ( $Opts{a} eq 'uninstall' ) {

    # get package file from db
    # parse package
    my %Structure = $CommonObject{PackageObject}->PackageParse( String => $FileString, );

    # intro screen
    if ( $Structure{IntroUninstallPre} ) {
        my %Data = _MessageGet( Info => $Structure{IntroUninstallPre} );
        print "+----------------------------------------------------------------------------+\n";
        print "| $Structure{Name}->{Content}-$Structure{Version}->{Content}\n";
        print "$Data{Title}";
        print "$Data{Description}";
        print "+----------------------------------------------------------------------------+\n";
    }

    # uninstall
    $CommonObject{PackageObject}->PackageUninstall(
        String => $FileString,
        Force  => $Opts{f},
    );

    # intro screen
    if ( $Structure{IntroUninstallPost} ) {
        my %Data = _MessageGet( Info => $Structure{IntroUninstallPost} );
        print "+----------------------------------------------------------------------------+\n";
        print "| $Structure{Name}->{Content}-$Structure{Version}->{Content}\n";
        print "$Data{Title}";
        print "$Data{Description}";
        print "+----------------------------------------------------------------------------+\n";
    }
    exit;
}
elsif ( $Opts{a} eq 'install' ) {

    # parse package
    my %Structure = $CommonObject{PackageObject}->PackageParse( String => $FileString, );

    # intro screen
    if ( $Structure{IntroInstallPre} ) {
        my %Data = _MessageGet( Info => $Structure{IntroInstallPre} );
        print "+----------------------------------------------------------------------------+\n";
        print "| $Structure{Name}->{Content}-$Structure{Version}->{Content}\n";
        print "$Data{Title}";
        print "$Data{Description}";
        print "+----------------------------------------------------------------------------+\n";
    }

    # install
    $CommonObject{PackageObject}->PackageInstall(
        String => $FileString,
        Force  => $Opts{f},
    );

    # intro screen
    if ( $Structure{IntroInstallPost} ) {
        my %Data = _MessageGet( Info => $Structure{IntroInstallPost} );
        print "+----------------------------------------------------------------------------+\n";
        print "| $Structure{Name}->{Content}-$Structure{Version}->{Content}\n";
        print "$Data{Title}";
        print "$Data{Description}";
        print "+----------------------------------------------------------------------------+\n";
    }
    exit;
}
elsif ( $Opts{a} eq 'reinstall' ) {

    # parse package
    my %Structure = $CommonObject{PackageObject}->PackageParse( String => $FileString, );

    # intro screen
    if ( $Structure{IntroReinstallPre} ) {
        my %Data = _MessageGet( Info => $Structure{IntroReinstallPre} );
        print "+----------------------------------------------------------------------------+\n";
        print "| $Structure{Name}->{Content}-$Structure{Version}->{Content}\n";
        print "$Data{Title}";
        print "$Data{Description}";
        print "+----------------------------------------------------------------------------+\n";
    }

    # install
    $CommonObject{PackageObject}->PackageReinstall(
        String => $FileString,
        Force  => $Opts{f},
    );

    # intro screen
    if ( $Structure{IntroReinstallPost} ) {
        my %Data = _MessageGet( Info => $Structure{IntroReinstallPost} );
        print "+----------------------------------------------------------------------------+\n";
        print "| $Structure{Name}->{Content}-$Structure{Version}->{Content}\n";
        print "$Data{Title}";
        print "$Data{Description}";
        print "+----------------------------------------------------------------------------+\n";
    }
    exit;
}
elsif ( $Opts{a} eq 'upgrade' ) {

    # parse package
    my %Structure = $CommonObject{PackageObject}->PackageParse( String => $FileString, );

    # intro screen
    if ( $Structure{IntroUpgradePre} ) {
        my %Data = _MessageGet( Info => $Structure{IntroUpgradePre} );
        print "+----------------------------------------------------------------------------+\n";
        print "| $Structure{Name}->{Content}-$Structure{Version}->{Content}\n";
        print "$Data{Title}";
        print "$Data{Description}";
        print "+----------------------------------------------------------------------------+\n";
    }

    # upgrade
    $CommonObject{PackageObject}->PackageUpgrade(
        String => $FileString,
        Force  => $Opts{f},
    );

    # intro screen
    if ( $Structure{IntroUpgradePost} ) {
        my %Data = _MessageGet( Info => $Structure{IntroUpgradePost} );
        print "+----------------------------------------------------------------------------+\n";
        print "| $Structure{Name}->{Content}-$Structure{Version}->{Content}\n";
        print "$Data{Title}";
        print "$Data{Description}";
        print "+----------------------------------------------------------------------------+\n";
    }
    exit;
}
elsif ( $Opts{a} eq 'list' ) {
    for my $Package ( $CommonObject{PackageObject}->RepositoryList() ) {
        my %Data = _MessageGet( Info => $Package->{Description}, Reformat => 'No' );
        print "+----------------------------------------------------------------------------+\n";
        print "| Name:        $Package->{Name}->{Content}\n";
        print "| Version:     $Package->{Version}->{Content}\n";
        print "| Vendor:      $Package->{Vendor}->{Content}\n";
        print "| URL:         $Package->{URL}->{Content}\n";
        print "| License:     $Package->{License}->{Content}\n";
        print "| Description: $Data{Description}\n";
    }
    print "+----------------------------------------------------------------------------+\n";
    exit;
}
elsif ( $Opts{a} eq 'list-repository' ) {
    my $Count = 0;
    my %List  = ();
    if ( $CommonObject{ConfigObject}->Get('Package::RepositoryList') ) {
        %List = %{ $CommonObject{ConfigObject}->Get('Package::RepositoryList') };
    }
    %List = ( %List, $CommonObject{PackageObject}->PackageOnlineRepositories() );
    for my $URL ( sort { $List{$a} cmp $List{$b} } keys %List ) {
        $Count++;
        print "+----------------------------------------------------------------------------+\n";
        print "| $Count) Name: $List{$URL}\n";
        print "|    URL:  $URL\n";
    }
    print "+----------------------------------------------------------------------------+\n";
    print "| Select the repository [1]: ";
    my $Repository = <STDIN>;
    chomp $Repository;
    if ( !$Repository ) {
        $Repository = 1;
    }
    $Count = 0;
    for my $URL ( sort { $List{$a} cmp $List{$b} } keys %List ) {
        $Count++;
        if ( $Count == $Repository ) {
            print
                "+----------------------------------------------------------------------------+\n";
            print "| Package Overview:\n";
            my @Packages = $CommonObject{PackageObject}->PackageOnlineList(
                URL  => $URL,
                Lang => $CommonObject{ConfigObject}->Get('DefaultLanguage'),
            );
            my $Count = 0;
            for my $Package (@Packages) {
                $Count++;
                print
                    "+----------------------------------------------------------------------------+\n";
                print "| $Count) Name:        $Package->{Name}\n";
                print "|    Version:     $Package->{Version}\n";
                print "|    Vendor:      $Package->{Vendor}\n";
                print "|    URL:         $Package->{URL}\n";
                print "|    License:     $Package->{License}\n";
                print "|    Description: $Package->{Description}\n";
                print "|    Install:     -p $URL:$Package->{File}\n";
            }
            print
                "+----------------------------------------------------------------------------+\n";
            print "| Install/Upgrade Package: ";
            my $PackageCount = <STDIN>;
            chomp($PackageCount);
            $Count = 0;
            for my $Package (@Packages) {
                $Count++;
                if ( $Count eq $PackageCount ) {
                    my $FileString = $CommonObject{PackageObject}->PackageOnlineGet(
                        Source => $URL,
                        File   => $Package->{File},
                    );
                    $CommonObject{PackageObject}->PackageInstall(
                        String => $FileString,
                        Force  => $Opts{'f'},
                    );
                }
            }
        }
    }
    exit;
}
elsif ( $Opts{a} eq 'p' ) {
    my @Data = $CommonObject{PackageObject}->PackageParse( String => $FileString, );
    for my $Tag (@Data) {
        print STDERR "Tag: $Tag->{Type} $Tag->{Tag} $Tag->{Content}\n";
    }
}
elsif ( $Opts{a} eq 'parse' ) {
    my %Structure = $CommonObject{PackageObject}->PackageParse( String => $FileString, );
    for my $Key ( sort keys %Structure ) {
        if ( ref( $Structure{$Key} ) eq 'ARRAY' ) {
            for my $Data ( @{ $Structure{$Key} } ) {
                print "--------------------------------------\n";
                print "$Key:\n";
                for ( %{$Data} ) {
                    if ( defined($_) && defined( $Data->{$_} ) ) {
                        print "  $_: $Data->{$_}\n";
                    }
                }
            }
        }
        else {
            print "--------------------------------------\n";
            print "$Key:\n";
            for my $Data ( %{ $Structure{$Key} } ) {
                if ( defined( $Structure{$Key}->{$Data} ) ) {
                    print "  $Data: $Structure{$Key}->{$Data}\n";
                }
            }
        }
    }
    exit;
}
elsif ( $Opts{a} eq 'index' ) {
    if ( !$Opts{d} ) {
        die "ERROR: invalid package root location -d is needed!";
    }
    elsif ( !-d $Opts{d} ) {
        die "ERROR: invalid package root location '$Opts{d}'";
    }
    my @Dirs = ();
    print "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n";
    print "<otrs_package_list version=\"1.0\">\n";
    BuildPackageIndex( $Opts{d} );
    print "</otrs_package_list>\n";
}
else {
    print STDERR "ERROR: Invalid -a '$Opts{a}' action\n";
    exit 1;
}

sub BuildPackageIndex {
    my $In = shift;

    my @List = glob("$In/*");
    for my $File (@List) {
        $File =~ s/\/\//\//g;
        if ( -d $File && $File !~ /CVS/ ) {
            BuildPackageIndex($File);
            $File =~ s/$Opts{d}//;

            #            print "Directory: $File\n";
        }
        else {
            my $OrigFile = $File;
            $File =~ s/$Opts{d}//;

            #               print "File: $File\n";
            #               my $Dir =~ s/^(.*)\//$1/;
            if ( $File !~ /Entries|Repository|Root|CVS/ && $File =~ /\.opm$/ ) {

                #               print "F: $File\n";
                my $Content    = '';
                my $ContentRef = $CommonObject{MainObject}->FileRead(
                    Location => $OrigFile,
                    Mode     => 'utf8',      # optional - binmode|utf8
                    Result   => 'SCALAR',    # optional - SCALAR|ARRAY
                );
                if ( !$ContentRef ) {
                    print STDERR "ERROR: Can't open $OrigFile: $!\n";
                    exit 1;
                }
                my %Structure
                    = $CommonObject{PackageObject}->PackageParse( String => ${$ContentRef} );
                my $XML = $CommonObject{PackageObject}->PackageBuild( %Structure, Type => 'Index' );
                print "<Package>\n";
                print $XML;
                print "  <File>$File</File>\n";
                print "</Package>\n";
            }
        }
    }
    return 1;
}

sub _MessageGet {
    my (%Param) = @_;

    my $Title       = '';
    my $Description = '';
    if ( $Param{Info} ) {
        for my $Tag ( @{ $Param{Info} } ) {
            if ( !$Description && $Tag->{Lang} eq 'en' ) {
                $Description = $Tag->{Content} || '';
                $Title       = $Tag->{Title}   || '';
            }
        }
        if ( !$Description ) {
            for my $Tag ( @{ $Param{Info} } ) {
                if ( !$Description ) {
                    $Description = $Tag->{Content} || '';
                    $Title       = $Tag->{Title}   || '';
                }
            }
        }
    }
    if ( !$Param{Reformat} || $Param{Reformat} ne 'No' ) {
        $Title       =~ s/(.{4,78})(?:\s|\z)/| $1\n/gm;
        $Description =~ s/^\s*//mg;
        $Description =~ s/\n/ /gs;
        $Description =~ s/\r/ /gs;
        $Description =~ s/\<style.+?\>.*\<\/style\>//gsi;
        $Description =~ s/\<br(\/|)\>/\n/gsi;
        $Description =~ s/\<(hr|hr.+?)\>/\n\n/gsi;
        $Description =~ s/\<(\/|)(pre|pre.+?|p|p.+?|table|table.+?|code|code.+?)\>/\n\n/gsi;
        $Description =~ s/\<(tr|tr.+?|th|th.+?)\>/\n\n/gsi;
        $Description =~ s/\.+?<\/(td|td.+?)\>/ /gsi;
        $Description =~ s/\<.+?\>//gs;
        $Description =~ s/  / /mg;
        $Description =~ s/&amp;/&/g;
        $Description =~ s/&lt;/</g;
        $Description =~ s/&gt;/>/g;
        $Description =~ s/&quot;/"/g;
        $Description =~ s/&nbsp;/ /g;
        $Description =~ s/^\s*\n\s*\n/\n/mg;
        $Description =~ s/(.{4,78})(?:\s|\z)/| $1\n/gm;
    }
    return (
        Description => $Description,
        Title       => $Title,
    );
}
