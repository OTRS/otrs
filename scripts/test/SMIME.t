# --
# SMIME.t - SMIME tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: SMIME.t,v 1.7.2.3 2011-05-19 02:48:49 dz Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use Kernel::System::Crypt;

use vars qw($Self);

my $HomeDir = $Self->{ConfigObject}->Get('Home');

# set config
$Self->{ConfigObject}->Set( Key => 'SMIME', Value => 1 );

my $CertPath = $Self->{ConfigObject}->Get('SMIME::CertPath');

my $OpenSSLBin = $Self->{ConfigObject}->Get('SMIME::Bin');

# get the openssl version string, e.g. OpenSSL 0.9.8e 23 Feb 2007
my $OpenSSLVersionString = qx{$OpenSSLBin version};
my $OpenSSLMajorVersion;

# get the openssl major version, e.g. 1 for version 1.0.0
if ( $OpenSSLVersionString =~ m{ \A (?: OpenSSL )? \s* ( \d )  }xmsi ) {
    $OpenSSLMajorVersion = $1;
}

# check if openssl is located there
if ( !-e $Self->{ConfigObject}->Get('SMIME::Bin') ) {

    # maybe it's a mac with macport
    if ( -e '/opt/local/bin/openssl' ) {
        $Self->{ConfigObject}->Set( Key => 'SMIME::Bin', Value => '/opt/local/bin/openssl' );
    }
}

# create crypt object
$Self->{CryptObject} = Kernel::System::Crypt->new(
    %{$Self},
    CryptType => 'SMIME',
);

