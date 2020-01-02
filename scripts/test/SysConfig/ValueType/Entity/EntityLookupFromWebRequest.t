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

use CGI;

use vars (qw($Self));

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $HelperObject->GetRandomID();

# Create new entities
my $PriorityID = $Kernel::OM->Get('Kernel::System::Priority')->PriorityAdd(
    Name    => $RandomID,
    ValidID => 1,
    UserID  => 1,
);
$Self->IsNot(
    $PriorityID,
    undef,
    "PriorityAdd() for Priority $RandomID",
);

my $QueueID = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
    Name            => $RandomID,
    ValidID         => 1,
    GroupID         => 1,
    SystemAddressID => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    Comment         => 'Some comment',
    UserID          => 1,
);
$Self->IsNot(
    $QueueID,
    undef,
    "QueueAdd() for Queue $RandomID",
);

my $StateID = $Kernel::OM->Get('Kernel::System::State')->StateAdd(
    Name    => $RandomID,
    Comment => 'some comment',
    ValidID => 1,
    TypeID  => 1,
    UserID  => 1,
);
$Self->IsNot(
    $StateID,
    undef,
    "StateAdd() for State $RandomID",
);

my $TypeID = $Kernel::OM->Get('Kernel::System::Type')->TypeAdd(
    Name    => $RandomID,
    ValidID => 1,
    UserID  => 1,
);
$Self->IsNot(
    $TypeID,
    undef,
    "TypeAdd() for Type $RandomID",
);

my @Tests = (
    {
        Name        => 'Missing EntityType',
        QueryString => "Action=AdminQueue;Subaction=Change;QueueID=$QueueID",
        EntityType  => undef,
        Success     => 0,
    },
    {
        Name          => 'Missing QueueID',
        QueryString   => "Action=AdminQueue;Subaction=Change",
        EntityType    => 'Queue',
        Success       => 1,
        ExpectedValue => undef,
    },
    {
        Name          => 'Wrong EntityType',
        QueryString   => "Action=AdminQueue;Subaction=Change;QueueID=$QueueID",
        EntityType    => 'Type',
        Success       => 1,
        ExpectedValue => undef,
    },
    {
        Name          => 'Wrong Queue EntityType',
        QueryString   => "Action=AdminQueue;Subaction=Change;QueueID=$QueueID" . '1',
        EntityType    => 'Queue',
        Success       => 1,
        ExpectedValue => undef,
    },
    {
        Name          => 'Wrong Priority EntityType',
        QueryString   => "Action=AdminPriority;Subaction=Change;PriorityID=$PriorityID" . '1',
        EntityType    => 'Priority',
        Success       => 1,
        ExpectedValue => undef,
    },
    {
        Name          => 'Wrong State EntityType',
        QueryString   => "Action=AdminState;Subaction=Change;ID=$StateID" . '1',
        EntityType    => 'State',
        Success       => 1,
        ExpectedValue => undef,
    },
    {
        Name          => 'Wrong Type EntityType',
        QueryString   => "Action=AdminType;Subaction=Change;ID=$TypeID" . '1',
        EntityType    => 'Type',
        Success       => 1,
        ExpectedValue => undef,
    },
    {
        Name          => 'Correct Queue EntityType',
        QueryString   => "Action=AdminQueue;Subaction=Change;QueueID=$QueueID",
        EntityType    => 'Queue',
        Success       => 1,
        ExpectedValue => $RandomID,
    },
    {
        Name          => 'Correct Priority EntityType',
        QueryString   => "Action=AdminPriority;Subaction=Change;PriorityID=$PriorityID",
        EntityType    => 'Priority',
        Success       => 1,
        ExpectedValue => $RandomID,
    },
    {
        Name          => 'Correct State EntityType',
        QueryString   => "Action=AdminState;Subaction=Change;ID=$StateID",
        EntityType    => 'State',
        Success       => 1,
        ExpectedValue => $RandomID,
    },
    {
        Name          => 'Correct Type EntityType',
        QueryString   => "Action=AdminType;Subaction=Change;ID=$TypeID",
        EntityType    => 'Type',
        Success       => 1,
        ExpectedValue => $RandomID,
    },
);

TEST:
for my $Test (@Tests) {
    local %ENV = (
        REQUEST_METHOD => 'GET',
        QUERY_STRING   => $Test->{QueryString} // '',
    );

    CGI->initialize_globals();
    my $Request = Kernel::System::Web::Request->new();

    my $EntityName = $Kernel::OM->Get('Kernel::System::SysConfig::ValueType::Entity')->EntityLookupFromWebRequest(
        EntityType => $Test->{EntityType} // '',
    );

    if ( !$Test->{Success} ) {
        $Self->Is(
            $EntityName,
            undef,
            "$Test->{Name} EntityLookupFromWebRequest() - EntityName (No Success)",
        );
        next TEST;
    }

    $Self->Is(
        $EntityName,
        $Test->{ExpectedValue},
        "$Test->{Name} EntityLookupFromWebRequest() - EntityName",
    );

    $Kernel::OM->ObjectsDiscard(
        Objects => [ 'Kernel::System::Web::Request', ],
    );
}

1;
