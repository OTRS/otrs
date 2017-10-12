# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Socket;
use MIME::Base64;

use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Operation::Ticket::TicketCreate;
use Kernel::GenericInterface::Operation::Session::SessionCreate;

use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData IsStringWithData);

# get needed objects
my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');
my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

# Skip SSL certificate verification.
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        SkipSSLVerify => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $Helper->GetRandomID();

$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'Ticket::Type',
    Value => 1,
);

$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'Ticket::Frontend::AccountTime',
    Value => 1,
);

$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'Ticket::Frontend::NeedAccountedTime',
    Value => 1,
);

# disable DNS lookups
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'CheckMXRecord',
    Value => 0,
);

$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'CheckEmailAddresses',
    Value => 1,
);

# disable SessionCheckRemoteIP setting
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'SessionCheckRemoteIP',
    Value => 0,
);

# enable customer groups support
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'CustomerGroupSupport',
    Value => 1,
);

# check if SSL Certificate verification is disabled
$Self->Is(
    $ENV{PERL_LWP_SSL_VERIFY_HOSTNAME},
    0,
    'Disabled SSL certificates verification in environment'
);

my $TestOwnerLogin        = $Helper->TestUserCreate();
my $TestResponsibleLogin  = $Helper->TestUserCreate();
my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate();
my $TestUserLogin         = $Helper->TestUserCreate(
    Groups => [ 'admin', 'users', ],
);
my $UserObject = $Kernel::OM->Get('Kernel::System::User');

my $OwnerID = $UserObject->UserLookup(
    UserLogin => $TestOwnerLogin,
);
my $ResponsibleID = $UserObject->UserLookup(
    UserLogin => $TestResponsibleLogin,
);
my $UserID = $UserObject->UserLookup(
    UserLogin => $TestUserLogin,
);

my $InvalidID = $Kernel::OM->Get('Kernel::System::Valid')->ValidLookup( Valid => 'invalid' );

# sanity test
$Self->IsNot(
    $InvalidID,
    undef,
    "ValidLookup() for 'invalid' should not be undef"
);

# get group object
my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

# create a new group
my $GroupID = $GroupObject->GroupAdd(
    Name    => 'TestSpecial' . $RandomID,
    Comment => 'comment describing the group',    # optional
    ValidID => 1,
    UserID  => 1,
);

my %GroupData = $GroupObject->GroupGet( ID => $GroupID );

# sanity check
$Self->True(
    IsHashRefWithData( \%GroupData ),
    "GroupGet() - for testing group",
);

# create queue object
my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

my @Queues;

my @QueueProperties = (
    {
        Name    => 'queue1' . $RandomID,
        GroupID => 1,
    },
    {
        Name    => 'queue2' . $RandomID,
        GroupID => $GroupID,
    }
);

# create queues
for my $QueueProperty (@QueueProperties) {
    my $QueueID = $QueueObject->QueueAdd(
        %{$QueueProperty},
        ValidID         => 1,
        SystemAddressID => 1,
        SalutationID    => 1,
        SignatureID     => 1,
        Comment         => 'Some comment',
        UserID          => 1,
    );

    # sanity check
    $Self->True(
        $QueueID,
        "QueueAdd() - create testing queue",
    );
    my %QueueData = $QueueObject->QueueGet( ID => $QueueID );

    push @Queues, \%QueueData;
}

# get type object
my $TypeObject = $Kernel::OM->Get('Kernel::System::Type');

# create new type
my $TypeID = $TypeObject->TypeAdd(
    Name    => 'TestType' . $RandomID,
    ValidID => 1,
    UserID  => 1,
);

# sanity check
$Self->True(
    $TypeID,
    "TypeAdd() - create testing type",
);

my %TypeData = $TypeObject->TypeGet(
    ID => $TypeID,
);

# sanity check
$Self->True(
    IsHashRefWithData( \%TypeData ),
    "TypeGet() - for testing type",
);

# create service object
my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');

# create new service
my $ServiceID = $ServiceObject->ServiceAdd(
    Name    => 'TestService' . $RandomID,
    ValidID => 1,
    UserID  => 1,
);

