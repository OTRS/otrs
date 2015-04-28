# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

my $UserID   = 1;
my $RandomID = $Kernel::OM->Get('Kernel::System::UnitTest::Helper')->GetRandomID();

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
    "TicketCreate() - TicketID:'$TicketID'",
);

my @Tests = (

    # normal attachment tests
    {
        Name   => 'Normal Attachment w/Disposition w/ContentID',
        Config => {
            Filename    => 'testing.pdf',
            ContentType => 'application/pdf',
            Disposition => 'attachment',
            ContentID   => 'testing123@example.com',
            Content     => '123',
            UserID      => $UserID,
        },
        ExpectedResults => {
            Filename           => 'testing.pdf',
            Filesize           => '3 Bytes',
            FilesizeRaw        => 3,
            ContentID          => '<testing123@example.com>',
            ContentType        => 'application/pdf',
            Disposition        => 'attachment',
            ContentAlternative => '',
        },
    },
    {
        Name   => 'Normal Attachment w/Disposition wo/ContentID',
        Config => {
            Filename    => 'testing.pdf',
            ContentType => 'application/pdf',
            Disposition => 'attachment',
            ContentID   => undef,
            Content     => '123',
            UserID      => $UserID,
        },
        ExpectedResults => {
            Filename           => 'testing.pdf',
            Filesize           => '3 Bytes',
            FilesizeRaw        => 3,
            ContentID          => '',
            ContentType        => 'application/pdf',
            Disposition        => 'attachment',
            ContentAlternative => '',
        },
    },
    {
        Name   => 'Normal Attachment wo/Disposition w/ContentID',
        Config => {
            Filename    => 'testing.pdf',
            ContentType => 'application/pdf',
            Disposition => undef,
            ContentID   => 'testing123@example.com',
            Content     => '123',
            UserID      => $UserID,
        },
        ExpectedResults => {
            Filename           => 'testing.pdf',
            Filesize           => '3 Bytes',
            FilesizeRaw        => 3,
            ContentID          => '<testing123@example.com>',
            ContentType        => 'application/pdf',
            Disposition        => 'attachment',
            ContentAlternative => '',
        },
    },
    {
        Name   => 'Normal Attachment wo/Disposition wo/ContentID',
        Config => {
            Filename    => 'testing.pdf',
            ContentType => 'application/pdf',
            Disposition => undef,
            ContentID   => undef,
            Content     => '123',
            UserID      => $UserID,
        },
        ExpectedResults => {
            Filename           => 'testing.pdf',
            Filesize           => '3 Bytes',
            FilesizeRaw        => 3,
            ContentID          => '',
            ContentType        => 'application/pdf',
            Disposition        => 'attachment',
            ContentAlternative => '',
        },
    },
    {
        Name   => 'Normal Attachment inline w/Disposition wo/ContentID',
        Config => {
            Filename    => 'testing.pdf',
            ContentType => 'application/pdf',
            Disposition => 'inline',
            ContentID   => undef,
            Content     => '123',
            UserID      => $UserID,
        },
        ExpectedResults => {
            Filename           => 'testing.pdf',
            Filesize           => '3 Bytes',
            FilesizeRaw        => 3,
            ContentID          => '',
            ContentType        => 'application/pdf',
            Disposition        => 'inline',
            ContentAlternative => '',
        },
    },
    {
        Name   => 'Normal Attachment inline w/Disposition w/ContentID',
        Config => {
            Filename    => 'testing.pdf',
            ContentType => 'application/pdf',
            Disposition => 'inline',
            ContentID   => 'testing123@example.com',
            Content     => '123',
            UserID      => $UserID,
        },
        ExpectedResults => {
            Filename           => 'testing.pdf',
            Filesize           => '3 Bytes',
            FilesizeRaw        => 3,
            ContentID          => '<testing123@example.com>',
            ContentType        => 'application/pdf',
            Disposition        => 'inline',
            ContentAlternative => '',
        },
    },

    # image tests
    {
        Name   => 'Image Attachment w/Disposition w/ContentID',
        Config => {
            Filename    => 'testing.png',
            ContentType => 'image/png',
            Disposition => 'attachment',
            ContentID   => 'testing123@example.com',
            Content     => '123',
            UserID      => $UserID,
        },
        ExpectedResults => {
            Filename           => 'testing.png',
            Filesize           => '3 Bytes',
            FilesizeRaw        => 3,
            ContentID          => '<testing123@example.com>',
            ContentType        => 'image/png',
            Disposition        => 'attachment',
            ContentAlternative => '',
        },
    },
    {
        Name   => 'Image Attachment w/Disposition wo/ContentID',
        Config => {
            Filename    => 'testing.png',
            ContentType => 'image/png',
            Disposition => 'attachment',
            ContentID   => undef,
            Content     => '123',
            UserID      => $UserID,
        },
        ExpectedResults => {
            Filename           => 'testing.png',
            Filesize           => '3 Bytes',
            FilesizeRaw        => 3,
            ContentID          => '',
            ContentType        => 'image/png',
            Disposition        => 'attachment',
            ContentAlternative => '',
        },
    },
    {
        Name   => 'Image Attachment wo/Disposition w/ContentID',
        Config => {
            Filename    => 'testing.png',
            ContentType => 'image/png',
            Disposition => undef,
            ContentID   => 'testing123@example.com',
            Content     => '123',
            UserID      => $UserID,
        },

        # images with content id and no disposition should be inline
        ExpectedResults => {
            Filename           => 'testing.png',
            Filesize           => '3 Bytes',
            FilesizeRaw        => 3,
            ContentID          => '<testing123@example.com>',
            ContentType        => 'image/png',
            Disposition        => 'inline',
            ContentAlternative => '',
        },
    },
    {
        Name   => 'Image Attachment wo/Disposition wo/ContentID',
        Config => {
            Filename    => 'testing.png',
            ContentType => 'image/png',
            Disposition => undef,
            ContentID   => undef,
            Content     => '123',
            UserID      => $UserID,
        },
        ExpectedResults => {
            Filename           => 'testing.png',
            Filesize           => '3 Bytes',
            FilesizeRaw        => 3,
            ContentID          => '',
            ContentType        => 'image/png',
            Disposition        => 'attachment',
            ContentAlternative => '',
        },
    },
    {
        Name   => 'Image Attachment inline w/Disposition wo/ContentID',
        Config => {
            Filename    => 'testing.png',
            ContentType => 'image/png',
            Disposition => 'inline',
            ContentID   => undef,
            Content     => '123',
            UserID      => $UserID,
        },
        ExpectedResults => {
            Filename           => 'testing.png',
            Filesize           => '3 Bytes',
            FilesizeRaw        => 3,
            ContentID          => '',
            ContentType        => 'image/png',
            Disposition        => 'inline',
            ContentAlternative => '',
        },
    },
    {
        Name   => 'Image Attachment inline w/Disposition w/ContentID',
        Config => {
            Filename    => 'testing.png',
            ContentType => 'image/png',
            Disposition => 'inline',
            ContentID   => 'testing123@example.com',
            Content     => '123',
            UserID      => $UserID,
        },
        ExpectedResults => {
            Filename           => 'testing.png',
            Filesize           => '3 Bytes',
            FilesizeRaw        => 3,
            ContentID          => '<testing123@example.com>',
            ContentType        => 'image/png',
            Disposition        => 'inline',
            ContentAlternative => '',
        },
    },

    # special attachments tests
    {
        Name   => 'Special Attachment w/Disposition w/ContentID',
        Config => {
            Filename    => 'file-2',
            ContentType => 'text/html',
            Disposition => 'attachment',
            ContentID   => 'testing123@example.com',
            Content     => '123',
            UserID      => $UserID,
        },
        ExpectedResults => {
            Filename           => 'file-2',
            Filesize           => '3 Bytes',
            FilesizeRaw        => 3,
            ContentID          => '<testing123@example.com>',
            ContentType        => 'text/html',
            Disposition        => 'attachment',
            ContentAlternative => '',
        },
    },
    {
        Name   => 'Special Attachment w/Disposition wo/ContentID',
        Config => {
            Filename    => 'file-2',
            ContentType => 'text/html',
            Disposition => 'attachment',
            ContentID   => undef,
            Content     => '123',
            UserID      => $UserID,
        },
        ExpectedResults => {
            Filename           => 'file-2',
            Filesize           => '3 Bytes',
            FilesizeRaw        => 3,
            ContentID          => '',
            ContentType        => 'text/html',
            Disposition        => 'attachment',
            ContentAlternative => '',
        },
    },
    {
        Name   => 'Special Attachment wo/Disposition w/ContentID',
        Config => {
            Filename    => 'file-2',
            ContentType => 'text/html',
            Disposition => undef,
            ContentID   => 'testing123@example.com',
            Content     => '123',
            UserID      => $UserID,
        },

        # special attachments with no disposition should be inline
        ExpectedResults => {
            Filename           => 'file-2',
            Filesize           => '3 Bytes',
            FilesizeRaw        => 3,
            ContentID          => '<testing123@example.com>',
            ContentType        => 'text/html',
            Disposition        => 'inline',
            ContentAlternative => '',
        },
    },
    {
        Name   => 'Special Attachment wo/Disposition wo/ContentID',
        Config => {
            Filename    => 'file-2',
            ContentType => 'text/html',
            Disposition => undef,
            ContentID   => undef,
            Content     => '123',
            UserID      => $UserID,
        },
        ExpectedResults => {
            Filename           => 'file-2',
            Filesize           => '3 Bytes',
            FilesizeRaw        => 3,
            ContentID          => '',
            ContentType        => 'text/html',
            Disposition        => 'inline',
            ContentAlternative => '',
        },
    },
    {
        Name   => 'Special Attachment inline w/Disposition wo/ContentID',
        Config => {
            Filename    => 'file-2',
            ContentType => 'text/html',
            Disposition => 'inline',
            ContentID   => undef,
            Content     => '123',
            UserID      => $UserID,
        },
        ExpectedResults => {
            Filename           => 'file-2',
            Filesize           => '3 Bytes',
            FilesizeRaw        => 3,
            ContentID          => '',
            ContentType        => 'text/html',
            Disposition        => 'inline',
            ContentAlternative => '',
        },
    },
    {
        Name   => 'Special Attachment inline w/Disposition w/ContentID',
        Config => {
            Filename    => 'file-2',
            ContentType => 'text/html',
            Disposition => 'inline',
            ContentID   => 'testing123@example.com',
            Content     => '123',
            UserID      => $UserID,
        },
        ExpectedResults => {
            Filename           => 'file-2',
            Filesize           => '3 Bytes',
            FilesizeRaw        => 3,
            ContentID          => '<testing123@example.com>',
            ContentType        => 'text/html',
            Disposition        => 'inline',
            ContentAlternative => '',
        },
    },
);

