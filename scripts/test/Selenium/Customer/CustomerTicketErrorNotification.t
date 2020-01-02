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
        my $Queue  = $Kernel::OM->Get('Kernel::System::Queue');
        my $Random = $Helper->GetRandomID();

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );

        # Do not check Service.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 0
        );

        # Do not check Type.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 0
        );

        # Disable queue selection.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::CustomerTicketMessage###Queue',
            Value => 0
        );

        # Enable customer group support.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CustomerGroupSupport',
            Value => 1
        );

        # Create test group.
        my $GroupName = 'Group' . $Random;
        my $GroupID   = $Kernel::OM->Get('Kernel::System::Group')->GroupAdd(
            Name    => $GroupName,
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $GroupID,
            "GroupID $GroupID is created.",
        );

        # Add test queue.
        my $QueueID = $Queue->QueueAdd(
            Name            => 'Queue' . $Random,
            ValidID         => 1,
            GroupID         => $GroupID,
            SystemAddressID => 1,
            SalutationID    => 1,
            SignatureID     => 1,
            Comment         => 'Selenium Queue',
            UserID          => 1,
        );
        $Self->True(
            $QueueID,
            "QueueID $QueueID is created.",
        );

        # Set test queue as default.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::CustomerTicketMessage###QueueDefault',
            Value => 'Queue' . $Random
        );

        # Create test customer user.
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        # Set user permissions to not include writing to test queue.
        my $Success = $Kernel::OM->Get('Kernel::System::CustomerGroup')->GroupMemberAdd(
            GID        => $GroupID,
            UID        => $TestCustomerUserLogin,
            Permission => {
                ro => 1,
                rw => 0,
            },
            UserID => 1,
        );
        $Self->True(
            $Success,
            "CustomerUser '$TestCustomerUserLogin' added to test group '$GroupName' with only 'ro' permission."
        );

        # Log in as the test customer user.
        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $TestCustomerUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to CustomerTicketMessage screen.
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketMessage");

        # Input fields and try to create ticket.
        $Selenium->find_element( "#Subject",        'css' )->send_keys('Subject');
        $Selenium->find_element( "#RichText",       'css' )->send_keys('Text');
        $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick();

        # Verify that there is an error.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('.MessageBox.Error').length;" );
        $Self->True(
            $Selenium->execute_script("return \$('.MessageBox.Error').length;"),
            "Error message appears on the top.",
        );
        $Self->True(
            $Selenium->execute_script(
                "return \$('.MessageBox.Error p:contains(\"You don\\'t have sufficient permissions for ticket creation in default queue\")').length;"
            ),
            "Error message text is correct.",
        );

        # Delete test queue.
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM queue WHERE id = ?",
            Bind => [ \$QueueID ],
        );
        $Self->True(
            $Success,
            "QueueID $QueueID is deleted.",
        );

        # Delete test group.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM group_customer_user WHERE group_id = ?",
            Bind => [ \$GroupID ],
        );
        $Self->True(
            $Success,
            "Group-CustomerUser relation for GroupID $GroupID is deleted.",
        );

        $Success = $DBObject->Do(
            SQL  => "DELETE FROM groups WHERE id = ?",
            Bind => [ \$GroupID ],
        );
        $Self->True(
            $Success,
            "GroupID $GroupID is deleted.",
        );

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure the cache is correct.
        for my $Cache (qw(CustomerGroup Group)) {
            $CacheObject->CleanUp(
                Type => $Cache,
            );
        }
    }
);

1;
