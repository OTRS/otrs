# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get needed objects
my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');
my $LoopProtectionObject = $Kernel::OM->Get('Kernel::System::PostMaster::LoopProtection');

# define needed variable
my $RandomID = $Kernel::OM->Get('Kernel::System::UnitTest::Helper')->GetRandomID();

for my $Module (qw(DB FS)) {

    $ConfigObject->Set(
        Key   => 'LoopProtectionModule',
        Value => "Kernel::System::PostMaster::LoopProtection::$Module",
    );

    # get rand sender address
    my $UserRand1 = 'example-user' . $RandomID . '@example.com';
    my $UserRand2 = 'example-user' . $RandomID . '@example.org';

    $ConfigObject->Set(
        Key   => 'PostmasterMaxEmailsPerAddress',
        Value => { $UserRand2 => 5 },
    );

    my $LoopProtectionObject = Kernel::System::PostMaster::LoopProtection->new();

    my $Check = $LoopProtectionObject->Check( To => $UserRand1 );

    $Self->True(
        $Check || 0,
        "#$Module - Check() - $UserRand1",
    );

    for ( 1 .. 42 ) {
        my $SendEmail = $LoopProtectionObject->SendEmail( To => $UserRand1 );
        $Self->True(
            $SendEmail || 0,
            "#$Module - SendEmail() - #$_ ",
        );
    }

    $Check = $LoopProtectionObject->Check( To => $UserRand1 );

    $Self->False(
        $Check || 0,
        "#$Module - Check() - $UserRand1",
    );

    # now test with per-address limit
    my $SendEmail = $LoopProtectionObject->SendEmail( To => $UserRand2 );
    for ( 1 .. 6 ) {
        my $SendEmail = $LoopProtectionObject->SendEmail( To => $UserRand2 );
        $Self->True(
            $SendEmail || 0,
            "#$Module - SendEmail() - $UserRand2 #$_ (with custom limit)",
        );
        $Check = $LoopProtectionObject->Check( To => $UserRand2 );
    }

    $Check = $LoopProtectionObject->Check( To => $UserRand2 );
    $Self->False(
        $Check || 0,
        "#$Module - Check() - $UserRand2 (with custom limit)",
    );
}

1;
