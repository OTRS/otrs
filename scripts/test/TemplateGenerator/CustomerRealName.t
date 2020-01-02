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

use Kernel::System::PostMaster;

# get needed objects
my $AutoResponseObject = $Kernel::OM->Get('Kernel::System::AutoResponse');
my $CommandObject      = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::PostMaster::Read');
my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper   = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $RandomID = $Helper->GetRandomID();

# do not check email addresses
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# do not really send emails
$ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::DoNotSendEmail',
);

# add system address
my $SystemAddressNameRand = 'SystemAddress' . $RandomID;
my $SystemAddressID       = $Kernel::OM->Get('Kernel::System::SystemAddress')->SystemAddressAdd(
    Name     => $SystemAddressNameRand . '@example.com',
    Realname => $SystemAddressNameRand,
    ValidID  => 1,
    QueueID  => 1,
    Comment  => 'Unit test system address',
    UserID   => 1,
);
$Self->True(
    $SystemAddressID,
    "SystemAddressAdd() - $SystemAddressNameRand, $SystemAddressID",
);

# add queue
my $QueueNameRand = 'Queue' . $RandomID;
my $QueueID       = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
    Name            => $QueueNameRand,
    ValidID         => 1,
    GroupID         => 1,
    SystemAddressID => $SystemAddressID,
    SalutationID    => 1,
    SignatureID     => 1,
    Comment         => 'Unit test queue',
    UserID          => 1,
);
$Self->True(
    $QueueID,
    "QueueAdd() - $QueueNameRand, $QueueID",
);

# add auto response
my $AutoResponseNameRand = 'AutoResponse' . $RandomID;
my $AutoResponseID       = $AutoResponseObject->AutoResponseAdd(
    Name        => $AutoResponseNameRand,
    Subject     => 'Unit Test AutoResponse Bug#4640',
    Response    => 'OTRS_CUSTOMER_REALNAME tag: <OTRS_CUSTOMER_REALNAME>',
    Comment     => 'Unit test auto response',
    AddressID   => $SystemAddressID,
    TypeID      => 1,
    ContentType => 'text/plain',
    ValidID     => 1,
    UserID      => 1,
);
$Self->True(
    $AutoResponseID,
    "AutoResponseAdd() - $AutoResponseNameRand, $AutoResponseID",
);

# assign auto response to queue
my $Success = $AutoResponseObject->AutoResponseQueue(
    QueueID         => $QueueID,
    AutoResponseIDs => [$AutoResponseID],
    UserID          => 1,
);
$Self->True(
    $Success,
    "AutoResponseQueue() - success"
);

# add customer user
my $CustomerUser   = $RandomID;
my $CustomerUserID = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
    Source         => 'CustomerUser',
    UserFirstname  => $CustomerUser,
    UserLastname   => $CustomerUser,
    UserCustomerID => 'TestCompany',
    UserLogin      => $CustomerUser,
    UserPassword   => $CustomerUser,
    UserEmail      => $CustomerUser . '@home.com',
    ValidID        => 1,
    UserID         => 1,
);
$Self->True(
    $CustomerUserID,
    "CustomerUserAdd() - $CustomerUser, $CustomerUserID",
);

# add notificaiton with customer as recipient
my $NotificationName = 'Notification' . $RandomID;
my $NotificationID   = $Kernel::OM->Get('Kernel::System::NotificationEvent')->NotificationAdd(
    Name    => $NotificationName,
    Comment => 'Unit Test Notification <OTRS_CUSTOMER_REALNAME> tag',
    Data    => {
        Transports => ['Email'],
        Events     => ['NotificationNewTicket'],
        Recipients => ['Customer'],
        QueueID    => [$QueueID],
    },
    Message => {
        en => {
            Subject     => 'Notification subject',
            Body        => 'OTRS_CUSTOMER_REALNAME tag: <OTRS_CUSTOMER_REALNAME>',
            ContentType => 'text/plain',
        },
    },
    ValidID => 1,
    UserID  => 1,
);
$Self->True(
    $NotificationID,
    "NotificationAdd() - $NotificationName, $NotificationID",
);

