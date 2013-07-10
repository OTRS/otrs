# --
# EmailHandling.t - PGP email handling tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;

use Kernel::Config;
use Kernel::Output::HTML::ArticleCheckPGP;
use Kernel::Output::HTML::Layout;
use Kernel::System::Crypt;
use Kernel::System::Main;
use Kernel::System::Ticket;
use Kernel::System::PostMaster;
use Kernel::System::VariableCheck qw(:all);
use Kernel::System::Web::Request;

# create local config object
my $ConfigObject = Kernel::Config->new();

# set config
$ConfigObject->Set(
    Key   => 'PGP',
    Value => 1,
);
$ConfigObject->Set(
    Key   => 'PGP::Options',
    Value => '--batch --no-tty --yes',
);
$ConfigObject->Set(
    Key => 'PGP::Key::Password',
    Value => { '04A17B7A' => 'somepass' },
);

# check if gpg is located there
if ( !-e $ConfigObject->Get('PGP::Bin') ) {

    # maybe it's a mac with macport
    if ( -e '/opt/local/bin/gpg' ) {
        $ConfigObject->Set( Key => 'PGP::Bin', Value => '/opt/local/bin/gpg' );
    }
}

# create local crypt object
my $CryptObject = Kernel::System::Crypt->new(
    %{$Self},
    ConfigObject => $ConfigObject,
    CryptType    => 'PGP',
);

if ( !$CryptObject ) {
    print STDERR "NOTICE: No PGP support!\n";
    return;
}

# create other objects
my $MainObject = Kernel::System::Main->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

my $ParamObject = Kernel::System::Web::Request->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $LayoutObject = Kernel::Output::HTML::Layout->new(
    %{$Self},
    TicketObject => $TicketObject,
    ParamObject  => $ParamObject,
    ConfigObject => $ConfigObject,
);

# make some preparations
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

