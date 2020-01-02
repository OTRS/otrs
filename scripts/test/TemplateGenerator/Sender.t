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

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $Helper->GetRandomID();

# create template generator after the dynamic field are created as it gathers all DF in the
# constructor
my $TemplateGeneratorObject = $Kernel::OM->Get('Kernel::System::TemplateGenerator');

my $TestUserLogin = $Helper->TestUserCreate(
    Language => 'en',
);

my %TestUser = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
    User => $TestUserLogin,
);
my $UserObject = $Kernel::OM->Get('Kernel::System::User');

# add SystemAddress
my $SystemAddressEmail    = $Helper->GetRandomID() . '@example.com';
my $SystemAddressRealname = "OTRS-Team";

my $SystemAddressObject = $Kernel::OM->Get('Kernel::System::SystemAddress');

my $SystemAddressID = $SystemAddressObject->SystemAddressAdd(
    Name     => $SystemAddressEmail,
    Realname => $SystemAddressRealname,
    Comment  => 'some comment',
    QueueID  => 1,
    ValidID  => 1,
    UserID   => 1,
);
my %SystemAddressData = $SystemAddressObject->SystemAddressGet( ID => $SystemAddressID );

my $QueueRand = $Helper->GetRandomID();
my $QueueID   = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
    Name                => $QueueRand,
    ValidID             => 1,
    GroupID             => 1,
    FirstResponseTime   => 30,
    FirstResponseNotify => 70,
    UpdateTime          => 240,
    UpdateNotify        => 80,
    SolutionTime        => 2440,
    SolutionNotify      => 90,
    SystemAddressID     => $SystemAddressID,
    SalutationID        => 1,
    SignatureID         => 1,
    UserID              => 1,
    Comment             => 'Some Comment',
);

my @Tests = (
    {
        Name              => 'Simple replace',
        AgentFirstname    => 'John',
        AgentLastname     => 'Doe',
        SystemAddressName => 'Test',
        Result            => {
            SystemAddressName          => "Test <$SystemAddressEmail>",
            AgentNameSystemAddressName => "John Doe via Test <$SystemAddressEmail>",
            AgentName                  => "John Doe <$SystemAddressEmail>",
        },

    },
    {
        Name              => 'Company with dot, requires escaping',
        AgentFirstname    => 'John',
        AgentLastname     => 'Doe',
        SystemAddressName => 'company.com',
        Result            => {
            SystemAddressName          => qq|"company.com" <$SystemAddressEmail>|,
            AgentNameSystemAddressName => qq|"John Doe via company.com" <$SystemAddressEmail>|,
            AgentName                  => "John Doe <$SystemAddressEmail>",
        },
    },
    {
        Name              => 'Username with special character, requires escaping',
        AgentFirstname    => 'Jack (the)',
        AgentLastname     => 'Ripper',
        SystemAddressName => 'Test',
        Result            => {
            SystemAddressName          => "Test <$SystemAddressEmail>",
            AgentNameSystemAddressName => qq|"Jack (the) Ripper via Test" <$SystemAddressEmail>|,
            AgentName                  => qq|"Jack (the) Ripper" <$SystemAddressEmail>|,
        },
    },
);

for my $Test (@Tests) {

    $SystemAddressObject->SystemAddressUpdate(
        %SystemAddressData,
        Realname => $Test->{SystemAddressName},
        UserID   => 1,
    );
    $UserObject->UserUpdate(
        %TestUser,
        UserFirstname => $Test->{AgentFirstname},
        UserLastname  => $Test->{AgentLastname},
        ChangeUserID  => 1,
    );

    for my $DefineEmailFrom (qw(SystemAddressName AgentNameSystemAddressName AgentName)) {

        $ConfigObject->Set(
            Key   => 'Ticket::DefineEmailFrom',
            Value => $DefineEmailFrom,
        );

        my $Result = $TemplateGeneratorObject->Sender(
            QueueID => $QueueID,
            UserID  => $TestUser{UserID}
        );

        $Self->Is(
            $Result,
            $Test->{Result}->{$DefineEmailFrom},
            "$Test->{Name} - $DefineEmailFrom - Sender()",
        );
    }
}

# Cleanup is done by RestoreDatabase.

1;
