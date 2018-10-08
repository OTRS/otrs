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
use Kernel::Language;

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Navigate to AgentPreferences screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentPreferences");
        sleep 2;

        my @Languages = sort keys %{ $ConfigObject->Get('DefaultUsedLanguages') };

        for my $Language (@Languages) {

            # Change AgentPreference language.
            $Selenium->execute_script(
                "\$('#UserLanguage').val('$Language').trigger('redraw.InputField').trigger('change');"
            );
            $Selenium->WaitFor( JavaScript => "return \$('#UserLanguage').val() === '$Language';" );
            sleep 2;

            $Selenium->find_element( '#UserLanguageUpdate', 'css' )->VerifiedClick();

            # Now check if the language was correctly applied in the interface.
            my $LanguageObject = Kernel::Language->new(
                UserLanguage => $Language,
            );

            my $LanguageWord = $LanguageObject->Get('Language');
            my $Notification = $LanguageObject->Get('Preferences updated successfully!');

            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('label[for=UserLanguage]').text() === '$LanguageWord:' && \$('.MessageBox.Notice').text().trim() === '$Notification';"
            );

            my $Element = $Selenium->find_element( 'label[for=UserLanguage]', 'css' );
            $Self->Is(
                substr( $Element->get_text(), 0, -1 ),
                $LanguageWord,
                "String 'Language' in $Language",
            );

            $Self->True(
                $Selenium->execute_script("return \$('.MessageBox.Notice').text().trim() === '$Notification';"),
                "Success notification in $Language",
            );
        }
    }
);

1;
