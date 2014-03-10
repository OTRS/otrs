# --
# LoopDetection.t - PostMaster tests for Message ID
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use Kernel::System::PostMaster;
use Kernel::System::Ticket;
use Kernel::Config;

my $ConfigObject = Kernel::Config->new();
my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

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
        %{$Self},
        ConfigObject => $ConfigObject,
        Email        => \@Email,
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