# add PGP keys and perform sanity check
for my $Count ( 1 .. 2 ) {
    my @Keys = $CryptObject->KeySearch(
        Search => $Search{$Count},
    );
    $Self->False(
        $Keys[0] || '',
        "Key:$Count - KeySearch()",
    );

    # get keys
    my $KeyString = $Self->{MainObject}->FileRead(
        Directory => $ConfigObject->Get('Home') . "/scripts/test/sample/Crypt/",
        Filename  => "PGPPrivateKey-$Count.asc",
    );
    my $Message = $CryptObject->KeyAdd(
        Key => ${$KeyString},
    );
    $Self->True(
        $Message || '',
        "Key:$Count - KeyAdd()",
    );

    @Keys = $CryptObject->KeySearch(
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

    my $PublicKeyString = $CryptObject->PublicKeyGet(
        Key => $Keys[0]->{Key},
    );
    $Self->True(
        $PublicKeyString || '',
        "Key:$Count - PublicKeyGet()",
    );

    my $PrivateKeyString = $CryptObject->SecretKeyGet(
        Key => $Keys[0]->{KeyPrivate},
    );
    $Self->True(
        $PrivateKeyString || '',
        "Key:$Count - SecretKeyGet()",
    );
}

# tests for handling encrypted emails
my @Tests = (
    {
        Name           => 'Encrypted Body, Plain Attachments',
        EmailFile      => '/scripts/test/sample/PGP/PGP_Test_2013-07-02-1977-1.eml',
        ArticleSubject => 'PGP Test 2013-07-02-1977-1',
        ArticleBody    => "This is only a test.\n",
    },
    {
        Name           => 'Encrypted Body and Attachments as whole',
        EmailFile      => '/scripts/test/sample/PGP/PGP_Test_2013-07-02-1977-2.eml',
        ArticleSubject => 'PGP Test 2013-07-02-1977-2',
        ArticleBody    => "This is only a test.\n",
    },
    {
        Name           => 'Encrypted Body and Attachments independently',
        EmailFile      => '/scripts/test/sample/PGP/PGP_Test_2013-07-02-1977-3.eml',
        ArticleSubject => 'PGP Test 2013-07-02-1977-3',
        ArticleBody    => "This is only a test.\n",
    },
);

# to store added tickets into the system (will be deleted later)
my @AddedTickets;

# lookp table to get a better idea of postmaster result
my %PostMasterReturnLookup = (
    0 => 'error (also false)',
    1 => 'new ticket created',
    2 => 'follow up / open/reopen',
    3 => 'follow up / close -> new ticket',
    4 => 'follow up / close -> reject',
    5 => 'ignored (because of X-OTRS-Ignore header)',
);

for my $Test (@Tests) {

    # read email content (from a file)
    my $Email = $MainObject->FileRead(
        Location => $ConfigObject->Get('Home') . $Test->{EmailFile},
        Result   => 'ARRAY',
    );

    # use post master to import mail into OTRS
    my $PostMasterObject = Kernel::System::PostMaster->new(
        %{$Self},
        ConfigObject => $ConfigObject,
        Email        => $Email,
        Trusted      => 1,
    );
    my @PostMasterResult = $PostMasterObject->Run( Queue => '' );

    # sanity check (if postmaster runs correctly)
    $Self->IsNot(
        $PostMasterResult[0],
        0,
        "$Test->{Name} - PostMaster result should not be 0"
            . " ($PostMasterReturnLookup{ $PostMasterResult[0] })",
    );

    # check if we get a new TicketID
    $Self->IsNot(
        $PostMasterResult[1],
        undef,
        "$Test->{Name} - PostMaster TicketID should not be undef",
    );

    # set the TicketID as the result form PostMaster
    my $TicketID = $PostMasterResult[1] || 0;

    if ( $PostMasterResult[1] > 0 ) {
        push @AddedTickets, $TicketID;

        # get ticket articles
        my @ArticleIDs = $TicketObject->ArticleIndex(
            TicketID => $TicketID,
        );

        # use the first result (it should be only 1)
        my %RawArticle = $TicketObject->ArticleGet(
            ArticleID     => $ArticleIDs[0],
            DynamicFields => 0,
            UserID        => 1,
        );

        # use ArticleCheckPGP to decript the article
        my $CheckObject = Kernel::Output::HTML::ArticleCheckPGP->new(
            %{$Self},
            ConfigObject => $ConfigObject,
            TicketObject => $TicketObject,
            LayoutObject => $LayoutObject,
            ArticleID    => $ArticleIDs[0],
            UserID       => 1,
        );
        my @CheckResult = $CheckObject->Check( Article => \%RawArticle );

        # sanity destroy object
        $CheckObject = undef;

        # check actual contents (subject and body)
        my %Article = $TicketObject->ArticleGet(
            ArticleID     => $ArticleIDs[0],
            DynamicFields => 0,
            UserID        => 1,
        );

        $Self->Is(
            $Article{Subject},
            $Test->{ArticleSubject},
            "$Test->{Name} - Decrypted article subject",
        );

        $Self->Is(
            $Article{Body},
            $Test->{ArticleBody},
            "$Test->{Name} - Decrypted article body",
        );

        # get the list of attachments
        my %AtmIndex = $TicketObject->ArticleAttachmentIndex(
            ArticleID                  => $ArticleIDs[0],
            Article                    => \%Article,
            StripPlainBodyAsAttachment => 1,
            UserID                     => 1,
        );

        FILEID:
        for my $FileID ( sort keys %AtmIndex ) {

            # skip non important attachments
            next FILEID if $AtmIndex{$FileID}->{Filename} =~ m{\A file-\d+ \z}msx;

            # get the attachment from the article (it should be already decrypted)
            my %Attachment = $TicketObject->ArticleAttachment(
                ArticleID => $ArticleIDs[0],
                FileID    => $FileID,
                UserID    => 1,
            );

            # read the original file (from file system)
            my $FileStringRef = $MainObject->FileRead(
                Location => $ConfigObject->Get('Home')
                    . '/scripts/test/sample/Crypt/'
                    . $AtmIndex{$FileID}->{Filename},
            );

            # check actual contents (attachment)
            $Self->Is(
                $Attachment{Content},
                ${$FileStringRef},
                "$Test->{Name} - Decrypted attachment $AtmIndex{$FileID}->{Filename}",
            );
        }
    }
}

# delete the tickets
for my $TicketID (@AddedTickets) {

    my $TicketDelete = $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => 1,
    );

    # sanity check
    $Self->True(
        $TicketDelete,
        "TicketDelete() successful for Ticket ID $TicketID",
    );
}

# delete PGP keys
for my $Count ( 1 .. 2 ) {
    my @Keys = $CryptObject->KeySearch(
        Search => $Search{$Count},
    );
    $Self->True(
        $Keys[0] || '',
        "Key:$Count - KeySearch()",
    );
    my $DeleteSecretKey = $CryptObject->SecretKeyDelete(
        Key => $Keys[0]->{KeyPrivate},
    );
    $Self->True(
        $DeleteSecretKey || '',
        "Key:$Count - SecretKeyDelete()",
    );

    my $DeletePublicKey = $CryptObject->PublicKeyDelete(
        Key => $Keys[0]->{Key},
    );
    $Self->True(
        $DeletePublicKey || '',
        "Key:$Count - PublicKeyDelete()",
    );

    @Keys = $CryptObject->KeySearch(
        Search => $Search{$Count},
    );
    $Self->False(
        $Keys[0] || '',
        "Key:$Count - KeySearch()",
    );
}

1;
