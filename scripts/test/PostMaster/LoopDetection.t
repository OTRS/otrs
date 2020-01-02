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

use Kernel::System::PostMaster;

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# This test checks if OTRS correctly detects that an email must not be auto-responded to.
my @Tests = (
    {
        Name => 'Regular mail',
        Email =>
            'From: test@home.com
To: test@home.com
Subject: Testmail

Body
',
        EmailParams => {
            From          => 'test@home.com',
            'X-OTRS-Loop' => '',
        },
    },
    {
        Name => 'Precedence',
        Email =>
            'From: test@home.com
To: test@home.com
Precedence: bulk
Subject: Testmail

Body
',
        EmailParams => {
            From          => 'test@home.com',
            'X-OTRS-Loop' => 'yes',
        },
    },
    {
        Name => 'X-Loop',
        Email =>
            'From: test@home.com
To: test@home.com
X-Loop: yes
Subject: Testmail

Body
',
        EmailParams => {
            From          => 'test@home.com',
            'X-OTRS-Loop' => 'yes',
        },
    },
    {
        Name => 'X-No-Loop',
        Email =>
            'From: test@home.com
To: test@home.com
X-No-Loop: yes
Subject: Testmail

Body
',
        EmailParams => {
            From          => 'test@home.com',
            'X-OTRS-Loop' => 'yes',
        },
    },
    {
        Name => 'X-OTRS-Loop',
        Email =>
            'From: test@home.com
To: test@home.com
X-OTRS-Loop: yes
Subject: Testmail

Body
',
        EmailParams => {
            From          => 'test@home.com',
            'X-OTRS-Loop' => 'yes',
        },
    },
    {
        Name => 'Auto-submitted: auto-generated',
        Email =>
            'From: test@home.com
To: test@home.com
Auto-submitted: auto-generated
Subject: Testmail

Body
',
        EmailParams => {
            From          => 'test@home.com',
            'X-OTRS-Loop' => 'yes',
        },
    },
    {
        Name => 'Auto-Submitted: auto-replied',
        Email =>
            'From: test@home.com
To: test@home.com
Auto-Submitted: auto-replied
Subject: Testmail

Body
',
        EmailParams => {
            From          => 'test@home.com',
            'X-OTRS-Loop' => 'yes',
        },
    },
    {
        Name => 'Auto-submitted: no',
        Email =>
            'From: test@home.com
To: test@home.com
Auto-submitted: no
Subject: Testmail

Body
',
        EmailParams => {
            From          => 'test@home.com',
            'X-OTRS-Loop' => '',
        },
    },
);

for my $Test (@Tests) {

    my @Email = split( /\n/, $Test->{Email} );

    my $CommunicationLogObject = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            Transport => 'Email',
            Direction => 'Incoming',
        },
    );
    $CommunicationLogObject->ObjectLogStart( ObjectLogType => 'Message' );

    my $PostMasterObject = Kernel::System::PostMaster->new(
        CommunicationLogObject => $CommunicationLogObject,
        Email                  => \@Email,
    );

    my $EmailParams = $PostMasterObject->GetEmailParams();

    for my $EmailParam ( sort keys %{ $Test->{EmailParams} } ) {
        $Self->Is(
            $EmailParams->{$EmailParam},
            $Test->{EmailParams}->{$EmailParam},
            "$Test->{Name} - $EmailParam",
        );
    }

    $CommunicationLogObject->ObjectLogStop(
        ObjectLogType => 'Message',
        Status        => 'Successful',
    );
    $CommunicationLogObject->CommunicationStop(
        Status => 'Successful',
    );
}

# cleanup cache is done by RestoreDatabase

1;
