# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;

use vars (qw($Self));

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

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
    Value => {
        '04A17B7A' => 'somepass',
        '114D1CB6' => 'somepass',
    },
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

    # Try to guess using system 'which'
    else {    # try to guess
        my $GPGBin = `which gpg`;
        chomp $GPGBin;
        if ($GPGBin) {
            $ConfigObject->Set(
                Key   => 'PGP::Bin',
                Value => $GPGBin,
            );
        }
    }
}

# create local crypt object
my $PGPObject = $Kernel::OM->Get('Kernel::System::Crypt::PGP');

if ( !$PGPObject ) {
    print STDERR "NOTICE: No PGP support!\n";
    return;
}

my %Search = (
    1 => 'unittest@example.com',
    2 => 'unittest2@example.com',
    3 => 'unittest3@example.com',
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
    3 => {
        Type             => 'pub',
        Identifier       => 'unit test <unittest3@example.com>',
        Bit              => '4096',
        Key              => 'E023689E',
        KeyPrivate       => '114D1CB6',
        Created          => '2015-12-16',
        Expires          => 'never',
        Fingerprint      => '8C99 1F7D CFD0 5245 8DD7  F2E3 EC9A 3128 E023 689E',
        FingerprintShort => '8C991F7DCFD052458DD7F2E3EC9A3128E023689E',
    },
);

my $TestText = 'hello1234567890äöüÄÖÜ€';
my $Home     = $ConfigObject->Get('Home');

# delete existing keys to have a cleaned test environment
COUNT:
for my $Count ( 1 .. 3 ) {

    my @Keys = $PGPObject->KeySearch(
        Search => $Search{$Count},
    );

    next COUNT if !$Keys[0];
    next COUNT if ref $Keys[0] ne 'HASH';

    if ( $Keys[0]->{KeyPrivate} ) {
        $PGPObject->SecretKeyDelete(
            Key => $Keys[0]->{KeyPrivate},
        );
    }

    if ( $Keys[0]->{Key} ) {
        $PGPObject->PublicKeyDelete(
            Key => $Keys[0]->{Key},
        );
    }
}

