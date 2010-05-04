# --
# CheckItem.t - check item tests
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: CheckItem.t,v 1.8 2010-05-04 01:10:10 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use Kernel::System::CheckItem;

# disable dns lookups
$Self->{ConfigObject}->Set( Key => 'CheckMXRecord',       Value => 0 );
$Self->{ConfigObject}->Set( Key => 'CheckEmailAddresses', Value => 1 );

# create new object
$Self->{CheckItemObject} = Kernel::System::CheckItem->new( %{$Self} );

# email address checks
my @Tests = (

    # Invalid
    {
        Email => 'somebody',
        Valid => 0,
    },
    {
        Email => 'somebod y@somehost.com',
        Valid => 0,
    },
    {
        Email => 'ä@somehost.com',
        Valid => 0,
    },
    {
        Email => '.somebody@somehost.com',
        Valid => 0,
    },
    {
        Email => 'somebody.@somehost.com',
        Valid => 0,
    },
    {
        Email => 'some..body@somehost.com',
        Valid => 0,
    },
    {
        Email => 'some@body@somehost.com',
        Valid => 0,
    },

    # Valid
    {
        Email => 'somebody@somehost.com',
        Valid => 1,
    },
    {
        Email => 'some.body@somehost.com',
        Valid => 1,
    },
    {
        Email => 'some+body@somehost.com',
        Valid => 1,
    },
    {
        Email => 'some-body@somehost.com',
        Valid => 1,
    },
    {
        Email => 'some_b_o_d_y@somehost.com',
        Valid => 1,
    },
    {
        Email => 'Some.Bo_dY.test.TesT@somehost.com',
        Valid => 1,
    },
    {
        Email => '_some.name@somehost.com',
        Valid => 1,
    },
);

for my $Test (@Tests) {

    # check address
    my $Valid = $Self->{CheckItemObject}->CheckEmail(
        Address => $Test->{Email},
    );

    # execute unit test
    if ( $Test->{Valid} ) {
        $Self->True(
            $Valid,
            "CheckEmail() - $Test->{Email}",
        );
    }
    else {
        $Self->False(
            $Valid,
            "CheckEmail() - $Test->{Email}",
        );
    }
}

# string clean tests
@Tests = (
    {
        String => ' ',
        Params => {},
        Result => '',
    },
    {
        String => undef,
        Params => {},
        Result => undef,
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {},
        Result => "Test\n\r\t test\n\r\t Test",
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft  => 1,
            TrimRight => 0,
        },
        Result => "Test\n\r\t test\n\r\t Test\n\r\t ",
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft  => 0,
            TrimRight => 1,
        },
        Result => "\n\r\t Test\n\r\t test\n\r\t Test",
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft  => 0,
            TrimRight => 0,
        },
        Result => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft          => 1,
            TrimRight         => 1,
            RemoveAllNewlines => 1,
            RemoveAllTabs     => 0,
            RemoveAllSpaces   => 0,
        },
        Result => "Test\t test\t Test",
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft          => 1,
            TrimRight         => 1,
            RemoveAllNewlines => 0,
            RemoveAllTabs     => 1,
            RemoveAllSpaces   => 0,
        },
        Result => "Test\n\r test\n\r Test",
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft          => 1,
            TrimRight         => 1,
            RemoveAllNewlines => 0,
            RemoveAllTabs     => 0,
            RemoveAllSpaces   => 1,
        },
        Result => "Test\n\r\ttest\n\r\tTest",
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft          => 0,
            TrimRight         => 0,
            RemoveAllNewlines => 0,
            RemoveAllTabs     => 0,
            RemoveAllSpaces   => 0,
        },
        Result => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft          => 0,
            TrimRight         => 0,
            RemoveAllNewlines => 1,
            RemoveAllTabs     => 0,
            RemoveAllSpaces   => 0,
        },
        Result => "\t Test\t test\t Test\t ",
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft          => 0,
            TrimRight         => 0,
            RemoveAllNewlines => 0,
            RemoveAllTabs     => 1,
            RemoveAllSpaces   => 0,
        },
        Result => "\n\r Test\n\r test\n\r Test\n\r ",
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft          => 0,
            TrimRight         => 0,
            RemoveAllNewlines => 0,
            RemoveAllTabs     => 0,
            RemoveAllSpaces   => 1,
        },
        Result => "\n\r\tTest\n\r\ttest\n\r\tTest\n\r\t",
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft          => 0,
            TrimRight         => 0,
            RemoveAllNewlines => 1,
            RemoveAllTabs     => 1,
            RemoveAllSpaces   => 1,
        },
        Result => "TesttestTest",
    },
);

for my $Test (@Tests) {

    # copy string to leave the original untouched
    my $String = $Test->{String};

    # start sting preparation
    my $StringRef = $Self->{CheckItemObject}->StringClean(
        StringRef => \$String,
        %{ $Test->{Params} },
    );

    # check result
    $Self->Is(
        ${$StringRef},
        $Test->{Result},
        'TrimTest',
    );
}

# credit card tests
@Tests = (
    {
        String => '4111 1111 1111 1111',
        Found  => 1,
        Result => '4111 XXXX XXXX 1111',
    },
    {
        String => '4111+1111+1111+1111',
        Found  => 1,
        Result => '4111+XXXX+XXXX+1111',
    },
    {
        String => '-4111+1111+1111+1111-',
        Found  => 1,
        Result => '-4111+XXXX+XXXX+1111-',
    },
    {
        String => '-4111+1111+1111+11-',
        Found  => 0,
        Result => '-4111+1111+1111+11-',
    },
    {
        String => '6011.0000/0000.0004',
        Found  => 1,
        Result => '6011.XXXX/XXXX.0004',
    },
    {
        String => '3400/0000/0000/009',
        Found  => 1,
        Result => '3400/XXXX/XXXX/009',
    },
    {
        String => '#5500.00000000.0004',
        Found  => 1,
        Result => '#5500.XXXXXXXX.0004',
    },
    {
        String => '#5500.00000000.0004.',
        Found  => 1,
        Result => '#5500.XXXXXXXX.0004.',
    },
    {
        String => "#5500.00000000.0004\n",
        Found  => 1,
        Result => "#5500.XXXXXXXX.0004\n",
    },
    {
        String => ":5500.00000000.0004\n",
        Found  => 1,
        Result => ":5500.XXXXXXXX.0004\n",
    },
    {
        String => "(5500.00000000.0004)\n",
        Found  => 1,
        Result => "(5500.XXXXXXXX.0004)\n",
    },
    {
        String => '#5500.00000000.00045.',
        Found  => 0,
        Result => '#5500.00000000.00045.',
    },
    {
        String => 'A5500.00000000.00045.',
        Found  => 0,
        Result => 'A5500.00000000.00045.',
    },
);
for my $Test (@Tests) {

    # copy string to leave the original untouched
    my $String = $Test->{String};

    # start sting preparation
    my ( $StringRef, $Found ) = $Self->{CheckItemObject}->CreditCardClean(
        StringRef => \$String,
    );

    # check result
    $Self->Is(
        $Found,
        $Test->{Found},
        'CreditCardClean - Found',
    );
    $Self->Is(
        ${$StringRef},
        $Test->{Result},
        'CreditCardClean - String',
    );
}

1;
