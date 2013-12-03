# --
# SMIME.t - SMIME tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;

use Kernel::System::Crypt;

use vars qw($Self);
use Kernel::Config;
use Kernel::System::Main;

# create local objects
my $ConfigObject = Kernel::Config->new();
my $HomeDir      = $ConfigObject->Get('Home');
my $CertPath     = $ConfigObject->Get('SMIME::CertPath');
my $PrivatePath  = $ConfigObject->Get('SMIME::PrivatePath');

my $OpenSSLBin = $ConfigObject->Get('SMIME::Bin');

# get the openssl version string, e.g. OpenSSL 0.9.8e 23 Feb 2007
my $OpenSSLVersionString = qx{$OpenSSLBin version};
my $OpenSSLMajorVersion;

# get the openssl major version, e.g. 1 for version 1.0.0
if ( $OpenSSLVersionString =~ m{ \A (?: OpenSSL )? \s* ( \d )  }xmsi ) {
    $OpenSSLMajorVersion = $1;
}

# openssl version 1.0.0 uses different hash algorithm... in the future release of openssl this might
#change again in such case a better version detection will be needed
my $UseNewHashes;
if ( $OpenSSLMajorVersion >= 1 ) {
    $UseNewHashes = 1;
}

# set config
$ConfigObject->Set(
    Key   => 'SMIME',
    Value => 1,
);

# check if openssl is located there
if ( !-e $ConfigObject->Get('SMIME::Bin') ) {

    # maybe it's a mac with macport
    if ( -e '/opt/local/bin/openssl' ) {
        $ConfigObject->Set(
            Key   => 'SMIME::Bin',
            Value => '/opt/local/bin/openssl',
        );
    }
}

# create crypt object
my $CryptObject = Kernel::System::Crypt->new(
    %{$Self},
    ConfigObject => $ConfigObject,
    CryptType    => 'SMIME',
);

if ( !$CryptObject ) {
    print STDERR "NOTICE: No SMIME support!\n";

    if ( !-e $OpenSSLBin ) {
        $Self->False(
            1,
            "No such $OpenSSLBin!",
        );
    }
    elsif ( !-x $OpenSSLBin ) {
        $Self->False(
            1,
            "$OpenSSLBin not executable!",
        );
    }
    elsif ( !-e $CertPath ) {
        $Self->False(
            1,
            "No such $CertPath!",
        );
    }
    elsif ( !-d $CertPath ) {
        $Self->False(
            1,
            "No such $CertPath directory!",
        );
    }
    elsif ( !-r $CertPath ) {
        $Self->False(
            1,
            "$CertPath not writable!",
        );
    }
    elsif ( !-e $PrivatePath ) {
        $Self->False(
            1,
            "No such $PrivatePath!",
        );
    }
    elsif ( !-d $Self->{PrivatePath} ) {
        $Self->False(
            1,
            "No such $PrivatePath directory!",
        );
    }
    elsif ( !-w $PrivatePath ) {
        $Self->False(
            1,
            "$PrivatePath not writable!",
        );
    }
    return 1;
}

# create main object
my $MainObject = Kernel::System::Main->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

my %Search = (
    1 => 'unittest@example.org',
    2 => 'unittest2@example.org',
);

# 0.9.x hashes
my $CheckHash1 = '980a83c7';
my $CheckHash2 = '999bcb2f';

# 1.0.0 hashes
if ($UseNewHashes) {
    $CheckHash1 = 'f62a2257';
    $CheckHash2 = '35c7d865';
}

my %Check = (
    1 => {
        Modulus =>
            'B686AD697981A5A387792F3F301062EF520F6966AE21421995C1AB63BF4AB974D250E8764F9B341364B0842FA59C9FFECCB0243ABF802FAF28DFDCE3C2315FC74D6BA81F09AB5F333A0EDAFFDDCB941792F4C0E57AC0413E205E89D4E61D39B0F144FAF3E7064FD97131DC1E723044E4B0DEAA17E83C0B0697C1BB65B11D997C6A3EAB148FFAB3ECF60CB9E17BE0DABAE087F488BCA29C14D597DE024F1A0EBA6F435EFA03B1EBCBBB5D1107CBBD72CC8B0202AE76BEA0672B24A75C82031BC2DE9B82CDC25316F7DDEC9D32BF9C4FF2858424AA371D2E96F71170AAB3167ED9FA5A2C525C53B8ECE725034339DC3DAC32D3840D1D3ACFB42DB67C9817142019',
        Subject =>
            'C= DE ST= Bayern L= Straubing O= OTRS AG CN= unittest emailAddress= unittest@example.org',
        Hash        => $CheckHash1,
        Private     => 'No',
        Serial      => 'F20143205EFC76E9',
        Type        => 'cert',
        Fingerprint => 'E9:F9:8D:54:74:35:E6:AC:9F:81:E5:D5:82:0E:6C:27:B2:B0:D4:18',
        Issuer =>
            '/C= DE/ST= Bayern/L= Straubing/O= OTRS AG/CN= unittest/emailAddress= unittest@example.org',
        Email          => 'unittest@example.org',
        ShortEndDate   => '2026-01-15',
        EndDate        => 'Jan 15 13:11:32 2026 GMT',
        StartDate      => 'May  8 13:11:32 2012 GMT',
        ShortStartDate => '2012-05-08',
    },
    2 => {
        Modulus =>
            'CFAF52AC9AD837F66289E6BAB9BBF96BD3173FE26EA06E72939E921528AFA6197C1FF941BEBEE1FD424353E725531A5521BA8BE7A796C0668E3FBFBEC9926D6B972E0513EDF12A81299328B62C132BB63D0B3942A2A194DE46814E84E2E959437DC5FC36F2F51E3B6913A0AF9DC1275495DE10EB2DA57913D725CAFBBCB8A2A476EF71B70A66AD7BFD9A2E37EB9C26BE41D5C5F9207C4CBA24AC0CE97367622CC14D717ACF54FF6111EA0BD62EB2D73D684FF8119AFDFA196233EF8DD2F31001F86621146A187236F30677E4639377AE53B7FAFE7B2C497832F736E566D86260DBC0E4720FE267E61646462CECF8A8353034CD6F8C9D617B86E3EB2EC3477237',
        Subject =>
            'C= DE ST= Bayern L= Straubing O= OTRS AG CN= unittest2 emailAddress= unittest2@example.org',
        Hash        => $CheckHash2,
        Private     => 'No',
        Serial      => 'F510FC0C8A46E2A1',
        Fingerprint => 'AD:E4:99:93:45:CB:82:E3:1E:4B:0F:92:12:8D:21:26:3D:16:77:87',
        Type        => 'cert',
        Issuer =>
            '/C= DE/ST= Bayern/L= Straubing/O= OTRS AG/CN= unittest2/emailAddress= unittest2@example.org',
        Email          => 'unittest2@example.org',
        EndDate        => 'Jan 15 13:29:18 2026 GMT',
        ShortEndDate   => '2026-01-15',
        StartDate      => 'May  8 13:29:18 2012 GMT',
        ShortStartDate => '2012-05-08',
    },
    'cert-1' => '-----BEGIN CERTIFICATE-----
MIIEXjCCA0agAwIBAgIJAPIBQyBe/HbpMA0GCSqGSIb3DQEBBQUAMHwxCzAJBgNV
BAYTAkRFMQ8wDQYDVQQIEwZCYXllcm4xEjAQBgNVBAcTCVN0cmF1YmluZzEQMA4G
A1UEChMHT1RSUyBBRzERMA8GA1UEAxMIdW5pdHRlc3QxIzAhBgkqhkiG9w0BCQEW
FHVuaXR0ZXN0QGV4YW1wbGUub3JnMB4XDTEyMDUwODEzMTEzMloXDTI2MDExNTEz
MTEzMlowfDELMAkGA1UEBhMCREUxDzANBgNVBAgTBkJheWVybjESMBAGA1UEBxMJ
U3RyYXViaW5nMRAwDgYDVQQKEwdPVFJTIEFHMREwDwYDVQQDEwh1bml0dGVzdDEj
MCEGCSqGSIb3DQEJARYUdW5pdHRlc3RAZXhhbXBsZS5vcmcwggEiMA0GCSqGSIb3
DQEBAQUAA4IBDwAwggEKAoIBAQC2hq1peYGlo4d5Lz8wEGLvUg9pZq4hQhmVwatj
v0q5dNJQ6HZPmzQTZLCEL6Wcn/7MsCQ6v4Avryjf3OPCMV/HTWuoHwmrXzM6Dtr/
3cuUF5L0wOV6wEE+IF6J1OYdObDxRPrz5wZP2XEx3B5yMETksN6qF+g8CwaXwbtl
sR2ZfGo+qxSP+rPs9gy54Xvg2rrgh/SIvKKcFNWX3gJPGg66b0Ne+gOx68u7XREH
y71yzIsCAq52vqBnKySnXIIDG8Lem4LNwlMW993snTK/nE/yhYQkqjcdLpb3EXCq
sxZ+2fpaLFJcU7js5yUDQzncPawy04QNHTrPtC22fJgXFCAZAgMBAAGjgeIwgd8w
HQYDVR0OBBYEFBZG1kwr7OFhLzYO9PEsPJT5OxbaMIGvBgNVHSMEgacwgaSAFBZG
1kwr7OFhLzYO9PEsPJT5OxbaoYGApH4wfDELMAkGA1UEBhMCREUxDzANBgNVBAgT
BkJheWVybjESMBAGA1UEBxMJU3RyYXViaW5nMRAwDgYDVQQKEwdPVFJTIEFHMREw
DwYDVQQDEwh1bml0dGVzdDEjMCEGCSqGSIb3DQEJARYUdW5pdHRlc3RAZXhhbXBs
ZS5vcmeCCQDyAUMgXvx26TAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBBQUAA4IB
AQBE2M1dcTkQyPJUXzchMGIWD5nkUDs0iHqIPNfeTWcTW3iuzZHA6rj4Lw7RFOs+
seYl14DywnYFUM5UZz4ko9t+uqECp4LK6qdkYomjSw+E8Zs5se8QlRYhDEjEDqwR
c0xg0lgybQoceMJ7ub+V/yp/EIyfKbaJBtYIDucQ6yB1EECVm1hfKKLg+gUk4rLY
WgEFDKCVadkItr5yLLMp9CGKWpiv7sW/5f2YVTEZGCcbp2hQRCMPpQYCtvbdfyh5
lZbOYUaP6zWPsKjftcev2Q5ik1L7N9eCynBF3a2U0TPVkfFyzuO58k96vUhKltOb
nj2wbQO4KjM12YLUuvahk5se
-----END CERTIFICATE-----
',
    'cert-2' => '-----BEGIN CERTIFICATE-----
MIIEZTCCA02gAwIBAgIJAPUQ/AyKRuKhMA0GCSqGSIb3DQEBBQUAMH4xCzAJBgNV
BAYTAkRFMQ8wDQYDVQQIEwZCYXllcm4xEjAQBgNVBAcTCVN0cmF1YmluZzEQMA4G
A1UEChMHT1RSUyBBRzESMBAGA1UEAxMJdW5pdHRlc3QyMSQwIgYJKoZIhvcNAQkB
FhV1bml0dGVzdDJAZXhhbXBsZS5vcmcwHhcNMTIwNTA4MTMyOTE4WhcNMjYwMTE1
MTMyOTE4WjB+MQswCQYDVQQGEwJERTEPMA0GA1UECBMGQmF5ZXJuMRIwEAYDVQQH
EwlTdHJhdWJpbmcxEDAOBgNVBAoTB09UUlMgQUcxEjAQBgNVBAMTCXVuaXR0ZXN0
MjEkMCIGCSqGSIb3DQEJARYVdW5pdHRlc3QyQGV4YW1wbGUub3JnMIIBIjANBgkq
hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAz69SrJrYN/Ziiea6ubv5a9MXP+JuoG5y
k56SFSivphl8H/lBvr7h/UJDU+clUxpVIbqL56eWwGaOP7++yZJta5cuBRPt8SqB
KZMotiwTK7Y9CzlCoqGU3kaBToTi6VlDfcX8NvL1HjtpE6CvncEnVJXeEOstpXkT
1yXK+7y4oqR273G3Cmate/2aLjfrnCa+QdXF+SB8TLokrAzpc2diLMFNcXrPVP9h
EeoL1i6y1z1oT/gRmv36GWIz743S8xAB+GYhFGoYcjbzBnfkY5N3rlO3+v57LEl4
Mvc25WbYYmDbwORyD+Jn5hZGRizs+Kg1MDTNb4ydYXuG4+suw0dyNwIDAQABo4Hl
MIHiMB0GA1UdDgQWBBQJSIvelTIWMmkrSc92Jf2Z2tFlojCBsgYDVR0jBIGqMIGn
gBQJSIvelTIWMmkrSc92Jf2Z2tFloqGBg6SBgDB+MQswCQYDVQQGEwJERTEPMA0G
A1UECBMGQmF5ZXJuMRIwEAYDVQQHEwlTdHJhdWJpbmcxEDAOBgNVBAoTB09UUlMg
QUcxEjAQBgNVBAMTCXVuaXR0ZXN0MjEkMCIGCSqGSIb3DQEJARYVdW5pdHRlc3Qy
QGV4YW1wbGUub3JnggkA9RD8DIpG4qEwDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0B
AQUFAAOCAQEASYgs16erFua1ayilG14OL+/qxgOa5UOi/+i1SGK0srNAE89ShTVv
XVJbEtYwJIZBUzGj6oOP6EhcV1HzMoyKnkR32JzxOF8JTdVfmFq/+g1+2WY82ONf
dgfqUWZK7FD7iiMQTAQwQ2ZsfRUeysufi45ZxIZd7G9vyDh83XyVR5P6rop56BZF
TtZDIk1lGfM1ZuXWeQfOUE4N0bOM+idDDMk3mcyy9wpkxAgq++FUQXwhwUnpeiZi
m012tpyvuaVVcNTY5MXgvonWtH2Vv8VnnBJ/at//961DX9u67qIQaIqReU18HjJ3
w/5UXrBm/VSYu01mcpSN4rCPM9onzepmEA==
-----END CERTIFICATE-----
'
);

