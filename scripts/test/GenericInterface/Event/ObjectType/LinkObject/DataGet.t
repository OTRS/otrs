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

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my %LinkObjectTemplate = (
    SourceObject => 'Ticket',
    SourceKey    => 123,
    TargetObject => 'Ticket',
    TargetKey    => 456,
    Type         => 'ParentChild',
    State        => 'Valid',
);

my %ExpectedDataRaw = %LinkObjectTemplate;

my @Tests = (
    {
        Name    => 'No Params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'Missing SourceObject',
        Config => {
            Data => {
                %LinkObjectTemplate,
                SourceObject => undef,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Missing SourceKey',
        Config => {
            Data => {
                %LinkObjectTemplate,
                SourceKey => undef,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Missing TargetObject',
        Config => {
            Data => {
                %LinkObjectTemplate,
                TargetObject => undef,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Missing TargetKey',
        Config => {
            Data => {
                %LinkObjectTemplate,
                TargetKey => undef,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Missing Type',
        Config => {
            Data => {
                %LinkObjectTemplate,
                Type => undef,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Missing State',
        Config => {
            Data => {
                %LinkObjectTemplate,
                State => undef,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Success',
        Config => {
            Data => {
                %LinkObjectTemplate,
            },
        },
        Success => 1,
    },
);

my $BackedObject = $Kernel::OM->Get('Kernel::GenericInterface::Event::ObjectType::LinkObject');

TEST:
for my $Test (@Tests) {

    my %ObjectData = $BackedObject->DataGet( %{ $Test->{Config} } );

    my %ExpectedData;
    if ( $Test->{Success} ) {
        %ExpectedData = %ExpectedDataRaw;
    }

    $Self->IsDeeply(
        \%ObjectData,
        \%ExpectedData,
        "$Test->{Name} DataGet()"
    );
}

# Cleanup is done by RestoreDatabase.
1;
