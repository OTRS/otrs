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

use Kernel::GenericInterface::Mapping;
use Kernel::GenericInterface::Debugger;

# get needed objects
my $ConfigObject     = $Kernel::OM->Get('Kernel::Config');
my $MainObject       = $Kernel::OM->Get('Kernel::System::Main');
my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $Helper->GetRandomID();

my $WebserviceID = $WebserviceObject->WebserviceAdd(
    Config => {
        Debugger => {
            DebugThreshold => 'debug',
            TestMode       => 1,
        },
        Provider => {
            Transport => {
                Type => '',
            },
        },
    },
    Name    => "$RandomID web service",
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $WebserviceID,
    "WebserviceAdd()",
);

# create a debugger object

my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    DebuggerConfig => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    WebserviceID      => $WebserviceID,
    CommunicationType => 'Provider',
);

# long hash
my $Limit    = 10000;
my $LimitSub = 10;
my %LargeHash;
my %LargeHashNewValue;
for my $Key ( 0 .. $Limit ) {
    $LargeHash{ 'Key_' . $Key }         = 'Value_' . $Key;
    $LargeHashNewValue{ 'Key_' . $Key } = 'new_value';
}

# large content
my %Attachments;

# file checks
for my $File (qw(xls txt doc png pdf)) {
    my $Location = $ConfigObject->Get('Home')
        . "/scripts/test/sample/StdAttachment/StdAttachment-Test1.$File";

    my $ContentRef = $MainObject->FileRead(
        Location => $Location,
        Mode     => 'binmode',
    );
    $Attachments{$File} = ${$ContentRef};
}
my $AttachmentsLimit = 500;    # take note is this number * 5 (types files)
my %LargeHashAttachments;
my %LargeHashAttachmentsResult;
for my $Key ( 0 .. $AttachmentsLimit ) {
    for my $File (qw(xls txt doc png pdf)) {
        $LargeHashAttachments{ 'Attachment_' . $Key . $File }       = $Attachments{$File};
        $LargeHashAttachmentsResult{ 'Attachment_' . $Key . $File } = $Attachments{txt};
    }
}

