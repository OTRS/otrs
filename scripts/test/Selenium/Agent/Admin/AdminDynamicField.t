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

use Kernel::Language;

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # create and login test user
        my $Language      = 'de';
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups   => ['admin'],
            Language => $Language,
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get config object
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # navigate to AdminDynamiFied screen
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');
        $Selenium->get("${ScriptAlias}index.pl?Action=AdminDynamicField");

        # check overview AdminDynamicField
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # get which browser is used for testing
        my $TestBrowser = $ConfigObject->Get('SeleniumTestsConfig')->{browser_name};

        # check page
        for my $Type (
            qw(Ticket Article)
            )
        {
            for my $ID (
                qw(Checkbox Date DateTime Dropdown Multiselect Text TextArea)
                )
            {
                my $ObjectType = $Type . "DynamicField";
                my $Element = $Selenium->find_element( "#$ObjectType option[value=$ID]", 'css' );
                $Element->is_enabled();

                # create a real test DynamicField
                my $RandomID = $Helper->GetRandomID();
                $Selenium->execute_script("\$('#$ObjectType').val('$ID').trigger('redraw.InputField').trigger('change');");
                $Selenium->WaitFor( JavaScript => 'return $("#Name").length' );
                $Selenium->find_element( "#Name",                      'css' )->send_keys($RandomID);
                $Selenium->find_element( "#Label",                     'css' )->send_keys($RandomID);
                $Selenium->execute_script("\$('#ValidID').val('1').trigger('redraw.InputField').trigger('change');");
                $Selenium->find_element( "#Name",                      'css' )->submit();

                # check if test DynamicField show on AdminDynamicField screen
                $Selenium->WaitFor( JavaScript => "return \$('.DynamicFieldsContent').length" );
                $Self->True(
                    index( $Selenium->get_page_source(), $RandomID ) > -1,
                    "$RandomID $ID $Type DynamicField found on page",
                );

                # go to new DynamicField again
                $Selenium->find_element( $RandomID, 'link_text' )->click();
                $Selenium->WaitFor( JavaScript => "return \$('#Label').length" );
                $Selenium->find_element( "#Label",                     'css' )->clear();
                $Selenium->find_element( "#Label",                     'css' )->send_keys( $RandomID . "-update" );
                $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");
                $Selenium->find_element( "#Name",                      'css' )->submit();

                # wait to load overview screen
                $Selenium->WaitFor( JavaScript => "return \$('.DynamicFieldsContent').length" );

                # check class of invalid DynamicField in the overview table
                $Self->True(
                    $Selenium->execute_script(
                        "return \$('tr.Invalid td a:contains($RandomID)').length"
                    ),
                    "There is a class 'Invalid' for test DynamicField",
                );

                # go to new DynamicField again after update and check values
                $Selenium->find_element( $RandomID, 'link_text' )->click();
                $Selenium->WaitFor( JavaScript => "return \$('#Name').length" );

                # check new DynamicField values
                $Self->Is(
                    $Selenium->find_element( '#Name', 'css' )->get_value(),
                    $RandomID,
                    "#Name stored value",
                );
                $Self->Is(
                    $Selenium->find_element( '#Label', 'css' )->get_value(),
                    $RandomID . "-update",
                    "#Label stored value",
                );
                $Self->Is(
                    $Selenium->find_element( '#ValidID', 'css' )->get_value(),
                    2,
                    "#ValidID stored value",
                );

                $Selenium->get("${ScriptAlias}index.pl?Action=AdminDynamicField");

                # delete DynamicFields, check button for deleting Dynamic Field
                my $DynamicFieldID = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
                    Name => $RandomID
                )->{ID};

                # click on delete icon
                my $CheckConfirmJS = <<"JAVASCRIPT";
(function () {
    var lastConfirm = undefined;
    window.confirm = function (message) {
        lastConfirm = message;
        return true;
    };
    window.getLastConfirm = function () {
        var result = lastConfirm;
        lastConfirm = undefined;
        return result;
    };
}());
JAVASCRIPT
                $Selenium->execute_script($CheckConfirmJS);

                $Selenium->find_element(
                    "//a[contains(\@data-query-string, \'Subaction=DynamicFieldDelete;ID=$DynamicFieldID' )]"
                )->click();

                my $LanguageObject = Kernel::Language->new(
                    UserLanguage => $Language,
                );

                $Self->Is(
                    $Selenium->execute_script("return window.getLastConfirm()"),
                    $LanguageObject->Translate(
                        'Do you really want to delete this dynamic field? ALL associated data will be LOST!'
                    ),
                    'Check for opened confirm text',
                );

                $Selenium->WaitFor( JavaScript => 'return $(".Dialog:visible").length === 0;' );
                $Selenium->get("${ScriptAlias}index.pl?Action=AdminDynamicField");

                my $Success;
                eval {
                    $Success = $Selenium->find_element( $RandomID, 'link_text' )->is_displayed();
                };

                $Self->False(
                    $Success,
                    "$RandomID dynamic field is deleted!",
                );

            }

            # make sure the cache is correct.
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => "DynamicField" );
        }
    }
);

1;
