# --
# CustomerCompany.t - CustomerCompany tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
use strict;
use warnings;
use vars (qw($Self));

use Kernel::System::CustomerCompany;
use Kernel::System::XML;
use Kernel::Config;

# create local objects
my $ConfigObject = Kernel::Config->new();
my $XMLObject    = Kernel::System::XML->new( %{$Self} );

my $Data         = $ConfigObject->Get('CustomerCompany');
my $DefaultValue = $Data->{Params}->{Table};

# ------------------------------------------------------------ #
# CustomerCompany test 1 (ForeignDB True)
# ------------------------------------------------------------ #

$Data->{Params} = {
    Table     => 'customer_company_test',
    ForeignDB => 1,
};

$ConfigObject->Set(
    Key   => 'CustomerCompany',
    Value => \%{$Data},
);

#Create on fly data table
my $XML = '
<Table Name="customer_company_test">
    <Column Name="customer_id" Required="true" PrimaryKey="true" Size="150" Type="VARCHAR"/>
    <Column Name="name" Required="true" Size="200" Type="VARCHAR"/>
    <Column Name="street" Required="false" Size="200" Type="VARCHAR"/>
    <Column Name="zip" Required="false" Size="200" Type="VARCHAR"/>
    <Column Name="city" Required="false" Size="200" Type="VARCHAR"/>
    <Column Name="country" Required="false" Size="200" Type="VARCHAR"/>
    <Column Name="url" Required="false" Size="200" Type="VARCHAR"/>
    <Column Name="comments" Required="false" Size="250" Type="VARCHAR"/>
    <Column Name="valid_id" Required="true" Type="SMALLINT"/>
    <Unique Name="customer_company_test_name">
        <UniqueColumn Name="name"/>
    </Unique>
</Table>
';
my @XMLARRAY = $XMLObject->XMLParse( String => $XML );
my @SQL = $Self->{DBObject}->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    'SQLProcessor() CREATE TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $Self->{DBObject}->Do( SQL => $SQL ) || 0,
        "Do() CREATE TABLE ($SQL)",
    );
}

$Data->{Params} = {
    Table     => 'customer_company_test',
    ForeignDB => 1,
};

$ConfigObject->Set(
    Key   => 'CustomerCompany',
    Value => \%{$Data},
);

my $CustomerCompanyObject = Kernel::System::CustomerCompany->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