# sanity check
$Self->True(
    $ServiceID,
    "ServiceAdd() - create testing service",
);

my %ServiceData = $ServiceObject->ServiceGet(
    ServiceID => $ServiceID,
    UserID    => 1,
);

# sanity check
$Self->True(
    IsHashRefWithData( \%ServiceData ),
    "ServiceGet() - for testing service",
);

# set service for the customer
$ServiceObject->CustomerUserServiceMemberAdd(
    CustomerUserLogin => $TestCustomerUserLogin,
    ServiceID         => $ServiceID,
    Active            => 1,
    UserID            => 1,
);

# create SLA object
my $SLAObject = $Kernel::OM->Get('Kernel::System::SLA');

# create new SLA
my $SLAID = $SLAObject->SLAAdd(
    Name       => 'TestSLA' . $RandomID,
    ServiceIDs => [$ServiceID],
    ValidID    => 1,
    UserID     => 1,
);

# sanity check
$Self->True(
    $SLAID,
    "SLAAdd() - create testing SLA",
);

my %SLAData = $SLAObject->SLAGet(
    SLAID  => $SLAID,
    UserID => 1,
);

# sanity check
$Self->True(
    IsHashRefWithData( \%SLAData ),
    "SLAGet() - for testing SLA",
);

# create state object
my $StateObject = $Kernel::OM->Get('Kernel::System::State');

# create new state
my $StateID = $StateObject->StateAdd(
    Name    => 'TestState' . $RandomID,
    TypeID  => 2,
    ValidID => 1,
    UserID  => 1,
);

# sanity check
$Self->True(
    $StateID,
    "StateAdd() - create testing state",
);

my %StateData = $StateObject->StateGet(
    ID => $StateID,
);

# sanity check
$Self->True(
    IsHashRefWithData( \%StateData ),
    "StateGet() - for testing state",
);

# create priority object
my $PriorityObject = $Kernel::OM->Get('Kernel::System::Priority');

# create new priority
my $PriorityID = $PriorityObject->PriorityAdd(
    Name    => 'TestPriority' . $RandomID,
    ValidID => 1,
    UserID  => 1,
);

# sanity check
$Self->True(
    $PriorityID,
    "PriorityAdd() - create testing priority",
);

my %PriorityData = $PriorityObject->PriorityGet(
    PriorityID => $PriorityID,
    UserID     => 1,
);

# sanity check
$Self->True(
    IsHashRefWithData( \%PriorityData ),
    "PriorityGet() - for testing priority",
);

# create dynamic field object
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

# create new dynamic field
my $DynamicFieldID = $DynamicFieldObject->DynamicFieldAdd(
    Name       => 'TestDynamicFieldGI' . $Helper->GetRandomNumber(),
    Label      => 'GI Test Field',
    FieldOrder => 9991,
    FieldType  => 'DateTime',
    ObjectType => 'Ticket',
    Config     => {
        DefaultValue  => 0,
        YearsInFuture => 0,
        YearsInPast   => 0,
        YearsPeriod   => 0,
    },
    ValidID => 1,
    UserID  => 1,
);

my $DynamicFieldID2 = $DynamicFieldObject->DynamicFieldAdd(
    Name       => 'TestDynamicFieldGI2' . $Helper->GetRandomNumber(),
    Label      => 'GI Test Field2',
    FieldOrder => 9992,
    FieldType  => 'Text',
    ObjectType => 'Article',
    Config     => {
        DefaultValue => '',
    },
    ValidID => 1,
    UserID  => 1,
);

# sanity check
$Self->True(
    $DynamicFieldID,
    "DynamicFieldAdd() - create testing dynamic field",
);

my $DynamicFieldData = $DynamicFieldObject->DynamicFieldGet(
    ID => $DynamicFieldID,
);

$Self->True(
    $DynamicFieldID2,
    "DynamicFieldAdd() - create testing dynamic field",
);

my $DynamicFieldData2 = $DynamicFieldObject->DynamicFieldGet(
    ID => $DynamicFieldID2,
);

# sanity check
$Self->True(
    IsHashRefWithData($DynamicFieldData),
    "DynamicFieldGet() - for testing dynamic field",
);