# get test data
my @Tests = (
    {
        Name => 'Email without Reply-To tag',
        Email =>
            "From: TestFrom\@home.com\nTo: TestTo\@home.com\nSubject: Email without Reply-To tag\nTest Body Email.\n",
        ResultAutoResponse => {
            To   => 'TestFrom@home.com',
            Body => 'OTRS_CUSTOMER_REALNAME tag: TestFrom@home.com',
        },
        ResultNotification => {
            To   => 'TestFrom@home.com',
            Body => 'OTRS_CUSTOMER_REALNAME tag: TestFrom@home.com',
        },
    },
    {
        Name => 'Email with Reply-To tag',
        Email =>
            "From: TestFrom\@home.com\nTo: TestTo\@home.com\nReply-To: TestReplyTo\@home.com\nSubject: Email with Reply-To tag\nTest Body Email.\n",
        ResultAutoResponse => {
            To   => 'TestReplyTo@home.com',
            Body => 'OTRS_CUSTOMER_REALNAME tag: TestReplyTo@home.com',
        },
        ResultNotification => {
            To   => 'TestReplyTo@home.com',
            Body => 'OTRS_CUSTOMER_REALNAME tag: TestReplyTo@home.com',
        },
    },
    {
        Name => 'Email with CustomerID',
        Email =>
            "From: $CustomerUser\@home.com\nTo: TestTo\@home.com\nSubject: Email with valid CustomerID\nTest Body Email.\n",
        ResultAutoResponse => {
            To   => "$CustomerUser\@home.com",
            Body => "OTRS_CUSTOMER_REALNAME tag: $CustomerUser $CustomerUser",
        },
        ResultNotification => {
            To   => "$CustomerUser\@home.com",
            Body => "OTRS_CUSTOMER_REALNAME tag: $CustomerUser $CustomerUser",
        },
    },
    {
        Name => 'Email with CustomerID and Reply-To tag',
        Email =>
            "From: $CustomerUser\@home.com\nTo: TestTo\@home.com\nReply-To: TestReplyTo\@home.com\nSubject: Email with valid CustomerID\nTest Body Email.\n",
        ResultAutoResponse => {
            To   => 'TestReplyTo@home.com',
            Body => "OTRS_CUSTOMER_REALNAME tag: $CustomerUser $CustomerUser",
        },
        ResultNotification => {
            To   => 'TestReplyTo@home.com',
            Body => "OTRS_CUSTOMER_REALNAME tag: $CustomerUser $CustomerUser",
        },
    },
    {
        Name => 'Email with Customer as Recipient',
        Email =>
            "From: TestRecipient\@home.com\nTo: $CustomerUser\@home.com\nSubject: Email with Recipient\nTest Body Email.\n",
        ResultAutoResponse => {
            To   => 'TestRecipient@home.com',
            Body => 'OTRS_CUSTOMER_REALNAME tag: TestRecipient@home.com',
        },
        ResultNotification => {
            To   => 'TestRecipient@home.com',
            Body => 'OTRS_CUSTOMER_REALNAME tag: TestRecipient@home.com',
        },
    },
);

# run test
for my $Test (@Tests) {

    my $TicketID;

    {
        $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::CommunicationLog::LogModule::Email'] );

        my $CommunicationLogObject = $Kernel::OM->Create(
            'Kernel::System::CommunicationLog',
            ObjectParams => {
                Transport => 'Email',
                Direction => 'Incoming',
            },
        );
        $CommunicationLogObject->ObjectLogStart( ObjectLogType => 'Message' );

        my $PostMasterObject = Kernel::System::PostMaster->new(
            CommunicationLogObject => $CommunicationLogObject,
            Trusted                => 1,
            Email                  => \$Test->{Email},
        );

        my @Return = $PostMasterObject->Run( Queue => $QueueNameRand );

        $TicketID = $Return[1];

        $CommunicationLogObject->ObjectLogStop(
            ObjectLogType => 'Message',
            Status        => 'Successful',
        );
        $CommunicationLogObject->CommunicationStop(
            Status => 'Successful',
        );
    }

    # get test ticket ID
    # my ($TicketID) = $Result =~ m{TicketID:\s+(\d+)};
    $Self->True(
        $TicketID,
        "TicketID $TicketID - created from email",
    );

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    # get auto repsonse article data
    my @MetaArticles = $ArticleObject->ArticleList(
        TicketID => $TicketID,
    );

    my %ArticleAutoResponse = $ArticleObject->BackendForArticle( %{ $MetaArticles[0] } )->ArticleGet(
        %{ $MetaArticles[1] },
    );

    # check auto response article values
    for my $AutoResponseKey ( sort keys %{ $Test->{ResultAutoResponse} } ) {

        $Self->Is(
            $ArticleAutoResponse{$AutoResponseKey},
            $Test->{ResultAutoResponse}->{$AutoResponseKey},
            "AutoResponse: $Test->{Name}, tag $AutoResponseKey",
        );
    }

    # get notification article data
    my %ArticleNotification = $ArticleObject->BackendForArticle( %{ $MetaArticles[0] } )->ArticleGet(
        %{ $MetaArticles[1] },
    );

    for my $NotificationKey ( sort keys %{ $Test->{ResultNotification} } ) {
        if ( $NotificationKey eq 'To' ) {
            $Self->Is(
                $ArticleNotification{$NotificationKey},
                $Test->{ResultNotification}->{$NotificationKey},
                "Notification: $Test->{Name}, tag $NotificationKey",
            );
        }
        else {
            $Self->True(
                index( $ArticleNotification{$NotificationKey}, $Test->{ResultNotification}->{$NotificationKey} ) > -1,
                "Notification: $Test->{Name}, $Test->{ResultNotification}->{$NotificationKey}, tag $NotificationKey"
            );
        }
    }
}

1;
