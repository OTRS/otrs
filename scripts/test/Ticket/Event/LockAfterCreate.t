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

# Get config object.
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# Get helper object.
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# UIse DoNotSendEmail email backend.
my $Success = $ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::DoNotSendEmail',
);
$Self->True(
    $Success,
    "Set Send Mail Module to DoNotSendEmail",
);

# Set default language to English.
$Success = $ConfigObject->Set(
    Key   => 'DefaultLanguage',
    Value => 'en',
);
$Self->True(
    $Success,
    "Set default language to English",
);

# Disable email checks to create new user.
$Success = $ConfigObject->Set(
    Key   => 'CheckMXRecord',
    Value => 0,
);
$Self->True(
    $Success,
    "Disabled CheckMXRecord",
);

$Success = $ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);
$Self->True(
    $Success,
    "Disabled CheckEmailAddress",
);

# Enable lock after create event.
$Success = $ConfigObject->Set(
    Key   => 'Ticket::EventModulePost###3100-LockAfterCreate',
    Value => {
        Action      => 'AgentTicketPhone|AgentTicketEmail',
        Event       => 'TicketCreate',
        Module      => 'Kernel::System::Ticket::Event::LockAfterCreate',
        Transaction => 0,
    },
);
$Self->True(
    $Success,
    "Enabled event LockAfterCreate",
);

# Create a new user for current test.
my $UserLogin = $Helper->TestUserCreate(
    Groups => ['admin'],
);
my %UserData = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
    User => $UserLogin,
);
my $UserID = $UserData{UserID};

# Create a new customer user for current test.
my $CustomerUserLogin = $Helper->TestCustomerUserCreate();

my %TicketCreateTemplate = (
    Title        => 'Ticket Title',
    QueueID      => 1,
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => 'example.com',
    CustomerUser => $CustomerUserLogin,
    OwnerID      => $UserID,
    UserID       => $UserID,
);

my @Tests = (
    {
        Name         => 'UserID 1',
        Request      => 'Action=AgentTicketPhone',
        TicketCreate => {
            UserID => 1,
        },
        Success => 0,
    },
    {
        Name         => 'Closed Ticket',
        Request      => 'Action=AgentTicketPhone',
        TicketCreate => {
            State => 'closed successful',
        },
        Success => 0,
    },
    {
        Name         => 'Wrong Action',
        Request      => 'Action=AgentTicketActionCommon',
        TicketCreate => {},
        Success      => 0,
    },
    {
        Name         => 'Missing Action',
        Request      => 'SubAction=StoreNew',
        TicketCreate => {},
        Success      => 0,
    },
    {
        Name         => 'Success Phone',
        Request      => 'Action=AgentTicketPhone',
        TicketCreate => {},
        Success      => 1,
    },
    {
        Name         => 'Success Email',
        Request      => 'Action=AgentTicketEmail',
        TicketCreate => {},
        Success      => 1,
    },
);

my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

for my $Test (@Tests) {

    # Fake a web request, as Action is used by the LockAfterCreate event.
    local %ENV = (
        REQUEST_METHOD => 'GET',
        QUERY_STRING   => $Test->{Request} || '',
    );
    CGI->initialize_globals();
    my $Request = Kernel::System::Web::Request->new();

    # Create an unlocked ticket,
    my $TicketID = $TicketObject->TicketCreate(
        %TicketCreateTemplate,
        %{ $Test->{TicketCreate} }
    );
    $Self->True(
        $TicketID,
        "$Test->{Name} TicketCreate() successful for Ticket ID $TicketID",
    );

    # Check ticket lock.
    my $TicketLock = $TicketObject->TicketLockGet( TicketID => $TicketID );
    $Self->Is(
        $TicketLock // 0,
        $Test->{Success},
        "$Test->{Name} TicketLockGet() for Ticket ID $TicketID",
    );

    # Discard web request object as it is used by OM in LockAfterCreate event.
    $Kernel::OM->ObjectsDiscard(
        Objects => ['Kernel::System::Web::Request'],
    );
}

# Cleanup is done by RestoreDatabase.
1;
