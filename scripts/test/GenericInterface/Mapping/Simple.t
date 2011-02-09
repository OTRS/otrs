# --
# Simple.t - Mapping tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Simple.t,v 1.2 2011-02-09 13:34:14 cg Exp $
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
        DebugLevel => 'debug',
    },
    WebserviceID => 1,
    TestMode     => 1,
);

# create a mapping instance
my $MappingObject = Kernel::GenericInterface::Mapping->new(
    %{$Self},
    DebuggerObject => $DebuggerObject,
    MappingConfig  => {
        Type   => 'Simple',
        Config => {},
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
    my $Content = '';
    open( IN,
        "< "
            . $Self->{ConfigObject}->Get('Home')
            . "/scripts/test/sample/StdAttachment/StdAttachment-Test1.$File"
        )
        || die $!;
    binmode(IN);
    while (<IN>) {
        $Content .= $_;
    }
    $Attachments{$File} = $Content;
    close(IN);
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
        Name   => 'Test whitout config',
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
        ResultSuccess => 1,
    },
    {
        Name   => 'Test KeyMapExact',
        Config => {
            TestOption  => 'KeyMapExact',
            KeyMapExact => {
                one  => 'new_value',
                two  => 'another_new_value',
                four => 'new_value_gain',
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
        },
        Data => {
            State    => 'A lost state',
            Stadium  => 'Allianz Arena',
            Status   => 'Open',
            Priority => 'with capital letter',
            priority => 'without capital letter',
        },
        ResultData => {
            'state' => 'Open',
            prio    => 'without capital letter',
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
            TestOption  => 'KeyMapExact',
            KeyMapExact => {
                one  => 'new_value',
                two  => 'another_new_value',
                four => 'new_value_gain',
            },
            KeyMapDefault => {
                MapType => 'MapTo',
                MapTo   => 'new_key',
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
            'state'      => 'Open',
            'Stadium'    => 'Allianz Arena',
            prio         => 'without capital letter',
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
);

for my $Test (@MappingTests) {

    my $StartSeconds = $Self->{TimeObject}->SystemTime() if ( $Test->{CheckTime} );

    $MappingObject->{MappingConfig}->{Config} = $Test->{Config};
    my $MappingResult = $MappingObject->Map(
        %{$Self},
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

    if ( !$Test->{ResultSuccess} ) {
        $Self->True(
            $MappingResult->{ErrorMessage},
            $Test->{Name} . ' (Error Message: ' .
                $MappingResult->{ErrorMessage} . ')' .
                ' for ' . $Limit . 'hash entries',
        );
    }
    else {
        $Self->False(
            $MappingObject->{ErrorMessage},
            $Test->{Name} . ' (Not Error Message).',
        );
    }
}

1;
