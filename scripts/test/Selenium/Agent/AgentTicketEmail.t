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

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper             = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $SignatureObject    = $Kernel::OM->Get('Kernel::System::Signature');
        my $QueueObject        = $Kernel::OM->Get('Kernel::System::Queue');
        my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

        # Disable check email addresses.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0,
        );

        # Do not check service and type.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 0,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 0,
        );

        # Enable session management use html cookies.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SessionUseCookie',
            Value => 1,
        );

        # Define random test variable.
        my $RandomID = $Helper->GetRandomID();

        my @SignatureIDs;
        my @QueueIDs;
        my @QueueNames;
        my @CustomerUserIDs;
        my @TestData = (
            {
                SignatureName => 'Signature1' . $RandomID,
                SignatureText => 'Customer First Name: <OTRS_CUSTOMER_DATA_UserFirstname>',
                QueueName     => 'Queue1' . $RandomID,
                UserFirstName => 'FirstName1' . $RandomID,
                UserLastName  => 'LastName1' . $RandomID,
                UserLogin     => 'UserLogin1' . $RandomID,
            },
            {
                SignatureName => 'Signature2' . $RandomID,
                SignatureText => 'Customer Last Name: <OTRS_CUSTOMER_DATA_UserLastname>',
                QueueName     => 'Queue2' . $RandomID,
                UserFirstName => 'FirstName2' . $RandomID,
                UserLastName  => 'LastName2' . $RandomID,
                UserLogin     => 'UserLogin2' . $RandomID,
            },
        );

        for my $Data (@TestData) {
            my $SignatureID = $SignatureObject->SignatureAdd(
                Name        => $Data->{SignatureName},
                Text        => $Data->{SignatureText},
                ContentType => 'text/plain; charset=utf-8',
                Comment     => 'Selenium signature',
                ValidID     => 1,
                UserID      => 1,
            );
            $Self->True(
                $SignatureID,
                "SignatureID $SignatureID is created"
            );
            push @SignatureIDs, $SignatureID;

            my $QueueID = $QueueObject->QueueAdd(
                Name            => $Data->{QueueName},
                ValidID         => 1,
                GroupID         => 1,
                SystemAddressID => 1,
                SalutationID    => 1,
                SignatureID     => $SignatureID,
                Comment         => 'Selenium Queue',
                UserID          => 1,
            );
            $Self->True(
                $QueueID,
                "QueueID $QueueID is created"
            );
            push @QueueIDs,   $QueueID;
            push @QueueNames, $Data->{QueueName};

            my $CustomerUserID = $CustomerUserObject->CustomerUserAdd(
                Source         => 'CustomerUser',
                UserFirstname  => $Data->{UserFirstName},
                UserLastname   => $Data->{UserLastName},
                UserCustomerID => $Data->{UserLogin},
                UserLogin      => $Data->{UserLogin},
                UserEmail      => "$Data->{UserLogin}\@localhost.com",
                ValidID        => 1,
                UserID         => 1,
            );
            $Self->True(
                $CustomerUserID,
                "CustomerUserID $CustomerUserID is created"
            );
            push @CustomerUserIDs, $CustomerUserID;
        }

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentTicketEmail screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketEmail");

        # Check page.
        for my $ID (
            qw(Dest ToCustomer CcCustomer BccCustomer CustomerID RichText
            Signature FileUpload NextStateID PriorityID submitRichText)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Check client side validation.
        my $Element = $Selenium->find_element( "#Subject", 'css' );
        $Element->send_keys("");
        $Selenium->find_element( "#submitRichText", 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Subject.Error").length' );

        $Self->True(
            $Selenium->execute_script("return \$('#Subject.Error').length"),
            'Client side validation correctly detected missing input value',
        );

        # Navigate to AgentTicketEmail screen again.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketEmail");

        # Verify signature tags like <OTRS_CUSTOMER_DATA_*>, please see bug#12853 for more information.
        #   Select first queue.
        $Selenium->execute_script(
            "\$('#Dest').val(\$('#Dest option').filter(function () { return \$(this).html() == '$QueueNames[0]'; } ).val() ).trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length' );

        # There is no selected customer, should be no replaced tags in signature.
        my $SignatureText = "Customer First Name: -";
        $Self->Is(
            $Selenium->execute_script('return $("#Signature").val()'),
            $SignatureText,
            "Signature is found with no replaced tags"
        );

        # Select customer user.
        $Selenium->find_element( "#ToCustomer", 'css' )->clear();
        $Selenium->find_element( "#ToCustomer", 'css' )->send_keys( $TestData[0]->{UserLogin} );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($TestData[0]->{UserLogin})').click()");
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#CustomerSelected_1").length && !$(".AJAXLoader:visible").length'
        );

        $SignatureText = "Customer First Name: $TestData[0]->{UserFirstName}";
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#Signature').val().indexOf('$SignatureText') !== -1;"
        );

        # Input subject data.
        my $TicketSubject = "Selenium Ticket";
        $Selenium->find_element( "#Subject", 'css' )->clear();
        $Selenium->find_element( "#Subject", 'css' )->send_keys($TicketSubject);

        # Queue and customer are selected, signature has replaced tags.
        $Self->Is(
            $Selenium->execute_script('return $("#Signature").val()'),
            $SignatureText,
            "Signature is found with replaced tags on selected customer"
        );

        # Change queue, trigger new signature.
        $Selenium->execute_script(
            "\$('#Dest').val(\$('#Dest option').filter(function () { return \$(this).html() == '$QueueNames[1]'; } ).val() ).trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length' );

        # Queue is changed, verify signature change with replaced tags.
        $SignatureText = "Customer Last Name: $TestData[0]->{UserLastName}";
        $Self->Is(
            $Selenium->execute_script('return $("#Signature").val()'),
            $SignatureText,
            "Signature is found with replaced tags on queue change"
        );

        # Add new customer in 'To'.
        $Selenium->find_element( "#ToCustomer", 'css' )->clear();
        $Selenium->find_element( "#ToCustomer", 'css' )->send_keys( $TestData[1]->{UserLogin} );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($TestData[1]->{UserLogin})').click()");

        # Change selected customer, trigger replacement tag in signature.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#CustomerSelected_2").length' );
        $Selenium->find_element( "#CustomerSelected_2", 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length' );

        $SignatureText = "Customer Last Name: $TestData[1]->{UserLastName}";
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#Signature').val().indexOf('$SignatureText') !== -1;"
        );

        # Input body data.
        my $TicketBody = "Selenium body test";
        $Selenium->find_element( "#RichText", 'css' )->clear();
        $Selenium->find_element( "#RichText", 'css' )->send_keys($TicketBody);

        # Selected customer is changed, signature replaced tags are changed.
        $Self->Is(
            $Selenium->execute_script('return $("#Signature").val()'),
            $SignatureText,
            "Signature is found with replaced tags on selected customer change"
        );

        # Submit form.
        $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick();

        # Get created test ticket data.
        my %TicketIDs = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSearch(
            Result         => 'HASH',
            Limit          => 1,
            CustomerUserID => $TestData[1]->{UserLogin},
        );
        my $TicketNumber = (%TicketIDs)[1];
        my $TicketID     = (%TicketIDs)[0];

        $Self->True(
            $TicketID,
            "Ticket was created and found - $TicketID",
        ) || die;

        $Self->True(
            $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketZoom;TicketID=$TicketID' )]"),
            "Ticket with ticket number $TicketNumber is created",
        );

        # Go to ticket zoom page of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Check if test ticket values are genuine.
        $Self->True(
            index( $Selenium->get_page_source(), $TicketSubject ) > -1,
            "$TicketSubject found on page",
        ) || die "$TicketSubject not found on page";
        $Self->True(
            index( $Selenium->get_page_source(), $TicketBody ) > -1,
            "$TicketBody found on page",
        ) || die "$TicketBody not found on page";
        $Self->True(
            index( $Selenium->get_page_source(), $TestData[1]->{UserLogin} ) > -1,
            "$TestData[1]->{UserLogin} found on page",
        ) || die "$TestData[1]->{UserLogin} not found on page";
        $Self->True(
            index( $Selenium->get_page_source(), $SignatureText ) > -1,
            "Signature found on page"
        ) || die "$SignatureText not found on page";

        # Disable session management use html cookies to check signature update (see bug#12890).
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SessionUseCookie',
            Value => 0,
        );

        # Navigate to AgentTicketEmail screen and login because there is no session cookies.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketEmail");
        $Selenium->find_element( "#User",        'css' )->send_keys($TestUserLogin);
        $Selenium->find_element( "#Password",    'css' )->send_keys($TestUserLogin);
        $Selenium->find_element( "#LoginButton", 'css' )->VerifiedClick();

        $Selenium->execute_script(
            "\$('#Dest').val(\$('#Dest option').filter(function () { return \$(this).html() == '$QueueNames[0]'; } ).val() ).trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length' );

        # Select customer user.
        $Selenium->find_element( "#ToCustomer", 'css' )->send_keys( $TestData[0]->{UserLogin} );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($TestData[0]->{UserLogin})').click()");
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#CustomerSelected_1").length && !$(".AJAXLoader:visible").length'
        );

        $SignatureText = "Customer First Name: $TestData[0]->{UserFirstName}";
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#Signature').val().indexOf('$SignatureText') !== -1;"
        );

        # Check if signature have correct text after set queue and customer user.
        $Self->Is(
            $Selenium->execute_script('return $("#Signature").val()'),
            $SignatureText,
            "Signature has correct text"
        );

        # Delete created test ticket.
        my $Success = $Kernel::OM->Get('Kernel::System::Ticket')->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );

        # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
        if ( !$Success ) {
            sleep 3;
            $Success = $Kernel::OM->Get('Kernel::System::Ticket')->TicketDelete(
                TicketID => $TicketID,
                UserID   => 1,
            );
        }
        $Self->True(
            $Success,
            "Ticket with ticket ID $TicketID is deleted",
        );

        # Delete created test customer users.
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        for my $CustomerLogin (@CustomerUserIDs) {
            my $TestCustomer = $DBObject->Quote($CustomerLogin);
            $Success = $DBObject->Do(
                SQL  => "DELETE FROM customer_user WHERE login = ?",
                Bind => [ \$TestCustomer ],
            );
            $Self->True(
                $Success,
                "Customer user $TestCustomer is deleted",
            );
        }

        # Delete created test queues.
        for my $QueueID (@QueueIDs) {
            $Success = $DBObject->Do(
                SQL  => "DELETE FROM queue WHERE id = ?",
                Bind => [ \$QueueID ],
            );
            $Self->True(
                $Success,
                "QueueID $QueueID is deleted",
            );
        }

        # Delete created test signature.
        for my $SignatureID (@SignatureIDs) {
            $Success = $DBObject->Do(
                SQL  => "DELETE FROM signature WHERE id = ?",
                Bind => [ \$SignatureID ],
            );
            $Self->True(
                $Success,
                "SignatureID $SignatureID is deleted",
            );
        }

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure the cache is correct.
        for my $Cache (qw (Ticket CustomerUser)) {
            $CacheObject->CleanUp( Type => $Cache );
        }

    }
);

1;