if ( !$Self->{CryptObject} ) {
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
            '  C= DE ST= Bayern L= Straubing O= OTRS AG CN= unittest emailAddress= unittest@example.org',
        Hash         => '980a83c7',
        Private      => 'No',
        Serial       => 'serial=D51FC7523893BCFD',
        ShortEndDate => '2012-03-29',
        Type         => 'cert',
        Fingerprint  => 'E1:FB:F1:3E:6B:83:9F:C3:29:8A:3E:C3:19:51:33:1C:73:7F:2C:0B',
        Issuer =>
            'issuer=  /C= DE/ST= Bayern/L= Straubing/O= OTRS AG/CN= unittest/emailAddress= unittest@example.org',
        Email          => 'unittest@example.org',
        StartDate      => 'Feb 19 11:20:56 2008 GMT',
        ShortStartDate => '2008-02-19',
    },
    2 => {
        Modulus =>
            'C37422BAB1D6CDE930ED44E79C4D3BD3BECBD4E391FB80C3FC74B639A926D670FDDF6A75EBC304E42FD83311C64356C3DF4E468484CF0A71CAACA333BB99B1ACF418B72020A4D44FA28DF97F0DC2E8D64A0926673FBAC1F29A669E6F3776601CC27937A3212228856CAB9396923B60998198FFD2BB10E8667C02C66F11BA5787',
        EndDate => 'Mar 29 11:32:20 2012 GMT',
        Subject =>
            '  C= DE ST= Bayern L= Straubing O= OTRS AG CN= unittest2 emailAddress= unittest2@example.org',
        Hash         => '999bcb2f',
        Private      => 'No',
        Serial       => 'serial=9BCC39BD2A958C37',
        ShortEndDate => '2012-03-29',
        Fingerprint  => '3F:EE:1A:D2:E1:29:06:03:BF:AB:18:8C:F4:BA:E0:9C:FD:47:5D:0A',
        Type         => 'cert',
        Issuer =>
            'issuer=  /C= DE/ST= Bayern/L= Straubing/O= OTRS AG/CN= unittest2/emailAddress= unittest2@example.org',
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
    my @Certs = $Self->{CryptObject}->Search(
        Search => $Search{$Count},
    );
    $Self->False(
        $Certs[0] || '',
        "#$Count Search()",
    );

    # add certificate ...
    my $CertString = $Self->{MainObject}->FileRead(
        Directory => $Self->{ConfigObject}->Get('Home') . "/scripts/test/sample/",
        Filename  => "SMIMECertificate-$Count.asc",
    );
    my $Message = $Self->{CryptObject}->CertificateAdd(
        Certificate => ${$CertString},
    );

    $Self->True(
        $Message || '',
        "#$Count CertificateAdd()",
    );

    @Certs = $Self->{CryptObject}->CertificateSearch(
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
        Directory => $Self->{ConfigObject}->Get('Home') . "/scripts/test/sample/",
        Filename  => "SMIMEPrivateKey-$Count.asc",
    );
    my $Secret = $Self->{MainObject}->FileRead(
        Directory => $Self->{ConfigObject}->Get('Home') . "/scripts/test/sample/",
        Filename  => "SMIMEPrivateKeyPass-$Count.asc",
    );
    $Message = $Self->{CryptObject}->PrivateAdd(
        Private => ${$KeyString},
        Secret  => ${$Secret},
    );
    $Self->True(
        $Message || '',
        "#$Count PrivateAdd()",
    );

    my @Keys = $Self->{CryptObject}->PrivateSearch(
        Search => $Search{$Count},
    );

    $Self->True(
        $Keys[0] || '',
        "#$Count PrivateSearch()",
    );

    my $CertificateString = $Self->{CryptObject}->CertificateGet(
        Hash => $Certs[0]->{Hash},
    );
    $Self->True(
        $CertificateString || '',
        "#$Count CertificateGet()",
    );

    my $PrivateKeyString = $Self->{CryptObject}->PrivateGet(
        Hash => $Keys[0]->{Hash},
    );
    $Self->True(
        $PrivateKeyString || '',
        "#$Count PrivateGet()",
    );

    # crypt
    my $Crypted = $Self->{CryptObject}->Crypt(
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
    my %Decrypt = $Self->{CryptObject}->Decrypt(
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
    my $Sign = $Self->{CryptObject}->Sign(
        Message => $TestText,
        Hash    => $Keys[0]->{Hash},
    );
    $Self->True(
        $Sign || '',
        "#$Count Sign()",
    );

    # verify
    my %Verify = $Self->{CryptObject}->Verify(
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
        my %Verify = $Self->{CryptObject}->Verify(
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
    %Verify = $Self->{CryptObject}->Verify(
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
            Directory => $Self->{ConfigObject}->Get('Home') . "/scripts/test/sample/",
            Filename  => "PGP-Test1.$File",
            Mode      => 'binmode',
        );
        my $Reference = ${$Content};
        $Reference =~ s{\n}{\r\n}gsm;

        # crypt
        my $Crypted = $Self->{CryptObject}->Crypt(
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
        my %Decrypt = $Self->{CryptObject}->Decrypt(
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
        my $Signed = $Self->{CryptObject}->Sign(
            Message => $Reference,
            Hash    => $Keys[0]->{Hash},
        );
        $Self->True(
            $Signed || '',
            "#$Count Sign() .$File",
        );

        # verify
        my %Verify = $Self->{CryptObject}->Verify(
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
    my @Keys = $Self->{CryptObject}->Search(
        Search => $Search{$Count},
    );
    $Self->True(
        $Keys[0] || '',
        "#$Count Search()",
    );
    my $PrivateRemoved = $Self->{CryptObject}->PrivateRemove(
        Hash => $Keys[0]->{Hash},
    );
    $Self->True(
        $PrivateRemoved || '',
        "#$Count PrivateRemove()",
    );

    my $CertificateRemoved = $Self->{CryptObject}->CertificateRemove(
        Hash => $Keys[0]->{Hash},
    );
    $Self->True(
        $CertificateRemoved || '',
        "#$Count CertificateRemove()",
    );

    @Keys = $Self->{CryptObject}->Search(
        Search => $Search{$Count},
    );
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

    $Self->{CryptObject}->CertificateAdd(
        Certificate => $SMIMEUser1Certificate{String},
    );

    $Self->{CryptObject}->PrivateAdd(
        Private => $SMIMEUser1Certificate{PrivateString},
        Secret  => $SMIMEUser1Certificate{PrivateSecret},
    );

    # sign a message with smimeuser1
    my $Message =
        'This is a signed message to sign, and verification must pass a certificate chain validation. -dz';

    my $PrivateKeyHash = '051d6705';
    my $Sign           = $Self->{CryptObject}->Sign(
        Message => $Message,
        Hash    => $PrivateKeyHash,
    );

    # verify it
    my %Data = $Self->{CryptObject}->Verify( Message => $Sign, );

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
        $Self->{CryptObject}->CertificateAdd(
            Certificate => $Cert->{String},
        );
    }

    # sign a message with smimeuser1 cert and embed all the  needed certificates
    my @CACertHash = ( "$Certificates{otrslabCA}->{Hash}", "$Certificates{otrsrdCA}->{Hash}" );
    $Sign = $Self->{CryptObject}->Sign(
        Message => $Message,
        Hash    => $PrivateKeyHash,
        CACert  => \@CACertHash,
    );

    # verify must fail not root cert added to the trusted cert path
    %Data = $Self->{CryptObject}->Verify( Message => $Sign, );

    # it must fail
    $Self->False(
        $Data{Successful},
        'Sign(), failed certificate chain verification, not installed CA root certificate',
    );

    # add the root CA (dzCA) cert to the trusted certificates path
    $Certificates{dzCA} = {
        Hash => '8b0cc41f',
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

    $Self->{CryptObject}->CertificateAdd(
        Certificate => $Certificates{dzCA}->{String},
    );

    # verify now must works
    %Data = $Self->{CryptObject}->Verify(
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
    my $Success = $Self->{CryptObject}->SignerCertRelationAdd(
        CertFingerprint => 'XX:XX:XX:XX:XX:XX:XX:XX:XX:XX',
        CAFingerprint   => 'XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:',
        UserID          => 1,
    );
    $Self->False(
        $Success,
        'SignerCertRelationAdd(), fail, wrong cert fingerprint',
    );

    # get all relations for a certificate
    $Success = $Self->{CryptObject}->SignerCertRelationGet(
        CertFingerprint => 'XX:XX:XX:XX:XX:XX:XX:XX:XX:XX',
    );
    $Self->False(
        $Success,
        'SignerCertRelationGet(), fail, wrong cert fingerprint',
    );

    # get one relation by ID
    $Success = $Self->{CryptObject}->SignerCertRelationGet(
        ID => '9999999',
    );
    $Self->False(
        $Success,
        'SignerCertRelationGet(), fail, wrong ID',
    );

    # true cert
    # add relation
    $Success = $Self->{CryptObject}->SignerCertRelationAdd(
        CertFingerprint => $SMIMEUser1Certificate{Fingerprint},
        CAFingerprint   => $Certificates{otrsrdCA}->{Fingerprint},
        UserID          => 1,
    );
    $Self->True(
        $Success,
        'SignerCertRelationAdd(), add relation for certificate',
    );

    $Success = $Self->{CryptObject}->SignerCertRelationAdd(
        CertFingerprint => $SMIMEUser1Certificate{Fingerprint},
        CAFingerprint   => $Certificates{otrslabCA}->{Fingerprint},
        UserID          => 1,
    );
    $Self->True(
        $Success,
        'SignerCertRelationAdd(), add relation for certificate',
    );

# sign a message after relations added not send CA certs now should be taken automatically by the sign function
    $Sign = $Self->{CryptObject}->Sign(
        Message => $Message,
        Hash    => $PrivateKeyHash,
    );

    # verify now must works
    %Data = $Self->{CryptObject}->Verify(
        Message     => $Sign,
        Certificate => "$CertPath/8b0cc41f.0",
    );

    # it must works
    $Self->True(
        $Data{Successful},
        'Sign(), successful certificate chain verification, signed using stored relations',
    );

    # get all relations for a certificate
    my @CertResults = $Self->{CryptObject}->SignerCertRelationGet(
        CertFingerprint => $SMIMEUser1Certificate{Fingerprint},
    );
    $Self->Is(
        scalar @CertResults,
        2,
        'SignerCertRelationGet(), get all certificate relations',
    );

    # get one relation by ID
    $Success = $Self->{CryptObject}->SignerCertRelationGet(
        ID => $CertResults[0]->{ID},
    );
    $Self->True(
        $Success,
        'SignerCertRelationGet(), get one relation by id',
    );

    # exists function
    $Success = $Self->{CryptObject}->SignerCertRelationExists(
        CertFingerprint => $CertResults[0]->{CertFingerprint},
        CAFingerprint   => $CertResults[0]->{CAFingerprint},
    );
    $Self->True(
        $Success,
        'SignerCertRelationExists(), check relation by fingerprints',
    );

    $Success = $Self->{CryptObject}->SignerCertRelationExists(
        ID => $CertResults[0]->{ID},
    );
    $Self->True(
        $Success,
        'SignerCertRelationExists(), check relation by ID',
    );

    # delete one relation by ID
    $Self->{CryptObject}->SignerCertRelationDelete(
        ID     => $CertResults[0]->{ID},
        UserID => 1,
    );
    $Success = $Self->{CryptObject}->SignerCertRelationExists(
        ID => $CertResults[0]->{ID},
    );
    $Self->False(
        $Success,
        'SignerCertRelationDelete(), by ID',
    );

    # delete all relations for a certificate
    $Self->{CryptObject}->SignerCertRelationDelete(
        CertFingerprint => $SMIMEUser1Certificate{Fingerprint},
        UserID          => 1,
    );
    $Success = $Self->{CryptObject}->SignerCertRelationExists(
        ID => $CertResults[1]->{ID},
    );
    $Self->False(
        $Success,
        'SignerCertRelationDelete(), delete all relations',
    );

    # delete certificates
    $Self->{CryptObject}->CertificateRemove(
        Hash => $SMIMEUser1Certificate{Hash},
    );

    $Self->{CryptObject}->PrivateRemove(
        Hash => $SMIMEUser1Certificate{Hash},
    );

    for my $Cert ( values %Certificates ) {
        $Self->{CryptObject}->CertificateRemove(
            Hash => $Cert->{Hash},
        );
    }

}

# reset config
$Self->{ConfigObject}->Set( Key => 'SMIME', Value => 0 );

1;