my @MappingTests = (
    {
        Name          => 'Test without config and data',
        Config        => undef,
        Data          => undef,
        ResultData    => {},
        ConfigSuccess => 1,
        ResultSuccess => 1,
    },
    {
        Name          => 'Test with invalid config and without data',
        Config        => [],
        Data          => undef,
        ResultData    => undef,
        ConfigSuccess => 0,
        ResultSuccess => 0,
    },
    {
        Name          => 'Test with empty data',
        Config        => undef,
        Data          => {},
        ResultData    => {},
        ConfigSuccess => 1,
        ResultSuccess => 1,
    },
    {
        Name          => 'Test with invalid data',
        Config        => undef,
        Data          => [],
        ResultData    => undef,
        ConfigSuccess => 1,
        ResultSuccess => 0,
    },
    {
        Name   => 'Test without data',
        Config => {
            KeyMapDefault => {
                MapType => 'Keep',
            },
            ValueMapDefault => {
                MapType => 'Keep',
            },
        },
        Data          => undef,
        ResultData    => {},
        ConfigSuccess => 1,
        ResultSuccess => 1,
    },
    {
        Name   => 'Test with leftover data',
        Config => {
            KeyMapDefault => {
                MapType => 'Keep',
            },
            ValueMapDefault => {
                MapType => 'Keep',
            },
        },
        Data => {
            ''  => 'one',
            two => 'two',
            ''  => 'three',
        },
        ResultData => {
            two => 'two',
        },
        ConfigSuccess => 1,
        ResultSuccess => 1,
    },
    {
        Name   => 'Test with undef config',
        Config => undef,
        Data   => {
            one   => 'one',
            two   => 'two',
            three => 'three',
        },
        ResultData => {
            one   => 'one',
            two   => 'two',
            three => 'three',
        },
        ConfigSuccess => 1,
        ResultSuccess => 1,
    },
    {
        Name   => 'Test empty config',
        Config => {},
        Data   => {
            one   => 'one',
            two   => 'two',
            three => 'three',
        },
        ResultData => {
            one   => 'one',
            two   => 'two',
            three => 'three',
        },
        ConfigSuccess => 0,
        ResultSuccess => 0,
    },
    {
        Name   => 'Test with wrong config',
        Config => {
            NoValidValue => {
                Invalid => 'value',
            },
        },
        Data => {
            one   => 'one',
            two   => 'two',
            three => 'three',
        },
        ResultData    => undef,
        ConfigSuccess => 0,
        ResultSuccess => 0,
    },
    {
        Name   => 'Test KeyMapExact',
        Config => {
            KeyMapExact => {
                one  => 'new_value',
                two  => 'another_new_value',
                four => 'new_value_gain',
            },
            KeyMapDefault => {
                MapType => 'Ignore',
            },
            ValueMapDefault => {
                MapType => 'Keep',
            },
        },
        Data => {
            one   => 'one',
            two   => 'two',
            three => 'three',
            four  => 'four',
            five  => 'five',
        },
        ResultData => {
            new_value         => 'one',
            another_new_value => 'two',
            new_value_gain    => 'four',
        },
        ConfigSuccess => 1,
        ResultSuccess => 1,
    },
    {
        Name   => 'Test KeyMapRegEx',
        Config => {
            KeyMapRegEx => {
                'Stat(e|us)'  => 'state',
                '[pP]riority' => 'prio',
            },
            KeyMapDefault => {
                MapType => 'Ignore',
            },
            ValueMapDefault => {
                MapType => 'Keep',
            },
        },
        Data => {
            State    => 'A lost state',
            Stadium  => 'Allianz Arena',
            Status   => 'Open',
            Priority => 'with capital letter',
            priority => 'without capital letter',
        },
        ResultData => {
            'state' => 'A lost state',
            prio    => 'with capital letter',
        },
        ConfigSuccess => 1,
        ResultSuccess => 1,
    },
    {
        Name   => 'Test KeyMapDefault (Keep)',
        Config => {
            KeyMapDefault => {
                MapType => 'Keep',
                MapTo   => 'new_value',
            },
            ValueMapDefault => {
                MapType => 'Keep',
            },
        },
        Data => {
            one   => 'one',
            two   => 'two',
            three => 'three',
        },
        ResultData => {
            one   => 'one',
            two   => 'two',
            three => 'three',
        },
        ConfigSuccess => 1,
        ResultSuccess => 1,
    },
    {
        Name   => 'Test KeyMapDefault (Ignore)',
        Config => {
            KeyMapDefault => {
                MapType => 'Ignore',
                MapTo   => 'new_value',
            },
            ValueMapDefault => {
                MapType => 'Keep',
            },
        },
        Data => {
            one   => 'one',
            two   => 'two',
            three => 'three',
        },
        ResultData    => {},
        ConfigSuccess => 1,
        ResultSuccess => 1,
    },
    {
        Name   => 'Test KeyMapDefault (MapTo)',
        Config => {
            KeyMapDefault => {
                MapType => 'MapTo',
                MapTo   => 'new_key',
            },
            ValueMapDefault => {
                MapType => 'Keep',
            },
        },
        Data => {
            one   => 'one',
            two   => 'two',
            three => 'three',
        },
        ResultData => {
            new_key => 'one',
        },
        ConfigSuccess => 1,
        ResultSuccess => 1,
    },
    {
        Name   => 'Test KeyMapExact & KeyMapDefault',
        Config => {
            KeyMapExact => {
                one  => 'new_value',
                two  => 'another_new_value',
                four => 'new_value_gain',
            },
            KeyMapDefault => {
                MapType => 'MapTo',
                MapTo   => 'new_key',
            },
            ValueMapDefault => {
                MapType => 'Keep',
            },
        },
        Data => {
            one   => 'one',
            two   => 'two',
            three => 'three',
            four  => 'four',
            five  => 'five',
        },
        ResultData => {
            new_value         => 'one',
            another_new_value => 'two',
            new_key           => 'three',
            new_value_gain    => 'four',
            new_key           => 'five',
        },
        ConfigSuccess => 1,
        ResultSuccess => 1,
    },
    {
        Name   => 'Test KeyMapRegEx & KeyMapDefault',
        Config => {
            KeyMapRegEx => {
                'Stat(e|us)'  => 'state',
                '[pP]riority' => 'prio',
            },
            KeyMapDefault => {
                MapType => 'Keep',
                MapTo   => 'new_key',
            },
            ValueMapDefault => {
                MapType => 'Keep',
            },
        },
        Data => {
            State        => 'A lost state',
            Stadium      => 'Allianz Arena',
            Status       => 'Open',
            Priority     => 'with capital letter',
            priority     => 'without capital letter',
            one_more_key => 'some value',
            other_key    => 'an empty string',
        },
        ResultData => {
            'state'      => 'A lost state',
            'Stadium'    => 'Allianz Arena',
            prio         => 'with capital letter',
            one_more_key => 'some value',
            other_key    => 'an empty string',
        },
        ConfigSuccess => 1,
        ResultSuccess => 1,
    },
    {
        Name   => 'Test KeyMapDefault ValueMapDefault large hash',
        Config => {
            KeyMapDefault => {
                MapType => 'Keep',
            },
            ValueMapDefault => {
                MapType => 'MapTo',
                MapTo   => 'new_value',
            },
        },
        Data          => \%LargeHash,
        ResultData    => \%LargeHashNewValue,
        ConfigSuccess => 1,
        ResultSuccess => 1,
        CheckTime     => 1,
    },
    {
        Name   => 'Test KeyMapDefault & ValueMapDefault large attachments hash',
        Config => {
            KeyMapDefault => {
                MapType => 'Keep',
            },
            ValueMapDefault => {
                MapType => 'MapTo',
                MapTo   => $Attachments{txt},
            },
        },
        Data          => \%LargeHashAttachments,
        ResultData    => \%LargeHashAttachmentsResult,
        ConfigSuccess => 1,
        ResultSuccess => 1,
        CheckTime     => 1,
    },
    {
        Name   => 'Test ValueMap no ValueMapDefault',
        Config => {
            KeyMapDefault => {
                MapType => 'Keep',
            },
            ValueMap => {
                first => {
                    ValueMapExact => {
                        1 => 'one',
                        2 => 'two',
                        3 => 'three',
                    },
                },
                second => {
                    ValueMapRegEx => {
                        '[rR]eg[eE]x' => 'regular expression',
                    },
                },
            },
        },
        Data          => {},
        ResultData    => {},
        ConfigSuccess => 0,
        ResultSuccess => 0,
    },
    {
        Name   => 'Test ValueMap empty ValueMapDefault',
        Config => {
            KeyMapDefault => {
                MapType => 'Keep',
            },
            ValueMap => {
                first => {
                    ValueMapExact => {
                        1 => 'one',
                        2 => 'two',
                        3 => 'three',
                    },
                },
                second => {
                    ValueMapRegEx => {
                        '[rR]eg[eE]x' => 'regular expression',
                    },
                },
            },
            ValueMapDefault => {
            },
        },
        Data => {
        },
        ResultData    => {},
        ConfigSuccess => 0,
        ResultSuccess => 0,
    },
    {
        Name   => 'Test ValueMap invalid ValueMapDefault',
        Config => {
            KeyMapDefault => {
                MapType => 'Keep',
            },
            ValueMap => {
                first => {
                    ValueMapExact => {
                        1 => 'one',
                        2 => 'two',
                        3 => 'three',
                    },
                },
                second => {
                    ValueMapRegEx => {
                        '[rR]eg[eE]x' => 'regular expression',
                    },
                },
            },
            ValueMapDefault => {
                MapType => 'ThisIsNotAValidMapType',
            },
        },
        Data => {
            Key => 'Value',
        },
        ResultData    => undef,
        ConfigSuccess => 0,
        ResultSuccess => 0,
    },
    {
        Name   => 'Test ValueMap no MapTo for MapType MapTo',
        Config => {
            KeyMapDefault => {
                MapType => 'Keep',
            },
            ValueMap => {
                first => {
                    ValueMapExact => {
                        1 => 'one',
                        2 => 'two',
                        3 => 'three',
                    },
                },
                second => {
                    ValueMapRegEx => {
                        '[rR]eg[eE]x' => 'regular expression',
                    },
                },
            },
            ValueMapDefault => {
                MapType => 'MapTo',
            },
        },
        Data => {
            Key => 'Value',
        },
        ResultData    => undef,
        ConfigSuccess => 0,
        ResultSuccess => 0,
    },
    {
        Name   => 'Test ValueMap invalid MapTo for MapType MapTo',
        Config => {
            KeyMapDefault => {
                MapType => 'Keep',
            },
            ValueMap => {
                first => {
                    ValueMapExact => {
                        1 => 'one',
                        2 => 'two',
                        3 => 'three',
                    },
                },
                second => {
                    ValueMapRegEx => {
                        '[rR]eg[eE]x' => 'regular expression',
                    },
                },
            },
            ValueMapDefault => {
                MapType => 'MapTo',
                MapTo   => {},
            },
        },
        Data => {
            Key => 'Value',
        },
        ResultData    => undef,
        ConfigSuccess => 0,
        ResultSuccess => 0,
    },
    {
        Name   => 'Test ValueMap invalid ValueMapExact',
        Config => {
            KeyMapDefault => {
                MapType => 'Keep',
            },
            ValueMap => {
                first => {
                    ValueMapExact => 'ThisShouldNotBeAString',
                },
                second => {
                    ValueMapRegEx => {
                        '[rR]eg[eE]x' => 'regular expression',
                    },
                },
            },
            ValueMapDefault => {
                MapType => 'Keep',
            },
        },
        Data => {
            Key => 'Value',
        },
        ResultData    => undef,
        ConfigSuccess => 0,
        ResultSuccess => 0,
    },
    {
        Name   => 'Test ValueMap invalid ValueMapRegEx',
        Config => {
            KeyMapDefault => {
                MapType => 'Keep',
            },
            ValueMap => {
                first => {
                    ValueMapExact => {
                        1 => 'one',
                        2 => 'two',
                        3 => 'three',
                    },
                },
                second => {
                    ValueMapRegEx => {
                        '[rR]eg[eE]x' => {},
                    },
                },
            },
            ValueMapDefault => {
                MapType => 'Keep',
            },
        },
        Data => {
            Key => 'Value',
        },
        ResultData    => undef,
        ConfigSuccess => 0,
        ResultSuccess => 0,
    },
    {
        Name   => 'Test ValueMap all correct',
        Config => {
            KeyMapDefault => {
                MapType => 'Keep',
            },
            ValueMap => {
                first => {
                    ValueMapExact => {
                        1 => 'one',
                        2 => 'two',
                        3 => 'three',
                    },
                },
                second => {
                    ValueMapRegEx => {
                        '[rR]eg[eE]x' => 'regular expression',
                    },
                },
            },
            ValueMapDefault => {
                MapType => 'Keep',
            },
        },
        Data => {
            first  => 2,
            second => 'regex',
        },
        ResultData => {
            first  => 'two',
            second => 'regular expression',
        },
        ConfigSuccess => 1,
        ResultSuccess => 1,
    },
);

