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

use Kernel::Output::HTML::ArticleCheck::SMIME;

# get needed objects
my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');
my $MainObject      = $Kernel::OM->Get('Kernel::System::Main');
my $HTMLUtilsObject = $Kernel::OM->Get('Kernel::System::HTMLUtils');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,

    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Disable email addresses checking.
$Helper->ConfigSettingChange(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my $SendEmails = sub {
    my %Param = @_;

    my $MailQueueObj = $Kernel::OM->Get('Kernel::System::MailQueue');

    # Get last item in the queue.
    my $Items = $MailQueueObj->List();
    my @ToReturn;
    for my $Item (@$Items) {
        $MailQueueObj->Send( %{$Item} );
        push @ToReturn, $Item->{Message};
    }

    # Clean the mail queue
    $MailQueueObj->Delete();

    return @ToReturn;
};

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

# check if openssl is located there
if ( !$OpenSSLBin || !( -e $OpenSSLBin ) ) {

    # maybe it's a mac with macport
    if ( -e '/opt/local/bin/openssl' ) {
        $ConfigObject->Set(
            Key   => 'SMIME::Bin',
            Value => '/opt/local/bin/openssl',
        );
    }

    # Try to guess using system 'which'
    else {    # try to guess
        my $OpenSSLBin = `which openssl`;
        chomp $OpenSSLBin;
        if ($OpenSSLBin) {
            $ConfigObject->Set(
                Key   => 'SMIME::Bin',
                Value => $OpenSSLBin,
            );
        }
    }
}

$OpenSSLBin = $ConfigObject->Get('SMIME::Bin');

# get the openssl version string, e.g. OpenSSL 0.9.8e 23 Feb 2007
my $OpenSSLVersionString = qx{$OpenSSLBin version};
my $OpenSSLMajorVersion;

# get the openssl major version, e.g. 1 for version 1.0.0
if ( $OpenSSLVersionString =~ m{ \A (?: (?: Open|Libre)SSL )? \s* ( \d )  }xmsi ) {
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

my $RandomID = $Helper->GetRandomNumber();

# use Test email backend
my $Success = $ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::Test',
);

$Self->True(
    $Success,
    "Set Email Test backend with true",
);

$Success = $ConfigObject->Set(
    Key   => 'CustomerNotifyJustToRealCustomer',
    Value => '0',
);

# set user id
my $UserID = 1;

# get dynamic field object
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

# create a dynamic field
my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
    Name       => "DFT1$RandomID",
    Label      => 'Description',
    FieldOrder => 9991,
    FieldType  => 'Text',
    ObjectType => 'Ticket',
    Config     => {
        DefaultValue => 'Default',
    },
    ValidID => 1,
    Reorder => 0,
    UserID  => $UserID,
);

my $TestEmailObject = $Kernel::OM->Get('Kernel::System::Email::Test');

$Success = $TestEmailObject->CleanUp();
$Self->True(
    $Success,
    'Initial cleanup',
);

$Self->IsDeeply(
    $TestEmailObject->EmailsGet(),
    [],
    'Test backend empty after initial cleanup',
);

$ConfigObject->Set(
    Key   => 'NotificationSenderEmail',
    Value => 'unittest@example.org',
);

# create crypt object
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
my $Check3Hash       = 'c3857c0d';
my $OTRSRootCAHash   = '1a01713f';
my $OTRSRDCAHash     = '7807c24e';
my $OTRSLabCAHash    = '2fc24258';
my $OTRSUserCertHash = 'eab039b6';

