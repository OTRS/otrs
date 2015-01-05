# --
# Crypt.t - Crypt tests
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# $Id: Crypt.t,v 1.21 2011-03-15 15:24:06 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars qw($Self);

use Kernel::System::Crypt;
use Kernel::Config;

# create local object
my $ConfigObject = Kernel::Config->new();

# set config
$ConfigObject->Set(
    Key   => 'PGP',
    Value => 1,
);
$ConfigObject->Set(
    Key   => 'PGP::Options',
    Value => '--batch --no-tty --yes',
);
$ConfigObject->Set(
    Key   => 'PGP::Key::Password',
    Value => { '04A17B7A' => 'somepass' },
);

# check if gpg is located there
if ( !-e $ConfigObject->Get('PGP::Bin') ) {

    # maybe it's a mac with macport
    if ( -e '/opt/local/bin/gpg' ) {
        $ConfigObject->Set(
            Key   => 'PGP::Bin',
            Value => '/opt/local/bin/gpg'
        );
    }
}

# create local crypt object
my $CryptObject = Kernel::System::Crypt->new(
    %{$Self},
    ConfigObject => $ConfigObject,
    CryptType    => 'PGP',
);

if ( !$CryptObject ) {
    print STDERR "NOTICE: No PGP support!\n";
    return;
}

my %Search = (
    1 => 'unittest@example.com',
    2 => 'unittest2@example.com',
);

my %Check = (
    1 => {
        Type             => 'pub',
        Identifier       => 'UnitTest <unittest@example.com>',
        Bit              => '1024',
        Key              => '38677C3B',
        KeyPrivate       => '04A17B7A',
        Created          => '2007-08-21',
        Expires          => 'never',
        Fingerprint      => '4124 DFBD CF52 D129 AB3E  3C44 1404 FBCB 3867 7C3B',
        FingerprintShort => '4124DFBDCF52D129AB3E3C441404FBCB38677C3B',
    },
    2 => {
        Type             => 'pub',
        Identifier       => 'UnitTest2 <unittest2@example.com>',
        Bit              => '1024',
        Key              => 'F0974D10',
        KeyPrivate       => '8593EAE2',
        Created          => '2007-08-21',
        Expires          => '2037-08-13',
        Fingerprint      => '36E9 9F7F AD76 6405 CBE1  BB42 F533 1A46 F097 4D10',
        FingerprintShort => '36E99F7FAD766405CBE1BB42F5331A46F0974D10',
    },
);

my $TestText = 'hello1234567890öäüß';

