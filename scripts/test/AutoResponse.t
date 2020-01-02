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

# get needed objects
my $ConfigObject        = $Kernel::OM->Get('Kernel::Config');
my $AutoResponseObject  = $Kernel::OM->Get('Kernel::System::AutoResponse');
my $SystemAddressObject = $Kernel::OM->Get('Kernel::System::SystemAddress');
my $QueueObject         = $Kernel::OM->Get('Kernel::System::Queue');
my $MailQueueObject     = $Kernel::OM->Get('Kernel::System::MailQueue');
my $ArticleObject       = $Kernel::OM->Get('Kernel::System::Ticket::Article');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get random id
my $RandomID = $HelperObject->GetRandomID();

# set queue name
my $QueueName = 'Some::Queue' . $RandomID;

# create new queue
my $QueueID = $QueueObject->QueueAdd(
    Name                => $QueueName,
    ValidID             => 1,
    GroupID             => 1,
    FirstResponseTime   => 0,
    FirstResponseNotify => 0,
    UpdateTime          => 0,
    UpdateNotify        => 0,
    SolutionTime        => 0,
    SolutionNotify      => 0,
    SystemAddressID     => 1,
    SalutationID        => 1,
    SignatureID         => 1,
    Comment             => 'Some Comment',
    UserID              => 1,
);

$Self->True(
    $QueueID,
    "QueueAdd() - $QueueName, $QueueID",
);

# use Test email backend
$ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::Test',
);
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => '0',
);

my $CustomerUserID = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
    Source         => 'CustomerUser',
    UserFirstname  => 'John',
    UserLastname   => 'Doe',
    UserCustomerID => "Customer#$RandomID",
    UserLogin      => "CustomerLogin#$RandomID",
    UserEmail      => "customer$RandomID\@example.com",
    UserPassword   => 'some_pass',
    ValidID        => 1,
    UserID         => 1,
);
$Self->True(
    $CustomerUserID,
    "Customer created."
);

# add system address
my $SystemAddressNameRand = 'SystemAddress' . $HelperObject->GetRandomID();
my $SystemAddressEmail    = $SystemAddressNameRand . '@example.com';
my $SystemAddressRealname = "$SystemAddressNameRand, $SystemAddressNameRand";
my $SystemAddressID       = $SystemAddressObject->SystemAddressAdd(
    Name     => $SystemAddressEmail,
    Realname => $SystemAddressRealname,
    ValidID  => 1,
    QueueID  => $QueueID,
    Comment  => 'Some Comment',
    UserID   => 1,
);
$Self->True(
    $SystemAddressID,
    'SystemAddressAdd()',
);

my %AutoResponseType = $AutoResponseObject->AutoResponseTypeList(
    Valid => 1,
);