# OpenSSL 1.0.0 hashes
if ($UseNewHashes) {
    $Check1Hash       = 'f62a2257';
    $Check2Hash       = '35c7d865';
    $Check3Hash       = 'a2ba8622';
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
    {
        CertificateName       => 'Check2',
        CertificateHash       => $Check2Hash,
        CertificateFileName   => 'SMIMECertificate-2.asc',
        PrivateKeyFileName    => 'SMIMEPrivateKey-2.asc',
        PrivateSecretFileName => 'SMIMEPrivateKeyPass-2.asc',
    },
    {
        CertificateName       => 'Check3',
        CertificateHash       => $Check3Hash,
        CertificateFileName   => 'SMIMECertificate-3.asc',
        PrivateKeyFileName    => 'SMIMEPrivateKey-3.asc',
        PrivateSecretFileName => 'SMIMEPrivateKeyPass-3.asc',
    },
    {
        CertificateName       => 'OTRSUserCert',
        CertificateHash       => $OTRSUserCertHash,
        CertificateFileName   => 'SMIMECertificate-smimeuser1.crt',
        PrivateKeyFileName    => 'SMIMEPrivateKey-smimeuser1.pem',
        PrivateSecretFileName => 'SMIMEPrivateKeyPass-smimeuser1.crt',
    },
    {
        CertificateName       => 'OTRSLabCA',
        CertificateHash       => $OTRSLabCAHash,
        CertificateFileName   => 'SMIMECACertificate-OTRSLab.crt',
        PrivateKeyFileName    => 'SMIMECAPrivateKey-OTRSLab.pem',
        PrivateSecretFileName => 'SMIMECAPrivateKeyPass-OTRSLab.crt',
    },
    {
        CertificateName       => 'OTRSRDCA',
        CertificateHash       => $OTRSRDCAHash,
        CertificateFileName   => 'SMIMECACertificate-OTRSRD.crt',
        PrivateKeyFileName    => 'SMIMECAPrivateKey-OTRSRD.pem',
        PrivateSecretFileName => 'SMIMECAPrivateKeyPass-OTRSRD.crt',
    },
    {
        CertificateName       => 'OTRSRootCA',
        CertificateHash       => $OTRSRootCAHash,
        CertificateFileName   => 'SMIMECACertificate-OTRSRoot.crt',
        PrivateKeyFileName    => 'SMIMECAPrivateKey-OTRSRoot.pem',
        PrivateSecretFileName => 'SMIMECAPrivateKeyPass-OTRSRoot.crt',
    },
);

# add chain certificates
for my $Certificate (@Certificates) {

    # add certificate ...
    my $CertString = $MainObject->FileRead(
        Directory => $ConfigObject->Get('Home') . "/scripts/test/sample/SMIME/",
        Filename  => $Certificate->{CertificateFileName},
    );
    my %Result = $SMIMEObject->CertificateAdd( Certificate => ${$CertString} );
    $Self->True(
        $Result{Successful} || '',
        "#$Certificate->{CertificateName} CertificateAdd() - $Result{Message}",
    );

    # add private key
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

# add system address
my $SystemAddressID = $Kernel::OM->Get('Kernel::System::SystemAddress')->SystemAddressAdd(
    Name     => 'unittest3@example.org',
    Realname => 'unit test',
    ValidID  => 1,
    QueueID  => 1,
    Comment  => 'Some Comment',
    UserID   => 1,
);
$Self->True(
    $SystemAddressID,
    'SystemAddressAdd()',
);

my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

# set the escalation into the future
my %Queue = $QueueObject->QueueGet(
    ID     => 1,
    UserID => $UserID,
);
my $QueueUpdate = $QueueObject->QueueUpdate(
    %Queue,
    SystemAddressID => $SystemAddressID,
    DefaultSignKey  => 'PGP::Detached::' . $Check3Hash . '.0',
    UserID          => $UserID,
);
$Self->True( $QueueUpdate, "QueueUpdate() $Queue{Name}" );

my $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

# create ticket
my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Ticket One Title',
    QueueID      => 1,
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => 'example.com',
    CustomerUser => 'customerOne@example.com',
    OwnerID      => $UserID,
    UserID       => $UserID,
);

# sanity check
$Self->True(
    $TicketID,
    "TicketCreate() successful for Ticket ID $TicketID",
);

my $ArticleID = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Internal')->ArticleCreate(
    TicketID             => $TicketID,
    IsVisibleForCustomer => 1,
    SenderType           => 'customer',
    From                 => 'customerOne@example.com',
    To                   => 'Some Agent A <agent-a@example.com>',
    Subject              => 'some short description',
    Body                 => 'the message text',
    Charset              => 'utf8',
    MimeType             => 'text/plain',
    HistoryType          => 'OwnerUpdate',
    HistoryComment       => 'Some free text!',
    UserID               => $UserID,
);

# sanity check
$Self->True(
    $ArticleID,
    "ArticleCreate() successful for Article ID $ArticleID",
);

# create ticket
my $TicketID2 = $TicketObject->TicketCreate(
    Title        => 'Ticket Two Title',
    QueueID      => 2,
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => 'example.com',
    CustomerUser => 'customerOne@example.com',
    OwnerID      => $UserID,
    UserID       => $UserID,
);

