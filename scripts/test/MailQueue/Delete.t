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

my $CreateTestData = sub {
    my %Param = @_;

    my $MailQueueObject      = $Kernel::OM->Get('Kernel::System::MailQueue');
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

    my %ElementData = (
        Sender    => 'mailqueue.test@otrs.com',
        Recipient => 'mailqueue.test@otrs.com',
        Message   => {
            'Key1' => 'Value1',
            'Key2' => 'Value2',
        },
        ArticleID => $ArticleID,
        MessageID => 'dummy',
        ID        => -99,
    );

    my $Result = $MailQueueObject->Create( %ElementData, );
    $Self->True(
        $Result,
        'Created the test element successfuly.'
    );

    return \%ElementData;
};

my $Test = sub {
    my %Param = @_;

    my $Filters = $Param{Filters};
    my $Test    = $Param{Test};

    my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');
    my $Result;

    my $TestBaseMessage = sprintf(
        'Delete records that match "%s"',
        join( ',', map { $_ . '=' . $Filters->{$_} } sort( keys( %{$Filters} ) ) ),
    );

    $Result = $MailQueueObject->Delete( %{$Filters} );
    $Self->True( $Result, $TestBaseMessage, );

    # Ensure record doesn't exist.
    $Result = $MailQueueObject->List( %{$Filters} );
    $Self->True(
        $Result && scalar( @{$Result} ) == 0,
        $TestBaseMessage . ', records not found.',
    );

    return;
};

my $TestDeleteByID = sub {
    my %Param = @_;

    my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');
    my $Element         = $CreateTestData->();
    $Test->(
        Filters => {
            ID => $Element->{ID},
        },
    );

    return;
};

my $TestDeleteByArticleID = sub {
    my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');
    my $Element         = $CreateTestData->();
    $Test->(
        Filters => {
            ArticleID => $Element->{ArticleID},
        },
    );

    return;
};

my $TestDeleteByMultipleColumns = sub {
    my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');
    my $Element         = $CreateTestData->();
    $Test->(
        Filters => {
            ArticleID => $Element->{ArticleID},
            Sender    => 'mailqueue.test@otrs.com',
        },
    );

    return;
};

# START THE TESTS

$TestDeleteByID->();
$TestDeleteByArticleID->();
$TestDeleteByMultipleColumns->();

# restore to the previous state is done by RestoreDatabase

1;
