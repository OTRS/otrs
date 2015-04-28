# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::PostMaster;

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

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

    my $PostMasterObject = Kernel::System::PostMaster->new(
        Email => \@Email,
    );

    my $EmailParams = $PostMasterObject->GetEmailParams();

    for my $EmailParam ( sort keys %{ $Test->{EmailParams} } ) {
        $Self->Is(
            $EmailParams->{$EmailParam},
            $Test->{EmailParams}->{$EmailParam},
            "$Test->{Name} - $EmailParam",
        );
    }
}

1;
