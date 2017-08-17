# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;
use Data::Dumper;
use vars (qw($Self));

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        # RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');


# Testing

# force-delete        => Delete even if still processing.
# purge               => Purges successful communications older than a week and all communications older than a month.
# delete-by-hours-old => Delete logs older than these number of hours. Example: --delete-by-hours-old="7"
# delete-by-date      => Delete from specific date. Example: --delete-by-date="2001-12-01"
# delete-by-id        => Delete logs from CommunicationID. Example: --delete-by-id="abcdefg12345"

# only one of there
# delete-by-id, delete-by-date, delete-by-hours-old, purge


my $CommandObject         = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Log::CommunicationLog');
my $CommunicationDBObject = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');

my ( $Result, $ExitCode );
{
    local *STDERR;
    open STDERR, '>:encoding(UTF-8)', \$Result;
    $ExitCode = $CommandObject->Execute();
    $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Result );
}

$Self->Is(
    $ExitCode,
    1,
    "Maint::Log::CommunicationLog exit code without arguments.",
);
$Self->True(
    index( $Result, 'Either --purge' ) > -1,
    "Return Help Message for no arguments.",
);

my @InvalidCombinations = (
    ['--delete-by-id', '123', '--delete-by-date', '2017-01-01'],
    # ['--delete-by-id', '123', '--delete-by-hours-old', '8'],
    # ['--delete-by-id', '123', '--purge'],
    # ['--delete-by-date', '2017-01-01', '--delete-by-hours-old', '8'],
    # ['--delete-by-date', '2017-01-01', '--purge'],
    # ['--delete-by-hours-old', '8', '--purge'],
    # ['--delete-by-id', '123', '--delete-by-date', '2017-01-01', '--delete-by-hours-old', '8'],
    # ['--delete-by-id', '123', '--delete-by-date', '2017-01-01', '--purge'],
    # ['--delete-by-id', '123', '--delete-by-hours-old', '8', '--purge'],
    # ['--delete-by-date', '2017-01-01', '--delete-by-hours-old', '8', '--purge'],
    );

# for my $InvalidCombination (@InvalidCombinations) {
#     my $tmp = join(", ", @$InvalidCombination);
#     {
#         local *STDERR;
#         open STDERR, '>:encoding(UTF-8)', \$Result;
#         $ExitCode = $CommandObject->Execute( @$InvalidCombination );
#         $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Result );
#     }
#     $Self->Is(
#         $ExitCode,
#         1,
#         "Maint::Log::CommunicationLog exit code with invalid combination ( $tmp ).",
#     );
#     $Self->True(
#         index( $Result, 'Only one type of action allowed per execution' ) > -1,
#         "Return Help Message for invalid combination ($tmp).",
#     );

# }

#$ExitCode = $CommandObject->Execute( '--delete-by-id', '123', '--delete-by-date', '2017-01-01');
# $ExitCode = $CommandObject->Execute( '', $Tickets[0]->{TicketID}, '--ticket-id', $Tickets[1]->{TicketID} );

my $CommunicationLogObject1 = $Kernel::OM->Create(
    'Kernel::System::CommunicationLog',
    ObjectParams => {
        Transport => 'Email',
        Direction => 'Incoming',
    }
);

my $CommunicationLogObject2 = $Kernel::OM->Create(
    'Kernel::System::CommunicationLog',
    ObjectParams => {
        Transport => 'Email',
        Direction => 'Outgoing',
    }
);

my $CommunicationID1 = $CommunicationLogObject1->CommunicationIDGet();
my $CommunicationID2 = $CommunicationLogObject2->CommunicationIDGet();

my $Communications = $CommunicationDBObject->CommunicationList();

my $RunTest = sub {
    my $Test = shift;
    my ($ExitCode, $Result);



    if ($Test->{Output} && $Test->{Output} eq 'STDOUT') {
        local *STDOUT;
        open STDOUT, '>:encoding(UTF-8)', \$Result;
        $ExitCode = $CommandObject->Execute( @{ $Test->{Params} } );
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Result );
    }
    else {
        local *STDERR;
        open STDERR, '>:encoding(UTF-8)', \$Result;
        $ExitCode = $CommandObject->Execute( @{ $Test->{Params} } );
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Result );
    }

    $Self->Is(
        $ExitCode,
        $Test->{ExpectedExitCode},
        "$Test->{Name} Exit Code: $Test->{ExpectedExitCode}",
    );

    $Self->True(
        index( $Result, $Test->{ExpectedResult} ) > -1,
        "$Test->{Name} expected result: '$Test->{ExpectedResult}'",
    );
};

my @Tests = (
    {
        Name             => 'No arguments given',
        ExpectedResult   => 'Either --purge, --delete-by-id, --delete-by-date or --delete-by-hours-old must be given!',
        ExpectedExitCode => 1,
        Output           => 'STDERR',
        Params           => undef,
    },
    {
        Name             => 'Invalid combination 1',
        ExpectedResult   => 'Only one type of action allowed per execution',
        ExpectedExitCode => 1,
        Params           => ['--delete-by-id', '123', '--delete-by-date', '2017-01-01'],
    },
    {
        Name             => 'Cannot delete processing communication without force.',
        ExpectedResult   => 'No communications found for deletion!',
        ExpectedExitCode => 0,
        Output           => 'STDOUT',
        Params           => ['--delete-by-id', $CommunicationID1 ],
    },
    {
        Name             => 'Cannot delete processing communication without force.',
        ExpectedResult   => 'Done',
        ExpectedExitCode => 1,
        Output           => 'STDOUT',
        Params           => ['--delete-by-id', $CommunicationID1, '--force-delete' ],
    },

);

for my $Test (@Tests) {
    $RunTest->( $Test );
}


# {
#     local *STDERR;
#     open STDERR, '>:encoding(UTF-8)', \$Result;
#     $ExitCode = $CommandObject->Execute( '--delete-by-id', $CommunicationID1 );
#     $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Result );

#     $Self->Is(
#         $ExitCode,
#         0,
#         "Maint::Log::CommunicationLog 'delete-by-id' exit code: Cannot delete processing communication without force.",
#     );
#     $Self->True(
#         index( $Result, 'No communications found for deletion!' ) > -1,
#         "Maint::Log::CommunicationLog 'delete-by-id': Cannot delete processing communication without force.",
#     );

# }



# {
#     local *STDERR;
#     open STDERR, '>:encoding(UTF-8)', \$Result;
#     $ExitCode = $CommandObject->Execute( '--delete-by-id', $CommunicationID1, '--force-delete' );
#     $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Result );
# }

# $Self->Is(
#     $ExitCode,
#     0,
#     "Maint::Log::CommunicationLog 'delete-by-id' exit code: Deleted processing communication with force.",
# );
# $Self->True(
#     index( $Result, 'No communications found for deletion!' ) > -1,
#     "Maint::Log::CommunicationLog 'delete-by-id': Deleted processing communication without force.",
# );
# my $Communications = $CommunicationDBObject->CommunicationList();
# print STDERR "ja so tenho uma comunication? ", scalar (@$Communications), "\n";

# cleanup is done by RestoreDatabase


1;