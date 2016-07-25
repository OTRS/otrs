# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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
        my $Helper             = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
        my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
        my $LanguageObject     = $Kernel::OM->Get('Kernel::Language');

        # disable check email addresses
        $ConfigObject->Set(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # get needed variables
        my $RandomNumber = $Helper->GetRandomNumber();
        my %CustomerUsers;

        # create test customers
        for my $Mail (qw(To Cc Bcc)) {

            my %CustomerUserData = (
                UserFirstname  => "Firstname$Mail$RandomNumber",
                UserLastname   => "Lastname$Mail$RandomNumber",
                UserEmail      => $Mail . $RandomNumber . '@example.com',
                UserCustomerID => 'CustomerID' . $RandomNumber,
                UserLogin      => $Mail . $RandomNumber,
            );

            my $CustomerUserID = $CustomerUserObject->CustomerUserAdd(
                Source       => 'CustomerUser',
                UserPassword => 'some_pass',
                ValidID      => 1,
                UserID       => 1,
                %CustomerUserData,
            );
            $Self->True(
                $CustomerUserID,
                "CustomerUserID $CustomerUserID is created",
            );
            $CustomerUserData{ID} = $CustomerUserID;
            push @{ $CustomerUsers{$Mail} }, \%CustomerUserData;
        }

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # navigate to AgentTicketEmail screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketEmail");

        # click 'Address book' and switch to iframe
        $Selenium->find_element( "#OptionAddressBook", 'css' )->click();
        $Selenium->switch_to_frame( $Selenium->find_element( '.TextOption', 'css' ) );

        # search by $RandomNumber for all test customer users as result
        $Selenium->execute_script("\$('#Search').val($RandomNumber)");
        $Selenium->find_element( "#Search", 'css' )->submit();

        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#SearchResult").length' );

        # click for To, Cc, Bcc
        for my $Mail ( sort keys %CustomerUsers ) {
            my $RelCustomer = $Mail . 'Customer';
            $Selenium->find_element(
                "a[rel=$RelCustomer][title*=\"$CustomerUsers{$Mail}->[0]->{UserEmail}\"]", 'css'
            )->click();
        }

        # click 'Apply'
        $Selenium->find_element( "#Apply", 'css' )->click();

        # switch back to the main window
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[0] );

        my $FieldID;

        for my $Mail ( sort keys %CustomerUsers ) {

            if ( $Mail eq 'To' ) {
                $FieldID = 'CustomerTicketText_1';
            }
            else {
                $FieldID = $Mail . 'CustomerTicketText_1';
            }

            # check input field content
            $Self->Is(
                $Selenium->execute_script("return \$('#$FieldID').val()"),
                "\"$CustomerUsers{$Mail}->[0]->{UserFirstname} $CustomerUsers{$Mail}->[0]->{UserLastname}\" <$CustomerUsers{$Mail}->[0]->{UserEmail}>",
                "'$Mail' field content is correct",
            );

            # click 'Address book'
            $Selenium->find_element( "#OptionAddressBook", 'css' )->click();
            $Selenium->switch_to_frame( $Selenium->find_element( '.TextOption', 'css' ) );

            # fill corresponding field to duplicate customer user
            my $MailCustomer = $Mail . 'Customer';
            my $EmailAddress =
                "\"$CustomerUsers{$Mail}->[0]->{UserFirstname} $CustomerUsers{$Mail}->[0]->{UserLastname}\" <$CustomerUsers{$Mail}->[0]->{UserEmail}>";
            $Selenium->execute_script("\$('#$MailCustomer').val('$EmailAddress')");
            $Selenium->find_element( "#Apply", 'css' )->click();

            $Handles = $Selenium->get_window_handles();
            $Selenium->switch_to_window( $Handles->[0] );

            # check error dialog modal
            $Self->Is(
                $Selenium->execute_script("return \$('.Dialog.Modal .InnerContent p').text()"),
                $LanguageObject->Translate(
                    "This address already exists on the address list. It is going to be deleted from the field, please try again."
                ),
                "Error dialog modal is correct",
            );

            # click OK
            $Selenium->find_element( "#DialogButton1", 'css' )->click();
        }

        # cleanup
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        my $Success;

        # delete customer users
        for my $Mail ( sort keys %CustomerUsers ) {

            $Success = $DBObject->Do(
                SQL  => "DELETE FROM customer_user WHERE login = ?",
                Bind => [ \$CustomerUsers{$Mail}->[0]->{ID} ],
            );
            $Self->True(
                $Success,
                "CustomerUserID $CustomerUsers{$Mail}->[0]->{ID} is deleted",
            );
        }

        # make sure cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'CustomerUser'
        );

    }
);

1;
