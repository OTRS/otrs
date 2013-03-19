#!/usr/bin/perl
# --
# bin/otrs.PostMasterDaemon.pl - the daemon for the PostMasterClient.pl client
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

my $Debug = 1;

use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Time;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::DB;
use Kernel::System::PostMaster;

use IO::Socket;

my $PreForkedServer = 1;
my $MaxConnects     = 30;

$SIG{CHLD} = \&StopChild;

my $Children = 0;
my %Children = ();

my $Server = IO::Socket::INET->new(
    LocalPort => 5555,
    LocalHost => 'localhost',
    Type      => SOCK_STREAM,
    Reuse     => 1,
    Listen    => 10,
) || die $@;

for ( 1 .. $PreForkedServer ) {
    MakeNewChild();
}

while (1) {
    sleep;
    for ( my $i = $Children; $i < $PreForkedServer; $i++ ) {
        MakeNewChild();
    }
}

sub MakeNewChild {
    $Children++;
    if ( my $PID = fork() ) {

        # parrent
        print STDERR "($$)Started new child ($PID)\n";
        $Children{$PID} = 1;
    }
    else {

        # child
        my $MaxConnectsCount = 0;
        while ( my $Client = $Server->accept() ) {
            $MaxConnectsCount++;
            print $Client "* --OK-- ($PID/$$)\n";
            my @Input = ();
            my $Data  = 0;
            while ( my $Line = <$Client> ) {
                if ( $Line =~ /^\* --END EMAIL--$/ ) {
                    $Data = 0;
                    if (@Input) {
                        PipeEmail(@Input);
                        print $Client "* --DONE--\n";
                    }
                    else {
                        print $Client "* --ERROR-- Got no data!\n";
                        exit 1;
                    }
                }
                if ($Data) {
                    push( @Input, $Line );
                }
                if ( $Line =~ /^\* --SEND EMAIL--$/ ) {
                    $Data = 1;
                }
            }

            # check max connects
            if ( $MaxConnects <= $MaxConnectsCount ) {
                exit;
            }
        }
    }
    return 1;
}

sub StopChild {
    my $PID = wait;
    print STDERR "($$)StopChild ($PID) (Current Children $Children)\n";
    $Children--;
    delete $Children{$$};

    return 1;
}

sub PipeEmail {
    my (@Email) = @_;

    # create common objects
    my %CommonObject = ();
    $CommonObject{ConfigObject} = Kernel::Config->new();
    $CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
    $CommonObject{TimeObject}   = Kernel::System::Time->new(%CommonObject);
    $CommonObject{LogObject}    = Kernel::System::Log->new(
        LogPrefix => 'OTRS-otrs.PostMasterDaemon.pl',
        %CommonObject,
    );
    $CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);
    $CommonObject{DBObject}   = Kernel::System::DB->new(%CommonObject);

    # debug info
    if ($Debug) {
        $CommonObject{LogObject}->Log(
            Priority => 'debug',
            Message  => 'Email handle (PostMasterDaemon.pl) started...',
        );
    }

    # ... common objects ...
    $CommonObject{PostMaster} = Kernel::System::PostMaster->new( %CommonObject, Email => \@Email );
    my @Return = $CommonObject{PostMaster}->Run();
    if ( !$Return[0] ) {
        $CommonObject{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't process mail, see log sub system!",
        );
    }
    undef $CommonObject{PostMaster};

    # debug info
    if ($Debug) {
        $CommonObject{LogObject}->Log(
            Priority => 'debug',
            Message  => 'Email handle (PostMasterDaemon.pl) stopped.',
        );
    }
    return 1;
}
