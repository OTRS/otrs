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

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $DBObject     = $Kernel::OM->Get('Kernel::System::DB');
my $Selenium     = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

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

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminSLA");

        # Check overview screen.
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Check breadcrumb on Overview screen.
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # Click "Add SLA".
        $Selenium->find_element("//a[contains(\@href, \'Subaction=SLAEdit' )]")->VerifiedClick();

        # Check add SLA screen.
        for my $ID (
            qw(Name ServiceIDs Calendar FirstResponseTime FirstResponseNotify UpdateTime
            UpdateNotify SolutionTime SolutionNotify ValidID Comment)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Check client side validation.
        $Selenium->find_element( "#Name", 'css' )->clear();
        $Selenium->find_element("//button[\@type='submit']")->click();
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('#Name.Error').length"
        );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Name').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # Check breadcrumb on Add screen.
        my $Count = 1;
        for my $BreadcrumbText ( 'SLA Management', 'Add SLA' ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # Create test SLA.
        my $SLARandomID = "SLA" . $Helper->GetRandomID();
        my $SLAComment  = "Selenium SLA test";

        $Selenium->find_element( "#Name",    'css' )->send_keys($SLARandomID);
        $Selenium->find_element( "#Comment", 'css' )->send_keys($SLAComment);
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

        # Check if test SLA show on AdminSLA screen.
        $Self->True(
            index( $Selenium->get_page_source(), $SLARandomID ) > -1,
            "$SLARandomID SLA found on page",
        );

        # Check test SLA values.
        $Selenium->find_element( $SLARandomID, 'link_text' )->VerifiedClick();

        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $SLARandomID,
            "#Name stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            $SLAComment,
            "#Comment stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            1,
            "#ValidID stored value",
        );

        # Check breadcrumb on Edit screen.
        $Count = 1;
        for my $BreadcrumbText ( 'SLA Management', 'Edit SLA: ' . $SLARandomID ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # Remove test SLA comment and set it to invalid.
        $Selenium->find_element( "#Comment", 'css' )->clear();
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 2,
        );
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

        # Check class of invalid SLA in the overview table.
        $Self->True(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($SLARandomID)').length"
            ),
            "There is a class 'Invalid' for test SLA",
        );

        # Check edited SLA values.
        $Selenium->find_element( $SLARandomID, 'link_text' )->VerifiedClick();

        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            "",
            "#Comment updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            2,
            "#ValidID stored value",
        );

        # Since there are no tickets that rely on our test SLA we can remove it from DB.
        my $SLAID = $Kernel::OM->Get('Kernel::System::SLA')->SLALookup(
            Name => $SLARandomID,
        );
        if ($SLARandomID) {
            my $Success = $DBObject->Do(
                SQL => "DELETE FROM sla_preferences WHERE sla_id = $SLAID",
            );
            $Self->True(
                $Success,
                "SLAPreferencesDelete - $SLARandomID",
            );
            $Success = $DBObject->Do(
                SQL => "DELETE FROM sla WHERE id = $SLAID",
            );
            $Self->True(
                $Success,
                "SLADelete - $SLARandomID",
            );
        }

    }

);

1;