# create web service object
my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
$Self->Is(
    ref $WebserviceObject,
    'Kernel::System::GenericInterface::Webservice',
    "Create web service object",
);

# set web service name
my $WebserviceName = '-Test-' . $RandomID;

my $WebserviceID = $WebserviceObject->WebserviceAdd(
    Name   => $WebserviceName,
    Config => {
        Debugger => {
            DebugThreshold => 'debug',
        },
        Provider => {
            Transport => {
                Type => '',
            },
        },
    },
    ValidID => 1,
    UserID  => 1,
);
$Self->True(
    $WebserviceID,
    "Added web service",
);

# get remote host with some precautions for certain unit test systems
my $Host = $Helper->GetTestHTTPHostname();

# prepare web service config
my $RemoteSystem =
    $ConfigObject->Get('HttpType')
    . '://'
    . $Host
    . '/'
    . $ConfigObject->Get('ScriptAlias')
    . '/nph-genericinterface.pl/WebserviceID/'
    . $WebserviceID;

my $WebserviceConfig = {

    #    Name => '',
    Description =>
        'Test for Ticket Connector using SOAP transport backend.',
    Debugger => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    Provider => {
        Transport => {
            Type   => 'HTTP::SOAP',
            Config => {
                MaxLength => 10000000,
                NameSpace => 'http://otrs.org/SoapTestInterface/',
                Endpoint  => $RemoteSystem,
            },
        },
        Operation => {
            TicketCreate => {
                Type              => 'Ticket::TicketCreate',
                IncludeTicketData => 1,
            },
            SessionCreate => {
                Type => 'Session::SessionCreate',
            },
        },
    },
    Requester => {
        Transport => {
            Type   => 'HTTP::SOAP',
            Config => {
                NameSpace => 'http://otrs.org/SoapTestInterface/',
                Encoding  => 'UTF-8',
                Endpoint  => $RemoteSystem,
                Timeout   => 120,
            },
        },
        Invoker => {
            TicketCreate => {
                Type => 'Test::TestSimple',
            },
            SessionCreate => {
                Type => 'Test::TestSimple',
            },
        },
    },
};

# update web service with real config
my $WebserviceUpdate = $WebserviceObject->WebserviceUpdate(
    ID      => $WebserviceID,
    Name    => $WebserviceName,
    Config  => $WebserviceConfig,
    ValidID => 1,
    UserID  => 1,
);
$Self->True(
    $WebserviceUpdate,
    "Updated web service $WebserviceID - $WebserviceName",
);

# Get SessionID
# create requester object
my $RequesterSessionObject = $Kernel::OM->Get('Kernel::GenericInterface::Requester');
$Self->Is(
    ref $RequesterSessionObject,
    'Kernel::GenericInterface::Requester',
    "SessionID - Create requester object",
);

# create a new user for current test
my $UserLogin = $Helper->TestUserCreate(
    Groups => [ 'admin', 'users' ],
);
my $Password = $UserLogin;

# create a new user without permissions for current test
my $UserLogin2 = $Helper->TestUserCreate();
my $Password2  = $UserLogin2;

# create a customer where a ticket will use and will have permissions
my $CustomerUserLogin = $Helper->TestCustomerUserCreate();
my $CustomerPassword  = $CustomerUserLogin;

# create a customer that will not have permissions
my $CustomerUserLogin2 = $Helper->TestCustomerUserCreate();
my $CustomerPassword2  = $CustomerUserLogin2;

# start requester with our web service
my $RequesterSessionResult = $RequesterSessionObject->Run(
    WebserviceID => $WebserviceID,
    Invoker      => 'SessionCreate',
    Data         => {
        UserLogin => $UserLogin,
        Password  => $Password,
    },
);

