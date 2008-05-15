# --
# SMIME.t - SMIME tests
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: SMIME.t,v 1.5 2008-05-15 14:11:20 ot Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

use strict;
use warnings;

use Kernel::System::Crypt;

use vars qw($Self);

my $HomeDir = $Self->{ConfigObject}->Get('Home');

# set config
$Self->{ConfigObject}->Set( Key => 'SMIME', Value => 1 );

#$Self->{ConfigObject}->Set(
#    Key => 'SMIME::CertPath', Value => "$HomeDir/var/ssl/certs"
#);
#$Self->{ConfigObject}->Set(
#    Key => 'SMIME::PrivatePath', Value => "$HomeDir/var/ssl/private"
#);

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
    $Check{'cert-1'} =~ tr{\t}{}d;
    $Check{'cert-2'} =~ tr{\t}{}d;
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
        $Crypted =~ m{Content-Type: application/x-pkcs7-mime;}
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
        Message => $Sign,
    );
    $Self->True(
        $Verify{Successful} || '',
        "#$Count Verify()",
    );
    $Self->True(
        $Verify{SignerCertificate} eq $Check{"cert-$Count"},
        "#$Count Verify()",
    );

    # verify failure on manipulated text
    my $ManipulatedSign = $Sign;
    $ManipulatedSign =~ s{Q}{W}g;
    %Verify = $Self->{CryptObject}->Verify(
        Message => $ManipulatedSign,
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
            $Crypted =~ m{Content-Type: application/x-pkcs7-mime;}
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
            Message => $Signed,
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

# reset config
$Self->{ConfigObject}->Set( Key => 'SMIME', Value => 0 );

1;
