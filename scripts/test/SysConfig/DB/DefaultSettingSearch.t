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
my $RandomNumber = $HelperObject->GetRandomNumber();

my @Tests = (
    {
        Name    => 'Empty',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'Missing Search',
        Config => {
            SearchType => 'XMLContent',
        },
        Success => 0,
    },
    {
        Name   => 'Search XMLContent WrongSearch',
        Config => {
            Search     => "OTRSNoneExsitingString$RandomNumber-UnitTest",
            SearchType => 'XMLContent',
        },
        ExpectedResultsInclude => [],
        Success                => 1,
    },
    {
        Name   => 'Search Metadata WrongSearch',
        Config => {
            Search     => "OTRSNoneExsitingString$RandomNumber-UnitTest",
            SearchType => 'Metadata',
        },
        ExpectedResultsInclude => [],
        Success                => 1,
    },
    {
        Name   => 'Search Filename WrongSearch',
        Config => {
            Search     => "OTRSNoneExsitingString$RandomNumber-UnitTest",
            SearchType => 'Filename',
        },
        ExpectedResultsInclude => [],
        Success                => 1,
    },
    {
        Name   => 'Search XMLContent ValueType=',
        Config => {
            Search     => "ValueType=",
            SearchType => 'XMLContent',
        },
        ExpectedResultsInclude => [qw(Daemon::Log::STDERR AdminEmail Ticket::Hook)],
        Success                => 1,
    },
    {
        Name   => 'Search Metadata ValueType=',
        Config => {
            Search     => "ValueType=",
            SearchType => 'Metadata',
        },
        ExpectedResultsInclude => [],
        Success                => 1,
    },
    {
        Name   => 'Search Filename ValueType=',
        Config => {
            CategoryFiles => ["ValueType="],
        },
        ExpectedResultsInclude => [],
        Success                => 1,
    },
    {
        Name   => 'Search XMLContent Ticket',
        Config => {
            Search     => "Ticket",
            SearchType => 'XMLContent',
        },
        ExpectedResultsInclude    => [qw(Ticket::Hook Ticket::NumberGenerator)],
        ExpectedResultsNotInclude => [qw(Daemon::Log::STDERR AdminEmail)],
        Success                   => 1,
    },
    {
        Name   => 'Search Metadata Ticket',
        Config => {
            Search     => "Ticket",
            SearchType => 'Metadata',
        },
        ExpectedResultsInclude    => [qw(Ticket::Hook Ticket::NumberGenerator)],
        ExpectedResultsNotInclude => [qw(Daemon::Log::STDERR AdminEmail)],
        Success                   => 1,
    },
    {
        Name   => 'Search Filename Ticket',
        Config => {
            CategoryFiles => ["Ticket.xml"],
        },
        ExpectedResultsInclude    => [qw(Ticket::Hook Ticket::NumberGenerator)],
        ExpectedResultsNotInclude => [qw(Daemon::Log::STDERR AdminEmail)],
        Success                   => 1,
    },
    {
        Name   => 'Search XMLContent Ticket:',
        Config => {
            Search     => "Ticket:",
            SearchType => 'XMLContent',
        },
        ExpectedResultsInclude    => [qw(Ticket::Hook Ticket::NumberGenerator)],
        ExpectedResultsNotInclude => [qw(Daemon::Log::STDERR AdminEmail)],
        Success                   => 1,
    },
    {
        Name   => 'Search Metadata Ticket:',
        Config => {
            Search     => "Ticket:",
            SearchType => 'Metadata',
        },
        ExpectedResultsInclude    => [qw(Ticket::Hook Ticket::NumberGenerator)],
        ExpectedResultsNotInclude => [qw(Daemon::Log::STDERR AdminEmail)],
        Success                   => 1,
    },
    {
        Name   => 'Search Filename Ticket:',
        Config => {
            CategoryFiles => ["Ticket:.xml"],
        },
        ExpectedResultsInclude => [],
        Success                => 1,
    },
    {
        Name   => 'Search XMLContent Ticket.xml',
        Config => {
            Search     => "Ticket.xml",
            SearchType => 'XMLContent',
        },
        ExpectedResultsInclude => [],
        Success                => 1,
    },
    {
        Name   => 'Search Metadata Ticket.xml',
        Config => {
            Search     => "Ticket.xml",
            SearchType => 'Metadata',
        },
        ExpectedResultsInclude => [],
        Success                => 1,
    },
    {
        Name   => 'Search Filename Ticket.xml',
        Config => {
            CategoryFiles => ["Ticket.xml"],
        },
        ExpectedResultsInclude    => [qw(Ticket::Hook Ticket::NumberGenerator)],
        ExpectedResultsNotInclude => [qw(Daemon::Log::STDERR AdminEmail)],
        Success                   => 1,
    },
    {
        Name   => 'Search XMLContent Ticket::Hook',
        Config => {
            Search     => "Ticket::Hook",
            SearchType => 'XMLContent',
        },
        ExpectedResultsInclude    => [qw(Ticket::Hook)],
        ExpectedResultsNotInclude => [qw(Ticket::NumberGenerator Daemon::Log::STDERR AdminEmail)],
        Success                   => 1,
    },
    {
        Name   => 'Search Metadata Ticket::Hook',
        Config => {
            Search     => "Ticket::Hook",
            SearchType => 'Metadata',
        },
        ExpectedResultsInclude    => [qw(Ticket::Hook)],
        ExpectedResultsNotInclude => [qw(Ticket::NumberGeneratorDaemon::Log::STDERR AdminEmail)],
        Success                   => 1,
    },
    {
        Name   => 'Search Filename Ticket::Hook',
        Config => {
            CategoryFiles => ["Ticket::Hook"],
        },
        ExpectedResultsInclude => [],
        Success                => 1,
    },
    {
        Name   => 'Search XMLContent Ticket:',
        Config => {
            Search     => [qw(Ticket::Hook Ticket::NumberGenerator)],
            SearchType => 'XMLContent',
        },
        ExpectedResultsInclude => [],
        Success                => 1,
    },
    {
        Name   => 'Search Metadata Ticket:',
        Config => {
            Search     => [qw(Ticket::Hook Ticket::NumberGenerator)],
            SearchType => 'Metadata',
        },
        ExpectedResultsInclude => [],
        Success                => 1,
    },
    {
        Name   => 'Search Filename Ticket:',
        Config => {
            CategoryFiles => [qw(Ticket::Hook Ticket::NumberGenerator)],
        },
        ExpectedResultsInclude => [],
        Success                => 1,
    },
    {
        Name   => 'Search XMLContent Ticket.xml Framework.xml',
        Config => {
            Search     => [qw(TTicket.xml Framework.xml)],
            SearchType => 'XMLContent',
        },
        ExpectedResultsInclude => [],
        Success                => 1,
    },
    {
        Name   => 'Search Metadata Ticket.xml Framework.xml',
        Config => {
            Search     => [qw(Ticket.xml Framework.xml)],
            SearchType => 'Metadata',
        },
        ExpectedResultsInclude => [],
        Success                => 1,
    },
    {
        Name   => 'Search Filename Ticket.xml Framework.xml',
        Config => {
            CategoryFiles => [qw(Ticket.xml Framework.xml)],
        },
        ExpectedResultsInclude    => [qw(AdminEmail Ticket::Hook Ticket::NumberGenerator)],
        ExpectedResultsNotInclude => [qw(Daemon::Log::STDERR )],
        Success                   => 1,
    },
    {
        Name   => 'Search XMLContent Ticket::Hook Valid 1',
        Config => {
            Search     => "Ticket::Hook",
            SearchType => 'XMLContent',
            Valid      => 1,
        },
        ExpectedResultsInclude    => [qw(Ticket::Hook)],
        ExpectedResultsNotInclude => [qw(Ticket::NumberGenerator Daemon::Log::STDERR AdminEmail )],
        Success                   => 1,
    },
    {
        Name   => 'Search XMLContent Ticket::Hook Valid 0',
        Config => {
            Search     => "Ticket::Hook",
            SearchType => 'XMLContent',
            Valid      => 0,
        },
        ExpectedResultsInclude    => [qw(Ticket::Hook)],
        ExpectedResultsNotInclude => [qw(Ticket::NumberGenerator Daemon::Log::STDERR AdminEmail)],
        Success                   => 1,
    },
    {
        Name   => 'Search XMLContent Ticket::WatcherGroup Valid 1',
        Config => {
            Search     => "Ticket::WatcherGroup",
            SearchType => 'XMLContent',
            Valid      => 1,
        },
        ExpectedResultsInclude => [qw()],
        ExpectedResultsNotInclude =>
            [qw(Ticket::WatcherGroup Ticket::NumberGenerator Daemon::Log::STDERR AdminEmail )],
        Success => 1,
    },
    {
        Name   => 'Search XMLContent Ticket::WatcherGroup Valid 0',
        Config => {
            Search     => "Ticket::WatcherGroup",
            SearchType => 'XMLContent',
            Valid      => 0,
        },
        ExpectedResultsInclude    => [qw(Ticket::WatcherGroup)],
        ExpectedResultsNotInclude => [qw(Ticket::NumberGenerator Daemon::Log::STDERR AdminEmail)],
        Success                   => 1,
    },
    {
        Name   => 'Search XMLContent AdminEmail in Ticket.xml ',
        Config => {
            Search        => "AdminEmail",
            SearchType    => 'XMLContent',
            CategoryFiles => [qw(Ticket.xml)],
        },
        ExpectedResultsInclude => [],
        Success                => 1,
    },
    {
        Name   => 'Search XMLContent AdminEmail in Framework.xml ',
        Config => {
            Search        => "AdminEmail",
            SearchType    => 'XMLContent',
            CategoryFiles => [qw(Framework.xml)],
        },
        ExpectedResultsInclude => [qw(AdminEmail)],
        Success                => 1,
    },
    {
        Name   => 'Search XMLContent Ticket::Hook in Ticket.xml ',
        Config => {
            Search        => "Ticket::Hook",
            SearchType    => 'XMLContent',
            CategoryFiles => [qw(Ticket.xml)],
        },
        ExpectedResultsInclude => [qw(Ticket::Hook)],
        Success                => 1,
    },
    {
        Name   => 'Search XMLContent Ticket::Hook in Framework.xml ',
        Config => {
            Search        => "Ticket::Hook",
            SearchType    => 'XMLContent',
            CategoryFiles => [qw(Framework.xml)],
        },
        ExpectedResultsInclude => [],
        Success                => 1,
    },

);

my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

TEST:
for my $Test (@Tests) {

    my @Result = $SysConfigDBObject->DefaultSettingSearch( %{ $Test->{Config} } );

    if ( !$Test->{Success} ) {
        $Self->IsDeeply(
            \@Result,
            [],
            "$Test->{Name} DefaultSettingSearch() - not succeed",
        );
        next TEST;
    }

    if ( scalar @{ $Test->{ExpectedResultsInclude} } == 0 ) {
        $Self->IsDeeply(
            \@Result,
            $Test->{ExpectedResultsInclude},
            "$Test->{Name} DefaultSettingSearch() - empty return",
        );

        next TEST;
    }

    my %ResultLookup = map { $_ => 1 } @Result;

    for my $ExpectedResult ( @{ $Test->{ExpectedResultsInclude} } ) {
        $Self->True(
            $ResultLookup{$ExpectedResult},
            "$Test->{Name} DefaultSettingSearch() - $ExpectedResult found with true",
        );
    }
    for my $NotExpectedResult ( @{ $Test->{NotExpectedResultsInclude} } ) {
        $Self->False(
            $ResultLookup{$NotExpectedResult},
            "$Test->{Name} DefaultSettingSearch() - $NotExpectedResult found with false",
        );
    }
}

1;
