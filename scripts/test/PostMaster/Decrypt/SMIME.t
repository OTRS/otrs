# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));
use File::Path qw(mkpath rmtree);

use Kernel::System::PostMaster;

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my $HomeDir = $ConfigObject->Get('Home');

# Create directory for certificates and private keys
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

my $OpenSSLBin = $ConfigObject->Get('SMIME::Bin') || '/usr/bin/openssl';

# Get the OpenSSL version string, e.g. OpenSSL 0.9.8e 23 Feb 2007.
my $OpenSSLVersionString = qx{$OpenSSLBin version};
my $OpenSSLMajorVersion;

# Get the OpenSSL major version, e.g. 1 for version 1.0.0
if ( $OpenSSLVersionString =~ m{ \A (?: (?: Open|Libre)SSL )? \s* ( \d )  }xmsi ) {
    $OpenSSLMajorVersion = $1;
}

# OpenSSL version 1.0.0 uses different hash algorithm... in the future release of OpenSSL this might
#change again in such case a better version detection will be needed.
my $UseNewHashes;
if ( $OpenSSLMajorVersion >= 1 ) {
    $UseNewHashes = 1;
}

# Set config.
$ConfigObject->Set(
    Key   => 'SMIME',
    Value => 1,
);

# Do not really send emails.
$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::Test',
);

# Get test email backed object.
my $TestBackendObject = $Kernel::OM->Get('Kernel::System::Email::Test');

my $Success = $TestBackendObject->CleanUp();
$Self->True(
    $Success,
    'Initial cleanup',
);

$Self->IsDeeply(
    $TestBackendObject->EmailsGet(),
    [],
    'Test backend empty after initial cleanup',
);

# Check if OpenSSL is located there.
if ( !-e $OpenSSLBin ) {

    # maybe it's a mac with mac ports
    if ( -e '/opt/local/bin/openssl' ) {
        $ConfigObject->Set(
            Key   => 'SMIME::Bin',
            Value => '/opt/local/bin/openssl',
        );
    }
}

# Create crypt object.
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

#
# Setup environment
#

# OpenSSL 0.9.x hashes
my $Check1Hash       = '980a83c7';
my $Check2Hash       = '999bcb2f';
my $OTRSRootCAHash   = '1a01713f';
my $OTRSRDCAHash     = '7807c24e';
my $OTRSLabCAHash    = '2fc24258';
my $OTRSUserCertHash = 'eab039b6';

# OpenSSL 1.0.0 hashes
if ($UseNewHashes) {
    $Check1Hash       = 'f62a2257';
    $Check2Hash       = '35c7d865';
    $OTRSRootCAHash   = '7835cf94';
    $OTRSRDCAHash     = 'b5d19fb9';
    $OTRSLabCAHash    = '19545811';
    $OTRSUserCertHash = '4d400195';
}

# certificates
my @Certificates = (
    {
        CertificateName       => 'Check1',
        CertificateHash       => $Check1Hash,
        CertificateFileName   => 'SMIMECertificate-1.asc',
        PrivateKeyFileName    => 'SMIMEPrivateKey-1.asc',
        PrivateSecretFileName => 'SMIMEPrivateKeyPass-1.asc',
    },
);

# Get main object.
my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

my @Crypted;

# Add chain certificates.
for my $Certificate (@Certificates) {

    # Add certificate ...
    my $CertString = $MainObject->FileRead(
        Directory => $ConfigObject->Get('Home') . "/scripts/test/sample/SMIME/",
        Filename  => $Certificate->{CertificateFileName},
    );
    my %Result = $SMIMEObject->CertificateAdd( Certificate => ${$CertString} );
    $Self->True(
        $Result{Successful} || '',
        "#$Certificate->{CertificateName} CertificateAdd() - $Result{Message}",
    );

    # Add private key.
    my $KeyString = $MainObject->FileRead(
        Directory => $ConfigObject->Get('Home') . "/scripts/test/sample/SMIME/",
        Filename  => $Certificate->{PrivateKeyFileName},
    );
    my $Secret = $MainObject->FileRead(
        Directory => $ConfigObject->Get('Home') . "/scripts/test/sample/SMIME/",
        Filename  => $Certificate->{PrivateSecretFileName},
    );
    %Result = $SMIMEObject->PrivateAdd(
        Private => ${$KeyString},
        Secret  => ${$Secret},
    );
    $Self->True(
        $Result{Successful} || '',
        "#$Certificate->{CertificateName} PrivateAdd()",
    );
}

