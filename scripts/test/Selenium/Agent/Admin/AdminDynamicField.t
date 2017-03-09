# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
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

my $CheckBredcrumb = sub {

    my %Param = @_;

    my $OverviewTitle  = $Param{OverviewTitle};
    my $BreadcrumbText = $Param{BreadcrumbText} || '';
    my $Count          = 1;

    for my $BreadcrumbText ( $OverviewTitle, $BreadcrumbText ) {
        $Self->Is(
            $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
            $BreadcrumbText,
            "Breadcrumb text '$BreadcrumbText' is found on screen"
        );

        $Count++;
    }
};

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        my %DynamicFieldsOverviewPageShownSysConfig = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet(
            Name => 'PreferencesGroups###DynamicFieldsOverviewPageShown',
        );

        # show more dynamic fields per page as the default value
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'PreferencesGroups###DynamicFieldsOverviewPageShown',
            Value => {
                %{ $DynamicFieldsOverviewPageShownSysConfig{EffectiveValue} },
                DataSelected => 999,
            },
        );

        # create test user and login
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

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AdminDynamiFied screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminDynamicField");

        # get language object
        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $Language,
        );

        # check overview AdminDynamicField
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # check breadcrumb on Overview screen
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # define variables for breadcrumb
        my $OverviewTitleBreadcrumb = $LanguageObject->Translate('Dynamic Fields Management');
        my $IDText;

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
                $Selenium->execute_script(
                    "\$('#$ObjectType').val('$ID').trigger('redraw.InputField').trigger('change');"
                );

                # wait until page has finished loading
                $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Name").length' );

                # modify names in two cases
                if ( $ID eq 'DateTime' ) {
                    $IDText = 'Date / Time';
                }
                elsif ( $ID eq 'TextArea' ) {
                    $IDText = 'Textarea';
                }
                else {
                    $IDText = $ID;
                }

                # check breadcrumb on Add screen
                $CheckBredcrumb->(
                    OverviewTitle  => $OverviewTitleBreadcrumb,
                    BreadcrumbText => $LanguageObject->Translate($Type) . ': '
                        . $LanguageObject->Translate( 'Add ' . $IDText . ' Field' )
                );

                $Selenium->find_element( "#Name",  'css' )->send_keys($RandomID);
                $Selenium->find_element( "#Label", 'css' )->send_keys($RandomID);
                $Selenium->execute_script("\$('#ValidID').val('1').trigger('redraw.InputField').trigger('change');");
                $Selenium->find_element( "#Name", 'css' )->VerifiedSubmit();

                # check if test DynamicField show on AdminDynamicField screen
                $Self->True(
                    index( $Selenium->get_page_source(), $RandomID ) > -1,
                    "$RandomID $ID $Type DynamicField found on page",
                );

                # go to new DynamicField again
                $Selenium->find_element( $RandomID, 'link_text' )->VerifiedClick();

                # check breadcrumb on Edit screen
                $CheckBredcrumb->(
                    OverviewTitle => $OverviewTitleBreadcrumb,
                    BreadcrumbText =>
                        $LanguageObject->Translate($Type)
                        . ': '
                        . $LanguageObject->Translate( 'Change ' . $IDText . ' Field' ) . ' - '
                        . $RandomID
                );

                $Selenium->find_element( "#Label", 'css' )->clear();
                $Selenium->find_element( "#Label", 'css' )->send_keys( $RandomID . "-update" );
                $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");
                $Selenium->find_element( "#Name", 'css' )->VerifiedSubmit();

                # check class of invalid DynamicField in the overview table
                $Self->True(
                    $Selenium->execute_script(
                        "return \$('tr.Invalid td a:contains($RandomID)').length"
                    ),
                    "There is a class 'Invalid' for test DynamicField",
                );

                # go to new DynamicField again after update and check values
                $Selenium->find_element( $RandomID, 'link_text' )->VerifiedClick();

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

                $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminDynamicField");

                # delete DynamicFields, check button for deleting Dynamic Field
                my $DynamicFieldID = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
                    Name => $RandomID
                )->{ID};

                # click on delete icon
                my $CheckConfirmJSBlock = <<"JAVASCRIPT";
(function () {
    var lastConfirm = undefined;
    window.confirm = function (message) {
        lastConfirm = message;
        return false; // stop procedure at first try
    };
    window.getLastConfirm = function () {
        var result = lastConfirm;
        lastConfirm = undefined;
        return result;
    };
}());
JAVASCRIPT
                $Selenium->execute_script($CheckConfirmJSBlock);

                $Selenium->find_element(
                    "//a[contains(\@data-query-string, \'Subaction=DynamicFieldDelete;ID=$DynamicFieldID' )]"
                )->VerifiedClick();

                $Self->Is(
                    $Selenium->execute_script("return window.getLastConfirm()"),
                    $LanguageObject->Translate(
                        'Do you really want to delete this dynamic field? ALL associated data will be LOST!'
                    ),
                    'Check for opened confirm text',
                );

                my $CheckConfirmJSProceed = <<"JAVASCRIPT";
(function () {
    var lastConfirm = undefined;
    window.confirm = function (message) {
        lastConfirm = message;
        return true; // allow procedure at second try
    };
    window.getLastConfirm = function () {
        var result = lastConfirm;
        lastConfirm = undefined;
        return result;
    };
}());
JAVASCRIPT
                $Selenium->execute_script($CheckConfirmJSProceed);

                $Selenium->find_element(
                    "//a[contains(\@data-query-string, \'Subaction=DynamicFieldDelete;ID=$DynamicFieldID' )]"
                )->VerifiedClick();

                # Wait for delete dialog to disappear.
                $Selenium->WaitFor(
                    JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length === 0;'
                );

                # navigate to AdminDynamicField screen
                $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminDynamicField");

                # check if dynamic filed is deleted
                my $Success;
                eval {
                    $Success = $Selenium->find_element( $RandomID, 'link_text' )->is_displayed();
                };

                $Self->False(
                    $Success,
                    "$RandomID dynamic field is deleted!",
                );

            }

            # make sure the cache is correct
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => "DynamicField" );
        }
    }
);

1;
