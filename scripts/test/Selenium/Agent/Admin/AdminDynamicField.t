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

use Kernel::Language;

# Get selenium object.
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # Get needed objects.
        my $Helper             = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
        my $CacheObject        = $Kernel::OM->Get('Kernel::System::Cache');

        my %DynamicFieldsOverviewPageShownSysConfig = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemGet(
            Name => 'PreferencesGroups###DynamicFieldsOverviewPageShown',
        );

        %DynamicFieldsOverviewPageShownSysConfig = map { $_->{Key} => $_->{Content} }
            grep { defined $_->{Key} } @{ $DynamicFieldsOverviewPageShownSysConfig{Setting}->[1]->{Hash}->[1]->{Item} };

        # Set values for later settings.
        $DynamicFieldsOverviewPageShownSysConfig{Data} = {
            '10'  => '10',
            '15'  => '15',
            '20'  => '20',
            '25'  => '25',
            '30'  => '30',
            '999' => '999',
        };

        # Show more dynamic fields per page as the default value.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'PreferencesGroups###DynamicFieldsOverviewPageShown',
            Value => {
                %DynamicFieldsOverviewPageShownSysConfig,
                DataSelected => 999,
            },
        );

        # Create test user and login.
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

        # Get script alias.
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AdminDynamiFied screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminDynamicField");

        # Check overview AdminDynamicField.
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Check page.
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

                # Create a real test DynamicField.
                my $RandomID = $Helper->GetRandomID();
                $Selenium->execute_script(
                    "\$('#$ObjectType').val('$ID').trigger('redraw.InputField').trigger('change');"
                );

                # Wait until page has finished loading.
                $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Name").length' );

                $Selenium->find_element( "#Name",  'css' )->send_keys($RandomID);
                $Selenium->find_element( "#Label", 'css' )->send_keys($RandomID);
                $Selenium->execute_script("\$('#ValidID').val('1').trigger('redraw.InputField').trigger('change');");
                $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

                # Check if test DynamicField show on AdminDynamicField screen.
                $Self->True(
                    index( $Selenium->get_page_source(), $RandomID ) > -1,
                    "$RandomID $ID $Type DynamicField found on page",
                );

                # Go to new DynamicField again.
                $Selenium->find_element( $RandomID, 'link_text' )->VerifiedClick();
                $Selenium->find_element( "#Label",  'css' )->clear();
                $Selenium->find_element( "#Label",  'css' )->send_keys( $RandomID . "-update" );
                $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");
                $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

                # Check class of invalid DynamicField in the overview table.
                $Self->True(
                    $Selenium->execute_script(
                        "return \$('tr.Invalid td a:contains($RandomID)').length"
                    ),
                    "There is a class 'Invalid' for test DynamicField",
                );

                # Go to new DynamicField again after update and check values.
                $Selenium->find_element( $RandomID, 'link_text' )->VerifiedClick();

                # Check new DynamicField values.
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

                # Delete DynamicFields, check button for deleting Dynamic Field.
                my $DynamicFieldID = $DynamicFieldObject->DynamicFieldGet(
                    Name => $RandomID
                )->{ID};

                # Click on delete icon.
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

                # Navigate to AdminDynamicField screen.
                $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminDynamicField");

                # Check if dynamic filed is deleted.
                my $Success;
                eval {
                    $Success = $Selenium->find_element( $RandomID, 'link_text' )->is_displayed();
                };

                $Self->False(
                    $Success,
                    "$RandomID dynamic field is deleted!",
                );

            }

            # Make sure the cache is correct.
            $CacheObject->CleanUp( Type => "DynamicField" );
        }

        # Test MaxOrder default value.
        # It could not be matter from which page creation of dynamic field starts - default value of
        # field order must be always the first next number of all fields (see bug#10681).
        my $RandomNumber = $Helper->GetRandomNumber();
        my @TestDynamicFieldIDs;

        # Create some dynamic fields to be sure there will be more than one page.
        for my $Count ( 1 .. 11 ) {
            my $DynamicFieldID = $DynamicFieldObject->DynamicFieldAdd(
                Name       => 'Name' . $Count . $RandomNumber,
                Label      => 'Label' . $Count . $RandomNumber,
                FieldType  => 'Text',
                FieldOrder => 10000,
                ObjectType => 'Ticket',
                Config     => {
                    Name        => 'TestName',
                    Description => 'Description for Dynamic Field.',
                },
                ValidID => 1,
                UserID  => 1,
            );
            $Self->True(
                $DynamicFieldID,
                "DynamicFieldID $DynamicFieldID is created",
            );
            push @TestDynamicFieldIDs, $DynamicFieldID;
        }

        # Navigate to AdminDynamiField screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminDynamicField");

        # Set 10 fields per page.
        $Selenium->find_element( "a#ShowContextSettingsDialog", 'css' )->VerifiedClick();
        $Selenium->execute_script(
            "\$('#AdminDynamicFieldsOverviewPageShown').val('10').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element( "#DialogButton1", 'css' )->VerifiedClick();

        # Get list of all dynamic fields for define MaxFieldOrder default value.
        my $DynamicFieldsList = $DynamicFieldObject->DynamicFieldList(
            Valid => 0,
        );
        my $MaxFieldOrder = scalar @{$DynamicFieldsList} + 1;

        # Click to create 'Text' type ticket dynamic field from the first page.
        $Selenium->execute_script(
            "\$('#TicketDynamicField').val('Text').trigger('redraw.InputField').trigger('change');"
        );

        # Wait until page has finished loading.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Name").length' );

        # Check FieldOrder default value.
        $Self->Is(
            $Selenium->execute_script("return \$('#FieldOrder').val()"),
            $MaxFieldOrder,
            "MaxFieldOrder default value ($MaxFieldOrder) is correct",
        );

        # Navigate to AdminDynamiField screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminDynamicField");

        # Go to the second page
        $Selenium->find_element( '#AdminDynamicFieldPage2', 'css' )->VerifiedClick();

        # Click to create 'Text' type ticket dynamic field from the second page.
        $Selenium->execute_script(
            "\$('#TicketDynamicField').val('Text').trigger('redraw.InputField').trigger('change');"
        );

        # Wait until page has finished loading.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Name").length' );

        # Check FieldOrder default value.
        $Self->Is(
            $Selenium->execute_script("return \$('#FieldOrder').val()"),
            $MaxFieldOrder,
            "MaxFieldOrder default value ($MaxFieldOrder) is correct",
        );

        # Delete created test dynamic fields.
        for my $TestDynamicFieldID (@TestDynamicFieldIDs) {
            my $Success = $DynamicFieldObject->DynamicFieldDelete(
                ID     => $TestDynamicFieldID,
                UserID => 1,
            );
            $Self->True(
                $Success,
                "DynamicFieldID $TestDynamicFieldID is deleted",
            );
        }

        # Make sure the cache is correct.
        $CacheObject->CleanUp( Type => "DynamicField" );
    }
);

1;
