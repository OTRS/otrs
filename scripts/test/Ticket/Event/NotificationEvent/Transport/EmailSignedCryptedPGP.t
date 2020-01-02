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

use Kernel::System::EmailParser;
use Kernel::Output::HTML::ArticleCheck::PGP;

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

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

my $PGPPath = $ConfigObject->Get('Home') . "/var/tmp/pgp" . $Helper->GetRandomID();
mkpath( [$PGPPath], 0, 0770 );    ## no critic

# Enable PGP in config.
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'PGP',
    Value => 1,
);

# Set PGP path in config.
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'PGP::Options',
    Value => "--homedir $PGPPath --batch --no-tty --yes",
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

# set PGP config
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
        '667B04B9' => 'somepass',
    },
);

$ConfigObject->Set(
    Key   => 'NotificationSenderEmail',
    Value => 'unittest@example.com',
);

my $PGPBin = $ConfigObject->Get('PGP::Bin');

# check if gpg is located there
if ( !$PGPBin || !( -e $PGPBin ) ) {

    # maybe it's a mac with macport
    if ( -e '/opt/local/bin/gpg' ) {
        $ConfigObject->Set(
            Key   => 'PGP::Bin',
            Value => '/opt/local/bin/gpg'
        );
    }
    else {
        # Try to guess using system 'which'
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

# Cleanup previus test data.
my $Search = 'unittest';
my @Keys   = $PGPObject->PrivateKeySearch(
    Search => $Search,
);

for my $PGPKey (@Keys) {
    $PGPObject->SecretKeyDelete(
        Key => $PGPKey->{Key},
    );
}

@Keys = $PGPObject->PublicKeySearch(
    Search => $Search,
);

for my $PGPKey (@Keys) {
    $PGPObject->PublicKeyDelete(
        Key => $PGPKey->{Key},
    );
}

# make some preparations
my %Search = (
    1 => 'unittest@example.com',
    3 => 'unittest3@example.com',
    4 => 'pgptest@example.com',
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
    4 => {
        Type             => 'pub',
        Identifier       => 'John Smith (Test PGP expired) <pgptest@example.com>',
        Bit              => '1024',
        Key              => '60F1602C',
        KeyPrivate       => '667B04B9',
        Created          => '2018-12-18',
        Expires          => '2018-12-19',
        Fingerprint      => '636A 848B CD5F 5746 43B0  B02A 0AEF 1EDB 60F1 602C',
        FingerprintShort => '636A848BCD5F574643B0B02A0AEF1EDB60F1602C',
    },
);

for my $Item ( sort keys %Check ) {

    # add PGP keys and perform sanity check
    my @Keys;

    # get keys
    my $KeyString = $MainObject->FileRead(
        Directory => $ConfigObject->Get('Home') . "/scripts/test/sample/Crypt/",
        Filename  => "PGPPrivateKey-$Item.asc",
    );
    my $Message = $PGPObject->KeyAdd(
        Key => ${$KeyString},
    );
    $Self->True(
        $Message || '',
        "Key:$Item - KeyAdd()",
    );

    @Keys = $PGPObject->KeySearch(
        Search => $Search{$Item},
    );

    $Self->True(
        $Keys[0] || '',
        "Key:$Item - KeySearch()",
    );
    for my $ID (qw(Type Identifier Bit Key KeyPrivate Created Expires Fingerprint FingerprintShort))
    {
        $Self->Is(
            $Keys[0]->{$ID} || '',
            $Check{$Item}->{$ID},
            "Key:$Item - KeySearch() - $ID",
        );
    }

    my $PublicKeyString = $PGPObject->PublicKeyGet(
        Key => $Keys[0]->{Key},
    );
    $Self->True(
        $PublicKeyString || '',
        "Key:1 - PublicKeyGet()",
    );

    my $PrivateKeyString = $PGPObject->SecretKeyGet(
        Key => $Keys[0]->{KeyPrivate},
    );
    $Self->True(
        $PrivateKeyString || '',
        "Key:1 - SecretKeyGet()",
    );
}

my $SystemAddressObject = $Kernel::OM->Get('Kernel::System::SystemAddress');
my %List                = $SystemAddressObject->SystemAddressList(
    Valid => 0,
);

my $SystemAddressEmail = 'unittest3@example.com';
my $SystemAddressID;
if ( !grep { $_ =~ m/^$SystemAddressEmail$/ } values %List ) {

    $SystemAddressID = $SystemAddressObject->SystemAddressAdd(
        Name     => $SystemAddressEmail,
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
}
else {
    %List            = reverse %List;
    $SystemAddressID = $List{$SystemAddressEmail};
}

my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

# set the escalation into the future
my %Queue = $QueueObject->QueueGet(
    ID     => 1,
    UserID => $UserID,
);
my $QueueUpdate = $QueueObject->QueueUpdate(
    %Queue,
    SystemAddressID => $SystemAddressID,
    DefaultSignKey  => 'PGP::Detached::114D1CB6',
    UserID          => $UserID,
);
$Self->True( $QueueUpdate, "QueueUpdate() $Queue{Name}" );

my $TicketObject          = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject         = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleInternalObject = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Internal');

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

my $ArticleID = $ArticleInternalObject->ArticleCreate(
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
        Name => 'PGP - No security settings',
        Data => {
            Events         => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientEmail => ['unittest@example.com'],
        },
        Success => 1,
    },

    {
        Name => 'PGP - not signing method',
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
        Name => 'PGP - send unsigned',
        Data => {
            Events                  => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientEmail          => ['unittest2@example.com'],
            EmailSecuritySettings   => ['1'],
            EmailSigningCrypting    => ['PGPSign'],
            EmailMissingSigningKeys => ['Send unsigned'],
        },
        UseSecondTicket => 0,
        VerifySignature => 0,
        Success         => 1,
    },
    {
        Name => 'PGP - send unsigned',
        Data => {
            Events                  => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientEmail          => ['unittest2@example.com'],
            EmailSecuritySettings   => ['1'],
            EmailSigningCrypting    => ['PGPSign'],
            EmailMissingSigningKeys => ['Send unsigned'],
        },
        UseSecondTicket => 1,
        VerifySignature => 0,
        Success         => 1,
    },
    {
        Name => 'PGP - send signed',
        Data => {
            Events                => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientEmail        => [ 'unittest@example.com', 'unittest2@example.com' ],
            EmailSecuritySettings => ['1'],
            EmailSigningCrypting  => ['PGPSign'],
        },
        VerifySignature => 1,
        Success         => 1,
    },
    {
        Name => 'PGP - send crypted',
        Data => {
            Events                => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientEmail        => ['unittest@example.com'],
            EmailSecuritySettings => ['1'],
            EmailSigningCrypting  => ['PGPCrypt'],
        },
        VerifyDecryption => 1,
        Success          => 1,
    },
    {
        Name => 'PGP - send uncrypted',
        Data => {
            Events                   => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientEmail           => ['unittest2@example.com'],
            EmailSecuritySettings    => ['1'],
            EmailSigningCrypting     => ['PGPCrypt'],
            EmailMissingCryptingKeys => ['Send'],
        },
        VerifyDecryption => 0,
        Success          => 1,
    },
    {
        Name => 'PGP - skip delivery',
        Data => {
            Events                   => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientEmail           => ['unittes2@example.com'],
            EmailSecuritySettings    => ['1'],
            EmailSigningCrypting     => ['PGPSignCrypt'],
            EmailMissingCryptingKeys => ['Skip'],
        },
        UseSecondTicket  => 1,
        VerifyDecryption => 0,
        Success          => 0,
    },
    {
        Name => 'PGP expired - send uncrypted',
        Data => {
            Events                   => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientEmail           => ['pgptest@example.com'],
            EmailSecuritySettings    => ['1'],
            EmailSigningCrypting     => ['PGPCrypt'],
            EmailMissingCryptingKeys => ['Send'],
        },
        VerifyDecryption => 0,
        Success          => 1,
    },
    {
        Name => 'PGP expired - skip delivery',
        Data => {
            Events                   => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientEmail           => ['pgptest@example.com'],
            EmailSecuritySettings    => ['1'],
            EmailSigningCrypting     => ['PGPCrypt'],
            EmailMissingCryptingKeys => ['Skip'],
        },
        VerifyDecryption => 0,
        Success          => 0,
    },
);

my $Count = 0;
my $NotificationID;

my $PostmasterUserID = $ConfigObject->Get('PostmasterUserID') || 1;

TEST:
for my $Test (@Tests) {

    # add transport setting
    $Test->{Data}->{Transports} = ['Email'];

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

    # get ticket articles
    my @Articles = $ArticleObject->ArticleList(
        TicketID => $TicketID,
        OnlyLast => 1,
    );
    my %Article = %{ $Articles[0] };

    my $CheckObject = Kernel::Output::HTML::ArticleCheck::PGP->new(

        # ArticleID => $LastArticleID,
        ArticleID => $Article{ArticleID},
        UserID    => $UserID,
    );

    my @CheckResult = $CheckObject->Check( Article => \%Article );

    if ( $Test->{VerifySignature} ) {
        my $SignatureVerified =
            grep {
            $_->{Successful} && $_->{Key} eq 'Signed' && $_->{SignatureFound} && $_->{Message}
            } @CheckResult;

        $Self->True(
            $SignatureVerified,
            "$Test->{Name} -  Signature verified",
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

# Remove test PGP path.
$Success = rmtree( [$PGPPath] );
$Self->True(
    $Success,
    "Directory deleted - '$PGPPath'",
);

# cleanup is done by RestoreDatabase.

1;
