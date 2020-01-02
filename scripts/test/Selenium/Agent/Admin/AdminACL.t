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

use Selenium::Remote::WDKeys;
use Kernel::Language;

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper      = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');
        my $DBObject    = $Kernel::OM->Get('Kernel::System::DB');

        # Defined user language for testing if message is being translated correctly.
        my $Language = "de";

        $Helper->ConfigSettingChange(
            Valid => 0,
            Key   => 'Ticket::Frontend::AgentTicketNote###DynamicField',
            Value => 0
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketNote###Queue',
            Value => 0
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketNote###QueueMandatory',
            Value => 0
        );

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );

        # Delete ACL if are any.
        my $ACLObject = $Kernel::OM->Get('Kernel::System::ACL::DB::ACL');
        my $List      = $ACLObject->ACLListGet(
            UserID   => 1,
            ValidIDs => [ '1', '2' ],
        );
        for my $ItemACL ( @{$List} ) {
            if ( $ItemACL->{Name} ) {
                my $Success = $ACLObject->ACLDelete(
                    ID     => $ItemACL->{ID},
                    UserID => 1,
                );
                $Self->True(
                    $Success,
                    "ACL $ItemACL->{Name} is deleted",
                );
            }
        }

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups   => [ 'admin', 'users' ],
            Language => $Language,
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $Language,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AdminACL screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL");

        # Check breadcrumb on Overview screen.
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # Click 'Create new ACL' link.
        $Selenium->find_element( "a.Create", 'css' )->VerifiedClick();

        # Check add page.
        for my $ID (
            qw(Name Comment Description StopAfterMatch ValidID)
            )
        {
            $Selenium->WaitFor(
                JavaScript => "return typeof(\$) === 'function' && \$('#$ID').length;"
            );
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Check breadcrumb on Create New screen.
        my $Count = 1;
        my $IsLinkedBreadcrumbText;
        my $SecondBreadcrumbText = $LanguageObject->Translate('ACL Management');
        my $ThirdBreadcrumbText  = $LanguageObject->Translate('Create New ACL');
        for my $BreadcrumbText ( $SecondBreadcrumbText, $ThirdBreadcrumbText ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim();"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # Check client side validation.
        my $Element = $Selenium->find_element( "#Name", 'css' );
        $Element->send_keys("");

        $Selenium->find_element( "#Submit", 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return \$('#Name.Error').length;" );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Name').hasClass('Error');"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        my @TestACLNames;

        # Create test ACL names.
        for my $Name (qw(ACL NewACL)) {
            my $TestACLName = $Name . $Helper->GetRandomNumber() . ' $ @';
            push @TestACLNames, $TestACLName;
        }

        # Test for Bug#14411, 300 is more than the allowed by the filed (200), exceeding characters
        #   are just not typed.
        my $Description = 'a' x 300;

        # Fill in test data.
        $Selenium->find_element( "#Name",           'css' )->send_keys( $TestACLNames[0] );
        $Selenium->find_element( "#Comment",        'css' )->send_keys('Selenium Test ACL');
        $Selenium->find_element( "#Description",    'css' )->send_keys($Description);
        $Selenium->find_element( "#StopAfterMatch", 'css' )->click();
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 1,
        );
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # Check breadcrumb on Edit screen.
        $Count = 1;
        for my $BreadcrumbText (
            $SecondBreadcrumbText,
            $LanguageObject->Translate('Edit ACL') . ': ' . $TestACLNames[0]
            )
        {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim();"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # The next screen should be the edit screen for this ACL
        # which means that there should be modernize fields present for Match/Change settings.
        $Self->Is(
            $Selenium->find_element( '#ItemAddLevel1Match_Search', 'css' )->is_displayed(),
            '1',
            'Check if modernize Match element is present as expected',
        );
        $Self->Is(
            $Selenium->find_element( '#ItemAddLevel1Change_Search', 'css' )->is_displayed(),
            '1',
            'Check if modernize Change element is present as expected',
        );

        # Check for the correct values.
        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $TestACLNames[0],
            "#Name stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            'Selenium Test ACL',
            "#Comment stored value",
        );

        # Test for Bug#14411 (only 200 out of 300 characters should be stored).
        my $StoredDescription = 'a' x 200;
        $Self->Is(
            $Selenium->find_element( '#Description', 'css' )->get_value(),
            $StoredDescription,
            "#Description stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#StopAfterMatch', 'css' )->get_value(),
            '1',
            "#StopAfterMatch stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            '1',
            "#ValidID stored value",
        );

        # Now lets play around with the match & change settings.
        $Selenium->execute_script(
            "\$('#ACLMatch').siblings('.ItemAddLevel1').val('Properties').trigger('redraw.InputField').trigger('change');"
        );

        # Wait until selection tree is closed.
        $Selenium->WaitFor(
            ElementMissing => [ '.InputField_ListContainer', 'css' ],
        );

        # After clicking an ItemAddLevel1 element, there should be now a new .ItemAdd element.
        $Self->Is(
            $Selenium->find_element( '#ACLMatch #Properties_Search', 'css' )->is_displayed(),
            '1',
            'Check for .ItemAdd element - modernize element #Properties_Search is visible',
        );

        my $CheckAlertJS = <<"JAVASCRIPT";
(function () {
    var lastAlert = undefined;
    window.alert = function (message) {
        lastAlert = message;
    };
    window.getLastAlert = function () {
        var result = lastAlert;
        lastAlert = undefined;
        return result;
    };
}());
JAVASCRIPT

        $Selenium->execute_script($CheckAlertJS);

        # Now we should not be able to add the same element again, an alert box should appear.
        $Selenium->execute_script(
            "\$('#ACLMatch').siblings('.ItemAddLevel1').val('Properties').trigger('redraw.InputField').trigger('change');"
        );

        # Wait until selection tree is closed.
        $Selenium->WaitFor(
            ElementMissing => [ '.InputField_ListContainer', 'css' ],
        );

        $Self->Is(
            $Selenium->execute_script("return window.getLastAlert();"),
            $LanguageObject->Translate('An item with this name is already present.'),
            'Check for opened alert text',
        );

        # Now lets add the CustomerUser element on level 2.
        $Selenium->InputFieldValueSet(
            Element => '#ACLMatch .ItemAdd',
            Value   => 'CustomerUser',
        );

        # Now there should be a new .DataItem element with an input element.
        $Self->Is(
            $Selenium->find_element( '#ACLMatch .DataItem .NewDataKey', 'css' )->is_displayed(),
            '1',
            'Check for .NewDataKey element',
        );

        # Type in some text & confirm by pressing 'enter', which should produce a new field.
        $Selenium->find_element( '#ACLMatch .DataItem .NewDataKey', 'css' )->send_keys("<Test>\N{U+E007}");

        # Check if the text was escaped correctly.
        $Self->Is(
            $Selenium->execute_script("return \$('.DataItem .DataItem.Editable').data('content');"),
            '<Test>',
            'Check for correctly unescaped item content',
        );
        $Self->Is(
            $Selenium->execute_script("return \$('.DataItem .DataItem.Editable').find('span:not(.Icon)').html();"),
            '&lt;Test&gt;',
            'Check for correctly escaped item text',
        );

        # Now there should be a two new elements: .ItemPrefix and .NewDataItem.
        $Self->Is(
            $Selenium->find_element( '#ACLMatch .DataItem .ItemPrefix', 'css' )->is_displayed(),
            '1',
            'Check for .ItemPrefix element',
        );
        $Self->Is(
            $Selenium->find_element( '#ACLMatch .DataItem .NewDataItem', 'css' )->is_displayed(),
            '1',
            'Check for .NewDataItem element',
        );

        # Now lets add the DynamicField element on level 2, which should create a new modernize
        # element containing dynamic fields and an 'Add all' button.
        $Selenium->InputFieldValueSet(
            Element => '#ACLMatch .ItemAdd',
            Value   => 'DynamicField',
        );

        # Wait until element is shown.
        $Selenium->WaitFor(
            JavaScript => "return \$('#ACLMatch .DataItem .NewDataKeyDropdown').length;"
        );
        $Self->Is(
            $Selenium->execute_script("return \$('#ACLMatch .DataItem .NewDataKeyDropdown').length;"),
            '1',
            'Check for .NewDataKeyDropdown element',
        );

        # Wait until element is shown.
        $Selenium->WaitFor(
            JavaScript => "return \$('#ACLMatch .DataItem .AddAll').length;"
        );
        $Self->Is(
            $Selenium->execute_script("return \$('#ACLMatch .DataItem .AddAll').length;"),
            '1',
            'Check for .AddAll element',
        );

        # Add all possible prefix values to check for inputed values see bug#12854
        # ( https://bugs.otrs.org/show_bug.cgi?id=12854 ).
        $Count = 1;
        for my $Prefix ( '[Not]', '[RegExp]', '[regexp]', '[NotRegExp]', '[Notregexp]' ) {
            $Selenium->find_element( "#Prefixes option[Value='$Prefix']", 'css' )->click();
            $Selenium->find_element( ".NewDataItem",                      'css' )->send_keys('Test');
            $Selenium->find_element( ".AddDataItem",                      'css' )->click();
            $Self->Is(
                $Selenium->execute_script("return \$('ul li.Editable:eq($Count) span').text();"),
                $Prefix . 'Test',
                "Value with prefix $Prefix is correct"
            );
            $Selenium->find_element( ".AddDataItem", 'css' )->click();
            $Count++;
        }

        # Set ACL to invalid
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 2,
        );

        my @AclID1     = split( 'ID=', $Selenium->get_current_url() );
        my $ACLfirstID = $AclID1[1];

        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # Navigate to 'Create new ACL' screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL;Subaction=ACLNew");

        # Add new ACL.
        $Selenium->execute_script("\$('#Name').val('$TestACLNames[1]')");
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 2,
        );
        $Selenium->find_element( '#Name', 'css' )->send_keys("\N{U+E007}");

        # Wait until the new for has been loaded and the "normal" Save button shows up.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#SubmitAndContinue').length;" );
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete;'
        );

        my @AclID2      = split( 'ID=', $Selenium->get_current_url() );
        my $ACLSecondID = $AclID2[1];

        # Click 'Save and Finish'.
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # Check if both ACL exist in the table.
        $Self->IsNot(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($TestACLNames[0])').parent().parent().css('display');"
            ),
            'none',
            "ACL $TestACLNames[0] is found",
        );
        $Self->IsNot(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($TestACLNames[1])').parent().parent().css('display');"
            ),
            'none',
            "ACL $TestACLNames[1] is found",
        );

        # Insert name of second ACL into filter field.
        $Selenium->find_element( "#FilterACLs", 'css' )->clear();
        $Selenium->find_element( "#FilterACLs", 'css' )->send_keys( $TestACLNames[1] );

        sleep 1;

        # Check if the first ACL does not exist and second does in the table.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($TestACLNames[0])').parent().parent().css('display');"
            ),
            'none',
            "ACL $TestACLNames[0] is not found",
        );
        $Self->IsNot(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($TestACLNames[1])').parent().parent().css('display');"
            ),
            'none',
            "ACL $TestACLNames[1] is found",
        );

        # Refresh screen.
        $Selenium->VerifiedRefresh();

        # Create copy of the first ACL.
        my $ACLID = $ACLObject->ACLGet(
            Name   => $TestACLNames[0],
            UserID => 1,
        )->{ID};

        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('a[href*=\"Action=AdminACL;Subaction=ACLCopy;ID=$ACLID\"]').length;"
        );

        $Selenium->find_element("//a[contains(\@href, 'Action=AdminACL;Subaction=ACLCopy;ID=$ACLID;' )]")
            ->VerifiedClick();

        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('a[href*=\"Action=AdminACL;Subaction=ACLCopy;ID=$ACLID\"]').length;"
        );

        # Create another copy of the same ACL, see bug#13204 (https://bugs.otrs.org/show_bug.cgi?id=13204).
        $Selenium->find_element("//a[contains(\@href, 'Action=AdminACL;Subaction=ACLCopy;ID=$ACLID;' )]")
            ->VerifiedClick();

        # Verify there are both copied ACL's.
        push @TestACLNames,
            $LanguageObject->Translate( '%s (copy) %s', $TestACLNames[0], 1 ),
            $LanguageObject->Translate( '%s (copy) %s', $TestACLNames[0], 2 );

        $Self->True(
            index( $Selenium->get_page_source(), $TestACLNames[2] ) > -1,
            "First copied ACL '$TestACLNames[2]' found on screen",
        );
        $Self->True(
            index( $Selenium->get_page_source(), $TestACLNames[3] ) > -1,
            "Second copied ACL '$TestACLNames[3]' found on screen",
        );

        # Check if queue based acl works on AgentTicketNote. See bug#14504.
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
        $ConfigObject->Set(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        my $UserObject = $Kernel::OM->Get('Kernel::System::User');
        my $TestUserID = $UserObject->UserLookup( UserLogin => $TestUserLogin );

        # Create dynamic field.
        my $DynamicFieldObject     = $Kernel::OM->Get('Kernel::System::DynamicField');
        my $RandomID               = $Helper->GetRandomID();
        my $DynamicFieldName       = "Produkt$RandomID";
        my $DynamicFieldDropDownID = $DynamicFieldObject->DynamicFieldAdd(
            Name       => $DynamicFieldName,
            Label      => $DynamicFieldName,
            ValidID    => 1,
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            FieldOrder => 11,
            UserID     => 1,
            Config     => {
                PossibleValues => {
                    A => 'A',
                    B => 'B',
                    C => 'C'
                }
            },
        );
        $Self->True(
            $DynamicFieldDropDownID,
            "Dynamic dropdown field is created",
        );

        # Create test queue.
        my $QueueNameACL = "QueueACL$RandomID";
        my $QueueName    = "Queue$RandomID";
        my @QueueIDs;
        for my $Queue ( $QueueNameACL, $QueueName ) {
            my $QueueID = $QueueObject->QueueAdd(
                Name            => $Queue,
                ValidID         => 1,
                GroupID         => 1,
                SystemAddressID => 1,
                FollowUpID      => 1,
                SalutationID    => 1,
                SignatureID     => 1,
                Comment         => 'UnitTest queue',
                UserID          => 1,
            );
            $Self->True(
                $QueueID,
                "QueueID $QueueID is created",
            );
            push @QueueIDs, $QueueID;
        }

        # Set fields to AgentTicketNote screen.
        my $Success = $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketNote###DynamicField',
            Value => {
                $DynamicFieldName => 1,
            },
        );
        $Self->True(
            $Success,
            "'Ticket::Frontend::AgentTicketNote###DynamicField' is updated successfully",
        );

        $Success = $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketNote###Queue',
            Value => 1
        );
        $Self->True(
            $Success,
            "'Ticket::Frontend::AgentTicketNote###Queue' is updated successfully",
        );

        $Success = $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketNote###QueueMandatory',
            Value => 1
        );
        $Self->True(
            $Success,
            "'Ticket::Frontend::AgentTicketNote###QueueMandatory' is updated successfully",
        );

        # Update ACL, disable dynamic fields.
        $Success = $ACLObject->ACLUpdate(
            ID           => $ACLfirstID,
            Name         => $TestACLNames[0],
            Comment      => '',
            Description  => '',
            ConfigChange => {
                Possible    => {},
                PossibleNot => {
                    Ticket => {
                        "DynamicField_$DynamicFieldName" => [
                            '[RegExp].+'
                        ]
                    }
                }
            },
            ConfigMatch    => '',
            ValidID        => 1,
            StopAfterMatch => 0,
            UserID         => 1,
        );
        $Self->True(
            $Success,
            "ACLID $ACLfirstID updated",
        );

        # Update ACL, enable dynamic fields for specific queue.
        $Success = $ACLObject->ACLUpdate(
            ID             => $ACLSecondID,
            Name           => $TestACLNames[1],
            Description    => '',
            StopAfterMatch => 0,
            UserID         => 1,
            ValidID        => 1,
            Comment        => '',
            ConfigChange   => {
                Possible    => {},
                PossibleAdd => {
                    Ticket => {
                        "DynamicField_$DynamicFieldName" => [
                            'A',
                            'B',
                            'C'
                        ]
                    }
                }
            },
            ConfigMatch => {
                Properties => {
                    Ticket => {
                        Queue => [
                            $QueueNameACL,
                        ]
                    }
                }
            },

        );
        $Self->True(
            $Success,
            "ACLID $ACLSecondID updated",
        );

        # Create ticket with queue other then ACL queue.
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
        my $TicketID     = $TicketObject->TicketCreate(
            Title        => 'Some Ticket Title',
            QueueID      => $QueueIDs[1],
            Lock         => 'unlock',
            State        => 'open',
            Priority     => '3 normal',
            CustomerID   => "Customer#$RandomID",
            CustomerUser => "CustomerLogin#$RandomID",
            OwnerID      => $TestUserID,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "TicketID $TicketID is created",
        );

        $Selenium->VerifiedRefresh();

        # Deploy ACL.
        $Selenium->find_element("//a[contains(\@href, 'Action=AdminACL;Subaction=ACLDeploy' )]")->VerifiedClick();
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketNote;TicketID=$TicketID");

        # Select ACL queue.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#NewQueueID").length;' );
        $Selenium->InputFieldValueSet(
            Element => '#NewQueueID',
            Value   => $QueueIDs[0],
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length;' );
        $Selenium->find_element( "#Subject",  'css' )->send_keys("Some Subject");
        $Selenium->find_element( "#RichText", 'css' )->send_keys("Some Text");

        $Selenium->execute_script(
            "\$('#submitRichText')[0].scrollIntoView(true);",
        );
        $Self->True(
            $Selenium->execute_script(
                "return \$('#submitRichText').length;"
            ),
            "Element '#submitRichText' is found in screen"
        );
        $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick();

        # Check if AgentTicketHistory contains added note.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketHistory;TicketID=$TicketID");
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.DataTable td[title=AddNote]').length;"
            ),
            1,
            "Note is added"
        );

        # Delete test ACLs from the database.
        for my $TestACLName (@TestACLNames) {

            $ACLID = $ACLObject->ACLGet(
                Name   => $TestACLName,
                UserID => 1,
            )->{ID};

            $Success = $ACLObject->ACLDelete(
                ID     => $ACLID,
                UserID => 1,
            );
            $Self->True(
                $Success,
                "ACL $TestACLName is deleted",
            );
        }

        $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );

        # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
        if ( !$Success ) {
            sleep 3;
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => 1,
            );
        }
        $Self->True(
            $Success,
            "Deleted test ticket - $TicketID",
        );

        # Delete queues.
        for my $Item (@QueueIDs) {
            if ($Item) {
                my $Success = $DBObject->Do(
                    SQL => "DELETE FROM queue WHERE id = $Item",
                );
                $Self->True(
                    $Success,
                    "Queue with ID $Item is deleted!",
                );
            }
        }

        # Navigate to AdminACL screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL");

        # Sync ACL information from database with the system configuration.
        $Selenium->find_element("//a[contains(\@href, 'Action=AdminACL;Subaction=ACLDeploy' )]")->VerifiedClick();

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'ACLEditor_ACL',
        );
    }
);

1;
