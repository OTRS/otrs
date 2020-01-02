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

use Kernel::System::VariableCheck qw(:all);

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper             = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
my $CacheObject        = $Kernel::OM->Get('Kernel::System::Cache');

$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my $RandomID  = $Helper->GetRandomID();
my $Firstname = "Firstname$RandomID";
my $Lastname  = "Lastname$RandomID";
my $Login     = "Login$RandomID";

# Create test customer user.
my $CustomerUserID = $CustomerUserObject->CustomerUserAdd(
    Source         => 'CustomerUser',
    UserFirstname  => $Firstname,
    UserLastname   => $Lastname,
    UserCustomerID => "Customer$RandomID",
    UserLogin      => $Login,
    UserEmail      => "$Login\@example.com",
    ValidID        => 1,
    UserID         => 1,
);

$Self->True(
    $CustomerUserID,
    "CustomerUserID $CustomerUserID is created",
);

my $CustomerUserConfig = $ConfigObject->Get('CustomerUser');

my @Tests = (
    {
        CustomerUserNameFieldsJoin => '###',
        CustomerUserNameFields     => [ 'first_name', 'last_name' ],
        ExpectedResult             => "$Firstname###$Lastname"
    },
    {
        CustomerUserNameFieldsJoin => '***',
        CustomerUserNameFields     => [ 'first_name', 'last_name' ],
        ExpectedResult             => "$Firstname***$Lastname"
    },
    {
        CustomerUserNameFieldsJoin => undef,
        CustomerUserNameFields     => [ 'first_name', 'last_name' ],
        ExpectedResult             => "$Firstname $Lastname"
    },
    {
        CustomerUserNameFieldsJoin => '###',
        CustomerUserNameFields     => [ 'last_name', 'first_name' ],
        ExpectedResult             => "$Lastname###$Firstname"
    },
    {
        CustomerUserNameFieldsJoin => '***',
        CustomerUserNameFields     => [ 'last_name', 'first_name' ],
        ExpectedResult             => "$Lastname***$Firstname"
    },
    {
        CustomerUserNameFieldsJoin => undef,
        CustomerUserNameFields     => [ 'last_name', 'first_name' ],
        ExpectedResult             => "$Lastname $Firstname"
    },
    {
        CustomerUserNameFieldsJoin => '###',
        CustomerUserNameFields     => [ 'first_name', 'last_name', 'login' ],
        ExpectedResult             => "$Firstname###$Lastname###$Login"
    },
    {
        CustomerUserNameFieldsJoin => undef,
        CustomerUserNameFields     => [ 'first_name', 'last_name', 'login' ],
        ExpectedResult             => "$Firstname $Lastname $Login"
    },
    {
        CustomerUserNameFieldsJoin => ' ',
        CustomerUserNameFields     => [ 'first_name', 'last_name', 'login' ],
        ExpectedResult             => "$Firstname $Lastname $Login"
    },
    {
        CustomerUserNameFieldsJoin => '',
        CustomerUserNameFields     => [ 'first_name', 'last_name', 'login' ],
        ExpectedResult             => "$Firstname$Lastname$Login"
    },
);

for my $Test (@Tests) {

    $CustomerUserConfig->{CustomerUserNameFieldsJoin} = $Test->{CustomerUserNameFieldsJoin};
    $CustomerUserConfig->{CustomerUserNameFields}     = $Test->{CustomerUserNameFields};

    $Helper->ConfigSettingChange(
        Key   => 'CustomerUser',
        Value => $CustomerUserConfig,
    );

    my $Name = $CustomerUserObject->CustomerName(
        UserLogin => $Login,
    );

    $Self->Is(
        $Name,
        $Test->{ExpectedResult},
        "ExpectedResult '$Test->{ExpectedResult}' is correct",
    );

    $CacheObject->CleanUp();
}

# cleanup is done by RestoreDatabase

1;
