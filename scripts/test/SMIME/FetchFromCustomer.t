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
use File::Path qw(mkpath rmtree);

use Devel::Peek;

use Kernel::System::Crypt::SMIME;
use Kernel::System::DB;
use Kernel::System::CustomerUser;
use Kernel::System::Console::Command::Maint::SMIME::FetchFromCustomer;

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

# copy all
# discard main + config

my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

# create crypt object
my $CryptObject = $Kernel::OM->Get('Kernel::System::Crypt::SMIME');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $HomeDir = $ConfigObject->Get('Home');

# get existing certificates
my @CertList  = $CryptObject->CertificateList();
my $CertCount = 0;
for my $Cert ( sort @CertList ) {
    $CertCount++;
}

# - first stage
my $TableName             = 'UnitTest_Customer_User_Table_1983272';
my @UnitTestCustomerUsers = (
    {
        FirstName       => 'Hans',
        LastName        => 'Hansen',
        Login           => 'unittest1',
        Email           => 'unittest@example.org',
        Status          => 1,
        CertificateType => 'PEM',
        Certifiacate    => '-----BEGIN CERTIFICATE-----
MIIEXjCCA0agAwIBAgIJAPIBQyBe/HbpMA0GCSqGSIb3DQEBBQUAMHwxCzAJBgNV
BAYTAkRFMQ8wDQYDVQQIEwZCYXllcm4xEjAQBgNVBAcTCVN0cmF1YmluZzEQMA4G
A1UEChMHT1RSUyBBRzERMA8GA1UEAxMIdW5pdHRlc3QxIzAhBgkqhkiG9w0BCQEW
FHVuaXR0ZXN0QGV4YW1wbGUub3JnMB4XDTEyMDUwODEzMTEzMloXDTI2MDExNTEz
MTEzMlowfDELMAkGA1UEBhMCREUxDzANBgNVBAgTBkJheWVybjESMBAGA1UEBxMJ
U3RyYXViaW5nMRAwDgYDVQQKEwdPVFJTIEFHMREwDwYDVQQDEwh1bml0dGVzdDEj
MCEGCSqGSIb3DQEJARYUdW5pdHRlc3RAZXhhbXBsZS5vcmcwggEiMA0GCSqGSIb3
DQEBAQUAA4IBDwAwggEKAoIBAQC2hq1peYGlo4d5Lz8wEGLvUg9pZq4hQhmVwatj
v0q5dNJQ6HZPmzQTZLCEL6Wcn/7MsCQ6v4Avryjf3OPCMV/HTWuoHwmrXzM6Dtr/
3cuUF5L0wOV6wEE+IF6J1OYdObDxRPrz5wZP2XEx3B5yMETksN6qF+g8CwaXwbtl
sR2ZfGo+qxSP+rPs9gy54Xvg2rrgh/SIvKKcFNWX3gJPGg66b0Ne+gOx68u7XREH
y71yzIsCAq52vqBnKySnXIIDG8Lem4LNwlMW993snTK/nE/yhYQkqjcdLpb3EXCq
sxZ+2fpaLFJcU7js5yUDQzncPawy04QNHTrPtC22fJgXFCAZAgMBAAGjgeIwgd8w
HQYDVR0OBBYEFBZG1kwr7OFhLzYO9PEsPJT5OxbaMIGvBgNVHSMEgacwgaSAFBZG
1kwr7OFhLzYO9PEsPJT5OxbaoYGApH4wfDELMAkGA1UEBhMCREUxDzANBgNVBAgT
BkJheWVybjESMBAGA1UEBxMJU3RyYXViaW5nMRAwDgYDVQQKEwdPVFJTIEFHMREw
DwYDVQQDEwh1bml0dGVzdDEjMCEGCSqGSIb3DQEJARYUdW5pdHRlc3RAZXhhbXBs
ZS5vcmeCCQDyAUMgXvx26TAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBBQUAA4IB
AQBE2M1dcTkQyPJUXzchMGIWD5nkUDs0iHqIPNfeTWcTW3iuzZHA6rj4Lw7RFOs+
seYl14DywnYFUM5UZz4ko9t+uqECp4LK6qdkYomjSw+E8Zs5se8QlRYhDEjEDqwR
c0xg0lgybQoceMJ7ub+V/yp/EIyfKbaJBtYIDucQ6yB1EECVm1hfKKLg+gUk4rLY
WgEFDKCVadkItr5yLLMp9CGKWpiv7sW/5f2YVTEZGCcbp2hQRCMPpQYCtvbdfyh5
lZbOYUaP6zWPsKjftcev2Q5ik1L7N9eCynBF3a2U0TPVkfFyzuO58k96vUhKltOb
nj2wbQO4KjM12YLUuvahk5se
-----END CERTIFICATE-----
',
    },
    {
        FirstName       => 'Klaus',
        LastName        => 'Klausen',
        Login           => 'unittest2',
        Email           => 'smimeuser1@test.com',
        Status          => 1,
        CertificateType => 'P7B',
        Certifiacate    => '-----BEGIN CERTIFICATE-----
MIIFjTCCA3UCCQDt3sB/CPz9rjANBgkqhkiG9w0BAQUFADB7MQswCQYDVQQGEwJN
WDEQMA4GA1UECBMHSmFsaXNjbzEQMA4GA1UEChMHT1RSUyBBRzERMA8GA1UECxMI
T1RSUyBMYWIxETAPBgNVBAMTCE9UUlMgTGFiMSIwIAYJKoZIhvcNAQkBFhNvdHJz
bGFiQGV4YW1wbGUuY29tMB4XDTEyMDUxNTAyNTIwNloXDTIyMDUxMzAyNTIwNlow
gZUxCzAJBgNVBAYTAk1YMRAwDgYDVQQIEwdKYWxpc2NvMRQwEgYDVQQHEwtHdWFk
YWxhamFyYTEQMA4GA1UEChMHT1RSUyBBRzERMA8GA1UECxMIT1RSUyBMYWIxFTAT
BgNVBAMTDFNNSU1FIFVzZXIgMTEiMCAGCSqGSIb3DQEJARYTc21pbWV1c2VyMUB0
ZXN0LmNvbTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAJ/cr+sMwWW3
SWLazwZ9O/dScatebBsQ3zEof/f6rO7zSppCPg/iA69VRZ9/wDJLe815bA9UBFXg
M+u/gI0Mnm8JPpPxXc+qqiTyWiNF25Tmxh3BWrFEcrx/3IRQ41G+3mbXWe5NcuWZ
unFbA8OGXW33BqQoV6SZjCxow/uz+YIkNXyNcHYRI87OrvCDhoc7qn7J6RFcDoyb
Sc8Tc5RasFiNvzE2vjodqKmQt1tpjucv15cBtSDTOwANtYYbcFgcUBqUZbeG2MbJ
e8791yXw5ZhoOOahroeszzlwk9r/d8x20iMeKm8O8nGq8+EDDPAZPhyzRfFgQexf
lu34PDGxr8eDniS31ohgMyLx4Kjsl4k5mKk3oxVbc69Y1cRbTbkVOw6gzc+Iyabb
Kuf+xcZQs/QH0IhKLX8yztW72KQJ0Bu0SS9750gkn2Zg2tEwTRnhvoqfLgcqI9Eb
vhYPP5vD17bqFYWizFyWCW7hyb9d41SZREzIT+hCSvRNvQY1HCTRk66pMU62ywjM
1XZmxjiZctQuTlPqHvGU3zF5A2wL4IfnsFGosaQ45nN03tWNfTlpZqHWMEZgmTEq
NGSjVZZUS8CLPq/YXREcWsXZKTFlY5bMhdPZF/PAgKQzPgC+NIkM2dbQGwK9d8P9
tOdHM/Qw6x/56P97uWfMOmKIL0pIygtPAgMBAAEwDQYJKoZIhvcNAQEFBQADggIB
AC32NGijuckU3gSks1pRi2hFzLEmlPcKCyBIjQlylOzUI93v3Bz0DAVcZGb0xw1I
KhNRL+PSF2X7eZi970CrGk5C1JquyS/khLR1kCqEFJshwCTm8ONMpFwXcMPgbRNQ
TNcS+OQTFAS2OV8mqAYLSmYL5e8OgxEUG765ORLU+2QHarMtky4VN1bBzpjCYvzU
UZY1Y3LILjARtJGE5Bl/9/QZTNsUcDKzaxbPT9/SF2JJhM7TkHBcrkm6q+vF3V98
PxdIj/cRPF8cvm9PGQA5JdnoIERGp4+RV8iuVBUPes4qfjQ8rQ1UHtqgscmVtu40
vM22tg7IfjZkj/YUbihj7q+D3GaG9G5qZJA6rIm0A4UKka7xBtIWqqVFDTGGkvAi
hX5OcSIvRiv+l9vBeYs/g4lM1yRLrlD7Zxyj3VdhBm4tJOzWzTp7T12AM9vxtGO7
T6C6nqSZCjGrZ24p0iQky9BrW49xXbGWu8PhxNwxA7ah9keARaTIyiNYgbT9Ey41
5oALXeUDVEVKLZpbkbsSaZ/NEQezMOSkeJxN8zhz9XAizykub3qoN1th0gyuX6SB
cguOn8Sg1O8jzlrZQOT5F6r2BGi4gn/rxIMAOoImAoYyjHZVK0psyGBekh4HYHDl
wpStC0yiqNRd1/r/wkihHv57xSScBPkpdu2Q9RBY36dJ
-----END CERTIFICATE-----
',
    }
);

