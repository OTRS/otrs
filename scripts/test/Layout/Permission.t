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

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

my ( $TestUserLogin, $UserID ) = $HelperObject->TestUserCreate(
    Groups => ['users'],
);
$Self->True(
    $UserID,
    'UserID exists',
);

$LayoutObject->{UserID}   = $UserID;
$LayoutObject->{UserType} = 'Agent';

my %CommonParameters = (
    "AccessKey"   => "m",
    "Block"       => "",
    "CSS"         => "",
    "Description" => "Create new email ticket and send this out (outbound).",
    "Link"        => "Action=AgentTicketEmail",
    "LinkOption"  => "",
    "Name"        => "New email ticket",
    "NavBar"      => "Ticket",
    "Prio"        => 210,
    "Type"        => "",
);

my @Tests = (
    {
        Title  => 'Group and GroupRo not defined',
        Config => {
            Group   => undef,
            GroupRo => undef,
        },
        Params => {
            Action => 'AgentTicketEmail',
            Type   => 'rw',
        },
        ExpectedResult => 1,
    },
    {
        Title  => 'Group and GroupRo empty',
        Config => {
            Group   => [],
            GroupRo => [],
        },
        Params => {
            Action => 'AgentTicketEmail',
            Type   => 'rw',
        },
        ExpectedResult => 1,
    },
    {
        Title  => 'Group set to admin',
        Config => {
            Group   => ['admin'],
            GroupRo => [],
        },
        Params => {
            Action => 'AgentTicketEmail',
            Type   => 'rw',
        },
        ExpectedResult => 0,
    },
    {
        Title  => 'GroupRo set to admin',
        Config => {
            Group   => [],
            GroupRo => ['admin'],
        },
        Params => {
            Action => 'AgentTicketEmail',
            Type   => 'rw',
        },
        ExpectedResult => 0,
    },
    {
        Title  => 'Group and GroupRo set to different group',
        Config => {
            Group   => ['admin'],
            GroupRo => ['rogroup'],
        },
        Params => {
            Action => 'AgentTicketEmail',
            Type   => 'rw',
        },
        ExpectedResult => 0,
    },
    {
        Title  => 'Group set to user group',
        Config => {
            Group   => ['users'],
            GroupRo => [],
        },
        Params => {
            Action => 'AgentTicketEmail',
            Type   => 'rw',
        },
        ExpectedResult => 1,
    },
    {
        Title  => 'GroupRo set to user group(Type is rw)',
        Config => {
            Group   => [],
            GroupRo => ['users'],
        },
        Params => {
            Action => 'AgentTicketEmail',
            Type   => 'rw',
        },
        ExpectedResult => 0,
    },
    {
        Title  => 'GroupRo set to user group(Type is ro)',
        Config => {
            Group   => [],
            GroupRo => ['users'],
        },
        Params => {
            Action => 'AgentTicketEmail',
            Type   => 'ro',
        },
        ExpectedResult => 1,
    },
);

for my $Test (@Tests) {

    if ( $Test->{Config} ) {

        # Set config.
        $HelperObject->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::Module###AgentTicketEmail',
            Value => {
                %CommonParameters,
                %{ $Test->{Config} },
            },
        );
    }

    my $Access = $LayoutObject->Permission(
        %{ $Test->{Params} },
    );

    $Self->Is(
        $Access,
        $Test->{ExpectedResult},
        "$Test->{Title} - Check expected result",
    );
}

1;