my $PostMasterFilter = $Kernel::OM->Get('Kernel::System::PostMaster::Filter');
my $FilterRand1      = 'filter' . $Helper->GetRandomID();

$PostMasterFilter->FilterAdd(
    Name           => $FilterRand1,
    StopAfterMatch => 0,
    Match          => [
        {
            Key   => 'X-OTRS-BodyDecrypted',
            Value => 'Hi',
        },
    ],
    Set => [
        {
            Key   => 'X-OTRS-Queue',
            Value => 'Junk',
        },
    ],
);

# Read email content (from a file).
my $Email = $MainObject->FileRead(
    Location => $ConfigObject->Get('Home') . '/scripts/test/sample/SMIME/SMIME-Test.eml',
    Result   => 'ARRAY',
);

$ConfigObject->Set(
    Key   => 'PostmasterDefaultState',
    Value => 'new'
);

$ConfigObject->Set(
    Key   => 'PostMaster::PreFilterModule',
    Value => {}
);

$ConfigObject->Set(
    Key   => 'PostMaster::PreFilterModule',
    Value => {
        '000-DecryptBody' => {
            'Module'             => 'Kernel::System::PostMaster::Filter::Decrypt',
            'StoreDecryptedBody' => '1',
        },
        '000-MatchDBSource' => {
            'Module' => 'Kernel::System::PostMaster::Filter::MatchDBSource',
        }
    }
);

my $CommunicationLogObject = $Kernel::OM->Create(
    'Kernel::System::CommunicationLog',
    ObjectParams => {
        Transport => 'Email',
        Direction => 'Incoming',
    },
);
$CommunicationLogObject->ObjectLogStart( ObjectLogType => 'Message' );

my $PostMasterObject = Kernel::System::PostMaster->new(
    CommunicationLogObject => $CommunicationLogObject,
    Email                  => $Email,
    Trusted                => 1,
);

my @Return = $PostMasterObject->Run( Queue => '' );

$Self->Is(
    $Return[0] || 0,
    1,
    "Create new ticket",
);

$Self->True(
    $Return[1] || 0,
    "Create new ticket (TicketID)",
);

$CommunicationLogObject->ObjectLogStop(
    ObjectLogType => 'Message',
    Status        => 'Successful',
);
$CommunicationLogObject->CommunicationStop(
    Status => 'Successful',
);

# Get ticket object.
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

my $TicketID = $Return[1];

my %Ticket = $TicketObject->TicketGet(
    TicketID => $Return[1],
);

my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Email' );
my @ArticleIndex         = $ArticleObject->ArticleList(
    TicketID => $Return[1],
    UserID   => 1,
);

my %FirstArticle = $ArticleBackendObject->ArticleGet( %{ $ArticleIndex[0] } );

$Self->Is(
    $Ticket{Queue},
    'Junk',
    "Ticket created in $Ticket{Queue}",
);

my $GetBody = $FirstArticle{Body};
chomp($GetBody);

$Self->Is(
    $GetBody,
    'Hi',
    "Body decrypted $FirstArticle{Body}",
);

# Delete needed test directories.
for my $Directory ( $CertPath, $PrivatePath ) {
    my $Success = rmtree( [$Directory] );
    $Self->True(
        $Success,
        "Directory deleted - '$Directory'",
    );
}

# Cleanup is done by RestoreDatabase.

1;
