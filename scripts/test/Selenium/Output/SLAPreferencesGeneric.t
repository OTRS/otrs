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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # activate Service
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 1
        );

        my %SLAPreferences = (
            Module  => "Kernel::Output::HTML::SLAPreferences::Generic",
            Label   => "Comment2",
            Desc    => "Define the sla comment 2.",
            Block   => "TextArea",
            Cols    => 50,
            Rows    => 5,
            PrefKey => "Comment2",
        );

        # enable SLAPreferences
        $Helper->ConfigSettingChange(
            Key   => 'SLAPreferences###Comment2',
            Value => \%SLAPreferences,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SLAPreferences###Comment2',
            Value => \%SLAPreferences,
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # go to SLA admin
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminSLA");

        # click "Add SLA"
        $Selenium->find_element("//a[contains(\@href, \'Subaction=SLAEdit' )]")->VerifiedClick();

        # check add page, and especially included SLA attribute Comment2
        for my $ID (
            qw( Name ServiceIDs Calendar FirstResponseTime FirstResponseNotify UpdateTime
            UpdateNotify SolutionTime SolutionNotify ValidID Comment Comment2 )
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # create a real test SLA
        my $RandomSLAName = "SLA" . $Helper->GetRandomID();
        $Selenium->find_element( "#Name",    'css' )->send_keys($RandomSLAName);
        $Selenium->find_element( "#Comment", 'css' )->send_keys("Some SLA Comment");

        # set included SLA attribute Comment2
        $Selenium->find_element( "#Comment2", 'css' )->send_keys('SLAPreferences Comment2');
        $Selenium->find_element( "#Submit",   'css' )->VerifiedClick();

        # check if test SLA is created
        $Self->True(
            index( $Selenium->get_page_source(), $RandomSLAName ) > -1,
            'New SLA found on table'
        );

        # go to new SLA again
        $Selenium->find_element( $RandomSLAName, 'link_text' )->VerifiedClick();

        # check SLA value
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            'Some SLA Comment',
            "#Comment stored value",
        );

        $Self->Is(
            $Selenium->find_element( '#Comment2', 'css' )->get_value(),
            'SLAPreferences Comment2',
            "#Comment2 stored value",
        );

        # update SLA
        my $UpdatedComment = "Updated comment for SLAPreferences Comment2";

        $Selenium->find_element( "#Comment2", 'css' )->clear();
        $Selenium->find_element( "#Comment2", 'css' )->send_keys($UpdatedComment);
        $Selenium->find_element( "#Submit",   'css' )->VerifiedClick();

        # check updated values
        $Selenium->find_element( $RandomSLAName, 'link_text' )->VerifiedClick();

        $Self->Is(
            $Selenium->find_element( '#Comment2', 'css' )->get_value(),
            $UpdatedComment,
            "#Comment2 updated value",
        );

        # delete test SLA
        my $SLAID = $Kernel::OM->Get('Kernel::System::SLA')->SLALookup(
            Name => $RandomSLAName,
        );

        # get DB object
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        my $Success = $DBObject->Do(
            SQL => "DELETE FROM sla_preferences WHERE sla_id = $SLAID",
        );
        $Self->True(
            $Success,
            "SLAPreferences are deleted - $RandomSLAName",
        );

        $Success = $DBObject->Do(
            SQL => "DELETE FROM sla WHERE id = $SLAID",
        );
        $Self->True(
            $Success,
            "SLA is deleted - $RandomSLAName",
        );

        # make sure the cache is correct.
        for my $Cache (
            qw (SLAPreferencesDB SysConfig)
            )
        {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }

    }
);

1;
