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
my $MainObject           = $Kernel::OM->Get('Kernel::System::Main');
my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Internal' );

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Create test ticket.
my $TicketID = $Kernel::OM->Get('Kernel::System::Ticket')->TicketCreate(
    Title        => 'Some Ticket_Title',
    QueueID      => 1,
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
    'TicketCreate()',
);

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
    'ArticleCreate()',
);

# article attachment checks
for my $Backend (qw(DB FS)) {

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

    for my $File (
        qw(Ticket-Article-Test1.xls Ticket-Article-Test1.txt Ticket-Article-Test1.doc
        Ticket-Article-Test1.png Ticket-Article-Test1.pdf Ticket-Article-Test-utf8-1.txt Ticket-Article-Test-utf8-1.bin Ticket-Article-Test-empty.txt)
        )
    {
        my $Location   = $ConfigObject->Get('Home') . "/scripts/test/sample/Ticket/$File";
        my $ContentRef = $MainObject->FileRead(
            Location => $Location,
            Mode     => 'binmode',
        );

        for my $FileName (
            'SimpleFile',
            'ÄÖÜカスタマ-',          # Unicode NFC
            'Второй_файл',    # Unicode NFD
            )
        {
            my $Content                = ${$ContentRef};
            my $FileNew                = $FileName . $File;
            my $MD5Orig                = $MainObject->MD5sum( String => $Content );
            my $ArticleWriteAttachment = $ArticleBackendObject->ArticleWriteAttachment(
                Content     => $Content,
                Filename    => $FileNew,
                ContentType => 'image/png',
                ArticleID   => $ArticleID,
                UserID      => 1,
            );
            $Self->True(
                $ArticleWriteAttachment,
                "$Backend ArticleWriteAttachment() - $FileNew",
            );

            my %AttachmentIndex = $ArticleBackendObject->ArticleAttachmentIndex(
                ArticleID => $ArticleID,
            );

            my $TargetFilename = $FileName . $File;

            $Self->Is(
                $AttachmentIndex{1}->{Filename},
                $TargetFilename,
                "$Backend ArticleAttachmentIndex() Filename - $FileNew"
            );

            my %Data = $ArticleBackendObject->ArticleAttachment(
                ArticleID => $ArticleID,
                FileID    => 1,
            );
            $Self->True(
                $Data{ContentType},
                "$Backend ArticleAttachment() ContentType - $FileNew",
            );
            $Self->True(
                $Data{Content} eq $Content,
                "$Backend ArticleWriteAttachment() / ArticleAttachment() - $FileNew",
            );
            $Self->True(
                $Data{ContentType} eq 'image/png',
                "$Backend ArticleWriteAttachment() / ArticleAttachment() - $File",
            );
            my $MD5New = $MainObject->MD5sum( String => $Data{Content} );
            $Self->Is(
                $MD5Orig || '1',
                $MD5New  || '2',
                "$Backend MD5 - $FileNew",
            );
            my $Delete = $ArticleBackendObject->ArticleDeleteAttachment(
                ArticleID => $ArticleID,
                UserID    => 1,
            );
            $Self->True(
                $Delete,
                "$Backend ArticleDeleteAttachment() - $FileNew",
            );

            %AttachmentIndex = $ArticleBackendObject->ArticleAttachmentIndex(
                ArticleID => $ArticleID,
            );

            $Self->IsDeeply(
                \%AttachmentIndex,
                {},
                "$Backend ArticleAttachmentIndex() after delete - $FileNew"
            );
        }
    }
}

# filename collision checks
for my $Backend (qw(DB FS)) {

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
        'Article backend loaded the correct storage module',
    );

    # Store file 2 times
    my $FileName               = "[Terminology Guide äöß].pdf";
    my $Content                = '123';
    my $FileNew                = $FileName;
    my $ArticleWriteAttachment = $ArticleBackendObject->ArticleWriteAttachment(
        Content     => $Content,
        Filename    => $FileNew,
        ContentType => 'image/png',
        ArticleID   => $ArticleID,
        UserID      => 1,
    );
    $Self->True(
        $ArticleWriteAttachment,
        "$Backend ArticleWriteAttachment() - collision check created $FileNew",
    );

    $ArticleWriteAttachment = $ArticleBackendObject->ArticleWriteAttachment(
        Content     => $Content,
        Filename    => $FileNew,
        ContentType => 'image/png',
        ArticleID   => $ArticleID,
        UserID      => 1,
    );
    $Self->True(
        $ArticleWriteAttachment,
        "$Backend ArticleWriteAttachment() - collision check created $FileNew second time",
    );

    my %AttachmentIndex = $ArticleBackendObject->ArticleAttachmentIndex(
        ArticleID => $ArticleID,
    );

    my $TargetFilename = '[Terminology Guide äöß]';

    if ( $Backend eq 'FS' ) {
        $TargetFilename = '_Terminology_Guide_äöß_';
    }

    $Self->Is(
        scalar keys %AttachmentIndex,
        2,
        "$Backend ArticleWriteAttachment() - collision check number of attachments",
    );

    my ($Entry1) = grep { $AttachmentIndex{$_}->{Filename} eq "$TargetFilename.pdf" } keys %AttachmentIndex;
    my ($Entry2) = grep { $AttachmentIndex{$_}->{Filename} eq "$TargetFilename-1.pdf" }
        keys %AttachmentIndex;

    $Self->IsDeeply(
        $AttachmentIndex{$Entry1},
        {
            'ContentAlternative' => '',
            'ContentID'          => '',
            'ContentType'        => 'image/png',
            'Filename'           => "$TargetFilename.pdf",
            'FilesizeRaw'        => '3',
            'Disposition'        => 'attachment',
        },
        "$Backend ArticleAttachmentIndex - collision check entry 1",
    );

    $Self->IsDeeply(
        $AttachmentIndex{$Entry2},
        {
            'ContentAlternative' => '',
            'ContentID'          => '',
            'ContentType'        => 'image/png',
            'Filename'           => "$TargetFilename-1.pdf",
            'FilesizeRaw'        => '3',
            'Disposition'        => 'attachment',
        },
        "$Backend ArticleAttachmentIndex - collision check entry 2",
    );

    my $Delete = $ArticleBackendObject->ArticleDeleteAttachment(
        ArticleID => $ArticleID,
        UserID    => 1,
    );

    $Self->True(
        $Delete,
        "$Backend ArticleDeleteAttachment()",
    );

    %AttachmentIndex = $ArticleBackendObject->ArticleAttachmentIndex(
        ArticleID => $ArticleID,
    );

    $Self->IsDeeply(
        \%AttachmentIndex,
        {},
        "$Backend ArticleAttachmentIndex() after delete",
    );
}

# cleanup is done by RestoreDatabase.

1;
