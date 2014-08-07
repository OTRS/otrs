# --
# CustomerAutoCompletion.t - frontend test AgentTicketPhone
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use vars qw($Self);

use Kernel::System::UnitTest::Helper;
use Kernel::System::User;
use Kernel::System::CustomerUser;
use Kernel::System::UnitTest::Selenium;

use Time::HiRes qw(sleep);

# This test checks if the customer auto completion works correctly.
# Special case: it must also work when called up directly via GET-Parameter.
# http://bugs.otrs.org/show_bug.cgi?id=7158

my $Selenium = Kernel::System::UnitTest::Selenium->new(
    Verbose        => 1,
    UnitTestObject => $Self,
);

$Selenium->RunTest(
    sub {

        my $Helper = Kernel::System::UnitTest::Helper->new(
            UnitTestObject => $Self,
            %{$Self},
            RestoreSystemConfiguration => 0,
        );

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['users'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Self->{ConfigObject}->Get('ScriptAlias');

        # create local objects
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        $ConfigObject->Set(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        my $CustomerUserObject = Kernel::System::CustomerUser->new(
            %{$Self},
            ConfigObject => $ConfigObject,
        );

        # create a test customer
        my $TestCustomerUser1 = $Helper->TestCustomerUserCreate()
            || die "Did not get test customer user";

        my $RandomID = $Helper->GetRandomID();

        my $Success = $CustomerUserObject->CustomerUserUpdate(
            Source         => 'CustomerUser',
            ID             => $TestCustomerUser1,
            UserCustomerID => $TestCustomerUser1,
            UserLogin      => $TestCustomerUser1,
            UserFirstname  => "$RandomID-1",
            UserLastname   => "$RandomID-1",
            UserPassword   => "$RandomID-1",
            UserEmail      => "$RandomID-1" . '@localunittest.com',
            ValidID        => 1,
            UserID         => 1,
        );

        $Self->True( $Success, "Updated test user 1" );

        my $TestCustomerUser2 = $Helper->TestCustomerUserCreate()
            || die "Did not get test customer user";

        $Success = $CustomerUserObject->CustomerUserUpdate(
            Source         => 'CustomerUser',
            ID             => $TestCustomerUser2,
            UserCustomerID => $TestCustomerUser2,
            UserLogin      => $TestCustomerUser2,
            UserFirstname  => "$RandomID-2",
            UserLastname   => "$RandomID-2",
            UserPassword   => "$RandomID-2",
            UserEmail      => "$RandomID-2" . '@localunittest.com',
            ValidID        => 1,
            UserID         => 1,
        );

        $Self->True( $Success, "Updated test user 2" );

        # Normal autocomplete tests
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentTicketPhone");

        my %AutoCompleteExptected = (
            "$RandomID"             => 2,
            "$RandomID-1"           => 1,
            "$RandomID-2"           => 1,
            "$RandomID-nonexisting" => 0,
        );

        for my $AutocompleteInput ( sort keys %AutoCompleteExptected ) {

            # Workaround: type_keys_ok() does not workin Safari.
            # Use type_ok() instead and emulate the key events.
            # see http://jira.openqa.org/browse/SRC-760
            $Selenium->find_element( "input.CustomerAutoComplete", 'css' )->clear();
            $Selenium->find_element( "input.CustomerAutoComplete", 'css' )
                ->send_keys($AutocompleteInput);

            # wait for autocomplete to load
            sleep 0.2;
            WAIT:
            for ( 1 .. 40 ) {
                if ( eval { $Selenium->execute_script("return \$.active") == 0; } ) {
                    last WAIT;
                }
                sleep 0.2;
            }

            my $AutoCompleteEntries = $Selenium->execute_script(
                "return \$('ul.ui-autocomplete li.ui-menu-item:visible').length",
            );

            $Self->Is(
                $AutoCompleteEntries,
                $AutoCompleteExptected{$AutocompleteInput},
                "Found entries in the autocomplete dropdown for input string $AutocompleteInput",
            );
        }
        }
);

1;
