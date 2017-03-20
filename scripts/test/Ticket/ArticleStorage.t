# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Unicode::Normalize;

# get needed objects
my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
my $MainObject    = $Kernel::OM->Get('Kernel::System::Main');
my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $TicketID = $Kernel::OM->Get('Kernel::System::Ticket')->TicketCreate(
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
    'TicketCreate()',
);

my $ArticleID = $ArticleObject->ArticleCreate(
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
    NoAgentNotify  => 1,                                          # if you don't want to send agent notifications
);

$Self->True(
    $ArticleID,
    'ArticleCreate()',
);

# article attachment checks
for my $Backend (qw(DB FS)) {

    # Make sure that the article object gets recreated for each loop.
    $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket::Article'] );

    $ConfigObject->Set(
        Key   => 'Ticket::StorageModule',
        Value => 'Kernel::System::Ticket::ArticleStorage' . $Backend,
    );

    $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    $Self->Is(
        $ArticleObject->{ArticleStorageModule},
        'Kernel::System::Ticket::ArticleStorage' . $Backend,
        "TicketObject loaded the correct backend",
    );

    for my $File (
        qw(Ticket-Article-Test1.xls Ticket-Article-Test1.txt Ticket-Article-Test1.doc
        Ticket-Article-Test1.png Ticket-Article-Test1.pdf Ticket-Article-Test-utf8-1.txt Ticket-Article-Test-utf8-1.bin)
        )
    {
        my $Location = $ConfigObject->Get('Home')
            . "/scripts/test/sample/Ticket/$File";
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
            my $ArticleWriteAttachment = $ArticleObject->ArticleWriteAttachment(
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

            my %AttachmentIndex = $ArticleObject->ArticleAttachmentIndex(
                ArticleID => $ArticleID,
                UserID    => 1,
            );

            my $TargetFilename = $FileName . $File;

            # Mac OS (HFS+) will store all filenames as NFD internally.
            if ( $^O eq 'darwin' && $Backend eq 'FS' ) {
                $TargetFilename = Unicode::Normalize::NFD($TargetFilename);
            }

            $Self->Is(
                $AttachmentIndex{1}->{Filename},
                $TargetFilename,
                "$Backend ArticleAttachmentIndex() Filename - $FileNew"
            );

            my %Data = $ArticleObject->ArticleAttachment(
                ArticleID => $ArticleID,
                FileID    => 1,
                UserID    => 1,
            );
            $Self->True(
                $Data{Content},
                "$Backend ArticleAttachment() Content - $FileNew",
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
            my $Delete = $ArticleObject->ArticleDeleteAttachment(
                ArticleID => $ArticleID,
                UserID    => 1,
            );
            $Self->True(
                $Delete,
                "$Backend ArticleDeleteAttachment() - $FileNew",
            );

            %AttachmentIndex = $ArticleObject->ArticleAttachmentIndex(
                ArticleID => $ArticleID,
                UserID    => 1,
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

    # Make sure that the TicketObject gets recreated for each loop.
    $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket::Article'] );

    $ConfigObject->Set(
        Key   => 'Ticket::StorageModule',
        Value => 'Kernel::System::Ticket::ArticleStorage' . $Backend,
    );

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    $Self->Is(
        $ArticleObject->{ArticleStorageModule},
        'Kernel::System::Ticket::ArticleStorage' . $Backend,
        "TicketObject loaded the correct backend",
    );

    # Store file 2 times
    my $FileName               = "[Terminology Guide äöß].pdf";
    my $Content                = '123';
    my $FileNew                = $FileName;
    my $ArticleWriteAttachment = $ArticleObject->ArticleWriteAttachment(
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

    $ArticleWriteAttachment = $ArticleObject->ArticleWriteAttachment(
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

    my %AttachmentIndex = $ArticleObject->ArticleAttachmentIndex(
        ArticleID => $ArticleID,
        UserID    => 1,
    );

    my $TargetFilename = '[Terminology Guide äöß]';

    if ( $Backend eq 'FS' ) {

        $TargetFilename = '_Terminology_Guide_äöß_';

        # Mac OS (HFS+) will store all filenames as NFD internally.
        if ( $^O eq 'darwin' ) {
            $TargetFilename = Unicode::Normalize::NFD($TargetFilename);
        }
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
            'Filesize'           => '3 Bytes',
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
            'Filesize'           => '3 Bytes',
            'FilesizeRaw'        => '3',
            'Disposition'        => 'attachment',
        },
        "$Backend ArticleAttachmentIndex - collision check entry 2",
    );

    my $Delete = $ArticleObject->ArticleDeleteAttachment(
        ArticleID => $ArticleID,
        UserID    => 1,
    );

    $Self->True(
        $Delete,
        "$Backend ArticleDeleteAttachment()",
    );

    %AttachmentIndex = $ArticleObject->ArticleAttachmentIndex(
        ArticleID => $ArticleID,
        UserID    => 1,
    );

    $Self->IsDeeply(
        \%AttachmentIndex,
        {},
        "$Backend ArticleAttachmentIndex() after delete",
    );
}

# cleanup is done by RestoreDatabase.

1;
