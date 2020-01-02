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

my $Helper               = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
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

    my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');
    my %ElementData     = (
        Sender    => 'mailqueue.test@otrs.com',
        Recipient => ['mailqueue.test@otrs.com'],
        Message   => {
            'Key1' => 'Value1',
            'Key2' => 'Value2',
        },
    );

    my %Elements = (
        "ArticleID::$ArticleID" => {
            %ElementData,
            ArticleID => $ArticleID,
            MessageID => 'dummy',
        },
        'ID::-99' => {
            %ElementData,
            ID => -99,
        }
    );

    for my $Key ( sort keys %Elements ) {
        my $Result = $MailQueueObject->Create( %{ $Elements{$Key} } );
        $Self->True(
            $Result,
            sprintf( 'Created the mail queue element "%s" successfuly.', $Key, ),
        );
    }

    return \%Elements;
};

my $Test = sub {
    my %Param = @_;

    my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');
    my $Filter          = $Param{Filter};
    my $ExpectedData    = \%{ $Param{ExpectedData} };

    my $Result;

    my $TestBaseMessage = sprintf(
        'Get queue element that match "%s"',
        join( ',', map { $_ . '=' . $Filter->{$_} } sort( keys %{$Filter} ) ),
    );

    $Result = $MailQueueObject->Get( %{$Filter} );
    $Self->True(
        $Result && scalar( keys %{$Result} ),
        $TestBaseMessage,
    );

    return if !$Result;

    # Remove from expected-data columns that doesn't belong to the record
    delete $ExpectedData->{MessageID};

    # Compare ExpectedData with Result.
    for my $Key ( sort( keys %{$ExpectedData} ) ) {
        my $ExpectedValue = $ExpectedData->{$Key};
        my $Value         = $Result->{$Key};

        if ( $Key eq 'Message' ) {
            my $Hash2Str = sub { return join ',', sort(@_); };
            $ExpectedValue = $Hash2Str->( %{$ExpectedValue} );
            $Value         = $Hash2Str->( %{$Value} );
        }
        elsif ( $Key eq 'Recipient' ) {
            $ExpectedValue = join ',', @{$ExpectedValue};
            $Value         = join ',', @{$Value};
        }

        if ( $Value ne $ExpectedValue ) {
            $Self->True(
                0,
                $TestBaseMessage . ', data match.',
            );

            return;
        }
    }

    $Self->True(
        1,
        $TestBaseMessage . ', data match.',
    );

    return;
};

my %Elements = %{ $CreateTestData->() };

# START THE TESTS

my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');
my $Result;

# Trying get a element without passing any param.
$Result = $MailQueueObject->Get();
$Self->False(
    $Result,
    'Parameters missing.',
);

# Get by ArticleID
$Test->(
    Filter => {
        ArticleID => $ArticleID,
    },
    ExpectedData => $Elements{"ArticleID::$ArticleID"},
);

# Get by ID
$Test->(
    Filter => {
        ID => -99,
    },
    ExpectedData => $Elements{'ID::-99'},
);

# restore to the previous state is done by RestoreDatabase

1;
