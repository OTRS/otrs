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
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $CreateMailQueueElement = sub {
    my %Param = @_;

    my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');
    my %ElementData     = (
        Sender    => 'mailqueue.test@otrs.com',
        Recipient => 'mailqueue.test@otrs.com',
        Message   => {
            'Key1' => 'Value1',
            'Key2' => 'Value2',
        },
    );

    return $MailQueueObject->Create(
        %ElementData,
        %Param,
    );
};

# START THE TESTS

# Ensure check mail addresses is enabled.
$Helper->ConfigSettingChange(
    Key   => 'CheckEmailAddresses',
    Value => 1,
);

# Disable MX record check.
$Helper->ConfigSettingChange(
    Key   => 'CheckMXRecord',
    Value => 0,
);

my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');
my $Result;

# Pass no params.
$Result = $MailQueueObject->Create();
$Self->False(
    $Result,
    'Trying to create a queue element without passing params.',
);

# Pass an invalid sender address
$Result = $CreateMailQueueElement->(
    Sender => 'dummy',
);
$Self->False(
    $Result,
    'Trying to create a queue element with an invalid sender.',
);

# Pass an invalid Recipient address
$Result = $CreateMailQueueElement->(
    Recipient => 'dummy',
);
$Self->False(
    $Result,
    'Trying to create a queue element with an invalid recipient.',
);

# Pass an invalid Recipient address (array)
$Result = $CreateMailQueueElement->(
    Recipient => [ 'mailqueue.test@otrs.com', 'dummy' ],
);
$Self->False(
    $Result,
    'Trying to create a queue element with an invalid recipient (array).',
);

# Simple recipient
$Result = $CreateMailQueueElement->();
$Self->True(
    $Result,
    'Trying to create a queue element with simple recipient.',
);

# ArrayRef recipient
$Result = $CreateMailQueueElement->(
    Recipient => [ 'mailqueue.test@otrs.com', 'mailqueue.test@otrs.com' ],
);
$Self->True(
    $Result,
    'Trying to create a queue element with arrayref recipient.',
);

my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $QueueObject          = $Kernel::OM->Get('Kernel::System::Queue');
my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
    ChannelName => 'Email',
);

# Create test queue.
my $QueueName = 'Queue' . $Helper->GetRandomID();
my $QueueID   = $QueueObject->QueueAdd(
    Name            => $QueueName,
    ValidID         => 1,
    GroupID         => 1,
    SystemAddressID => 1,
    FollowUpID      => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    Comment         => 'UnitTest queue',
    UserID          => 1,
);
$Self->True(
    $QueueID,
    "Test QueueAdd() - QueueID $QueueID",
);

# Create test ticket.
my $TicketID = $TicketObject->TicketCreate(
    Title        => 'UnitTest ticket one',
    QueueID      => 1,
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'open',
    CustomerID   => '12345',
    CustomerUser => 'test@localunittest.com',
    OwnerID      => 1,
    UserID       => 1,
);
$Self->True(
    $TicketID,
    "Test TicketCreate() - TicketID $TicketID",
);

# Create article for test ticket one.
my $ArticleID = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID,
    IsVisibleForCustomer => 1,
    SenderType           => 'customer',
    Subject              => 'UnitTest article one',
    From                 => '"test" <test@localunittest.com>',
    To                   => $QueueName,
    Body                 => 'UnitTest body',
    Charset              => 'utf-8',
    MimeType             => 'text/plain',
    HistoryType          => 'PhoneCallCustomer',
    HistoryComment       => 'Some free text!',
    UserID               => 1,
    UnlockOnAway         => 1,
    AutoResponseType     => 'auto follow up',
    OrigHeader           => {
        From    => '"test" <test@localunittest.com>',
        To      => $QueueName,
        Subject => 'UnitTest article one',
        Body    => 'UnitTest body',

    },
    Queue => $QueueName,
);
$Self->True(
    $ArticleID,
    "Test  ArticleCreate() - ArticleID $ArticleID",
);

for my $Idx ( 0 .. 1 ) {
    $Result = $CreateMailQueueElement->(
        ArticleID => $ArticleID,
        MessageID => 'dummy',
    );
    my $TestType = $Idx ? 'False' : 'True';
    $Self->$TestType(
        $Result,
        'Trying to create a queue element to article-id 1, attempt ' . ( $Idx + 1 ),
    );
}

# Check if communication-log lookup was created.
my $Item = $MailQueueObject->Get(
    ArticleID => $ArticleID,
);
my $CommunicationLogDBObj = $Kernel::OM->Get(
    'Kernel::System::CommunicationLog::DB',
);
my $ComLookupInfo = $CommunicationLogDBObj->ObjectLookupGet(
    TargetObjectType => 'MailQueueItem',
    TargetObjectID   => $Item->{ID},
) || {};

$Self->True(
    $ComLookupInfo->{ObjectLogID},
    'Found communication-log lookup information for the queue element.',
);

# Restore to the previous state is done by RestoreDatabase.

1;
