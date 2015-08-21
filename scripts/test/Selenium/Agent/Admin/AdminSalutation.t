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

        # get helper object
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 1,
            },
        );
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # do not check RichText
        $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
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
        $Selenium->get("${ScriptAlias}index.pl?Action=AdminSalutation");

        # check overview screen
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # click 'Add salutation'
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminSalutation;Subaction=Add' )]")->click();
        for my $ID (
            qw(Name RichText ValidID Comment)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # check client side validation
        my $Element = $Selenium->find_element( "#Name", 'css' );
        $Element->send_keys("");
        $Element->submit();

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Name').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # create real test Salutation
        my $SalutationRandomID = "Salutation" . $Helper->GetRandomID();
        my $SalutationRichText = "Dear <OTRS_OWNER_Userfirstname>>,\n\nThank you for your request.";
        my $SalutationComment  = "Selenium Salutation test";

        $Selenium->find_element( "#Name",     'css' )->send_keys($SalutationRandomID);
        $Selenium->find_element( "#RichText", 'css' )->send_keys($SalutationRichText);
        $Selenium->find_element( "#Comment",  'css' )->send_keys($SalutationComment);
        $Selenium->find_element( "#Name",     'css' )->submit();

        # check if test Salutation show on AdminSalutation screen
        $Self->True(
            index( $Selenium->get_page_source(), $SalutationRandomID ) > -1,
            "$SalutationRandomID Salutation found on page",
        );

        # check test Salutation values
        $Selenium->find_element( $SalutationRandomID, 'link_text' )->click();

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

        # edit test Salutation, clear comment and set it to invalid
        my $EditSalutationRichText = "Dear <OTRS_CUSTOMER_Userlastname>,\n\nThank you for your request.";

        $Selenium->find_element( "#RichText",                  'css' )->clear();
        $Selenium->find_element( "#RichText",                  'css' )->send_keys($EditSalutationRichText);
        $Selenium->find_element( "#Comment",                   'css' )->clear();
        $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Name",                      'css' )->submit();

        # check edited Salutation
        $Selenium->find_element( $SalutationRandomID, 'link_text' )->click();

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

        # go back to AdminSalutation overview screen
        $Selenium->get("${ScriptAlias}index.pl?Action=AdminSalutation");

        # chack class of invalid Salutation in the overview table
        $Self->True(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($SalutationRandomID)').length"
            ),
            "There is a class 'Invalid' for test Salutation",
        );

        # since there are no tickets that rely on our test Salutation, we can remove them
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

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Salutation'
        );

    }

);

1;
