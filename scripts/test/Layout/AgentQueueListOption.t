# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get layout object
my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

my @Tests = (
    {
        Name   => 'Simple test',
        Params => {
            Name => 'test',
            Data => {
                1 => 'Testqueue',
            },
        },
        Result => '<select name="test" id="test" class="" data-tree="true"   >
<option value="1">Testqueue</option>
</select>
',
    },
    {
        Name   => 'Special characters',
        Params => {
            Name => 'test',
            Data => {
                '1||"><script>alert(\'hey there\');</script>' => '"><script>alert(\'hey there\');</script>',
            },
        },
        Result => q{<select name="test" id="test" class="" data-tree="true"   >
<option value="1||&quot;&gt;&lt;script&gt;alert('hey there');&lt;/script&gt;">&quot;&gt;&lt;script&gt;alert('hey there');&lt;/script&gt;</option>
</select>
},
    },

);

for my $Test (@Tests) {
    my $Result = $LayoutObject->AgentQueueListOption( %{ $Test->{Params} } );
    $Self->Is(
        $Result,
        $Test->{Result},
        $Test->{Name}
    );
}

1;
