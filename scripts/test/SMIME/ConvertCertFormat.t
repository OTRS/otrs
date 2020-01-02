# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));
use File::Path qw(mkpath rmtree);

use Devel::Peek;

use Kernel::System::Crypt::SMIME;

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

my $HomeDir = $ConfigObject->Get('Home');

# create directory for certificates and private keys
my $CertPath    = $ConfigObject->Get('Home') . "/var/tmp/certs";
my $PrivatePath = $ConfigObject->Get('Home') . "/var/tmp/private";
mkpath( [$CertPath],    0, 0770 );    ## no critic
mkpath( [$PrivatePath], 0, 0770 );    ## no critic

# set SMIME paths
$ConfigObject->Set(
    Key   => 'SMIME::CertPath',
    Value => $CertPath,
);
$ConfigObject->Set(
    Key   => 'SMIME::PrivatePath',
    Value => $PrivatePath,
);

my $OpenSSLBin = $ConfigObject->Get('SMIME::Bin');

# set config
$ConfigObject->Set(
    Key   => 'SMIME',
    Value => 1,
);
$ConfigObject->Set(
    Key   => 'SMIME::FetchFromCustomer',
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

my $SMIMEObject = $Kernel::OM->Get('Kernel::System::Crypt::SMIME');

if ( !$SMIMEObject ) {
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
    elsif ( !-w $CertPath ) {
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

=item $CertificateSearch->()

searching for unittest-added certificates
returns found certificates with attributes

    my $Result = $CertificateSearch->();

Returns:
    same return as $Kernel::OM->Get('Kernel::System::Crypt::SMIME')->CertificateSearch(
        Search => 'SearchString'
    );

=cut

my $CertificateSearch = sub {
    my ( $Self, %Param ) = @_;

    my @Result;
    my $SMIMEObject = $Kernel::OM->Get('Kernel::System::Crypt::SMIME');
    for my $SearchString ( ( '@example.org', 'smimeuser1@test.com' ) ) {
        push @Result, $SMIMEObject->CertificateSearch(
            Search => $SearchString,
        );
    }

    return @Result;
};

# delete all before running
my @PreRunSearchResult = $CertificateSearch->();

for my $Cert (@PreRunSearchResult) {
    $SMIMEObject->CertificateRemove(
        Filename => $Cert->{Filename},
    );
}

# All certificates for testing
my @Certificates = (
    {
        CertificateName      => 'Check1',
        CertificateFileName1 => 'SMIMECertificate-1.asc',
        CertificateFileName2 => 'SMIMECertificate-1.p7b',
        CertificateFileName3 => 'SMIMECertificate-1.der',
        CertificateFileName4 => 'SMIMECertificate-1.pfx',
        CertificatePassFile  => 'SMIMEPrivateKeyPass-1.asc',
        Success              => 1
    },
    {
        CertificateName      => 'Check2',
        CertificateFileName1 => 'SMIMECertificate-2.asc',
        CertificateFileName2 => 'SMIMECertificate-2.p7b',
        CertificateFileName3 => 'SMIMECertificate-2.der',
        CertificateFileName4 => 'SMIMECertificate-2.pfx',
        CertificatePassFile  => 'SMIMEPrivateKeyPass-2.asc',
        Success              => 1
    },
    {
        CertificateName      => 'Check3',
        CertificateFileName1 => 'SMIMECertificate-3.asc',
        CertificateFileName2 => 'SMIMECertificate-3.p7b',
        CertificateFileName3 => 'SMIMECertificate-3.der',
        CertificateFileName4 => 'SMIMECertificate-3.pfx',
        CertificatePassFile  => 'SMIMEPrivateKeyPass-3.asc',
        Success              => 1
    },
    {
        CertificateName      => 'OTRSUserCert',
        CertificateFileName1 => 'SMIMECertificate-smimeuser1.crt',
        CertificateFileName2 => 'SMIMECertificate-smimeuser1.p7b',
        CertificateFileName3 => 'SMIMECertificate-smimeuser1.der',
        CertificateFileName4 => 'SMIMECertificate-smimeuser1.pfx',
        CertificatePassFile  => 'SMIMEPrivateKeyPass-smimeuser1.crt',
        Success              => 0                                       # Test with passfile will fail (wrong password)
    },
);

=item $CertificationConversionTest->()

do the testing
- read
- convert
- search-empty
- add
- search-filled
- remove
returns Certificate String converted to PEM-format

    my $Result = $CertificationConversionTest->(
        $CertificateString,     # filename
        'PEM',                  # format             # PEM, PKCS#7/P7B, DER, PFX
        'PemCertificateString', # CheckString        # (optional), FilereadString if empty
        'Path/to/PassFile'      # pass-filename      # (optional) only needed for PFX
    );

Returns:
    $Result =
    "-----BEGIN CERTIFICATE-----
    MIIEXjCCA0agAwIBAgIJAPIBQyBe/HbpMA0GCSqGSIb3DQEBBQUAMHwxCzAJBgNV
    ...
    nj2wbQO4KjM12YLUuvahk5se
    -----END CERTIFICATE-----
    ";

=cut

my $CertificationConversionTest = sub {
    my ( $Success, $CertificateFileName, $Format, $CheckString, $CertificatePassFile ) = @_;

    return if !defined $Success;
    return if !$CertificateFileName;
    return if !$Format;

    # create objects
    my $MainObject  = $Kernel::OM->Get('Kernel::System::Main');
    my $SMIMEObject = $Kernel::OM->Get('Kernel::System::Crypt::SMIME');

    # read
    my $CertString = $MainObject->FileRead(
        Directory => $ConfigObject->Get('Home') . "/scripts/test/sample/SMIME/",
        Filename  => $CertificateFileName,
    );
    $CheckString ||= ${$CertString};

    my $FormatedCertificate;

    # convert
    # no passfile
    if ( !$CertificatePassFile ) {
        $FormatedCertificate = $SMIMEObject->ConvertCertFormat( String => ${$CertString} );

        # Remove any not needed information for easy compare.
        if ( $FormatedCertificate && $FormatedCertificate !~ m{\A-----BEGIN} ) {
            $FormatedCertificate = substr( $FormatedCertificate, index( $FormatedCertificate, '-----BEGIN' ), -1 );
        }
        $Self->Is(
            $FormatedCertificate,
            $CheckString,
            "#$CertificateFileName ConvertCertFormat() was successful for $Format-format",
        );
    }

    # passfile needed
    else {
        my $Pass = $MainObject->FileRead(
            Directory => $ConfigObject->Get('Home') . "/scripts/test/sample/SMIME/",
            Filename  => $CertificatePassFile,
        );
        $FormatedCertificate = $SMIMEObject->ConvertCertFormat(
            String     => ${$CertString},
            Passphrase => ${$Pass}
        );

        # Remove any not needed information for easy compare.
        if ( $FormatedCertificate && $FormatedCertificate !~ m{\A-----BEGIN} ) {
            $FormatedCertificate
                = substr( $FormatedCertificate, index( $FormatedCertificate, '-----BEGIN' ), -1 ) . "\n";
        }

        if ($Success) {
            $Self->Is(
                $FormatedCertificate,
                $CheckString,
                "#$CertificateFileName ConvertCertFormat() was successful for $Format-format",
            );
        }
        else {
            $Self->Is(
                $FormatedCertificate,
                undef,
                "#$CertificateFileName ConvertCertFormat() was UNsuccessful for $Format-format (invalid password?)",
            );
        }
    }

    # search before add
    my @SearchResult = $CertificateSearch->();
    $Self->False(
        $SearchResult[0] || '',
        "#$CertificateFileName CertificateSearch()-before was empty",
    );

    # add
    if ($FormatedCertificate) {
        my %AddResult = $SMIMEObject->CertificateAdd( Certificate => $FormatedCertificate );
        $Self->True(
            $AddResult{Successful} || '',
            "#$CertificateFileName CertificateAdd() - $AddResult{Message}",
        );

        # search after add
        @SearchResult = $CertificateSearch->();
        $Self->True(
            $SearchResult[0] || '',
            "#$CertificateFileName CertificateSearch()-after was NOT empty",
        );
    }

    # remove
    for my $Cert (@SearchResult) {
        my %Result = $SMIMEObject->CertificateRemove(
            Filename => $Cert->{Filename},
        );

        $Self->Is(
            $Result{Successful},
            1,
            "#$CertificateFileName CertificateRemove() - $Result{Message}",
        );
    }
    return $FormatedCertificate;

};

# check certificates
for my $Certificate (@Certificates) {

    #
    # PEM check
    #
    my $PemCertificate = $CertificationConversionTest->(
        $Certificate->{Success},                 # Success
        $Certificate->{CertificateFileName1},    # Filename
        'PEM'                                    # format
    );

    #
    # P7B check
    #
    $CertificationConversionTest->(
        $Certificate->{Success},                 # Success
        $Certificate->{CertificateFileName2},    # filename
        'PKCS#7/P7B',                            # format
        $PemCertificate                          # checkstring
    );

    #
    # DER check
    #
    $CertificationConversionTest->(
        $Certificate->{Success},                 # Success
        $Certificate->{CertificateFileName3},    # filename
        'DER',                                   # format
        $PemCertificate                          # checkstring
    );

    #
    # PFX check
    #
    $CertificationConversionTest->(
        $Certificate->{Success},                 # Success
        $Certificate->{CertificateFileName4},    # filename
        'PFX',                                   # format
        $PemCertificate,                         # checkstring
        $Certificate->{CertificatePassFile}      # pass-filename
    );
}

# delete needed test directories
for my $Directory ( $CertPath, $PrivatePath ) {
    my $Success = rmtree( [$Directory] );
    $Self->True(
        $Success,
        "Directory deleted - '$Directory'",
    );
}

# cleanup is done by RestoreDatabase.

1;
