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

use Kernel::System::VariableCheck qw( IsArrayRefWithData IsHashRefWithData );

use vars (qw($Self));

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# disable check email address
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0
);

my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

# Get default from database.
return if !$DBObject->Prepare(
    SQL => "
        SELECT COUNT(sd.id)
        FROM sysconfig_default sd
        WHERE
            sd.xml_filename IN (
                'Calendar.xml' ,'CloudServices.xml', 'Daemon.xml', 'Framework.xml', 'GenericInterface.xml',
                'ProcessManagement.xml', 'Ticket.xml'
            )
            AND is_invisible != '1'
        ",
);

my $OTRSSettings;
while ( my @Data = $DBObject->FetchrowArray() ) {
    $OTRSSettings = $Data[0];
}

my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

my @Tests = (
    {
        Name   => 'Correct Search',
        Params => {
            Search => 'LogModule::SysLog',
        },
        ExpectedResult => [
            'LogModule::SysLog::Charset',
            'LogModule::SysLog::Facility',
        ],
        Success => 1,
    },
    {
        Name   => 'Multiple Term Search',
        Params => {
            Search => 'look-up DNS',
        },
        ExpectedResult => [
            'CheckMXRecord::Nameserver',
        ],
        Success => 1,
    },
    {
        Name   => 'Multiple Term Search 2',
        Params => {
            Search => 'look-up      DNS',
        },
        ExpectedResult => [
            'CheckMXRecord::Nameserver',
        ],
        Success => 1,
    },
    {
        Name   => 'Empty Result',
        Params => {
            Search => 'WatcherType',
        },
        ExpectedResult => [],
        Success        => 1,
    },
    {
        Name   => 'Size Result',
        Params => {
            Category => 'OTRS',
        },
        ExpectedResult => $OTRSSettings,
        Success        => 1,
    },
    {
        Name   => 'Invisible Search',
        Params => {
            Search           => 'SystemConfiguration::MaximumDeployments',
            IncludeInvisible => 1,
        },
        ExpectedResult => [
            'SystemConfiguration::MaximumDeployments',
        ],
        Success => 1,
    },
    {
        Name   => '!Invisible Search',
        Params => {
            Search           => 'SystemConfiguration::MaximumDeployments',
            IncludeInvisible => 0,
        },
        ExpectedResult => [],
        Success        => 1,
    },
);

TEST:
for my $Test (@Tests) {

    my @Result = $SysConfigObject->ConfigurationSearch( %{ $Test->{Params} } );

    if ( $Test->{Name} =~ m{Size} ) {
        $Self->Is(
            scalar @Result,
            $Test->{ExpectedResult},
            "$Test->{Name} correct",
        );
        next TEST;
    }

    my %LookupResult = map { $_ => 1 } @Result;

    for my $ExpectedItem ( @{ $Test->{ExpectedResult} } ) {

        $Self->True(
            $LookupResult{$ExpectedItem},
            "$Test->{Name} correct - Found '$ExpectedItem'",
        );
    }
}

1;