TEST:
for my $Test (@MappingTests) {

    my $StartSeconds;
    $StartSeconds = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch()
        if ( $Test->{CheckTime} );

    # instantiate mapping object to catch config errors
    my $MappingObject = Kernel::GenericInterface::Mapping->new(
        DebuggerObject => $DebuggerObject,
        MappingConfig  => {
            Type   => 'Simple',
            Config => $Test->{Config},
        },
    );
    if ( $Test->{ConfigSuccess} ) {
        $Self->Is(
            ref $MappingObject,
            'Kernel::GenericInterface::Mapping',
            $Test->{Name} . ' MappingObject was correctly instantiated',
        );
        next TEST if ref $MappingObject ne 'Kernel::GenericInterface::Mapping';
    }
    else {
        $Self->IsNot(
            ref $MappingObject,
            'Kernel::GenericInterface::Mapping',
            $Test->{Name} . ' MappingObject was not correctly instantiated',
        );
        next TEST;
    }
    my $MappingResult = $MappingObject->Map(
        Data => $Test->{Data},
    );
    if ( $Test->{CheckTime} ) {
        my $EndSeconds = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();
        $Self->True(
            ( $EndSeconds - $StartSeconds ) < 5,
            $Test->{Name}
                . ' Mapping - Performance on large data set: '
                . ( $EndSeconds - $StartSeconds )
                . ' second(s)',
        );
    }

    # check if function return correct status
    $Self->Is(
        $MappingResult->{Success},
        $Test->{ResultSuccess},
        $Test->{Name} . ' (Success).',
    );

    # check if function return correct data
    $Self->IsDeeply(
        $MappingResult->{Data},
        $Test->{ResultData},
        $Test->{Name} . ' (Data Structure).',
    );

    $Self->Is(
        $MappingResult->{Success},
        $Test->{ResultSuccess},
        $Test->{Name} . ' success status',
    );

    if ( !$Test->{ResultSuccess} ) {
        $Self->True(
            $MappingResult->{ErrorMessage},
            $Test->{Name} . ' error message found',
        );
    }

    # instantiate another object
    my $SecondMappingObject = Kernel::GenericInterface::Mapping->new(
        DebuggerObject => $DebuggerObject,
        MappingConfig  => {
            Type   => 'Simple',
            Config => $Test->{Config},
        },
    );

    $Self->Is(
        ref $SecondMappingObject,
        'Kernel::GenericInterface::Mapping',
        $Test->{Name} . ' SecondMappingObject was correctly instantiated',
    );
}    # end tests

# cleanup is done by RestoreDatabase.

1;
