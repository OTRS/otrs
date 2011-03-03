# --
# Simple.t - Mapping tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Simple.t,v 1.11 2011-03-03 15:03:36 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use Kernel::GenericInterface::Mapping;
use Kernel::GenericInterface::Debugger;

# create a debbuger object

my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    %$Self,
    DebuggerConfig => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    WebserviceID      => 1,
    CommunicationType => 'Provider',
);

# create a mapping instance
my $MappingObject = Kernel::GenericInterface::Mapping->new(
    %{$Self},
    DebuggerObject => $DebuggerObject,
    MappingConfig  => {
        Type => 'Simple',
    },
);
$Self->Is(
    ref $MappingObject,
    'Kernel::GenericInterface::Mapping',
    'MappingObject was correctly instantiated',
);

# long hash
my $Limit    = 100000;
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
    my $Location = $Self->{ConfigObject}->Get('Home')
        . "/scripts/test/sample/StdAttachment/StdAttachment-Test1.$File";

    my $ContentRef = $Self->{MainObject}->FileRead(
        Location => $Location,
        Mode     => 'binmode',
    );
    $Attachments{$File} = ${$ContentRef};
}
my $AttachmentsLimit = 5000;    # take note is this number * 5 (types files)
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
        ResultData    => undef,
        ResultSuccess => 0,
    },
    {
        Name          => 'Test without data',
        Config        => {},
        Data          => undef,
        ResultData    => undef,
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
        ResultData    => undef,
        ResultSuccess => 0,
    },
    {
        Name   => 'Test with wrong data',
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
        ResultSuccess => 1,
    },
    {
        Name   => 'Test without config',
        Config => {},
        Data   => {
            one   => 'one',
            two   => 'two',
            three => 'three',
        },
        ResultData    => undef,
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
        ResultSuccess => 1,
        CheckTime     => 1,
    },
    {
        Name   => 'Test KeyMapDefault & ValueMapDefault large atachments hash',
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
        Data => {
        },
        ResultData    => undef,
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
        ResultData    => undef,
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
        },
        ResultData    => undef,
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
        },
        ResultData    => undef,
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
        },
        ResultData    => undef,
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
        },
        ResultData    => undef,
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
        },
        ResultData    => undef,
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
        ResultSuccess => 1,
    },
);

for my $Test (@MappingTests) {

    my $StartSeconds = $Self->{TimeObject}->SystemTime() if ( $Test->{CheckTime} );

    $MappingObject->{MappingConfig}->{Config} = $Test->{Config};
    my $MappingResult = $MappingObject->Map(
        Data => $Test->{Data},
    );
    my $EndSeconds = $Self->{TimeObject}->SystemTime() if ( $Test->{CheckTime} );
    $Self->True(
        ( $EndSeconds - $StartSeconds ) < 5,
        'Mapping - Performance on large data set: ' .
            ( $EndSeconds - $StartSeconds ) . ' second(s)',
        )
        if ( $Test->{CheckTime} );

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
}

1;
