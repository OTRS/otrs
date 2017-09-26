# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

if ( $Selenium->{browser_name} ne 'firefox' ) {
    $Self->True(
        1,
        "PDF test currently only supports Firefox",
    );
    return 1;
}

$Selenium->RunTest(
    sub {

        my $Helper   = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $RandomID = $Helper->GetRandomID();

        # Do not check email addresses.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # Enable ticket Responsible feature.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Responsible',
            Value => 1
        );

        # Enable ticket Type feature.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 1
        );

        # Enable ticket service feature.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 1
        );

        # Create Queue.
        my $QueueName = 'Que' . $RandomID;
        my $QueueID   = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
            Name            => $QueueName,
            ValidID         => 1,
            GroupID         => 1,
            SystemAddressID => 1,
            SalutationID    => 1,
            SignatureID     => 1,
            Comment         => 'Selenium Queue',
            UserID          => 1,
        );
        $Self->True(
            $QueueID,
            "Created QueueID $QueueID"
        );

        # Create Service.
        my $ServiceName = 'Servi' . $RandomID;
        my $ServiceID   = $Kernel::OM->Get('Kernel::System::Service')->ServiceAdd(
            Name    => $ServiceName,
            ValidID => 1,
            Comment => 'Selenium Service',
            UserID  => 1,
        );
        $Self->True(
            $ServiceID,
            "Created ServiceID $ServiceID"
        );

        # Create SLA.
        my $SLAName = 'SL' . $RandomID;
        my $SLAID   = $Kernel::OM->Get('Kernel::System::SLA')->SLAAdd(
            ServiceIDs        => [$ServiceID],
            Name              => $SLAName,
            FirstResponseTime => 50,
            UpdateTime        => 100,
            SolutionTime      => 200,
            ValidID           => 1,
            Comment           => 'Selenium SLA',
            UserID            => 1,
        );
        $Self->True(
            $QueueID,
            "Created SLAID $QueueID"
        );

        # Create Type.
        my $TypeName = 'Type' . $RandomID;
        my $TypeID   = $Kernel::OM->Get('Kernel::System::Type')->TypeAdd(
            Name    => $TypeName,
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $TypeID,
            "Created TypeID $TypeID"
        );

        # Create Users.
        my $UserObject = $Kernel::OM->Get('Kernel::System::User');
        my @Users;
        for my $UserCount ( 1 .. 2 ) {

            # Create test User and login.
            my $TestUserLogin = $Helper->TestUserCreate(
                Groups => [ 'users' ],
            ) || die "Did not get test user";

            # Get user data.
            my %UserData = $UserObject->GetUserData(
                User => $TestUserLogin,
            );

            push @Users, \%UserData;
        }

        # Create Customer Company.
        my %CustomerCompany = (
            CustomerID             => 'Customer' . $RandomID,
            CustomerCompanyName    => 'Company' . $RandomID,
            CustomerCompanyStreet  => 'Street' . $RandomID,
            CustomerCompanyZIP     => 'ZIP' . $RandomID,
            CustomerCompanyCity    => 'City' . $RandomID,
            CustomerCompanyCountry => 'Country' . $RandomID,
            CustomerCompanyURL     => 'URL' . $RandomID,
            CustomerCompanyComment => 'Comment' . $RandomID,
        );
        my $CustomerCompanyID = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanyAdd(
            ValidID => 1,
            UserID  => 1,
            %CustomerCompany,
        );
        $Self->True(
            $CustomerCompanyID,
            "Created CustomerCompanyID $CustomerCompanyID"
        );

        # Create Customer User.
        my %CustomerUser = (
            UserFirstname  => 'CustomerFirstName' . $RandomID,
            UserLastname   => 'CustomerLastName' . $RandomID,
            UserCustomerID => $CustomerCompanyID,
            UserLogin      => 'CustomerLogin' . $RandomID,
            UserPassword   => 'CustomerPass' . $RandomID,
            UserEmail      => 'CustomerEmail' . $RandomID . '@example.com',
        );
        my $CustomerUserID = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
            Source  => 'CustomerUser',
            ValidID => 1,
            UserID  => 1,
            %CustomerUser,
        );
        $Self->True(
            $CustomerUserID,
            "Created CustomerUserID $CustomerUserID"
        );

        $Kernel::OM->Get('Kernel::System::CustomerUser')->SetPreferences(
            UserID => $CustomerUserID,
            Key    => 'UserLanguage',
            Value  => 'en',
        );

        # Create Tickets.
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
        my @Tickets;
        for my $Count ( 1 .. 3 ) {
            my $TicketNumber = $TicketObject->TicketCreateNumber();
            my $TicketTitle  = 'Ticket' . $Count . $RandomID;
            my %Ticket       = (
                TN            => $TicketNumber,
                Title         => $TicketTitle,
                QueueID       => $QueueID,
                Lock          => 'unlock',
                Priority      => '5 very high',
                State         => 'open',
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                CustomerID    => $CustomerCompanyID,
                CustomerUser  => $CustomerUserID,
                OwnerID       => $Users[0]->{UserID},
                ResponsibleID => $Users[1]->{UserID},

            );
            my $TicketID = $TicketObject->TicketCreate(
                UserID => 1,
                %Ticket,
            );
            $Self->True(
                $TicketID,
                "Created TicketID $TicketID"
            );
            push @Tickets, {
                ID     => $TicketID,
                Number => $TicketNumber,
                Title  => $TicketTitle,
            };
        }

        # Recreate TicketObject to let event handlers run also for transaction mode.
        $Kernel::OM->ObjectsDiscard(
            Objects => [
                'Kernel::System::Ticket',
            ],
        );
        $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Create Articles.
        my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');
        my @Articles      = (
            {
                ChannelName          => 'Email',
                SenderType           => 'customer',
                IsVisibleForCustomer => 1,
                From                 => 'From ' . $RandomID . ' A <email@example.com>',
                To                   => 'To ' . $RandomID . ' A <email@example.com>',
                Subject              => 'First Article Subject ' . $RandomID,
                Body                 => 'First Article body ' . $RandomID,
                HistoryType          => 'EmailCustomer',
                HistoryComment       => 'Customer sent an email',
            },
            {
                ChannelName          => 'Internal',
                SenderType           => 'agent',
                IsVisibleForCustomer => 0,
                From                 => 'From ' . $RandomID . ' B <email@example.com>',
                To                   => 'To ' . $RandomID . ' B <email@example.com>',
                Subject              => 'Second Article Subject ' . $RandomID,
                Body                 => 'Second Article body ' . $RandomID,
                HistoryType          => 'AddNote',
                HistoryComment       => 'Agent created note',
            },
            {
                ChannelName          => 'Email',
                SenderType           => 'system',
                IsVisibleForCustomer => 1,
                From                 => 'OTRS System <otrs@localhost>',
                Cc                   => 'Cc ' . $RandomID . ' C <email@example.com>',
                Subject              => 'Third Article Subject ' . $RandomID,
                Body                 => 'Third Article body ' . $RandomID,
                HistoryType          => 'SendAutoReply',
                HistoryComment       => 'Sent auto reply',
            },
        );

        my @ArticleIDs;
        for my $Article (@Articles) {
            my $ArticleBackendObject = $ArticleObject->BackendForChannel(
                ChannelName => $Article->{ChannelName},
            );

            my $ArticleID = $ArticleBackendObject->ArticleCreate(
                TicketID    => $Tickets[0]->{ID},
                ContentType => 'text/plain; charset=ISO-8859-15',
                UserID      => 1,
                %{$Article},
            );
            $Self->True(
                $ArticleID,
                "Created ArticleID $ArticleID"
            );
            push @ArticleIDs, $ArticleID;
        }

        # Create Dynamic Fields.
        my $RandomNumber = substr $Helper->GetRandomNumber(), -7;
        my %DynamicFields = (
            Dropdown => {
                Name       => 'DFDropdown' . $RandomNumber,
                Label      => 'DFDropdown' . $RandomNumber,
                FieldOrder => 9990,
                FieldType  => 'Dropdown',
                ObjectType => 'Ticket',
                Config     => {
                    DefaultValue   => '',
                    Link           => '',
                    PossibleNone   => 0,
                    PossibleValues => {
                        0 => 'NotDFSelected',
                        1 => 'YesDFSelected',
                    },
                    TranslatableValues => 1,
                },
                Reorder => 0,
                ValidID => 1,
                UserID  => 1,
            },
            Multiselect => {
                Name       => 'DFMultiselect' . $RandomNumber,
                Label      => 'DFMultiselect' . $RandomNumber,
                FieldOrder => 9990,
                FieldType  => 'Multiselect',
                ObjectType => 'Ticket',
                Config     => {
                    DefaultValue   => '',
                    Link           => '',
                    PossibleNone   => 0,
                    PossibleValues => {
                        year  => 'year',
                        month => 'month',
                        week  => 'week',
                    },
                    TranslatableValues => 1,
                },
                Reorder => 0,
                ValidID => 1,
                UserID  => 1,
            },
            Text => {
                Name       => 'DFText' . $RandomNumber,
                Label      => 'DFText' . $RandomNumber,
                FieldOrder => 9990,
                FieldType  => 'Text',
                ObjectType => 'Article',
                Config     => {
                    DefaultValue => '',
                    Link         => '',
                },
                Reorder => 0,
                ValidID => 1,
                UserID  => 1,
            },
        );

        my %DynamicFieldValues = (
            Text        => "DFText$RandomID",
            Dropdown    => '1',
            Multiselect => [
                'month',
                'year',
            ],
        );

        my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
        my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

        my @DynamicFieldIDs;
        for my $DynamicFieldType ( sort keys %DynamicFields ) {

            my $DynamicFieldID = $DynamicFieldObject->DynamicFieldAdd(
                %{ $DynamicFields{$DynamicFieldType} },
            );

            $Self->True(
                $DynamicFieldID,
                "Created DynamicField $DynamicFields{$DynamicFieldType}->{Name} - ID $DynamicFieldID",
            );
            push @DynamicFieldIDs, $DynamicFieldID;

            # Set DynamicField value to ticket or article accordingly.
            my $ObjectID = $Tickets[0]->{ID};
            if ( $DynamicFields{$DynamicFieldType}->{ObjectType} eq 'Article' ) {
                $ObjectID = $ArticleIDs[0];
            }

            # Set the value from the dynamic field.
            my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
                Name => $DynamicFields{$DynamicFieldType}->{Name},
            );
            my $Value = $DynamicFieldValues{$DynamicFieldType};

            $DynamicFieldBackendObject->ValueSet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $ObjectID,
                Value              => $Value,
                UserID             => 1,
            );
        }

        # Enable created DynamicFields to be visible in AgentTicketPrint.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketPrint###DynamicField',
            Value => {
                $DynamicFields{Dropdown}->{Name}    => 1,
                $DynamicFields{Multiselect}->{Name} => 1,
                $DynamicFields{Text}->{Name}        => 1,
            },
        );

        # Enable created DynamicFields to be visible in CustomerTicketPrint.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::CustomerTicketPrint###DynamicField',
            Value => {
                $DynamicFields{Dropdown}->{Name}    => 1,
                $DynamicFields{Multiselect}->{Name} => 1,
                $DynamicFields{Text}->{Name}        => 1,
            },
        );

        # Enable Ticket attributes in CustomerTicketZoom screen => CustomerTicketPrint.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::CustomerTicketZoom###AttributesView',
            Value => {
                Owner       => 1,
                Priority    => 1,
                Queue       => 1,
                Responsible => 1,
                SLA         => 1,
                Service     => 1,
                State       => 1,
                Type        => 1,
            },
        );

        # Link first and second ticket as parent-child.
        my $LinkObject = $Kernel::OM->Get('Kernel::System::LinkObject');
        my $Success    = $LinkObject->LinkAdd(
            SourceObject => 'Ticket',
            SourceKey    => $Tickets[0]->{ID},
            TargetObject => 'Ticket',
            TargetKey    => $Tickets[1]->{ID},
            Type         => 'ParentChild',
            State        => 'Valid',
            UserID       => 1,
        );
        $Self->True(
            $Success,
            "TickedID $Tickets[0]->{ID} and $Tickets[1]->{ID} linked as parent-child"
        );

        # Link first and third ticket as child-parent.
        $Success = $LinkObject->LinkAdd(
            SourceObject => 'Ticket',
            SourceKey    => $Tickets[2]->{ID},
            TargetObject => 'Ticket',
            TargetKey    => $Tickets[0]->{ID},
            Type         => 'ParentChild',
            State        => 'Valid',
            UserID       => 1,
        );
        $Self->True(
            $Success,
            "TickedID $Tickets[2]->{ID} and $Tickets[1]->{ID} linked as parent-child"
        );

        # Create test User and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentTicketZoom screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$Tickets[0]->{ID}");

        # Click to print ticket in Agent interface.
        $Selenium->find_element("//a[contains(\@href, \'AgentTicketPrint;TicketID=$Tickets[0]->{ID}' )]")->click();

        # Switch to AgentTicketPrint pop up window.
        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Special approach is used for waiting for PDF document to be loaded fully before checking it's content.
        # This is supported and tested in Mozilla Firefox browser.
        $Selenium->WaitFor( JavaScript => 'return document.getElementsByClassName("endOfContent").length === 2' );

        # Create test scenarios.
        my @Tests = (

            # Ticket information.
            {
                Value     => "Ticket#$Tickets[0]->{Number}",
                Message   => "Ticket#$Tickets[0]->{Number} value is correct",
                Interface => 'All',
            },
            {
                Value     => $Tickets[0]->{Title},
                Message   => 'TicketTitle value is correct',
                Interface => 'All',
            },
            {
                Value     => "printed by $TestUserLogin $TestUserLogin ($TestUserLogin\@localunittest.com),",
                Message   => 'PrintedBy value is correct',
                Interface => 'Agent'
            },
            {
                Value     => "printed by $CustomerUser{UserFirstname} $CustomerUser{UserLastname}",
                Message   => 'PrintedBy value is correct',
                Interface => 'Customer'
            },
            {
                Value     => 'State',
                Message   => 'State label is correct',
                Interface => 'All',
            },
            {
                Value     => 'open',
                Message   => 'State value is correct',
                Interface => 'All',
            },
            {
                Value     => 'Age',
                Message   => 'Age label is correct',
                Interface => 'All',
            },
            {
                Value     => '0 m',
                Message   => 'Age value is correct',
                Interface => 'All',
            },
            {
                Value     => 'Accounted time',
                Message   => 'Accounted time label is correct',
                Interface => 'Agent',
            },
            {
                Value     => 'First Response',
                Message   => 'First Response Time label is correct',
                Interface => 'Agent',
            },
            {
                Value     => 'Solution Time',
                Message   => 'Accounted time label is correct',
                Interface => 'Agent',
            },
            {
                Value     => 'Priority',
                Message   => 'Priority label is correct',
                Interface => 'All',
            },
            {
                Value     => '5 very high',
                Message   => 'Priority value is correct',
                Interface => 'All',
            },
            {
                Value     => 'Created',
                Message   => 'Created label is correct',
                Interface => 'All',
            },
            {
                Value     => 'Queue',
                Message   => 'Queue label is correct',
                Interface => 'All',
            },
            {
                Value     => $QueueName,
                Message   => 'Queue value is correct',
                Interface => 'All',
            },
            {
                Value     => 'Lock',
                Message   => 'Lock label is correct',
                Interface => 'Agent',
            },
            {
                Value     => 'unlock',
                Message   => 'Lock value is correct',
                Interface => 'Agent',
            },
            {
                Value     => 'CustomerID',
                Message   => 'CustomerID label is correct',
                Interface => 'All',
            },
            {
                Value     => $CustomerCompany{CustomerID},
                Message   => 'CustomerID value is correct',
                Interface => 'All',
            },
            {
                Value     => 'Owner',
                Message   => 'Owner label is correct',
                Interface => 'All',
            },
            {
                Value     => $Users[0]->{UserLogin},
                Message   => 'Owner first row value is correct',
                Interface => 'All',
            },
            {
                Value     => '(' . $Users[0]->{UserFirstname},
                Message   => 'Owner second row value is correct',
                Interface => 'Agent',
            },
            {
                Value     => $Users[0]->{UserLastname} . ')',
                Message   => 'Owner third row value is correct',
                Interface => 'Agent',
            },
            {
                Value     => 'Responsible',
                Message   => 'Responsible label is correct',
                Interface => 'All',
            },
            {
                Value     => $Users[1]->{UserLogin},
                Message   => 'Responsible first row value is correct',
                Interface => 'All',
            },
            {
                Value     => '(' . $Users[1]->{UserFirstname},
                Message   => 'Responsible second row value is correct',
                Interface => 'Agent',
            },
            {
                Value     => $Users[1]->{UserLastname} . ')',
                Message   => 'Responsible third row value is correct',
                Interface => 'Agent',
            },
            {
                Value     => 'Type',
                Message   => 'Type label is correct',
                Interface => 'All',
            },
            {
                Value     => $TypeName,
                Message   => 'Type value is correct',
                Interface => 'All',
            },
            {
                Value     => 'Service',
                Message   => 'Service label is correct',
                Interface => 'All',
            },
            {
                Value     => $ServiceName,
                Message   => 'Service value is correct',
                Interface => 'All',
            },
            {
                Value     => 'SLA',
                Message   => 'SLA label is correct',
                Interface => 'All',
            },
            {
                Value     => $SLAName,
                Message   => 'SLA value is correct',
                Interface => 'All',
            },

            # Ticket Dynamic Fields.
            {
                Value     => $DynamicFields{Dropdown}->{Label} . ':',
                Message   => 'DynamicField Dropdown label is correct for Ticket',
                Interface => 'All',
            },
            {
                Value     => 'YesDFSelected',
                Message   => 'DynamicField Dropdown value is correct for Ticket',
                Interface => 'All',
            },
            {
                Value     => $DynamicFields{Multiselect}->{Label} . ':',
                Message   => 'DynamicField Multiselect label is correct for Ticket',
                Interface => 'All',
            },
            {
                Value     => 'month, year',
                Message   => 'DynamicField Multiselect value is correct for Ticket',
                Interface => 'All',
            },

            # Linked Objects.
            {
                Value     => 'Parent:',
                Message   => 'Parent: label is correct',
                Interface => 'Agent',
            },
            {
                Value     => $Tickets[2]->{Number} . ': ' . $Tickets[2]->{Name},
                Message   => 'Parent: value is correct',
                Interface => 'Agent',
            },
            {
                Value     => 'Child:',
                Message   => 'Child: label is correct',
                Interface => 'Agent',
            },
            {
                Value     => $Tickets[1]->{Number} . ': ' . $Tickets[1]->{Name},
                Message   => 'Child: value is correct',
                Interface => 'Agent',
            },

            # Customer information.
            {
                Value     => 'Customer Information',
                Message   => 'Customer Information header is correct',
                Interface => 'All',
            },
            {
                Value     => 'Firstname:',
                Message   => 'Firstname: label is correct',
                Interface => 'All',
            },
            {
                Value     => $CustomerUser{UserFirstname},
                Message   => 'Firstname: value is correct',
                Interface => 'All',
            },
            {
                Value     => 'Lastname:',
                Message   => 'Lastname: label is correct',
                Interface => 'All',
            },
            {
                Value     => $CustomerUser{UserLastname},
                Message   => 'Lastname: value is correct',
                Interface => 'All',
            },
            {
                Value     => 'Username:',
                Message   => 'Username: label is correct',
                Interface => 'All',
            },
            {
                Value     => $CustomerUser{UserLogin},
                Message   => 'Username: value is correct',
                Interface => 'All',
            },
            {
                Value     => 'Email:',
                Message   => 'Email: label is correct',
                Interface => 'All',
            },
            {
                Value     => $CustomerUser{UserEmail},
                Message   => 'Email: value is correct',
                Interface => 'All',
            },
            {
                Value     => 'Customer:',
                Message   => 'Customer: label is correct',
                Interface => 'All',
            },
            {
                Value     => $CustomerCompany{CustomerCompanyName},
                Message   => 'Customer: value is correct',
                Interface => 'All',
            },
            {
                Value     => 'Street:',
                Message   => 'Street: label is correct',
                Interface => 'All',
            },
            {
                Value     => $CustomerCompany{CustomerCompanyStreet},
                Message   => 'Street: value is correct',
                Interface => 'All',
            },
            {
                Value     => 'Zip:',
                Message   => 'Zip: label is correct',
                Interface => 'All',
            },
            {
                Value     => $CustomerCompany{CustomerCompanyZIP},
                Message   => 'Zip: value is correct',
                Interface => 'All',
            },
            {
                Value     => 'City:',
                Message   => 'City: label is correct',
                Interface => 'All',
            },
            {
                Value     => $CustomerCompany{CustomerCompanyCity},
                Message   => 'City: value is correct',
                Interface => 'All',
            },
            {
                Value     => 'Country:',
                Message   => 'Country: label is correct',
                Interface => 'All',
            },
            {
                Value     => $CustomerCompany{CustomerCompanyCountry},
                Message   => 'Country: value is correct',
                Interface => 'All',
            },
            {
                Value     => 'URL:',
                Message   => 'URL: label is correct',
                Interface => 'All',
            },
            {
                Value     => $CustomerCompany{CustomerCompanyURL},
                Message   => 'URL: value is correct',
                Interface => 'All',
            },
            {
                Value     => 'Comment:',
                Message   => 'Comment: label is correct',
                Interface => 'All',
            },
            {
                Value     => $CustomerCompany{CustomerCompanyComment},
                Message   => 'Comment: value is correct',
                Interface => 'All',
            },

            # Article #3 information.
            {
                Value     => 'From:',
                Message   => 'From: label is correct',
                Interface => 'All',
            },
            {
                Value     => 'OTRS System',
                Message   => 'From: value is correct for Article#3',
                Interface => 'All',
            },
            {
                Value     => 'To:',
                Message   => 'To: label is correct',
                Interface => 'All',
            },
            {
                Value     => 'Cc:',
                Message   => 'From: label is correct',
                Interface => 'All',
            },
            {
                Value     => 'Cc ' . $RandomID . ' C',
                Message   => 'Cc: value is correct for Article#3',
                Interface => 'All',
            },
            {
                Value     => 'Subject:',
                Message   => 'Subject: label is correct',
                Interface => 'All',
            },
            {
                Value     => $Articles[2]->{Subject},
                Message   => 'Subject: value is correct for Article#3',
                Interface => 'All',
            },
            {
                Value     => 'Created:',
                Message   => 'Created: label is correct',
                Interface => 'All',
            },
            {
                Value     => 'by system',
                Message   => 'Created: value is correct for Article#3',
                Interface => 'All',
            },
            {
                Value     => $Articles[2]->{Body},
                Message   => 'Body: value is correct for Article#3',
                Interface => 'All',
            },

            # Article #2 information.
            {
                Value     => 'From ' . $RandomID . ' B',
                Message   => 'From: value is correct for Article#2',
                Interface => 'Agent',
            },
            {
                Value     => 'To ' . $RandomID . ' B',
                Message   => 'To: value is correct for Article#2',
                Interface => 'Agent',
            },
            {
                Value     => $Articles[1]->{Subject},
                Message   => 'Subject: value is correct for Article#2',
                Interface => 'Agent',
            },
            {
                Value     => 'by agent',
                Message   => 'Created: value is correct for Article#2',
                Interface => 'Agent',
            },
            {
                Value     => $Articles[1]->{Body},
                Message   => 'Body: value is correct for Article#2',
                Interface => 'Agent',
            },

            # Article #1 information.
            {
                Value     => 'From ' . $RandomID . ' A',
                Message   => 'From: value is correct for Article#1',
                Interface => 'All',
            },
            {
                Value     => 'To ' . $RandomID . ' A',
                Message   => 'To: value is correct for Article#1',
                Interface => 'All',
            },
            {
                Value     => $Articles[0]->{Subject},
                Message   => 'Subject: value is correct for Article#1',
                Interface => 'All',
            },
            {
                Value     => 'by customer',
                Message   => 'Created: value is correct for Article#1',
                Interface => 'All',
            },
            {
                Value     => $DynamicFields{Text}->{Label} . ':',
                Message   => 'DynamicField Text label is correct for Article#1',
                Interface => 'All',
            },
            {
                Value     => $DynamicFieldValues{Text},
                Message   => 'DynamicField Text value is correct for Article#1',
                Interface => 'All',
            },
            {
                Value     => $Articles[0]->{Body},
                Message   => 'Body: value is correct for Article#1',
                Interface => 'All',
            },

            # Pagination.
            {
                Value     => 'Page 1',
                Message   => 'Page 1 is correct',
                Interface => 'All',
            },
            {
                Value     => 'Page 2',
                Message   => 'Page 2 is correct',
                Interface => 'Agent',
            },
        );

        # Verify values in AgentTicketPrint.
        my $AgentPageSource = $Selenium->get_page_source();

        for my $Test (@Tests) {
            if ( $Test->{Interface} eq 'All' || $Test->{Interface} eq 'Agent' ) {
                $Self->True(
                    index( $AgentPageSource, $Test->{Value} ) > -1,
                    'Agent - ' . $Test->{Message},
                );
            }
        }

        # Close AgentTicketPrint PDF pop up window and switch window.
        $Selenium->close();
        $Selenium->switch_to_window( $Handles->[0] );
        $Selenium->WaitFor( WindowCount => 1 );

        # Login customer user.
        $Selenium->Login(
            Type     => 'Customer',
            User     => $CustomerUser{UserLogin},
            Password => $CustomerUser{UserPassword},
        );

        # Navigate to CustomerTicketZoom of created first ticket.
        $Selenium->VerifiedGet(
            "${ScriptAlias}customer.pl?Action=CustomerTicketZoom;TicketNumber=$Tickets[0]->{Number}"
        );

        # Click to print ticket in Customer interface.
        $Selenium->find_element("//a[contains(\@href, \'CustomerTicketPrint;TicketID=$Tickets[0]->{ID}' )]")->click();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Special approach is used for waiting for PDF document to be loaded fully before checking it's content.
        # Currently this is supported in Mozilla Firefox browser.
        $Selenium->WaitFor( JavaScript => 'return document.getElementsByClassName("endOfContent").length === 1' );

        # Verify values in CustomerTicketPrint.
        my $CustomerPageSource = $Selenium->get_page_source();

        for my $Test (@Tests) {
            if ( $Test->{Interface} eq 'All' || $Test->{Interface} eq 'Customer' ) {
                $Self->True(
                    index( $CustomerPageSource, $Test->{Value} ) > -1,
                    'Customer - ' . $Test->{Message},
                );
            }
            elsif ( $Test->{Interface} eq 'Agent' ) {
                $Self->True(
                    index( $CustomerPageSource, $Test->{Value} ) == -1,
                    'Customer - ' . $Test->{Message} . ' - not visible',
                );
            }
        }

        # Delete test Tickets.
        for my $Ticket ( reverse @Tickets ) {
            $Success = $TicketObject->TicketDelete(
                TicketID => $Ticket->{ID},
                UserID   => 1,
            );
            $Self->True(
                $Success,
                "TicketID $Ticket->{ID} is deleted",
            );
        }

        # Delete test DynamicFields.
        for my $DynamicFieldID (@DynamicFieldIDs) {

            $Success = $DynamicFieldObject->DynamicFieldDelete(
                ID     => $DynamicFieldID,
                UserID => 1,
            );
            $Self->True(
                $Success,
                "DynamicField ID $DynamicFieldID is deleted",
            );
        }

        # Delete test data from the DB.
        my @DeleteData = (
            {
                SQL     => "DELETE FROM customer_user WHERE login = ?",
                Bind    => $CustomerUserID,
                Message => "CustomerUserID $CustomerUserID is deleted",
            },
            {
                SQL     => "DELETE FROM customer_company WHERE customer_id = ?",
                Bind    => $CustomerCompanyID,
                Message => "CustomerCompanyID $CustomerCompanyID is deleted",
            },
            {
                SQL     => "DELETE FROM ticket_type WHERE id = ?",
                Bind    => $TypeID,
                Message => "TypeID $TypeID is deleted",
            },
            {
                SQL     => "DELETE FROM service_sla WHERE sla_id = ?",
                Bind    => $SLAID,
                Message => "Service-SLA relation deleted",
            },
            {
                SQL     => "DELETE FROM sla WHERE id = ?",
                Bind    => $SLAID,
                Message => "SLAID $SLAID is deleted",
            },
            {
                SQL     => "DELETE FROM service WHERE id = ?",
                Bind    => $ServiceID,
                Message => "ServiceID $ServiceID is deleted",
            },
            {
                SQL     => "DELETE FROM queue WHERE id = ?",
                Bind    => $QueueID,
                Message => "QueueID $QueueID is deleted",
            },
        );

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        for my $Item (@DeleteData) {
            $Success = $DBObject->Do(
                SQL  => $Item->{SQL},
                Bind => [ \$Item->{Bind} ],
            );
            $Self->True(
                $Success,
                $Item->{Message},
            );
        }

        # Clear cache.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp();
    }
);

1;