# remove \r that will have been inserted on Windows automatically
if ( $^O =~ m{Win}i ) {
    $Check{'cert-1'} =~ tr{\r}{}d;
    $Check{'cert-2'} =~ tr{\r}{}d;
}

my $TestText = 'hello1234567890öäüß';

for my $Count ( 1 .. 2 ) {
    my @Certs = $CryptObject->Search( Search => $Search{$Count} );
    $Self->False(
        $Certs[0] || '',
        "#$Count Search()",
    );

    # add certificate ...
    my $CertString = $Self->{MainObject}->FileRead(
        Directory => $ConfigObject->Get('Home') . "/scripts/test/sample/SMIME/",
        Filename  => "SMIMECertificate-$Count.asc",
    );
    my %Result = $CryptObject->CertificateAdd( Certificate => ${$CertString} );

    $Certs[0]->{Filename} = $Result{Filename};

    $Self->True(
        $Result{Successful} || '',
        "#$Count CertificateAdd() - $Result{Message}",
    );

    # test if read cert from file is the same as in unittest file
    $Self->Is(
        ${$CertString},
        $Check{"cert-$Count"},
        "#$Count CertificateSearch() - Test if read cert from file is the same as in unittest file",
    );

    @Certs = $CryptObject->CertificateSearch(
        Search => $Search{$Count},
    );

    $Self->True(
        $Certs[0] || '',
        "#$Count CertificateSearch()",
    );

    for my $ID ( sort keys %{ $Check{$Count} } ) {
        $Self->Is(
            $Certs[0]->{$ID} || '',
            $Check{$Count}->{$ID},
            "#$Count CertificateSearch() - $ID",
        );
    }

    # and private key
    my $KeyString = $Self->{MainObject}->FileRead(
        Directory => $ConfigObject->Get('Home') . "/scripts/test/sample/SMIME/",
        Filename  => "SMIMEPrivateKey-$Count.asc",
    );
    my $Secret = $Self->{MainObject}->FileRead(
        Directory => $ConfigObject->Get('Home') . "/scripts/test/sample/SMIME/",
        Filename  => "SMIMEPrivateKeyPass-$Count.asc",
    );
    %Result = $CryptObject->PrivateAdd(
        Private => ${$KeyString},
        Secret  => ${$Secret},
    );
    $Self->True(
        $Result{Successful} || '',
        "#$Count PrivateAdd()",
    );

    my @Keys = $CryptObject->PrivateSearch( Search => $Search{$Count} );

    $Self->True(
        $Keys[0] || '',
        "#$Count PrivateSearch()",
    );

    my $CertificateString = $CryptObject->CertificateGet(
        Hash        => $Certs[0]->{Hash},
        Fingerprint => $Certs[0]->{Fingerprint},
    );
    $Self->True(
        $CertificateString || '',
        "#$Count CertificateGet()",
    );

    my $PrivateKeyString = $CryptObject->PrivateGet(
        Hash    => $Keys[0]->{Hash},
        Modulus => $Certs[0]->{Modulus},
    );
    $Self->True(
        $PrivateKeyString || '',
        "#$Count PrivateGet()",
    );

    # crypt
    my $Crypted = $CryptObject->Crypt(
        Message  => $TestText,
        Filename => $Certs[0]->{Filename},
    );
    $Self->True(
        $Crypted || '',
        "#$Count Crypt() by cert filename",
    );

    $Self->True(
        $Crypted =~ m{Content-Type: application/(x-)?pkcs7-mime;}
            && $Crypted =~ m{Content-Transfer-Encoding: base64},
        "#$Count Crypt() - Data seems ok (crypted)",
    );

    # decrypt
    my %Decrypt = $CryptObject->Decrypt(
        Message  => $Crypted,
        Filename => $Certs[0]->{Filename},
    );
    $Self->True(
        $Decrypt{Successful} || '',
        "#$Count Decrypt() by cert filename - Successful: $Decrypt{Message}",
    );
    $Self->Is(
        $Decrypt{Data} || '',
        $TestText,
        "#$Count Decrypt() - Data",
    );

    # sign
    my $Sign = $CryptObject->Sign(
        Message  => $TestText,
        Filename => $Certs[0]->{Filename},
    );
    $Self->True(
        $Sign || '',
        "#$Count Sign()",
    );

    # verify
    my %Verify = $CryptObject->Verify(
        Message => $Sign,
        CACert  => "$CertPath/$Certs[0]->{Filename}",
    );

    $Self->True(
        $Verify{Successful} || '',
        "#$Count Verify() - self signed sending certificate path",
    );
    $Self->True(
        $Verify{SignerCertificate} eq $Check{"cert-$Count"},
        "#$Count Verify()",
    );

    # verify failure on manipulated text
    my $ManipulatedSign = $Sign;
    $ManipulatedSign =~ s{Q}{W}g;
    %Verify = $CryptObject->Verify(
        Message => $ManipulatedSign,
        CACert  => "$CertPath/$Certs[0]->{Filename}",
    );
    $Self->True(
        !$Verify{Successful},
        "#$Count Verify() - on manipulated text",
    );

   # file checks
   # TODO: signing binary files doesn't seem to work at all, maybe because they need to be converted
   #       to base64 first?
   #    for my $File (qw(xls txt doc png pdf)) {
    for my $File (qw(txt)) {
        my $Content = $Self->{MainObject}->FileRead(
            Directory => $ConfigObject->Get('Home') . "/scripts/test/sample/SMIME/",
            Filename  => "PGP-Test1.$File",
            Mode      => 'binmode',
        );
        my $Reference = ${$Content};
        $Reference =~ s{\n}{\r\n}gsm;

        # crypt
        my $Crypted = $CryptObject->Crypt(
            Message     => $Reference,
            Hash        => $Certs[0]->{Hash},
            Fingerprint => $Certs[0]->{Fingerprint},
        );
        $Self->True(
            $Crypted || '',
            "#$Count Crypt()",
        );
        $Self->True(
            $Crypted =~ m{Content-Type: application/(x-)?pkcs7-mime;}
                && $Crypted =~ m{Content-Transfer-Encoding: base64},
            "#$Count Crypt() - Data seems ok (crypted)",
        );

        # decrypt
        my %Decrypt = $CryptObject->Decrypt(
            Message     => $Crypted,
            Hash        => $Certs[0]->{Hash},
            Fingerprint => $Certs[0]->{Fingerprint},
        );
        $Self->True(
            $Decrypt{Successful} || '',
            "#$Count Decrypt() - Successful .$File",
        );
        $Self->True(
            $Decrypt{Data} eq $Reference,
            "#$Count Decrypt() - Data .$File",
        );

        # sign
        my $Signed = $CryptObject->Sign(
            Message     => $Reference,
            Hash        => $Keys[0]->{Hash},
            Fingerprint => $Keys[0]->{Fingerprint},
        );
        $Self->True(
            $Signed || '',
            "#$Count Sign() .$File",
        );

        # verify
        my %Verify = $CryptObject->Verify(
            Message => $Signed,
            CACert  => "$CertPath/$Certs[0]->{Filename}",
        );
        $Self->True(
            $Verify{Successful} || '',
            "#$Count Verify() .$File",
        );
        $Self->True(
            $Verify{SignerCertificate} eq $Check{"cert-$Count"},
            "#$Count Verify() .$File - SignerCertificate",
        );
    }
}

# delete keys
for my $Count ( 1 .. 2 ) {
    my @Keys = $CryptObject->Search(
        Search => $Search{$Count},
    );
    $Self->True(
        $Keys[0] || '',
        "#$Count Search()",
    );
    my %Result = $CryptObject->PrivateRemove(
        Hash    => $Keys[0]->{Hash},
        Modulus => $Keys[0]->{Modulus},
    );
    $Self->True(
        $Result{Successful} || '',
        "#$Count PrivateRemove() - $Result{Message}",
    );

    %Result = $CryptObject->CertificateRemove(
        Hash        => $Keys[0]->{Hash},
        Fingerprint => $Keys[0]->{Fingerprint},
    );

    $Self->True(
        $Result{Successful} || '',
        "#$Count CertificateRemove()",
    );

    @Keys = $CryptObject->Search( Search => $Search{$Count} );
    $Self->False(
        $Keys[0] || '',
        "#$Count Search()",
    );
}

# function to retrieve the certificate data from test files
my $GetCertificateDataFromFiles = sub {
    my ( $CertificateFileName, $PrivateKeyFileName, $PrivateSecretFileName ) = @_;

    # read certificates, private keys and secrets
    my $CertStringRef = $Self->{MainObject}->FileRead(
        Directory => $ConfigObject->Get('Home') . "/scripts/test/sample/SMIME/",
        Filename  => $CertificateFileName,
    );
    my $PrivateStringRef = $Self->{MainObject}->FileRead(
        Directory => $ConfigObject->Get('Home') . "/scripts/test/sample/SMIME/",
        Filename  => $PrivateKeyFileName,
    );
    my $PrivateSecretRef = $Self->{MainObject}->FileRead(
        Directory => $ConfigObject->Get('Home') . "/scripts/test/sample/SMIME/",
        Filename  => $PrivateSecretFileName,
    );

    # return strings instead of references
    return ( ${$CertStringRef}, ${$PrivateStringRef}, ${$PrivateSecretRef} );
};

# OpenSSL 0.9.x correct hashes
my $OTRSRootCAHash   = '1a01713f';
my $OTRSRDCAHash     = '7807c24e';
my $OTRSLabCAHash    = '2fc24258';
my $OTRSUserCertHash = 'eab039b6';

# OpenSSL 1.0.0 correct hashes
if ($UseNewHashes) {
    $OTRSRootCAHash   = '7835cf94';
    $OTRSRDCAHash     = 'b5d19fb9';
    $OTRSLabCAHash    = '19545811';
    $OTRSUserCertHash = '4d400195';
}

# create certificates table
my %Certificates;

# get data from files
my ( $CertificateString, $PrivateString, $PrivateSecret ) = $GetCertificateDataFromFiles->(
    "SMIMECACertificate-OTRSLab.crt",
    "SMIMECAPrivateKey-OTRSLab.pem",
    "SMIMECAPrivateKeyPass-OTRSLab.crt",
);

# fill certificates table
$Certificates{OTRSLabCA} = {
    Hash          => $OTRSLabCAHash,
    Fingerprint   => '28:10:65:6D:C7:FD:1B:37:BE:B5:73:44:9F:D9:C8:95:57:34:B0:A1',
    String        => $CertificateString,
    PrivateSecret => $PrivateSecret,
    PrivateHash   => $OTRSLabCAHash,
    PrivateString => $PrivateString,
};

# get data from files
( $CertificateString, $PrivateString, $PrivateSecret ) = $GetCertificateDataFromFiles->(
    "SMIMECACertificate-OTRSRD.crt",
    "SMIMECAPrivateKey-OTRSRD.pem",
    "SMIMECAPrivateKeyPass-OTRSRD.crt",
);

# fill certificates table
$Certificates{OTRSRDCA} = {
    Hash          => $OTRSRDCAHash,
    Fingerprint   => '3F:F1:41:8A:CF:39:30:53:DB:27:B0:08:3A:58:54:ED:31:D2:8A:FC',
    String        => $CertificateString,
    PrivateSecret => $PrivateSecret,
    PrivateHash   => $OTRSRDCAHash,
    PrivateString => $PrivateString,
};

# get data from files
( $CertificateString, $PrivateString, $PrivateSecret ) = $GetCertificateDataFromFiles->(
    "SMIMECACertificate-OTRSRoot.crt",
    "SMIMECAPrivateKey-OTRSRoot.pem",
    "SMIMECAPrivateKeyPass-OTRSRoot.crt",
);

# fill certificates table
$Certificates{OTRSRootCA} = {
    Hash          => $OTRSRootCAHash,
    Fingerprint   => 'BB:F7:B5:5B:52:AE:2D:4F:5A:B5:BD:E5:56:C5:D0:D9:38:3F:76:18',
    String        => $CertificateString,
    PrivateSecret => $PrivateSecret,
    PrivateHash   => $OTRSRootCAHash,
    PrivateString => $PrivateString,
};