for my $TypeID ( sort keys %AutoResponseType ) {

    my $AutoResponseNameRand = 'SystemAddress' . $HelperObject->GetRandomID();

    my %Tests = (
        Created => {
            Name        => $AutoResponseNameRand,
            Subject     => 'Some Subject - updated',
            Response    => 'Some Response - updated',
            Comment     => 'Some Comment - updated',
            AddressID   => $SystemAddressID,
            TypeID      => $TypeID,
            ContentType => 'text/plain',
            ValidID     => 1,
        },
        Updated => {
            Name        => $AutoResponseNameRand . ' - updated',
            Subject     => 'Some Subject - updated',
            Response    => 'Some Response - updated',
            Comment     => 'Some Comment - updated',
            AddressID   => $SystemAddressID,
            TypeID      => $TypeID,
            ContentType => 'text/html',
            ValidID     => 2,
        },
        ExpectedData => {
            AutoResponseID => '',
            Address        => $SystemAddressEmail,
            Realname       => $SystemAddressRealname,
        },
    );

    # add auto response
    my $AutoResponseID = $AutoResponseObject->AutoResponseAdd(
        UserID => 1,
        %{ $Tests{Created} },
    );

    # this will be used later to test function AutoResponseGetByTypeQueueID()
    $Tests{ExpectedData}{AutoResponseID} = $AutoResponseID;

    $Self->True(
        $AutoResponseID,
        "AutoResponseAdd() - AutoResponseType: $AutoResponseType{$TypeID}",
    );

    my %AutoResponse = $AutoResponseObject->AutoResponseGet( ID => $AutoResponseID );

    for my $Item ( sort keys %{ $Tests{Created} } ) {
        $Self->Is(
            $AutoResponse{$Item} || '',
            $Tests{Created}{$Item},
            "AutoResponseGet() - $Item",
        );
    }

    my %AutoResponseList = $AutoResponseObject->AutoResponseList( Valid => 0 );
    my $List             = grep { $_ eq $AutoResponseID } keys %AutoResponseList;
    $Self->True(
        $List,
        'AutoResponseList() - test Auto Response is in the list.',
    );

    %AutoResponseList = $AutoResponseObject->AutoResponseList( Valid => 1 );
    $List             = grep { $_ eq $AutoResponseID } keys %AutoResponseList;
    $Self->True(
        $List,
        'AutoResponseList() - test Auto Response is in the list.',
    );

    # get a list of the queues that do not have auto response
    my %AutoResponseWithoutQueue = $AutoResponseObject->AutoResponseWithoutQueue();

    $Self->True(
        exists $AutoResponseWithoutQueue{$QueueID} && $AutoResponseWithoutQueue{$QueueID} eq $QueueName,
        'AutoResponseWithoutQueue() contains queue ' . $QueueName . ' with ID ' . $QueueID,
    );

    my %AutoResponseListByType = $AutoResponseObject->AutoResponseList(
        TypeID => $TypeID,
        Valid  => 1,
    );
    $List = grep { $_ eq $AutoResponseID } keys %AutoResponseList;
    $Self->True(
        $List,
        'AutoResponseList() by AutoResponseTypeID (AutoResponseTypeID) - test Auto Response is in the list.',
    );

    my $AutoResponseQueue = $AutoResponseObject->AutoResponseQueue(
        QueueID         => $QueueID,
        AutoResponseIDs => [$AutoResponseID],
        UserID          => 1,
    );
    $Self->True(
        $AutoResponseQueue,
        'AutoResponseQueue()',
    );

    # check again after assigning auto response to queue
    %AutoResponseWithoutQueue = $AutoResponseObject->AutoResponseWithoutQueue();
    $Self->False(
        exists $AutoResponseWithoutQueue{$QueueID} && $AutoResponseWithoutQueue{$QueueID} eq $QueueName,
        'AutoResponseWithoutQueue() does not contain queue ' . $QueueName . ' with ID ' . $QueueID,
    );

    my %AutoResponseData = $AutoResponseObject->AutoResponseGetByTypeQueueID(
        QueueID => $QueueID,
        Type    => $AutoResponseType{$TypeID},
    );

    for my $Item (qw/AutoResponseID Address Realname/) {
        $Self->Is(
            $AutoResponseData{$Item} || '',
            $Tests{ExpectedData}{$Item},
            "AutoResponseGetByTypeQueueID() - $Item",
        );
    }

    if ( $TypeID == 1 ) {

        # auto-reply

        my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
        my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
            ChannelName => 'Email',
        );

        # create a new ticket
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'Some Ticket Title',
            QueueID      => $QueueID,
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => "Customer#$RandomID",
            CustomerUser => "CustomerLogin#$RandomID",
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->IsNot(
            $TicketID,
            undef,
            'TicketCreate() - TicketID should not be undef',
        );

        my $ArticleID1 = $ArticleBackendObject->ArticleCreate(
            TicketID             => $TicketID,
            IsVisibleForCustomer => 0,
            SenderType           => 'agent',
            From                 => 'Some Agent <otrs@example.com>',
            To                   => 'Suplier<suplier@example.com>',
            Subject              => 'Email for suplier',
            Body                 => 'the message text',
            Charset              => 'utf8',
            MimeType             => 'text/plain',
            HistoryType          => 'OwnerUpdate',
            HistoryComment       => 'Some free text!',
            UserID               => 1,
        );
        $Self->True(
            $ArticleID1,
            "First article created."
        );

        my $TestEmailObject = $Kernel::OM->Get('Kernel::System::Email::Test');
        my $CleanUpSuccess  = $TestEmailObject->CleanUp();
        $Self->True(
            $CleanUpSuccess,
            'Cleanup Email backend',
        );

        my $ArticleID2 = $ArticleBackendObject->ArticleCreate(
            TicketID             => $TicketID,
            IsVisibleForCustomer => 0,
            SenderType           => 'customer',
            From                 => 'Suplier<suplier@example.com>',
            To                   => 'Some Agent <otrs@example.com>',
            Subject              => 'some short description',
            Body                 => 'the message text',
            Charset              => 'utf8',
            MimeType             => 'text/plain',
            HistoryType          => 'OwnerUpdate',
            HistoryComment       => 'Some free text!',
            UserID               => 1,
            AutoResponseType     => 'auto reply',
            OrigHeader           => {
                From    => 'Some Agent <otrs@example.com>',
                Subject => 'some short description',
            },
        );

        $Self->True(
            $ArticleID2,
            "Second article created."
        );

        # Auto response create a new article, so we need to get the article id generated
        #   - supposedly it should be the last created article for the ticket.
        my @Articles = $ArticleObject->ArticleList(
            TicketID => $TicketID,
            OnlyLast => 1,
        );

        # Get the mail queue element.
        my $MailQueueElement = $MailQueueObject->Get( ArticleID => $Articles[0]->{ArticleID} );

        # Make sure that auto-response is not sent to the customer (in CC) - See bug#12293
        $Self->IsDeeply(
            $MailQueueElement->{Recipient},
            [
                'otrs@example.com'
            ],
            'Check AutoResponse recipients.'
        );

        # Check From header line if it was quoted correctly, please see bug#13130 for more information.
        $Self->True(
            ( $MailQueueElement->{Message}->{Header} =~ m{^From:\s+"$Tests{ExpectedData}->{Realname}"}sm ) // 0,
            'Check From header line quoting'
        );
    }

    $AutoResponseQueue = $AutoResponseObject->AutoResponseQueue(
        QueueID         => $QueueID,
        AutoResponseIDs => [],
        UserID          => 1,
    );

    my $AutoResponseUpdate = $AutoResponseObject->AutoResponseUpdate(
        ID     => $AutoResponseID,
        UserID => 1,
        %{ $Tests{Updated} },
    );

    $Self->True(
        $AutoResponseUpdate,
        'AutoResponseUpdate()',
    );

    %AutoResponse = $AutoResponseObject->AutoResponseGet( ID => $AutoResponseID );

    for my $Item ( sort keys %{ $Tests{Created} } ) {
        $Self->Is(
            $AutoResponse{$Item} || '',
            $Tests{Updated}{$Item},
            "AutoResponseGet() - $Item",
        );
    }

    %AutoResponseList = $AutoResponseObject->AutoResponseList( Valid => 1 );
    $List             = grep { $_ eq $AutoResponseID } keys %AutoResponseList;
    $Self->False(
        $List,
        'AutoResponseList() - test Auto Response is not in the list of valid Auto Responses.',
    );

    %AutoResponseList = $AutoResponseObject->AutoResponseList( Valid => 0 );

    $List = grep { $_ eq $AutoResponseID } keys %AutoResponseList;
    $Self->True(
        $List,
        'AutoResponseList() - test Auto Response is in the list of all Auto Responses.',
    );
}

# cleanup is done by RestoreDatabase

1;
