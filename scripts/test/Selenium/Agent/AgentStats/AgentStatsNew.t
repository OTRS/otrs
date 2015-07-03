# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get selenium object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Selenium' => {
        Verbose => 1,
        }
);
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 1,
                }
        );
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # get sysconfig object
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # do not check service and type
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 0
        );
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 0
        );
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Stats::TimeType',
            Value => 'extended',
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users', 'stats' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # create test params
        my @Tests = (
            {
                Title       => 'Ticket Accumulation Stats ' . $Helper->GetRandomID(),
                Object      => 'Ticket',
                XAxis       => "QueueIDs option[value='1']",
                ValueSeries => "PriorityIDs option[value='4']",
                Restriction => "StateIDs option[value='4']",
                ExpectedValues =>
                    {
                    Object      => 'TicketAccumulation',
                    XAxis       => 'Postmaster',
                    ValueSeries => '4 high',
                    Restriction => 'open',
                    },
                Step1Fields => [
                    'Title', 'Description', 'Object', 'Permission', 'Format',
                    'SumRow', 'SumCol', 'Cache', 'ShowAsDashboardWidget', 'Valid',
                ],
                Step2Fields => [
                    'QueueIDs', 'StateIDs', 'StateTypeIDs', 'PriorityIDs', 'CreatedQueueIDs', 'CreatedPriorityIDs',
                    'CreatedStateIDs', 'LockIDs', 'CreateTime', 'LastChangeTime', 'ChangeTime', 'CloseTime2',
                    'EscalationTime',
                    'EscalationResponseTime', 'EscalationUpdateTime', 'EscalationSolutionTime', 'CustomerID'
                ],
                Step3Fields => [
                    'StateIDs', 'StateTypeIDs', 'PriorityIDs', 'CreatedQueueIDs', 'CreatedPriorityIDs',
                    'CreatedStateIDs', 'LockIDs', 'CustomerID'
                ],
                Step4Fields => [
                    'StateIDs', 'StateTypeIDs', 'CreatedQueueIDs', 'CreatedPriorityIDs',
                    'CreatedStateIDs', 'LockIDs', 'Title', 'CustomerUserLogin', 'From', 'To', 'Cc', 'Subject', 'Body',
                    'CreateTime', 'LastChangeTime', 'ChangeTime', 'CloseTime2', 'EscalationTime',
                    'EscalationResponseTime', 'EscalationUpdateTime', 'EscalationSolutionTime', 'CustomerID'
                ],
            },
            {
                Title       => 'Ticket Accounted Time Stats ' . $Helper->GetRandomID(),
                Object      => 'TicketAccountedTime',
                XAxis       => "StateIDs option[value='1']",
                ValueSeries => "CreatedQueueIDs option[value='2']",
                Restriction => "SelectCreateTime",
                ExpectedValues =>
                    {
                    Object      => 'TicketAccountedTime',
                    XAxis       => 'new',
                    ValueSeries => 'Raw',
                    Restriction => 'Ticket Create Time',
                    },
                Step1Fields => [
                    'Title', 'Description', 'Object', 'Permission', 'Format',
                    'SumRow', 'SumCol', 'Cache', 'ShowAsDashboardWidget', 'Valid'
                ],
                Step2Fields => [
                    'KindsOfReporting', 'QueueIDs', 'StateIDs', 'StateTypeIDs', 'PriorityIDs', 'CreatedQueueIDs',
                    'CreatedPriorityIDs',
                    'CreatedStateIDs', 'LockIDs', 'CreateTime', 'LastChangeTime', 'ChangeTime', 'CloseTime2',
                    'EscalationTime',
                    'EscalationResponseTime', 'EscalationUpdateTime', 'EscalationSolutionTime', 'CustomerID'
                ],
                Step3Fields => [
                    'QueueIDs', 'StateTypeIDs', 'PriorityIDs', 'CreatedQueueIDs', 'CreatedPriorityIDs',
                    'CreatedStateIDs', 'LockIDs', 'CustomerID'
                ],
                Step4Fields => [
                    'KindsOfReporting', 'QueueIDs', 'StateTypeIDs', 'PriorityIDs', 'CreatedPriorityIDs',
                    'CreatedStateIDs', 'LockIDs', 'Title', 'CustomerUserLogin', 'From', 'To', 'Cc', 'Subject', 'Body',
                    'CreateTime', 'LastChangeTime', 'ChangeTime', 'CloseTime2', 'EscalationTime',
                    'EscalationResponseTime', 'EscalationUpdateTime', 'EscalationSolutionTime', 'CustomerID'
                ],
            },
            {
                Title       => 'Ticket Responsible Solution Time ' . $Helper->GetRandomID(),
                Object      => 'TicketSolutionResponseTime',
                XAxis       => "CreatedPriorityIDs option[value='2']",
                ValueSeries => "LockIDs option[value='2']",
                Restriction =>
                    {
                    Field                 => 'SelectCloseTime2',
                    RestrictionPeriod     => 'CloseTime2TimeSelect',
                    RestrictionPeriodUnit => "CloseTime2TimeRelativeUnit option[value='Day']",
                    },
                ExpectedValues =>
                    {
                    Object      => 'TicketSolutionResponseTime',
                    XAxis       => '2 low',
                    ValueSeries => 'lock',
                    Restriction => 'The last 1 day(s)',
                    },
                Step1Fields => [
                    'Title', 'Description', 'Object', 'Permission', 'Format',
                    'SumRow', 'SumCol', 'Cache', 'ShowAsDashboardWidget', 'Valid'
                ],
                Step2Fields => [
                    'KindsOfReporting', 'QueueIDs', 'StateIDs', 'StateTypeIDs', 'PriorityIDs', 'CreatedQueueIDs',
                    'CreatedPriorityIDs',
                    'CreatedStateIDs', 'LockIDs', 'CreateTime', 'LastChangeTime', 'ChangeTime', 'CloseTime2',
                    'EscalationTime',
                    'EscalationResponseTime', 'EscalationUpdateTime', 'EscalationSolutionTime', 'CustomerID'
                ],
                Step3Fields => [
                    'QueueIDs', 'StateIDs', 'StateTypeIDs', 'PriorityIDs', 'CreatedQueueIDs',
                    'CreatedStateIDs', 'LockIDs', 'CustomerID'
                ],
                Step4Fields => [
                    'KindsOfReporting', 'QueueIDs', 'StateIDs', 'StateTypeIDs', 'PriorityIDs', 'CreatedQueueIDs',
                    'CreatedStateIDs', 'Title', 'CustomerUserLogin', 'From', 'To', 'Cc', 'Subject', 'Body',
                    'CreateTime', 'LastChangeTime', 'ChangeTime', 'CloseTime2', 'EscalationTime',
                    'EscalationResponseTime', 'EscalationUpdateTime', 'EscalationSolutionTime', 'CustomerID',
                    'DynamicField_ProcessManagementProcessID', 'DynamicField_ProcessManagementActivityID'
                ],
            },
            {
                Title       => 'Ticket List Stats ' . $Helper->GetRandomID(),
                Object      => 'TicketList',
                XAxis       => "TicketAttributes option[value='Age']",
                ValueSeries => "SortSequence option[value='Up']",
                Restriction => "Limit option[value='20']",
                ExpectedValues =>
                    {
                    Object      => 'Ticketlist',
                    XAxis       => 'Age',
                    ValueSeries => 'ascending',
                    Restriction => 'UseAsRestrictionLimit',
                    },
                Step1Fields => [
                    'Title', 'Description', 'Object', 'Permission', 'Format',
                    'SumRow', 'SumCol', 'Cache', 'ShowAsDashboardWidget', 'Valid'
                ],
                Step2Fields => ['TicketAttributes'],
                Step3Fields => [ 'OrderBy', 'SortSequence' ],
                Step4Fields => [
                    'Limit', 'QueueIDs', 'StateIDs', 'StateIDsHistoric', 'StateTypeIDs', 'StateTypeIDsHistoric',
                    'PriorityIDs', 'CreatedQueueIDs', 'CreatedPriorityIDs',
                    'CreatedStateIDs', 'LockIDs', 'Title', 'CustomerUserLogin', 'From', 'To', 'Cc', 'Subject', 'Body',
                    'CreateTime',             'LastChangeTime',       'ChangeTime',             'EscalationTime',
                    'EscalationResponseTime', 'EscalationUpdateTime', 'EscalationSolutionTime', 'CustomerID',
                    'DynamicField_ProcessManagementProcessID', 'DynamicField_ProcessManagementActivityID'
                ],
            },
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # create selenium tests for each stats object, check page, values and delete test
        for my $Stats (@Tests) {

            $Selenium->get("${ScriptAlias}index.pl?Action=AgentStats;Subaction=Add");

            # Step 1
            # check page
            for my $Step1Fields ( @{ $Stats->{Step1Fields} } ) {
                $Selenium->find_element( "#$Step1Fields", 'css' )->is_displayed();
            }

            # input params
            $Selenium->find_element( "#Title",       'css' )->send_keys( $Stats->{Title} );
            $Selenium->find_element( "#Description", 'css' )->send_keys("Selenium test stat");
            $Selenium->find_element( "#Object option[value='$Stats->{Object}']", 'css' )->click();
            $Selenium->find_element("//button[\@value='Next...'][\@type='submit']")->click();

            # Step 2
            # check page
            for my $Step2Fields ( @{ $Stats->{Step2Fields} } ) {
                $Selenium->find_element("//input[\@value='$Step2Fields']")->is_displayed();
            }

            # input params
            $Selenium->find_element( "#$Stats->{XAxis}", 'css' )->click();
            $Selenium->find_element("//button[\@value='Next...'][\@type='submit']")->click();

            # Step 3
            # check page
            for my $Step3Fields ( @{ $Stats->{Step3Fields} } ) {
                $Selenium->find_element("//input[\@name='Select$Step3Fields']")->is_displayed();
            }

            # input params
            $Selenium->find_element( "#$Stats->{ValueSeries}", 'css' )->click();
            $Selenium->find_element("//button[\@value='Next...'][\@type='submit']")->click();

            # Step 4
            # check page
            for my $Step4Fields ( @{ $Stats->{Step4Fields} } ) {
                $Selenium->find_element("//input[\@name='Select$Step4Fields']")->is_displayed();
            }

            # input params
            if ( $Stats->{Object} eq "TicketSolutionResponseTime" ) {
                $Selenium->find_element("//input[\@name='$Stats->{Restriction}->{Field}']")->click();
                $Selenium->find_element(
                    "//input[\@value='Relativ'][\@name='$Stats->{Restriction}->{RestrictionPeriod}']"
                )->click();
                $Selenium->find_element( "#$Stats->{Restriction}->{RestrictionPeriodUnit}", 'css' )->click();
            }
            elsif ( $Stats->{Object} eq "TicketAccountedTime" ) {
                $Selenium->find_element("//input[\@name='$Stats->{Restriction}']")->click();
            }
            elsif ( $Stats->{Object} eq "TicketList" ) {
                $Selenium->find_element( "#$Stats->{Restriction}", 'css' )->click();
                $Selenium->find_element("//input[\@name='FixedLimit']")->click();
            }
            else {
                $Selenium->find_element( "#$Stats->{Restriction}", 'css' )->click();
            }
            $Selenium->find_element("//button[\@value='Finish'][\@type='submit']")->click();

            # verify stats params
            for my $StatsValue ( sort keys %{ $Stats->{ExpectedValues} } ) {
                $Self->True(
                    index( $Selenium->get_page_source(), $Stats->{ExpectedValues}->{$StatsValue} ) > -1,
                    "Expexted $StatsValue for stats is founded - $Stats->{ExpectedValues}->{$StatsValue}"
                );
            }

            # get stats object
            $Kernel::OM->ObjectParamAdd(
                'Kernel::System::Stats' => {
                    UserID => 1,
                    }
            );
            my $StatsObject = $Kernel::OM->Get('Kernel::System::Stats');

            # get stats IDs
            my $StatsIDs = $StatsObject->GetStatsList(
                AccessRw => 1,
            );

            my $Count       = scalar @{$StatsIDs};
            my $StatsIDLast = $StatsIDs->[ $Count - 1 ];

            # open delete action screen
            $Selenium->find_element("//a[contains(\@href, \'Subaction=Delete\' )]")->click();

            # check delete action screen
            for my $StatsData ( $Stats->{Title}, $StatsIDLast ) {
                $Self->True(
                    index( $Selenium->get_page_source(), $StatsData ) > -1,
                    "$StatsData is founded on delete action screen"
                );
            }

            # delete stat
            $Selenium->find_element("//button[\@value='Yes'][\@type='submit']")->click();

            # sort descending stats by ID
            $Selenium->get("${ScriptAlias}index.pl?Subaction=Overview;Direction=DESC;OrderBy=ID;StartHit=1");

            # check if stats is deleted
            $Self->True(
                index( $Selenium->get_page_source(), $Stats->{Title} ) == -1,
                "$Stats->{Title} is deleted"
            );

        }
    }
);

1;
