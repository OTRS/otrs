# --
# Language.t - frontend tests for admin area
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::Language;
use Kernel::System::UnitTest::Helper;
use Kernel::System::UnitTest::Selenium;

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my $Selenium = Kernel::System::UnitTest::Selenium->new(
    Verbose => 1,
);

$Selenium->RunTest(
    sub {

        my $Helper = Kernel::System::UnitTest::Helper->new(
            RestoreSystemConfiguration => 0,
        );

        my $TestUserLogin = $Helper->TestUserCreate() || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        $Selenium->get("${ScriptAlias}index.pl?Action=AgentPreferences");

        my @Languages = sort keys %{ $ConfigObject->Get('DefaultUsedLanguages') };

        Language:
        for my $Language (@Languages) {

            # check for the language selection box
            my $Element = $Selenium->find_element( "select#UserLanguage", 'css' );

            # select the current language & submit
            $Element = $Selenium->find_child_element( $Element, "option[value='$Language']", 'css' );
            $Element->click();
            $Element->submit();

            # now check if the language was correctly applied in the interface
            my $LanguageObject = Kernel::Language->new(
                UserLanguage => $Language,
            );

            $Element = $Selenium->find_element( '.MainBox h1', 'css' );
            $Self->Is(
                $Element->get_text(),
                $LanguageObject->Get('Edit your preferences'),
                "Heading translation in $Language",
            );

            $Self->True(
                index(
                    $Selenium->get_page_source(),
                    $LanguageObject->Get('Preferences updated successfully!')
                    ) > -1,
                "Success notification in $Language",
            );
        }
    }
);

1;
