# --
# CustomerAutoCompletion.t - frontend test AgentTicketPhone
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
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

use Time::HiRes qw(sleep);

# This test checks if the customer auto completion works correctly.
# Special case: it must also work when called up directly via GET-Parameter.
# http://bugs.otrs.org/show_bug.cgi?id=7158

if ( !$Self->{ConfigObject}->Get('SeleniumTestsActive') ) {
    $Self->True( 1, 'Selenium testing is not active' );
    return 1;
}

require Kernel::System::UnitTest::Selenium;    ## no critic

my $Helper = Kernel::System::UnitTest::Helper->new(
    UnitTestObject => $Self,
    %{$Self},
    RestoreSystemConfiguration => 0,
);

my $TestUserLogin = $Helper->TestUserCreate(
    Groups => ['admin'],
) || die "Did not get test user";

for my $SeleniumScenario ( @{ $Helper->SeleniumScenariosGet() } ) {
    eval {
        my $Selenium = Kernel::System::UnitTest::Selenium->new(
            Verbose        => 1,
            UnitTestObject => $Self,
            %{$SeleniumScenario},
        );

        eval {

            $Selenium->Login(
                Type     => 'Agent',
                User     => $TestUserLogin,
                Password => $TestUserLogin,
            );

            my $ScriptAlias = $Self->{ConfigObject}->Get('ScriptAlias');

            # create local objects
            my $ConfigObject = Kernel::Config->new();

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

            # Open new ticket mask with customer search parameter.
            my %ParamAutoCompleteExptected = (
                "Action=AgentTicketPhone;Subaction=StoreNew;ExpandCustomerName=1;From=$RandomID"
                    => 2,    # more than one match, selection
                "Action=AgentTicketPhone;Subaction=StoreNew;ExpandCustomerName=1;From=$RandomID-1"
                    => 0,    # just one match, no selection
                "Action=AgentTicketPhone;Subaction=StoreNew;ExpandCustomerName=1;From=$RandomID-2"
                    => 0,
                "Action=AgentTicketPhone;Subaction=StoreNew;ExpandCustomerName=1;From=$RandomID-nonexisting"
                    => 0,
                "Action=AgentTicketEmail;Subaction=StoreNew;ExpandCustomerName=1;To=$RandomID"
                    => 2,    # more than one match, selection
                "Action=AgentTicketEmail;Subaction=StoreNew;ExpandCustomerName=1;To=$RandomID-1"
                    => 0,    # just one match, no selection
                "Action=AgentTicketEmail;Subaction=StoreNew;ExpandCustomerName=1;To=$RandomID-2"
                    => 0,
                "Action=AgentTicketEmail;Subaction=StoreNew;ExpandCustomerName=1;To=$RandomID-nonexisting"
                    => 0,
            );

            for my $AutocompleteURL ( sort keys %ParamAutoCompleteExptected ) {
                $Selenium->open_ok("${ScriptAlias}index.pl?$AutocompleteURL");
                $Selenium->wait_for_page_to_load_ok("30000");

                # wait for autocomplete to load
                sleep 0.2;
                WAIT:
                for ( 1 .. 10 ) {
                    last WAIT
                        if (
                        eval {
                            $Selenium->get_eval("this.browserbot.getCurrentWindow().\$.active")
                                == 0;
                        }
                        );
                    sleep 1;
                }

                my $AutoCompleteEntries = $Selenium->get_eval(
                    "this.browserbot.getCurrentWindow().\$('ul.ui-autocomplete li.ui-menu-item:visible').length",
                );

                $Self->Is(
                    $AutoCompleteEntries,
                    $ParamAutoCompleteExptected{$AutocompleteURL},
                    "Found entries in the autocomplete dropdown for URL $AutocompleteURL",
                );
            }

            # Normal autocomplete tests
            $Selenium->open_ok("${ScriptAlias}index.pl?Action=AgentTicketPhone");
            $Selenium->wait_for_page_to_load_ok("30000");

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
                $Selenium->type_ok( "css=input#CustomerAutoComplete", $AutocompleteInput );
                $Selenium->get_eval(
                    "this.browserbot.getCurrentWindow().\$('input#CustomerAutoComplete').trigger('keydown').trigger('keypress').trigger('keyup');",
                );

                # wait for autocomplete to load
                sleep 0.2;
                WAIT:
                for ( 1 .. 10 ) {
                    last WAIT
                        if (
                        eval {
                            $Selenium->get_eval("this.browserbot.getCurrentWindow().\$.active")
                                == 0;
                        }
                        );
                    sleep 1;
                }

                my $AutoCompleteEntries = $Selenium->get_eval(
                    "this.browserbot.getCurrentWindow().\$('ul.ui-autocomplete li.ui-menu-item:visible').length",
                );

                $Self->Is(
                    $AutoCompleteEntries,
                    $AutoCompleteExptected{$AutocompleteInput},
                    "Found entries in the autocomplete dropdown for input string $AutocompleteInput",
                );
            }

            return 1;

        } || $Self->True( 0, "Exception in Selenium scenario '$SeleniumScenario->{ID}': $@" );

        return 1;

    } || $Self->True( 0, "Exception in Selenium scenario '$SeleniumScenario->{ID}': $@" );
}

1;
