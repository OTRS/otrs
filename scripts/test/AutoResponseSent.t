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

my $SendLastTicketArticleMail = sub {
    my %Param = @_;

    my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');
    my $ArticleObject   = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    my @Articles = $ArticleObject->ArticleList(
        TicketID => $Param{TicketID},
        OnlyLast => 1,
    );
    my $MailQueueItem = $MailQueueObject->Get(
        ArticleID => $Articles[0]->{ArticleID},
    );

    if ( !$MailQueueItem || !%{$MailQueueItem} ) { return; }

    $MailQueueObject->Send( %{$MailQueueItem}, );

    return 1;
};

# get needed objects
my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');
my $QueueObject          = $Kernel::OM->Get('Kernel::System::Queue');
my $AutoResponseObject   = $Kernel::OM->Get('Kernel::System::AutoResponse');
my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $TestEmailObject      = $Kernel::OM->Get('Kernel::System::Email::Test');
my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
    ChannelName => 'Email',
);
my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# don't validate email addresses
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# use test email backend
my $Success = $ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::Test',
);
$Self->True(
    $Success,
    "Set test backend Email - true",
);

# get test data
my @Tests = (
    {
        Subject            => 'AutoResponse Reply',
        AutoResponseTypeID => 1,
        AutoResponseType   => 'auto reply',
        TicketState        => 'open',
    },
    {
        Subject            => 'AutoResponse Follow Up',
        FollowUpID         => 1,                          # Queue follow up option 'possible'
        AutoResponseTypeID => 3,
        AutoResponseType   => 'auto follow up',
        TicketState        => 'open',
    },
    {
        Subject            => 'AutoResponse Reject',
        FollowUpID         => 2,                          # Queue follow up option 'rejected'
        AutoResponseTypeID => 2,
        AutoResponseType   => 'auto reject',
        TicketState        => 'closed successful',
    },
    {
        Subject            => 'AutoResponse Reply/New Ticket',
        FollowUpID         => 3,                                 # Queue follow up option 'new ticket'
        AutoResponseTypeID => 4,
        AutoResponseType   => 'auto reply/new ticket',
        TicketState        => 'closed successful',
    },
    {
        Subject            => 'AutoResponse Remove',
        AutoResponseTypeID => 5,
        AutoResponseType   => 'auto remove',
        TicketState        => 'removed',
    },
);

