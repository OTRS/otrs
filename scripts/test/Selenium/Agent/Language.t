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

use vars qw($Self);

use Kernel::System::UnitTest::Helper;
use Kernel::Language;
use Kernel::System::UnitTest::Selenium;

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

        my $TestUserLogin = $Helper->TestUserCreate() || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Self->{ConfigObject}->Get('ScriptAlias');

        $Selenium->get("${ScriptAlias}index.pl?Action=AgentPreferences");

        my @Languages = sort keys %{ $Self->{ConfigObject}->Get('DefaultUsedLanguages') };

        Language:
        for my $Language (@Languages) {

            # check for the language selection box
            my $Element = $Selenium->find_element( "select#UserLanguage", 'css' );

            # select the current language & submit
            $Element
                = $Selenium->find_child_element( $Element, "option[value='$Language']", 'css' );
            $Element->click();
            $Element->submit();

            # now check if the language was correctly applied in the interface
            my $LanguageObject = Kernel::Language->new(
                MainObject   => $Self->{MainObject},
                ConfigObject => $Self->{ConfigObject},
                EncodeObject => $Self->{EncodeObject},
                LogObject    => $Self->{LogObject},
                UserLanguage => $Language,
            );

            $Element = $Selenium->find_element( 'h1', 'css' );
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
