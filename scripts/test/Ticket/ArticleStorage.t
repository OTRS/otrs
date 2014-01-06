# --
# ArticleStorage.t - ticket module testscript
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: ArticleStorage.t,v 1.1 2011-08-30 11:46:50 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use utf8;
use vars (qw($Self));

use Time::HiRes qw( usleep );

use Kernel::Config;
use Kernel::System::Ticket;

# create local objects
my $ConfigObject = Kernel::Config->new();
my $UserObject   = Kernel::System::User->new(
    ConfigObject => $ConfigObject,
    %{$Self},
);
my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

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
    NoAgentNotify => 1,    # if you don't want to send agent notifications
);

$Self->True(
    $ArticleID,
    'ArticleCreate()',
);

# article attachment checks
for my $Backend (qw(DB FS)) {
    $ConfigObject->Set(
        Key   => 'Ticket::StorageModule',
        Value => 'Kernel::System::Ticket::ArticleStorage' . $Backend,
    );
    my $TicketObject = Kernel::System::Ticket->new(
        %{$Self},
        ConfigObject => $ConfigObject,
    );
    for my $File (
        qw(Ticket-Article-Test1.xls Ticket-Article-Test1.txt Ticket-Article-Test1.doc
        Ticket-Article-Test1.png Ticket-Article-Test1.pdf Ticket-Article-Test-utf8-1.txt Ticket-Article-Test-utf8-1.bin)
        )
    {
        my $Location = $Self->{ConfigObject}->Get('Home')
            . "/scripts/test/sample/Ticket/$File";
        my $ContentRef = $Self->{MainObject}->FileRead(
            Location => $Location,
            Mode     => 'binmode',
        );
        my $Content                = ${$ContentRef};
        my $FileNew                = "ÄÖÜ ? カスタマ-" . $File;
        my $MD5Orig                = $Self->{MainObject}->MD5sum( String => $Content );
        my $ArticleWriteAttachment = $TicketObject->ArticleWriteAttachment(
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
        my %Data = $TicketObject->ArticleAttachment(
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
        my $MD5New = $Self->{MainObject}->MD5sum( String => $Data{Content} );
        $Self->Is(
            $MD5Orig || '1',
            $MD5New  || '2',
            "$Backend MD5 - $FileNew",
        );
        my $Delete = $TicketObject->ArticleDeleteAttachment(
            ArticleID => $ArticleID,
            UserID    => 1,
        );
        $Self->True(
            $Delete,
            "$Backend ArticleDeleteAttachment() - $FileNew",
        );
    }
}

# the ticket is no longer needed
$TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);

1;
