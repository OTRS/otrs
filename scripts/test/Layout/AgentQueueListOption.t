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

my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my @Tests = (
    {
        Name   => 'Simple test',
        Params => {
            Name => 'test',
            Data => {
                1 => 'Testqueue',
            },
        },
        ResultTree => '<select name="test" id="test" class="" data-tree="true"   >
<option value="1">Testqueue</option>
</select>
',
        ResultList => '<select id="test" name="test">
  <option value="1">Testqueue</option>
</select>',
    },
    {
        Name   => 'Posible empty selection',
        Params => {
            Name => 'test',
            Data => {
                1     => 'Testqueue',
                '||-' => '-',
            },
        },
        ResultTree => '<select name="test" id="test" class="" data-tree="true"   >
<option value="||-">-</option>
<option value="1">Testqueue</option>
</select>
',
        ResultList => '<select id="test" name="test">
  <option value="||-">-</option>
  <option value="1">Testqueue</option>
</select>',
    },
    {
        Name   => 'Special empty selection: - Move -',
        Params => {
            Name => 'test',
            Data => {
                1     => 'Testqueue',
                '||-' => '- Move -',
            },
        },
        ResultTree => '<select name="test" id="test" class="" data-tree="true"   >
<option value="||-">- Move -</option>
<option value="1">Testqueue</option>
</select>
',
        ResultList => '<select id="test" name="test">
  <option value="||-">- Move -</option>
  <option value="1">Testqueue</option>
</select>',
    },
    {
        Name   => 'Special characters',
        Params => {
            Name => 'test',
            Data => {
                '1||"><script>alert(\'hey there\');</script>' => '"><script>alert(\'hey there\');</script>',
            },
        },
        ResultTree => q{<select name="test" id="test" class="" data-tree="true"   >
<option value="1||&quot;&gt;&lt;script&gt;alert('hey there');&lt;/script&gt;">&quot;&gt;&lt;script&gt;alert('hey there');&lt;/script&gt;</option>
</select>
},
        ResultList => q{<select id="test" name="test">
  <option value="1||"><script>alert('hey there');</script>">"><script>alert('hey there');</script></option>
</select>},
    },

);

for my $ListType (qw(tree list)) {

    $ConfigObject->Set(
        Key   => 'Ticket::Frontend::ListType',
        Value => $ListType,
    );

    my $ResultType = ( $ListType eq 'tree' ) ? 'ResultTree' : 'ResultList';

    # Test creating queue list option for tree/list ListType.
    for my $Test (@Tests) {
        my $Result = $LayoutObject->AgentQueueListOption( %{ $Test->{Params} } );

        $Self->Is(
            $Result,
            $Test->{$ResultType},
            $Test->{Name} . ' ' . $ListType . ' ListType',
        );
    }
}

1;