# TODO - SQL as XML (preprocess?)
# Create Table
$DBObject->Do(
    SQL =>
        "CREATE TABLE $TableName (
        id INTEGER NOT NULL AUTO_INCREMENT,
        login VARCHAR (200) NOT NULL,
        email VARCHAR (150) NOT NULL,
        customer_id VARCHAR (150) NOT NULL,
        pw VARCHAR (64) NULL,
        title VARCHAR (50) NULL,
        first_name VARCHAR (100) NOT NULL,
        last_name VARCHAR (100) NOT NULL,
        userSMIMECertificate LONGBLOB NULL,
        valid_id SMALLINT(6) NOT NULL,
        create_time DATETIME NOT NULL,
        create_by INTEGER NOT NULL,
        change_time DATETIME NOT NULL,
        change_by INTEGER NOT NULL,
        PRIMARY KEY(id),
        UNIQUE INDEX customer_user_login (login)
    )"
);

# Fill Table
my $SQL = "INSERT INTO $TableName
                (login, email, customer_id, pw, title, first_name, last_name, userSMIMECertificate, valid_id, create_time,
                create_by, change_time, change_by)
            VALUES
                (?,?,?,?,?,?,?,?,1,current_timestamp,1,current_timestamp,1)";
my $Pwd = $MainObject->GenerateRandomString(
    Length => 8,
);
foreach my $CustomerUser (@UnitTestCustomerUsers) {
    my $Return = $DBObject->Do(
        SQL  => $SQL,
        Bind => [
            \$CustomerUser->{Login}, \$CustomerUser->{Email}, \'unittest_customer_id',
            \$Pwd,
            \'Mr', \$CustomerUser->{FirstName}, \$CustomerUser->{LastName}, \$CustomerUser->{Certifiacate}
        ],
    );
    $DBObject->Prepare(
        SQL  => "SELECT id, email from $TableName where login = ?",
        Bind => [ \$CustomerUser->{Login} ],
    );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Self->Is(
            $Row[1],
            $CustomerUser->{Email},
            "CustomerUser $Row[0] with $CustomerUser->{CertificateType} added into CustomerUserTable ",
        );
    }
}

