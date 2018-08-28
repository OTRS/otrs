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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get needed objects
        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # create and login test user
        my $Language      = 'hu';
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups   => [ 'admin', 'users' ],
            Language => $Language,
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # navigate to appropriate screen in the test
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=Admin");

        my $NavigationModule = $ConfigObject->Get('Frontend::NavigationModule');

        my @NavigationCheck = (
            'Általános ügyintéző',
            'Dinamikus mezők',
            'Folyamatkezelés',
            'Hozzáférés-vezérlési listák (ACL)',
            'Webszolgáltatások',
        );

        # Check if items sort well.
        my $Count = 0;
        for my $Item (@NavigationCheck) {
            my $Navigation = $Selenium->execute_script(
                "return \$('.WidgetSimple:eq(7) ul li:eq($Count) a span.Title').text().trim()"
            );

            $Navigation =~ s/\n\s+/@/g;
            my @Navigation = split( '@', $Navigation );

            $Self->Is(
                $Navigation[0],
                $NavigationCheck[$Count],
                "$NavigationCheck[$Count] - admin navigation item is sorted well",
            );

            # Add item to favourite.
            $Selenium->execute_script(
                "\$('.WidgetSimple:eq(7) ul li:eq($Count) a span.AddAsFavourite').trigger('click')"
            );

            my $Favourite = $Selenium->execute_script(
                "return \$('.WidgetSimple:eq(7) ul li:eq($Count) a span.AddAsFavourite').attr('data-module')"
            );

            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('li[data-module=\"$Favourite\"]').hasClass('IsFavourite');"
            );

            $Self->True(
                $Selenium->execute_script(
                    "return \$('li[data-module=\"$Favourite\"]').hasClass('IsFavourite');"
                ),
                "$NavigationCheck[$Count] - admin navigation item is added to favourite",
            );

            $Count++;
        }

        $Selenium->VerifiedRefresh();

        $Count = 0;
        for my $Item (@NavigationCheck) {

            # Check order in favoutite list.
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('.Favourites tr:eq($Count) a').text()"
                ),
                $NavigationCheck[$Count],
                "$NavigationCheck[$Count] - admin navigation item is sort well",
            );

            # Check order in Admin navigation menu.
            $Count++;
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#nav-Admin ul li:eq($Count) a').text()"
                ),
                $NavigationCheck[ $Count - 1 ],
                "$NavigationCheck[$Count-1] - admin navigation item is sort well",
            );
        }

        $Count = scalar @NavigationCheck;
        for my $Item (@NavigationCheck) {

            # Removes item from favourites.
            $Selenium->execute_script(
                "\$('.DataTable .RemoveFromFavourites:eq($Count)').trigger('click')"
            );

            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('.DataTable .RemoveFromFavourites').length == $Count;"
            );

            $Self->True(
                $Selenium->execute_script(
                    "return \$('.DataTable .RemoveFromFavourites').length == $Count;"
                ),
                "$NavigationCheck[$Count] - admin navigation item is removed from favourite",
            );
            $Count--;
        }
    }
);

1;
