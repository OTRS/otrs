# --
# Crypt.t - Crypt tests
# Copyright (C) 2001-2008 OTRS GmbH, http://otrs.org/
# --
# $Id: Crypt.t,v 1.4.2.1 2008-01-07 13:02:33 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use utf8;
use Kernel::System::Crypt;

# set config
$Self->{ConfigObject}->Set(Key => 'PGP', Value => 1);
$Self->{ConfigObject}->Set(Key => 'PGP::Options', Value => '--batch --no-tty --yes');
$Self->{ConfigObject}->Set(Key => 'PGP::Key::Password', Value => { '04A17B7A' => 'somepass'} );
# check if gpg is located there
if (! -e $Self->{ConfigObject}->Get('PGP::Bin')) {
    # maybe it's a mac with macport
    if (-e '/opt/local/bin/gpg') {
        $Self->{ConfigObject}->Set(Key => 'PGP::Bin', Value => '/opt/local/bin/gpg');
    }
}

# create crypt object
$Self->{CryptObject} = Kernel::System::Crypt->new(
    %{$Self},
    CryptType => 'PGP',
);

if (!$Self->{CryptObject}) {
    print STDERR "NOTICE: No PGP support!\n";
    return;
}

my %Search = (
    1 => 'unittest@example.com',
    2 => 'unittest2@example.com',
);

my %Check = (
    1 => {
        Type => 'pub',
        Identifier => 'UnitTest <unittest@example.com>',
        Bit => '1024D',
        Key => '38677C3B',
        KeyPrivate => '04A17B7A',
        Created => '2007-08-21',
        Expires => '',
        Fingerprint => '4124 DFBD CF52 D129 AB3E  3C44 1404 FBCB 3867 7C3B',
        FingerprintShort => '4124DFBDCF52D129AB3E3C441404FBCB38677C3B',
    },
    2 => {
        Type => 'pub',
        Identifier => 'UnitTest2 <unittest2@example.com>',
        Bit => '1024D',
        Key => 'F0974D10',
        KeyPrivate => '8593EAE2',
        Created => '2007-08-21',
        Expires => '2037-08-13',
        Fingerprint => '36E9 9F7F AD76 6405 CBE1  BB42 F533 1A46 F097 4D10',
        FingerprintShort => '36E99F7FAD766405CBE1BB42F5331A46F0974D10',
    },
);