for my $Count ( 1 .. 2 ) {
    my @Keys = $CryptObject->KeySearch(
        Search => $Search{$Count},
    );
    $Self->False(
        $Keys[0] || '',
        "#$Count KeySearch()",
    );

    # get keys
    my $KeyString = $Self->{MainObject}->FileRead(
        Directory => $ConfigObject->Get('Home') . "/scripts/test/sample/Crypt/",
        Filename  => "PGPPrivateKey-$Count.asc",
    );
    my $Message = $CryptObject->KeyAdd(
        Key => ${$KeyString},
    );
    $Self->True(
        $Message || '',
        "#$Count KeyAdd()",
    );

    @Keys = $CryptObject->KeySearch(
        Search => $Search{$Count},
    );

    $Self->True(
        $Keys[0] || '',
        "#$Count KeySearch()",
    );
    for my $ID (qw(Type Identifier Bit Key KeyPrivate Created Expires Fingerprint FingerprintShort))
    {
        $Self->Is(
            $Keys[0]->{$ID} || '',
            $Check{$Count}->{$ID},
            "#$Count KeySearch() - $ID",
        );
    }

    my $PublicKeyString = $CryptObject->PublicKeyGet(
        Key => $Keys[0]->{Key},
    );
    $Self->True(
        $PublicKeyString || '',
        "#$Count PublicKeyGet()",
    );

    my $PrivateKeyString = $CryptObject->SecretKeyGet(
        Key => $Keys[0]->{KeyPrivate},
    );
    $Self->True(
        $PrivateKeyString || '',
        "#$Count SecretKeyGet()",
    );

    # crypt
    my $Crypted = $CryptObject->Crypt(
        Message => $TestText,
        Key     => $Keys[0]->{Key},
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
    my %Decrypt = $CryptObject->Decrypt(
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
    my $Sign = $CryptObject->Sign(
        Message => $TestText,
        Key     => $Keys[0]->{KeyPrivate},
        Type    => 'Inline'                  # Detached|Inline
    );
    $Self->True(
        $Sign || '',
        "#$Count Sign() - inline",
    );

    # verify
    my %Verify = $CryptObject->Verify(
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
    %Verify = $CryptObject->Verify(
        Message => $ManipulatedSign,
    );
    $Self->True(
        !$Verify{Successful},
        "#$Count Verify() - on manipulated text",
    );

    # sign detached
    $Sign = $CryptObject->Sign(
        Message => $TestText,
        Key     => $Keys[0]->{KeyPrivate},
        Type    => 'Detached'                # Detached|Inline
    );
    $Self->True(
        $Sign || '',
        "#$Count Sign() - detached",
    );

    # verify
    %Verify = $CryptObject->Verify(
        Message => $TestText,
        Sign    => $Sign,
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
    %Verify = $CryptObject->Verify(
        Message => " $TestText ",
        Sign    => $Sign,
    );
    $Self->True(
        !$Verify{Successful},
        "#$Count Verify() - detached on manipulated text",
    );

    # file checks
    for my $File (qw(xls txt doc png pdf)) {
        my $Content = $Self->{MainObject}->FileRead(
            Directory => $ConfigObject->Get('Home') . "/scripts/test/sample/Crypt/",
            Filename  => "PGP-Test1.$File",
            Mode      => 'binmode',
        );
        my $Reference = ${$Content};

        # crypt
        my $Crypted = $CryptObject->Crypt(
            Message => $Reference,
            Key     => $Keys[0]->{Key},
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
        my %Decrypt = $CryptObject->Decrypt(
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
        my $Sign = $CryptObject->Sign(
            Message => $Reference,
            Key     => $Keys[0]->{KeyPrivate},
            Type    => 'Inline'                  # Detached|Inline
        );
        $Self->True(
            $Sign || '',
            "#$Count Sign() - inline .$File",
        );

        # verify
        my %Verify = $CryptObject->Verify(
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
        $Sign = $CryptObject->Sign(
            Message => $Reference,
            Key     => $Keys[0]->{KeyPrivate},
            Type    => 'Detached'                # Detached|Inline
        );
        $Self->True(
            $Sign || '',
            "#$Count Sign() - detached .$File",
        );

        # verify
        %Verify = $CryptObject->Verify(
            Message => ${$Content},
            Sign    => $Sign,
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

    # Crypt() should still work if asked to crypt a UTF8-string (instead of ISO-string or
    # binary octets) - automatic conversion to a byte string should take place.
    my $UTF8Text = $TestText;
    utf8::upgrade($UTF8Text);
    $Self->True(
        utf8::is_utf8($UTF8Text),
        "Should now have a UTF8-string",
    );
    $Crypted = $CryptObject->Crypt(
        Message => $UTF8Text,
        Key     => $Keys[0]->{Key},
    );
    $Self->True(
        $Crypted || '',
        "Crypt() should still work if given a UTF8-string",
    );
    $Self->True(
        $Crypted =~ m{-----BEGIN PGP MESSAGE-----} && $Crypted =~ m{-----END PGP MESSAGE-----},
        "#$Count Crypt() - Data seems ok (crypted)",
    );

    # decrypt
    %Decrypt = $CryptObject->Decrypt(
        Message => $Crypted,
    );
    $Self->True(
        $Decrypt{Successful} || '',
        "#$Count Decrypt() - Successful",
    );

    # we have crypted an utf8-string, but we will get back a byte string. In order to compare it,
    # we need to decode it into utf8:
    utf8::decode( $Decrypt{Data} );
    $Self->Is(
        $Decrypt{Data},
        $UTF8Text,
        "#$Count Decrypt() - Data",
    );
}

# check for expired and revoked PGP keys
{

    # expired key
    my $Search = 'testingexpired@example.com';

    # get expired key
    my $KeyString = $Self->{MainObject}->FileRead(
        Directory => $ConfigObject->Get('Home') . '/scripts/test/sample/Crypt/',
        Filename  => 'PGPPublicKey-Expired.asc',
    );

    # add the key to the keyring
    $CryptObject->KeyAdd( Key => ${$KeyString} );

    # search for expired key and wait for expired status
    my @Keys = $CryptObject->KeySearch(
        Search => $Search,
    );

    $Self->Is(
        $Keys[0]->{Status},
        'expired',
        'Check for expired pgp key',
    );

    # revoked key

    $Search = 'testingkey@test.com';

    # get key
    $KeyString = $Self->{MainObject}->FileRead(
        Directory => $ConfigObject->Get('Home') . '/scripts/test/sample/Crypt/',
        Filename  => 'PGPPublicKey-ToRevoke.asc',
    );

    # add the key to the keyring
    $CryptObject->KeyAdd( Key => ${$KeyString} );

    # get key
    $KeyString = $Self->{MainObject}->FileRead(
        Directory => $ConfigObject->Get('Home') . '/scripts/test/sample/Crypt/',
        Filename  => 'PGPPublicKey-RevokeCert.asc',
    );

    # add the key to the keyring
    $CryptObject->KeyAdd( Key => ${$KeyString} );

    # search for revoked key and wait for revoked status
    @Keys = $CryptObject->KeySearch(
        Search => $Search,
    );

    $Self->Is(
        $Keys[0]->{Status},
        'revoked',
        'Check for revoked pgp key',
    );
}

# delete keys
for my $Count ( 1 .. 2 ) {
    my @Keys = $CryptObject->KeySearch(
        Search => $Search{$Count},
    );
    $Self->True(
        $Keys[0] || '',
        "#$Count KeySearch()",
    );
    my $DeleteSecretKey = $CryptObject->SecretKeyDelete(
        Key => $Keys[0]->{KeyPrivate},
    );
    $Self->True(
        $DeleteSecretKey || '',
        "#$Count SecretKeyDelete()",
    );

    my $DeletePublicKey = $CryptObject->PublicKeyDelete(
        Key => $Keys[0]->{Key},
    );
    $Self->True(
        $DeletePublicKey || '',
        "#$Count PublicKeyDelete()",
    );

    @Keys = $CryptObject->KeySearch(
        Search => $Search{$Count},
    );
    $Self->False(
        $Keys[0] || '',
        "#$Count KeySearch()",
    );
}

1;