# Add Table as CustomerUser Table in Config
# TODO - delete config-file-stuff
my $SetFromFile = 2;
my $NewConfig;
my $FileLocation;
if ( $SetFromFile == 1 ) {
    my $ConfigFile = $MainObject->FileRead(
        Directory => $ConfigObject->Get('Home') . "/scripts/test/sample/SMIME/",
        Filename  => 'LDAPFetchUnitTest.pm',
    );
    $FileLocation = $MainObject->FileWrite(
        Directory => $ConfigObject->Get('Home') . "/Kernel/Config/Files/",
        Filename  => 'LDAPFetchUnitTest.pm',
        Mode      => 'utf8',
        Content   => $ConfigFile,
    );

    # discard $Kernel::OM->Get('Kernel::Config');
    # ForcePackageReload => 1,

    $Self->True(
        $NewConfig,
        "Table was added as another Login Method into Config",
    );
}
else {
    $ConfigObject->Set(
        Key   => "Customer::AuthModule10",
        Value => 'Kernel::System::CustomerAuth::DB',
    );
    $ConfigObject->Set(
        Key   => "Customer::AuthModule::DB::Table10",
        Value => $TableName,
    );
    $ConfigObject->Set(
        Key   => "Customer::AuthModule::DB::CustomerKey10",
        Value => 'login',
    );
    $ConfigObject->Set(
        Key   => "Customer::AuthModule::DB::CustomerPassword10",
        Value => 'pw',
    );
    $ConfigObject->Set(
        Key   => "Customer::AuthModule::DB::CryptType10",
        Value => 'plain',
    );
    my %CustomerUserConfig = (
        Name   => 'Database Backend',
        Module => 'Kernel::System::CustomerUser::DB',
        Params => {
            Table => $TableName,
        },
        ReadOnly => 1,

        # customer unique id
        CustomerKey => 'login',

        # customer #
        CustomerID                         => 'customer_id',
        CustomerUserListFields             => [ 'first_name', 'last_name', 'email' ],
        CustomerUserSearchFields           => [ 'login', 'first_name', 'last_name', 'customer_id' ],
        CustomerUserSearchPrefix           => '*',
        CustomerUserSearchSuffix           => '*',
        CustomerUserSearchListLimit        => 250,
        CustomerUserPostMasterSearchFields => ['email'],
        CustomerUserNameFields     => [ 'title', 'first_name', 'last_name' ],
        CustomerUserEmailUniqCheck => 1,

        # show now own tickets in customer panel, CompanyTickets
        CustomerUserExcludePrimaryCustomerID => 0,

        # admin can't change customer preferences
        AdminSetPreferences => 0,

        # cache time to live in sec. - cache any ldap queries
        CacheTTL => 120,
        Map      => [

            # note: Login, Email and CustomerID are mandatory!
            # if you need additional attributes from AD, just map them here.
            # var, frontend, storage, shown (1=always,2=lite), required, storage-type, http-link, readonly
            [ 'UserSalutation',   'Title or salutation', 'title',                1, 0, 'var', '', 0 ],
            [ 'UserFirstname',    'Firstname',           'first_name',           1, 1, 'var', '', 0 ],
            [ 'UserLastname',     'Lastname',            'last_name',            1, 1, 'var', '', 0 ],
            [ 'UserLogin',        'Username',            'login',                1, 1, 'var', '', 0 ],
            [ 'UserPassword',     'Password',            'pw',                   0, 0, 'var', '', 0 ],
            [ 'UserEmail',        'Email',               'email',                1, 1, 'var', '', 0 ],
            [ 'UserCustomerID',   'CustomerID',          'customer_id',          0, 1, 'var', '', 0 ],
            [ 'SMIMECertificate', 'SMIMECertificate',    'userSMIMECertificate', 0, 1, 'var', '', 0 ],
        ],
    );
    my $Return = $ConfigObject->Set(
        Key   => "CustomerUser10",
        Value => \%CustomerUserConfig,
    );
}

