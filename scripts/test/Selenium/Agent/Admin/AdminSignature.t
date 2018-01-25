# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminSignature");

        # Check overview screen.
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Check breadcrumb on Overview screen.
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # Click 'Add signature'.
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminSignature;Subaction=Add' )]")->VerifiedClick();
        for my $ID (
            qw(Name RichText ValidID Comment)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Check client side validation.
        my $Element = $Selenium->find_element( "#Name", 'css' );
        $Element->send_keys("");
        $Selenium->find_element( "#Submit", 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Name.Error').length" );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Name').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # Check breadcrumb on Add screen.
        my $Count = 1;
        for my $BreadcrumbText ( 'Signature Management', 'Add Signature' ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # Create real test Signature.
        my $SignatureRandomID = "Signature" . $Helper->GetRandomID();

        # Also check leading and trailing white space.
        my $SignatureRichText = "\n\nYour Ticket-Team \n\n<OTRS_Owner_UserFirstname> <OTRS_Owner_UserLastname>\n";
        my $SignatureComment  = "Selenium Signature test";

        $Selenium->find_element( "#Name",     'css' )->send_keys($SignatureRandomID);
        $Selenium->find_element( "#RichText", 'css' )->send_keys($SignatureRichText);
        $Selenium->find_element( "#Comment",  'css' )->send_keys($SignatureComment);
        $Selenium->find_element( "#Submit",   'css' )->VerifiedClick();

        # Check if test Signature show on AdminSignature screen.
        $Self->True(
            index( $Selenium->get_page_source(), $SignatureRandomID ) > -1,
            "$SignatureRandomID Signature found on page",
        );

        # Check is there notification after service is added.
        my $Notification = 'Signature added!';
        $Self->True(
            $Selenium->execute_script("return \$('.MessageBox.Notice p:contains($Notification)').length"),
            "$Notification - notification is found."
        );

        # Check test Signature values.
        $Selenium->find_element( $SignatureRandomID, 'link_text' )->VerifiedClick();

        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $SignatureRandomID,
            "#Name stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#RichText', 'css' )->get_value(),
            $SignatureRichText,
            "#RichText stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            $SignatureComment,
            "#Comment stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            1,
            "#ValidID stored value",
        );

        # Check breadcrumb on Edit screen.
        $Count = 1;
        for my $BreadcrumbText ( 'Signature Management', 'Edit Signature: ' . $SignatureRandomID ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # Edit test Signature, clear comment and set it to invalid.
        my $EditSignatureRichText
            = "Your Ticket-Team \n\n<OTRS_Responsible_UserFirstname> <OTRS_Responsible_UserLastname>";

        $Selenium->find_element( "#RichText", 'css' )->clear();
        $Selenium->find_element( "#RichText", 'css' )->send_keys($EditSignatureRichText);
        $Selenium->find_element( "#Comment",  'css' )->clear();
        $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # Check is there notification after service is updated.
        $Notification = 'Signature updated!';
        $Self->True(
            $Selenium->execute_script("return \$('.MessageBox.Notice p:contains($Notification)').length"),
            "$Notification - notification is found."
        );

        # Check class of invalid Signature in the overview table.
        $Self->True(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($SignatureRandomID)').length"
            ),
            "There is a class 'Invalid' for test Signature",
        );

        # Check edited Signature.
        $Selenium->find_element( $SignatureRandomID, 'link_text' )->VerifiedClick();

        $Self->Is(
            $Selenium->find_element( '#RichText', 'css' )->get_value(),
            $EditSignatureRichText,
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

        # Since there are no tickets that rely on our test Signature, we can remove them
        # again from the DB.
        if ($SignatureRandomID) {
            $SignatureRandomID = $DBObject->Quote($SignatureRandomID);
            my $Success = $DBObject->Do(
                SQL  => "DELETE FROM signature WHERE name = ?",
                Bind => [ \$SignatureRandomID ],
            );
            if ($Success) {
                $Self->True(
                    $Success,
                    "SignatureDelete - $SignatureRandomID",
                );
            }
        }

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Signature'
        );

    }

);

1;
