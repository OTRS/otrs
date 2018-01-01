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
use Kernel::Language;

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get config object
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # get script alias
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # navigate to AgentPReferences screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentPreferences");

        my @Languages = sort keys %{ $ConfigObject->Get('DefaultUsedLanguages') };

        Language:
        for my $Language (@Languages) {

            # change AgentPreference language
            $Selenium->execute_script(
                "\$('#UserLanguage').val('$Language').trigger('redraw.InputField').trigger('change');"
            );

            # TODO; It should be improved. There is a problem with redraw InputField
            sleep 3;
            $Selenium->execute_script('$("#UserLanguageUpdate").click()');
            sleep 2;

            # now check if the language was correctly applied in the interface
            my $LanguageObject = Kernel::Language->new(
                UserLanguage => $Language,
            );

            my $Element = $Selenium->find_element( 'Label[for=UserLanguage]', 'css' );
            $Self->Is(
                substr( $Element->get_text(), 0, -1 ),
                $LanguageObject->Get('Language'),
                "String 'Language' in $Language",
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
