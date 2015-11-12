# --
# UTF8Filename.t - PostMaster tests for Message ID
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

use Kernel::System::PostMaster;
use Kernel::System::Ticket;

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

for my $Backend (qw(DB FS)) {

    $ConfigObject->Set(
        Key   => 'Ticket::StorageModule',
        Value => 'Kernel::System::Ticket::ArticleStorage' . $Backend,
    );

    my $Location = $ConfigObject->Get('Home')
        . "/scripts/test/sample/PostMaster/UTF8Filename.box";

    my $ContentRef = $MainObject->FileRead(
        Location => $Location,
        Mode     => 'binmode',
        Result   => 'ARRAY',
    );

    # new/clear ticket object
    my $TicketObject = Kernel::System::Ticket->new();

    my $TicketID;
    {
        my $PostMasterObject = Kernel::System::PostMaster->new(
            Email => $ContentRef,
        );

        my @Return = $PostMasterObject->Run();

        $TicketID = $Return[1];
    }

    $Self->True(
        $TicketID,
        "$Backend - Ticket created",
    );

    my @ArticleIDs = $TicketObject->ArticleIndex( TicketID => $TicketID );
    $Self->True(
        $ArticleIDs[0],
        "$Backend - Article created",
    );

    my %Attachments = $TicketObject->ArticleAttachmentIndex(
        ArticleID => $ArticleIDs[0],
        UserID    => 1,
    );

    $Self->IsDeeply(
        $Attachments{1},
        {
            ContentAlternative => '',
            ContentID          => '',
            Filesize           => '132 Bytes',
            ContentType        => 'application/pdf; name="=?UTF-8?Q?Documentacio=CC=81n=2Epdf?="',
            Filename           => 'Documentación.pdf',
            FilesizeRaw        => '132',
            Disposition        => 'attachment'
        },
        "$Backend - Attachment filename",
    );

    my $Success = $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => 1,
    );

    $Self->True(
        $Success,
        "$Backend - TicketDelete - removed ticket $TicketID",
    );
}

1;
