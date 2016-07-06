# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get needed objects
my $AutoResponseObject = $Kernel::OM->Get('Kernel::System::AutoResponse');
my $CommandObject      = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::PostMaster::Read');
my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');
my $DBObject           = $Kernel::OM->Get('Kernel::System::DB');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper   = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $RandomID = $Helper->GetRandomID();

# add system address
my $SystemAddressNameRand = 'SystemAddress' . $RandomID;
my $SystemAddressID       = $Kernel::OM->Get('Kernel::System::SystemAddress')->SystemAddressAdd(
    Name     => $SystemAddressNameRand . '@example.com',
    Realname => $SystemAddressNameRand,
    ValidID  => 1,
    QueueID  => 1,
    Comment  => 'Unit test system address',
    UserID   => 1,
);
$Self->True(
    $SystemAddressID,
    "SystemAddressAdd() - $SystemAddressNameRand, $SystemAddressID",
);

# add queue
my $QueueNameRand = 'Queue' . $RandomID;
my $QueueID       = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
    Name            => $QueueNameRand,
    ValidID         => 1,
    GroupID         => 1,
    SystemAddressID => $SystemAddressID,
    SalutationID    => 1,
    SignatureID     => 1,
    Comment         => 'Unit test queue',
    UserID          => 1,
);
$Self->True(
    $QueueID,
    "QueueAdd() - $QueueNameRand, $QueueID",
);

# add auto response
my $AutoResponseNameRand0 = 'AutoResponse' . $RandomID;

my $AutoResponseID = $AutoResponseObject->AutoResponseAdd(
    Name        => $AutoResponseNameRand0,
    Subject     => 'Unit Test AutoResponse Bug#4640',
    Response    => 'OTRS_CUSTOMER_REALNAME tag: <OTRS_CUSTOMER_REALNAME>',
    Comment     => 'Unit test auto response',
    AddressID   => $SystemAddressID,
    TypeID      => 1,
    ContentType => 'text/plain',
    ValidID     => 1,
    UserID      => 1,
);
$Self->True(
    $AutoResponseID,
    "AutoResponseAdd() - $AutoResponseNameRand0, $AutoResponseID",
);

# assign auto response to queue
my $Success = $AutoResponseObject->AutoResponseQueue(
    QueueID         => $QueueID,
    AutoResponseIDs => [$AutoResponseID],
    UserID          => 1,
);
$Self->True(
    $Success,
    "AutoResponseQueue() - success"
);

# get test data
my @Tests = (
    {
        Name => 'Email without Reply-To tag',
        Email =>
            "From: TestFrom\@home.com\nTo: TestTo\@home.com\nSubject: Email without Reply-To tag\nTest Body Email.\n",
        Result => {
            To   => 'TestFrom@home.com',
            Body => 'OTRS_CUSTOMER_REALNAME tag: TestTo@home.com',
            }
    },
    {
        Name => 'Email with Reply-To tag',
        Email =>
            "From: TestFrom\@home.com\nTo: TestTo\@home.com\nReply-To: TestReplyTo\@home.com\nSubject: Email with Reply-To tag\nTest Body Email.\n",
        Result => {
            To   => 'TestReplyTo@home.com',
            Body => 'OTRS_CUSTOMER_REALNAME tag: TestReplyTo@home.com',
            }
    },
);

# run test
for my $Test (@Tests) {

    my $ExitCode;
    my $Result;

    {
        local *STDIN;
        open STDIN, '<:utf8', \$Test->{Email};    ## no critic
        local *STDOUT;
        open STDOUT, '>:utf8', \$Result;          ## no critic

        $ExitCode = $CommandObject->Execute( '--target-queue', $QueueNameRand, '--debug' );
    }

    $Self->Is(
        $ExitCode,
        0,
        "$Test->{Name} - Maint::PostMaster::Read exit code with email input",
    );

    # get test ticket ID
    my ($TicketID) = $Result =~ m{TicketID:\s+(\d+)};
    $Self->True(
        $TicketID,
        "TicketID $TicketID - created from email",
    );

    # get auto repsonse article data
    my @ArticleIDs = $TicketObject->ArticleIndex(
        TicketID => $TicketID,
    );
    my %ArticleAutoResponse = $TicketObject->ArticleGet(
        ArticleID => $ArticleIDs[1],
        UserID    => 1,
    );

    # check auto response article values
    for my $Key ( sort keys %{ $Test->{Result} } ) {

        $Self->Is(
            $ArticleAutoResponse{$Key},
            $Test->{Result}->{$Key},
            "$Test->{Name}, tag $Key",
        );
    }
}

1;
