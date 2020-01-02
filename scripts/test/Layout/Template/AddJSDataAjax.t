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

# get layout object
my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

my @Tests = (
    {
        Name   => 'Simple Data',
        Input  => { 'Key1' => 'Value1' },
        Result => '
<script type="text/javascript">//<![CDATA[
"use strict";
Core.Config.AddConfig({"Key1":"Value1"});
//]]></script>',
    },
    {
        Name  => 'More complex Data',
        Input => {
            'Key1' => {
                '1' => '2',
                '3' => '4'
            }
        },
        Result => '
<script type="text/javascript">//<![CDATA[
"use strict";
Core.Config.AddConfig({"Key1":{"1":"2","3":"4"}});
//]]></script>',
    },
);

for my $Test (@Tests) {

    for my $JSData ( sort keys %{ $Test->{Input} } ) {
        $LayoutObject->AddJSData(
            Key   => $JSData,
            Value => $Test->{Input}->{$JSData}
        );
    }

    my $Output = $LayoutObject->Output(
        Template => '',
        Data     => {},
        AJAX     => 1,
    );

    $Self->Is(
        $Output,
        $Test->{Result},
        $Test->{Name},
    );
}

1;