# sanity check
$Self->True(
    $TicketID2,
    "TicketCreate() successful for Ticket ID $TicketID2",
);

my $NotificationEventObject      = $Kernel::OM->Get('Kernel::System::NotificationEvent');
my $EventNotificationEventObject = $Kernel::OM->Get('Kernel::System::Ticket::Event::NotificationEvent');

my @Tests = (
    {
        Name => 'SMIME - No security settings',
        Data => {
            Events         => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientEmail => ['unittest@example.com'],
        },
        Success => 1,
    },
    {
        Name => 'SMIME - not signing method',
        Data => {
            Events                => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientEmail        => ['unittest@example.com'],
            EmailSecuritySettings => ['1'],
            EmailSigningCrypting  => [],
        },
        VerifySignature => 0,
        Success         => 1,
    },
    {
        Name => 'SMIME - send unsigned',
        Data => {
            Events                  => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientEmail          => ['unittest2@example.com'],
            EmailSecuritySettings   => ['1'],
            EmailSigningCrypting    => ['SMIMESign'],
            EmailMissingSigningKeys => ['Send unsigned'],
        },
        UseSecondTicket => 0,
        VerifySignature => 0,
        Success         => 1,
    },
    {
        Name => 'SMIME - send unsigned',
        Data => {
            Events                  => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientEmail          => ['unittest2@example.com'],
            EmailSecuritySettings   => ['1'],
            EmailSigningCrypting    => ['SMIMESign'],
            EmailMissingSigningKeys => ['Send unsigned'],
        },
        UseSecondTicket => 1,
        VerifySignature => 0,
        Success         => 1,
    },
    {
        Name => 'SMIME - send signed',
        Data => {
            Events                => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientEmail        => [ 'unittest@example.com', 'unittest2@example.com' ],
            EmailSecuritySettings => ['1'],
            EmailSigningCrypting  => ['SMIMESign'],
        },
        VerifySignature => 1,
        Success         => 1,
    },
    {
        Name => 'SMIME - send crypted',
        Data => {
            Events                => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientEmail        => ['unittest@example.org'],
            EmailSecuritySettings => ['1'],
            EmailSigningCrypting  => ['SMIMECrypt'],
        },
        VerifyDecryption => 1,
        Success          => 1,
    },
    {
        Name => 'SMIME - send uncrypted',
        Data => {
            Events                   => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientEmail           => ['unittest2@example.com'],
            EmailSecuritySettings    => ['1'],
            EmailSigningCrypting     => ['SMIMECrypt'],
            EmailMissingCryptingKeys => ['Send'],
        },
        VerifyDecryption => 0,
        Success          => 1,
    },
    {
        Name => 'SMIME - skip delivery',
        Data => {
            Events                   => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientEmail           => ['unittes2@example.com'],
            EmailSecuritySettings    => ['1'],
            EmailSigningCrypting     => ['SMIMESignCrypt'],
            EmailMissingCryptingKeys => ['Skip'],
        },
        UseSecondTicket  => 1,
        VerifyDecryption => 0,
        Success          => 0,
    },
    {
        Name         => 'SMIME key expired - skip delivery',
        FixedTimeSet => 1,
        Data         => {
            Events                   => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientEmail           => ['unittest@example.org'],
            EmailSecuritySettings    => ['1'],
            EmailSigningCrypting     => ['SMIMECrypt'],
            EmailMissingCryptingKeys => ['Skip'],
        },
        VerifyDecryption => 0,
        Success          => 0,
    },
    {
        Name         => 'SMIME key expired - send uncrypted',
        FixedTimeSet => 1,
        Data         => {
            Events                   => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientEmail           => ['unittest@example.org'],
            EmailSecuritySettings    => ['1'],
            EmailSigningCrypting     => ['SMIMECrypt'],
            EmailMissingCryptingKeys => ['Send'],
        },
        VerifyDecryption => 0,
        Success          => 1,
    },
    {
        Name         => 'SMIME key expired - skip delivery',
        FixedTimeSet => 1,
        Data         => {
            Events                   => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientEmail           => ['unittest@example.org'],
            EmailSecuritySettings    => ['1'],
            EmailSigningCrypting     => ['SMIMESignCrypt'],
            EmailMissingCryptingKeys => ['Skip'],
        },
        VerifyDecryption => 0,
        Success          => 0,
    },
    {
        Name         => 'SMIME key expired - send uncrypted',
        FixedTimeSet => 1,
        Data         => {
            Events                   => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientEmail           => ['unittest@example.org'],
            EmailSecuritySettings    => ['1'],
            EmailSigningCrypting     => ['SMIMESignCrypt'],
            EmailMissingCryptingKeys => ['Send'],
        },
        VerifyDecryption => 0,
        Success          => 1,
    },

);

