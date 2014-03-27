# --
# SMIME.t - SMIME tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: SMIME.t,v 1.14.2.4 2012-05-08 13:33:00 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use Kernel::System::Crypt;

use vars qw($Self);
use Kernel::Config;

# create local objects
my $ConfigObject = Kernel::Config->new();
my $HomeDir      = $ConfigObject->Get('Home');
my $CertPath     = $ConfigObject->Get('SMIME::CertPath');

my $OpenSSLBin = $ConfigObject->Get('SMIME::Bin');

# get the openssl version string, e.g. OpenSSL 0.9.8e 23 Feb 2007
my $OpenSSLVersionString = qx{$OpenSSLBin version};
my $OpenSSLMajorVersion;

# get the openssl major version, e.g. 1 for version 1.0.0
if ( $OpenSSLVersionString =~ m{ \A (?: OpenSSL )? \s* ( \d )  }xmsi ) {
    $OpenSSLMajorVersion = $1;
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
    return;
}

my %Search = (
    1 => 'unittest@example.org',
    2 => 'unittest2@example.org',
);

my %Check = (
    1 => {
        Modulus =>
            'B686AD697981A5A387792F3F301062EF520F6966AE21421995C1AB63BF4AB974D250E8764F9B341364B0842FA59C9FFECCB0243ABF802FAF28DFDCE3C2315FC74D6BA81F09AB5F333A0EDAFFDDCB941792F4C0E57AC0413E205E89D4E61D39B0F144FAF3E7064FD97131DC1E723044E4B0DEAA17E83C0B0697C1BB65B11D997C6A3EAB148FFAB3ECF60CB9E17BE0DABAE087F488BCA29C14D597DE024F1A0EBA6F435EFA03B1EBCBBB5D1107CBBD72CC8B0202AE76BEA0672B24A75C82031BC2DE9B82CDC25316F7DDEC9D32BF9C4FF2858424AA371D2E96F71170AAB3167ED9FA5A2C525C53B8ECE725034339DC3DAC32D3840D1D3ACFB42DB67C9817142019',
        Subject =>
            'C= DE ST= Bayern L= Straubing O= OTRS AG CN= unittest emailAddress= unittest@example.org',
        Hash        => '980a83c7',
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
        Hash        => '999bcb2f',
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
    my $Message = $CryptObject->CertificateAdd( Certificate => ${$CertString} );

    $Self->True(
        $Message || '',
        "#$Count CertificateAdd() - $Message",
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

    for my $ID ( keys %{ $Check{$Count} } ) {
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
    $Message = $CryptObject->PrivateAdd(
        Private => ${$KeyString},
        Secret  => ${$Secret},
    );
    $Self->True(
        $Message || '',
        "#$Count PrivateAdd()",
    );

    my @Keys = $CryptObject->PrivateSearch( Search => $Search{$Count} );

    $Self->True(
        $Keys[0] || '',
        "#$Count PrivateSearch()",
    );

    my $CertificateString = $CryptObject->CertificateGet( Hash => $Certs[0]->{Hash} );
    $Self->True(
        $CertificateString || '',
        "#$Count CertificateGet()",
    );

    my $PrivateKeyString = $CryptObject->PrivateGet( Hash => $Keys[0]->{Hash} );
    $Self->True(
        $PrivateKeyString || '',
        "#$Count PrivateGet()",
    );

    # crypt
    my $Crypted = $CryptObject->Crypt(
        Message => $TestText,
        Hash    => $Certs[0]->{Hash},
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
        Message => $Crypted,
        Hash    => $Certs[0]->{Hash},
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

    # sign
    my $Sign = $CryptObject->Sign(
        Message => $TestText,
        Hash    => $Keys[0]->{Hash},
    );
    $Self->True(
        $Sign || '',
        "#$Count Sign()",
    );

    # verify
    my %Verify = $CryptObject->Verify(
        Message     => $Sign,
        Certificate => "$CertPath/$Check{$Count}->{Hash}.0",
    );

    $Self->True(
        $Verify{Successful} || '',
        "#$Count Verify() - self signed sending certificate path",
    );
    $Self->True(
        $Verify{SignerCertificate} eq $Check{"cert-$Count"},
        "#$Count Verify()",
    );

    if ( $OpenSSLMajorVersion >= 1 ) {
        my %Verify = $CryptObject->Verify(
            Message => $Sign,
        );

        $Self->False(
            $Verify{Successful} || '',
            "#$Count Verify() - self signed not sending certificate path",
        );
    }

    # verify failure on manipulated text
    my $ManipulatedSign = $Sign;
    $ManipulatedSign =~ s{Q}{W}g;
    %Verify = $CryptObject->Verify(
        Message     => $ManipulatedSign,
        Certificate => "$CertPath/$Check{$Count}->{Hash}.0",
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
            Message => $Reference,
            Hash    => $Certs[0]->{Hash},
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
            Message => $Crypted,
            Hash    => $Certs[0]->{Hash},
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
            Message => $Reference,
            Hash    => $Keys[0]->{Hash},
        );
        $Self->True(
            $Signed || '',
            "#$Count Sign() .$File",
        );

        # verify
        my %Verify = $CryptObject->Verify(
            Message     => $Signed,
            Certificate => "$CertPath/$Check{$Count}->{Hash}.0",
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
    my $PrivateRemoved = $CryptObject->PrivateRemove( Hash => $Keys[0]->{Hash} );
    $Self->True(
        $PrivateRemoved || '',
        "#$Count PrivateRemove()",
    );

    my $CertificateRemoved = $CryptObject->CertificateRemove( Hash => $Keys[0]->{Hash} );
    $Self->True(
        $CertificateRemoved || '',
        "#$Count CertificateRemove()",
    );

    @Keys = $CryptObject->Search( Search => $Search{$Count} );
    $Self->False(
        $Keys[0] || '',
        "#$Count Search()",
    );
}

1;
