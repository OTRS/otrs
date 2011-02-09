# --
# Simple.t - Mapping tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Simple.t,v 1.1 2011-02-09 09:07:49 cg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use Kernel::GenericInterface::Mapping;

# create a debbuger object
use Kernel::GenericInterface::Debugger;

$Self->{DebuggerObject} = Kernel::GenericInterface::Debugger->new(
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
    MappingConfig => {
        Type   => 'Simple',
        Config => {},
    },
);
$Self->Is(
    ref $MappingObject,
    'Kernel::GenericInterface::Mapping',
    'MappingObject was correctly instantiated',
);

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
            KeyMapExact => {                # key/value pairs for direct replacement
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
            three             => 'three',
            new_value_gain    => 'four',
            five              => 'five',
        },
        ResultSuccess => 1,
    },
    {
        Name   => 'Test KeyMapRegEx',
        Config => {
            KeyMapRegEx => {    # replace keys with value if current key matches regex
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
            'state'   => 'Open',
            'Stadium' => 'Allianz Arena',
            prio      => 'without capital letter',
        },
        ResultSuccess => 1,
    },
    {
        Name   => 'Test KeyMapDefault (Keep)',
        Config => {
            KeyMapDefault => {    # optional. If not set, keys will remain unchanged
                MapType => 'Keep',         # possible values are
                                           # 'Keep' (leave unchanged)
                                           # 'Ignore' (drop key/value pair)
                                           # 'MapTo' (use provided value as default)
                MapTo   => 'new_value',    # only used if 'MapType' is 'MapTo'
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
            KeyMapDefault => {    # optional. If not set, keys will remain unchanged
                MapType => 'Ignore',       # possible values are
                                           # 'Keep' (leave unchanged)
                                           # 'Ignore' (drop key/value pair)
                                           # 'MapTo' (use provided value as default)
                MapTo   => 'new_value',    # only used if 'MapType' is 'MapTo'
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
            KeyMapDefault => {    # optional. If not set, keys will remain unchanged
                MapType => 'MapTo',      # possible values are
                                         # 'Keep' (leave unchanged)
                                         # 'Ignore' (drop key/value pair)
                                         # 'MapTo' (use provided value as default)
                MapTo   => 'new_key',    # only used if 'MapType' is 'MapTo'
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
            KeyMapExact => {                # key/value pairs for direct replacement
                one  => 'new_value',
                two  => 'another_new_value',
                four => 'new_value_gain',
            },
            KeyMapDefault => {              # optional. If not set, keys will remain unchanged
                MapType => 'MapTo',         # possible values are
                                            # 'Keep' (leave unchanged)
                                            # 'Ignore' (drop key/value pair)
                                            # 'MapTo' (use provided value as default)
                MapTo   => 'new_key',       # only used if 'MapType' is 'MapTo'
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
            KeyMapRegEx => {    # replace keys with value if current key matches regex
                'Stat(e|us)'  => 'state',
                '[pP]riority' => 'prio',
            },
            KeyMapDefault => {    # optional. If not set, keys will remain unchanged
                MapType => 'Keep',       # possible values are
                                         # 'Keep' (leave unchanged)
                                         # 'Ignore' (drop key/value pair)
                                         # 'MapTo' (use provided value as default)
                MapTo   => 'new_key',    # only used if 'MapType' is 'MapTo'
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
);

for my $Test (@MappingTests) {
    $MappingObject->{MappingConfig}->{Config} = $Test->{Config};
    my $MappingResult = $MappingObject->Map(
        %{$Self},
        Data => $Test->{Data},
    );

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
                $MappingResult->{ErrorMessage} . ')',
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