# adding tests for smime certificate chains
{

    # get data from files
    my ( $CertificateString, $PrivateString, $PrivateSecret ) = $GetCertificateDataFromFiles->(
        "SMIMECertificate-smimeuser1.crt",
        "SMIMEPrivateKey-smimeuser1.pem",
        "SMIMEPrivateKeyPass-smimeuser1.crt",
    );

    # add certificate smimeuser1
    my %SMIMEUser1Certificate;
    %SMIMEUser1Certificate = (
        Hash          => $OTRSUserCertHash,
        Fingerprint   => 'F1:1F:83:42:14:DB:0F:FD:2E:F7:C5:84:36:8B:07:72:48:2C:C9:C0',
        String        => $CertificateString,
        PrivateSecret => $PrivateSecret,
        PrivateHash   => $OTRSUserCertHash,
        PrivateString => $PrivateString,
    );

    my %Result = $CryptObject->CertificateAdd(
        Certificate => $SMIMEUser1Certificate{String},
    );

    $SMIMEUser1Certificate{Filename} = $Result{Filename};

    %Result = $CryptObject->PrivateAdd(
        Private => $SMIMEUser1Certificate{PrivateString},
        Secret  => $SMIMEUser1Certificate{PrivateSecret},
    );

    $SMIMEUser1Certificate{PrivateFilename} = $Result{Filename};

    # sign a message with smimeuser1
    my $Message =
        'This is a signed message to sign, and verification must pass a certificate chain validation.';

    my $Sign = $CryptObject->Sign(
        Message     => $Message,
        Hash        => $SMIMEUser1Certificate{PrivateHash},
        Fingerprint => $SMIMEUser1Certificate{Fingerprint},
    );

    # verify it
    my %Data = $CryptObject->Verify( Message => $Sign, );

    # it must fail
    $Self->False(
        $Data{Successful},
        'Sign(), failed certificate chain verification, needed CA certificates not embedded',
    );

    # add CA certificates to the local cert storage (OTRSLabCA and OTRSRDCA)
    for my $Cert (qw( OTRSLabCA OTRSRDCA )) {
        $CryptObject->CertificateAdd(
            Certificate => $Certificates{$Cert}->{String},
        );
    }

    # sign a message with smimeuser1
    $Sign = $CryptObject->Sign(
        Message     => $Message,
        Hash        => $SMIMEUser1Certificate{PrivateHash},
        Fingerprint => $SMIMEUser1Certificate{Fingerprint},
    );

    # verify must fail not root cert added to the trusted cert path
    %Data = $CryptObject->Verify( Message => $Sign, );

    # it must fail
    $Self->False(
        $Data{Successful},
        'Sign(), failed certificate chain verification, not installed CA root certificate',
    );

    # add the root CA cert to the trusted certificates path
    $CryptObject->CertificateAdd(
        Certificate => $Certificates{OTRSRootCA}->{String},
    );

    # verify now must works
    %Data = $CryptObject->Verify(
        Message => $Sign,
        CACert  => "$CertPath/$OTRSRootCAHash.0",
    );

    # it must work
    $Self->True(
        $Data{Successful},
        'Verify(), successful certificate chain verification, installed CA root certificate and embedded CA certs',
    );

    # testing relations between certificates
    # fail

    # add relation
    my $Success = $CryptObject->SignerCertRelationAdd(
        CertFingerprint => 'XX:XX:XX:XX:XX:XX:XX:XX:XX:XX',
        CAFingerprint   => 'XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:',
        UserID          => 1,
    );
    $Self->False(
        $Success,
        'SignerCertRelationAdd(), fail, wrong cert fingerprint',
    );

    # get all relations for a certificate
    $Success = $CryptObject->SignerCertRelationGet(
        CertFingerprint => 'XX:XX:XX:XX:XX:XX:XX:XX:XX:XX',
    );
    $Self->False(
        $Success,
        'SignerCertRelationGet(), fail, wrong cert fingerprint',
    );

    # get one relation by ID
    $Success = $CryptObject->SignerCertRelationGet(
        ID => '9999999',
    );
    $Self->False(
        $Success,
        'SignerCertRelationGet(), fail, wrong ID',
    );

    # true cert
    # add relation
    $Success = $CryptObject->SignerCertRelationAdd(
        CertFingerprint => $SMIMEUser1Certificate{Fingerprint},
        CAFingerprint   => $Certificates{OTRSRDCA}->{Fingerprint},
        UserID          => 1,
    );
    $Self->True(
        $Success,
        'SignerCertRelationAdd(), add relation for certificate',
    );

    $Success = $CryptObject->SignerCertRelationAdd(
        CertFingerprint => $SMIMEUser1Certificate{Fingerprint},
        CAFingerprint   => $Certificates{OTRSLabCA}->{Fingerprint},
        UserID          => 1,
    );
    $Self->True(
        $Success,
        'SignerCertRelationAdd(), add relation for certificate',
    );

# sign a message after relations added not send CA certs now should be taken automatically by the sign function
    $Sign = $CryptObject->Sign(
        Message  => $Message,
        Filename => $SMIMEUser1Certificate{Filename},
    );

    # verify now must works
    %Data = $CryptObject->Verify(
        Message => $Sign,
        CACert  => "$CertPath/$OTRSRootCAHash.0",
    );

    # it must works
    $Self->True(
        $Data{Successful},
        'Sign(), successful certificate chain verification, signed using stored relations',
    );

    # get all relations for a certificate
    my @CertResults = $CryptObject->SignerCertRelationGet(
        CertFingerprint => $SMIMEUser1Certificate{Fingerprint},
    );
    $Self->Is(
        scalar @CertResults,
        2,
        'SignerCertRelationGet(), get all certificate relations',
    );

    # get one relation by ID
    $Success = $CryptObject->SignerCertRelationGet(
        ID => $CertResults[0]->{ID},
    );
    $Self->True(
        $Success,
        'SignerCertRelationGet(), get one relation by id',
    );

    # exists function
    $Success = $CryptObject->SignerCertRelationExists(
        CertFingerprint => $CertResults[0]->{CertFingerprint},
        CAFingerprint   => $CertResults[0]->{CAFingerprint},
    );
    $Self->True(
        $Success,
        'SignerCertRelationExists(), check relation by fingerprints',
    );

    $Success = $CryptObject->SignerCertRelationExists(
        ID => $CertResults[0]->{ID},
    );
    $Self->True(
        $Success,
        'SignerCertRelationExists(), check relation by ID',
    );

    # delete one relation by ID
    $CryptObject->SignerCertRelationDelete(
        ID => $CertResults[0]->{ID},
    );
    $Success = $CryptObject->SignerCertRelationExists(
        ID => $CertResults[0]->{ID},
    );
    $Self->False(
        $Success,
        'SignerCertRelationDelete(), by ID',
    );

    # delete all relations for a certificate
    $CryptObject->SignerCertRelationDelete(
        CertFingerprint => $SMIMEUser1Certificate{Fingerprint},
    );
    $Success = $CryptObject->SignerCertRelationExists(
        ID => $CertResults[1]->{ID},
    );
    $Self->False(
        $Success,
        'SignerCertRelationDelete(), delete all relations',
    );

    # delete certificates
    $CryptObject->CertificateRemove(
        Hash        => $SMIMEUser1Certificate{Hash},
        Fingerprint => $SMIMEUser1Certificate{Fingerprint},
    );

    for my $Cert ( values %Certificates ) {
        $CryptObject->CertificateRemove(
            Hash        => $Cert->{Hash},
            Fingerprint => $Cert->{Fingerprint},
        );
    }

}