# run test
my @QueueIDs;
my @TicketIDs;
my @AutoResponseIDs;
my $Count = 1;
for my $Test (@Tests) {

    # clean up test email backend
    $Success = $TestEmailObject->CleanUp();
    $Self->True(
        $Success,
        "Test $Count : Test backend Email initial cleanup",
    );
    $Self->IsDeeply(
        $TestEmailObject->EmailsGet(),
        [],
        "Test $Count : Test backend Email empty after initial cleanup",
    );

    # create test queue
    my $QueueName = 'Queue' . $Helper->GetRandomID();
    my $QueueID   = $QueueObject->QueueAdd(
        Name            => $QueueName,
        ValidID         => 1,
        GroupID         => 1,
        SystemAddressID => 1,
        FollowUpID      => $Test->{FollowUpID},
        SalutationID    => 1,
        SignatureID     => 1,
        Comment         => 'UnitTest queue',
        UserID          => 1,
    );
    $Self->True(
        $QueueID,
        "Test $Count : QueueAdd() - QueueID $QueueID",
    );
    push @QueueIDs, $QueueID;

    # create test auto-response
    my $AutoResponseName = 'AutoResponse' . $Helper->GetRandomID();
    my $AutoResponseID   = $AutoResponseObject->AutoResponseAdd(
        Name        => $AutoResponseName,
        ValidID     => 1,
        Subject     => $Test->{Subject},
        Response    => 'UnitTest AutoResponse response',
        ContentType => 'text/plain',
        AddressID   => 1,
        TypeID      => $Test->{AutoResponseTypeID},
        UserID      => 1,
    );
    $Self->True(
        $AutoResponseID,
        "Test $Count : AutoResponseAdd() - AutoResponseID $AutoResponseID",
    );
    push @AutoResponseIDs, $AutoResponseID;

    # assigns test auto-responses to a test queue
    my $AutoResponseQueue = $AutoResponseObject->AutoResponseQueue(
        QueueID         => $QueueID,
        AutoResponseIDs => [$AutoResponseID],
        UserID          => 1,
    );
    $Self->True(
        $AutoResponseQueue,
        "Test $Count : AutoResponseQueue() - added relation",
    );

    # create test ticket
    my $TicketIDOne = $TicketObject->TicketCreate(
        Title        => 'UnitTest ticket one',
        QueueID      => $QueueID,
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'open',
        CustomerID   => '12345',
        CustomerUser => 'test@localunittest.com',
        OwnerID      => 1,
        UserID       => 1,
    );
    $Self->True(
        $TicketIDOne,
        "Test $Count : TicketCreate() - TicketID $TicketIDOne",
    );
    push @TicketIDs, $TicketIDOne;

    # create article for test ticket one
    my $ArticleIDOne = $ArticleBackendObject->ArticleCreate(
        TicketID             => $TicketIDOne,
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
        AutoResponseType     => $Test->{AutoResponseType},
        OrigHeader           => {
            From    => '"test" <test@localunittest.com>',
            To      => $QueueName,
            Subject => 'UnitTest article one',
            Body    => 'UnitTest body',

        },
        Queue => $QueueName,
    );
    $Self->True(
        $ArticleIDOne,
        "Test $Count : ArticleCreate() - ArticleID $ArticleIDOne",
    );

    {
        # Get last article for the ticket and really send it
        my $LastArticleMailSent = $SendLastTicketArticleMail->(
            TicketID => $TicketIDOne,
        );

        # check if AutoResponse is sent
        my $Emails = $TestEmailObject->EmailsGet();

        $Self->True(
            $LastArticleMailSent && ( scalar @{$Emails} ) == 1,
            "Test $Count : Emails fetched from backend - AutoResponse $Test->{AutoResponseType} sent",
        );
    }

    # clean up test email backend again
    $Success = $TestEmailObject->CleanUp();
    $Self->True(
        $Success,
        "Test $Count : Test backend Email cleanup - success",
    );
    $Self->IsDeeply(
        $TestEmailObject->EmailsGet(),
        [],
        "Test $Count : Test backend Email - empty after cleanup",
    );

    # check auto response suppression with X-OTRS-Loop
    $ArticleIDOne = $ArticleBackendObject->ArticleCreate(
        TicketID             => $TicketIDOne,
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
        AutoResponseType     => $Test->{AutoResponseType},
        OrigHeader           => {
            From          => '"test" <test@localunittest.com>',
            To            => $QueueName,
            Subject       => 'UnitTest article one',
            Body          => 'UnitTest body',
            'X-OTRS-Loop' => 'yes'

        },
        Queue => $QueueName,
    );
    $Self->True(
        $ArticleIDOne,
        "Test $Count : ArticleCreate() - ArticleID $ArticleIDOne",
    );

    {
        # Get last article for the ticket and really send it
        my $LastArticleMailSent = $SendLastTicketArticleMail->(
            TicketID => $TicketIDOne,
        );

        # check if AutoResponse is sent
        my $Emails = $TestEmailObject->EmailsGet();
        $Self->True(
            !$LastArticleMailSent && !scalar( @{$Emails} ),
            "Test $Count : Emails fetched from backend - AutoResponse $Test->{AutoResponseType} suppressed by X-OTRS-Loop",
        );
    }

    # clean up test email backend again
    $Success = $TestEmailObject->CleanUp();
    $Self->True(
        $Success,
        "Test $Count : Test backend Email cleanup - success",
    );
    $Self->IsDeeply(
        $TestEmailObject->EmailsGet(),
        [],
        "Test $Count : Test backend Email - empty after cleanup",
    );

    # check auto response re-enabling with X-OTRS-Loop
    $ArticleIDOne = $ArticleBackendObject->ArticleCreate(
        TicketID             => $TicketIDOne,
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
        AutoResponseType     => $Test->{AutoResponseType},
        OrigHeader           => {
            From          => '"test" <test@localunittest.com>',
            To            => $QueueName,
            Subject       => 'UnitTest article one',
            Body          => 'UnitTest body',
            'X-OTRS-Loop' => 'no'

        },
        Queue => $QueueName,
    );
    $Self->True(
        $ArticleIDOne,
        "Test $Count : ArticleCreate() - ArticleID $ArticleIDOne",
    );

    {
        # Get last article for the ticket and really send it
        my $LastArticleMailSent = $SendLastTicketArticleMail->(
            TicketID => $TicketIDOne,
        );

        # check if AutoResponse is sent
        my $Emails = $TestEmailObject->EmailsGet();
        $Self->True(
            $LastArticleMailSent && ( scalar @{$Emails} ) == 1,
            "Test $Count : Emails fetched from backend - AutoResponse $Test->{AutoResponseType} re-enabled by X-OTRS-Loop",
        );
    }

    # clean up test email backend again
    $Success = $TestEmailObject->CleanUp();
    $Self->True(
        $Success,
        "Test $Count : Test backend Email cleanup - success",
    );
    $Self->IsDeeply(
        $TestEmailObject->EmailsGet(),
        [],
        "Test $Count : Test backend Email - empty after cleanup",
    );

    # test if auto-response get activated once it's invalid
    # see bug bug#11481
    # set test AutoResponse on ivalid
    $Success = $AutoResponseObject->AutoResponseUpdate(
        ID          => $AutoResponseID,
        Name        => $AutoResponseName,
        ValidID     => 2,
        Subject     => $Test->{Subject},
        Response    => 'UnitTest AutoResponse response',
        ContentType => 'text/plain',
        AddressID   => 1,
        TypeID      => $Test->{AutoResponseTypeID},
        UserID      => 1,
    );
    $Self->True(
        $Success,
        "Test $Count : AutoResponseUpdate() - AutoResponse $Test->{AutoResponseType} - set to invalid",
    );

    # create new test ticket
    my $TicketIDTwo = $TicketObject->TicketCreate(
        Title        => 'UnitTest ticket two',
        QueueID      => $QueueID,
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'open',
        CustomerID   => '12345',
        CustomerUser => 'test@localunittest.com',
        OwnerID      => 1,
        UserID       => 1,
    );
    $Self->True(
        $TicketIDTwo,
        "Test $Count : TicketCreate() - TicketID $TicketIDTwo",
    );
    push @TicketIDs, $TicketIDTwo;

    # create article two for test ticket two
    my $ArticleIDTwo = $ArticleBackendObject->ArticleCreate(
        TicketID             => $TicketIDTwo,
        IsVisibleForCustomer => 1,
        SenderType           => 'customer',
        Subject              => 'UnitTest article two',
        From                 => '"test" <test@localunittest.com>',
        To                   => $QueueName,
        Body                 => 'UnitTest body',
        Charset              => 'utf-8',
        MimeType             => 'text/plain',
        HistoryType          => 'PhoneCallCustomer',
        HistoryComment       => 'Some free text!',
        UserID               => 1,
        UnlockOnAway         => 1,
        AutoResponseType     => $Test->{AutoResponseType},
        OrigHeader           => {
            From    => '"test" <test@localunittest.com>',
            To      => $QueueName,
            Subject => 'UnitTest article two',
            Body    => 'UnitTest body',

        },
        Queue => $QueueName,
    );
    $Self->True(
        $ArticleIDTwo,
        "Test $Count : ArticleCreate() - ArticleID $ArticleIDTwo",
    );

    {
        # Get last article for the ticket and really send it
        my $LastArticleMailSent = $SendLastTicketArticleMail->(
            TicketID => $TicketIDTwo,
        );

        my $Emails = $TestEmailObject->EmailsGet();

        # check if AutoResponse is sent while invalid
        $Self->True(
            !$LastArticleMailSent && !( scalar @{$Emails} ),
            "Test $Count : Test backend Email empty - AutoResponse $Test->{AutoResponseType} not sent while invalid",
        );
    }

    $Count++;
}

# cleanup is done by RestoreDatabase

1;
