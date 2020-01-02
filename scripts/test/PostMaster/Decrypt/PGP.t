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

use Kernel::System::PostMaster;

# Get helper object.
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Get config object.
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# Set config.
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
    Value => { '04A17B7A' => 'somepass' },
);

$ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::DoNotSendEmail',
);

# Check if GPG is located there.
if ( !-e $ConfigObject->Get('PGP::Bin') ) {

    if ( -e '/usr/bin/gpg' ) {
        $ConfigObject->Set(
            Key   => 'PGP::Bin',
            Value => '/usr/bin/gpg'
        );
    }

    elsif ( -e '/usr/local/bin/gpg' ) {
        $ConfigObject->Set(
            Key   => 'PGP::Bin',
            Value => '/usr/local/bin/gpg'
        );
    }

    # Maybe it's a mac with mac ports.
    elsif ( -e '/opt/local/bin/gpg' ) {
        $ConfigObject->Set(
            Key   => 'PGP::Bin',
            Value => '/opt/local/bin/gpg'
        );
    }
}

# Create local crypt object.
my $PGPObject = $Kernel::OM->Get('Kernel::System::Crypt::PGP');

if ( !$PGPObject ) {
    print STDERR "NOTICE: No PGP support!\n";
    return;
}

# Make some preparations
my %Search = (
    1 => 'unittest@example.com',
    2 => 'unittest2@example.com',
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
    2 => {
        Type             => 'pub',
        Identifier       => 'UnitTest2 <unittest2@example.com>',
        Bit              => '1024',
        Key              => 'F0974D10',
        KeyPrivate       => '8593EAE2',
        Created          => '2007-08-21',
        Expires          => '2037-08-13',
        Fingerprint      => '36E9 9F7F AD76 6405 CBE1  BB42 F533 1A46 F097 4D10',
        FingerprintShort => '36E99F7FAD766405CBE1BB42F5331A46F0974D10',
    },
);

# Get main object.
my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