my $Count = 0;
my $NotificationID;

my $PostmasterUserID = $ConfigObject->Get('PostmasterUserID') || 1;

TEST:
for my $Test (@Tests) {

    # add transport setting
    $Test->{Data}->{Transports} = ['Email'];

    if ( $Test->{FixedTimeSet} ) {

        # create isolated time environment during test
        $Helper->FixedTimeSet(
            $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => '2026-10-20 00:00:00',
                },
            )->ToEpoch()
        );
    }

    $NotificationID = $NotificationEventObject->NotificationAdd(
        Name    => "JobName$Count-$RandomID",
        Comment => 'An optional comment',
        Data    => $Test->{Data},
        Message => {
            en => {
                Subject     => 'JobName',
                Body        => 'JobName <OTRS_TICKET_TicketID> <OTRS_CONFIG_SendmailModule> <OTRS_OWNER_UserFirstname>',
                ContentType => 'text/plain',
            },
            de => {
                Subject     => 'JobName',
                Body        => 'JobName <OTRS_TICKET_TicketID> <OTRS_CONFIG_SendmailModule> <OTRS_OWNER_UserFirstname>',
                ContentType => 'text/plain',
            },
        },
        ValidID => 1,
        UserID  => $UserID,
    );

    # sanity check
    $Self->IsNot(
        $NotificationID,
        undef,
        "$Test->{Name} - NotificationAdd() should not be undef",
    );

    my $UseTicket = ( $Test->{UseSecondTicket} ? $TicketID2 : $TicketID );

    my $Result = $EventNotificationEventObject->Run(
        Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
        Data  => {
            TicketID => $UseTicket,
        },
        Config => {},
        UserID => $UserID,
    );

    $SendEmails->();

    my $Emails = $TestEmailObject->EmailsGet();
    if ( $Test->{Success} ) {

        # sanity check
        $Self->True(
            scalar @{$Emails},
            "$Test->{Name} - Successful sending for Notification ID $NotificationID",
        );
    }
    else {

        # sanity check
        $Self->False(
            scalar @{$Emails},
            "$Test->{Name} - Unsuccessful sending for Notification ID $NotificationID",
        );
    }

    # get last ticket article
    my @Articles = $ArticleObject->ArticleList(
        TicketID => $TicketID,
        OnlyLast => 1,
    );
    my %Article;
    if ( scalar @Articles && $Articles[0] ) {
        %Article = %{ $Articles[0] };
    }
    my $CheckObject = Kernel::Output::HTML::ArticleCheck::SMIME->new(
        ArticleID => $Article{ArticleID},
        UserID    => $UserID,
    );

    my @CheckResult = $CheckObject->Check( Article => \%Article );

    if ( $Test->{VerifySignature} ) {
        my $SignatureVerified =
            grep {
            $_->{SignatureFound} && $_->{Key} eq 'Signed' && $_->{SignatureFound} && $_->{Message}
            } @CheckResult;

        $Self->True(
            $SignatureVerified,
            "$Test->{Name} - Signature verified",
        );
    }

    if ( $Test->{VerifyDecryption} ) {
        my $DecryptionVerified =
            grep { $_->{Successful} && $_->{Key} eq 'Crypted' } @CheckResult;

        $Self->True(
            $DecryptionVerified,
            "$Test->{Name} - Decryption verified",
        );
    }

}
continue {
    # delete notification event
    my $NotificationDelete = $NotificationEventObject->NotificationDelete(
        ID     => $NotificationID,
        UserID => $UserID,
    );

    # sanity check
    $Self->True(
        $NotificationDelete,
        "$Test->{Name} - NotificationDelete() successful for Notification ID $NotificationID",
    );

    $TestEmailObject->CleanUp();

    $Count++;
    undef $NotificationID;
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
