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

my $CheckBreadcrumb = sub {

    my %Param = @_;

    my $BreadcrumbText = $Param{BreadcrumbText} || '';
    my $Count          = 1;

    for my $BreadcrumbText ( 'System Email Addresses Management', $BreadcrumbText ) {
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

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Disable check email address.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        # Get test user ID.
        my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Add test Queue.
        my $QueueObject   = $Kernel::OM->Get('Kernel::System::Queue');
        my $QueueRandomID = "queue" . $Helper->GetRandomID();
        my $QueueID       = $QueueObject->QueueAdd(
            Name            => $QueueRandomID,
            ValidID         => 1,
            GroupID         => 1,
            SystemAddressID => 1,
            SalutationID    => 1,
            SignatureID     => 1,
            UserID          => $UserID,
            Comment         => 'Selenium Test Queue',
        );
        $Self->True(
            $QueueID,
            "Created Queue - $QueueRandomID",
        );

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AdminSystemAddress screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminSystemAddress");

        # Check overview AdminSystemAddress screen.
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Check breadcrumb on Overview screen.
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # Click 'Add system address'.
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminSystemAddress;Subaction=Add')]")->VerifiedClick();

        # Check add new SystemAddress screen.
        for my $ID (
            qw(Name Realname QueueID ValidID Comment)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Check breadcrumb on Add screen.
        $CheckBreadcrumb->( BreadcrumbText => 'Add System Email Address' );

        # Check client side validation.
        $Selenium->find_element( "#Name",   'css' )->clear();
        $Selenium->find_element( "#Submit", 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Name.Error').length" );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Name').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # Create real test SystemAddress.
        my $SysAddRandom  = 'sysadd' . $Helper->GetRandomID() . '@localhost.com';
        my $SysAddComment = "Selenium test SystemAddress";

        $Selenium->find_element( "#Name",     'css' )->send_keys($SysAddRandom);
        $Selenium->find_element( "#Realname", 'css' )->send_keys($SysAddRandom);
        $Selenium->InputFieldValueSet(
            Element => '#QueueID',
            Value   => $QueueID,
        );
        $Selenium->find_element( "#Comment", 'css' )->send_keys($SysAddComment);
        $Selenium->find_element( "#Submit",  'css' )->VerifiedClick();

        $Selenium->WaitFor(
            ElementExists => " //a[contains(.,'$SysAddRandom')]"
        );

        # Check for created test SystemAddress.
        $Self->True(
            index( $Selenium->get_page_source(), $SysAddRandom ) > -1,
            "$SysAddRandom found on page",
        );

        # Click 'Add system address'.
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminSystemAddress;Subaction=Add')]")->VerifiedClick();

        $Selenium->find_element( "#Name",     'css' )->send_keys($SysAddRandom);
        $Selenium->find_element( "#Realname", 'css' )->send_keys($SysAddRandom);
        $Selenium->InputFieldValueSet(
            Element => '#QueueID',
            Value   => $QueueID,
        );
        $Selenium->find_element( "#Comment", 'css' )->send_keys($SysAddComment);
        $Selenium->find_element( "#Submit",  'css' )->click();

        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".Dialog.Modal #DialogButton1").length'
        );
        $Selenium->find_element( "#DialogButton1", 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".Dialog.Modal").length' );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Name').hasClass('ServerError')"
            ),
            '1',
            'Client side validation correctly detected existing name error',
        );

        # Get created system address ID.
        my %SysAddList = $Kernel::OM->Get('Kernel::System::SystemAddress')->SystemAddressList(
            Valid => 1,
        );
        %SysAddList = reverse %SysAddList;

        my %QueueUpdateToTestAddress = (
            QueueID         => $QueueID,
            Name            => $QueueRandomID,
            ValidID         => 1,
            GroupID         => 1,
            SystemAddressID => $SysAddList{$SysAddRandom},
            SalutationID    => 1,
            SignatureID     => 1,
            UserID          => 1,
            FollowUpID      => 1,
            Comment         => 'Some Comment2',
            FollowUpLock    => 1
        );

        # Update queue with created test address.
        my $QueueUpdate = $QueueObject->QueueUpdate(
            %QueueUpdateToTestAddress,
        );
        $Self->True(
            $QueueUpdate,
            "QueueID $QueueID is updated with system address ID $SysAddList{$SysAddRandom}"
        );

        # Click 'Go to overview'.
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminSystemAddress')]")->VerifiedClick();

        # Go to the new test SystemAddress and check values.
        $Selenium->find_element( $SysAddRandom, 'link_text' )->VerifiedClick();
        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $SysAddRandom,
            "#Name stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#Realname', 'css' )->get_value(),
            $SysAddRandom,
            "#Realname stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#QueueID', 'css' )->get_value(),
            $QueueID,
            "#QueueID stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            1,
            "#ValidID stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            $SysAddComment,
            "#Comment stored value",
        );

        my $ErrorMessage
            = 'This system address cannot be set to invalid, because it is used in one or more queue(s) or auto response(s).';

        # Verify field explanation for valid field when system address is used in one or more queues or auto response.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#ValidID').parent().find('.FieldExplanation').text().trim()",
            ),
            $ErrorMessage,
            "Valid field explanation correct"
        );

        # Verify invalid options are not available as selection.
        $Self->False(
            $Selenium->execute_script(
                "return \$('#ValidID option[Value=2]').length"
            ),
            "Invalid options are disabled for system address which is used in queue."
        );

        my %QueueUpdateToDafaultAddress = (
            QueueID         => $QueueID,
            Name            => $QueueRandomID,
            ValidID         => 1,
            GroupID         => 1,
            SystemAddressID => 1,
            SalutationID    => 1,
            SignatureID     => 1,
            UserID          => 1,
            FollowUpID      => 1,
            Comment         => 'Some Comment2',
            FollowUpLock    => 1
        );

        # Update queue to the default system address.
        $QueueUpdate = $QueueObject->QueueUpdate(
            %QueueUpdateToDafaultAddress,
        );
        $Self->True(
            $QueueUpdate,
            "QueueID $QueueID is updated with system address ID $SysAddList{$SysAddRandom}"
        );

        # Check breadcrumb on Edit screen.
        $CheckBreadcrumb->( BreadcrumbText => 'Edit System Email Address: ' . $SysAddRandom );

        # Refresh screen.
        $Selenium->VerifiedRefresh();

        # Edit test SystemAddress and set it to invalid.
        $Selenium->find_element( "#Realname", 'css' )->send_keys(" Edited");
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 2,
        );
        $Selenium->find_element( "#Comment", 'css' )->clear();
        $Selenium->find_element( "#Submit",  'css' )->VerifiedClick();

        # Check class of invalid SystemAddress in the overview table.
        $Self->True(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($SysAddRandom)').length"
            ),
            "There is a class 'Invalid' for test SystemAddress",
        );

        # Check edited test SystemAddress values.
        $Selenium->find_element( $SysAddRandom, 'link_text' )->VerifiedClick();
        $Self->Is(
            $Selenium->find_element( '#Realname', 'css' )->get_value(),
            $SysAddRandom . " Edited",
            "#Realname updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            2,
            "#ValidID updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            "",
            "#Comment updated value",
        );

        # Check if is possible to set address used by auto responce to invalid, see bug#14243.
        # Set system address to valid.
        my $SystemAddressObject = $Kernel::OM->Get('Kernel::System::SystemAddress');
        $SystemAddressObject->SystemAddressUpdate(
            ID       => $SysAddList{$SysAddRandom},
            Name     => $SysAddRandom,
            Realname => $SysAddRandom,
            ValidID  => 1,
            QueueID  => $QueueID,
            Comment  => 'some comment',
            UserID   => 1,
        );

        my $AutoResponseObject   = $Kernel::OM->Get('Kernel::System::AutoResponse');
        my $AutoResponseNameRand = 'SystemAddress' . $Helper->GetRandomID();

        # Add auto response.
        my $AutoResponseID = $AutoResponseObject->AutoResponseAdd(
            Name        => $AutoResponseNameRand,
            Subject     => 'Some Subject - updated',
            Response    => 'Some Response - updated',
            Comment     => 'Some Comment - updated',
            AddressID   => $SysAddList{$SysAddRandom},
            TypeID      => 1,
            ContentType => 'text/plain',
            ValidID     => 1,
            UserID      => 1,
        );
        $Self->True(
            $AutoResponseID,
            "AutoResponseID $AutoResponseID is created",
        );

        # Refresh screen.
        $Selenium->VerifiedRefresh();

        # Verify field explanation for valid field when system address is used in one or more queues or auto response.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#ValidID').parent().find('.FieldExplanation').text().trim()",
            ),
            $ErrorMessage,
            "Valid field explanation correct"
        );

        my %AutoResponseToDefaultAddress = (
            ID          => $AutoResponseID,
            Name        => $AutoResponseNameRand,
            ValidID     => 1,
            Subject     => 'Some Subject',
            Response    => 'Auto Response Test',
            ContentType => 'text/plain',
            AddressID   => 1,
            TypeID      => 1,
            UserID      => 1
        );

        # Set auto response to default otrs address.
        my $Success = $AutoResponseObject->AutoResponseUpdate(
            %AutoResponseToDefaultAddress,
        );
        $Self->True(
            $Success,
            "AutoResponseID $AutoResponseID is set to invalid",
        );

        # Refresh screen.
        $Selenium->VerifiedRefresh();
        $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");

        # Set auto response to test address,
        # and check if will return server error if system address set invalid.
        $Success = $AutoResponseObject->AutoResponseUpdate(
            ID          => $AutoResponseID,
            Name        => $AutoResponseNameRand,
            ValidID     => 1,
            Subject     => 'Some Subject',
            Response    => 'Auto Response Test',
            ContentType => 'text/plain',
            AddressID   => $SysAddList{$SysAddRandom},
            TypeID      => 1,
            UserID      => 1,
        );
        $Self->True(
            $Success,
            "AutoResponseID $AutoResponseID is set to test address",
        );

        $Selenium->find_element( "#Submit", 'css' )->click();

        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length === 1;'
        );

        # Confirm JS error.
        $Selenium->find_element( "#DialogButton1", 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".Dialog.Modal").length' );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#ValidID').hasClass('ServerError')"
            ),
            '1',
            'Client side validation correctly detected existing name error',
        );

        # Verify field explanation for valid field when system address is used in one or more queues or auto response.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#ValidID').parent().find('.FieldExplanation').text().trim()",
            ),
            $ErrorMessage,
            "Valid field explanation correct"
        );

        $Selenium->find_element( "#Submit", 'css' )->click();

        # Set auto response to default otrs address.
        $Success = $AutoResponseObject->AutoResponseUpdate(
            %AutoResponseToDefaultAddress,
        );
        $Self->True(
            $Success,
            "AutoResponseID $AutoResponseID is set to default address",
        );

        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminSystemAddress;Subaction=Change;ID=$SysAddList{$SysAddRandom}"
        );

        # Update queue to the test system address.
        # and check if will return server error if system address is set to invalid.
        $QueueUpdate = $QueueObject->QueueUpdate(
            %QueueUpdateToTestAddress,
        );
        $Self->True(
            $QueueUpdate,
            "QueueID $QueueID is updated with system address ID $SysAddList{$SysAddRandom}"
        );

        $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Submit", 'css' )->click();

        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length === 1;'
        );

        # Confirm JS error.
        $Selenium->find_element( "#DialogButton1", 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".Dialog.Modal").length' );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#ValidID').hasClass('ServerError')"
            ),
            '1',
            'Client side validation correctly detected existing name error',
        );

        # Verify field explanation for valid field when system address is used in one or more queues or auto response.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#ValidID').parent().find('.FieldExplanation').text().trim()",
            ),
            $ErrorMessage,
            "Valid field explanation correct"
        );

        # Update queue to the default system address.
        $QueueUpdate = $QueueObject->QueueUpdate(
            %QueueUpdateToDafaultAddress,
        );
        $Self->True(
            $QueueUpdate,
            "QueueID $QueueID is updated with system address ID $SysAddList{$SysAddRandom}"
        );

        # Set auto response to invalid.
        $Success = $AutoResponseObject->AutoResponseUpdate(
            %AutoResponseToDefaultAddress,
            ValidID => 2,
        );
        $Self->True(
            $Success,
            "AutoResponseID $AutoResponseID is set to invalid",
        );

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Delete auto response.
        $Success = $DBObject->Do(
            SQL => "DELETE FROM auto_response WHERE id = $AutoResponseID",
        );
        $Self->True(
            $Success,
            "AutoResponseID $AutoResponseID is deleted",
        );

        # Since we no longer need them, delete test Queue and SystemAddress from the DB.
        $Success = $DBObject->Do(
            SQL => "DELETE FROM system_address WHERE value0 = \'$SysAddRandom\'",
        );
        $Self->True(
            $Success,
            "System address $SysAddRandom is deleted",
        );
        $Success = $DBObject->Do(
            SQL => "DELETE FROM queue WHERE id = \'$QueueID\'",
        );
        $Self->True(
            $Success,
            "QueueID $QueueRandomID is deleted",
        );

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure cache is correct.
        for my $Cache (qw(Queue SystemAddress)) {
            $CacheObject->CleanUp( Type => $Cache );
        }
    }
);

1;