foreach my $Count (1..2) {
    my @Keys = $Self->{CryptObject}->KeySearch(
        Search => $Search{$Count},
    );
    $Self->False(
        $Keys[0] || '',
        "#$Count KeySearch()",
    );

    # get keys
    my $KeyString = $Self->{MainObject}->FileRead(
        Directory => $Self->{ConfigObject}->Get('Home')."/scripts/test/sample/",
        Filename => "PGPPrivateKey-$Count.asc",
    );
    my $Message = $Self->{CryptObject}->KeyAdd(
        Key => ${$KeyString},
    );
    $Self->True(
        $Message || '',
        "#$Count KeyAdd()",
    );

    @Keys = $Self->{CryptObject}->KeySearch(
        Search => $Search{$Count},
    );

    $Self->True(
        $Keys[0] || '',
        "#$Count KeySearch()",
    );
    foreach my $ID (qw(Type Identifier Bit Key KeyPrivate Created Expires Fingerprint FingerprintShort)) {
        $Self->Is(
            $Keys[0]->{$ID} || '',
            $Check{$Count}->{$ID},
            "#$Count KeySearch() - $ID",
        );
    }

    my $PublicKeyString = $Self->{CryptObject}->PublicKeyGet(
        Key => $Keys[0]->{Key},
    );
    $Self->True(
        $PublicKeyString || '',
        "#$Count PublicKeyGet()",
    );

    my $PrivateKeyString = $Self->{CryptObject}->SecretKeyGet(
        Key => $Keys[0]->{KeyPrivate},
    );
    $Self->True(
        $PrivateKeyString || '',
        "#$Count SecretKeyGet()",
    );

    # crypt
    my $Crypted = $Self->{CryptObject}->Crypt(
        Message => 'hello1234567890öäüß',
        Key => $Keys[0]->{Key},
    );
    $Self->True(
        $Crypted || '',
        "#$Count Crypt()",
    );
    # decrypt
    my %Decrypt = $Self->{CryptObject}->Decrypt(
        Message => $Crypted,
    );
    $Self->True(
        $Decrypt{Successful} || '',
        "#$Count Decrypt() - Successful",
    );
    $Self->Is(
        $Decrypt{Data} || '',
        'hello1234567890öäüß',
        "#$Count Decrypt() - Data",
    );
    # sign inline
    my $Sign = $Self->{CryptObject}->Sign(
        Message => 'hello1234567890äöß',
        Key => $Keys[0]->{KeyPrivate},
        Type => 'Inline'  # Detached|Inline
    );
    $Self->True(
        $Sign || '',
        "#$Count Sign() - inline",
    );
    # verify
    my %Verify = $Self->{CryptObject}->Verify(
        Message => $Sign,
    );
    $Self->True(
        $Verify{Successful} || '',
        "#$Count Verify() - inline",
    );
    # sign detached
    $Sign = $Self->{CryptObject}->Sign(
        Message => 'hello1234567890äöß',
        Key => $Keys[0]->{KeyPrivate},
        Type => 'Detached'  # Detached|Inline
    );
    $Self->True(
        $Sign || '',
        "#$Count Sign() - detached",
    );
    # verify
    %Verify = $Self->{CryptObject}->Verify(
        Message => 'hello1234567890äöß',
        Sign => $Sign,
    );
    $Self->True(
        $Verify{Successful} || '',
        "#$Count Verify() - detached",
    );

    # file checks
    foreach my $File (qw(xls txt doc png pdf)) {
        my $Content = $Self->{MainObject}->FileRead(
            Directory => $Self->{ConfigObject}->Get('Home')."/scripts/test/sample/",
            Filename => "PGP-Test1.$File",
            Mode => 'binmode',
        );
        my $Reference = ${$Content};
        # crypt
        my $Crypted = $Self->{CryptObject}->Crypt(
            Message => $Reference,
            Key => $Keys[0]->{Key},
        );
        $Self->True(
            $Crypted || '',
            "#$Count Crypt()",
        );
        # decrypt
        my %Decrypt = $Self->{CryptObject}->Decrypt(
            Message => $Crypted,
        );
        $Self->True(
            $Decrypt{Successful} || '',
            "#$Count Decrypt() - Successful",
        );
        $Self->True(
            $Decrypt{Data} eq ${$Content},
            "#$Count Decrypt() - Data",
        );
        # sign inline
        my $Sign = $Self->{CryptObject}->Sign(
            Message => $Reference,
            Key => $Keys[0]->{KeyPrivate},
            Type => 'Inline'  # Detached|Inline
        );
        $Self->True(
            $Sign || '',
            "#$Count Sign() - inline .$File",
        );
        # verify
        my %Verify = $Self->{CryptObject}->Verify(
            Message => $Sign,
        );
        $Self->True(
            $Verify{Successful} || '',
            "#$Count Verify() - inline .$File",
        );
        # sign detached
        $Sign = $Self->{CryptObject}->Sign(
            Message => $Reference,
            Key => $Keys[0]->{KeyPrivate},
            Type => 'Detached'  # Detached|Inline
        );
        $Self->True(
            $Sign || '',
            "#$Count Sign() - detached .$File",
        );
        # verify
        %Verify = $Self->{CryptObject}->Verify(
            Message => ${$Content},
            Sign => $Sign,
        );
        $Self->True(
            $Verify{Successful} || '',
            "#$Count Verify() - detached .$File",
        );

    }
}

# delete keys
foreach my $Count (1..2) {
    my @Keys = $Self->{CryptObject}->KeySearch(
        Search => $Search{$Count},
    );
    $Self->True(
        $Keys[0] || '',
        "#$Count KeySearch()",
    );
    my $DeleteSecretKey  = $Self->{CryptObject}->SecretKeyDelete(
        Key =>  $Keys[0]->{KeyPrivate},
    );
    $Self->True(
        $DeleteSecretKey || '',
        "#$Count SecretKeyDelete()",
    );

    my $DeletePublicKey  = $Self->{CryptObject}->PublicKeyDelete(
        Key =>  $Keys[0]->{Key},
    );
    $Self->True(
        $DeletePublicKey || '',
        "#$Count PublicKeyDelete()",
    );

    @Keys = $Self->{CryptObject}->KeySearch(
        Search => $Search{$Count},
    );
    $Self->False(
        $Keys[0] || '',
        "#$Count KeySearch()",
    );
}

# reset config
$Self->{ConfigObject}->Set(Key => 'PGP', Value => 0);

1;
