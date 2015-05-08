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

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

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

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        $Selenium->get("${ScriptAlias}index.pl?Action=AdminDynamicField");

        # check overview AdminDynamicField
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

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
                $Element->is_displayed();

                # create a real test DynamicField
                my $RandomID = $Helper->GetRandomID();
                $Element->click();

                $Selenium->find_element( "#Name",                      'css' )->send_keys($RandomID);
                $Selenium->find_element( "#Label",                     'css' )->send_keys($RandomID);
                $Selenium->find_element( "#ValidID option[value='1']", 'css' )->click();
                $Selenium->find_element( "#Name",                      'css' )->submit();

                # check if test DynamicField show on AdminDynamicField screen
                $Self->True(
                    index( $Selenium->get_page_source(), $RandomID ) > -1,
                    "$RandomID $Type DynamicField found on page",
                );

                # go to new DynamicField again
                $Selenium->find_element( $RandomID,                    'link_text' )->click();
                $Selenium->find_element( "#Label",                     'css' )->clear();
                $Selenium->find_element( "#Label",                     'css' )->send_keys( $RandomID . "-update" );
                $Selenium->find_element( "#ValidID option[value='2']", 'css' )->click();
                $Selenium->find_element( "#Name",                      'css' )->submit();

                # go to new DynamicField again after update and check values
                $Selenium->find_element( $RandomID, 'link_text' )->click();

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

                # delete DynamicFields, check button for deleting Dynamic Field
                $Selenium->get("${ScriptAlias}index.pl?Action=AdminDynamicField");
                my $DynamicFieldID = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
                    Name => $RandomID
                )->{ID};

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
                    $LanguageObject->Get('Do you really want to delete this dynamic field? ALL associated data will be LOST!'),
                    'Check for opened confirm text',
                );

                sleep 1;    # allow some time for field deletion

                $Selenium->refresh();
                my $Success;
                eval {
                    $Success = $Selenium->find_element( $RandomID, 'link_text' )->is_displayed();
                };

                $Self->False(
                    $Success,
                    "$RandomID dynamic filed is deleted!",
                );

            }

            # Make sure the cache is correct.
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => "DynamicField" );
        }
    }
);

1;
