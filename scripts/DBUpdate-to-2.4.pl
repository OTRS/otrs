#!/usr/bin/perl -w
# --
# DBUpdate-to-2.4.pl - update script to migrate OTRS 2.3.x to 2.4.x
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: DBUpdate-to-2.4.pl,v 1.13 2010-06-17 21:15:48 dz Exp $
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

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';

use vars qw($VERSION);
$VERSION = qw($Revision: 1.13 $) [1];

use Getopt::Std;
use Kernel::Config;
use Kernel::System::CheckItem;
use Kernel::System::Log;
use Kernel::System::Time;
use Kernel::System::Encode;
use Kernel::System::DB;
use Kernel::System::Main;
use Kernel::System::SysConfig;
use Kernel::System::Queue;
use Kernel::System::Ticket;
use Kernel::System::NotificationEvent;

# get options
my %Opts;
getopt( 'h', \%Opts );
if ( $Opts{h} ) {
    print STDOUT "DBUpdate-to-2.4.pl <Revision $VERSION> - Database migration script\n";
    print STDOUT "Copyright (C) 2001-2014 OTRS AG, http://otrs.com/\n";
    exit 1;
}

print STDOUT "Start migration of the system...\n\n";

# instance needed objects (1/2)
my %CommonObject;
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-DBUpdate-to-2.4',
    %CommonObject,
);
$CommonObject{EncodeObject}    = Kernel::System::Encode->new(%CommonObject);
$CommonObject{MainObject}      = Kernel::System::Main->new(%CommonObject);
$CommonObject{TimeObject}      = Kernel::System::Time->new(%CommonObject);
$CommonObject{DBObject}        = Kernel::System::DB->new(%CommonObject);
$CommonObject{SysConfigObject} = Kernel::System::SysConfig->new(%CommonObject);

# initialization if config/xml files

# define config dir
my $ConfigDir = $CommonObject{ConfigObject}->Get('Home') . '/Kernel/Config/Files/';

# check ZZZ files
my %ZZZFiles = (
    ZZZAAuto => -f $ConfigDir . 'ZZZAAuto.pm' ? 1 : 0,
    ZZZAuto  => -f $ConfigDir . 'ZZZAuto.pm'  ? 1 : 0,
);

# rebuild config
my $Success = RebuildConfig();

# error handling
if ( !$Success ) {
    print STDOUT "Can't write config files! Please run bin/otrs.SetPermissions.pl and try again.";
    exit 0;
}

# instance needed objects (2/2)
$CommonObject{ConfigObject}            = Kernel::Config->new();
$CommonObject{QueueObject}             = Kernel::System::Queue->new(%CommonObject);
$CommonObject{TicketObject}            = Kernel::System::Ticket->new(%CommonObject);
$CommonObject{NotificationEventObject} = Kernel::System::NotificationEvent->new(%CommonObject);

# start migration process
CleanUpCacheDir();
MigrateCustomerNotification();

# removed ZZZ files to fix permission problem
ZZZFILE:
for my $ZZZFile ( keys %ZZZFiles ) {
    next ZZZFILE if $ZZZFiles{$ZZZFile};
    unlink $ConfigDir . $ZZZFile . '.pm';
}

print STDOUT "\nMigration of the system completed!\n";

exit 0;

=item RebuildConfig()

rebuild config files (based on Kernel/Config/Files/*.xml)

    RebuildConfig();

=cut

sub RebuildConfig {

    print STDOUT "NOTICE: Rebuild config... ";

    my $Success = $CommonObject{SysConfigObject}->WriteDefault();

    if ( !$Success ) {
        print STDOUT " failed.\n";
        return;
    }

    print STDOUT " done.\n";

    return 1;
}

=item CleanUpCacheDir()

this function removes all cache files

    CleanUpCacheDir();

=cut

sub CleanUpCacheDir {

    print STDOUT "NOTICE: Clean up old cache files... ";

    my $CacheDirectory = $CommonObject{ConfigObject}->Get('TempDir');

    # delete all cache files
    my @CacheFiles = $CommonObject{MainObject}->DirectoryRead(
        Directory => $CacheDirectory,
        Filter    => '*',
    );
    for my $CacheFile (@CacheFiles) {
        next if ( !-f $CacheFile );
        unlink $CacheFile;
    }
    print STDOUT " done.\n";

    return 1;
}

=item MigrateCustomerNotification()

migrate all queue based customer notifications to new event notifications

    MigrateCustomerNotification();

=cut

sub MigrateCustomerNotification {

    print STDOUT "NOTICE: Migrate queue based customer notifications... ";

    # get all queues
    my %Queues = $CommonObject{QueueObject}->GetAllQueues();

    # move enabled notification to new event notitfication
    my %Events;
    for my $QueueID ( keys %Queues ) {
        $CommonObject{DBObject}->Prepare(
            SQL  => 'SELECT state_notify, move_notify, owner_notify FROM queue WHERE id =  ?',
            Bind => [ \$QueueID ],
        );
        while ( my @Row = $CommonObject{DBObject}->FetchrowArray() ) {
            if ( $Row[0] ) {
                push @{ $Events{TicketStateUpdate} }, $QueueID,
            }
            if ( $Row[1] ) {
                push @{ $Events{TicketQueueUpdate} }, $QueueID,
            }
            if ( $Row[2] ) {
                push @{ $Events{TicketOwnerUpdate} }, $QueueID,
            }
        }
    }
    if (%Events) {
        my %Map = (
            TicketStateUpdate => 'Customer::StateUpdate',
            TicketQueueUpdate => 'Customer::QueueUpdate',
            TicketOwnerUpdate => 'Customer::OwnerUpdate',
        );
        for my $Type ( sort keys %Map ) {
            next if !$Events{$Type};
            $CommonObject{DBObject}->Prepare(
                SQL => 'SELECT notification_charset, subject, text, content_type '
                    . 'FROM notifications WHERE '
                    . 'notification_type = ? AND notification_language = \'en\'',
                Bind => [ \$Map{$Type} ],
            );
            my %Notification;
            while ( my @Row = $CommonObject{DBObject}->FetchrowArray() ) {
                %Notification = (
                    Subject => $Row[1],
                    Body    => $Row[2],
                    Type    => $Row[3],
                    Charset => $Row[0],
                );
            }
            $CommonObject{NotificationEventObject}->NotificationAdd(
                Name => "customer-$Type",
                %Notification,
                Data => {
                    Recipients => ['Customer'],
                    Events     => [$Type],
                    QueueID    => $Events{$Type},
                },
                Type    => 'text/plain',
                ValidID => 1,
                UserID  => 1,
            );
        }
    }

    print STDOUT " done.\n";

    return 1;
}

1;
