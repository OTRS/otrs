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
use POSIX qw( floor );

use vars (qw($Self));

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get needed objects
        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # disable 'Ticket Information', 'Customer Information' and 'Linked Objects' widgets in AgentTicketZoom screen
        for my $WidgetDisable (qw(0100-TicketInformation 0200-CustomerInformation 0300-LinkTable)) {
            $Helper->ConfigSettingChange(
                Valid => 0,
                Key   => "Ticket::Frontend::AgentTicketZoom###Widgets###$WidgetDisable",
                Value => '',
            );
        }

        # enable ticket service, type, responsible
        $Helper->ConfigSettingChange(
            Key   => 'Ticket::Service',
            Value => 1,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 1
        );
        $Helper->ConfigSettingChange(
            Key   => 'Ticket::Type',
            Value => 1,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 1
        );
        $Helper->ConfigSettingChange(
            Key   => 'Ticket::Responsible',
            Value => 1,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Responsible',
            Value => 1
        );

        # use a calendar with the same business hours for every day so that the UT runs correctly
        # on every day of the week and outside usual business hours.
        my %Week;
        my @Days = qw(Sun Mon Tue Wed Thu Fri Sat);
        for my $Day (@Days) {
            $Week{$Day} = [ 0 .. 23 ];
        }
        $Helper->ConfigSettingChange(
            Key   => 'TimeWorkingHours',
            Value => \%Week,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'TimeWorkingHours',
            Value => \%Week,
        );

        # disable default Vacation days
        $Helper->ConfigSettingChange(
            Key   => 'TimeVacationDays',
            Value => {},
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'TimeVacationDays',
            Value => {},
        );

        # get user object
        my $UserObject = $Kernel::OM->Get('Kernel::System::User');

        # create test responsible user
        my $ResponsibleUser = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        # get test user responsible ID
        my $ResponsibleUserID = $UserObject->UserLookup(
            UserLogin => $ResponsibleUser,
        );

        # create login user
        my $UserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        # get test user login ID
        my $UserLoginID = $UserObject->UserLookup(
            UserLogin => $UserLogin,
        );

        # get test ticket data
        my $RandomID   = $Helper->GetRandomID();
        my %TicketData = (
            Age         => '0 m',
            Type        => "Type$RandomID",
            Service     => "Service$RandomID",
            SLA         => "SLA$RandomID",
            Queue       => "Queue$RandomID",
            Priority    => '5 very high',
            State       => 'open',
            Locked      => 'unlock',
            Responsible => $ResponsibleUser,
        );

        # get type object
        my $TypeObject = $Kernel::OM->Get('Kernel::System::Type');

        # create test type
        my $TypeID = $TypeObject->TypeAdd(
            Name    => $TicketData{Type},
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $TypeID,
            "TypeID $TypeID is created"
        );

        # get queue object
        my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

        # create test queue
        my $QueueID = $QueueObject->QueueAdd(
            Name            => $TicketData{Queue},
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
            "QueueID $QueueID is created"
        );

        # create test service
        my $ServiceID = $Kernel::OM->Get('Kernel::System::Service')->ServiceAdd(
            Name    => $TicketData{Service},
            ValidID => 1,
            Comment => 'Selenium Service',
            UserID  => 1,
        );
        $Self->True(
            $ServiceID,
            "ServiceID $ServiceID is created"
        );

        # create test SLA with low escalation times, so we trigger warning in 'Ticket Information' widget
        my %EscalationTimes = (
            FirstResponseTime => 30,
            UpdateTime        => 40,
            SolutionTime      => 50,
        );
        my $SLAID = $Kernel::OM->Get('Kernel::System::SLA')->SLAAdd(
            ServiceIDs        => [$ServiceID],
            Name              => $TicketData{SLA},
            FirstResponseTime => $EscalationTimes{FirstResponseTime},
            UpdateTime        => $EscalationTimes{UpdateTime},
            SolutionTime      => $EscalationTimes{SolutionTime},
            ValidID           => 1,
            Comment           => 'Selenium SLA',
            UserID            => 1,
        );
        $Self->True(
            $SLAID,
            "SLAID $SLAID is created"
        );

        # get dynamic field objects
        my $DynamicFieldObject      = $Kernel::OM->Get('Kernel::System::DynamicField');
        my $DynamicFieldValueObject = $Kernel::OM->Get('Kernel::System::DynamicFieldValue');

        # create test dynamic field
        my $DynamicFieldName = "DFText$RandomID";
        my $DynamicFieldID   = $DynamicFieldObject->DynamicFieldAdd(
            Name       => $DynamicFieldName,
            Label      => "DFLabel",
            FieldOrder => 9991,
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue => '',
            },
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $DynamicFieldID,
            "DynamicFieldID $DynamicFieldID is created"
        );

        # enable test dynamic field to show in AgentTicketZoom screen in 'Ticket Information' widget
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketZoom###DynamicField',
            Value => {
                $DynamicFieldName => 1,
            },
        );

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test ticket
        my $Customer    = "Customer$RandomID";
        my $TitleRandom = "Title$RandomID";
        my $TicketID    = $TicketObject->TicketCreate(
            Title         => $TitleRandom,
            Queue         => $TicketData{Queue},
            TypeID        => $TypeID,
            Lock          => $TicketData{Locked},
            Priority      => $TicketData{Priority},
            State         => $TicketData{State},
            ServiceID     => $ServiceID,
            SLAID         => $SLAID,
            CustomerID    => $Customer,
            ResponsibleID => $ResponsibleUserID,
            OwnerID       => $UserLoginID,
            UserID        => $UserLoginID,
        );
        $Self->True(
            $TicketID,
            "TicketID $TicketID is created",
        );

        # add dynamic field value to the test ticket
        my $DFValue = "DFValueText$RandomID";
        my $Success = $DynamicFieldValueObject->ValueSet(
            FieldID    => $DynamicFieldID,
            ObjectType => 'Ticket',
            ObjectID   => $TicketID,
            UserID     => 1,
            Value      => [
                {
                    ValueText => $DFValue,
                },
            ],
        );
        $Self->True(
            $Success,
            "DynamicField value added to the test ticket",
        );

        # login test user
        $Selenium->Login(
            Type     => 'Agent',
            User     => $UserLogin,
            Password => $UserLogin,
        );

        # get script alias
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # navigate to AgentTicketZoom for test created ticket
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # verify its right screen
        $Self->True(
            index( $Selenium->get_page_source(), $TitleRandom ) > -1,
            "Ticket $TitleRandom found on page",
        );

        # verify there is no 'Ticket Information' widget, it's disabled
        $Self->True(
            index( $Selenium->get_page_source(), "$TicketData{Service}" ) == -1,
            "Ticket Information widget is disabled",
        );

        # reset 'Ticket Information' widget sysconfig, enable it and refresh screen
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketZoom###Widgets###0100-TicketInformation',
            Value => {
                'Location' => 'Sidebar',
                'Module'   => 'Kernel::Output::HTML::TicketZoom::TicketInformation',
            },
        );

        $Selenium->VerifiedRefresh();

        # verify there is 'Ticket Information' widget, it's enabled
        $Self->Is(
            $Selenium->find_element( '.Header>h2', 'css' )->get_text(),
            'Ticket Information',
            'Ticket Information widget is enabled',
        );

        # verify there is no collapsed elements on the screen
        $Self->True(
            $Selenium->find_element("//div[contains(\@class, \'WidgetSimple Expanded')]"),
            "Ticket Information Widget is expanded",
        );

        # toggle to collapse 'Ticket Information' widget
        $Selenium->find_element("//a[contains(\@title, \'Show or hide the content' )]")->VerifiedClick();

        # verify there is collapsed element on the screen
        $Self->True(
            $Selenium->find_element("//div[contains(\@class, \'WidgetSimple Collapsed')]"),
            "Ticket Information Widget is collapsed",
        );

        # add article to ticket
        my $ArticleID = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Email')->ArticleCreate(
            TicketID             => $TicketID,
            IsVisibleForCustomer => 1,
            SenderType           => 'customer',
            Subject              => 'some short description',
            Body                 => 'the message text',
            Charset              => 'ISO-8859-15',
            MimeType             => 'text/plain',
            HistoryType          => 'EmailCustomer',
            HistoryComment       => 'Some free text!',
            UserID               => 1,
        );
        $Self->True(
            $ArticleID,
            "ArticleID $ArticleID is created",
        );

        # add accounted time to the ticket
        my $AccountedTime = 123;
        $Success = $TicketObject->TicketAccountTime(
            TicketID  => $TicketID,
            ArticleID => $ArticleID,
            TimeUnit  => $AccountedTime,
            UserID    => 1,
        );
        $Self->True(
            $Success,
            "Accounted Time $AccountedTime added to ticket"
        );

        # refresh screen to get accounted time value
        $Selenium->VerifiedRefresh();

        # verify 'Ticket Information' widget values
        for my $TicketInformationCheck ( sort keys %TicketData ) {
            $Self->True(
                $Selenium->find_element("//p[contains(\@title, \'$TicketData{$TicketInformationCheck}' )]"),
                "$TicketInformationCheck - $TicketData{$TicketInformationCheck} found in Ticket Information widget"
            );
        }

        # verify customer link to 'Customer Information Center'
        $Self->True(
            $Selenium->find_element("//a[contains(\@href, \'AgentCustomerInformationCenter;CustomerID=$Customer' )]"),
            "Customer link to 'Customer Information Center' found",
        );

        # verify accounted time value
        $Self->True(
            index( $Selenium->get_page_source(), qq|<p class="Value">$AccountedTime</p>| ) > -1,
            "Accounted Time found in Ticket Information Widget",
        );

        # verify dynamic field value in 'Ticket Information' widget
        $Self->True(
            $Selenium->find_element("//span[contains(\@title, \'$DFValue' )]"),
            "DynamicField value - $DFValue found in Ticket Information widget",
        );

        # Recreate TicketObject to let event handlers run also for transaction mode.
        $Kernel::OM->ObjectsDiscard(
            Objects => [
                'Kernel::System::Ticket',
            ],
        );
        $Kernel::OM->Get('Kernel::System::Ticket');

        # refresh screen to be sure escalation time will get latest times
        $Selenium->VerifiedRefresh();

        # get ticket data for escalation time values
        my %Ticket = $TicketObject->TicketGet(
            TicketID => $TicketID,
            Extended => 1,
            UserID   => 1,
        );

        # verify escalation times, warning should be active
        for my $EscalationTime ( sort keys %EscalationTimes ) {
            $EscalationTime = floor( $Ticket{$EscalationTime} / 60 );

            # Check if warning is visible
            $Self->True(

                # Check for EscalationTime or EscalationTime + 1 (one minute tolerance, since it fails on fast systems)
                $Selenium->find_element(
                    "//p[\@class='Warning'][\@title='Service Time: $EscalationTime m' or \@title='Service Time: "
                        . ( $EscalationTime + 1 ) . " m']"
                ),
                "Escalation Time $EscalationTime m , found in Ticket Information Widget",
            );
        }

        # cleanup test data
        # delete dynamic field value
        $Success = $DynamicFieldValueObject->ValueDelete(
            FieldID  => $DynamicFieldID,
            ObjectID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "DynamicField value removed from the test ticket",
        );

        # delete dynamic field
        $Success = $DynamicFieldObject->DynamicFieldDelete(
            ID     => $DynamicFieldID,
            UserID => 1,
        );
        $Self->True(
            $Success,
            "DynamicFieldID $DynamicFieldID is deleted",
        );

        # delete test ticket
        $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "TicketID $TicketID is deleted",
        );

        # get DB object
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # get delete test data
        my @DeleteData = (
            {
                SQL     => "DELETE FROM ticket_type WHERE id = $TypeID",
                Message => "TypeID $TypeID is deleted",
            },
            {
                SQL     => "DELETE FROM service_sla WHERE sla_id = $SLAID",
                Message => "Service-SLA relation deleted",
            },
            {
                SQL     => "DELETE FROM sla WHERE id = $SLAID",
                Message => "SLAID $SLAID is deleted",
            },
            {
                SQL     => "DELETE FROM service WHERE id = $ServiceID",
                Message => "ServiceID $ServiceID is deleted",
            },
            {
                SQL     => "DELETE FROM queue WHERE id = $QueueID",
                Message => "QueueID $QueueID is deleted",
            },
        );

        # delete test created items
        for my $Item (@DeleteData) {
            $Success = $DBObject->Do(
                SQL => $Item->{SQL},
            );
            $Self->True(
                $Success,
                $Item->{Message},
            );
        }

        # make sure cache is correct
        for my $Cache (qw( Ticket Type SLA Service Queue DynamicField )) {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => $Cache );
        }

    }
);

1;
