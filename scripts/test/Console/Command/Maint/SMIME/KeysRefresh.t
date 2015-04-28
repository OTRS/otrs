# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use Kernel::System::Crypt::SMIME;
use File::Copy;

use vars (qw($Self));

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# set config
$ConfigObject->Set(
    Key   => 'SMIME',
    Value => 1,
);
$ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::DoNotSendEmail',
);

# check if OpenSSL is located there
if ( !-e $ConfigObject->Get('SMIME::Bin') ) {

    # maybe it's a mac with macport
    if ( -e '/opt/local/bin/openssl' ) {
        $ConfigObject->Set(
            Key   => 'SMIME::Bin',
            Value => '/opt/local/bin/openssl',
        );
    }
}

# get crypt object
my $CryptObject;

eval {
    $CryptObject = Kernel::System::Crypt::SMIME->new();
};

if ( !$CryptObject ) {
    $Self->True(
        1,
        'The system with current configuration does not support SMIME, this test can not continue!'
    );
    return 1;
}

# get current configuration settings
my $OpenSSLBin = $ConfigObject->Get('SMIME::Bin');
my $CertDir    = $ConfigObject->Get('SMIME::CertPath');
my $PrivateDir = $ConfigObject->Get('SMIME::PrivatePath');

# helper function to create a directory
my $CreateDir = sub {
    my $Directory = $_[0];

    if ( !-d $Directory ) {
        File::Path::mkpath( $Directory, 0, 0770 );    ## no critic

        if ( !-d $Directory ) {
            $Self->True(
                0,
                "Failed to create path: $Directory, can not continue!",
            );
            return;
        }
    }
    else {
        $Self->True(
            1,
            "$Directory, already exists, nothing to create!",
        );
    }
    return 1;
};

my $Home = $ConfigObject->Get('Home');

# get new certificates directory
my $NewCertDir = $Home . '/var/tmp/SMIMETest/Certs';

if ( $CertDir eq $NewCertDir ) {
    $Self->True(
        0,
        "SMIME Certificates directory should not be in $NewCertDir, can not continue!",
    );
}

# create new directory for certificates
my $Success = $CreateDir->($NewCertDir);
return if !$Success;

# get new private directory
my $NewPrivateDir = $ConfigObject->Get('Home') . '/var/tmp/SMIMETest/Private';

if ( $PrivateDir eq $NewPrivateDir ) {
    $Self->True(
        0,
        "SMIME Private directory should not be in $NewPrivateDir, can not continue!",
    );
}

# create new directory for private keys
$Success = $CreateDir->($NewPrivateDir);
return if !$Success;

# set a new certificate private key and secret files
for my $Type (qw(Certificate PrivateKey PrivateKeyPass)) {

    my $FileName = 'SMIME' . $Type . '-1.asc';

    my $SourcePath = $Home . '/scripts/test/sample/SMIME/' . $FileName;

    my $TargetPath = $NewPrivateDir;

    if ( $Type eq 'Certificate' ) {
        $TargetPath = $NewCertDir;
    }

    $TargetPath .= "/123.0";

    if ( $Type eq 'PrivateKeyPass' ) {
        $TargetPath .= '.P';
    }

    my $Success = copy( $SourcePath, $TargetPath );
    if ( !$Success ) {
        $Self->True(
            0,
            "Could not copy file from $SourcePath to $TargetPath, can not continue!",
        );
    }
}

# helper function to set a config setting
my $ConfigSet = sub {
    my %Param = @_;
    $ConfigObject->Set(
        Key   => $Param{Key},
        Value => $Param{Value},
    );

    my $Value = $ConfigObject->Get( $Param{Key} );

    $Self->Is(
        $Value,
        $Param{Value},
        "$Param{TestName} - Config Set() for key $Param{Key}"
    );
};

# disable SMIME by default
$ConfigSet->(
    Key      => 'SMIME',
    Value    => 0,
    TestName => 'Init'
);

my $RandomName = $Kernel::OM->Get('Kernel::System::UnitTest::Helper')->GetRandomID();