# testing new features for CertificateAdd
{

    # insert certificates with same hash value
    my %CertInfo;

    # insert certificate information in a hash to compare later
    # insert first the not common cert content
    $CertInfo{'SmimeTest_0'} = {
        Serial      => '8C640B7D82967C5A',
        Fingerprint => '8F:5A:BD:42:0F:4C:19:DC:15:09:69:1F:60:62:A0:A4:7A:33:02:54',
        Modulus =>
            'A28172017D075C69600A03CFAC610FD44D348369E107DB5DA23B72D79E5F1E34583BE5E41D11203CE609AB34E6CA4F371D0D906C66693F1AAF59E8EA8D3A7756EAA73E3C0A081095191149B2AA82BCCD6918E73283A01D33641035164A9854FC9E174815E0BE90D08DED47B512B3CFCF42EEC60F3C486285A3B7E633AEC454BF',
        StartDate      => 'Feb 25 20:12:47 2011 GMT',
        EndDate        => 'Feb 25 20:12:47 2012 GMT',
        ShortStartDate => '2011-02-25',
        ShortEndDate   => '2012-02-25',
        CertString =>
            '-----BEGIN CERTIFICATE-----
MIICqzCCAhQCCQCMZAt9gpZ8WjANBgkqhkiG9w0BAQUFADCBmTELMAkGA1UEBhMC
TVgxEDAOBgNVBAgTB0phbGlzY28xFDASBgNVBAcTC0d1YWRhbGFqYXJhMQ0wCwYD
VQQKEwRPVFJTMSEwHwYDVQQLExhSZXNlYXJjaCBhbmQgRGV2ZWxvcG1lbnQxETAP
BgNVBAMTCG90cnMub3JnMR0wGwYJKoZIhvcNAQkBFg5zbWltZUB0ZXN0LmNvbTAe
Fw0xMTAyMjUyMDEyNDdaFw0xMjAyMjUyMDEyNDdaMIGZMQswCQYDVQQGEwJNWDEQ
MA4GA1UECBMHSmFsaXNjbzEUMBIGA1UEBxMLR3VhZGFsYWphcmExDTALBgNVBAoT
BE9UUlMxITAfBgNVBAsTGFJlc2VhcmNoIGFuZCBEZXZlbG9wbWVudDERMA8GA1UE
AxMIb3Rycy5vcmcxHTAbBgkqhkiG9w0BCQEWDnNtaW1lQHRlc3QuY29tMIGfMA0G
CSqGSIb3DQEBAQUAA4GNADCBiQKBgQCigXIBfQdcaWAKA8+sYQ/UTTSDaeEH212i
O3LXnl8eNFg75eQdESA85gmrNObKTzcdDZBsZmk/Gq9Z6OqNOndW6qc+PAoIEJUZ
EUmyqoK8zWkY5zKDoB0zZBA1FkqYVPyeF0gV4L6Q0I3tR7USs8/PQu7GDzxIYoWj
t+YzrsRUvwIDAQABMA0GCSqGSIb3DQEBBQUAA4GBAGr1Uhgbwf+Z/qpMwPl+ugOU
Jb0CGVc7eJtos8nTYGhg3Ws/bdENDOhf8iIhFegK1litZeQx/WAXgiCZYHClj7tD
/5vsMJVA0WSJNUZvi+MXi5VVG+gwGGgqyCvgyiU8XAaEPZY/olSIW/flv/KQA+f4
hX1v0pAMYoGlj4pLmNqp
-----END CERTIFICATE-----
',
    };
    $CertInfo{'SmimeTest_1'} = {
        Serial      => 'EBBDEED192DEF3D5',
        Fingerprint => '45:BB:21:E6:AD:9B:0A:95:52:D6:0E:C1:95:94:D6:A4:AA:1E:A8:07',
        Modulus =>
            'E0F44A17A52FF5930737244074CEE25CC8E28C65259A43F39BEFF0F600C81C8ABABB44C38B5BB2A45FABC87E00D9B51232CAE7F35E1AD13C0A0A8E87CD54D6CCF0734E3EE791544DA206AD485718DA0677EF7761DEEE0E32E8A1DC3EBCAE0ED5DA9C2B56207993319168E00621D17972687DA4C956821D2CF6A636675094E581',
        StartDate      => 'Apr  8 14:23:22 2011 GMT',
        EndDate        => 'Apr  7 14:23:22 2012 GMT',
        ShortStartDate => '2011-04-08',
        ShortEndDate   => '2012-04-07',
        CertString =>
            '-----BEGIN CERTIFICATE-----
MIICqzCCAhQCCQDrve7Rkt7z1TANBgkqhkiG9w0BAQUFADCBmTELMAkGA1UEBhMC
TVgxEDAOBgNVBAgTB0phbGlzY28xFDASBgNVBAcTC0d1YWRhbGFqYXJhMQ0wCwYD
VQQKEwRPVFJTMSEwHwYDVQQLExhSZXNlYXJjaCBhbmQgRGV2ZWxvcG1lbnQxETAP
BgNVBAMTCG90cnMub3JnMR0wGwYJKoZIhvcNAQkBFg5zbWltZUB0ZXN0LmNvbTAe
Fw0xMTA0MDgxNDIzMjJaFw0xMjA0MDcxNDIzMjJaMIGZMQswCQYDVQQGEwJNWDEQ
MA4GA1UECBMHSmFsaXNjbzEUMBIGA1UEBxMLR3VhZGFsYWphcmExDTALBgNVBAoT
BE9UUlMxITAfBgNVBAsTGFJlc2VhcmNoIGFuZCBEZXZlbG9wbWVudDERMA8GA1UE
AxMIb3Rycy5vcmcxHTAbBgkqhkiG9w0BCQEWDnNtaW1lQHRlc3QuY29tMIGfMA0G
CSqGSIb3DQEBAQUAA4GNADCBiQKBgQDg9EoXpS/1kwc3JEB0zuJcyOKMZSWaQ/Ob
7/D2AMgcirq7RMOLW7KkX6vIfgDZtRIyyufzXhrRPAoKjofNVNbM8HNOPueRVE2i
Bq1IVxjaBnfvd2He7g4y6KHcPryuDtXanCtWIHmTMZFo4AYh0XlyaH2kyVaCHSz2
pjZnUJTlgQIDAQABMA0GCSqGSIb3DQEBBQUAA4GBALtZQpsB1UA3WtfHl7qoVM3d
X/umav+OgOsBHZKH4UV1CgLmgDz9i8kVy2yEKL/QgCE/aPjSOf46TSKQX4pQy/2w
sc8WqMKf2rOWj65HEarZnVMzTIErm14HJzJljkQg0gdR8ph4gFIscIfO9csLd8ud
BLrMsW3mKPx9cPinBGIH
-----END CERTIFICATE-----
',
    };
    $CertInfo{'SmimeTest_2'} = {
        Serial      => '92AC1D548E1ACAD9',
        Fingerprint => '7E:63:F2:63:65:80:BB:8E:EB:B7:A8:6A:5C:2C:58:C0:6F:EA:F8:37',
        Modulus =>
            'C93D9FEA0914DBF689B1D11E69A7D059ABA12AF3D39415E18837A29F6EF018ECF89105BA50838C7298636B7B055DDCD898E10C78357902F381423A32D0974CF5CE8A3593CBEA0DBC902AE994DEFF2B131A4E0A03FA59E445EF08D31CA854EE2BDF01F039C27119ED8AE2CB8A54040D54EC20BB502B13D9A2D41808BFD2CBC62F',
        StartDate      => 'May 10 16:18:07 2011 GMT',
        EndDate        => 'May  9 16:18:07 2012 GMT',
        ShortStartDate => '2011-05-10',
        ShortEndDate   => '2011-05-09',
        CertString =>
            '-----BEGIN CERTIFICATE-----
MIICqzCCAhQCCQCSrB1UjhrK2TANBgkqhkiG9w0BAQUFADCBmTELMAkGA1UEBhMC
TVgxEDAOBgNVBAgTB0phbGlzY28xFDASBgNVBAcTC0d1YWRhbGFqYXJhMQ0wCwYD
VQQKEwRPVFJTMSEwHwYDVQQLExhSZXNlYXJjaCBhbmQgRGV2ZWxvcG1lbnQxETAP
BgNVBAMTCG90cnMub3JnMR0wGwYJKoZIhvcNAQkBFg5zbWltZUB0ZXN0LmNvbTAe
Fw0xMTA1MTAxNjE4MDdaFw0xMjA1MDkxNjE4MDdaMIGZMQswCQYDVQQGEwJNWDEQ
MA4GA1UECBMHSmFsaXNjbzEUMBIGA1UEBxMLR3VhZGFsYWphcmExDTALBgNVBAoT
BE9UUlMxITAfBgNVBAsTGFJlc2VhcmNoIGFuZCBEZXZlbG9wbWVudDERMA8GA1UE
AxMIb3Rycy5vcmcxHTAbBgkqhkiG9w0BCQEWDnNtaW1lQHRlc3QuY29tMIGfMA0G
CSqGSIb3DQEBAQUAA4GNADCBiQKBgQDJPZ/qCRTb9omx0R5pp9BZq6Eq89OUFeGI
N6KfbvAY7PiRBbpQg4xymGNrewVd3NiY4Qx4NXkC84FCOjLQl0z1zoo1k8vqDbyQ
KumU3v8rExpOCgP6WeRF7wjTHKhU7ivfAfA5wnEZ7Yriy4pUBA1U7CC7UCsT2aLU
GAi/0svGLwIDAQABMA0GCSqGSIb3DQEBBQUAA4GBAAU2T96dFsU3ScksB7yDQ29H
rf34bF5GIoBmFoTTjjlP0qlON3ksk7q5fwqv2gQAcLpsyKivngX4ykQVUfBt4WMv
XFvmf5o761D/LVa7affvUbMMeqpBMOizONfxWGhm0BuMkbM72OyK0UNyMLTkeNLc
PHquavB33QpjlKE/X01O
-----END CERTIFICATE-----
',
    };
    $CertInfo{'SmimeTest_3'} = {
        Serial      => '94791BB083403427',
        Fingerprint => '8D:57:A4:EA:90:B2:CF:2A:80:40:9A:06:B1:EC:A9:14:02:91:46:BF',
        Modulus =>
            'A57D1A863BFAC706576464E9DAC3AEDAF83FC3EB2E830EC9399D5A2D2187D74ABC192F97942FB457F0E7563F9E2F926DC3A0A6D4C281766DE698485D4C8EEF213954F810F78195DA244B3754E84A9B55F20796937F19BB9EA3E10210E7F610E030061413DD0565A1D6E8D9726641EF11073FECBAF2A78172F2DBB86944D324AD',
        StartDate      => 'May 10 16:24:37 2011 GMT',
        EndDate        => 'May  9 16:24:37 2012 GMT',
        ShortStartDate => '2011-05-10',
        ShortEndDate   => '2011-05-09',
        CertString =>
            '-----BEGIN CERTIFICATE-----
MIICqzCCAhQCCQCUeRuwg0A0JzANBgkqhkiG9w0BAQUFADCBmTELMAkGA1UEBhMC
TVgxEDAOBgNVBAgTB0phbGlzY28xFDASBgNVBAcTC0d1YWRhbGFqYXJhMQ0wCwYD
VQQKEwRPVFJTMSEwHwYDVQQLExhSZXNlYXJjaCBhbmQgRGV2ZWxvcG1lbnQxETAP
BgNVBAMTCG90cnMub3JnMR0wGwYJKoZIhvcNAQkBFg5zbWltZUB0ZXN0LmNvbTAe
Fw0xMTA1MTAxNjI0MzdaFw0xMjA1MDkxNjI0MzdaMIGZMQswCQYDVQQGEwJNWDEQ
MA4GA1UECBMHSmFsaXNjbzEUMBIGA1UEBxMLR3VhZGFsYWphcmExDTALBgNVBAoT
BE9UUlMxITAfBgNVBAsTGFJlc2VhcmNoIGFuZCBEZXZlbG9wbWVudDERMA8GA1UE
AxMIb3Rycy5vcmcxHTAbBgkqhkiG9w0BCQEWDnNtaW1lQHRlc3QuY29tMIGfMA0G
CSqGSIb3DQEBAQUAA4GNADCBiQKBgQClfRqGO/rHBldkZOnaw67a+D/D6y6DDsk5
nVotIYfXSrwZL5eUL7RX8OdWP54vkm3DoKbUwoF2beaYSF1Mju8hOVT4EPeBldok
SzdU6EqbVfIHlpN/Gbueo+ECEOf2EOAwBhQT3QVlodbo2XJmQe8RBz/suvKngXLy
27hpRNMkrQIDAQABMA0GCSqGSIb3DQEBBQUAA4GBAHMzv3AdAdg3bo9EjdiRdUmu
y/lGMs8Q/9vyOlCM8NxdvjrjB0T6r67Nhjp9pRzy9GAdeCXvkKjH3fYa0O6H98v5
2ZUGDxkv+qL4Wb9MwQsm1DmAEzhExMIEL90GhiBO1OUzRsr0AOyYjSVejXf//Igg
xqdO7PfndBF8qwrJ7S91
-----END CERTIFICATE-----
',
    };

    # 0.9.x hash
    my $CommonHash = 'b93941b5';

    # 1.0.0 hash
    if ($UseNewHashes) {
        $CommonHash = '9d993e95';
    }

    for my $Number ( 0 .. 3 ) {

        # insert the common content
        $CertInfo{ 'SmimeTest_' . $Number }->{Subject} =
            'C= MX ST= Jalisco L= Guadalajara O= OTRS OU= Research and Development CN= otrs.org emailAddress= smime@test.com';
        $CertInfo{ 'SmimeTest_' . $Number }->{Hash}    = $CommonHash;
        $CertInfo{ 'SmimeTest_' . $Number }->{Private} = 'No';
        $CertInfo{ 'SmimeTest_' . $Number }->{Type}    = 'cert';
        $CertInfo{ 'SmimeTest_' . $Number }->{Issuer} =
            'C= MX/ST= Jalisco/L= Guadalajara/O= OTRS/OU= Research and Development/CN= otrs.org/emailAddress= smime@test.com';
        $CertInfo{ 'SmimeTest_' . $Number }->{Email} = 'smime@test.com';

        # add every SmimeTest_N certificate
        my %Result = $CryptObject->CertificateAdd(
            Certificate => $CertInfo{ 'SmimeTest_' . $Number }->{CertString}
        );

        $Self->True(
            $Result{Successful},
            "# SmimeTest_$Number.crt - CertificateAdd(), certificates with duplicate hash - $Result{Message}",
        );

        $CertInfo{ 'SmimeTest_' . $Number }->{Filename} = $Result{Filename} || '';

        my @Result = $CryptObject->CertificateSearch(
            Search => 'smime@test.com',
        );

        $Self->Is(
            ( scalar @Result ),
            ( $Number + 1 ),
            '# Testing the addition, no overwriting other certs with same hash',
        );

        my $CertificateString = $CryptObject->CertificateGet(
            Filename => $Result{Filename},
        );

        $Self->Is(
            $CertificateString,
            $CertInfo{ 'SmimeTest_' . $Number }->{CertString},
            '# CertificateGet(), by filename',
        );

        $CertificateString = $CryptObject->CertificateGet(
            Hash        => $CertInfo{ 'SmimeTest_' . $Number }->{Hash},
            Fingerprint => $CertInfo{ 'SmimeTest_' . $Number }->{Fingerprint},
        );

        $Self->Is(
            $CertificateString,
            $CertInfo{ 'SmimeTest_' . $Number }->{CertString},
            '# CertificateGet(), by hash/fingerprint',
        );
    }

    # working with privates
    # add private

    my %Private;
    $Private{SmimeTest_0} = {
        CertString => '-----BEGIN RSA PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: DES-EDE3-CBC,41DF8969735B2C68

STE29gngpyNuoEuQGLNEQKhSkpLk+No4nuyOK0kuzC1pOzEanqLGo9v5Aee9Yqvf
3zuneRmUUePalh4B+0X3Kt1MgnvELhxVTBWqKLq3VKNnSg5br90a9M/AA2mW90T8
CeGgUDS36pw+pswYkEMZT3kUMOsRjYjz4Y7Yp+nm1WwtqEbfplbzG8gvfO29LLpN
dq5KoYU5kIwgHHzph1foswVjSy0XKYnMYXMY4Yrp10zdF/diOH/6j4YBOv6AQIwL
lMCmja8URbrXSOKYFZb+Ghda6rkJkuuno87e6WM9dCO2fELyMIS50jat5g4SriUE
VNvW+R3Z9L5Lf+uc67x8JJw+rQRagMhNZ37xH3qDbWiiWdnlbGp/HbaIlcSKJ+zA
bcT1EFtJIXXTq7Mg/6npLeRN0Whc6ogn0Wm6nZbjy58eXFx49nn/WXPVx7cnsIiD
4bb5AmltFPU/q+qFFayFtfrw6AIEaRdhFpX4sjUum+WNq2cf5t8R9GttN92VkAAf
OmlaI5bgSkFa+YwFr8kZkugYDEzJ9eof78n2K3YKJXp5o3++Qrl9+q/rI6nCpHXV
fcZPEpAsK1py6Vab+LYjKqUdciTj131Dz3UizjoUF1csGv8qpnlR5eqARzb5vhOY
qjD4PlLuP28vcC22VciW/Zjw5ybaGHF/PLW0Yh5QzJRlW6JpiVjmLbXniY4dv3eG
iyeQzaId1Uf+WL6Xt2XsBv4igGO4sEgee1nJX01pg7RkkhM+c9SnktR6OPAvuGnh
VXFf9uJZzQlCWrp3d/UyzA1An5cjiXuPThvJqV9accP/YS8InoL9KA==
-----END RSA PRIVATE KEY-----',
    };
    $Private{SmimeTest_1} = {
        CertString => '-----BEGIN RSA PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: DES-EDE3-CBC,65D18B149F5BF8FC

g0d8L+u8iVCbxKnKy31QZosXrJrNY5xinR1hfEdkuN9KXNRYFuP+zgKxpX3dXKPN
iJYppfQ1qETOPMIz/Rbsm6gvfJU+LRgTjYB2Lc3fdnrMsTewH2grwiTPOOM5upVe
5bTzo0964qwwsKdehAb3UIXlY6sw3F++Jx0A8nNUpECki8w/WZuBGdpBzXIDOTyk
Qmg+T9GZhv5odmlbmAE79TC1ynXXB9FR5AbYxxWiNTh23BPi5fPs042d6afDDj8C
NAxJvULOApQpYiMwLG1Z7fhiXdYpAMLzQeZYuQl6JuiLMLgHwBV2VHh2jw2Z2OQq
4fDaN6cArKNJ380k2OgElH77XLPY5om22CTYlkIHdNFpZBhHi9OjgZnmwDUIZ4ld
V1XLZh0frxEabwoSJag1BWWhJqU/bMgcttt2fnXQx9hby3aJqPVyEzRP/FSGaWf9
Og8KOECBqTuY5G5yM6erJQNEuiAGu8ZQpT51N5oHk74+OjJYTnDZmn2IQZvz8/g8
pRvELzhHmpERmbYPVJwio121gH+fKAD+AvxvXLB6ZyUeEySjyEfXUzFc2mS59nKS
kZGfdNnzNpnq2IOf7zYXXPH8kUz/nppw+LchFwjYHapgjC5U434vBa2VG/Ln+YGS
6XJnjzdJtDh8ATmD/lBH5bJLkuaeiW+2+7PL9Hk4idzE6LeL1i+P9DupIfegfRS3
H2qt6l1rbBmTDUnSkqKXap1VPURmbh2/xn062plVQ+lAQNDFQKcPXpYsmJrKsF0O
eQnDsF9Lh7LTm6eKYcMkms1EEUvjHbNzIuOaG5Vo5pgJD+f7CqR6xQ==
-----END RSA PRIVATE KEY-----',
    };
    $Private{SmimeTest_2} = {
        CertString => '-----BEGIN RSA PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: DES-EDE3-CBC,12B5DE96A0F259F6

euFPqBOVa5lzjF1/BGSDzeBBL+YLRrEidHq7mzGffPy0c7YZMJrohcIg/QekioYQ
LXFuNhUvQ1Jw29oDOcjwimG81HOefZjo4ofk7GAqmcg10hA79n54tAXatC6DcgVO
4SxK26bTyXuXs7UCWqOO93izVUTqoTLpfQiDK35GW9jaLLXqHtfG0WlGobq7VyfG
lMo+3/Q7psyrJYn1N65aQGFtPnMf6/5vq3FFENjl4X+ulBerb7VYKl+a4AJv67rp
h/1MT+JMxLuukLZgveIYzgU5h4xn6EUjqJ/wQ1NvdL9WTmr7TOLtQIyWx4GNf+GN
ssec5nacjz10XCWDQSTyxoB2WkIbXAHWK77/kYXww75QmCV6cNsyrCn/9m3ND3hi
enreXaL6l4H7HOWwiSjf7oFs1XCWpn7H4sorgulGWxUEHORl6I36wb8ilLpa4NIj
YaFrrGh+h472ZgKvVHfX/I77vyLrYAeVZD416qpuoZPO6LrKj4pMED9saegn5iPN
a6k2smWVaPe1Z1vFbynxLOJi/OBBRxCyUUVrNd8MOccU8e1vaP8c4QAiyc9EtTx4
BaOwC10gQZgSa0hopMT1p5l6cHXbEY9+S8Qcrpq+8JoPfN4B6N/MecQ2EYzX0R2H
RfG20fFWOdDylLQew7OukmiCluY1mXEr56e26DU0o9hkJw1BkbB40kSO02zkhwy/
XAydFSgfQxly2GWwnzhy/MBoETNy/3Sr0TTg1QTioeCsRtCkKvQ8NqAN1DEBUyqd
d0/4/ghNIYjPUweuQr+UuVxKuKBCLmnQRPBCk3WFagY=
-----END RSA PRIVATE KEY-----',
    };
    $Private{SmimeTest_3} = {
        CertString => '-----BEGIN RSA PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: DES-EDE3-CBC,BF96FF804B2B5B68

twu71c7Ug0UaiAfc64vKbJ3g5Xoq74dZ/zumiSWk6qDXvkb4irl2fe/YoQVoJcEZ
RQb0lCfi4GprcRRNa59BCFlOilTvI+xPpqL2wCNX8U8PuTahG/orVGxjK5wZZXWC
gwt4nsJ4lRIJk2ggrYMJq6qpE548D4c/6EvcO29069vVajEakkkwpmc24V9Bc4nj
7yPuRwPWc/6oWbT/5G6AYnGYeC3E3D7YXiVLvWW9qCk8UhNMXNvzSXrzqszOkA0I
iQH/OM5VW7myBCdRzWm0yByJxK8D8L5J7kPkkJsDrt/lsB9MZcIZsLG7cNqYpWHJ
H+OLSmTGTNxpC3LAk/HJZRznOikbUJXyBE30kswWP6VtYH0aISJ5FRiSvmkb5IMu
aNYhVfOhTul9xrhSICZ25ZKaB+ogG8ihiwIoqnzFUaS8uOnLNg2J/L5FYp2tV7PP
MCYgR5uzjDdqJ3AG9x05Dd1bIMs/he0ZkPY+RcyhHGDzndlzppjvQfq2w37HLCV8
mdoutGlm+q3AXd2mOa6J4yhNcmDjGV2ETg+fmKRtFG3I/GGzvFy0mF4dHGy9fegl
ZxwJTZoIST0i34OhzgjzB3YQtMGKuvYgYBKsRxNRjLcqy6hCS3N3RKX5g1hUQwih
gIvXzDO84PIhTB6iHfBlPTf7bUzJAGm5J2cHL/W0JyKWmdiRK8ei+BNGH6WvdFKy
VvHrdzP1tlEqZhMhfEgiNYVhYaxg6SaKSVY9GlGmMVrL2rUNIJ5I+Ef0lZh842bF
0w07C53r3xsbkSL6m0dU3Z0O7ax2wcCLAA0mA5JfqsMdn59ACA9aEw==
-----END RSA PRIVATE KEY-----',
    };

    my $OriginalPrivateListCount = $CryptObject->PrivateList();

    # test privates
    for my $Number ( 0 .. 3 ) {
        my %Result = $CryptObject->PrivateAdd(
            Private => $Private{ 'SmimeTest_' . $Number }->{CertString},
            Secret  => 'smime',
        );

        $Private{ 'SmimeTest_' . $Number }->{Filename} = $Result{Filename} || '';

        # added
        $Self->True(
            $Result{Successful} || '',
            'PrivateAdd() - private certs with same hash'
        );

        $Self->Is(
            $Private{ 'SmimeTest_' . $Number }->{Filename},
            $CertInfo{ 'SmimeTest_' . $Number }->{Filename},
            "# Cert and private key has the same filename: $Private{'SmimeTest_'.$Number}->{Filename}",
        );

        # is overwriting one each other?
        my @Result       = $CryptObject->PrivateSearch( Search => 'smime@test.com', );
        my $Counter      = $Number + 1;
        my $ResultNumber = scalar @Result;
        $Self->Is(
            $ResultNumber,
            $Counter,
            '# Added private without overwriting others with same hash',
        );

        # is linked to the correct certificate? - ADD TEST

        @Result       = $CryptObject->PrivateList();
        $ResultNumber = scalar @Result;
        $Self->Is(
            $ResultNumber,
            $Counter + $OriginalPrivateListCount,
            "# private list must be return also $Counter",
        );
    }

    # delete certificates
    for my $Number ( 0 .. 1 ) {

        # delete certificates
        my %Result = $CryptObject->CertificateRemove(
            Hash        => $CertInfo{ 'SmimeTest_' . $Number }->{Hash},
            Fingerprint => $CertInfo{ 'SmimeTest_' . $Number }->{Fingerprint},
        );

        $Self->True(
            $Result{Successful},
            "# CertificateRemove() by Hash/Fingerprint, $Result{Message}",
        );

        my @Result = $CryptObject->CertificateSearch(
            Search => $CertInfo{ 'SmimeTest_' . $Number }->{Fingerprint}
        );
        $Self->False(
            ( scalar @Result ),
            "# CertificateSearch(), certificate not found, successfuly deleted",
        );
    }

    for my $Number ( 2 .. 3 ) {

        # delete certificate 2, must delete its corresponding private
        my %Result = $CryptObject->CertificateRemove(
            Hash        => $CertInfo{ 'SmimeTest_' . $Number }->{Hash},
            Fingerprint => $CertInfo{ 'SmimeTest_' . $Number }->{Fingerprint},
        );

        $Self->True(
            $Result{Successful},
            "# CertificateRemove() by filename, $Result{Message}",
        );

        # private must be deleted
        my ($PrivateExists) = $CryptObject->PrivateGet(
            Filename => $Private{ 'SmimeTest_' . $Number }->{Filename},
        );

        $Self->False(
            $PrivateExists,
            '# Private was correctly removed on certificate remove',
        );
    }

    # private secret normalization tests
    {

        # function to reuse
        my $CreateWrongPrivateSecretFile = sub {
            my (
                $WrongPrivateSecretFile, $WrongPrivateSecretFileContent,
                $WrongPrivateSecretFileLocation
            ) = @_;

            # create a new private secret file with the wrong name
            my $FileLocation = $MainObject->FileWrite(
                Location => $WrongPrivateSecretFileLocation,
                Content  => \$WrongPrivateSecretFileContent,
            );

            # sanity checks
            $Self->Is(
                $FileLocation,
                $WrongPrivateSecretFileLocation,
                "NormalizePrivateSecret: Created wrong private secret filename:"
                    . " $WrongPrivateSecretFile with wrong name",
            );

            my $FileExists;
            if ( -e $WrongPrivateSecretFileLocation ) {
                $FileExists = 1;
            }

            $Self->True(
                $FileExists,
                "NormalizePrivateSecret: Wrong private secret filename: $WrongPrivateSecretFile"
                    . " exists with true (before normalize)",
            );

            my $ContentSCALARRef = $MainObject->FileRead(
                Location => $WrongPrivateSecretFileLocation,
            );

            $Self->Is(
                $$ContentSCALARRef,
                $WrongPrivateSecretFileContent,
                "NormalizePrivateSecret: Read wrong private secret filename:"
                    . " $WrongPrivateSecretFile content",
            );
        };

        my $PrivateKeyHash                 = 'aaaaaaaa';
        my $PrivateKeyFile                 = "$PrivateKeyHash.7";
        my $PrivateKeyFileContent          = 'does not matter fot this test';
        my $PrivateKeyFileLocation         = "$PrivatePath/$PrivateKeyFile";
        my $WrongPrivateSecretFile         = "$PrivateKeyHash.P";
        my $WrongPrivateSecretFileContent  = 'Secret';
        my $WrongPrivateSecretFileLocation = "$PrivatePath/$WrongPrivateSecretFile";

        # create the private key file otherwize test will always fail
        my $FileLocation = $MainObject->FileWrite(
            Location => $PrivateKeyFileLocation,
            Content  => \$PrivateKeyFileContent,
        );

        # sanity checks
        $Self->Is(
            $FileLocation,
            $PrivateKeyFileLocation,
            "NormalizePrivateSecret: Created private key filename: $PrivateKeyFile",
        );

        $Self->True(
            1,
            "----Normaize Private Secrets wrong private secret filename----"
        );

        # create a new private secret file with a wrong name format
        $CreateWrongPrivateSecretFile->(
            $WrongPrivateSecretFile, $WrongPrivateSecretFileContent, $WrongPrivateSecretFileLocation
        );

        my $CorrectPrivateSecretFile         = "$PrivateKeyFile.P";
        my $CorrectPrivateSecretFileLocation = "$PrivatePath/$CorrectPrivateSecretFile";

        my $FileExists;

        # the correct file does not exist at this time
        if ( -e $CorrectPrivateSecretFileLocation ) {
            $FileExists = 1;
        }

        $Self->False(
            $FileExists,
            "NormalizePrivateSecret: Correct private secret filename: $CorrectPrivateSecretFile"
                . " exists with false (before normalize)",
        );
        $FileExists = 0;

        # normalize private secret
        my $Response = $CryptObject->CheckCertPath();
        $Self->True(
            $Response->{Success},
            "NormalizePrivateSecret: CheckCertPath() executed successfully with true",
        );

        # output details if process was not successful
        if ( !$Response->{Success} ) {
            $Self->True(
                0,
                $Response->{Details},
            );
        }

        # by this time after the normalization the file should not exsist
        if ( -e $WrongPrivateSecretFileLocation ) {
            $FileExists = 1;
        }

        $Self->False(
            $FileExists,
            "NormalizePrivateSecret: Wrong private secret filename:"
                . " $WrongPrivateSecretFile exists with false (after normalize)",
        );
        $FileExists = 0;

        # the file shoud be renamed to the correct format at this point
        if ( -e $CorrectPrivateSecretFileLocation ) {
            $FileExists = 1;
        }

        $Self->True(
            $FileExists,
            "NormalizePrivateSecret: Wrong private secret filename: $CorrectPrivateSecretFile exists"
                . " with true (after normalize)",
        );
        $FileExists = 0;

        # leave the correct private secret file for the next test
        $Self->True(
            1,
            "----Normaize Private Secret duplicated files with same content----"
        );

        # create a new private secret file with a wrong name format
        $CreateWrongPrivateSecretFile->(
            $WrongPrivateSecretFile, $WrongPrivateSecretFileContent, $WrongPrivateSecretFileLocation
        );

        # get the content od the wrong and the correct private secret files
        my $WrongPrivateSecretContent = $MainObject->FileRead(
            Location => $WrongPrivateSecretFileLocation,
        );

        my $CorrectPrivateSecretContent = $MainObject->FileRead(
            Location => $CorrectPrivateSecretFileLocation,
        );

        $Self->Is(
            $$WrongPrivateSecretContent,
            $$CorrectPrivateSecretContent,
            "NormalizePrivateSecret: $WrongPrivateSecretFile and $CorrectPrivateSecretFile has"
                . " same content",
        );

        # normalize private secrets
        $Response = $CryptObject->CheckCertPath();
        $Self->True(
            $Response->{Success},
            "NormalizePrivateSecret: CheckCertPath() executed successfully with true",
        );

        # output details if process was not successful
        if ( !$Response->{Success} ) {
            $Self->True(
                0,
                $Response->{Details},
            );
        }

        # by this time after the normalization the file should not exsist (since contents are equal)
        if ( -e $WrongPrivateSecretFileLocation ) {
            $FileExists = 1;
        }

        $Self->False(
            $FileExists,
            "NormalizePrivateSecret: Wrong private secret filename: $WrongPrivateSecretFile exists"
                . " with false (after normalize duplicate file same content)",
        );
        $FileExists = 0;

        # the file shoud be renamed to the correct format at this point
        if ( -e $CorrectPrivateSecretFileLocation ) {
            $FileExists = 1;
        }

        $Self->True(
            $FileExists,
            "NormalizePrivateSecret: Correct private secret filename: $CorrectPrivateSecretFile"
                . " exists with true (after normalize duplicate file same content)",
        );
        $FileExists = 0;

        # leave the correct file again but modify its content this will cause that both file exists
        # at the end
        $Self->True(
            1,
            "----Normaize Private Secret duplicated files with diferent content----"
        );

        # change the content of the correct private secret file
        $FileLocation = $MainObject->FileWrite(
            Location => $CorrectPrivateSecretFileLocation,
            Content  => \'Not so secret',
        );

        # create a new private secret file with a wrong name format
        $CreateWrongPrivateSecretFile->(
            $WrongPrivateSecretFile, $WrongPrivateSecretFileContent, $WrongPrivateSecretFileLocation
        );

        # get the content od the wrong and the correct private secret files
        $WrongPrivateSecretContent = $MainObject->FileRead(
            Location => $WrongPrivateSecretFileLocation,
        );

        $CorrectPrivateSecretContent = $MainObject->FileRead(
            Location => $CorrectPrivateSecretFileLocation,
        );

        $Self->IsNot(
            $$WrongPrivateSecretContent,
            $$CorrectPrivateSecretContent,
            "NormalizePrivateSecret: $WrongPrivateSecretFile and $CorrectPrivateSecretFile has"
                . " different content",
        );

        # normalize private secrets
        $Response = $CryptObject->CheckCertPath();
        $Self->True(
            $Response->{Success},
            "NormalizePrivateSecret: CheckCertPath() executed successfully with true",
        );

        # output details if process was not successfull
        if ( !$Response->{Success} ) {
            $Self->True(
                0,
                $Response->{Details},
            );
        }

        # by this time after the normalization the file should stil exists
        # (since contents are diferent)
        if ( -e $WrongPrivateSecretFileLocation ) {
            $FileExists = 1;
        }

        $Self->True(
            $FileExists,
            "NormalizePrivateSecret: Wrong private secret filename: $WrongPrivateSecretFile exists"
                . " with true (after normalize duplicate file diferent content)",
        );
        $FileExists = 0;

        # the corret private secret file still exists
        if ( -e $CorrectPrivateSecretFileLocation ) {
            $FileExists = 1;
        }

        $Self->True(
            $FileExists,
            "NormalizePrivateSecret: Correct private secret filename: $CorrectPrivateSecretFile"
                . " exists with true (after normalize duplicate file same content)",
        );
        $FileExists = 0;

        # remove files from file system
        my $FileDeleteSuccess = $MainObject->FileDelete(
            Location => $WrongPrivateSecretFileLocation,
        );
        $Self->True(
            $FileDeleteSuccess,
            "NormalizePrivateSecret: Remove wrong private secret filename: $WrongPrivateSecretFile"
                . " with true",
        );
        $FileDeleteSuccess = $MainObject->FileDelete(
            Location => $CorrectPrivateSecretFileLocation,
        );
        $Self->True(
            $FileDeleteSuccess,
            "NormalizePrivateSecret: Remove correct private secret filename:"
                . " $WrongPrivateSecretFile with true",
        );
        $FileDeleteSuccess = $MainObject->FileDelete(
            Location => $PrivateKeyFileLocation,
        );
        $Self->True(
            $FileDeleteSuccess,
            "NormalizePrivateSecret: Remove private key filename: $PrivateKeyFile with true",
        );
    }

    # re-hash tests
    {

        # add CA certifictes manually, otherwise the correct hash will be calculated for the name
        # create wrong file function
        my $CreateWrongCAFiles = sub {
            my (
                $CAName,
                $WrongCAFile,
                $WrongCAFileContent,
                $WrongCAPrivateKeyFileContent,
                $WrongCAPrivateSecretFileContent,
                $UsePrivateKeys,
                $UsePrivateSecrets,
                $TestName,
            ) = @_;

            my $WrongCAFileLocation              = "$CertPath/$WrongCAFile";
            my $WrongCAPrivateKeyFile            = $WrongCAFile;
            my $WrongCAPrivateKeyFileLocation    = "$PrivatePath/$WrongCAPrivateKeyFile";
            my $WrongCAPrivateSecretFile         = "$WrongCAPrivateKeyFile.P";
            my $WrongCAPrivateSecretFileLocation = "$WrongCAPrivateKeyFileLocation.P";

            # create new CA certificate with wrong name
            my $FileLocation = $MainObject->FileWrite(
                Location => $WrongCAFileLocation,
                Content  => \$WrongCAFileContent,
            );

            # sanity checks
            my $FileExists;
            if ( -e $WrongCAFileLocation ) {
                $FileExists = 1;
            }

            $Self->True(
                $FileExists,
                "Re-Hash $TestName: Wrong CA $CAName filename: $WrongCAFile exists with true"
                    . " (before re-hash)",
            );
            $FileExists = 0;

            my $ContentSCALARRef = $MainObject->FileRead(
                Location => $WrongCAFileLocation,
            );

            $Self->Is(
                $$ContentSCALARRef,
                $WrongCAFileContent,
                "Re-Hash $TestName: Read wrong CA $CAName filename: $WrongCAFile content",
            );

            if ($UsePrivateKeys) {

                # create new private key with wrong CA certificate name
                $FileLocation = $MainObject->FileWrite(
                    Location => $WrongCAPrivateKeyFileLocation,
                    Content  => \$WrongCAPrivateKeyFileContent,
                );

                # sanity checks
                if ( -e $WrongCAPrivateKeyFileLocation ) {
                    $FileExists = 1;
                }

                $Self->True(
                    $FileExists,
                    "Re-Hash $TestName: Wrong CA $CAName private key filename:"
                        . " $WrongCAPrivateKeyFile exists with true (before re-hash)",
                );
                $FileExists = 0;

                $ContentSCALARRef = $MainObject->FileRead(
                    Location => $WrongCAPrivateKeyFileLocation,
                );

                $Self->Is(
                    $$ContentSCALARRef,
                    $WrongCAPrivateKeyFileContent,
                    "Re-Hash $TestName: Read wrong CA $CAName private key filename:"
                        . " $WrongCAPrivateKeyFile content",
                );
            }

            if ($UsePrivateSecrets) {

                # create new private secret file for wrong CA certificate
                $FileLocation = $MainObject->FileWrite(
                    Location => $WrongCAPrivateSecretFileLocation,
                    Content  => \$WrongCAPrivateSecretFileContent,
                );

                if ( -e $WrongCAPrivateSecretFileLocation ) {
                    $FileExists = 1;
                }

                $Self->True(
                    $FileExists,
                    "Re-Hash $TestName: Wrong CA $CAName private secret filename:"
                        . " $WrongCAPrivateSecretFile exists with true (before re-hash)",
                );
                $FileExists = 0;

                $ContentSCALARRef = $MainObject->FileRead(
                    Location => $WrongCAPrivateSecretFileLocation,
                );

                $Self->Is(
                    $$ContentSCALARRef,
                    $WrongCAPrivateSecretFileContent,
                    "Re-Hash $TestName: Read wrong CA $CAName private secret filename:"
                        . " $WrongCAPrivateSecretFile content",
                );
            }
        };

        # check correct files function
        my $CheckCorrectCAFiles = sub {
            my (
                $CAName,
                $WrongCAFile,
                $CorrectCAFile,
                $CorrectCAFileContent,
                $CorrectCAPrivateKeyContent,
                $CorrectCAPrivateSecretFileContent,
                $UsePrivateKeys,
                $UsePrivateSecrets,
                $TestName,
            ) = @_;

            my $WrongCAFileLocation              = "$CertPath/$WrongCAFile";
            my $WrongCAPrivateKeyFile            = $WrongCAFile;
            my $WrongCAPrivateKeyFileLocation    = "$PrivatePath/$WrongCAPrivateKeyFile";
            my $WrongCAPrivateSecretFile         = "$WrongCAPrivateKeyFile.P";
            my $WrongCAPrivateSecretFileLocation = "$WrongCAPrivateKeyFileLocation.P";

            my $CorrectCAFileLocation              = "$CertPath/$CorrectCAFile";
            my $CorrectCAPrivateKeyFile            = $CorrectCAFile;
            my $CorrectCAPrivateKeyFileLocation    = "$PrivatePath/$CorrectCAPrivateKeyFile";
            my $CorrectCAPrivateSecretFile         = "$CorrectCAPrivateKeyFile.P";
            my $CorrectCAPrivateSecretFileLocation = "$CorrectCAPrivateKeyFileLocation.P";

            # check if wrong CA cetificates, private keys and secrets exists
            {
                my $FileExists;
                if ( -e $WrongCAFileLocation ) {
                    $FileExists = 1;
                }
                $Self->False(
                    $FileExists,
                    "Re-Hash $TestName: Wrong CA $CAName certificate filename: $WrongCAFile"
                        . " File exists with false (after re-hash)",
                );
            }
            if ($UsePrivateKeys) {
                my $FileExists;
                if ( -e $WrongCAPrivateKeyFileLocation ) {
                    $FileExists = 1;
                }
                $Self->False(
                    $FileExists,
                    "Re-Hash $TestName: Wrong CA $CAName private key filename:"
                        . " $WrongCAPrivateKeyFile File exists with false (after re-hash)",
                );
            }
            if ( $UsePrivateSecrets && !$UsePrivateKeys ) {
                my $FileExists;
                if ( -e $WrongCAPrivateSecretFileLocation ) {
                    $FileExists = 1;
                }
                $Self->True(
                    $FileExists,
                    "Re-Hash $TestName: Wrong CA $CAName private secret filename:"
                        . " $WrongCAPrivateSecretFile File exists with true (after re-hash)"
                        . " there was no private key",
                );
            }

            # check if crorrect CA certificates, private keys and secrets exists
            {
                my $FileExists;
                if ( -e $CorrectCAFileLocation ) {
                    $FileExists = 1;
                }
                $Self->True(
                    $FileExists,
                    "Re-Hash $TestName: Correct CA $CAName certificate filename: $CorrectCAFile"
                        . " File exists with true (after re-hash)",
                );
            }
            if ($UsePrivateKeys) {
                my $FileExists;
                if ( -e $CorrectCAPrivateKeyFileLocation ) {
                    $FileExists = 1;
                }
                $Self->True(
                    $FileExists,
                    "Re-Hash $TestName: Correct CA $CAName private key filename:"
                        . " $CorrectCAPrivateKeyFile File exists with true (after re-hash)",
                );
            }
            if ( $UsePrivateSecrets && !$UsePrivateKeys ) {
                my $FileExists;
                if ( -e $CorrectCAPrivateSecretFileLocation ) {
                    $FileExists = 1;
                }
                $Self->False(
                    $FileExists,
                    "Re-Hash $TestName: Correct CA $CAName private secret filename:"
                        . " $CorrectCAPrivateSecretFile File exists with false (after re-hash)"
                        . " there was not provate key",
                );
            }

            # check CA certificates, private keys and secrets contents is correct
            my $Certificate = $CryptObject->CertificateGet(
                Filename => $CorrectCAFile,
            );

            $Self->Is(
                $Certificate,
                $CorrectCAFileContent,
                "Re-Hash $TestName: Correct CA $CAName certificate filename: $CorrectCAFile"
                    . " File content",
            );

            my $PrivateKeyString;
            my $PrivateSecret;

            # use CryptObject if use both private keys and secrets
            if ( $UsePrivateKeys && $UsePrivateSecrets ) {
                ( $PrivateKeyString, $PrivateSecret ) = $CryptObject->PrivateGet(
                    Filename => $CorrectCAPrivateKeyFile,
                );
            }

            # otherwise get them manually
            elsif ($UsePrivateKeys) {
                $PrivateKeyString = $MainObject->FileRead(
                    Location => $CorrectCAPrivateKeyFileLocation,
                );
                $PrivateKeyString = ${$PrivateKeyString};
            }

            # if wrong file was added it should remain
            elsif ( $UsePrivateSecrets && !$UsePrivateKeys ) {
                $PrivateSecret = $MainObject->FileRead(
                    Location => $WrongCAPrivateSecretFileLocation,
                );
                $PrivateSecret = ${$PrivateSecret};
            }

            if ($UsePrivateKeys) {
                $Self->Is(
                    $PrivateKeyString,
                    $CorrectCAPrivateKeyContent,
                    "Re-Hash $TestName: Correct CA $CAName private key filename:"
                        . " $CorrectCAPrivateKeyFile File content",
                );
            }

            if ( $UsePrivateSecrets && !$UsePrivateKeys ) {
                $Self->Is(
                    $PrivateSecret,
                    $CorrectCAPrivateSecretFileContent,
                    "Re-Hash $TestName: Wrong CA $CAName private secret filename:"
                        . " $WrongCAPrivateSecretFile File content (there was no key)",
                );
            }
        };

        # function to create certificate reations directly into the database
        my $ManualCertRelationAdd = sub {
            my ( $CertificateHash, $CertificateFingerprint, $CAHash, $CAFingerprint, $TestName )
                = @_;

            my $Success = $Self->{DBObject}->Do(
                SQL => 'INSERT INTO smime_signer_cert_relations'
                    . ' ( cert_hash, cert_fingerprint, ca_hash, ca_fingerprint, create_time, create_by, change_time, change_by)'
                    . ' VALUES (?, ?, ?, ?, current_timestamp, 1, current_timestamp, 1)',
                Bind => [
                    \$CertificateHash, \$CertificateFingerprint, \$CAHash, \$CAFingerprint,
                ],
            );

            $Self->True(
                $Success,
                "Re-Hash $TestName: Manual certificate relation added for"
                    . " Certificate $CertificateHash and CA $CAHash with true",
            );
        };

        # set wrong hashes
        my %WrongHashes = (
            OTRSRootCA => 'aaaaaaaa',
            OTRSRDCA   => 'bbbbbbbb',
            OTRSLabCA  => 'cccccccc',
        );

        my @Tests = (
            {
                Name     => '3 Certs, PKs and PSs',
                WrongCAs => {
                    OTRSRootCA => {
                        WrongCAFile                  => "$WrongHashes{OTRSRootCA}.0",
                        WrongCAFileContent           => $Certificates{OTRSRootCA}->{String},
                        WrongCAPrivateKeyFileContent => $Certificates{OTRSRootCA}->{PrivateString},
                        WrongCAPrivateSecretFileContent =>
                            $Certificates{OTRSRootCA}->{PrivateSecret},
                        WrongRelations => [
                            {
                                CertHash        => $WrongHashes{OTRSRootCA},
                                CertFingerprint => $Certificates{OTRSRootCA}->{Fingerprint},
                                CAHash          => $WrongHashes{OTRSRDCA},
                                CAFingerprint   => $Certificates{OTRSRDCA}->{Fingerprint},

                            },
                            {
                                CertHash        => $WrongHashes{OTRSRootCA},
                                CertFingerprint => $Certificates{OTRSRootCA}->{Fingerprint},
                                CAHash          => $WrongHashes{OTRSLabCA},
                                CAFingerprint   => $Certificates{OTRSLabCA}->{Fingerprint},

                            },
                        ],
                    },
                    OTRSRDCA => {
                        WrongCAFile                     => "$WrongHashes{OTRSRDCA}.0",
                        WrongCAFileContent              => $Certificates{OTRSRDCA}->{String},
                        WrongCAPrivateKeyFileContent    => $Certificates{OTRSRDCA}->{PrivateString},
                        WrongCAPrivateSecretFileContent => $Certificates{OTRSRDCA}->{PrivateSecret},
                        WrongRelations                  => [
                            {
                                CertHash        => $WrongHashes{OTRSRDCA},
                                CertFingerprint => $Certificates{OTRSRDCA}->{Fingerprint},
                                CAHash          => $WrongHashes{OTRSRootCA},
                                CAFingerprint   => $Certificates{OTRSRootCA}->{Fingerprint},

                            },
                            {
                                CertHash        => $WrongHashes{OTRSRDCA},
                                CertFingerprint => $Certificates{OTRSRDCA}->{Fingerprint},
                                CAHash          => $WrongHashes{OTRSLabCA},
                                CAFingerprint   => $Certificates{OTRSLabCA}->{Fingerprint},

                            },
                        ],
                    },
                    OTRSLabCA => {
                        WrongCAFile                  => "$WrongHashes{OTRSLabCA}.0",
                        WrongCAFileContent           => $Certificates{OTRSLabCA}->{String},
                        WrongCAPrivateKeyFileContent => $Certificates{OTRSLabCA}->{PrivateString},
                        WrongCAPrivateSecretFileContent =>
                            $Certificates{OTRSRootCA}->{PrivateSecret},
                        WrongRelations => [
                            {
                                CertHash        => $WrongHashes{OTRSLabCA},
                                CertFingerprint => $Certificates{OTRSLabCA}->{Fingerprint},
                                CAHash          => $WrongHashes{OTRSRootCA},
                                CAFingerprint   => $Certificates{OTRSRootCA}->{Fingerprint},

                            },
                            {
                                CertHash        => $WrongHashes{OTRSLabCA},
                                CertFingerprint => $Certificates{OTRSLabCA}->{Fingerprint},
                                CAHash          => $WrongHashes{OTRSRDCA},
                                CAFingerprint   => $Certificates{OTRSRDCA}->{Fingerprint},

                            },
                        ],
                    },
                },
                CorrectCAs => {
                    OTRSRootCA => {
                        CorrectRelations => [
                            {
                                CertHash        => $Certificates{OTRSRootCA}->{Hash},
                                CertFingerprint => $Certificates{OTRSRootCA}->{Fingerprint},
                                CAHash          => $Certificates{OTRSRDCA}->{Hash},
                                CAFingerprint   => $Certificates{OTRSRDCA}->{Fingerprint},

                            },
                            {
                                CertHash        => $Certificates{OTRSRootCA}->{Hash},
                                CertFingerprint => $Certificates{OTRSRootCA}->{Fingerprint},
                                CAHash          => $Certificates{OTRSLabCA}->{Hash},
                                CAFingerprint   => $Certificates{OTRSLabCA}->{Fingerprint},

                            },
                        ],
                    },
                    OTRSRDCA => {
                        CorrectRelations => [
                            {
                                CertHash        => $Certificates{OTRSRDCA}->{Hash},
                                CertFingerprint => $Certificates{OTRSRDCA}->{Fingerprint},
                                CAHash          => $Certificates{OTRSRootCA}->{Hash},
                                CAFingerprint   => $Certificates{OTRSRootCA}->{Fingerprint},

                            },
                            {
                                CertHash        => $Certificates{OTRSRDCA}->{Hash},
                                CertFingerprint => $Certificates{OTRSRDCA}->{Fingerprint},
                                CAHash          => $Certificates{OTRSLabCA}->{Hash},
                                CAFingerprint   => $Certificates{OTRSLabCA}->{Fingerprint},

                            },
                        ],
                    },
                    OTRSLabCA => {
                        CorrectRelations => [
                            {
                                CertHash        => $Certificates{OTRSLabCA}->{Hash},
                                CertFingerprint => $Certificates{OTRSLabCA}->{Fingerprint},
                                CAHash          => $Certificates{OTRSRootCA}->{Hash},
                                CAFingerprint   => $Certificates{OTRSRootCA}->{Fingerprint},

                            },
                            {
                                CertHash        => $Certificates{OTRSLabCA}->{Hash},
                                CertFingerprint => $Certificates{OTRSLabCA}->{Fingerprint},
                                CAHash          => $Certificates{OTRSRDCA}->{Hash},
                                CAFingerprint   => $Certificates{OTRSRDCA}->{Fingerprint},
                            },
                        ],
                    },
                },
                UsePrivateKeys    => 1,
                UsePrivateSecrets => 1,
                UseRelations      => 1,
                SuccessReHash     => 1,
            },
            {
                Name     => '1 Cert, No PKs No PSs',
                WrongCAs => {
                    OTRSRootCA => {
                        WrongCAFile                  => "$WrongHashes{OTRSRootCA}.0",
                        WrongCAFileContent           => $Certificates{OTRSRootCA}->{String},
                        WrongCAPrivateKeyFileContent => $Certificates{OTRSRootCA}->{PrivateString},
                        WrongCAPrivateSecretFileContent =>
                            $Certificates{OTRSRootCA}->{PrivateSecret},
                    },
                },
                UsePrivateKeys    => 0,
                UsePrivateSecrets => 0,
                UseRelations      => 0,
                SuccessReHash     => 1,
            },
            {
                Name     => '1 Cert, 1 PKs No PSs',
                WrongCAs => {
                    OTRSRootCA => {
                        WrongCAFile                  => "$WrongHashes{OTRSRootCA}.0",
                        WrongCAFileContent           => $Certificates{OTRSRootCA}->{String},
                        WrongCAPrivateKeyFileContent => $Certificates{OTRSRootCA}->{PrivateString},
                        WrongCAPrivateSecretFileContent =>
                            $Certificates{OTRSRootCA}->{PrivateSecret},
                    },
                },
                UsePrivateKeys    => 1,
                UsePrivateSecrets => 0,
                UseRelations      => 0,
                SuccessReHash     => 1,
            },
            {
                Name     => '1 Cert, No PKs 1 PSs',
                WrongCAs => {
                    OTRSRootCA => {
                        WrongCAFile                  => "$WrongHashes{OTRSRootCA}.0",
                        WrongCAFileContent           => $Certificates{OTRSRootCA}->{String},
                        WrongCAPrivateKeyFileContent => $Certificates{OTRSRootCA}->{PrivateString},
                        WrongCAPrivateSecretFileContent =>
                            $Certificates{OTRSRootCA}->{PrivateSecret},
                    },
                },
                UsePrivateKeys    => 0,
                UsePrivateSecrets => 1,
                UseRelations      => 0,
                SuccessReHash     => 1,
            },
        );

        # execute tests
        for my $Test (@Tests) {

            # define Wrong CA certificates, private keys and secrets
            my %WrongCAs = %{ $Test->{WrongCAs} };

            # set the correct CA data
            my %CorrectCAs;
            for my $CAName ( sort keys %WrongCAs ) {

                my $Index;

                # calculate index
                FILENAME:
                for my $Count ( 0 .. 9 ) {
                    if ( -e "$CertPath/$Certificates{$CAName}->{Hash}.$Count" ) {
                        next FILENAME;
                    }
                    $Index = $Count;
                    last FILENAME;
                }

                $CorrectCAs{$CAName} = {
                    CorrectCAFile                     => "$Certificates{$CAName}->{Hash}.$Index",
                    CorrectCAFileContent              => $Certificates{$CAName}->{String},
                    CorrectCAPrivateKeyFileContent    => $Certificates{$CAName}->{PrivateString},
                    CorrectCAPrivateSecretFileContent => $Certificates{$CAName}->{PrivateSecret},
                    CorrectRelations
                        => $Test->{CorrectCAs}->{$CAName}->{CorrectRelations} || '',
                };
            }

            #create new CA file set with wrong names
            for my $CAName ( sort keys %WrongCAs ) {
                $CreateWrongCAFiles->(
                    $CAName,
                    $WrongCAs{$CAName}->{WrongCAFile},
                    $WrongCAs{$CAName}->{WrongCAFileContent},
                    $WrongCAs{$CAName}->{WrongCAPrivateKeyFileContent},
                    $WrongCAs{$CAName}->{WrongCAPrivateSecretFileContent},
                    $Test->{UsePrivateKeys},
                    $Test->{UsePrivateSecrets},
                    $Test->{Name},
                );
            }

            # create a check wrong DB certificate relations
            if ( $Test->{UseRelations} ) {

                my $ExpectedRelations = ( scalar keys %WrongCAs ) - 1;

                # create certificates relations manually
                CERTIFICATE:
                for my $CertName ( sort keys %WrongCAs ) {

                    my $CertificateHash;
                    my $CertificateFingerprint;
                    my $CAHash;
                    my $CAFingerprint;

                    CA:
                    for my $CAName ( sort keys %WrongCAs ) {
                        next CA if $CAName eq $CertName;

                        # set relation data
                        $CertificateHash        = $WrongHashes{$CertName};
                        $CertificateFingerprint = $Certificates{$CertName}->{Fingerprint};
                        $CAHash                 = $WrongHashes{$CAName};
                        $CAFingerprint          = $Certificates{$CAName}->{Fingerprint};

                        # create relations
                        $ManualCertRelationAdd->(
                            $CertificateHash,
                            $CertificateFingerprint,
                            $CAHash,
                            $CAFingerprint,
                            $Test->{Name},
                        );
                    }

                    # get relations
                    my @RelationsData = $CryptObject->SignerCertRelationGet(
                        CertFingerprint => $CertificateFingerprint,
                    );

                    $Self->Is(
                        scalar @RelationsData,
                        $ExpectedRelations,
                        "Re-Hash $Test->{Name}: Manual certificate relations for"
                            . " Certificate $CertificateHash number (before re-hash)",
                    );

                    # remove extended information for easy compare
                    for my $Relation (@RelationsData) {
                        delete $Relation->{ID};
                        delete $Relation->{CreatedBy};
                        delete $Relation->{Changed};
                        delete $Relation->{ChangedBy};
                        delete $Relation->{Created};
                    }

                    # deep compare wrong relations
                    $Self->IsDeeply(
                        \@RelationsData,
                        $Test->{WrongCAs}->{$CertName}->{WrongRelations},
                        "Re-Hash $Test->{Name}: Manual certificate relations for"
                            . " Certificate $CertificateHash data (before re-hash)",
                    );
                }
            }

            # refresh the hases
            my $Response = $CryptObject->CheckCertPath();
            $Self->True(
                $Response->{Success},
                "Re-Hash $Test->{Name}: CheckCertPath() executed successfully with true",
            );

            # output details if process was not successfull
            if ( !$Response->{Success} ) {
                $Self->True(
                    0,
                    $Response->{Details},
                );
            }

            # check certificates with correct names
            for my $CAName ( sort keys %WrongCAs ) {
                $CheckCorrectCAFiles->(
                    $CAName,
                    $WrongCAs{$CAName}->{WrongCAFile},
                    $CorrectCAs{$CAName}->{CorrectCAFile},
                    $CorrectCAs{$CAName}->{CorrectCAFileContent},
                    $CorrectCAs{$CAName}->{CorrectCAPrivateKeyFileContent},
                    $CorrectCAs{$CAName}->{CorrectCAPrivateSecretFileContent},
                    $Test->{UsePrivateKeys},
                    $Test->{UsePrivateSecrets},
                    $Test->{Name},
                );
            }

            # check updated DB certificate relations
            if ( $Test->{UseRelations} ) {

                my $ExpectedRelations = ( scalar keys %CorrectCAs ) - 1;

                # check updated relations
                CERTIFICATE:
                for my $CertName ( sort keys %CorrectCAs ) {

                    my $CertificateFingerprint = $Certificates{$CertName}->{Fingerprint};
                    my $CertificateHash        = $Certificates{$CertName}->{Hash};

                    # get relations
                    my @RelationsData = $CryptObject->SignerCertRelationGet(
                        CertFingerprint => $CertificateFingerprint,
                    );

                    $Self->Is(
                        scalar @RelationsData,
                        $ExpectedRelations,
                        "Re-Hash $Test->{Name}: Manual certificate relations for"
                            . " Certificate $CertificateHash number (after re-hash)",
                    );

                    # remove extended information for easy compare
                    for my $Relation (@RelationsData) {
                        delete $Relation->{ID};
                        delete $Relation->{CreatedBy};
                        delete $Relation->{Changed};
                        delete $Relation->{ChangedBy};
                        delete $Relation->{Created};
                    }

                    # deep compare wrong relations
                    $Self->IsDeeply(
                        \@RelationsData,
                        $CorrectCAs{$CertName}->{CorrectRelations},
                        "Re-Hash $Test->{Name}: Manual certificate relations for"
                            . " Certificate $CertificateHash data (after re-hash)",
                    );
                }
            }

            # remove certificates, private keys and secrets from the file system
            # db relations are deleted automatically when private keys are removed when using
            # $CryptObject
            for my $CAName ( sort keys %WrongCAs ) {

                my $CorrectCAPrivateKeyFile    = $CorrectCAs{$CAName}->{CorrectCAFile};
                my $CorrectCAPrivateSecretFile = "$CorrectCAPrivateKeyFile.P";
                my $WrongCAPrivateSecretFile   = "$WrongCAs{$CAName}->{WrongCAFile}.P";

                my $RemoveSuccess = $CryptObject->CertificateRemove(
                    Filename => $CorrectCAs{$CAName}->{CorrectCAFile},
                );
                $Self->True(
                    $RemoveSuccess,
                    "Re-Hash $Test->{Name}: system cleanup, CertificateRemove()"
                        . " $CorrectCAs{$CAName}->{CorrectCAFile} with true",
                );

                # use CryptObject if use both private keys and secrets
                if ( $Test->{UsePrivateKeys} && $Test->{UsePrivateSecrets} ) {
                    $RemoveSuccess = $CryptObject->PrivateRemove(
                        Filename => $CorrectCAPrivateKeyFile,
                    );
                    $Self->True(
                        $RemoveSuccess,
                        "Re-Hash $Test->{Name}: system cleanup, PrivateRemove()"
                            . " $CorrectCAPrivateKeyFile and $CorrectCAPrivateSecretFile with true",
                    );
                }

                # otherwise remove them manually
                elsif ( $Test->{UsePrivateKeys} ) {
                    my $RemoveSuccess = $MainObject->FileDelete(
                        Location => "$PrivatePath/$CorrectCAPrivateKeyFile"
                    );
                    $Self->True(
                        $RemoveSuccess,
                        "Re-Hash $Test->{Name}: system cleanup, remove private key"
                            . " $CorrectCAPrivateKeyFile with true",
                    );

                    # remove also certificate relations (if any)
                    my $Success = $CryptObject->SignerCertRelationDelete(
                        CertFingerprint => $Certificates{$CAName}->{Fingerprint},
                        UserID          => 1,
                    );
                    $Self->True(
                        $RemoveSuccess,
                        "Re-Hash $Test->{Name}: system cleanup, remove certificate relations"
                            . " for hash $Certificates{$CAName}->{Hash} with true",
                    );

                }
                elsif ( $Test->{UsePrivateSecrets} && !$Test->{UsePrivateKeys} ) {
                    my $RemoveSuccess = $MainObject->FileDelete(
                        Location => "$PrivatePath/$WrongCAPrivateSecretFile",
                    );
                    $Self->True(
                        $RemoveSuccess,
                        "Re-Hash $Test->{Name}: system cleanup, remove private secret"
                            . " $WrongCAPrivateSecretFile with true there was no private key",
                    );
                }

                # check for certificate relations
                my @RelationsData = $CryptObject->SignerCertRelationGet(
                    CertFingerprint => $Certificates{$CAName}->{Fingerprint},
                );
                $Self->Is(
                    scalar @RelationsData,
                    0,
                    "Re-Hash $Test->{Name}: system cleanup, certificate relations for hash"
                        . " $Certificates{$CAName}->{Hash} number",
                );
            }
        }
    }
}