# start the tests
for my $Count ( 1 .. 3 ) {
    my @Keys = $PGPObject->KeySearch(
        Search => $Search{$Count},
    );
    $Self->False(
        $Keys[0] || '',
        "#$Count KeySearch()",
    );

    # get keys
    for my $Privacy ( 'Private', 'Public' ) {

        my $KeyString = $MainObject->FileRead(
            Directory => $Home . "/scripts/test/sample/Crypt/",
            Filename  => "PGP${Privacy}Key-$Count.asc",
        );
        my $Message = $PGPObject->KeyAdd(
            Key => ${$KeyString},
        );

        $Self->True(
            $Message || '',
            "#$Count KeyAdd() ($Privacy)",
        );
    }

    @Keys = $PGPObject->KeySearch(
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

    my $PublicKeyString = $PGPObject->PublicKeyGet(
        Key => $Keys[0]->{Key},
    );
    $Self->True(
        $PublicKeyString || '',
        "#$Count PublicKeyGet()",
    );

    my $PrivateKeyString = $PGPObject->SecretKeyGet(
        Key => $Keys[0]->{KeyPrivate},
    );
    $Self->True(
        $PrivateKeyString || '',
        "#$Count SecretKeyGet()",
    );

    # crypt
    my $Crypted = $PGPObject->Crypt(
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
    my %Decrypt = $PGPObject->Decrypt(
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
    my $Sign = $PGPObject->Sign(
        Message => $TestText,
        Key     => $Keys[0]->{KeyPrivate},
        Type    => 'Inline'                  # Detached|Inline
    );
    $Self->True(
        $Sign || '',
        "#$Count Sign() - inline",
    );

    # verify
    my %Verify = $PGPObject->Verify(
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
    %Verify = $PGPObject->Verify(
        Message => $ManipulatedSign,
    );
    $Self->True(
        !$Verify{Successful},
        "#$Count Verify() - on manipulated text",
    );

    # sign detached
    $Sign = $PGPObject->Sign(
        Message => $TestText,
        Key     => $Keys[0]->{KeyPrivate},
        Type    => 'Detached'                # Detached|Inline
    );
    $Self->True(
        $Sign || '',
        "#$Count Sign() - detached",
    );

    # verify
    %Verify = $PGPObject->Verify(
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
    %Verify = $PGPObject->Verify(
        Message => " $TestText ",
        Sign    => $Sign,
    );
    $Self->True(
        !$Verify{Successful},
        "#$Count Verify() - detached on manipulated text",
    );

    # file checks
    for my $File (qw(xls txt doc png pdf)) {
        my $Content = $MainObject->FileRead(
            Directory => $Home . "/scripts/test/sample/Crypt/",
            Filename  => "PGP-Test1.$File",
            Mode      => 'binmode',
        );
        my $Reference = ${$Content};

        # crypt
        my $Crypted = $PGPObject->Crypt(
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
        my %Decrypt = $PGPObject->Decrypt(
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
        my $Sign = $PGPObject->Sign(
            Message => $Reference,
            Key     => $Keys[0]->{KeyPrivate},
            Type    => 'Inline'                  # Detached|Inline
        );
        $Self->True(
            $Sign || '',
            "#$Count Sign() - inline .$File",
        );

        # verify
        my %Verify = $PGPObject->Verify(
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
        $Sign = $PGPObject->Sign(
            Message => $Reference,
            Key     => $Keys[0]->{KeyPrivate},
            Type    => 'Detached'                # Detached|Inline
        );
        $Self->True(
            $Sign || '',
            "#$Count Sign() - detached .$File",
        );

        # verify
        %Verify = $PGPObject->Verify(
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
    $Crypted = $PGPObject->Crypt(
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
    %Decrypt = $PGPObject->Decrypt(
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

# check signing for different digest types
# only key 3 currently supports all those types
for my $Count (3) {

    my @Keys = $PGPObject->KeySearch(
        Search => $Search{$Count},
    );

    my %DeprecatedDigestTypes = (
        md5 => 1,
    );
    for my $DigestPreference (qw(md5 sha1 sha224 sha256 sha384 sha512)) {

        # set digest type
        $ConfigObject->Set(
            Key   => 'PGP::Options::DigestPreference',
            Value => $DigestPreference,
        );

        # sign inline
        my $Sign = $PGPObject->Sign(
            Message => $TestText,
            Key     => $Keys[0]->{KeyPrivate},
            Type    => 'Inline'                  # Detached|Inline
        );
        if ( $DeprecatedDigestTypes{$DigestPreference} ) {
            $Self->False(
                $Sign || '',
                "#$Count Sign() using $DigestPreference fail - inline",
            );
        }
        else {
            $Self->True(
                $Sign || '',
                "#$Count Sign() using $DigestPreference - inline",
            );

            # verify used digest algtorithm
            my $DigestAlgorithm;
            $DigestAlgorithm = lc $1 if $Sign =~ m{ \n Hash: [ ] ([^\n]+) \n }xms;
            $Self->Is(
                $DigestAlgorithm || '',
                $DigestPreference,
                "#$Count Sign() - check used digest algorithm",
            );

            # verify
            my %Verify = $PGPObject->Verify(
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
            %Verify = $PGPObject->Verify(
                Message => $ManipulatedSign,
            );
            $Self->True(
                !$Verify{Successful},
                "#$Count Verify() - on manipulated text",
            );
        }

        # sign detached
        $Sign = $PGPObject->Sign(
            Message => $TestText,
            Key     => $Keys[0]->{KeyPrivate},
            Type    => 'Detached'                # Detached|Inline
        );
        if ( $DeprecatedDigestTypes{$DigestPreference} ) {
            $Self->False(
                $Sign || '',
                "#$Count Sign() using $DigestPreference fail - detached",
            );
        }
        else {
            $Self->True(
                $Sign || '',
                "#$Count Sign() using $DigestPreference - detached",
            );

            # verify
            my %Verify = $PGPObject->Verify(
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
            %Verify = $PGPObject->Verify(
                Message => " $TestText ",
                Sign    => $Sign,
            );
            $Self->True(
                !$Verify{Successful},
                "#$Count Verify() - detached on manipulated text",
            );
        }
    }
}

# check for expired and revoked PGP keys
{

    # expired key
    my $Search = 'testingexpired@example.com';

    # get expired key
    my $KeyString = $MainObject->FileRead(
        Directory => $Home . '/scripts/test/sample/Crypt/',
        Filename  => 'PGPPublicKey-Expired.asc',
    );

    # add the key to the keyring
    $PGPObject->KeyAdd( Key => ${$KeyString} );

    # search for expired key and wait for expired status
    my @Keys = $PGPObject->KeySearch(
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
    $KeyString = $MainObject->FileRead(
        Directory => $Home . '/scripts/test/sample/Crypt/',
        Filename  => 'PGPPublicKey-ToRevoke.asc',
    );

    # add the key to the keyring
    $PGPObject->KeyAdd( Key => ${$KeyString} );

    # get key
    $KeyString = $MainObject->FileRead(
        Directory => $Home . '/scripts/test/sample/Crypt/',
        Filename  => 'PGPPublicKey-RevokeCert.asc',
    );

    # add the key to the keyring
    $PGPObject->KeyAdd( Key => ${$KeyString} );

    # search for revoked key and wait for revoked status
    @Keys = $PGPObject->KeySearch(
        Search => $Search,
    );

    $Self->Is(
        $Keys[0]->{Status},
        'revoked',
        'Check for revoked pgp key',
    );
}

# delete keys
for my $Count ( 1 .. 3 ) {
    my @Keys = $PGPObject->KeySearch(
        Search => $Search{$Count},
    );
    $Self->True(
        $Keys[0] || '',
        "#$Count KeySearch()",
    );
    my $DeleteSecretKey = $PGPObject->SecretKeyDelete(
        Key => $Keys[0]->{KeyPrivate},
    );
    $Self->True(
        $DeleteSecretKey || '',
        "#$Count SecretKeyDelete()",
    );

    my $DeletePublicKey = $PGPObject->PublicKeyDelete(
        Key => $Keys[0]->{Key},
    );
    $Self->True(
        $DeletePublicKey || '',
        "#$Count PublicKeyDelete()",
    );

    @Keys = $PGPObject->KeySearch(
        Search => $Search{$Count},
    );
    $Self->False(
        $Keys[0] || '',
        "#$Count KeySearch()",
    );
}

# cleanup is done by RestoreDatabase

1;
