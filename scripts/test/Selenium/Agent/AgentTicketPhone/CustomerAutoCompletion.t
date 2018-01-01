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
use Time::HiRes qw(sleep);

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

# This test checks if the customer auto completion works correctly.
# Special case: it must also work when called up directly via GET-Parameter.
# http://bugs.otrs.org/show_bug.cgi?id=7158

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # get config object
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # don't check email address validity
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['users'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Create some CustomerIDs for the test.
        my @CustomerIDs;

        for my $Counter ( 1 .. 3 ) {

            # create test Customer
            my $CustomerName = "Customer-$Counter-" . $Helper->GetRandomID();
            my $CustomerID   = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanyAdd(
                CustomerID          => $CustomerName,
                CustomerCompanyName => $CustomerName,
                ValidID             => 1,
                UserID              => 1,
            );
            $Self->True(
                $CustomerID,
                "CustomerCompanyAdd - $CustomerID",
            );

            push @CustomerIDs, $CustomerID
        }

        my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

        # create a test customer
        my $TestCustomerUser1 = $Helper->TestCustomerUserCreate()
            || die "Did not get test customer user";

        my $CustomerUser = $Helper->GetRandomID();

        my $Success = $CustomerUserObject->CustomerUserUpdate(
            Source         => 'CustomerUser',
            ID             => $TestCustomerUser1,
            UserCustomerID => $CustomerIDs[0],
            UserLogin      => $TestCustomerUser1,
            UserFirstname  => "$CustomerUser-1",
            UserLastname   => "$CustomerUser-1",
            UserPassword   => "$CustomerUser-1",
            UserEmail      => "$CustomerUser-1" . '@localunittest.com',
            ValidID        => 1,
            UserID         => 1,
        );

        $Self->True(
            $Success,
            "Updated test user 1"
        );

        # set customer user as a member of company
        $Success = $CustomerUserObject->CustomerUserCustomerMemberAdd(
            CustomerUserID => $TestCustomerUser1,
            CustomerID     => $CustomerIDs[1],
            Active         => 1,
            UserID         => 1,
        );

        $Self->True(
            $Success,
            "Added a additional CustomerID relation to customer test user 1"
        );

        my $TestCustomerUser2 = $Helper->TestCustomerUserCreate()
            || die "Did not get test customer user";

        $Success = $CustomerUserObject->CustomerUserUpdate(
            Source         => 'CustomerUser',
            ID             => $TestCustomerUser2,
            UserCustomerID => $TestCustomerUser2,
            UserLogin      => $TestCustomerUser2,
            UserFirstname  => "$CustomerUser-2",
            UserLastname   => "$CustomerUser-2",
            UserPassword   => "$CustomerUser-2",
            UserEmail      => "$CustomerUser-2" . '@localunittest.com',
            ValidID        => 1,
            UserID         => 1,
        );

        $Self->True(
            $Success,
            "Updated test user 2"
        );

        my $TestCustomerUser3 = $Helper->TestCustomerUserCreate()
            || die "Did not get test customer user";

        # update customer user 3 with very similar data as customer user 2
        # disable customer user email uniqueness check temporarily
        my $CustomerUserConfig = $ConfigObject->Get('CustomerUser');
        $CustomerUserConfig->{CustomerUserEmailUniqCheck} = 0;
        $Helper->ConfigSettingChange(
            Key   => 'CustomerUser',
            Value => $CustomerUserConfig,
        );
        $Success = $CustomerUserObject->CustomerUserUpdate(
            Source         => 'CustomerUser',
            ID             => $TestCustomerUser3,
            UserCustomerID => $TestCustomerUser3,
            UserLogin      => $TestCustomerUser3,
            UserFirstname  => "$CustomerUser-2",
            UserLastname   => "$CustomerUser-2",
            UserPassword   => "$CustomerUser-2",
            UserEmail      => "$CustomerUser-2" . '@localunittest.com',
            ValidID        => 1,
            UserID         => 1,
        );

        $Self->True(
            $Success,
            "Updated test user 3"
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # open AgentTicketPhone screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketPhone");

        # First test that the additional CustomerID select button is visible but disabled, because the field
        #   is readonly as default.
        $Self->Is(
            $Selenium->execute_script("return \$('#SelectionCustomerID').prop('disabled')"),
            1,
            "Button to select a other CustomerID is disabled",
        );
        $Self->Is(
            $Selenium->execute_script("return \$('#SelectionCustomerID').prop('title')"),
            'The customer ID is not changeable, no other customer ID can be assigned to this ticket.',
            'Button text for the not changeable CustomerID is found on screen',
        );

        $Helper->ConfigSettingChange(
            Key   => 'Ticket::Frontend::AgentTicketPhone::CustomerIDReadOnly',
            Value => 0,
        );

        # Check if the additional CustomerID select button is not disabled.
        $Selenium->VerifiedRefresh();

        $Self->Is(
            $Selenium->execute_script("return \$('#SelectionCustomerID').prop('disabled')"),
            1,
            "Button to select a other CustomerID is disabled",
        );
        $Self->Is(
            $Selenium->execute_script("return \$('#SelectionCustomerID').prop('title')"),
            'First select a customer user, then you can select a customer ID to assign to this ticket.',
            'Button text for changeable CustomerID but disabled button is found on screen',
        );

        my %AutoCompleteExpected = (
            "$CustomerUser" => {
                Expected => 2,    # AgentCustomerSearch should return only 2 records (see bug#11996)
                CustomerUser => "\"$CustomerUser-1 $CustomerUser-1\" <$CustomerUser-1\@localunittest.com>",
                CustomerID   => $CustomerIDs[0],
                AutocompleteInput =>
                    "\"$CustomerUser-1 $CustomerUser-1\" <$CustomerUser-1\@localunittest.com> ($TestCustomerUser1)",
            },
            "$CustomerUser-1" => {
                Expected     => 1,
                CustomerUser => "\"$CustomerUser-1 $CustomerUser-1\" <$CustomerUser-1\@localunittest.com>",
                CustomerID   => $CustomerIDs[1],
                AutocompleteInput =>
                    "\"$CustomerUser-1 $CustomerUser-1\" <$CustomerUser-1\@localunittest.com> ($TestCustomerUser1)",
                SelectAssigendCustomerID => $CustomerIDs[1],
            },
            "$CustomerUser-2" => {
                Expected => 1,    # AgentCustomerSearch should return only 1 record (see bug#11996)
                CustomerUser => "\"$CustomerUser-2 $CustomerUser-2\" <$CustomerUser-2\@localunittest.com>",
                CustomerID   => $CustomerIDs[2],
                AutocompleteInput =>
                    "\"$CustomerUser-2 $CustomerUser-2\" <$CustomerUser-2\@localunittest.com> ($TestCustomerUser2)",
                SelectAllCustomerID => $CustomerIDs[2],
            },
            "$CustomerUser-nonexisting" => {
                Expected            => 0,
                CustomerID          => $CustomerIDs[2],
                SelectAllCustomerID => $CustomerIDs[2],
            },
        );

        for my $AutocompleteInput ( sort keys %AutoCompleteExpected ) {

            # check autocomplete field
            $Selenium->find_element( "input.CustomerAutoComplete", 'css' )->clear();
            $Selenium->find_element( "input.CustomerAutoComplete", 'css' )->send_keys($AutocompleteInput);

            if ( $AutoCompleteExpected{$AutocompleteInput}->{Expected} ) {

                # wait for autocomplete to load
                $Selenium->WaitFor(
                    JavaScript =>
                        "return typeof(\$) === 'function' && \$('li.ui-menu-item:visible').length === $AutoCompleteExpected{$AutocompleteInput}->{Expected}"
                );
            }
            else {

                # Send a "return" key to trigger the javascript events, because we need a change of the field,
                #   if no auto complete result exists.
                $Selenium->find_element( "input.CustomerAutoComplete", 'css' )->send_keys("\n");

                # Wait for ajax call after customer user selection.
                $Selenium->WaitFor(
                    JavaScript => 'return typeof($) === "function" && !$("span.AJAXLoader:visible").length',
                );
            }

            my $AutoCompleteEntries = $Selenium->execute_script(
                "return \$('ul.ui-autocomplete li.ui-menu-item:visible').length",
            );

            $Self->Is(
                $AutoCompleteEntries,
                $AutoCompleteExpected{$AutocompleteInput}->{Expected},
                "Found entries in the autocomplete dropdown for input string $AutocompleteInput",
            );

            if ( $AutoCompleteExpected{$AutocompleteInput}->{Expected} ) {

                # select customer user
                $Selenium->execute_script("\$('li.ui-menu-item:contains($AutocompleteInput)').click()");

                # Wait until customer data is loading (CustomerID is filled after CustomerAutoComplete)
                $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#CustomerID").val().length' );

                # Wait for ajax call after customer user selection.
                $Selenium->WaitFor(
                    JavaScript => 'return typeof($) === "function" && !$("span.AJAXLoader:visible").length',
                );

                # check if customer is selected
                $Self->Is(
                    $Selenium->find_element( "#CustomerTicketText_1", 'css' )->get_value(),
                    $AutoCompleteExpected{$AutocompleteInput}->{CustomerUser},
                    "Customer user is selected",
                );
            }

            if (
                $AutoCompleteExpected{$AutocompleteInput}->{SelectAssigendCustomerID}
                || $AutoCompleteExpected{$AutocompleteInput}->{SelectAllCustomerID}
                )
            {

                $Selenium->WaitFor(
                    JavaScript => 'return !$("#SelectionCustomerID").prop("disabled")',
                );

                $Selenium->find_element( "#SelectionCustomerID", 'css' )->click();
                $Selenium->WaitFor(
                    JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length === 1;'
                );
                $Selenium->WaitFor(
                    JavaScript =>
                        'return typeof($) === "function" && $("#SelectionCustomerIDAll:visible").length'
                );

                if ( $AutoCompleteExpected{$AutocompleteInput}->{SelectAssigendCustomerID} ) {
                    $Selenium->execute_script(
                        "\$('#SelectionCustomerIDAssigned').val('$AutoCompleteExpected{$AutocompleteInput}->{SelectAssigendCustomerID}').trigger('redraw.InputField').trigger('change');"
                    );
                }
                elsif ( $AutoCompleteExpected{$AutocompleteInput}->{SelectAllCustomerID} ) {

                    # Check if the assigend dropdown is not visible for a not existing customer user.
                    if ( !$AutoCompleteExpected{$AutocompleteInput}->{Expected} ) {
                        $Self->Is(
                            $Selenium->execute_script(
                                "return \$('#SelectionCustomerIDAssigned:visible').length"
                            ),
                            0,
                            "SelectionCustomerIDAssigned is not visible",
                        );
                    }

                    $Selenium->find_element( "#SelectionCustomerIDAll", 'css' )->clear();
                    $Selenium->find_element( "#SelectionCustomerIDAll", 'css' )
                        ->send_keys( $AutoCompleteExpected{$AutocompleteInput}->{SelectAllCustomerID} );

                    # Wait for autocomplete to load.
                    $Selenium->WaitFor(
                        JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length'
                    );
                    $Selenium->WaitFor(
                        JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length'
                    );

                    # select customer id
                    $Selenium->execute_script(
                        "\$('li.ui-menu-item:contains($AutoCompleteExpected{$AutocompleteInput}->{SelectAllCustomerID})').click()"
                    );

                }

                $Selenium->WaitFor(
                    JavaScript => 'return typeof($) === "function" && !$("#SelectionCustomerIDAll:visible").length;'
                );
            }

            # check if correct CustomerID is filled
            $Self->Is(
                $Selenium->find_element( "#CustomerID", 'css' )->get_value(),
                $AutoCompleteExpected{$AutocompleteInput}->{CustomerID},
                "CustomerID is selected",
            );

            $Selenium->VerifiedRefresh();
        }

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        for my $CustomerID (@CustomerIDs) {

            my $Success = $DBObject->Do(
                SQL  => "DELETE FROM customer_user_customer WHERE customer_id = ?",
                Bind => [ \$CustomerID ],
            );
            $Self->True(
                $Success,
                "Deleted CustomerUserCustomer Relation - $CustomerID",
            );

            $Success = $DBObject->Do(
                SQL  => "DELETE FROM customer_company WHERE customer_id = ?",
                Bind => [ \$CustomerID ],
            );
            $Self->True(
                $Success,
                "Deleted CustomerCompany - $CustomerID",
            );
        }

        # Make sure the cache is correct.
        for my $Cache (qw(CustomerUser CustomerCompany)) {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }
    }
);

1;
