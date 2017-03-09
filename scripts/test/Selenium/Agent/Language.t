# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
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
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentPreferences;Subaction=Group;Group=UserProfile");

        my @Languages = sort keys %{ $ConfigObject->Get('DefaultUsedLanguages') };

        for my $Language (@Languages) {

            # check for the language selection box
            $Selenium->execute_script(
                "\$('#UserLanguage').val('$Language').trigger('redraw.InputField').trigger('change');"
            );
            $Selenium->execute_script(
                "\$('#UserLanguage').closest('.WidgetSimple').find('.SettingUpdateBox').find('button').trigger('click');"
            );

            # wait for the ajax call to finish
            $Selenium->WaitFor(
                JavaScript =>
                    "return \$('#UserLanguage').closest('.WidgetSimple').hasClass('HasOverlay')"
            );
            $Selenium->WaitFor(
                JavaScript =>
                    "return \$('#UserLanguage').closest('.WidgetSimple').find('.fa-check').length"
            );
            $Selenium->WaitFor(
                JavaScript =>
                    "return !\$('#UserLanguage').closest('.WidgetSimple').hasClass('HasOverlay')"
            );

            # reload the screen
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentPreferences;Subaction=Group;Group=UserProfile");

            # now check if the language was correctly applied in the interface
            my $LanguageObject = Kernel::Language->new(
                UserLanguage => $Language,
            );

            my $Element = $Selenium->find_element( 'Label[for=UserLanguage]', 'css' );
            my $Label = $Element->get_text();
            $Label =~ s/^\s+|\s+$//g;
            my $Expected = $LanguageObject->Translate('Language');
            $Expected =~ s/^\s+|\s+$//g;
            $Self->Is(
                $Label,
                $Expected,
                "String 'Language' in $Language",
            );
        }
    }
);

1;