for my $Key ( 1 .. 3 ) {

    my $CompanyRand = 'Example-Customer-Company' . $Key . int( rand(1000000) );
    $Self->{EncodeObject}->EncodeInput( \$CompanyRand );

    my $CustomerID = $CustomerCompanyObject->CustomerCompanyAdd(
        CustomerID             => $CompanyRand,
        CustomerCompanyName    => $CompanyRand . ' Inc',
        CustomerCompanyStreet  => 'Some Street',
        CustomerCompanyZIP     => '12345',
        CustomerCompanyCity    => 'Some city',
        CustomerCompanyCountry => 'USA',
        CustomerCompanyURL     => 'http://example.com',
        CustomerCompanyComment => 'some comment',
        ValidID                => 1,
        UserID                 => 1,
    );

    $Self->True(
        $CustomerID,
        "CustomerCompanyAdd() - $CustomerID",
    );

    my %CustomerCompany = $CustomerCompanyObject->CustomerCompanyGet(
        CustomerID => $CustomerID,
    );

    $Self->Is(
        $CustomerCompany{CustomerCompanyName},
        "$CompanyRand Inc",
        "CustomerCompanyGet() - 'Company Name'",
    );

    $Self->Is(
        $CustomerCompany{CustomerID},
        "$CompanyRand",
        "CustomerCompanyGet() - CustomerID",
    );

    $Self->Is(
        $CustomerCompany{CreateTime},
        undef,
        "CustomerCompanyGet() - CreateTime Not define",
    );

    $Self->Is(
        $CustomerCompany{ChangeTime},
        undef,
        "CustomerCompanyGet() - ChangeTime Not Define",
    );

    # check cache
    %CustomerCompany = $CustomerCompanyObject->CustomerCompanyGet(
        CustomerID => $CustomerID,
    );

    $Self->Is(
        $CustomerCompany{CustomerCompanyName},
        "$CompanyRand Inc",
        "CustomerCompanyGet() cached - 'Company Name'",
    );

    $Self->Is(
        $CustomerCompany{CustomerID},
        "$CompanyRand",
        "CustomerCompanyGet() cached - CustomerID",
    );

    $Self->Is(
        $CustomerCompany{CreateTime},
        undef,
        "CustomerCompanyGet() cached - CreateTime Not define",
    );

    $Self->Is(
        $CustomerCompany{ChangeTime},
        undef,
        "CustomerCompanyGet() cached - ChangeTime Not Define",
    );

    my $Update = $CustomerCompanyObject->CustomerCompanyUpdate(
        CustomerCompanyID      => $CompanyRand,
        CustomerID             => $CompanyRand . '- updated',
        CustomerCompanyName    => $CompanyRand . '- updated Inc',
        CustomerCompanyStreet  => 'Some Street',
        CustomerCompanyZIP     => '12345',
        CustomerCompanyCity    => 'Some city',
        CustomerCompanyCountry => 'USA',
        CustomerCompanyURL     => 'http://updated.example.com',
        CustomerCompanyComment => 'some comment updated',
        ValidID                => 1,
        UserID                 => 1,
    );

    $Self->True(
        $Update,
        "CustomerCompanyUpdate() - $CustomerID",
    );

    %CustomerCompany = $CustomerCompanyObject->CustomerCompanyGet(
        CustomerID => $CompanyRand . '- updated',
    );

    $Self->Is(
        $CustomerCompany{CustomerCompanyName},
        "$CompanyRand- updated Inc",
        "CustomerCompanyGet() - 'Company Name'",
    );

    $Self->Is(
        $CustomerCompany{CustomerID},
        "$CompanyRand- updated",
        "CustomerCompanyGet() - CustomerID",
    );

    $Self->Is(
        $CustomerCompany{CustomerCompanyComment},
        "some comment updated",
        "CustomerCompanyGet() - Comment",
    );

    $Self->Is(
        $CustomerCompany{CustomerCompanyURL},
        "http://updated.example.com",
        "CustomerCompanyGet() - Comment",
    );

    $Self->Is(
        $CustomerCompany{CreateTime},
        undef,
        "CustomerCompanyGet() - CreateTime Not define",
    );

    $Self->Is(
        $CustomerCompany{ChangeTime},
        undef,
        "CustomerCompanyGet() - ChangeTime Not Define",
    );

    $CustomerCompanyObject->CustomerCompanyUpdate(
        CustomerCompanyID      => $CompanyRand . '- updated',
        CustomerID             => $CompanyRand . '- updated',
        CustomerCompanyName    => $CompanyRand . '- updated Inc',
        CustomerCompanyStreet  => 'Some Street',
        CustomerCompanyZIP     => '12345',
        CustomerCompanyCity    => 'Some city',
        CustomerCompanyCountry => 'Germany',
        CustomerCompanyURL     => 'http://updated.example.com',
        CustomerCompanyComment => 'some comment updated',
        ValidID                => 1,
        UserID                 => 1,
    );

    %CustomerCompany = $CustomerCompanyObject->CustomerCompanyGet(
        CustomerID => $CompanyRand . '- updated',
    );

    $Self->Is(
        $CustomerCompany{CustomerCompanyCountry},
        'Germany',
        "CustomerCompanyGet() cached - Changed country from USA to Germany and check value",
    );
}

$XML      = '<TableDrop Name="customer_company_test"/>';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );
@SQL      = $Self->{DBObject}->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    'SQLProcessor() DROP TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $Self->{DBObject}->Do( SQL => $SQL ) || 0,
        "Do() DROP TABLE ($SQL)",
    );
}

# ------------------------------------------------------------ #
# CustomerCompany test 1 (ForeignDB False)
# ------------------------------------------------------------ #

$Data->{Params} = {
    Table     => $DefaultValue,
    ForeignDB => 0,
};

$ConfigObject->Set(
    Key   => 'CustomerCompany',
    Value => \%{$Data},
);

$CustomerCompanyObject = Kernel::System::CustomerCompany->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

