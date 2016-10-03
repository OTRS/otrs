# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
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
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

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
    'TicketCreate()',
);

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
    NoAgentNotify  => 1,
);

$Self->True(
    $ArticleID,
    'ArticleCreate()',
);

my @Tests = (

    # Latin characters, 1 byte per character when encoding
    # attachment with 20 character long Latin name,
    {
        Description => 'Latin 20 characters',
        FileName    => 'abcdefghjkabcdefghjk',
    },

    # attachment with 75 character long Latin FileName
    {
        Description => 'Latin 75 characters',
        FileName    => 'abcdefghjkabcdefghjkabcdefghjkabcdefghjkabcdefghjkabcdefghjkabcdefghjkabcde',
    },

    # attachment with 120 character long Latin FileName
    {
        Description => 'Latin 120 characters',
        FileName =>
            'abcdefghjkabcdefghjkabcdefghjkabcdefghjkabcdefghjkabcdefghjkabcdefghjkabcdefghjkabcdefghjkabcdefghjkabcdefghjkabcdefghjk',
    },

    # attachment with 140 character long Latin FileName
    {
        Description => 'Latin 140 characters',
        FileName =>
            'abcdefghjkabcdefghjkabcdefghjkabcdefghjkabcdefghjkabcdefghjkabcdefghjkabcdefghjkabcdefghjkabcdefghjkabcdefghjkabcdefghjkabcdefghjkabcdefghjk',
    },

    # Cyrillic character, 2 byte per character when encoding
    # attachment with 20 character long Cyrillic name,
    {
        Description => 'Cyrillic 20 characters',
        FileName    => 'шђпчћжђшпчшђпчћжђшпч',
    },

    # attachment with 75 character long Cyrillic FileName
    {
        Description => 'Cyrillic 75 characters',
        FileName =>
            'шђпчћжђшпчшђпчћжђшпчшђпчћжђшпчшђпчћжђшпчшђпчћжђшпчшђпчћжђшпчшђпчћжђшпчшђпчћ',
    },

    # attachment with 120 character long Cyrillic FileName, approximately limit for
    # Linux file name reaching 255 bytes after encoding Cyrillic letters
    {
        Description => 'Cyrillic 120 characters',
        FileName =>
            'шђпчћжђшпчшђпчћжђшпчшђпчћжђшпчшђпчћжђшпчшђпчћжђшпчшђпчћжђшпчшђпчћжђшпчшђпчћжђшпчшђпчћжђшпчшђпчћжђшпчшђпчћжђшпчшђпчћжђшпч',
    },

    # attachment with 140 character long Cyrillic FileName
    # have to cut name to create attachment file in FS backend
    {
        Description => 'Cyrillic 140 characters',
        FileName =>
            'шђпчћжђшпчшђпчћжђшпчшђпчћжђшпчшђпчћжђшпчшђпчћжђшпчшђпчћжђшпчшђпчћжђшпчшђпчћжђшпчшђпчћжђшпчшђпчћжђшпчшђпчћжђшпчшђпчћжђшпчшђпчћжђшпчшђпчћжђшпч',
    },

    # Japanese charcters, 3 byte per character when encoding
    # there are issues on some systems when encoding 3 byte characters, skip these tests on them
    # attachment with 20 character long Japanese name,
    {
        Description => 'Japanese 20 characters',
        FileName    => '人だけの会員制転職サ人だけの会員制転職サ',
        OSCheck     => 1,
    },

    # attachment with 75 character long Japanese FileName, approximately limit for
    # Linux file name reaching 255 bytes after encoding Japanese letters
    {
        Description => 'Japanese 75 characters',
        FileName =>
            '人だけの会員制転職サ人だけの会員制転職サ人だけの会員制転職サ人だけの会員制転職サ人だけの会員制転職サ人だけの会員制転職サ人だけの会員制転職サ人だけの会',
        OSCheck => 1,
    },

    # attachment with 120 character long Japanese FileName
    # have to cut name to create attachment file in FS backend
    {
        Description => 'Japanese 120 characters',
        FileName =>
            '人だけの会員制転職サ人だけの会員制転職サ人だけの会員制転職サ人だけの会員制転職サ人だけの会員制転職サ人だけの会員制転職サ人だけの会員制転職サ人だけの会員制転職サ人だけの会員制転職サ人だけの会員制転職サ人だけの会員制転職サ人だけの会員制転職サ',
        OSCheck => 1,
    },

    # attachment with 140 character long Japanese FileName
    # have to cut name to create attachment file in FS backend
    {
        Description => 'Japanese 140 characters',
        FileName =>
            '人だけの会員制転職サ人だけの会員制転職サ人だけの会員制転職サ人だけの会員制転職サ人だけの会員制転職サ人だけの会員制転職サ人だけの会員制転職サ人だけの会員制転職サ人だけの会員制転職サ人だけの会員制転職サ人だけの会員制転職サ人だけの会員制転職サ人だけの会員制転職サ人だけの会員制転職サ',
        OSCheck => 1,
    },
);

