# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
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

        # get helper object
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 1,
            },
        );
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        my $TestUserLogin = $Helper->TestCustomerUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # go to customer preferences
        $Selenium->get("${ScriptAlias}customer.pl?Action=CustomerPreferences");

        # create test params
        my @Tests = (
            {
                Name  => 'Ticket Overview',
                ID    => 'UserRefreshTime',
                Value => '5',
            },
            {
                Name  => 'Number of displayed tickets',
                ID    => 'UserShowTickets',
                Value => '30',
            },
        );

        my $UpdateMessage = "Preferences updated successfully!";

        # update generic preferences
        for my $Test (@Tests) {

            $Selenium->execute_script("\$('#$Test->{ID}').val('$Test->{Value}').trigger('redraw.InputField');");
            $Selenium->find_element( "#$Test->{ID} option[value='$Test->{Value}']", 'css' )->submit();

            $Self->True(
                index( $Selenium->get_page_source(), $UpdateMessage ) > -1,
                "Customer preference $Test->{Name} - updated"
            );
        }
    }
);

1;
