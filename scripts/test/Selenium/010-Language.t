# --
# 010-Language.t - frontend tests for admin area
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
use Kernel::Language;

use Time::HiRes qw(sleep);

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

my $TestUserLogin = $Helper->TestUserCreate() || die "Did not get test user";

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

            $Selenium->open_ok("${ScriptAlias}index.pl?Action=AgentPreferences");
            $Selenium->wait_for_page_to_load_ok("30000");

            my @Languages = sort keys %{ $Self->{ConfigObject}->Get('DefaultUsedLanguages') };

            Language:
            for my $Language (@Languages) {

                # check for the language selection box
                $Selenium->is_element_present_ok("css=select#UserLanguage");

                # select the current language
                $Selenium->select_ok( "UserLanguage", "value=$Language" );

                # reload the page
                $Selenium->click_ok("UserLanguageUpdate");
                $Selenium->wait_for_page_to_load_ok("30000");

                # now check if the language was correctly applied in the interface
                my $LanguageObject = Kernel::Language->new(
                    MainObject   => $Self->{MainObject},
                    ConfigObject => $Self->{ConfigObject},
                    EncodeObject => $Self->{EncodeObject},
                    LogObject    => $Self->{LogObject},
                    UserLanguage => $Language,
                );

                $Selenium->text_is( "//h1", $LanguageObject->Get('Edit your preferences') );
                $Selenium->is_text_present_ok(
                    $LanguageObject->Get('Preferences updated successfully!')
                );
            }
            return 1;
        } || $Self->True( 0, "Exception in Selenium scenario '$SeleniumScenario->{ID}': $@" );

        return 1;

    } || $Self->True( 0, "Exception in Selenium scenario '$SeleniumScenario->{ID}': $@" );

}

1;
