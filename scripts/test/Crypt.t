# --
# Crypt.t - Crypt tests
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: Crypt.t,v 1.11 2008-01-25 12:07:35 ot Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

use strict;
use warnings;

use Kernel::System::Crypt;

use vars qw($Self);

# set config
$Self->{ConfigObject}->Set(Key => 'PGP', Value => 1);
$Self->{ConfigObject}->Set(
    Key => 'PGP::Options', Value => '--batch --no-tty --yes'
);
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
        Bit => '1024',
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
        Bit => '1024',
        Key => 'F0974D10',
        KeyPrivate => '8593EAE2',
        Created => '2007-08-21',
        Expires => '2037-08-13',
        Fingerprint => '36E9 9F7F AD76 6405 CBE1  BB42 F533 1A46 F097 4D10',
        FingerprintShort => '36E99F7FAD766405CBE1BB42F5331A46F0974D10',
    },
);

my $TestText = 'hello1234567890öäüß';

for my $Count (1..2) {
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
    for my $ID (qw(Type Identifier Bit Key KeyPrivate Created Expires Fingerprint FingerprintShort)) {
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
        Message => $TestText,
        Key => $Keys[0]->{Key},
    );
    $Self->True(
        $Crypted || '',
        "#$Count Crypt()",
    );
    $Self->True(
        $Crypted =~ m{-----BEGIN PGP MESSAGE-----} && $Crypted =~ m{-----END PGP MESSAGE-----},
        "#$Count Crypt() - Data seems ok (crypted)",
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
        $TestText,
        "#$Count Decrypt() - Data",
    );
    $Self->Is(
        $Decrypt{KeyID} || '',
        $Check{$Count}->{KeyPrivate},
        "#$Count Decrypt() - KeyID",
    );
    # sign inline
    my $Sign = $Self->{CryptObject}->Sign(
        Message => $TestText,
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
    $Self->Is(
        $Verify{KeyID} || '',
        $Check{$Count}->{Key},
        "#$Count Verify() - inline - KeyID",
    );
    $Self->Is(
        $Verify{KeyUserID} || '',
        $Check{$Count}->{Identifier},
        "#$Count Verify() - inline - KeyUserID",
    );
    # verify failure on manipulated text
    my $ManipulatedSign = $Sign;
    $ManipulatedSign =~ s{$TestText}{garble-$TestText-garble};
    %Verify = $Self->{CryptObject}->Verify(
        Message => $ManipulatedSign,
    );
    $Self->True(
        !$Verify{Successful},
        "#$Count Verify() - on manipulated text",
    );
    # sign detached
    $Sign = $Self->{CryptObject}->Sign(
        Message => $TestText,
        Key => $Keys[0]->{KeyPrivate},
        Type => 'Detached'  # Detached|Inline
    );
    $Self->True(
        $Sign || '',
        "#$Count Sign() - detached",
    );
    # verify
    %Verify = $Self->{CryptObject}->Verify(
        Message => $TestText,
        Sign => $Sign,
    );
    $Self->True(
        $Verify{Successful} || '',
        "#$Count Verify() - detached",
    );
    $Self->Is(
        $Verify{KeyID} || '',
        $Check{$Count}->{Key},
        "#$Count Verify() - detached - KeyID",
    );
    $Self->Is(
        $Verify{KeyUserID} || '',
        $Check{$Count}->{Identifier},
        "#$Count Verify() - detached - KeyUserID",
    );
    # verify failure
    %Verify = $Self->{CryptObject}->Verify(
        Message => " $TestText ",
        Sign => $Sign,
    );
    $Self->True(
        !$Verify{Successful},
        "#$Count Verify() - detached on manipulated text",
    );

    # file checks
    for my $File (qw(xls txt doc png pdf)) {
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
        $Self->True(
            $Crypted =~ m{-----BEGIN PGP MESSAGE-----} && $Crypted =~ m{-----END PGP MESSAGE-----},
            "#$Count Crypt() - Data seems ok (crypted)",
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
        $Self->Is(
            $Decrypt{KeyID} || '',
            $Check{$Count}->{KeyPrivate},
            "#$Count Decrypt - KeyID",
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
        $Self->Is(
            $Verify{KeyID} || '',
            $Check{$Count}->{Key},
            "#$Count Verify() - inline .$File - KeyID",
        );
        $Self->Is(
            $Verify{KeyUserID} || '',
            $Check{$Count}->{Identifier},
            "#$Count Verify() - inline .$File - KeyUserID",
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
        $Self->Is(
            $Verify{KeyID} || '',
            $Check{$Count}->{Key},
            "#$Count Verify() - detached .$File - KeyID",
        );
        $Self->Is(
            $Verify{KeyUserID} || '',
            $Check{$Count}->{Identifier},
            "#$Count Verify() - detached .$File - KeyUserID",
        );
    }

    # Crypt() should fail if asked to crypt a UTF8-string (instead of ISO-string or binary octets)
    my $UTF8Text = $TestText;
    utf8::upgrade($UTF8Text);
    $Self->True(
        utf8::is_utf8($UTF8Text),
        "Should now have a UTF8-string",
    );
    my $EvalResult = eval {
        $Self->{CryptObject}->Crypt(
            Message => $UTF8Text,
            Key => $Keys[0]->{Key},
        );
        0;
    };
    $Self->False(
        $EvalResult,
        "Crypt() should fail if given a UTF8-string",
    );
}

# delete keys
for my $Count (1..2) {
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
