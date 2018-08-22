# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
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

        my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

        # create a test customer
        my $TestCustomerUser1 = $Helper->TestCustomerUserCreate()
            || die "Did not get test customer user";

        my $CustomerUser = $Helper->GetRandomID();

        my $Success = $CustomerUserObject->CustomerUserUpdate(
            Source         => 'CustomerUser',
            ID             => $TestCustomerUser1,
            UserCustomerID => $TestCustomerUser1,
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

        my %AutoCompleteExpected = (
            "$CustomerUser" => {
                Expected => 2,    # AgentCustomerSearch should return only 2 records (see bug#11996)
                CustomerUser => "\"$CustomerUser-1 $CustomerUser-1\" <$CustomerUser-1\@localunittest.com>",
                AutocompleteInput =>
                    "\"$CustomerUser-1 $CustomerUser-1\" <$CustomerUser-1\@localunittest.com> ($TestCustomerUser1)",
            },
            "$CustomerUser-1" => {
                Expected     => 1,
                CustomerUser => "\"$CustomerUser-1 $CustomerUser-1\" <$CustomerUser-1\@localunittest.com>",
                AutocompleteInput =>
                    "\"$CustomerUser-1 $CustomerUser-1\" <$CustomerUser-1\@localunittest.com> ($TestCustomerUser1)",
            },
            "$CustomerUser-2" => {
                Expected => 1,    # AgentCustomerSearch should return only 1 record (see bug#11996)
                CustomerUser => "\"$CustomerUser-2 $CustomerUser-2\" <$CustomerUser-2\@localunittest.com>",
                AutocompleteInput =>
                    "\"$CustomerUser-2 $CustomerUser-2\" <$CustomerUser-2\@localunittest.com> ($TestCustomerUser2)",
            },
            "$CustomerUser-nonexisting" => {
                Expected => 0,
            },
        );

        for my $AutocompleteInput ( sort keys %AutoCompleteExpected ) {

            # check autocomplete field
            $Selenium->find_element( "input.CustomerAutoComplete", 'css' )->clear();
            $Selenium->find_element( "input.CustomerAutoComplete", 'css' )->send_keys($AutocompleteInput);

            if ( $AutoCompleteExpected{$AutocompleteInput}{Expected} ) {

                # wait for autocomplete to load
                $Selenium->WaitFor(
                    JavaScript =>
                        "return typeof(\$) === 'function' && \$('li.ui-menu-item:visible').length === $AutoCompleteExpected{$AutocompleteInput}->{Expected}"
                );
            }

            my $AutoCompleteEntries = $Selenium->execute_script(
                "return \$('ul.ui-autocomplete li.ui-menu-item:visible').length",
            );

            $Self->Is(
                $AutoCompleteEntries,
                $AutoCompleteExpected{$AutocompleteInput}{Expected},
                "Found entries in the autocomplete dropdown for input string $AutocompleteInput",
            );

            if ( $AutoCompleteExpected{$AutocompleteInput}{Expected} ) {

                # select customer user
                $Selenium->execute_script(
                    "\$('li.ui-menu-item:contains($AutoCompleteExpected{$AutocompleteInput}{AutocompleteInput})').click()"
                );

                # check if customer is selected
                $Self->Is(
                    $Selenium->find_element( "#CustomerTicketText_1", 'css' )->get_value(),
                    $AutoCompleteExpected{$AutocompleteInput}{CustomerUser},
                    "Customer user is selected",
                );
            }

            $Selenium->VerifiedRefresh();
        }
    }
);

1;
