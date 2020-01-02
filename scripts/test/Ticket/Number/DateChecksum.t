# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
$ConfigObject->Set(
    Key   => 'Ticket::NumberGenerator',
    Value => 'Kernel::System::Ticket::Number::DateChecksum',
);
$ConfigObject->Set(
    Key   => 'SystemID',
    Value => 10,
);

# Delete counters
my $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => 'DELETE FROM ticket_number_counter',
);
$Self->True(
    $Success,
    'Temporary cleared ticket_nuber_counter table',
);

my @Tests = (
    {
        Name           => '2016-01-01 1',
        DateString     => '2016-01-01 00:00:01',
        ExpectedResult => '201601011000001',
    },
    {
        Name           => '2016-01-01 2',
        DateString     => '2016-01-01 00:00:01',
        ExpectedResult => '201601011000002',
    },
    {
        Name           => '2016-01-01 3',
        DateString     => '2016-01-01 12:00:00',
        ExpectedResult => '201601011000003',
    },
    {
        Name           => '2016-01-01 4',
        DateString     => '2016-01-01 23:59:59',
        ExpectedResult => '201601011000004',
    },
    {
        Name           => '2016-01-02 1',
        DateString     => '2016-01-02 00:00:00',
        ExpectedResult => '201601021000001',
    },
    {
        Name           => '2016-01-02 2',
        DateString     => '2016-01-02 00:00:01',
        ExpectedResult => '201601021000002',
    },
    {
        Name           => '2016-12-12 1',
        DateString     => '2016-12-12 23:59:59',
        ExpectedResult => '201612121000001',
    },
    {
        Name           => '2017-01-01 1',
        DateString     => '2017-01-01 00:00:00',
        ExpectedResult => '201701011000001',
    },
);

# Delete current counters.
return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => 'DELETE FROM ticket_number_counter',
);
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

my $TicketNumberGeneratorObject = $Kernel::OM->Get('Kernel::System::Ticket::Number::DateChecksum');

for my $Test (@Tests) {

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => $Test->{DateString},
        },
    );

    $HelperObject->FixedTimeSet($DateTimeObject);

    my $TicketNumber = $TicketNumberGeneratorObject->TicketCreateNumber();

    $Self->Is(
        length $TicketNumber,
        16,
        "$Test->{Name} TicketNumberBuild() length"
    );

    # Remove checksum part to be possible to compare
    chop $TicketNumber;

    $Self->Is(
        $TicketNumber,
        $Test->{ExpectedResult},
        "$Test->{Name} TicketNumberBuild() w/o checksum",
    );
}

# Cleanup is done by RestoreDatabase.

1;