for my $Test (@Tests) {
    for my $Backend (qw(DB FS)) {

        # Make sure that the TicketObject gets recreated for each loop.
        $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket'] );

        $ConfigObject->Set(
            Key   => 'Ticket::StorageModule',
            Value => 'Kernel::System::Ticket::ArticleStorage' . $Backend,
        );

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        $Self->True(
            $TicketObject->isa( 'Kernel::System::Ticket::ArticleStorage' . $Backend ),
            "TicketObject loaded the correct backend",
        );

        # create an article
        my $ArticleID = $TicketObject->ArticleCreate(
            TicketID       => $TicketID,
            ArticleType    => 'note-internal',
            SenderType     => 'agent',
            From           => 'Some Agent <email@example.com>',
            To             => 'Some Customer <customer-a@example.com>',
            Subject        => 'some short description',
            Body           => 'the message text',
            ContentType    => 'text/plain; charset=ISO-8859-15',
            HistoryType    => 'OwnerUpdate',
            HistoryComment => 'Some free text!',
            UserID         => 1,
            NoAgentNotify  => 1,                                         # if you don't want to send agent notifications
        );
        $Self->True(
            $ArticleID,
            "ArticleCreate() - ArticleID:'$ArticleID'",
        );

        # create attachment
        my $Success = $TicketObject->ArticleWriteAttachment(
            %{ $Test->{Config} },
            ArticleID => $ArticleID,
        );
        $Self->True(
            $Success,
            "$Test->{Name} | $Backend ArticleWriteAttachment() - created $Test->{Config}->{Filename}",
        );

        # get the list of all attachments (should be only 1)
        my %AttachmentIndex = $TicketObject->ArticleAttachmentIndex(
            ArticleID => $ArticleID,
            UserID    => $UserID,
        );
        my $AttachmentID = grep { $AttachmentIndex{$_}->{Filename} eq $Test->{Config}->{Filename} }
            keys %AttachmentIndex;
        $Self->IsDeeply(
            $AttachmentIndex{$AttachmentID},
            $Test->{ExpectedResults},
            "$Test->{Name} | $Backend ArticleAttachmentIndex",
        );

        # get the attachment individually
        my %Attachment = $TicketObject->ArticleAttachment(
            ArticleID => $ArticleID,
            FileID    => $AttachmentID,
            UserID    => $UserID,
        );

        # add the missing content to the test expected resutls
        my %ExpectedAttachment = (
            %{ $Test->{ExpectedResults} },
            Content => $Test->{Config}->{Content},
        );
        $Self->IsDeeply(
            \%Attachment,
            \%ExpectedAttachment,
            "$Test->{Name} | $Backend ArticleAttachment",
        );
    }
}

# the ticket is no longer needed
my $Success = $TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);
$Self->True(
    $Success,
    "TicketDelete() - TicketID:'$TicketID'",
);

1;
