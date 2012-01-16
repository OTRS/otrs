# --
# SMIME.t - SMIME tests
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: SMIME.t,v 1.22 2012-01-16 10:46:29 mg Exp $
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
            'B5D12B210C8EF3E6B404162157022CEFF46AF6519571F985C116A3CF096B5BD9DBE306CA6683221F08858C8BA1422F934916FE29EF89DA1F1DD55AA47443F796CB882843E16CB4F722F8038768B6FDCE8F4ADEC5E81DB46F9B300A765737B698FC0B7D1E57410BCF810E4B3B4F74FD5C805378879E8C23CD5CB6A0A160AE42E9',
        EndDate => 'Mar 29 11:20:56 2012 GMT',
        Subject =>
            'C= DE ST= Bayern L= Straubing O= OTRS AG CN= unittest emailAddress= unittest@example.org',
        Hash         => '980a83c7',
        Private      => 'No',
        Serial       => 'D51FC7523893BCFD',
        ShortEndDate => '2012-03-29',
        Type         => 'cert',
        Fingerprint  => 'E1:FB:F1:3E:6B:83:9F:C3:29:8A:3E:C3:19:51:33:1C:73:7F:2C:0B',
        Issuer =>
            '/C= DE/ST= Bayern/L= Straubing/O= OTRS AG/CN= unittest/emailAddress= unittest@example.org',
        Email          => 'unittest@example.org',
        StartDate      => 'Feb 19 11:20:56 2008 GMT',
        ShortStartDate => '2008-02-19',
    },
    2 => {
        Modulus =>
            'C37422BAB1D6CDE930ED44E79C4D3BD3BECBD4E391FB80C3FC74B639A926D670FDDF6A75EBC304E42FD83311C64356C3DF4E468484CF0A71CAACA333BB99B1ACF418B72020A4D44FA28DF97F0DC2E8D64A0926673FBAC1F29A669E6F3776601CC27937A3212228856CAB9396923B60998198FFD2BB10E8667C02C66F11BA5787',
        EndDate => 'Mar 29 11:32:20 2012 GMT',
        Subject =>
            'C= DE ST= Bayern L= Straubing O= OTRS AG CN= unittest2 emailAddress= unittest2@example.org',
        Hash         => '999bcb2f',
        Private      => 'No',
        Serial       => '9BCC39BD2A958C37',
        ShortEndDate => '2012-03-29',
        Fingerprint  => '3F:EE:1A:D2:E1:29:06:03:BF:AB:18:8C:F4:BA:E0:9C:FD:47:5D:0A',
        Type         => 'cert',
        Issuer =>
            '/C= DE/ST= Bayern/L= Straubing/O= OTRS AG/CN= unittest2/emailAddress= unittest2@example.org',
        Email          => 'unittest2@example.org',
        StartDate      => 'Feb 19 11:32:20 2008 GMT',
        ShortStartDate => '2008-02-19',
    },
    'cert-1' => '-----BEGIN CERTIFICATE-----
