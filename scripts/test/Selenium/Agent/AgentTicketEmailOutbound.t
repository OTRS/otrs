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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get needed objects
        my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
        my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # disable check email addresses
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # do not check RichText
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );

        # do not check service and type
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 0
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 0
        );

        # create test user
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        # get test user ID
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # get needed variables
        my $RandomID = $Helper->GetRandomID();
        my $DFName   = 'DF' . $RandomID;

        # create a test dynamic field
        my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
            Name       => $DFName,
            Label      => 'TestDF',
            FieldOrder => 9991,
            FieldType  => 'Multiselect',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue   => '',
                PossibleNone   => '0',
                PossibleValues => {
                    Key1 => '1',
                    Key2 => '2',
                },
                TranslatableValues => '0',
                TreeView           => '0',
            },
            ValidID => 1,
            UserID  => $TestUserID,
        );

        # enable test dynamic field to show in AgentTicketEmailOutbound screen
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketEmailOutbound###DynamicField',
            Value => {
                $DFName => 1,
            },
        );

        # create test ticket
        my $TicketID = $TicketObject->TicketCreate(
            TN           => $TicketObject->TicketCreateNumber(),
            Title        => "Selenium Test Ticket",
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => 'SeleniumCustomer',
            CustomerUser => "SeleniumCustomer\@localhost.com",
            OwnerID      => $TestUserID,
            UserID       => $TestUserID,
        );
        $Self->True(
            $TicketID,
            "Ticket is created - $TicketID",
        );

        # add test customer for testing
        my $TestCustomer       = 'Customer' . $Helper->GetRandomID();
        my $TestCustomerUserID = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
            Source         => 'CustomerUser',
            UserFirstname  => $TestCustomer,
            UserLastname   => $TestCustomer,
            UserCustomerID => $TestCustomer,
            UserLogin      => $TestCustomer,
            UserEmail      => "$TestCustomer\@localhost.com",
            ValidID        => 1,
            UserID         => $TestUserID,
        );
        $Self->True(
            $TestCustomerUserID,
            "CustomerUserAdd - $TestCustomerUserID"
        );

        # login
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # navigate to AgentTicketEmailOutbound screen of created test ticket
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketEmailOutbound;TicketID=$TicketID");

        my $TestDynamicField = 'DynamicField_' . $DFName;
        my @Elements         = (
            'ToCustomer',
            'Subject',
            'RichText',
            'FileUpload',
            'ComposeStateID',
            'submitRichText',
            $TestDynamicField
        );

        # check page
        for my $ID (@Elements) {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        my $Message = 'Article subject will be empty if the subject contains only the ticket hook!';

        $Self->True(
            $Selenium->execute_script("return \$('.MessageBox.Notice:contains(\"$Message\")').length;"),
            "Notification about empty subject is found",
        );

        # get state ID for 'open' state
        my $StateObject = $Kernel::OM->Get('Kernel::System::State');
        my $StateID     = $StateObject->StateLookup(
            State => 'open',
        );

        # check update form with JS for dynamic field
        $Self->Is(
            $Selenium->execute_script("return \$('#AJAXLoaderDynamicField_$DFName').length"),
            0,
            "AJAX Loader for '$DFName' does not exist",
        );
        $Selenium->InputFieldValueSet(
            Element => '#ComposeStateID',
            Value   => $StateID,
        );

        # wait for appearance of ajax update field
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('#AJAXLoaderDynamicField_$DFName').length"
        );
        $Self->Is(
            $Selenium->execute_script("return \$('#AJAXLoaderDynamicField_$DFName').length"),
            1,
            "AJAX Loader for '$DFName' exists - JS function was run",
        );

        # fill in customer
        $Selenium->find_element( "#ToCustomer", 'css' )->send_keys($TestCustomer);

        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );

        $Selenium->execute_script("\$('li.ui-menu-item:contains($TestCustomer)').click()");
        $Selenium->find_element( "#Subject",        'css' )->send_keys("TestSubject");
        $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick();

        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#ArticleTree td.Direction i").hasClass("fa-long-arrow-right")'
        );

        # See the bug #13752
        $Self->True(
            $Selenium->execute_script("return \$('#ArticleTree td.Direction i').hasClass('fa-long-arrow-right')"),
            "There is right direction arrow",
        ) || die;

        # navigate to AgentTicketHistory of created test ticket
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketHistory;TicketID=$TicketID");

        # confirm email outbound action
        $Self->True(
            index( $Selenium->get_page_source(), 'Sent email to customer.' ) > -1,
            'Ticket email outbound completed'
        );

        # Check email sending multiplication (see bug#14694 - https://bugs.otrs.org/show_bug.cgi?id=14694).
        # Navigate to AgentTicketEmailOutbound screen of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketEmailOutbound;TicketID=$TicketID");

        my $Subject      = "TestSubject-$RandomID";
        my $EmailAddress = "$RandomID\@example.com";

        $Selenium->find_element( "#Subject",        'css' )->send_keys($Subject);
        $Selenium->find_element( "#ToCustomer",     'css' )->send_keys($EmailAddress);
        $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick();

        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#ArticleTable").length;' );

        # Verify that exactly one email is sent (one article is created).
        $Self->Is(
            $Selenium->execute_script("return \$('#ArticleTable tbody td.Subject:contains(\"$Subject\")').length;"),
            1,
            "Exactly one email is sent to '$EmailAddress' with subject '$Subject'",
        );

        # delete created test tickets
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => $TestUserID,
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
            "TicketID $TicketID is deleted",
        );

        # delete test created dynamic field
        $Success = $DynamicFieldObject->DynamicFieldDelete(
            ID     => $FieldID,
            UserID => $TestUserID,
        );
        $Self->True(
            $Success,
            "DynamicFieldID $FieldID is deleted",
        );

        # delete created test customer user
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        $TestCustomer = $DBObject->Quote($TestCustomer);
        $Success      = $DBObject->Do(
            SQL  => "DELETE FROM customer_user WHERE login = ?",
            Bind => [ \$TestCustomer ],
        );
        $Self->True(
            $Success,
            "CustomerUser $TestCustomer is deleted",
        );

        # make sure the cache is correct
        for my $Cache (qw(Ticket CustomerUser))
        {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }

    }
);

1;
