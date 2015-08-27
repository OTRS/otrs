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
        $Selenium->get("${ScriptAlias}index.pl?Action=AdminSignature");

        # check overview screen
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # click 'Add signature'
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminSignature;Subaction=Add' )]")->click();
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

        # create real test Signature
        my $SignatureRandomID = "Signature" . $Helper->GetRandomID();
        my $SignatureRichText = "Your Ticket-Team \n\n<OTRS_Owner_UserFirstname> <OTRS_Owner_UserLastname>";
        my $SignatureComment  = "Selenium Signature test";

        $Selenium->find_element( "#Name",     'css' )->send_keys($SignatureRandomID);
        $Selenium->find_element( "#RichText", 'css' )->send_keys($SignatureRichText);
        $Selenium->find_element( "#Comment",  'css' )->send_keys($SignatureComment);
        $Selenium->find_element( "#Name",     'css' )->submit();

        # check if test Signature show on AdminSignature screen
        $Self->True(
            index( $Selenium->get_page_source(), $SignatureRandomID ) > -1,
            "$SignatureRandomID Signature found on page",
        );

        # check test Signature values
        $Selenium->find_element( $SignatureRandomID, 'link_text' )->click();

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

        # edit test Signature, clear comment and set it to invalid
        my $EditSignatureRichText
            = "Your Ticket-Team \n\n<OTRS_Responsible_UserFirstname> <OTRS_Responsible_UserLastname>";

        $Selenium->find_element( "#RichText", 'css' )->clear();
        $Selenium->find_element( "#RichText", 'css' )->send_keys($EditSignatureRichText);
        $Selenium->find_element( "#Comment",  'css' )->clear();
        $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Name", 'css' )->submit();

        # chack class of invalid Signature in the overview table
        $Self->True(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($SignatureRandomID)').length"
            ),
            "There is a class 'Invalid' for test Signature",
        );

        # check edited Signature
        $Selenium->find_element( $SignatureRandomID, 'link_text' )->click();

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

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Signature'
        );

    }

);

1;