my @Tests = (
    {
        Name     => 'Empty Options (disabled)',
        Options  => [],
        ExitCode => 1,
    },
    {
        Name      => 'Wrong OpenSSL Binary',
        Options   => [ '--verbose', '--force' ],
        ConfigSet => [
            {
                Key   => 'SMIME::Bin',
                Value => $RandomName,
            },
        ],
        ExitCode => 1,
    },
    {
        Name      => 'Wrong Certificate Directory',
        Options   => [ '--verbose', '--force' ],
        ConfigSet => [
            {
                Key   => 'SMIME::Bin',
                Value => $OpenSSLBin,
            },
            {
                Key   => 'SMIME::CertPath',
                Value => $RandomName,
            },
        ],
        ExitCode => 1,
    },
    {
        Name      => 'Wrong Private Directory',
        Options   => [ '--verbose', '--force' ],
        ConfigSet => [
            {
                Key   => 'SMIME::Bin',
                Value => $OpenSSLBin,
            },
            {
                Key   => 'SMIME::CertPath',
                Value => $NewCertDir,
            },
            {
                Key   => 'SMIME::PrivatePath',
                Value => $RandomName,
            },
        ],
        ExitCode => 1,
    },
    {
        Name      => 'Correct Call long detail level (need to use force)',
        Options   => [ '--verbose', '--force' ],
        ConfigSet => [
            {
                Key   => 'SMIME::Bin',
                Value => $OpenSSLBin,
            },
            {
                Key   => 'SMIME::CertPath',
                Value => $NewCertDir,
            },
            {
                Key   => 'SMIME::PrivatePath',
                Value => $NewPrivateDir,
            },
        ],
        ExitCode => 0,
    },
    {
        Name      => 'Correct Call short detail level (need to use force)',
        Options   => ['--force'],
        ConfigSet => [
            {
                Key   => 'SMIME::Bin',
                Value => $OpenSSLBin,
            },
            {
                Key   => 'SMIME::CertPath',
                Value => $NewCertDir,
            },
            {
                Key   => 'SMIME::PrivatePath',
                Value => $NewPrivateDir,
            },
        ],
        ExitCode => 0,
    },
    {
        Name      => 'Correct Call long detail level (no need to use force)',
        Options   => ['--verbose'],
        ConfigSet => [
            {
                Key   => 'SMIME',
                Value => 1,
            },
            {
                Key   => 'SMIME::Bin',
                Value => $OpenSSLBin,
            },
            {
                Key   => 'SMIME::CertPath',
                Value => $NewCertDir,
            },
            {
                Key   => 'SMIME::PrivatePath',
                Value => $NewPrivateDir,
            },
        ],
        ExitCode => 0,
    },
);

# get needed objects
my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::SMIME::KeysRefresh');
my $MainObject    = $Kernel::OM->Get('Kernel::System::Main');

# helper function to check files
my $FileCheck = sub {
    my %Param = @_;

    for my $Location (
        "$NewCertDir/$Param{Hash}.0",
        "$NewPrivateDir/$Param{Hash}.0",
        "$NewPrivateDir/$Param{Hash}.0.P",
        )
    {

        my $Success = -e $Location ? 1 : 0;

        if ( $Param{TestType} eq 'True' ) {
            $Self->True(
                $Success,
                "$Param{TestName} file $Location exists with true",
            );
        }
        else {
            $Self->False(
                $Success,
                "$Param{TestName} file $Location exists with false",
            );
        }
    }
};

my $FileMove = sub {
    my %Param = @_;

    my @MoveList = (
        {
            SourcePath => $NewCertDir . "/$Param{Hash}.0",
            TargetPath => $NewCertDir . "/$RandomName.0",
        },
        {
            SourcePath => $NewPrivateDir . "/$Param{Hash}.0",
            TargetPath => $NewPrivateDir . "/$RandomName.0",
        },
        {
            SourcePath => $NewPrivateDir . "/$Param{Hash}.0.P",
            TargetPath => $NewPrivateDir . "/$RandomName.0.P",
        },
    );

    for my $Move (@MoveList) {

        move( $Move->{SourcePath}, $Move->{TargetPath} );

        my $Success = -e $Move->{TargetPath} ? 1 : 0;
        $Self->True(
            $Success,
            "$Param{TestName} renamed file $Move->{SourcePath} to $Move->{TargetPath} with true",
        );

    }
};

for my $Test (@Tests) {

    if ( $Test->{ConfigSet} ) {
        for my $Setting ( @{ $Test->{ConfigSet} } ) {
            $ConfigSet->(
                %{$Setting},
                TestName => $Test->{Name},
            );
        }
    }

    my %CertificateAttributes;

    if ( !$Test->{ExitCode} ) {

        my $CryptObject;
        eval {
            $CryptObject = Kernel::System::Crypt::SMIME->new();
        };

        my $ContentSCALARRef = $MainObject->FileRead(
            Location => $Home . '/scripts/test/sample/SMIME/SMIMECertificate-1.asc',
        );

        %CertificateAttributes = $CryptObject->CertificateAttributes(
            Certificate => ${$ContentSCALARRef},
        );

        # files with the correct hash should not be in the directories
        $FileCheck->(
            Hash     => $CertificateAttributes{Hash},
            TestType => 'False',
            TestName => $Test->{Name},
        );
    }

    my $ExitCode = $CommandObject->Execute( @{ $Test->{Options} } );

    $Self->Is(
        $ExitCode,
        $Test->{ExitCode},
        "$Test->{Name} - Exit Code",
    );

    if ( !$ExitCode ) {

        # files with the correct hash must be in the directories
        $FileCheck->(
            Hash     => $CertificateAttributes{Hash},
            TestType => 'True',
            TestName => $Test->{Name},
        );

        # rename files for next execution
        $FileMove->(
            Hash     => $CertificateAttributes{Hash},
            TestName => $Test->{Name},
        );
    }
}

# cleanup
$Success = File::Path::rmtree( $Home . '/var/tmp/SMIMETest' );
$Self->True(
    $Success,
    'Removed temporary Certificates and Private Keys root directory with true',
);

1;