MIIDWTCCAsKgAwIBAgIJANUfx1I4k7z9MA0GCSqGSIb3DQEBBQUAMHwxCzAJBgNV
BAYTAkRFMQ8wDQYDVQQIEwZCYXllcm4xEjAQBgNVBAcTCVN0cmF1YmluZzEQMA4G
A1UEChMHT1RSUyBBRzERMA8GA1UEAxMIdW5pdHRlc3QxIzAhBgkqhkiG9w0BCQEW
FHVuaXR0ZXN0QGV4YW1wbGUub3JnMB4XDTA4MDIxOTExMjA1NloXDTEyMDMyOTEx
MjA1NlowfDELMAkGA1UEBhMCREUxDzANBgNVBAgTBkJheWVybjESMBAGA1UEBxMJ
U3RyYXViaW5nMRAwDgYDVQQKEwdPVFJTIEFHMREwDwYDVQQDEwh1bml0dGVzdDEj
MCEGCSqGSIb3DQEJARYUdW5pdHRlc3RAZXhhbXBsZS5vcmcwgZ8wDQYJKoZIhvcN
AQEBBQADgY0AMIGJAoGBALXRKyEMjvPmtAQWIVcCLO/0avZRlXH5hcEWo88Ja1vZ
2+MGymaDIh8IhYyLoUIvk0kW/invidofHdVapHRD95bLiChD4Wy09yL4A4dotv3O
j0rexegdtG+bMAp2Vze2mPwLfR5XQQvPgQ5LO090/VyAU3iHnowjzVy2oKFgrkLp
AgMBAAGjgeIwgd8wHQYDVR0OBBYEFHcbSoH3e7LcaizNIja//BPUrMkjMIGvBgNV
HSMEgacwgaSAFHcbSoH3e7LcaizNIja//BPUrMkjoYGApH4wfDELMAkGA1UEBhMC
REUxDzANBgNVBAgTBkJheWVybjESMBAGA1UEBxMJU3RyYXViaW5nMRAwDgYDVQQK
EwdPVFJTIEFHMREwDwYDVQQDEwh1bml0dGVzdDEjMCEGCSqGSIb3DQEJARYUdW5p
dHRlc3RAZXhhbXBsZS5vcmeCCQDVH8dSOJO8/TAMBgNVHRMEBTADAQH/MA0GCSqG
SIb3DQEBBQUAA4GBABIu7YxiWIstI9XXAFtEA3dQzQNOPP5vh7zju7Zi8WHmkMC6
3OnVz5v5bazcBxDcIGVSGe0IUElvMXGDgFzbVnIWGb3lhDcjKiLjshR7tUSs4eeR
w1mJrbFPWksw+fr6vUQwtU0YaNU0mKhE/e0WGDQw6d3/sU/XCM6zKEdrRDum
-----END CERTIFICATE-----
',
    'cert-2' => '-----BEGIN CERTIFICATE-----
MIIDYDCCAsmgAwIBAgIJAJvMOb0qlYw3MA0GCSqGSIb3DQEBBQUAMH4xCzAJBgNV
BAYTAkRFMQ8wDQYDVQQIEwZCYXllcm4xEjAQBgNVBAcTCVN0cmF1YmluZzEQMA4G
A1UEChMHT1RSUyBBRzESMBAGA1UEAxMJdW5pdHRlc3QyMSQwIgYJKoZIhvcNAQkB
FhV1bml0dGVzdDJAZXhhbXBsZS5vcmcwHhcNMDgwMjE5MTEzMjIwWhcNMTIwMzI5
MTEzMjIwWjB+MQswCQYDVQQGEwJERTEPMA0GA1UECBMGQmF5ZXJuMRIwEAYDVQQH
EwlTdHJhdWJpbmcxEDAOBgNVBAoTB09UUlMgQUcxEjAQBgNVBAMTCXVuaXR0ZXN0
MjEkMCIGCSqGSIb3DQEJARYVdW5pdHRlc3QyQGV4YW1wbGUub3JnMIGfMA0GCSqG
SIb3DQEBAQUAA4GNADCBiQKBgQDDdCK6sdbN6TDtROecTTvTvsvU45H7gMP8dLY5
qSbWcP3fanXrwwTkL9gzEcZDVsPfTkaEhM8KccqsozO7mbGs9Bi3ICCk1E+ijfl/
DcLo1koJJmc/usHymmaebzd2YBzCeTejISIohWyrk5aSO2CZgZj/0rsQ6GZ8AsZv
EbpXhwIDAQABo4HlMIHiMB0GA1UdDgQWBBSnQFo3v5xSzt4e1XEUbqFmpSDurzCB
sgYDVR0jBIGqMIGngBSnQFo3v5xSzt4e1XEUbqFmpSDur6GBg6SBgDB+MQswCQYD
VQQGEwJERTEPMA0GA1UECBMGQmF5ZXJuMRIwEAYDVQQHEwlTdHJhdWJpbmcxEDAO
BgNVBAoTB09UUlMgQUcxEjAQBgNVBAMTCXVuaXR0ZXN0MjEkMCIGCSqGSIb3DQEJ
ARYVdW5pdHRlc3QyQGV4YW1wbGUub3JnggkAm8w5vSqVjDcwDAYDVR0TBAUwAwEB
/zANBgkqhkiG9w0BAQUFAAOBgQCjOBwiSBW2GBKh9uoobhpgl/O6J2yfCKFXcfTh
JN9H2yH0QEUpG0eTsSY25Ns5vXS7WmYkMsIemTz5knkhmjSR7uqx6+OMQDGVjfID
nLcdi8Cg4aLtoofolDSgyMbwYPBIuO8W3+WXvEXgZdWGiOlfs/25GVflLPh7haPC
/4ruQw==
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

