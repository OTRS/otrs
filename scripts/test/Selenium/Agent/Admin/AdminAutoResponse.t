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
        $Selenium->get("${ScriptAlias}index.pl?Action=AdminAutoResponse");

        # check overview AdminAutoResponse
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # click 'Add auto response'
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminAutoResponse;Subaction=Add' )]")->click();

        # check page
        for my $ID (
            qw(Name Subject RichText TypeID AddressID ValidID Comment)
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

        # create a real test Auto Response
        my $RandomID = 'AutoResponse' . $Helper->GetRandomID();
        my $Text     = "Seleniumn auto response text";

        $Selenium->find_element( "#Name",                        'css' )->send_keys($RandomID);
        $Selenium->find_element( "#Subject",                     'css' )->send_keys($RandomID);
        $Selenium->find_element( "#RichText",                    'css' )->send_keys($Text);
        $Selenium->execute_script("\$('#TypeID').val('1').trigger('redraw.InputField').trigger('change');");
        $Selenium->execute_script("\$('#AddressID').val('1').trigger('redraw.InputField').trigger('change');");
        $Selenium->execute_script("\$('#ValidID').val('1').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Name",                        'css' )->submit();

        # check if test auto resposne show on AdminAutoResponse screen
        $Self->True(
            index( $Selenium->get_page_source(), $RandomID ) > -1,
            "$RandomID job found on page",
        );

        # edit test job and set it to invalid
        $Selenium->find_element( $RandomID, 'link_text' )->click();
        my $RandomID2 = 'AutoResponseUpdate' . $Helper->GetRandomID();
        $Selenium->find_element( "#Name",                      'css' )->clear();
        $Selenium->find_element( "#Name",                      'css' )->send_keys($RandomID2);
        $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Name",                      'css' )->submit();

        # check if edited auto response show on AdminAutoResponse
        $Self->True(
            index( $Selenium->get_page_source(), $RandomID2 ) > -1,
            "$RandomID2 auto response found on page",
        );

        # check class of invalid AutoResponse in the overview table
        $Self->True(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($RandomID2)').length"
            ),
            "There is a class 'Invalid' for test AutoResponse",
        );

        # since there are no tickets that rely on our test auto response, we can remove them
        # again from the DB.
        if ($RandomID2) {
            my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
            $RandomID2 = $DBObject->Quote($RandomID2);
            my $Success = $DBObject->Do(
                SQL  => "DELETE FROM auto_response WHERE name = ?",
                Bind => [ \$RandomID2 ],
            );
            if ($Success) {
                $Self->True(
                    $Success,
                    "AutoResponseDelete - $RandomID2",
                );
            }
        }

    }

);

1;
