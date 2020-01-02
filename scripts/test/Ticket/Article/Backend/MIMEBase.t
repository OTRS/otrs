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

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
$Helper->FixedTimeSet();

# Disable email addresses checking.
$Helper->ConfigSettingChange(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# Use test email backend.
$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::Test',
);

my $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

# Create test ticket.
my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);
$Self->True(
    $TicketID,
    'TicketCreate()'
);

my $MessageID   = '<' . $Helper->GetRandomID() . '@example.com>';
my %ArticleHash = (
    TicketID             => $TicketID,
    SenderType           => 'agent',
    IsVisibleForCustomer => 1,
    From                 => 'Some Agent <email@example.com>',
    To                   => 'Some Customer A <customer-a@example.com>',
    Cc                   => 'Some Customer B <customer-b@example.com>',
    Bcc                  => 'Some Customer C <customer-c@example.com>',
    Subject              => 'some short description',
    Body                 => 'the message text',
    MessageID            => $MessageID,
    Charset              => 'ISO-8859-15',
    MimeType             => 'text/plain',
    HistoryType          => 'OwnerUpdate',
    HistoryComment       => 'Some free text!',
    UserID               => 1,
    UnlockOnAway         => 1,
    FromRealname         => 'Some Agent',
    ToRealname           => 'Some Customer A',
    CcRealname           => 'Some Customer B',
);

my $TimeStamp = $Kernel::OM->Create('Kernel::System::DateTime')->ToString();

