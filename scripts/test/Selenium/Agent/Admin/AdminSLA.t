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

        $Selenium->get("${ScriptAlias}index.pl?Action=AdminSLA");

        # check overview screen
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # click "Add SLA"
        $Selenium->find_element("//a[contains(\@href, \'Subaction=SLAEdit' )]")->click();

        # check add SLA screen
        for my $ID (
            qw(Name ServiceIDs Calendar FirstResponseTime FirstResponseNotify UpdateTime
            UpdateNotify SolutionTime SolutionNotify ValidID Comment)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

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

        # create test SLA
        my $SLARandomID = "SLA" . $Helper->GetRandomID();
        my $SLAComment  = "Selenium SLA test";

        $Selenium->find_element( "#Name",    'css' )->send_keys($SLARandomID);
        $Selenium->find_element( "#Comment", 'css' )->send_keys($SLAComment);
        $Selenium->find_element( "#Name",    'css' )->submit();

        # wait to load overview screen
        $Selenium->WaitFor( JavaScript => "return \$('a.AsBlock:contains($SLARandomID)').length" );

        # check if test SLA show on AdminSLA screen
        $Self->True(
            index( $Selenium->get_page_source(), $SLARandomID ) > -1,
            "$SLARandomID SLA found on page",
        );

        # check test SLA values
        $Selenium->find_element( $SLARandomID, 'link_text' )->click();

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

        # remove test SLA comment and set it to invalid
        $Selenium->find_element( "#Comment", 'css' )->clear();
        $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Name", 'css' )->submit();

        # wait to load overview screen
        $Selenium->WaitFor( JavaScript => "return \$('a.AsBlock:contains($SLARandomID)').length" );

        # check class of invalid SLA in the overview table
        $Self->True(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($SLARandomID)').length"
            ),
            "There is a class 'Invalid' for test SLA",
        );

        # check edited SLA values
        $Selenium->find_element( $SLARandomID, 'link_text' )->click();

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

        # Since there are no tickets that rely on our test SLA we can remove it from DB
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
