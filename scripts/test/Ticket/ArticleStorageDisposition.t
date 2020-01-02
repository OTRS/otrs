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

my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');
my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Internal' );

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $UserID = 1;

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
            FilesizeRaw        => 3,
            ContentID          => '<testing123@example.com>',
            ContentType        => 'text/html',
            Disposition        => 'inline',
            ContentAlternative => '',
        },
    },
);

for my $Backend (qw(DB FS)) {

    my $TicketID = $TicketObject->TicketCreate(
        Title        => 'Some Ticket_Title',
        Queue        => 'Raw',
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'closed successful',
        CustomerNo   => 'unittest',
        CustomerUser => 'customer@example.com',
        OwnerID      => 1,
        UserID       => 1,
    );
    $Self->True(
        $TicketID,
        "TicketCreate() - TicketID: '$TicketID'"
    );

    for my $Test (@Tests) {

        # Make sure that the article backend object gets recreated for each loop.
        $Kernel::OM->ObjectsDiscard( Objects => [ ref $ArticleBackendObject ] );

        $ConfigObject->Set(
            Key   => 'Ticket::Article::Backend::MIMEBase::ArticleStorage',
            Value => 'Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorage' . $Backend,
        );

        $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Internal' );

        $Self->Is(
            $ArticleBackendObject->{ArticleStorageModule},
            'Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorage' . $Backend,
            'Article backend loaded the correct storage module'
        );

        # create an article
        my $ArticleID = $ArticleBackendObject->ArticleCreate(
            TicketID             => $TicketID,
            SenderType           => 'agent',
            IsVisibleForCustomer => 0,
            From                 => 'Some Agent <email@example.com>',
            To                   => 'Some Customer <customer-a@example.com>',
            Subject              => 'some short description',
            Body                 => 'the message text',
            ContentType          => 'text/plain; charset=ISO-8859-15',
            HistoryType          => 'OwnerUpdate',
            HistoryComment       => 'Some free text!',
            UserID               => 1,
            NoAgentNotify        => 1,
        );
        $Self->True(
            $ArticleID,
            "ArticleCreate() - ArticleID: '$ArticleID'"
        );

        # create attachment
        my $Success = $ArticleBackendObject->ArticleWriteAttachment(
            %{ $Test->{Config} },
            ArticleID => $ArticleID,
        );
        $Self->True(
            $Success,
            "$Test->{Name} | $Backend ArticleWriteAttachment() - created $Test->{Config}->{Filename}",
        );

        # get the list of all attachments (should be only 1)
        my %AttachmentIndex = $ArticleBackendObject->ArticleAttachmentIndex(
            ArticleID => $ArticleID,
        );
        my $AttachmentID = grep { $AttachmentIndex{$_}->{Filename} eq $Test->{Config}->{Filename} }
            keys %AttachmentIndex;
        $Self->IsDeeply(
            $AttachmentIndex{$AttachmentID},
            $Test->{ExpectedResults},
            "$Test->{Name} | $Backend ArticleAttachmentIndex",
        );

        # get the attachment individually
        my %Attachment = $ArticleBackendObject->ArticleAttachment(
            ArticleID => $ArticleID,
            FileID    => $AttachmentID,
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

    # cleanup is done by RestoreDatabase, but we need to additionally
    # run TicketDelete() to cleanup the FS backend too
    my $Success = $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->True(
        $Success,
        "TicketDelete() - TicketID: '$TicketID'",
    );
}

1;