# adding tests for smime certificate chains
{

    # add certificate smimeuser1
    my %SMIMEUser1Certificate;
    %SMIMEUser1Certificate = (
        Hash        => '051d6705',
        Fingerprint => '02:61:27:30:DC:15:99:F1:53:AB:09:F9:4D:1D:75:D1:6D:6E:F4:1A',
        String =>
            '-----BEGIN CERTIFICATE-----
MIIDDTCCAnagAwIBAgIBATANBgkqhkiG9w0BAQUFADCBiTELMAkGA1UEBhMCTVgx
EDAOBgNVBAgTB0phbGlzY28xFDASBgNVBAcTC0d1YWRhbGFqYXJhMREwDwYDVQQK
EwhPVFJTIExhYjEMMAoGA1UECxQDUiZEMREwDwYDVQQDEwhvdHJzLm9yZzEeMBwG
CSqGSIb3DQEJARYPb3Ryc3JkQHRlc3QuY29tMB4XDTExMDUxMjIxNTc0OFoXDTEy
MDUxMTIxNTc0OFowgZExCzAJBgNVBAYTAk1YMRAwDgYDVQQIEwdKYWxpc2NvMRQw
EgYDVQQHEwtHdWFkYWxhamFyYTERMA8GA1UEChMIT1RSUyBMYWIxDDAKBgNVBAsU
A1ImRDEVMBMGA1UEAxMMU21pbWUgVXNlciAxMSIwIAYJKoZIhvcNAQkBFhNzbWlt
ZXVzZXIxQHRlc3QuY29tMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDOcpur
SybB79FYJ0bJV3ZIKVAASd1OvSxlNluANquBNfbh8nkAfOixVQUmT9bvrD2UEDqr
f4WlZ49usY8UOewlgSK+oDs2/h5Lls2UVXGux/4uTH9uha/NjwzhBj5n5YJyO9AZ
N2xQtA2GBsHsNahkAyQv14pm6jyDC02QS9tzxwIDAQABo3sweTAJBgNVHRMEAjAA
MCwGCWCGSAGG+EIBDQQfFh1PcGVuU1NMIEdlbmVyYXRlZCBDZXJ0aWZpY2F0ZTAd
BgNVHQ4EFgQUQuF1ZBhRRTs8jmbUezTAqqv7a0IwHwYDVR0jBBgwFoAUJUAnRdY9
wmh0neVHgC5dHTRKwEkwDQYJKoZIhvcNAQEFBQADgYEAFlHnt3CmQi/EGFRtDk3Z
cI//dmkTHg81Kt0+Zq3JdhDqoAevIbFnhLsqEf6696yytyL/UHPG1Ivu3dTmPfyh
Ke3EvjnBq5V0R6TCSHXWMyE5qzSy+z9ZI4dqbBC5m18XokXqK4D1nBKK+mMY532w
AFZc+igKesPcdjhaBJFPZ+Q=
-----END CERTIFICATE-----',
        PrivateSecret => 'smimeuser1',
        PrivateHash   => '051d6705',
        PrivateString =>
            '-----BEGIN RSA PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: DES-EDE3-CBC,74A4BA3503D67A48

mrv1oB+iF6G/z2RLLJBrWPm9DWO1d/97bDMpBgau/kLJ55ugZP+iu7r4MdxJgFeh
CFY2PgswVOHa8MZtx+PFNHfZBIBh06w7MYVjrTU1tUg8LmLARN4L6pEdgUzmVR01
Cln9yVh52fBSGo5W/2J8Fu/yaAk4QiHy961f5mjT2F6LCFebGzdKLHpuS7zzS4G4
CqWb31GWHWWKYriKLcwGL4waPjPQrhiHVHjSF297ehPRQmryvQrws4IqZBh/pE8/
sQVdCmPwTnp06TBvinb4z0zuxEpPjXSyKf2YCCPFUVm09NVy61PJ/THUNjDJqO5R
Fqz0k3ExqWiSwDZuoDoEtj38DYjUEx8oSUKQLQ40AsbG6e2SpQxPOUdALLzIt21D
gRa0Idch9NlE6/tpDon4RxJrqXWulAr5dYQc/ria1wpkbLKrJ/EpT9ivSzVsRyFj
eoHuxMnHZ1h6wOUmFT6X/VjPZapqcmsHO0WpM2gs51WyTmw8AqrXMw3FJ4Fx5dTo
Wr/fzzAz4ar9k9YmiLI9VWbHUygPCM+Z49obUnW1w8+OUsRWhVT7aiXbh2h2GPbb
K1PO6DyT8ieF7zTXHhQ6i+x4e/7pZ6HBE5SVKqtZlt5kfrUxOeGgExwQgCxrSWiZ
P2TOhrdphD+DUf3nxiwRM/khnobofQSKvETP0ZLzOYp00tLQFbLxszfMlbXnEcqA
cAgAiLDlmdBvN/lawOMoNgMz4YoUWvTdmQRaqchgfRzkTiiCoDlmbVmAawKj4vsi
XgLpk1hOJqMI3lGeiFINPcGWCQW8l6/wqiRZHqM/wdXXoNzvLLayIQ==
-----END RSA PRIVATE KEY-----',
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
        'This is a signed message to sign, and verification must pass a certificate chain validation. -dz';

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
        'Sign(), failed certificate chain verification, not needed CA certificates embedded',
    );

    my %Certificates;
    $Certificates{otrslabCA} = {
        Hash        => '94c8105e',
        Fingerprint => '17:E8:86:81:1A:B1:8B:60:DF:C5:B5:99:49:F2:EF:19:FC:F6:64:64',
        String =>
            '-----BEGIN CERTIFICATE-----
MIIDJTCCAo6gAwIBAgIBATANBgkqhkiG9w0BAQUFADCBqDELMAkGA1UEBhMCTVgx
EDAOBgNVBAgTB0phbGlzY28xFDASBgNVBAcTC0d1YWRhbGFqYXJhMRgwFgYDVQQK
Ew9EYW5pZWwgWmFtb3Jhbm8xFDASBgNVBAsTC0RldmVsb3BtZW50MRswGQYDVQQD
ExJkYW5pZWx6YW1vcmFuby5jb20xJDAiBgkqhkiG9w0BCQEWFWR6QGRhbmllbHph
bW9yYW5vLmNvbTAeFw0xMTA1MTIxOTQ2MTlaFw0xMjA1MTExOTQ2MTlaMIGHMQsw
CQYDVQQGEwJNWDEQMA4GA1UECBMHSmFsaXNjbzEUMBIGA1UEBxMLR3VhZGFsYWph
cmExETAPBgNVBAoTCE9UUlMgTGFiMQwwCgYDVQQLFANSJkQxETAPBgNVBAMTCG90
cnMub3JnMRwwGgYJKoZIhvcNAQkBFg1vdHJzQHRlc3QuY29tMIGfMA0GCSqGSIb3
DQEBAQUAA4GNADCBiQKBgQDEV3q4ita8Yk92x6yOE8NqPx3Wkj5whqJxlGcDUgz6
wNvE6HgcuAZ4B0Y/opEp1gp7y1b5kYtztv9QaZMEoBAyfSLlpPODMsy/NoHy+Wo8
Fg7cgJ1BIDarRzgGc+VMxkwX0udJfowaXljdgq5JpfCO1bJpEgQyahyBgQc/+tUC
8QIDAQABo34wfDAMBgNVHRMEBTADAQH/MCwGCWCGSAGG+EIBDQQfFh1PcGVuU1NM
IEdlbmVyYXRlZCBDZXJ0aWZpY2F0ZTAdBgNVHQ4EFgQUBHKMEg2WLJxvCJswUK0U
bN+TAGMwHwYDVR0jBBgwFoAUz2QtFg4vN2LoCPemaZeYD1m3lH8wDQYJKoZIhvcN
AQEFBQADgYEAUWnmjvfRxbjEKmluEWr1noPt8+31ZhBvIYRfygN21e/DqsVzNbNr
7bbmki7KtgYxggZ3c2gSpnC2TD7Q7TLNp8gZ4x43gbE0BP5g85AFcyPn/63EvC5w
WAyN4F/4TyH7cr3CSfXQ7hMyd6ZCvnu3sT6tMFSZfRoCtFGc8sAJpg0=
-----END CERTIFICATE-----',
    };

    $Certificates{otrsrdCA} = {
        Hash        => '16765241',
        Fingerprint => '4C:73:63:FB:26:91:CF:5B:E6:51:5C:5F:4B:06:BF:AB:02:6C:F2:B8',
        String =>
            '-----BEGIN CERTIFICATE-----
MIIDBjCCAm+gAwIBAgIBAjANBgkqhkiG9w0BAQUFADCBhzELMAkGA1UEBhMCTVgx
EDAOBgNVBAgTB0phbGlzY28xFDASBgNVBAcTC0d1YWRhbGFqYXJhMREwDwYDVQQK
EwhPVFJTIExhYjEMMAoGA1UECxQDUiZEMREwDwYDVQQDEwhvdHJzLm9yZzEcMBoG
CSqGSIb3DQEJARYNb3Ryc0B0ZXN0LmNvbTAeFw0xMTA1MTIyMTUxMzhaFw0xMjA1
MTEyMTUxMzhaMIGJMQswCQYDVQQGEwJNWDEQMA4GA1UECBMHSmFsaXNjbzEUMBIG
A1UEBxMLR3VhZGFsYWphcmExETAPBgNVBAoTCE9UUlMgTGFiMQwwCgYDVQQLFANS
JkQxETAPBgNVBAMTCG90cnMub3JnMR4wHAYJKoZIhvcNAQkBFg9vdHJzcmRAdGVz
dC5jb20wgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAL/4muYUMzRrPPhs+6/r
2o10hWaQbIIMKOTydTej6hDeWyu/MuNnV25TwjoSwgkHkS451d5JKeP8BBnHMe3s
eWY74tOKQYaT7dRjM3PCvlET3h0H4nJzgQwnpbrkWTwN3mfFdggXizhSUgmQV1CO
cVOiGjNJM0d1H3VYMC+zkItdAgMBAAGjfjB8MAwGA1UdEwQFMAMBAf8wLAYJYIZI
AYb4QgENBB8WHU9wZW5TU0wgR2VuZXJhdGVkIENlcnRpZmljYXRlMB0GA1UdDgQW
BBQlQCdF1j3CaHSd5UeALl0dNErASTAfBgNVHSMEGDAWgBQEcowSDZYsnG8ImzBQ
rRRs35MAYzANBgkqhkiG9w0BAQUFAAOBgQB1b1zKc2zx/hTTtcYbf9wWaibmljPy
nOOBuCE+xfZ4qoZu74gi+aMwi3vt7rBzWSQBzc1OxlxYzHaxHnZdlZnRexQpPKwU
DJWoW6Kn9MfjSqqvJLlNg+5upmv67nUYtrpiU0HhCBkaQAd4Z9etH2cCVK6MpJZS
PexBgADUDM/q9w==
-----END CERTIFICATE-----',
    };

    # add CA certificates to the local cert storage
    for my $Cert ( values %Certificates ) {
        $CryptObject->CertificateAdd(
            Certificate => $Cert->{String},
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

    # add the root CA (dzCA) cert to the trusted certificates path
    $Certificates{dzCA} = {
        Hash        => '8b0cc41f',
        Fingerprint => '8C:8A:07:DA:78:B3:C0:1B:37:5A:9E:47:B8:08:00:33:44:AE:74:F8',
        String =>
            '-----BEGIN CERTIFICATE-----
MIID4zCCA0ygAwIBAgIJAIyAzC4orpb1MA0GCSqGSIb3DQEBBQUAMIGoMQswCQYD
VQQGEwJNWDEQMA4GA1UECBMHSmFsaXNjbzEUMBIGA1UEBxMLR3VhZGFsYWphcmEx
GDAWBgNVBAoTD0RhbmllbCBaYW1vcmFubzEUMBIGA1UECxMLRGV2ZWxvcG1lbnQx
GzAZBgNVBAMTEmRhbmllbHphbW9yYW5vLmNvbTEkMCIGCSqGSIb3DQEJARYVZHpA
ZGFuaWVsemFtb3Jhbm8uY29tMB4XDTExMDUxMTIxNTA0OFoXDTE2MDUwOTIxNTA0
OFowgagxCzAJBgNVBAYTAk1YMRAwDgYDVQQIEwdKYWxpc2NvMRQwEgYDVQQHEwtH
dWFkYWxhamFyYTEYMBYGA1UEChMPRGFuaWVsIFphbW9yYW5vMRQwEgYDVQQLEwtE
ZXZlbG9wbWVudDEbMBkGA1UEAxMSZGFuaWVsemFtb3Jhbm8uY29tMSQwIgYJKoZI
hvcNAQkBFhVkekBkYW5pZWx6YW1vcmFuby5jb20wgZ8wDQYJKoZIhvcNAQEBBQAD
gY0AMIGJAoGBAMl1QdY/qvckELLyR+OjqGI30LGXYiJLDL0ntNK24ivXgLNC+HwJ
N8zax09w4Wijv2dgBoPPtnx5y0upQzGNO196Hqsq0J1Jzz5y/w4oM9MpLK5BNKnt
yl7YHi7lUqac4nI15i890lZUXiIWYMFxHhBtCxHS1ghTzNZdWuR9P8c1AgMBAAGj
ggERMIIBDTAdBgNVHQ4EFgQUz2QtFg4vN2LoCPemaZeYD1m3lH8wgd0GA1UdIwSB
1TCB0oAUz2QtFg4vN2LoCPemaZeYD1m3lH+hga6kgaswgagxCzAJBgNVBAYTAk1Y
MRAwDgYDVQQIEwdKYWxpc2NvMRQwEgYDVQQHEwtHdWFkYWxhamFyYTEYMBYGA1UE
ChMPRGFuaWVsIFphbW9yYW5vMRQwEgYDVQQLEwtEZXZlbG9wbWVudDEbMBkGA1UE
AxMSZGFuaWVsemFtb3Jhbm8uY29tMSQwIgYJKoZIhvcNAQkBFhVkekBkYW5pZWx6
YW1vcmFuby5jb22CCQCMgMwuKK6W9TAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEB
BQUAA4GBAJc8P3QOybn5Gi2mqU3bXgS0yolkxx5wPGVnGG9ikwQK8sLsChK/kJVY
S9jQadO9ADKExyC82UclxP4uB1o9HXTpcNeFGU8C7VOY+7Og3P6i3L9Rc1v5jgGw
XLDWddmyvARs76znW/E85MA1qzWuTdj/o2dTRwkJ1cacuQu48N49
-----END CERTIFICATE-----',
    };

    $CryptObject->CertificateAdd(
        Certificate => $Certificates{dzCA}->{String},
    );

    # verify now must works
    %Data = $CryptObject->Verify(
        Message     => $Sign,
        Certificate => "$CertPath/8b0cc41f.0",
    );

    # it must works
    $Self->True(
        $Data{Successful},
        'Sign(), successful certificate chain verification, installed CA root certificate and embedded CA certs',
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
        CAFingerprint   => $Certificates{otrsrdCA}->{Fingerprint},
        UserID          => 1,
    );
    $Self->True(
        $Success,
        'SignerCertRelationAdd(), add relation for certificate',
    );

    $Success = $CryptObject->SignerCertRelationAdd(
        CertFingerprint => $SMIMEUser1Certificate{Fingerprint},
        CAFingerprint   => $Certificates{otrslabCA}->{Fingerprint},
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
        Message     => $Sign,
        Certificate => "$CertPath/8b0cc41f.0",
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

    for my $Number ( 0 .. 3 ) {

        # insert the common content
        $CertInfo{ 'SmimeTest_' . $Number }->{Subject} =
            'C= MX ST= Jalisco L= Guadalajara O= OTRS OU= Research and Development CN= otrs.org emailAddress= smime@test.com';
        $CertInfo{ 'SmimeTest_' . $Number }->{Hash}    = 'b93941b5';
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
            $Counter,
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

}
1;
