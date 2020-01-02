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

# get HTMLUtils object
my $HTMLUtilsObject = $Kernel::OM->Get('Kernel::System::HTMLUtils');

# DocumentComplete tests
my @Tests = (
    {
        Input => 'Some Text',
        Result =>
            '<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/></head><body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;">Some Text</body></html>',
        Name => 'DocumentComplete - simple'
    },
    {
        Input  => '<html><body>Some Text</body></html>',
        Result => '<html><body>Some Text</body></html>',
        Name   => 'DocumentComplete - simple'
    },
);

for my $Test (@Tests) {
    my $Ascii = $HTMLUtilsObject->DocumentComplete(
        Charset => 'iso-8859-1',
        String  => $Test->{Input},
    );
    $Self->Is(
        $Ascii,
        $Test->{Result},
        $Test->{Name},
    );
}

1;