# Go through all MIME based communication channels.
for my $ChannelName (qw(Email Phone Internal)) {
    my $ArticleBackendObject = $Kernel::OM->Get("Kernel::System::Ticket::Article::Backend::$ChannelName");
    $Self->True(
        $ArticleBackendObject,
        "Got '$ChannelName' article backend object"
    );

    # Create test article.
    my $ArticleID = $ArticleBackendObject->ArticleCreate(
        %ArticleHash,
    );
    $Self->True(
        $ArticleID,
        "ArticleCreate - Added article $ArticleID"
    );
    $ArticleHash{ArticleID}  = $ArticleID;
    $ArticleHash{CreateBy}   = 1;
    $ArticleHash{CreateTime} = $TimeStamp;

    # Check meta article.
    my @Articles = $ArticleObject->ArticleList(
        TicketID => $TicketID,
        OnlyLast => 1,
    );

    for my $Key (qw(TicketID ArticleID CommunicationChannelID IsVisibleForCustomer SenderTypeID)) {
        my $Value;
        if ( $Key eq 'TicketID' ) {
            $Value = $TicketID;
        }
        elsif ( $Key eq 'ArticleID' ) {
            $Value = $ArticleID;
        }
        elsif ( $Key eq 'CommunicationChannelID' ) {
            my %CommunicationChannel = $Kernel::OM->Get('Kernel::System::CommunicationChannel')->ChannelGet(
                ChannelName => $ChannelName,
            );
            $Value = $CommunicationChannel{ChannelID};
        }
        elsif ( $Key eq 'IsVisibleForCustomer' ) {
            $Value = 1;
        }
        elsif ( $Key eq 'SenderTypeID' ) {
            $Value = $ArticleObject->ArticleSenderTypeLookup( SenderType => 'agent' );
        }

        $Self->Is(
            $Articles[0]->{$Key},
            $Value,
            "ArticleList - Value for $Key"
        );
    }

    # Get article data.
    my %Article = $ArticleBackendObject->ArticleGet(
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
        RealNames => 1,
    );

    KEY:
    for my $Key (
        qw(TicketID ArticleID From ReplyTo To Cc Bcc Subject MessageID InReplyTo References ContentType Body SenderType
        SenderTypeID IsVisibleForCustomer CreateBy CreateTime Charset MimeType FromRealname ToRealname CcRealname
        BccRealname)
        )
    {
        my $Value = $ArticleHash{$Key};
        next KEY if !defined $Value;

        $Self->Is(
            $Article{$Key},
            $Value,
            "ArticleGet - Value for $Key"
        );
    }

    my $NewBody = 'this changed message text';
    my $Success = $ArticleBackendObject->ArticleUpdate(
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
        Key       => 'Body',
        Value     => $NewBody,
        UserID    => 1,
    );
    $Self->True(
        $Success,
        'ArticleUpdate - Change body'
    );

    my $NewVisibleForCustomer = 0;
    $Success = $ArticleBackendObject->ArticleUpdate(
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
        Key       => 'IsVisibleForCustomer',
        Value     => $NewVisibleForCustomer,
        UserID    => 1,
    );
    $Self->True(
        $Success,
        'ArticleUpdate - Change customer visibility'
    );

    # Get article data again.
    %Article = $ArticleBackendObject->ArticleGet(
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
    );

    KEY:
    for my $Key (
        qw(Body IsVisibleForCustomer)
        )
    {
        my $Value;
        if ( $Key eq 'Body' ) {
            $Value = $NewBody;
        }
        elsif ( $Key eq 'IsVisibleForCustomer' ) {
            $Value = $NewVisibleForCustomer;
        }

        $Self->Is(
            $Article{$Key},
            $Value,
            "ArticleGet - Value for $Key"
        );
    }

    if ( $ChannelName eq 'Email' ) {

        # Get article data by message ID.
        my %Article = $ArticleBackendObject->ArticleGetByMessageID(
            MessageID => $MessageID,
            RealNames => 1,
        );

        KEY:
        for my $Key (
            qw(TicketID ArticleID From ReplyTo To Cc Bcc Subject MessageID InReplyTo References ContentType Body
            SenderType SenderTypeID IsVisibleForCustomer CreateBy CreateTime Charset MimeType FromRealname ToRealname
            CcRealname BccRealname)
            )
        {
            my $Value = $ArticleHash{$Key};
            if ( $Key eq 'Body' ) {
                $Value = $NewBody;
            }
            elsif ( $Key eq 'IsVisibleForCustomer' ) {
                $Value = $NewVisibleForCustomer;
            }
            next KEY if !defined $Value;

            $Self->Is(
                $Article{$Key},
                $Value,
                "ArticleGet - Value for $Key",
            );
        }

        my $ArticleID = $ArticleBackendObject->ArticleSend(
            %ArticleHash,
        );
        $Self->True(
            $ArticleID,
            "ArticleCreate - Sent article $ArticleID"
        );
        $ArticleHash{ArticleID} = $ArticleID;
        delete $ArticleHash{MessageID};

        # Remove existing article from the mail queue, so it doesn't interfere with later tests.
        $Kernel::OM->Get('Kernel::System::MailQueue')->Delete( ArticleID => $ArticleID );

        # Get article data again.
        %Article = $ArticleBackendObject->ArticleGet(
            TicketID  => $TicketID,
            ArticleID => $ArticleID,
        );

        KEY:
        for my $Key (
            qw(TicketID ArticleID From ReplyTo To Cc Bcc Subject MessageID InReplyTo References ContentType Body
            SenderType SenderTypeID CreateBy CreateTime Charset MimeType)
            )
        {
            my $Value = $ArticleHash{$Key};
            next KEY if !defined $Value;

            $Self->Is(
                $Article{$Key},
                $Value,
                "ArticleGet - Value for $Key"
            );
        }

        $Success = $ArticleBackendObject->ArticleBounce(
            From      => 'some@example.com',
            To        => 'webmaster@example.com',
            TicketID  => $TicketID,
            ArticleID => $ArticleID,
            UserID    => 1,
        );
        $Self->True(
            $Success,
            "ArticleBounce - Bounced article $ArticleID"
        );
    }

    $Success = $ArticleBackendObject->ArticleDelete(
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
        UserID    => 1,
    );
    $Self->True(
        $Success,
        "ArticleDelete - Deleted article $ArticleID"
    );

    %Article = $ArticleBackendObject->ArticleGet(
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
    );
    $Self->False(
        scalar %Article,
        'ArticleGet - Empty return value'
    );
}

# Cleanup is done by RestoreDatabase.

1;