# Add PGP keys and perform sanity check.
for my $Count ( 1 .. 2 ) {

    my @Keys = $PGPObject->KeySearch(
        Search => $Search{$Count},
    );

    $Self->False(
        $Keys[0] || '',
        "Key:$Count - KeySearch()",
    );

    # Get keys.
    my $KeyString = $MainObject->FileRead(
        Directory => $ConfigObject->Get('Home') . "/scripts/test/sample/Crypt/",
        Filename  => "PGPPrivateKey-$Count.asc",
    );
    my $Message = $PGPObject->KeyAdd(
        Key => ${$KeyString},
    );
    $Self->True(
        $Message || '',
        "Key:$Count - KeyAdd()",
    );

    @Keys = $PGPObject->KeySearch(
        Search => $Search{$Count},
    );

    $Self->True(
        $Keys[0] || '',
        "Key:$Count - KeySearch()",
    );
    for my $ID (qw(Type Identifier Bit Key KeyPrivate Created Expires Fingerprint FingerprintShort))
    {
        $Self->Is(
            $Keys[0]->{$ID} || '',
            $Check{$Count}->{$ID},
            "Key:$Count - KeySearch() - $ID",
        );
    }

    my $PublicKeyString = $PGPObject->PublicKeyGet(
        Key => $Keys[0]->{Key},
    );
    $Self->True(
        $PublicKeyString || '',
        "Key:$Count - PublicKeyGet()",
    );

    my $PrivateKeyString = $PGPObject->SecretKeyGet(
        Key => $Keys[0]->{KeyPrivate},
    );
    $Self->True(
        $PrivateKeyString || '',
        "Key:$Count - SecretKeyGet()",
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
            Value => 'test',
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
    Location => $ConfigObject->Get('Home') . '/scripts/test/sample/PGP/PGP_Test_2013-07-02-1977-2.eml',
    Result   => 'ARRAY',
);

my $CommunicationLogObject = $Kernel::OM->Create(
    'Kernel::System::CommunicationLog',
    ObjectParams => {
        Transport => 'Email',
        Direction => 'Incoming',
    },
);
$CommunicationLogObject->ObjectLogStart( ObjectLogType => 'Message' );

# Part where StoreDecryptedBody is enabled
my $PostMasterObject = Kernel::System::PostMaster->new(
    CommunicationLogObject => $CommunicationLogObject,
    Email                  => $Email,
    Trusted                => 1,
);

$ConfigObject->Set(
    Key   => 'PostmasterDefaultState',
    Value => 'new'
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

my @Return = $PostMasterObject->Run( Queue => '' );

$Self->Is(
    $Return[0] || 0,
    1,
    "Create new ticket",
);

# Get ticket object.
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

$Self->True(
    $Return[1] || 0,
    "Create new ticket (TicketID)",
);

my $TicketID = $Return[1];

my %Ticket = $TicketObject->TicketGet(
    TicketID => $Return[1],
);

my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Email' );

my @ArticleIndex = $ArticleObject->ArticleList(
    TicketID => $Return[1],
    UserID   => 1,
);

$Self->Is(
    $Ticket{Queue},
    'Junk',
    "Ticket created in $Ticket{Queue}",
);

my %FirstArticle = $ArticleBackendObject->ArticleGet( %{ $ArticleIndex[0] } );

my $GetBody = $FirstArticle{Body};
chomp($GetBody);

$Self->Is(
    $GetBody,
    'This is only a test.',
    "Body decrypted $FirstArticle{Body}",
);

# Read email again to make sure that everything is there in the array.
$Email = $MainObject->FileRead(
    Location => $ConfigObject->Get('Home') . '/scripts/test/sample/PGP/PGP_Test_2013-07-02-1977-2.eml',
    Result   => 'ARRAY',
);

# Part where StoreDecryptedBody is disabled
$PostMasterObject = Kernel::System::PostMaster->new(
    CommunicationLogObject => $CommunicationLogObject,
    Email                  => $Email,
    Trusted                => 1,
);

$ConfigObject->Set(
    Key   => 'PostmasterDefaultState',
    Value => 'new'
);

$ConfigObject->Set(
    Key   => 'PostMaster::PreFilterModule',
    Value => {
        '000-DecryptBody' => {
            'Module'             => 'Kernel::System::PostMaster::Filter::Decrypt',
            'StoreDecryptedBody' => '0',
        },
        '000-MatchDBSource' => {
            'Module' => 'Kernel::System::PostMaster::Filter::MatchDBSource',
        }
    }
);

my @ReturnEncrypted = $PostMasterObject->Run( Queue => '' );

$Self->Is(
    $ReturnEncrypted[0] || 0,
    1,
    "Create new ticket",
);

$Self->True(
    $ReturnEncrypted[1] || 0,
    "Create new ticket (TicketID)",
);

$CommunicationLogObject->ObjectLogStop(
    ObjectLogType => 'Message',
    Status        => 'Successful',
);
$CommunicationLogObject->CommunicationStop(
    Status => 'Successful',
);

my $TicketIDEncrypted = $Return[1];

my %TicketEncrypted = $TicketObject->TicketGet(
    TicketID => $ReturnEncrypted[1],
);

my @ArticleIndexEncrypted = $ArticleObject->ArticleList(
    TicketID => $ReturnEncrypted[1],
    UserID   => 1,
);

$Self->Is(
    $Ticket{Queue},
    'Junk',
    "Ticket created in $TicketEncrypted{Queue}",
);

my %FirstArticleEncrypted = $ArticleBackendObject->ArticleGet( %{ $ArticleIndexEncrypted[0] } );

my $GetBodyEncrypted = $FirstArticleEncrypted{Body};

$Self->True(
    scalar $GetBodyEncrypted =~ m{no text message => see attachment},
    "Body was not decrypted",
);

# Delete PGP keys.
for my $Count ( 1 .. 2 ) {
    my @Keys = $PGPObject->KeySearch(
        Search => $Search{$Count},
    );
    $Self->True(
        $Keys[0] || '',
        "Key:$Count - KeySearch()",
    );
    my $DeleteSecretKey = $PGPObject->SecretKeyDelete(
        Key => $Keys[0]->{KeyPrivate},
    );
    $Self->True(
        $DeleteSecretKey || '',
        "Key:$Count - SecretKeyDelete()",
    );

    my $DeletePublicKey = $PGPObject->PublicKeyDelete(
        Key => $Keys[0]->{Key},
    );
    $Self->True(
        $DeletePublicKey || '',
        "Key:$Count - PublicKeyDelete()",
    );

    @Keys = $PGPObject->KeySearch(
        Search => $Search{$Count},
    );
    $Self->False(
        $Keys[0] || '',
        "Key:$Count - KeySearch()",
    );
}

# Cleanup is done by RestoreDatabase.

1;
