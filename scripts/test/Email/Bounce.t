# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --
use strict;
use warnings;
use utf8;

use vars (qw($Self));

$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::DoNotSendEmail',
);

local $ENV{TZ} = 'UTC';
my $Helper     = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $SystemTime = $Kernel::OM->Get('Kernel::System::Time')->TimeStamp2SystemTime(
    String => '2014-01-01 12:00:00',
);
$Helper->FixedTimeSet($SystemTime);

my $EmailObject = $Kernel::OM->Get('Kernel::System::Email');

my @Tests = (
    {
        Name   => 'Simple email',
        Params => {
            From         => 'from@bounce.com',
            To           => 'to@bounce.com',
            'Message-ID' => '<bounce@mail>',
            Email        => <<'EOF',
From: test@home.com
To: test@otrs.com
Message-ID: <original@mail>
Subject: Bounce test

Testmail
EOF
        },
        Result => <<'EOF',
From: test@home.com
To: test@otrs.com
Message-ID: <original@mail>
Subject: Bounce test
Resent-Message-ID: <bounce@mail>
Resent-To: to@bounce.com
Resent-From: from@bounce.com
Resent-Date: Wed, 1 Jan 2014 12:00:00 +0000

Testmail
EOF
    },
);

for my $Test (@Tests) {
    my ( $Header, $Body ) = $EmailObject->Bounce(
        %{ $Test->{Params} }
    );
    $Self->Is(
        $$Header . "\n" . $$Body,
        $Test->{Result},
        "$Test->{Name} Bounce()",
    );
}

1;
