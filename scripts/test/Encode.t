# --
# Encode.t - Encode tests
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: Encode.t,v 1.3 2009-08-18 12:52:55 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

# EncodeInternalUsed & EncodeFrontendUsed tests
my @Tests = (
    {
        Name    => 'EncodeInternalUsed() && EncodeFrontendUsed()',
        Charset => 'UTF-8',
        Result  => 'utf-8',
    },
    {
        Name    => 'EncodeInternalUsed() && EncodeFrontendUsed()',
        Charset => 'UTF8',
        Result  => 'utf-8',
    },
    {
        Name    => 'EncodeInternalUsed() && EncodeFrontendUsed()',
        Charset => 'utF8',
        Result  => 'utf-8',
    },
);
for my $Test (@Tests) {
    $Self->{ConfigObject}->Set(
        Key   => 'DefaultCharset',
        Value => $Test->{Charset},
    );
    my $Charset = $Self->{EncodeObject}->EncodeInternalUsed();
    $Self->Is(
        $Charset,
        $Test->{Result},
        $Test->{Name} . " ($Test->{Charset})",
    );
    $Charset = $Self->{EncodeObject}->EncodeFrontendUsed();
    $Self->Is(
        $Charset,
        $Test->{Result},
        $Test->{Name} . " ($Test->{Charset})",
    );
}

# Convert tests
{
    use utf8;
    my @Tests = (
        {
            Name          => 'Convert()',
            Input         => 'abc123',
            Result        => 'abc123',
            InputCharset  => 'ascii',
            ResultCharset => 'utf8',
            UTF8          => 1,
        },
        {
            Name          => 'Convert()',
            Input         => 'abc123הצü',
            Result        => 'abc123הצü',
            InputCharset  => 'utf8',
            ResultCharset => 'utf8',
            UTF8          => 1,
        },
        {
            Name          => 'Convert()',
            Input         => 'abc123הצü',
            Result        => 'abc123הצü',
            InputCharset  => 'iso-8859-15',
            ResultCharset => 'utf8',
            UTF8          => 1,
        },
        {
            Name          => 'Convert()',
            Input         => 'abc123הצü',
            Result        => 'abc123הצü',
            InputCharset  => 'utf8',
            ResultCharset => 'utf-8',
            UTF8          => 1,
        },
        {
            Name          => 'Convert()',
            Input         => 'abc123הצü',
            Result        => 'abc123הצü',
            InputCharset  => 'utf8',
            ResultCharset => 'iso-8859-15',
            UTF8          => 1,
        },
        {
            Name          => 'Convert()',
            Input         => 'abc123הצü',
            Result        => 'abc123???',
            InputCharset  => 'utf8',
            ResultCharset => 'iso-8859-1',
            Force         => 1,
            UTF8          => '',
        },
    );
    for my $Test (@Tests) {
        my $Result = $Self->{EncodeObject}->Convert(
            Text  => $Test->{Input},
            From  => $Test->{InputCharset},
            To    => $Test->{ResultCharset},
            Force => $Test->{Force},
        );
        my $IsUTF8 = Encode::is_utf8($Result);
        $Self->True(
            $IsUTF8 eq $Test->{UTF8},
            $Test->{Name} . " is_utf8",

            #$Test->{Name} . " is_utf8 ($Test->{Input})",
        );
        $Self->True(
            $Result eq $Test->{Result},
            $Test->{Name},

            #$Test->{Name} . " ($Test->{Input})",
        );
    }
}

1;