my $NewSessionID = $RequesterSessionResult->{Data}->{SessionID};
my @Tests        = (
    {
        Name           => 'Ticket with IDs',
        SuccessRequest => 1,
        SuccessCreate  => 1,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                SenderTypeID                    => 1,
                IsVisibleForCustomer            => 1,
                CommunicationChannel            => 'Email',
                From                            => 'enjoy@otrs.com',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
            },
            DynamicField => [
                {
                    Name  => $DynamicFieldData->{Name},
                    Value => '2012-01-17 12:40:00',
                },
                {
                    Name  => $DynamicFieldData2->{Name},
                    Value => 'DynamicFieldTypeArticle',
                },
            ],
            Attachment => [
                {
                    Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                    ContentType => 'text/plain; charset=UTF8',
                    Filename    => 'Test.txt',
                    Disposition => 'attachment',
                },
            ],
        },
        Operation => 'TicketCreate',
    },
);

# debugger object
my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    DebuggerConfig => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    WebserviceID      => $WebserviceID,
    CommunicationType => 'Provider',
);
$Self->Is(
    ref $DebuggerObject,
    'Kernel::GenericInterface::Debugger',
    'DebuggerObject instantiate correctly',
);

for my $Test (@Tests) {

    # create local object
    my $LocalObject = "Kernel::GenericInterface::Operation::Ticket::$Test->{Operation}"->new(
        DebuggerObject => $DebuggerObject,
        WebserviceID   => $WebserviceID,
        Operation      => $Test->{Operation},
    );

    $Self->Is(
        ref $LocalObject,
        "Kernel::GenericInterface::Operation::Ticket::$Test->{Operation}",
        "$Test->{Name} - Create local object",
    );

    my %Auth = (
        UserLogin => $UserLogin,
        Password  => $Password,
    );
    if ( IsHashRefWithData( $Test->{Auth} ) ) {
        %Auth = %{ $Test->{Auth} };
    }

    # start requester with our web service
    my $LocalResult = $LocalObject->Run(
        WebserviceID => $WebserviceID,
        Invoker      => $Test->{Operation},
        Data         => {
            %Auth,
            %{ $Test->{RequestData} },
        },
    );

    # check result
    $Self->Is(
        ref $LocalResult,
        'HASH',
        "$Test->{Name} - Local result structure is valid",
    );

    # create requester object
    my $RequesterObject = $Kernel::OM->Get('Kernel::GenericInterface::Requester');
    $Self->Is(
        ref $RequesterObject,
        'Kernel::GenericInterface::Requester',
        "$Test->{Name} - Create requester object",
    );

    # start requester with our web service
    my $RequesterResult = $RequesterObject->Run(
        WebserviceID => $WebserviceID,
        Invoker      => $Test->{Operation},
        Data         => {
            %Auth,
            %{ $Test->{RequestData} },
        },
    );

    # check result
    $Self->Is(
        ref $RequesterResult,
        'HASH',
        "$Test->{Name} - Requester result structure is valid",
    );

    $Self->Is(
        $RequesterResult->{Success},
        $Test->{SuccessRequest},
        "$Test->{Name} - Requester successful result",
    );

    # tests supposed to succeed
    if ( $Test->{SuccessCreate} ) {

        # local results
        $Self->True(
            $LocalResult->{Data}->{TicketID},
            "$Test->{Name} - Local result TicketID with True.",
        );
        $Self->True(
            $LocalResult->{Data}->{TicketNumber},
            "$Test->{Name} - Local result TicketNumber with True.",
        );
        $Self->True(
            $LocalResult->{Data}->{ArticleID},
            "$Test->{Name} - Local result ArticleID with True.",
        );
        $Self->Is(
            $LocalResult->{Data}->{Error},
            undef,
            "$Test->{Name} - Local result Error is undefined.",
        );

        # requester results
        $Self->True(
            $RequesterResult->{Data}->{TicketID},
            "$Test->{Name} - Requester result TicketID with True.",
        );
        $Self->True(
            $RequesterResult->{Data}->{TicketNumber},
            "$Test->{Name} - Requester result TicketNumber with True.",
        );
        $Self->True(
            $RequesterResult->{Data}->{ArticleID},
            "$Test->{Name} - Requester result ArticleID with True.",
        );
        $Self->Is(
            $RequesterResult->{Data}->{Error},
            undef,
            "$Test->{Name} - Requester result Error is undefined.",
        );

        # create ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # check several ticket and article data
        $Self->Is(
            $LocalResult->{Data}->{Ticket}->{Title},
            $Test->{RequestData}->{Ticket}->{Title},
            "$Test->{Name} - Ticket title Ok.",
        );

        $Self->Is(
            $LocalResult->{Data}->{Ticket}->{QueueID},
            $Test->{RequestData}->{Ticket}->{QueueID},
            "$Test->{Name} - Ticket QueueID Ok.",
        );

        $Self->Is(
            $LocalResult->{Data}->{Ticket}->{Article}->{Body},
            $Test->{RequestData}->{Article}->{Body},
            "$Test->{Name} - Article body Ok.",
        );

        $Self->Is(
            $LocalResult->{Data}->{Ticket}->{Article}->{From},
            $Test->{RequestData}->{Article}->{From},
            "$Test->{Name} - Article from Ok.",
        );

        # check dynamic fields
        my %CompareDynamicFieldTest;
        for my $Field ( @{ $Test->{RequestData}->{DynamicField} } ) {
            if ( $Field->{Name} eq $DynamicFieldData->{Name} ) {
                $CompareDynamicFieldTest{Ticket} = $Field;
            }
            elsif ( $Field->{Name} eq $DynamicFieldData2->{Name} ) {
                $CompareDynamicFieldTest{Article} = $Field;
            }

        }

        my %CompareDynamicFieldLocal;
        LOCALRESULTTICKET:
        for my $Field ( @{ $LocalResult->{Data}->{Ticket}->{DynamicField} } ) {
            next LOCALRESULTTICKET if $Field->{Name} ne $DynamicFieldData->{Name};
            $CompareDynamicFieldLocal{Ticket} = $Field;
        }

        LOCALRESULTARTICLE:
        for my $Field ( @{ $LocalResult->{Data}->{Ticket}->{Article}->{DynamicField} } ) {
            next LOCALRESULTARTICLE if $Field->{Name} ne $DynamicFieldData2->{Name};
            $CompareDynamicFieldLocal{Article} = $Field;
        }

        $Self->IsDeeply(
            \%CompareDynamicFieldLocal,
            \%CompareDynamicFieldTest,
            "$Test->{Name} - local Ticket->DynamicField match test definition.",
        );

        $Self->Is(
            $LocalResult->{Data}->{Ticket}->{Article}->{Attachment}->[0]->{Filename},
            $Test->{RequestData}->{Attachment}->[0]->{Filename},
            "$Test->{Name} - Attachment filename Ok.",
        );

        $Self->Is(
            $RequesterResult->{Data}->{Ticket}->{Title},
            $Test->{RequestData}->{Ticket}->{Title},
            "$Test->{Name} - Ticket title Ok.",
        );

        $Self->Is(
            $RequesterResult->{Data}->{Ticket}->{QueueID},
            $Test->{RequestData}->{Ticket}->{QueueID},
            "$Test->{Name} - Ticket QueueID Ok.",
        );

        $Self->Is(
            $RequesterResult->{Data}->{Ticket}->{Article}->{Body},
            $Test->{RequestData}->{Article}->{Body},
            "$Test->{Name} - Article body Ok.",
        );

        $Self->Is(
            $RequesterResult->{Data}->{Ticket}->{Article}->{From},
            $Test->{RequestData}->{Article}->{From},
            "$Test->{Name} - Article from Ok.",
        );

        # check dynamic fields
        my %CompareDynamicFieldReq;
        LOCALRESULTTICKET:
        for my $Field ( @{ $RequesterResult->{Data}->{Ticket}->{DynamicField} } ) {
            next LOCALRESULTTICKET if $Field->{Name} ne $DynamicFieldData->{Name};
            $CompareDynamicFieldReq{Ticket} = $Field;
        }

        # Check for type of key containing article dynamic field data, since it might be a hash on systems without
        #   multiple fields defined. In this case normalize it to an array of hashes for easier comparison later.
        if ( ref $RequesterResult->{Data}->{Ticket}->{Article}->{DynamicField} eq 'HASH' ) {
            $RequesterResult->{Data}->{Ticket}->{Article}->{DynamicField}
                = [ $RequesterResult->{Data}->{Ticket}->{Article}->{DynamicField} ];
        }

        LOCALRESULTARTICLE:
        for my $Field ( @{ $RequesterResult->{Data}->{Ticket}->{Article}->{DynamicField} } ) {
            next LOCALRESULTARTICLE if $Field->{Name} ne $DynamicFieldData2->{Name};
            $CompareDynamicFieldReq{Article} = $Field;
        }

        $Self->IsDeeply(
            \%CompareDynamicFieldReq,
            \%CompareDynamicFieldTest,
            "$Test->{Name} - req Ticket->DynamicField match test definition.",
        );

        # check attachment
        $Self->Is(
            $RequesterResult->{Data}->{Ticket}->{Article}->{Attachment}->{Filename},
            $Test->{RequestData}->{Attachment}->[0]->{Filename},
            "$Test->{Name} - Attachment filename Ok.",
        );

        # delete the tickets
        for my $TicketID (
            $LocalResult->{Data}->{TicketID},
            $RequesterResult->{Data}->{TicketID}
            )
        {

            # Allow some time for all history entries to be written to the ticket before deleting it,
            #   otherwise TicketDelete could fail.
            sleep 1;

            my $TicketDelete = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => 1,
            );

            # sanity check
            $Self->True(
                $TicketDelete,
                "TicketDelete() successful for Ticket ID $TicketID",
            );
        }
    }
}