# CertificateRead() tests
{

    # add certificates
    for my $CA (qw( OTRSRootCA OTRSLabCA )) {
        my %Result = $CryptObject->CertificateAdd(
            Certificate => $Certificates{$CA}->{String},
        );

        # sanity check
        $Self->True(
            $Result{Successful},
            "CertificateAdd() $CA for CertificateRead() add success with true",
        );
    }

    # create test cases
    my @Tests = (
        {
            Name    => 'Empty Params',
            Params  => {},
            Success => 0,
        },
        {
            Name   => 'Wrong Filename',
            Params => {
                Filename => "$Certificates{OTRSRDCA}->{Hash}.0",
            },
            Success => 0,
        },
        {
            Name   => 'Missing Hash',
            Params => {
                Hash        => '',
                Fingerprint => $Certificates{OTRSRootCA}->{Fingerprint},
            },
            Success => 0,
        },
        {
            Name   => 'Missing Fingerprint',
            Params => {
                Hash        => $Certificates{OTRSRootCA}->{Hash},
                Fingerprint => '',
            },
            Success => 0,
        },
        {
            Name   => 'Wrong Hash',
            Params => {
                Hash        => $Certificates{OTRSLabCA}->{Hash},
                Fingerprint => $Certificates{OTRSRootCA}->{Fingerprint},
            },
            Success => 0,
        },
        {
            Name   => 'Wrong Fingerprint',
            Params => {
                Hash        => $Certificates{OTRSRootCA}->{Hash},
                Fingerprint => $Certificates{OTRSLabCA}->{Fingerprint},
            },
            Success => 0,
        },
        {
            Name   => 'Correct Filename',
            Params => {
                Filename => "$Certificates{OTRSRootCA}->{Hash}.0",
            },
            Success => 1,
        },
        {
            Name   => 'Correct Hash, Fingerprint',
            Params => {
                Hash        => $Certificates{OTRSRootCA}->{Hash},
                Fingerprint => $Certificates{OTRSRootCA}->{Fingerprint},
            },
            Success => 1,
        },

    );

    for my $Test (@Tests) {
        my $CertificateText = $CryptObject->CertificateRead( %{ $Test->{Params} } );

        if ( $Test->{Success} ) {
            $Self->IsNot(
                $CertificateText,
                undef,
                "CertificateRead() $Test->{Name}: should return the certificate",
            );

            # check for certificate words
            for my $String (
                qw(
                Certificate Serial Signature Issuer: Validity Before After Subject: Modulus RSA
                )
                )
            {
                my $Match;
                if ( $CertificateText =~ m{\Q$String\E} ) {
                    $Match = 1;
                }

                $Self->True(
                    $Match,
                    "CertificateRead $Test->{Name}: Certificate contains word '$String'",
                    )
            }
        }
        else {
            $Self->Is(
                $CertificateText,
                undef,
                "CertificateRead() $Test->{Name}: should return undef",
            );
        }
    }

    # compare both methods
    my $CertificateText1 = $CryptObject->CertificateRead(
        Filename => "$Certificates{OTRSRootCA}->{Hash}.0",
    );
    my $CertificateText2 = $CryptObject->CertificateRead(
        Hash        => $Certificates{OTRSRootCA}->{Hash},
        Fingerprint => $Certificates{OTRSRootCA}->{Fingerprint},
    );

    $Self->Is(
        $CertificateText1,
        $CertificateText2,
        "CertificateRead() using Filename / Hash and Fingerprint certificates match",
    );

    # clean system, remove certificates
    for my $CA (qw( OTRSRootCA OTRSLabCA )) {
        my %Result = $CryptObject->CertificateRemove(
            Hash        => $Certificates{$CA}->{Hash},
            Fingerprint => $Certificates{$CA}->{Fingerprint},
        );

        # sanity check
        $Self->True(
            $Result{Successful},
            "CertificateRemove() $CA for CertificateRead() remove success with true",
        );
    }
}

