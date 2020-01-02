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

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AdminService screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminService");

        # Check overview AdminService screen.
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Check breadcrumb on Overview screen.
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # Click 'Add Service'.
        $Selenium->find_element("//a[contains(\@href, \'ServiceEdit;ServiceID=NEW' )]")->VerifiedClick();

        # Check client side validation.
        $Selenium->find_element( "#Name",   'css' )->clear();
        $Selenium->find_element( "#Submit", 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Name.Error').length" );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Name').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # Navigate to AdminService screen again.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminService");

        # Click 'Add new service'.
        $Selenium->find_element("//a[contains(\@href, \'ServiceEdit;ServiceID=NEW' )]")->VerifiedClick();

        # Check add Service screen.
        for my $ID (
            qw(Name ParentID ValidID Comment)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Check breadcrumb on Add screen.
        my $Count = 1;
        for my $BreadcrumbText ( 'Service Management', 'Add Service' ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # Create first test Service.
        my $ServiceRandomID = "service" . $Helper->GetRandomID();
        my $ServiceComment  = "Selenium test Service";

        $Selenium->find_element( "#Name",    'css' )->send_keys($ServiceRandomID);
        $Selenium->find_element( "#Comment", 'css' )->send_keys($ServiceComment);
        $Selenium->find_element( "#Submit",  'css' )->VerifiedClick();

        # Create second test Service.
        $Selenium->find_element("//a[contains(\@href, \'ServiceEdit;ServiceID=NEW' )]")->VerifiedClick();

        my $ServiceRandomID2 = "service" . $Helper->GetRandomID();

        $Selenium->find_element( "#Name",    'css' )->send_keys($ServiceRandomID2);
        $Selenium->find_element( "#Comment", 'css' )->send_keys($ServiceComment);
        $Selenium->find_element( "#Submit",  'css' )->VerifiedClick();

        # Check for created test Services on AdminService screen.
        $Self->True(
            index( $Selenium->get_page_source(), $ServiceRandomID ) > -1,
            "$ServiceRandomID Service found on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), $ServiceRandomID2 ) > -1,
            "$ServiceRandomID2 Service found on page",
        );

        # Check new test Service values.
        $Selenium->find_element( $ServiceRandomID2, 'link_text' )->VerifiedClick();
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

        # Check breadcrumb on Edit screen.
        $Count = 1;
        for my $BreadcrumbText ( 'Service Management', 'Edit Service: ' . $ServiceRandomID2 ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');

        # Get test Services IDs.
        my @ServiceIDs;
        my $ServiceID = $ServiceObject->ServiceLookup(
            Name => $ServiceRandomID,
        );
        push @ServiceIDs, $ServiceID;

        my $ServiceID2 = $ServiceObject->ServiceLookup(
            Name => $ServiceRandomID2,
        );
        push @ServiceIDs, $ServiceID2;

        # Edit second test Service.
        $Selenium->InputFieldValueSet(
            Element => '#ParentID',
            Value   => $ServiceID,
        );
        $Selenium->find_element( "#Comment", 'css' )->clear();
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 2,
        );
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # Check class of invalid Service in the overview table.
        $Self->True(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($ServiceRandomID)').length"
            ),
            "There is a class 'Invalid' for test Service",
        );

        # Check edited test Selenium values.
        my $ServiceUpdatedRandomID2 = "$ServiceRandomID\::$ServiceRandomID2";

        $Selenium->find_element( $ServiceUpdatedRandomID2, 'link_text' )->VerifiedClick();
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
        $Selenium->InputFieldValueSet(
            Element => '#ParentID',
            Value   => '',
        );
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # Create third test Service.
        $Selenium->find_element("//a[contains(\@href, \'ServiceEdit;ServiceID=NEW' )]")->VerifiedClick();

        my $ServiceRandomID3 = "Long service" . $Helper->GetRandomID();
        $ServiceRandomID3
            .= $ServiceRandomID3 . $ServiceRandomID3 . $ServiceRandomID3 . $ServiceRandomID3 . $ServiceRandomID3;

        $Selenium->find_element( "#Name", 'css' )->send_keys($ServiceRandomID3);
        $Selenium->InputFieldValueSet(
            Element => '#ParentID',
            Value   => $ServiceID,
        );

        $Selenium->find_element( "#Comment", 'css' )->send_keys($ServiceComment);
        $Selenium->find_element( "#Submit",  'css' )->VerifiedClick();

        # Check for created test Services on AdminService screen.
        $Self->False(
            index( $Selenium->get_page_source(), $ServiceRandomID3 ) > -1,
            "$ServiceRandomID3 Service found on page",
        );

        $Selenium->WaitFor(
            JavaScript => 'return $(".Dialog:visible button.Close").length',
        );
        $Selenium->find_element( ".Dialog button.Close", "css" )->click();
        $Selenium->WaitFor(
            JavaScript => 'return !$(".Dialog:visible button.Close").length',
        );

        # Check if tooltip error message is there.
        $Self->True(
            index( $Selenium->get_page_source(), "Service name maximum length is 200 characters" ) > -1,
            "Check tooltip error message",
        );

        # Since there are no tickets that rely on our test Services we can remove them from DB.
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        for my $ServiceID (@ServiceIDs) {
            my $Success = $DBObject->Do(
                SQL => "DELETE FROM service_preferences WHERE service_id = $ServiceID",
            );
            $Self->True(
                $Success,
                "Deleted Service preferences - $ServiceID",
            );
            $Success = $DBObject->Do(
                SQL => "DELETE FROM service WHERE id = $ServiceID",
            );
            $Self->True(
                $Success,
                "Deleted Service - $ServiceID",
            );
        }

        # Make sure cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Service'
        );
    }
);

1;