for my $Key ( 1 .. 3 ) {

    my $CompanyRand = 'Example-Customer-Company' . $Key . int( rand(1000000) );
    $Self->{EncodeObject}->EncodeInput( \$CompanyRand );

    my $CustomerID = $CustomerCompanyObject->CustomerCompanyAdd(
        CustomerID             => $CompanyRand,
        CustomerCompanyName    => $CompanyRand . ' Inc',
        CustomerCompanyStreet  => 'Some Street',
        CustomerCompanyZIP     => '12345',
        CustomerCompanyCity    => 'Some city',
        CustomerCompanyCountry => 'USA',
        CustomerCompanyURL     => 'http://example.com',
        CustomerCompanyComment => 'some comment',
        ValidID                => 1,
        UserID                 => 1,
    );

    $Self->True(
        $CustomerID,
        "CustomerCompanyAdd() - $CustomerID",
    );

    my %CustomerCompany = $CustomerCompanyObject->CustomerCompanyGet(
        CustomerID => $CustomerID,
    );

    $Self->Is(
        $CustomerCompany{CustomerCompanyName},
        "$CompanyRand Inc",
        "CustomerCompanyGet() - 'Company Name'",
    );

    $Self->Is(
        $CustomerCompany{CustomerID},
        "$CompanyRand",
        "CustomerCompanyGet() - CustomerID",
    );

    $Self->True(
        $CustomerCompany{CreateTime},
        "CustomerCompanyGet() - CreateTime",
    );

    $Self->True(
        $CustomerCompany{ChangeTime},
        "CustomerCompanyGet() - ChangeTime",
    );

    my $Update = $CustomerCompanyObject->CustomerCompanyUpdate(
        CustomerCompanyID      => $CompanyRand,
        CustomerID             => $CompanyRand . '- updated',
        CustomerCompanyName    => $CompanyRand . '- updated Inc',
        CustomerCompanyStreet  => 'Some Street',
        CustomerCompanyZIP     => '12345',
        CustomerCompanyCity    => 'Some city',
        CustomerCompanyCountry => 'USA',
        CustomerCompanyURL     => 'http://updated.example.com',
        CustomerCompanyComment => 'some comment updated',
        ValidID                => 1,
        UserID                 => 1,
    );

    $Self->True(
        $Update,
        "CustomerCompanyUpdate() - $CustomerID",
    );

    %CustomerCompany = $CustomerCompanyObject->CustomerCompanyGet(
        CustomerID => $CompanyRand . '- updated',
    );

    $Self->Is(
        $CustomerCompany{CustomerCompanyName},
        "$CompanyRand- updated Inc",
        "CustomerCompanyGet() - 'Company Name'",
    );

    $Self->Is(
        $CustomerCompany{CustomerID},
        "$CompanyRand- updated",
        "CustomerCompanyGet() - CustomerID",
    );

    $Self->Is(
        $CustomerCompany{CustomerCompanyComment},
        "some comment updated",
        "CustomerCompanyGet() - Comment",
    );

    $Self->Is(
        $CustomerCompany{CustomerCompanyURL},
        "http://updated.example.com",
        "CustomerCompanyGet() - Comment",
    );

    $Self->True(
        $CustomerCompany{CreateTime},
        "CustomerCompanyGet() - CreateTime",
    );

    $Self->True(
        $CustomerCompany{ChangeTime},
        "CustomerCompanyGet() - ChangeTime",
    );

    $CustomerCompanyObject->CustomerCompanyUpdate(
        CustomerCompanyID      => $CompanyRand . '- updated',
        CustomerID             => $CompanyRand . '- updated',
        CustomerCompanyName    => $CompanyRand . '- updated Inc',
        CustomerCompanyStreet  => 'Some Street',
        CustomerCompanyZIP     => '12345',
        CustomerCompanyCity    => 'Some city',
        CustomerCompanyCountry => 'Germany',
        CustomerCompanyURL     => 'http://updated.example.com',
        CustomerCompanyComment => 'some comment updated',
        ValidID                => 1,
        UserID                 => 1,
    );

    %CustomerCompany = $CustomerCompanyObject->CustomerCompanyGet(
        CustomerID => $CompanyRand . '- updated',
    );

    $Self->Is(
        $CustomerCompany{CustomerCompanyCountry},
        'Germany',
        "CustomerCompanyGet() cached - Changed country from USA to Germany and check value",
    );
}

my %CustomerCompanyList = $CustomerCompanyObject->CustomerCompanyList( Valid => 0 );
my $CompanyList = %CustomerCompanyList ? 1 : 0;

# check CustomerCompanyList with Valid=>0
$Self->True(
    $CompanyList,
    "CustomerCompanyList() with Valid=>0",
);

%CustomerCompanyList = $CustomerCompanyObject->CustomerCompanyList(
    Search => 'Example',
    Valid  => 0,
);

$Self->True(
    scalar keys %CustomerCompanyList,
    "CustomerCompanyList() with Search",
);

%CustomerCompanyList = $CustomerCompanyObject->CustomerCompanyList(
    Search => 'Foo-123FALSE-Example*',
    Valid  => 0,
);

$Self->False(
    scalar keys %CustomerCompanyList,
    "CustomerCompanyList() with Search",
);

1;
