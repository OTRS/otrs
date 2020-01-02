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

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminSalutation");

        # Check overview screen.
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Check breadcrumb on Overview screen.
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # Click 'Add salutation'.
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminSalutation;Subaction=Add' )]")->VerifiedClick();
        for my $ID (
            qw(Name RichText ValidID Comment)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Check breadcrumb on Add screen.
        my $Count = 1;
        for my $BreadcrumbText ( 'Salutation Management', 'Add Salutation' ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # Check if Signature field has validation. See bug#14881.
        # Check client side validation.
        for my $HTMLElement (qw(Name RichText)) {
            my $Element = $Selenium->find_element( "#$HTMLElement", 'css' );
            $Element->send_keys("");
            $Selenium->find_element("//button[\@type='submit']")->click();
            $Selenium->WaitFor(
                JavaScript => "return typeof(\$) === 'function' && \$('#$HTMLElement.Error').length"
            );

            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#$HTMLElement').hasClass('Error')"
                ),
                '1',
                "Client side validation correctly detected missing input value for Element $HTMLElement",
            );
        }

        # Create real test Salutation.
        my $SalutationRandomID = "Salutation" . $Helper->GetRandomID();
        my $SalutationRichText = "Dear <OTRS_OWNER_Userfirstname>>,\n\nThank you for your request.";
        my $SalutationComment  = "Selenium Salutation test";

        $Selenium->find_element( "#Name",     'css' )->send_keys($SalutationRandomID);
        $Selenium->find_element( "#RichText", 'css' )->send_keys($SalutationRichText);
        $Selenium->find_element( "#Comment",  'css' )->send_keys($SalutationComment);
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

        # Check if test Salutation show on AdminSalutation screen.
        $Self->True(
            index( $Selenium->get_page_source(), $SalutationRandomID ) > -1,
            "$SalutationRandomID Salutation found on page",
        );

        # Check test Salutation values.
        $Selenium->find_element( $SalutationRandomID, 'link_text' )->VerifiedClick();

        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $SalutationRandomID,
            "#Name stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#RichText', 'css' )->get_value(),
            $SalutationRichText,
            "#RichText stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            $SalutationComment,
            "#Comment stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            1,
            "#ValidID stored value",
        );

        # Check breadcrumb on Edit screen.
        $Count = 1;
        for my $BreadcrumbText ( 'Salutation Management', 'Edit Salutation: ' . $SalutationRandomID ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # Edit test Salutation, clear comment and set it to invalid.
        my $EditSalutationRichText = "Dear <OTRS_CUSTOMER_Userlastname>,\n\nThank you for your request.";

        $Selenium->find_element( "#RichText", 'css' )->clear();
        $Selenium->find_element( "#RichText", 'css' )->send_keys($EditSalutationRichText);
        $Selenium->find_element( "#Comment",  'css' )->clear();
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 2,
        );
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

        # Check edited Salutation.
        $Selenium->find_element( $SalutationRandomID, 'link_text' )->VerifiedClick();

        $Self->Is(
            $Selenium->find_element( '#RichText', 'css' )->get_value(),
            $EditSalutationRichText,
            "#RichText updated value",
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

        # Go back to AdminSalutation overview screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminSalutation");

        # Check class of invalid Salutation in the overview table.
        $Self->True(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($SalutationRandomID)').length"
            ),
            "There is a class 'Invalid' for test Salutation",
        );

        # Since there are no tickets that rely on our test Salutation, we can remove them
        # again from the DB.
        if ($SalutationRandomID) {
            $SalutationRandomID = $DBObject->Quote($SalutationRandomID);
            my $Success = $DBObject->Do(
                SQL  => "DELETE FROM salutation WHERE name = ?",
                Bind => [ \$SalutationRandomID ],
            );
            if ($Success) {
                $Self->True(
                    $Success,
                    "SalutationDelete - $SalutationRandomID",
                );
            }
        }

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Salutation'
        );
    }
);

1;