# attributes cache tests
for my $Count ( 1 .. 2 ) {
    my @Certs = $CryptObject->Search( Search => $Search{$Count} );
    $Self->False(
        $Certs[0] || '',
        "#$Count Search()",
    );

    # add certificate ...
    my $CertString = $Self->{MainObject}->FileRead(
        Directory => $ConfigObject->Get('Home') . "/scripts/test/sample/SMIME/",
        Filename  => "SMIMECertificate-$Count.asc",
    );
    my %Result = $CryptObject->CertificateAdd( Certificate => ${$CertString} );

    $Certs[0]->{Filename} = $Result{Filename};

    my $CertCacheKey    = 'CertAttributes::Filename::' . $Result{Filename};
    my $PrivateCacheKey = 'PrivateAttributes::Filename::' . $Result{Filename};

    $Self->True(
        $Result{Successful} || '',
        "#$Count CertificateAdd() - $Result{Message}",
    );

    # get attributes from OpenSSL
    # check cache
    my $Cache = $CryptObject->{CacheObject}->Get(
        Type => 'SMIME_Cert',
        Key  => $CertCacheKey,
    );
    $Self->Is(
        $Cache,
        undef,
        "#$Count Cache for Certificarte Attributes is empty",

    );
    my %CertificateAttributes = $CryptObject->CertificateAttributes(
        Certificate => ${$CertString},
        Filename    => $Result{Filename},
    );
    $Self->IsNotDeeply(
        \%CertificateAttributes,
        {},
        "#$Count Certificarte Attributes OpenSSL are not empty",
    );

    # at this point the attributes should be cached, read them again
    # check cache
    $Cache = $CryptObject->{CacheObject}->Get(
        Type => 'SMIME_Cert',
        Key  => $CertCacheKey,
    );
    $Self->IsNot(
        $Cache,
        undef,
        "#$Count Cache for Certificarte Attributes is not empty",

    );
    my %CertificateAttributesCached = $CryptObject->CertificateAttributes(
        Certificate => ${$CertString},
        Filename    => $Result{Filename},
    );
    $Self->IsNotDeeply(
        \%CertificateAttributesCached,
        {},
        "#$Count Certificarte Attributes Cached are not empty",
    );

    # compare both results
    $Self->IsDeeply(
        \%CertificateAttributes,
        \%CertificateAttributesCached,
        "#$Count Certificated Attributes OpenSSL and Cached"
    );

    @Certs = $CryptObject->CertificateSearch(
        Search => $Search{$Count},
    );

    $Self->True(
        $Certs[0] || '',
        "#$Count CertificateSearch()",
    );

    # add private key
    my $KeyString = $Self->{MainObject}->FileRead(
        Directory => $ConfigObject->Get('Home') . "/scripts/test/sample/SMIME/",
        Filename  => "SMIMEPrivateKey-$Count.asc",
    );
    my $Secret = $Self->{MainObject}->FileRead(
        Directory => $ConfigObject->Get('Home') . "/scripts/test/sample/SMIME/",
        Filename  => "SMIMEPrivateKeyPass-$Count.asc",
    );
    %Result = $CryptObject->PrivateAdd(
        Private => ${$KeyString},
        Secret  => ${$Secret},
    );
    $Self->True(
        $Result{Successful} || '',
        "#$Count PrivateAdd()",
    );

    # read private attribues from OpenSSL
    # check cache
    $Cache = $CryptObject->{CacheObject}->Get(
        Type => 'SMIME_Private',
        Key  => $PrivateCacheKey,
    );
    $Self->Is(
        $Cache,
        undef,
        "#$Count Cache for Private Attributes is empty",

    );
    my %PrivateAttributes = $CryptObject->PrivateAttributes(
        Private  => ${$KeyString},
        Secret   => ${$Secret},
        Filename => $Result{Filename},
    );
    $Self->IsNotDeeply(
        \%PrivateAttributes,
        {},
        "#$Count Private Attributes OpenSSL are not empty",
    );

    # at this point the attributes should be already cached
    # check cache
    $Cache = $CryptObject->{CacheObject}->Get(
        Type => 'SMIME_Private',
        Key  => $PrivateCacheKey,
    );
    $Self->IsNot(
        $Cache,
        undef,
        "#$Count Cache for Private Attributes is not empty",

    );
    my %PrivateAttributesCached = $CryptObject->PrivateAttributes(
        Private  => ${$KeyString},
        Secret   => ${$Secret},
        Filename => $Result{Filename},
    );
    $Self->IsNotDeeply(
        \%PrivateAttributesCached,
        {},
        "#$Count Private Attributes Cached are not empty",
    );

    # compare both
    $Self->IsDeeply(
        \%PrivateAttributes,
        \%PrivateAttributesCached,
        "#$Count Private Attributes OpenSSL and Cached",
    );

    # after private add all cache for certs must be cleaned, get certificate attributes from OpenSSL
    # check cache
    $Cache = $CryptObject->{CacheObject}->Get(
        Type => 'SMIME_Cert',
        Key  => $CertCacheKey,
    );
    $Self->Is(
        $Cache,
        undef,
        "#$Count Cache for Certificarte Attributes after private is empty",

    );
    my %CertificateAttributesAfterPrivate = $CryptObject->CertificateAttributes(
        Certificate => ${$CertString},
        Filename    => $Result{Filename},
    );
    $Self->IsNotDeeply(
        \%CertificateAttributesAfterPrivate,
        {},
        "#$Count Certificarte Attributes after private OpenSSL are not empty",
    );

    # cache must be set right now, read attributes again
    # check cache
    $Cache = $CryptObject->{CacheObject}->Get(
        Type => 'SMIME_Cert',
        Key  => $CertCacheKey,
    );
    $Self->IsNot(
        $Cache,
        undef,
        "#$Count Cache for Certificarte Attributes after private is not empty",

    );
    my %CertificateAttributesCachedAfterPrivate = $CryptObject->CertificateAttributes(
        Certificate => ${$CertString},
        Filename    => $Result{Filename},
    );
    $Self->IsNotDeeply(
        \%CertificateAttributesCachedAfterPrivate,
        {},
        "#$Count Certificarte Attributes Cached after private are not empty",
    );

    # compare both
    $Self->IsDeeply(
        \%CertificateAttributes,
        \%CertificateAttributesCached,
        "#$Count Certificated Attributes after private OpenSSL and Cached",
    );

    # compare before vs after
    $Self->IsNotDeeply(
        \%CertificateAttributesCached,
        \%CertificateAttributesCachedAfterPrivate,
        "#$Count Certificated Attributes Cached before and after private must be different",
    );

    my @Keys = $CryptObject->PrivateSearch( Search => $Search{$Count} );

    $Self->True(
        $Keys[0] || '',
        "#$Count PrivateSearch()",
    );
}

# delete keys
for my $Count ( 1 .. 2 ) {
    my @Keys = $CryptObject->Search(
        Search => $Search{$Count},
    );
    $Self->True(
        $Keys[0] || '',
        "#$Count Search()",
    );
    my %Result = $CryptObject->PrivateRemove(
        Hash    => $Keys[0]->{Hash},
        Modulus => $Keys[0]->{Modulus},
    );
    $Self->True(
        $Result{Successful} || '',
        "#$Count PrivateRemove() - $Result{Message}",
    );

    %Result = $CryptObject->CertificateRemove(
        Hash        => $Keys[0]->{Hash},
        Fingerprint => $Keys[0]->{Fingerprint},
    );

    $Self->True(
        $Result{Successful} || '',
        "#$Count CertificateRemove()",
    );

    @Keys = $CryptObject->Search( Search => $Search{$Count} );
    $Self->False(
        $Keys[0] || '',
        "#$Count Search()",
    );
}

1;
