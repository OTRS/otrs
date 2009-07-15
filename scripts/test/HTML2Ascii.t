# --
# HTML2Ascii.t - HTML2Ascii tests
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: HTML2Ascii.t,v 1.1 2009-07-15 14:45:47 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use Kernel::System::HTML2Ascii;

$Self->{HTML2AsciiObject} = Kernel::System::HTML2Ascii->new( %{$Self} );

my @Tests = (
    {
        Input  => 'Some Text',
        Result => 'Some Text',
        Name   => 'ToAscii - simple'
    },
    {
        Input  => '<b>Some Text</b>',
        Result => 'Some Text',
        Name   => 'ToAscii - simple'
    },
    {
        Input  => '<b>Some Text</b><br/>More Text',
        Result => 'Some Text
More Text',
        Name   => 'ToAscii - simple'
    },
);

for my $Test (@Tests) {
    my $Ascii = $Self->{HTML2AsciiObject}->ToAscii(
        String => $Test->{Input},
    );
    $Self->Is(
        $Ascii,
        $Test->{Result},
        $Test->{Name},
    );
}

1;
