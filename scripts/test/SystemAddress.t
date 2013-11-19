# --
# SystemAddress.t - SystemAddress tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# $Id: SystemAddress.t,v 1.3 2010-10-29 22:16:59 en Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;

use Kernel::System::SystemAddress;

my $SystemAddressObject = Kernel::System::SystemAddress->new( %{$Self} );

# add SystemAddress
my $SystemAddressEmail    = 'example-SystemAddress' . int( rand(1000000) ) . '@example.com';
my $SystemAddressRealname = "OTRS-Team";

my $SystemAddressID = $SystemAddressObject->SystemAddressAdd(
    Name     => $SystemAddressEmail,
    Realname => $SystemAddressRealname,
    Comment  => 'some comment',
    QueueID  => 2,
    ValidID  => 1,
    UserID   => 1,
);

$Self->True(
    $SystemAddressID,
    'SystemAddressAdd()',
);

my %SystemAddress = $SystemAddressObject->SystemAddressGet( ID => $SystemAddressID );

$Self->Is(
    $SystemAddress{Name},
    $SystemAddressEmail,
    'SystemAddressGet() - Name',
);
$Self->Is(
    $SystemAddress{Realname},
    $SystemAddressRealname,
    'SystemAddressGet() - Realname',
);
$Self->Is(
    $SystemAddress{Comment},
    'some comment',
    'SystemAddressGet() - Comment',
);
$Self->Is(
    $SystemAddress{QueueID},
    2,
    'SystemAddressGet() - QueueID',
);
$Self->Is(
    $SystemAddress{ValidID},
    1,
    'SystemAddressGet() - ValidID',
);

my %SystemAddressList = $SystemAddressObject->SystemAddressList( Valid => 0 );
my $Hit = 0;
for ( sort keys %SystemAddressList ) {
    if ( $_ eq $SystemAddressID ) {
        $Hit = 1;
    }
}
$Self->True(
    $Hit eq 1,
    'SystemAddressList()',
);

my @Tests = (
    {
        Address => uc($SystemAddressEmail),
        QueueID => 2,
    },
    {
        Address => lc($SystemAddressEmail),
        QueueID => 2,
    },
    {
        Address => $SystemAddressEmail,
        QueueID => 2,
    },
    {
        Address => '2' . $SystemAddressEmail,
        QueueID => undef,
    },
    {
        Address => ', ' . $SystemAddressEmail,
        QueueID => undef,
    },
    {
        Address => ')' . $SystemAddressEmail,
        QueueID => undef,
    },
);
for my $Test (@Tests) {
    my $QueueID = $SystemAddressObject->SystemAddressQueueID( Address => $Test->{Address} );
    $Self->Is(
        $QueueID,
        $Test->{QueueID},
        "SystemAddressQueueID() - $Test->{Address}",
    );
}

my $SystemAddressUpdate = $SystemAddressObject->SystemAddressUpdate(
    ID       => $SystemAddressID,
    Name     => '2' . $SystemAddressEmail,
    Realname => '2' . $SystemAddressRealname,
    Comment  => 'some comment 1',
    QueueID  => 1,
    ValidID  => 2,
    UserID   => 1,
);
$Self->True(
    $SystemAddressUpdate,
    'SystemAddressUpdate()',
);

%SystemAddress = $SystemAddressObject->SystemAddressGet( ID => $SystemAddressID );

$Self->Is(
    $SystemAddress{Name},
    '2' . $SystemAddressEmail,
    'SystemAddressGet() - Name',
);
$Self->Is(
    $SystemAddress{Realname},
    '2' . $SystemAddressRealname,
    'SystemAddressGet() - Realname',
);
$Self->Is(
    $SystemAddress{Comment},
    'some comment 1',
    'SystemAddressGet() - Comment',
);
$Self->Is(
    $SystemAddress{QueueID},
    1,
    'SystemAddressGet() - QueueID',
);
$Self->Is(
    $SystemAddress{ValidID},
    2,
    'SystemAddressGet() - ValidID',
);

1;
