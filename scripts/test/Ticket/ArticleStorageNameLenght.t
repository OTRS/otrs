# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;

use vars (qw($Self));

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper               = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Internal' );

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# Create test ticket and add an article to it.
my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'unittest@otrs.com',
    OwnerID      => 1,
    UserID       => 1,
);
$Self->True(
    $TicketID,
    "TicketCreate - TicketID $TicketID",
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
    "ArticleCreate - ArticleID $ArticleID",
);

# Define 1, 2 and 3 byte per character codes.
#   To check byte count, run: perl -CS -e 'print "\x{CODE}"' | wc -c
my %Characters = (
    Latin    => "\x{0061}",
    Cyrillic => "\x{0448}",
    Japanese => "\x{306C}",
);

my @Tests = (

    # Latin characters, 1 byte per character when encoding.
    #   Attachment with 20 character long Latin name.
    {
        Description => 'Latin 20 characters',
        FileName    => $Characters{Latin} x 20,
    },

    # Attachment with 75 character long Latin name.
    {
        Description => 'Latin 75 characters',
        FileName    => $Characters{Latin} x 75,
    },

    # Attachment with 120 character long Latin name.
    {
        Description => 'Latin 120 characters',
        FileName    => $Characters{Latin} x 120,
    },

    # Attachment with 140 character long Latin name.
    {
        Description => 'Latin 140 characters',
        FileName    => $Characters{Latin} x 140,
    },

    # Attachment with 245 character long Latin name.
    {
        Description => 'Latin 245 characters',
        FileName    => $Characters{Latin} x 245,
    },

    # Attachment with 300 character long Latin name.
    {
        Description => 'Latin 300 characters',
        FileName    => $Characters{Latin} x 300,
    },

    # Cyrillic characters, 2 byte per character when encoding.
    #   Attachment with 20 character long Cyrillic name.
    {
        Description => 'Cyrillic 20 characters',
        FileName    => $Characters{Cyrillic} x 20,
    },

    # Attachment with 75 character long Cyrillic name.
    {
        Description => 'Cyrillic 75 characters',
        FileName    => $Characters{Cyrillic} x 75,
    },

    # Attachment with 120 character long Cyrillic name, approximately limit for
    #   Linux file name reaching 255 bytes after encoding Cyrillic letters.
    {
        Description => 'Cyrillic 120 characters',
        FileName    => $Characters{Cyrillic} x 120,
    },

    # Attachment with 140 character long Cyrillic name.
    #   Will have to be cut in order to create attachment file in FS backend.
    {
        Description => 'Cyrillic 140 characters',
        FileName    => $Characters{Cyrillic} x 140,
    },

    # Japanese characters, 3 byte per character when encoding.
    #   Some systems do not support 3 byte characters in their filesystem, test will be skipped on
    #   them. Please see check below.
    {
        Description => 'Japanese 20 characters',
        FileName    => $Characters{Japanese} x 20,
        OSCheck     => 1,
    },

    # Attachment with 75 character long Japanese name, approximately limit for
    #   Linux file name reaching 255 bytes after encoding Japanese letters.
    {
        Description => 'Japanese 75 characters',
        FileName    => $Characters{Japanese} x 75,
        OSCheck     => 1,
    },

    # Attachment with 120 character long Japanese name.
    #   Will have to be cut in order to create attachment file in FS backend.
    {
        Description => 'Japanese 120 characters',
        FileName    => $Characters{Japanese} x 120,
        OSCheck     => 1,
    },

    # Attachment with 140 character long Japanese name.
    #   Will have to be cut in order to create attachment file in FS backend.
    {
        Description => 'Japanese 140 characters',
        FileName    => $Characters{Japanese} x 140,
        OSCheck     => 1,
    },
);

# Check if environment supports 3-byte encoded characters in filenames.
my $MultiByteSupport = 0;
my $TempDirectory    = $ConfigObject->Get('Home') . '/var/tmp/';
my $TempFilename     = ( $Characters{Japanese} x 5 ) . '.txt';
my $FSTempFilename   = $MainObject->FileWrite(
    Directory => $TempDirectory,
    Filename  => $TempFilename,
    Content   => \'',
);

# Check if filenames are identical.
if ( $FSTempFilename eq $TempFilename ) {
    $MultiByteSupport = 1;
}

# Delete the test file.
$MainObject->FileDelete(
    Directory       => $TempDirectory,
    Filename        => $FSTempFilename,
    Type            => 'Local',
    DisableWarnings => 1,
);

TEST:
for my $Test (@Tests) {

    # Check both storage backends.
    for my $Backend (qw(DB FS)) {

        # Skip tests cases for 3 byte characters, if system does not support them.
        if ( $Backend eq 'FS' && !$MultiByteSupport && $Test->{OSCheck} ) {
            $Self->True(
                1,
                "Skipping test - $Test->{Description} - system does not support 3-byte characters in FS",
            );
            next TEST;
        }

        # Make sure that the article backend object gets recreated for each loop.
        $Kernel::OM->ObjectsDiscard( Objects => [ ref $ArticleBackendObject ] );

        $ConfigObject->Set(
            Key   => 'Ticket::Article::Backend::MIMEBase::ArticleStorage',
            Value => 'Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorage' . $Backend,
        );

        # Re-create article backend object for every run, in order to reflect the article storage backend change.
        $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Internal' );

        $Self->Is(
            $ArticleBackendObject->{ArticleStorageModule},
            'Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorage' . $Backend,
            'Article backend loaded the correct storage module'
        );

        # Re-create article backend object for every run, in order to reflect the article storage backend change.
        my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Internal' );

        my $Ext                    = '.txt';
        my $FileName               = $Test->{FileName} . $Ext;
        my $Content                = '123';
        my $MD5Orig                = $MainObject->MD5sum( String => $Content );
        my $ArticleWriteAttachment = $ArticleBackendObject->ArticleWriteAttachment(
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

        my %AttachmentIndex = $ArticleBackendObject->ArticleAttachmentIndex(
            ArticleID => $ArticleID,
            UserID    => 1,
        );

        # Get attachment file name.
        my $TargetFileName = $MainObject->FilenameCleanUp(
            Filename => $FileName,
            Type     => 'Local',
        );

        $Self->Is(
            $AttachmentIndex{1}->{Filename},
            $TargetFileName,
            "$Backend ArticleAttachmentIndex() Attachment name $Test->{Description}"
        );

        my %Data = $ArticleBackendObject->ArticleAttachment(
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
        my $Delete = $ArticleBackendObject->ArticleDeleteAttachment(
            ArticleID => $ArticleID,
            UserID    => 1,
        );
        $Self->True(
            $Delete,
            "$Backend ArticleDeleteAttachment() - Attachment name $Test->{Description}",
        );

        %AttachmentIndex = $ArticleBackendObject->ArticleAttachmentIndex(
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

# Cleanup is done by RestoreDatabase, but we need to delete the tickets to cleanup the filesystem too.
my @DeleteTicketList = $TicketObject->TicketSearch(
    Result            => 'ARRAY',
    CustomerUserLogin => 'unittest@otrs.com',
    UserID            => 1,
);
for my $TicketID (@DeleteTicketList) {
    $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => 1,
    );
}

1;
