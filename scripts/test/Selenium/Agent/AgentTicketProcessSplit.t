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

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Set 'Linked Objects' widget to simple view.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'LinkObject::ViewMode',
            Value => 'Simple',
        );

        # Disable check email addresses.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Key   => 'Frontend::RichText',
            Value => 0,
        );

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        my @DeleteTicketIDs;

        # create a test ticket
        my $RandomID = $Helper->GetRandomID();
        my $TicketID = $TicketObject->TicketCreate(
            Title        => "Ticket$RandomID",
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'open',
            CustomerNo   => '123465',
            CustomerUser => 'customer@example.com',
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "Ticket is created - ID $TicketID",
        );

        push @DeleteTicketIDs, $TicketID;

        my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
            ChannelName => 'Phone',
        );

        my $ArticleID = $ArticleBackendObject->ArticleCreate(
            TicketID             => $TicketID,
            IsVisibleForCustomer => 1,
            SenderType           => 'agent',
            Subject              => 'Selenium subject test',
            Body                 => "Article",
            ContentType          => 'text/plain; charset=ISO-8859-15',
            HistoryType          => 'OwnerUpdate',
            HistoryComment       => 'Some free text!',
            UserID               => 1,
            NoAgentNotify        => 1,
        );
        $Self->True(
            $ArticleID,
            "ArticleCreate - ID $ArticleID",
        );

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
        my $ScriptAlias  = $ConfigObject->Get('ScriptAlias');

        # Navigate to AdminProcessManagement screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");

        # Import test Selenium Process.
        my $Location
            = $ConfigObject->Get('Home') . "/scripts/test/sample/ProcessManagement/CustomerTicketOverviewProcess.yml";
        $Selenium->find_element( "#FileUpload",                      'css' )->send_keys($Location);
        $Selenium->find_element( "#OverwriteExistingEntitiesImport", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && !\$('#OverwriteExistingEntitiesImport:checked').length"
        );
        $Selenium->find_element("//button[\@value='Upload process configuration'][\@type='submit']")->VerifiedClick();
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessSync' )]")->VerifiedClick();

        # We have to allow a 1 second delay for Apache2::Reload to pick up the changed Process cache.
        sleep 1;

        # Navigate to AgentTicketZoom screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID;");

        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Get Process list.
        my $ProcessObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process');
        my $List          = $ProcessObject->ProcessList(
            UseEntities => 1,
            UserID      => $TestUserID,
        );

        # Get Process entity.
        my %ListReverse = reverse %{$List};
        my $ProcessName = 'CustomerTicketOverviewProcess';

        my $Process = $ProcessObject->ProcessGet(
            EntityID => $ListReverse{$ProcessName},
            UserID   => $TestUserID,
        );

        # Click on the split action.
        $Selenium->find_element( '.SplitSelection', 'css' )->click();

        $Selenium->WaitForjQueryEventBound(
            CSSSelector => '#SplitSubmit',
        );

        # Change it to Process.
        $Selenium->InputFieldValueSet(
            Element => '#SplitSelection',
            Value   => 'ProcessTicket',
        );
        $Selenium->WaitFor(
            JavaScript => 'return $("#ProcessEntityID").length;'
        );

        # Change it to Process EntityID.
        $Selenium->InputFieldValueSet(
            Element => '#ProcessEntityID',
            Value   => $Process->{EntityID},
        );
        $Selenium->find_element( '#SplitSubmit', 'css' )->VerifiedClick();

        # Check if CustomerID read only field can be disabled. See bug#14412.
        # Disable CustomerID read only.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketProcess::CustomerIDReadOnly',
            Value => 0
        );

        $Selenium->VerifiedRefresh();

        # Check if customer user input is on create process screen.
        $Selenium->WaitFor(
            JavaScript => 'return $("#CustomerAutoComplete").length;'
        );

        my $RandomCustomerUser = 'RandomCustomerUser' . $Helper->GetRandomID();
        $Selenium->find_element( "#CustomerAutoComplete", 'css' )->clear();
        $Selenium->find_element( "#CustomerID",           'css' )->clear();
        $Selenium->find_element( "#CustomerAutoComplete", 'css' )->send_keys($RandomCustomerUser);
        $Selenium->find_element( "#CustomerID",           'css' )->send_keys($RandomCustomerUser);

        # Check if select button is enabled.
        $Self->Is(
            $Selenium->execute_script("return \$('#SelectionCustomerID').prop('disabled');"),
            0,
            "Button to select a other CustomerID is disabled",
        );

        $Selenium->find_element( "#CustomerAutoComplete", 'css' )->clear();
        $Selenium->find_element( "#CustomerID",           'css' )->clear();

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketProcess::CustomerIDReadOnly',
            Value => 1
        );

        $Selenium->VerifiedRefresh();

        # Check if customer user input is on create process screen.
        $Selenium->WaitFor(
            JavaScript => 'return $("#CustomerAutoComplete").length;'
        );

        # Create Process ticket without article.
        $Selenium->find_element( "#CustomerAutoComplete", 'css' )->send_keys('Huber');
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->VerifiedClick();

        # Remember created ticket, to delete the ticket at the end of the test.
        my @TicketID = split( 'TicketID=', $Selenium->get_current_url() );
        push @DeleteTicketIDs, $TicketID[1];

        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".AsBlock.LinkObjectLink").length;'
        );

        # Verify there is link to parent ticket.
        $Self->True(
            $Selenium->find_elements(
                "//a[contains(\@class, 'LinkObjectLink')][contains(\@href, 'Action=AgentTicketZoom;TicketID=$TicketID')]"
            ),
            "Link to parent ticket is found",
        );

        # Scroll down.
        $Selenium->execute_script(
            "\$('a.LinkObjectLink[href*=\"Action=AgentTicketZoom;TicketID=$TicketID\"]')[0].scrollIntoView(true);",
        );

        # Check if ticket split with customer created article is preselecting customer user from article. See bug#12956.
        # Create test customer company.
        my $TestCompany = 'Company' . $RandomID;
        my $CustomerID  = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanyAdd(
            CustomerID          => $TestCompany,
            CustomerCompanyName => $TestCompany,
            ValidID             => 1,
            UserID              => 1,
        );
        $Self->True(
            $CustomerID,
            "CustomerCompanyID $CustomerID is created",
        );

        # Create test customer user.
        my $TestUser      = 'CustomerUser' . $RandomID;
        my $TestUserEmail = "$TestUser\@example.com";
        my $CustomerUser  = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
            Source         => 'CustomerUser',
            UserFirstname  => $TestUser,
            UserLastname   => $TestUser,
            UserCustomerID => $CustomerID,
            UserLogin      => $TestUser,
            UserEmail      => $TestUserEmail,
            ValidID        => 1,
            UserID         => 1
        );
        $Self->True(
            $CustomerUser,
            "First CustomerUser $CustomerUser is created",
        );

        my $UserFormString = "\"$TestUser $TestUser\" <$TestUserEmail>";
        my $ArticleID2     = $ArticleBackendObject->ArticleCreate(
            TicketID             => $TicketID,
            IsVisibleForCustomer => 0,
            SenderType           => 'customer',
            From                 => $UserFormString,
            To                   => 'Some Agent <otrs@example.com>',
            Subject              => 'some short description',
            Body                 => 'the message text',
            Charset              => 'utf8',
            MimeType             => 'text/plain',
            HistoryType          => 'OwnerUpdate',
            HistoryComment       => 'Some free text!',
            UserID               => 1,
        );
        $Self->True(
            $ArticleID2,
            "Second article created."
        );

        # Go to linked Ticket.
        $Selenium->find_element(
            "//a[contains(\@class, 'LinkObjectLink')][contains(\@href, 'Action=AgentTicketZoom;TicketID=$TicketID' )]"
        )->VerifiedClick();

        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".AsBlock.LinkObjectLink").length;'
        );

        # Verify there is link to child ticket.
        $Self->True(
            $Selenium->find_elements(
                "//a[contains(\@class, 'LinkObjectLink')][contains(\@href, 'Action=AgentTicketZoom;TicketID=$TicketID[1]')]"
            ),
            "Link to child ticket is found",
        );

        # Click on the split action.
        $Selenium->find_element( '.SplitSelection', 'css' )->click();

        $Selenium->WaitForjQueryEventBound(
            CSSSelector => '#SplitSubmit',
        );

        # Change it to Process.
        $Selenium->InputFieldValueSet(
            Element => '#SplitSelection',
            Value   => 'ProcessTicket',
        );
        $Selenium->WaitFor(
            JavaScript => 'return $("#ProcessEntityID").length;'
        );

        # Change it to Process EntityID.
        $Selenium->InputFieldValueSet(
            Element => '#ProcessEntityID',
            Value   => $Process->{EntityID},
        );
        $Selenium->find_element( '#SplitSubmit', 'css' )->VerifiedClick();

        $Selenium->WaitFor(
            JavaScript => 'return $("#CustomerAutoComplete").length;'
        );

        # Check if correct user is selected after process ticket split.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#CustomerAutoComplete').val().trim();"
            ),
            $UserFormString,
            "Preselected customer user is correct"
        );

        # Navigate to AgentTicketProcess screen. Test bug#14758.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketProcess");

        $Selenium->InputFieldValueSet(
            Element => '#ProcessEntityID',
            Value   => $ListReverse{$ProcessName},
        );

        $Selenium->WaitFor(
            ElementExists => "//input[contains(\@name,'CustomerUserID')]"
        );

        # Verify form is loaded.
        $Self->True(
            $Selenium->execute_script(
                "return \$('#CustomerAutoComplete').length;"
            ),
            "Customer field is available."
        ) || die;

        my $Success;
        for my $TicketID (@DeleteTicketIDs) {

            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => $TestUserID,
            );

            # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
            if ( !$Success ) {
                sleep 3;
                $Success = $TicketObject->TicketDelete(
                    TicketID => $TicketID,
                    UserID   => $TestUserID,
                );
            }
            $Self->True(
                $Success,
                "TicketID $TicketID is deleted",
            );
        }

        # Clean up activities.
        my $ActivityObject       = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Activity');
        my $ActivityDialogObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::ActivityDialog');
        for my $Item ( @{ $Process->{Activities} } ) {
            my $Activity = $ActivityObject->ActivityGet(
                EntityID            => $Item,
                UserID              => $TestUserID,
                ActivityDialogNames => 0,
            );

            # Clean up activity dialogs.
            for my $ActivityDialogItem ( @{ $Activity->{ActivityDialogs} } ) {
                my $ActivityDialog = $ActivityDialogObject->ActivityDialogGet(
                    EntityID => $ActivityDialogItem,
                    UserID   => $TestUserID,
                );

                # Delete test activity dialog.
                $Success = $ActivityDialogObject->ActivityDialogDelete(
                    ID     => $ActivityDialog->{ID},
                    UserID => $TestUserID,
                );
                $Self->True(
                    $Success,
                    "ActivityDialog $ActivityDialog->{Name} is deleted",
                );
            }

            # Delete test activity.
            $Success = $ActivityObject->ActivityDelete(
                ID     => $Activity->{ID},
                UserID => $TestUserID,
            );

            $Self->True(
                $Success,
                "Activity $Activity->{Name} is deleted",
            );
        }

        # Clean up transition actions
        my $TransitionActionsObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::TransitionAction');
        for my $Item ( @{ $Process->{TransitionActions} } ) {
            my $TransitionAction = $TransitionActionsObject->TransitionActionGet(
                EntityID => $Item,
                UserID   => $TestUserID,
            );

            # Delete test transition action.
            $Success = $TransitionActionsObject->TransitionActionDelete(
                ID     => $TransitionAction->{ID},
                UserID => $TestUserID,
            );

            $Self->True(
                $Success,
                "TransitionAction $TransitionAction->{Name} is deleted",
            );
        }

        # Clean up transition.
        my $TransitionObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Transition');
        for my $Item ( @{ $Process->{Transitions} } ) {
            my $Transition = $TransitionObject->TransitionGet(
                EntityID => $Item,
                UserID   => $TestUserID,
            );

            # Delete test transition.
            $Success = $TransitionObject->TransitionDelete(
                ID     => $Transition->{ID},
                UserID => $TestUserID,
            );

            $Self->True(
                $Success,
                "Transition $Transition->{Name} is deleted",
            );
        }

        # Delete created test customer users.
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM customer_user WHERE login = ?",
            Bind => [ \$CustomerUser ],
        );
        $Self->True(
            $Success,
            "Customer user $CustomerUser is deleted",
        );

        # Delete created customer company.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM customer_company WHERE customer_id = ?",
            Bind => [ \$CustomerID ],
        );
        $Self->True(
            $Success,
            "CustomerCompany $CustomerID is deleted.",
        );

        # Delete test Process.
        $Success = $ProcessObject->ProcessDelete(
            ID     => $Process->{ID},
            UserID => $TestUserID,
        );
        $Self->True(
            $Success,
            "Process $Process->{Name} is deleted",
        );

    },
);

1;