my $AuthObject = $Kernel::OM->Get('Kernel::System::CustomerAuth');

# login check
$DBObject->Prepare(
    SQL => "SELECT id, login, pw, email from $TableName",
);
my %Customers;
while ( my @Row = $DBObject->FetchrowArray() ) {
    $Customers{ $Row[1] } = $Row[2];

    #$Kernel::OM->Get('Kernel::System::Log')->Dumper( 'row', \@Row )
}

for my $Customer ( sort keys %Customers ) {
    my $AuthResult = $AuthObject->Auth(
        User => $Customer,
        Pw   => $Customers{$Customer},
    );

    #$Kernel::OM->Get('Kernel::System::Log')->Dumper( 'login?', $AuthResult );
    $Self->Is(
        $AuthResult,
        $Customer,
        "CustomerUser $Customer login OK",
    );
}

#sleep(15);

# check against existing certificates
@CertList = $CryptObject->CertificateList();
my $OldOKCount = 0;
for my $Cert ( sort @CertList ) {
    $OldOKCount++;
}
$Self->Is(
    $OldOKCount,
    $CertCount,
    "NewCertificates not yet imported",
);

# get CustomerUser-List
my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
my %List               = $CustomerUserObject->CustomerSearch(
    CustomerID => 'unittest_customer_id',
    Valid      => 1,
);

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::SMIME::FetchFromCustomer');

CUSTOMERUSER:
for my $CustomerUser ( sort keys %List ) {
    my %User = $CustomerUserObject->CustomerUserDataGet(
        User => $CustomerUser,
    );
    next CUSTOMERUSER if !$User{SMIMECertificate};

    # 1st try with CertificateSearch
    # add
    my @CertificateFilename = $CryptObject->CertificateSearch(
        Search => $User{UserEmail},
    );

    $Self->True(
        $CertificateFilename[0]{Filename},
        'Certificate for $User{UserEmail} was imported',
    );

    # check
    my $Certificate = $CryptObject->CertificateGet(
        Filename => $CertificateFilename[0]{Filename},
    );

    # remove
    my %Remove = $CryptObject->CertificateRemove(
        Filename => $CertificateFilename[0]{Filename},
    );
    $Self->False(
        $Remove{Success},
        "$Remove{Message}",
    );

    #2nd try - Console Command
    my $ExitCode = $CommandObject->Execute();

    $Self->Is(
        $ExitCode,
        1,
        "Maint::SMIME::FetchFromCustomer exit code without arguments.",
    );

    # check & add
    $ExitCode = $CommandObject->Execute( '--mail', $User{UserEmail}, '--force' );

    my @CertificateFilename2nd = $CryptObject->CertificateSearch(
        Search  => $User{UserEmail},
        DontAdd => 1,
    );

    $Self->True(
        $CertificateFilename2nd[0],
        "Certificate for $User{UserEmail} found",
    );

    # remove
    my %Remove2nd = $CryptObject->CertificateRemove(
        Filename => $CertificateFilename2nd[0]{Filename},
    );
    $Self->False(
        $Remove2nd{Success},
        "$Remove2nd{Message}",
    );

}

# create second customer-table - OK
# use as login - OK
# test fetch and convert as it would be a real ldap - OK

# - second stage
# creat a real LDAP server to test against

$DBObject->Do( SQL => 'Drop table ' . $TableName );

# cleanup is done by RestoreDatabase.

1;
