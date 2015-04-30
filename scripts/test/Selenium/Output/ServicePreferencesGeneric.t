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

        # activate Service
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 1
        );

        my %ServicePreferences = (
            Module  => "Kernel::Output::HTML::ServicePreferences::Generic",
            Label   => "Comment2",
            Desc    => "Define the service comment 2.",
            Block   => "TextArea",
            Cols    => 50,
            Rows    => 5,
            PrefKey => "Comment2",
        );

        # enable ServicePreferences
        $Kernel::OM->Get('Kernel::Config')->Set(
            Key   => 'ServicePreferences###Comment2',
            Value => \%ServicePreferences,
        );

        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'ServicePreferences###Comment2',
            Value => \%ServicePreferences,
        );

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # go to service admin
        $Selenium->get("${ScriptAlias}index.pl?Action=AdminService");

        # click "Add service"
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ServiceEdit' )]")->click();

        # check add page, and especially included service attribute Comment2
        for my $ID (
            qw( Name ParentID ValidID Comment Comment2 )
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # create a real test service
        my $RandomServiceName = "Service" . $Helper->GetRandomID();
        $Selenium->find_element( "#Name",    'css' )->send_keys($RandomServiceName);
        $Selenium->find_element( "#Comment", 'css' )->send_keys("Some service Comment");

        # set included service attribute Comment2
        $Selenium->find_element( "#Comment2", 'css' )->send_keys('ServicePreferences Comment2');
        $Selenium->find_element( "#Name",     'css' )->submit();

        # check if test service is created
        $Self->True(
            index( $Selenium->get_page_source(), $RandomServiceName ) > -1,
            'New service found on table'
        );

        # go to new service again
        $Selenium->find_element( $RandomServiceName, 'link_text' )->click();

        # check service value
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            'Some service Comment',
            "#Comment stored value",
        );

        $Self->Is(
            $Selenium->find_element( '#Comment2', 'css' )->get_value(),
            'ServicePreferences Comment2',
            "#Comment2 stored value",
        );

        # update service
        my $UpdatedComment = "Updated comment for ServicePreferences Comment2";

        $Selenium->find_element( "#Comment2", 'css' )->clear();
        $Selenium->find_element( "#Comment2", 'css' )->send_keys($UpdatedComment);
        $Selenium->find_element( "#Comment2", 'css' )->submit();

        # check updated values
        $Selenium->find_element( $RandomServiceName, 'link_text' )->click();

        $Self->Is(
            $Selenium->find_element( '#Comment2', 'css' )->get_value(),
            $UpdatedComment,
            "#Comment2 updated value",
        );

        # delete test service
        my $ServiceID = $Kernel::OM->Get('Kernel::System::Service')->ServiceLookup(
            Name => $RandomServiceName,
        );

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        my $Success = $DBObject->Do(
            SQL => "DELETE FROM service_preferences WHERE service_id = $ServiceID",
        );
        $Self->True(
            $Success,
            "ServicePreferences are deleted - $RandomServiceName",
        );

        $Success = $DBObject->Do(
            SQL => "DELETE FROM service WHERE id = $ServiceID",
        );
        $Self->True(
            $Success,
            "Service is deleted - $RandomServiceName",
        );

        # make sure the cache is correct.
        for my $Cache (
            qw (ServicePreferencesDB Service SysConfig)
            )
        {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }

        }
);

1;