# delete web service
my $WebserviceDelete = $WebserviceObject->WebserviceDelete(
    ID     => $WebserviceID,
    UserID => 1,
);
$Self->True(
    $WebserviceDelete,
    "Deleted web service $WebserviceID",
);

# get DB object
my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

my $Success;

# delete queues
for my $QueueData (@Queues) {
    $Success = $DBObject->Do(
        SQL => "DELETE FROM queue WHERE id = $QueueData->{QueueID}",
    );
    $Self->True(
        $Success,
        "Queue with ID $QueueData->{QueueID} is deleted!",
    );
}

# delete group
$Success = $DBObject->Do(
    SQL => "DELETE FROM groups WHERE id = $GroupID",
);
$Self->True(
    $Success,
    "Group with ID $GroupID is deleted!",
);

# delete type
$Success = $DBObject->Do(
    SQL => "DELETE FROM ticket_type WHERE id = $TypeID",
);
$Self->True(
    $Success,
    "Type with ID $TypeID is deleted!",
);

# delete service_customer_user and service
$Success = $DBObject->Do(
    SQL => "DELETE FROM service_customer_user WHERE service_id = $ServiceID",
);
$Self->True(
    $Success,
    "Service user referenced to service ID $ServiceID is deleted!",
);

$Success = $DBObject->Do(
    SQL => "DELETE FROM service_sla WHERE service_id = $ServiceID OR sla_id = $SLAID",
);
$Self->True(
    $Success,
    "Service SLA referenced to service ID $ServiceID is deleted!",
);

$Success = $DBObject->Do(
    SQL => "DELETE FROM service WHERE id = $ServiceID",
);
$Self->True(
    $Success,
    "Service with ID $ServiceID is deleted!",
);

# delete SLA
$Success = $DBObject->Do(
    SQL => "DELETE FROM sla WHERE id = $SLAID",
);
$Self->True(
    $Success,
    "SLA with ID $SLAID is deleted!",
);

# delete state
$Success = $DBObject->Do(
    SQL => "DELETE FROM ticket_state WHERE id = $StateID",
);
$Self->True(
    $Success,
    "State with ID $StateID is deleted!",
);

# delete priority
$Success = $DBObject->Do(
    SQL => "DELETE FROM ticket_priority WHERE id = $PriorityID",
);
$Self->True(
    $Success,
    "Priority with ID $PriorityID is deleted!",
);

# Delete test dynamic fields.
$Success = $DBObject->Do(
    SQL  => 'DELETE FROM dynamic_field WHERE id = ? OR id = ?',
    Bind => [ \$DynamicFieldID, \$DynamicFieldID2 ],
);
$Self->True(
    $Success,
    "Dynamic fields with ID $DynamicFieldID and $DynamicFieldID2 are deleted!",
);

# cleanup cache
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

1;
