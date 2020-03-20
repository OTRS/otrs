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

use Kernel::Language;

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

my $CheckBredcrumb = sub {

    my %Param = @_;

    my $OverviewTitle  = $Param{OverviewTitle};
    my $BreadcrumbText = $Param{BreadcrumbText} || '';
    my $Count          = 1;

    for my $BreadcrumbText ( $OverviewTitle, $BreadcrumbText ) {
        $Self->Is(
            $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim();"),
            $BreadcrumbText,
            "Breadcrumb text '$BreadcrumbText' is found on screen"
        );

        $Count++;
    }
};

$Selenium->RunTest(
    sub {

        my $Helper             = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
        my $CacheObject        = $Kernel::OM->Get('Kernel::System::Cache');

        my %DynamicFieldsOverviewPageShownSysConfig = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet(
            Name => 'PreferencesGroups###DynamicFieldsOverviewPageShown',
        );

        # Show more dynamic fields per page as the default value.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'PreferencesGroups###DynamicFieldsOverviewPageShown',
            Value => {
                %{ $DynamicFieldsOverviewPageShownSysConfig{EffectiveValue} },
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

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AdminDynamiField screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminDynamicField");

        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $Language,
        );

        # Check overview AdminDynamicField.
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Check breadcrumb on Overview screen.
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        my $OTRSBusinessIsInstalled = $Kernel::OM->Get('Kernel::System::OTRSBusiness')->OTRSBusinessIsInstalled();
        my $OBTeaser                = $LanguageObject->Translate('More Business Fields');
        my $OBTeaserFound           = index( $Selenium->get_page_source(), $OBTeaser ) > -1;
        if ( !$OTRSBusinessIsInstalled ) {
            $Self->True(
                $OBTeaserFound,
                "OTRSBusiness teaser found on page",
            );
            for my $TeaserOption (qw(Database Webservice ContactWithData)) {
                $Selenium->find_element( "select#TicketDynamicField option[value=$TeaserOption]", 'css' );
            }

        }
        else {
            $Self->False(
                $OBTeaserFound,
                "OTRSBusiness teaser not found on page",
            );
        }

        # Define variables for breadcrumb.
        my $OverviewTitleBreadcrumb = $LanguageObject->Translate('Dynamic Fields Management');
        my $IDText;

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
                my $Element    = $Selenium->find_element( "#$ObjectType option[value=$ID]", 'css' );
                $Element->is_enabled();

                # Create a real test DynamicField.
                my $RandomID = $Helper->GetRandomID();
                $Selenium->InputFieldValueSet(
                    Element => "#$ObjectType",
                    Value   => $ID,
                );

                # Wait until page has finished loading.
                $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Name").length;' );

                # Modify names in two cases.
                if ( $ID eq 'DateTime' ) {
                    $IDText = 'Date / Time';
                }
                elsif ( $ID eq 'TextArea' ) {
                    $IDText = 'Textarea';
                }
                else {
                    $IDText = $ID;
                }

                # Check breadcrumb on Add screen.
                $CheckBredcrumb->(
                    OverviewTitle  => $OverviewTitleBreadcrumb,
                    BreadcrumbText => $LanguageObject->Translate($Type) . ': '
                        . $LanguageObject->Translate( 'Add %s field', $LanguageObject->Translate($IDText) )
                );

                $Selenium->find_element( "#Name",  'css' )->send_keys($RandomID);
                $Selenium->find_element( "#Label", 'css' )->send_keys($RandomID);
                $Selenium->InputFieldValueSet(
                    Element => '#ValidID',
                    Value   => 1,
                );

                # Submit form.
                $Selenium->execute_script(
                    "\$('#Submit')[0].scrollIntoView(true);",
                );
                $Self->True(
                    $Selenium->execute_script("return \$('#Submit').length;"),
                    "Element '#Submit' is found in screen"
                );
                $Selenium->find_element( '#Submit', 'css' )->VerifiedClick();

                $Selenium->WaitFor(
                    JavaScript =>
                        "return typeof(\$) === 'function' && \$('#DynamicFieldsTable tr:contains($RandomID)').length;"
                );

                # Check if test dynamic field is shown in AdminDynamicField screen.
                $Self->True(
                    $Selenium->execute_script("return \$('#DynamicFieldsTable tr:contains($RandomID)').length;"),
                    "$RandomID $ID $Type DynamicField found on page",
                );

                # Go to new dynamic field again.
                $Selenium->find_element( $RandomID, 'link_text' )->VerifiedClick();

                # Check breadcrumb on Edit screen.
                $CheckBredcrumb->(
                    OverviewTitle  => $OverviewTitleBreadcrumb,
                    BreadcrumbText => $LanguageObject->Translate($Type) . ': '
                        . $LanguageObject->Translate( 'Change %s field', $LanguageObject->Translate($IDText) ) . ' - '
                        . $RandomID
                );

                $Selenium->WaitFor(
                    JavaScript => "return typeof(\$) === 'function' && \$('#Label').length && \$('#ValidID').length;"
                );

                $Selenium->find_element( "#Label", 'css' )->clear();
                $Selenium->find_element( "#Label", 'css' )->send_keys( $RandomID . "-update" );
                $Selenium->InputFieldValueSet(
                    Element => '#ValidID',
                    Value   => 2,
                );

                # Submit form.
                $Selenium->execute_script(
                    "\$('#Submit')[0].scrollIntoView(true);",
                );
                $Self->True(
                    $Selenium->execute_script("return \$('#Submit').length;"),
                    "Element '#Submit' is found in screen"
                );
                $Selenium->find_element( '#Submit', 'css' )->VerifiedClick();

                $Selenium->WaitFor(
                    JavaScript =>
                        "return typeof(\$) === 'function' && \$('tr.Invalid td a:contains($RandomID)').length;"
                );

                # Check class of invalid dynamic field in the overview table.
                $Self->True(
                    $Selenium->execute_script(
                        "return \$('tr.Invalid td a:contains($RandomID)').length;"
                    ),
                    "There is a class 'Invalid' for test DynamicField",
                );

                # Go to new dynamic field again after update and check values.
                $Selenium->find_element( $RandomID, 'link_text' )->VerifiedClick();

                $Selenium->WaitFor(
                    JavaScript => "return typeof(\$) === 'function' && \$('#Name').length;"
                );

                # Check new dynamic field values.
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

                # Navigate to AdminDynamicField screen.
                $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminDynamicField");

                # Delete dynamic field.
                my $DynamicFieldID = $DynamicFieldObject->DynamicFieldGet(
                    Name => $RandomID
                )->{ID};

                $Selenium->find_element(
                    "//a[contains(\@data-query-string, \'Subaction=DynamicFieldDelete;ID=$DynamicFieldID' )]"
                )->click();

                $Selenium->WaitFor( AlertPresent => 1 );

                $Self->Is(
                    $Selenium->get_alert_text(),
                    $LanguageObject->Translate(
                        'Do you really want to delete this dynamic field? ALL associated data will be LOST!'
                    ),
                    'Check for open confirm text',
                );

                $Selenium->accept_alert();

                $Selenium->WaitFor(
                    JavaScript =>
                        "return typeof(\$) === 'function' && \$('#DynamicFieldID_$DynamicFieldID').length == 0;"
                );
                $Selenium->VerifiedRefresh();

                # Check if dynamic field is deleted.
                $Self->False(
                    $Selenium->execute_script(
                        "return \$('#DynamicFieldID_$DynamicFieldID').length;"
                    ),
                    "DynamicField ($Type-$ID) $RandomID is deleted",
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

        # Create some dynamic fields to be sure there will be at least two pages.
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

        $Selenium->WaitForjQueryEventBound(
            CSSSelector => "#ShowContextSettingsDialog",
        );

        # Set 10 fields per page.
        $Selenium->find_element( "a#ShowContextSettingsDialog", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => 'return $("#AdminDynamicFieldsOverviewPageShown").length && $("#DialogButton1").length;'
        );
        $Selenium->InputFieldValueSet(
            Element => '#AdminDynamicFieldsOverviewPageShown',
            Value   => 10,
        );

        $Selenium->find_element( "#DialogButton1", 'css' )->VerifiedClick();

        # Get list of all dynamic fields for define MaxFieldOrder default value.
        my $DynamicFieldsList = $DynamicFieldObject->DynamicFieldList(
            Valid => 0,
        );
        my $MaxFieldOrder = scalar @{$DynamicFieldsList} + 1;

        # Click to create 'Text' type ticket dynamic field from the first page.
        $Selenium->InputFieldValueSet(
            Element => '#TicketDynamicField',
            Value   => 'Text',
        );

        # Wait until page has finished loading.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Name").length;' );

        # Check FieldOrder default value.
        $Self->Is(
            $Selenium->execute_script("return \$('#FieldOrder').val();"),
            $MaxFieldOrder,
            "MaxFieldOrder default value ($MaxFieldOrder) is correct",
        );

        # Go back to AdminDynamiField screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminDynamicField");

        # Wait until page has finished loading.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#AdminDynamicFieldPage2").length;' );

        # Go to the second page.
        $Selenium->find_element( "#AdminDynamicFieldPage2", 'css' )->VerifiedClick();

        # Wait until page has finished loading.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#TicketDynamicField").length;' );

        # Click to create 'Text' type ticket dynamic field from the second page.
        $Selenium->InputFieldValueSet(
            Element => '#TicketDynamicField',
            Value   => 'Text',
        );

        # Wait until page has finished loading.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#FieldOrder").length;' );

        # Check FieldOrder default value.
        $Self->Is(
            $Selenium->execute_script("return \$('#FieldOrder').val();"),
            $MaxFieldOrder,
            "MaxFieldOrder default value ($MaxFieldOrder) is correct",
        );

        # Delete created test dynamic fields.
        for my $TestDynamicFieldID (@TestDynamicFieldIDs) {
            my $Success = $DynamicFieldObject->DynamicFieldDelete(
                ID     => $TestDynamicFieldID,
                UserID => 1,
            );

            # Dynamic field deletion could fail. Try again in this case.
            if ( !$Success ) {
                sleep 3;
                $Success = $DynamicFieldObject->DynamicFieldDelete(
                    ID     => $TestDynamicFieldID,
                    UserID => 1,
                );
            }

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
