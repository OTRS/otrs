# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # create test user and login
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
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerPreferences");

        # create test params
        my @Tests = (
            {
                Name  => 'Ticket Overview',
                ID    => 'UserRefreshTimeUpdate',
                Value => '5',
            },
            {
                Name  => 'Number of displayed tickets',
                ID    => 'UserShowTicketsUpdate',
                Value => '30',
            },
        );

        my $UpdateMessage = "Preferences updated successfully!";

        # update generic preferences
        for my $Test (@Tests) {

            $Selenium->InputFieldValueSet(
                Element => "#$Test->{ID}",
                Value   => $Test->{Value},
            );
            $Selenium->find_element( "#$Test->{ID}", 'css' )->VerifiedClick();

            $Self->True(
                index( $Selenium->get_page_source(), $UpdateMessage ) > -1,
                "Customer preference $Test->{Name} - updated"
            );
        }
    }
);

1;
