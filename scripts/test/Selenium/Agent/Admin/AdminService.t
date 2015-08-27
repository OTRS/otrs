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

# get needed objects
my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');
my $DBObject      = $Kernel::OM->Get('Kernel::System::DB');
my $Selenium      = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');
        $Selenium->get("${ScriptAlias}index.pl?Action=AdminService");

        # check overview AdminService screen
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # click 'Add Service'
        $Selenium->find_element("//a[contains(\@href, \'ServiceEdit;ServiceID=NEW' )]")->click();

        # check client side validation
        $Selenium->find_element( "#Name", 'css' )->clear();
        $Selenium->find_element( "#Name", 'css' )->submit();
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Name').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        $Selenium->get("${ScriptAlias}index.pl?Action=AdminService");
        $Selenium->find_element("//a[contains(\@href, \'ServiceEdit;ServiceID=NEW' )]")->click();

        # check add Service screen
        for my $ID (
            qw(Name ParentID ValidID Comment)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # create first test Service
        my $ServiceRandomID = "service" . $Helper->GetRandomID();
        my $ServiceComment  = "Selenium test Service";

        $Selenium->find_element( "#Name",    'css' )->send_keys($ServiceRandomID);
        $Selenium->find_element( "#Comment", 'css' )->send_keys($ServiceComment);
        $Selenium->find_element( "#Name",    'css' )->submit();

        # wait to load overview screen
        $Selenium->WaitFor( JavaScript => "return \$('.ActionList span:contains(Add service)').length" );

        # create second test Service
        $Selenium->find_element("//a[contains(\@href, \'ServiceEdit;ServiceID=NEW' )]")->click();

        my $ServiceRandomID2 = "service" . $Helper->GetRandomID();

        $Selenium->find_element( "#Name",    'css' )->send_keys($ServiceRandomID2);
        $Selenium->find_element( "#Comment", 'css' )->send_keys($ServiceComment);
        $Selenium->find_element( "#Name",    'css' )->submit();

        # wait to load overview screen
        $Selenium->WaitFor( JavaScript => "return \$('a.AsBlock:contains($ServiceRandomID)').length" );

        # check for created test Services on AdminService screen
        $Self->True(
            index( $Selenium->get_page_source(), $ServiceRandomID ) > -1,
            "$ServiceRandomID Service found on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), $ServiceRandomID2 ) > -1,
            "$ServiceRandomID2 Service found on page",
        );

        # check new test Service values
        $Selenium->find_element( $ServiceRandomID2, 'link_text' )->click();
        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $ServiceRandomID2,
            "#Name stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            $ServiceComment,
            "#Comment stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            1,
            "#ValidID stored value",
        );

        # get test Services IDs
        my @ServiceIDs;
        my $ServiceID = $ServiceObject->ServiceLookup(
            Name => $ServiceRandomID,
        );
        push @ServiceIDs, $ServiceID;

        my $ServiceID2 = $ServiceObject->ServiceLookup(
            Name => $ServiceRandomID2,
        );
        push @ServiceIDs, $ServiceID2;

        # edit second test Service
        $Selenium->execute_script("\$('#ParentID').val('$ServiceID').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Comment", 'css' )->clear();
        $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Name", 'css' )->submit();

        # check class of invalid Service in the overview table
        $Self->True(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($ServiceRandomID)').length"
            ),
            "There is a class 'Invalid' for test Service",
        );

        # check edited test Selenium values
        my $ServiceUpdatedRandomID2 = "$ServiceRandomID\::$ServiceRandomID2";

        $Selenium->find_element( $ServiceUpdatedRandomID2, 'link_text' )->click();
        $Self->Is(
            $Selenium->find_element( '#ParentID', 'css' )->get_value(),
            $ServiceID,
            "#ParentID updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            "",
            "#Comment updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            2,
            "#ValidID updated value",
        );
        $Selenium->execute_script("\$('#ParentID').val('').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Name", 'css' )->submit();

        # Since there are no tickets that rely on our test Services we can remove
        # them from DB
        for my $ServiceID (@ServiceIDs) {
            my $Success = $DBObject->Do(
                SQL => "DELETE FROM service WHERE id = $ServiceID",
            );
            $Self->True(
                $Success,
                "Deleted Service - $ServiceID",
            );
        }

        # make sure cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Service'
        );

    }

);

1;