# check if environment supports 3-byte characters in filenames
my $MultiByteSupport = 0;
my $TempDirectory    = $ConfigObject->Get('Home') . '/var/tmp/';
my $TempFilename     = '人だけの会員制転職サ人だけの会員制転職サ.txt';
my $FSTempFilename   = $MainObject->FileWrite(
    Directory => $TempDirectory,
    Filename  => $TempFilename,
    Content   => \'',
);

# check if filenames are identical
if ( $FSTempFilename eq $TempFilename ) {
    $MultiByteSupport = 1;
}

# cleanup
$MainObject->FileDelete(
    Directory       => $TempDirectory,
    Filename        => $FSTempFilename,
    Type            => 'Local',
    DisableWarnings => 1,
);

TEST:
for my $Test (@Tests) {

    # article attachment checks
    for my $Backend (qw(DB FS)) {

        # skip tests cases for 3 byte characters, if system does not support it
        if ( !$MultiByteSupport && $Test->{OSCheck} ) {
            $Self->True(
                1,
                "Skipping test - $Test->{Description} - system does not support 3-byte characters in FS",
            );
            next TEST;
        }

        # make sure that the TicketObject gets recreated for each loop.
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

        my $Ext                    = '.txt';
        my $FileName               = $Test->{FileName} . $Ext;
        my $Content                = '123';
        my $MD5Orig                = $MainObject->MD5sum( String => $Content );
        my $ArticleWriteAttachment = $TicketObject->ArticleWriteAttachment(
            Content     => $Content,
            Filename    => $FileName,
            ContentType => 'text/html',
            ArticleID   => $ArticleID,
            UserID      => 1,
        );
        $Self->True(
            $ArticleWriteAttachment,
            "$Backend ArticleWriteAttachment() - $Test->{Description} - Original name $FileName",
        );

        my %AttachmentIndex = $TicketObject->ArticleAttachmentIndex(
            ArticleID => $ArticleID,
            UserID    => 1,
        );

        # get target file name
        my $TargetFileName;
        if ( $Backend eq 'DB' ) {
            $TargetFileName = $FileName,
        }
        else {
            $TargetFileName = $MainObject->FilenameCleanUp(
                Filename => $FileName,
                Type     => 'Local',
            );
        }

        # Normalize filename to properly compare file names which are identical but in a different unicode form
        if ( $Backend eq 'FS' ) {
            $TargetFileName = Unicode::Normalize::NFD($TargetFileName);
        }

        $Self->Is(
            $AttachmentIndex{1}->{Filename},
            $TargetFileName,
            "$Backend ArticleAttachmentIndex() Attachment name $Test->{Description}"
        );

        my %Data = $TicketObject->ArticleAttachment(
            ArticleID => $ArticleID,
            FileID    => 1,
            UserID    => 1,
        );
        $Self->True(
            $Data{Content},
            "$Backend ArticleAttachment() Content - Attachment name $Test->{Description}",
        );
        $Self->True(
            $Data{ContentType},
            "$Backend ArticleAttachment() ContentType - Attachment name $Test->{Description}",
        );
        $Self->True(
            $Data{Content} eq $Content,
            "$Backend ArticleWriteAttachment() / ArticleAttachment() Content - Attachment name $Test->{Description}",
        );
        $Self->True(
            $Data{ContentType} eq 'text/html',
            "$Backend ArticleWriteAttachment() / ArticleAttachment() ContentType - Attachment name $Test->{Description}",
        );
        my $MD5New = $MainObject->MD5sum( String => $Data{Content} );
        $Self->Is(
            $MD5Orig || '1',
            $MD5New  || '2',
            "$Backend MD5 - Attachment name $Test->{Description}",
        );
        my $Delete = $TicketObject->ArticleDeleteAttachment(
            ArticleID => $ArticleID,
            UserID    => 1,
        );
        $Self->True(
            $Delete,
            "$Backend ArticleDeleteAttachment() - Attachment name $Test->{Description}",
        );

        %AttachmentIndex = $TicketObject->ArticleAttachmentIndex(
            ArticleID => $ArticleID,
            UserID    => 1,
        );

        $Self->IsDeeply(
            \%AttachmentIndex,
            {},
            "$Backend ArticleAttachmentIndex() after delete - Attachment name $Test->{Description}"
        );
    }
}

# the ticket is no longer needed
$TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);

$Self->True(
    $TicketObject,
    'TicketDelete()',
);
