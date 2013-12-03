# --
# Replace.t - template generator
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use utf8;
use vars (qw($Self));

use Kernel::Config;
use Kernel::System::Ticket;
use Kernel::System::TemplateGenerator;
use Kernel::System::CustomerUser;
use Kernel::System::Queue;

# create local objects
my $ConfigObject = Kernel::Config->new();
my $UserObject   = Kernel::System::User->new(
    ConfigObject => $ConfigObject,
    %{$Self},
);
my $CustomerUserObject = Kernel::System::CustomerUser->new(
    ConfigObject => $ConfigObject,
    %{$Self},
);
my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $QueueObject = Kernel::System::Queue->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $TemplateGeneratorObject = Kernel::System::TemplateGenerator->new(
    %{$Self},
    ConfigObject       => $ConfigObject,
    TicketObject       => $TicketObject,
    UserObject         => $UserObject,
    CustomerUserObject => $CustomerUserObject,
    QueueObject        => $QueueObject,
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

my @Tests = (
    {
        Name => 'simple replace',
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_CUSTOMER_From>',
        Result   => 'Test test@home.com',
    },
    {
        Name => 'simple replace, case insensitive',
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_CUSTOMER_FROM>',
        Result   => 'Test test@home.com',
    },
    {
        Name => 'remove unknown tags',
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_CUSTOMER_INVALID_TAG>',
        Result   => 'Test -',
    },
);

for my $Test (@Tests) {
    my $Result = $TemplateGeneratorObject->_Replace(
        Text     => $Test->{Template},
        Data     => $Test->{Data},
        RichText => $Test->{RichText},
        UserID   => 1,
    );
    $Self->Is(
        $Result,
        $Test->{Result},
        $Test->{Name},
    );
}

# the ticket is no longer needed
$TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);

1;
