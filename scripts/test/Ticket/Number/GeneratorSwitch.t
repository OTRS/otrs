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

my @BackendOrder = (
    [qw(AutoIncrement Date DateChecksum)],
    [qw(Date AutoIncrement DateChecksum)],
    [qw(Date DateChecksum AutoIncrement)],
    [qw(DateChecksum AutoIncrement Date)],
    [qw(DateChecksum Date AutoIncrement)],
);

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $DBObject     = $Kernel::OM->Get('Kernel::System::DB');
my $CacheObject  = $Kernel::OM->Get('Kernel::System::Cache');

my $Iterations = 3;

for my $DeleteCounters ( 0, 1 ) {
    for my $Pass ( 1 .. $Iterations ) {
        for my $Index ( 0 .. $#BackendOrder ) {
            for my $Backend ( @{ $BackendOrder[$Index] } ) {

                $ConfigObject->Set(
                    Key   => 'Ticket::NumberGenerator',
                    Value => 'Kernel::System::Ticket::Number::' . $Backend,
                );

                if ($DeleteCounters) {

                    # Delete current counters.
                    return if !$DBObject->Do(
                        SQL => 'DELETE FROM ticket_number_counter',
                    );
                    $CacheObject->CleanUp();
                }

                my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

                my $TicketID = $TicketObject->TicketCreate(
                    Title        => 'Some Ticket Title',
                    QueueID      => 1,
                    Lock         => 'unlock',
                    PriorityID   => 3,
                    StateID      => 4,
                    TypeID       => 1,
                    CustomerID   => '123465',
                    CustomerUser => 'customer@example.com',
                    OwnerID      => 1,
                    UserID       => 1,
                );
                my %Ticket = $TicketObject->TicketGet(
                    TicketID      => $TicketID,
                    DynamicFields => 0,
                    UserID        => 1,
                    Silent        => 0,
                );

                $Self->IsNot(
                    $Ticket{TicketNumber},
                    undef,
                    "TicketNumber Pass $Pass with backend $Backend using order $Index deleting counters $DeleteCounters",
                );
            }
        }
    }
}

# Cleanup is done by RestoreDatabase.

1;
