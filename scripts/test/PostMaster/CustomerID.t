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

# Get needed objects.
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# Get helper object.
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomNumber = $Helper->GetRandomNumber();

# Use Test email backend.
$ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::Test',
);
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => '0',
);

# Create customer company.
my $CustomerName = 'Company' . $RandomNumber;
my $CustomerID   = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanyAdd(
    CustomerID             => $CustomerName,
    CustomerCompanyName    => $CustomerName,
    CustomerCompanyStreet  => $CustomerName,
    CustomerCompanyZIP     => $CustomerName,
    CustomerCompanyCity    => $CustomerName,
    CustomerCompanyCountry => 'Germany',
    CustomerCompanyURL     => 'http://www.otrs.com',
    CustomerCompanyComment => $CustomerName,
    ValidID                => 1,
    UserID                 => 1,
);
$Self->True(
    $CustomerID,
    "CustomerID $CustomerID is created",
);

# Create customer user.
my $CustomerUser             = 'User' . $RandomNumber;
my $CustomerUserEmailAddress = $CustomerUser . '@example.com';
my $CustomerUserLogin        = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
    Source         => 'CustomerUser',
    UserFirstname  => $CustomerUser,
    UserLastname   => $CustomerUser,
    UserCustomerID => $CustomerID,
    UserLogin      => $CustomerUser,
    UserEmail      => $CustomerUserEmailAddress,
    UserPassword   => 'password',
    ValidID        => 1,
    UserID         => 1,
);
$Self->True(
    $CustomerUserLogin,
    "CustomerUser '$CustomerUserLogin' is created",
);

my $UnknownEmailAddress = 'Unknown' . $CustomerUserEmailAddress;

my @Tests = (
    {
        EmailAddress => $UnknownEmailAddress,
        Config       => {
            'PostMaster::NewTicket::AutoAssignCustomerIDForUnknownCustomers' => 0,
        },
        Result => {
            CustomerUserID => $UnknownEmailAddress,
            CustomerID     => '',
        },
    },
    {
        EmailAddress => $UnknownEmailAddress,
        Config       => {
            'PostMaster::NewTicket::AutoAssignCustomerIDForUnknownCustomers' => 1,
        },
        Result => {
            CustomerUserID => $UnknownEmailAddress,
            CustomerID     => $UnknownEmailAddress,
        },
    },
    {
        EmailAddress => $CustomerUserEmailAddress,
        Config       => {
            'PostMaster::NewTicket::AutoAssignCustomerIDForUnknownCustomers' => 0,
        },
        Result => {
            CustomerUserID => $CustomerUserLogin,
            CustomerID     => $CustomerID,
        },
    }
);

for my $Test (@Tests) {

    for my $Setting ( sort keys %{ $Test->{Config} } ) {
        $ConfigObject->Set(
            Key   => $Setting,
            Value => $Test->{Config}->{$Setting}
        );
    }

    my $Email = "From: $Test->{EmailAddress}\nTo: you\@home.com\nSubject: Test\nContent in Body.\n";
    my @Return;

    {
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
            Email                  => \$Email,
        );

        @Return = $PostMasterObject->Run();

        $CommunicationLogObject->ObjectLogStop(
            ObjectLogType => 'Message',
            Status        => 'Successful',
        );
        $CommunicationLogObject->CommunicationStop(
            Status => 'Successful',
        );
    }

    $Self->Is(
        $Return[0],
        1,
        "New ticket is created",
    );
    $Self->True(
        $Return[1],
        "New created ticket ID is $Return[1]",
    );

    my %Ticket = $TicketObject->TicketGet(
        TicketID => $Return[1],
    );

    $Self->Is(
        $Ticket{CustomerID} // '',
        $Test->{Result}->{CustomerID},
        "Ticket customer ID is expected",
    );
    $Self->Is(
        $Ticket{CustomerUserID} // '',
        $Test->{Result}->{CustomerUserID},
        "Ticket customer user ID is expected",
    );
}

# Cleanup is done by RestoreDatabase.

1;
