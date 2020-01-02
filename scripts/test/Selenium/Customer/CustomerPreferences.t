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

use Kernel::Language;

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # enable google authenticator shared secret preference
        my $SharedSecretConfig
            = $Kernel::OM->Get('Kernel::Config')->Get('CustomerPreferencesGroups')->{'GoogleAuthenticatorSecretKey'};
        $SharedSecretConfig->{Active} = 1;
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => "CustomerPreferencesGroups###GoogleAuthenticatorSecretKey",
            Value => $SharedSecretConfig,
        );

        # create test customer user and login
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $TestCustomerUserLogin,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to CustomerPreference screen
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerPreferences");

        # check CustomerPreferences screen
        for my $ID (
            qw(UserLanguage UserShowTickets UserRefreshTime CurPw NewPw NewPw1 UserGoogleAuthenticatorSecretKey)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # check CustomerPreferences default values
        $Self->Is(
            $Selenium->find_element( '#UserLanguage', 'css' )->get_value(),
            "en",
            "#UserLanguage stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#UserRefreshTime', 'css' )->get_value(),
            "0",
            "#UserRefreshTime stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#UserShowTickets', 'css' )->get_value(),
            "25",
            "#UserShowTickets stored value",
        );

        # edit checked stored values
        $Selenium->InputFieldValueSet(
            Element => '#UserRefreshTime',
            Value   => 2,
        );
        $Selenium->find_element( '#UserRefreshTimeUpdate', 'css' )->VerifiedClick();

        $Selenium->InputFieldValueSet(
            Element => '#UserShowTickets',
            Value   => 20,
        );
        $Selenium->find_element( '#UserShowTicketsUpdate', 'css' )->VerifiedClick();

        # check edited values
        $Self->Is(
            $Selenium->find_element( '#UserRefreshTime', 'css' )->get_value(),
            "2",
            "#UserRefreshTime updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#UserShowTickets', 'css' )->get_value(),
            "20",
            "#UserShowTickets updated value",
        );

        # test different language scenarios
        for my $Language (
            qw(de es ru zh_CN sr_Cyrl en)
            )
        {
            # change CustomerPreference language
            $Selenium->InputFieldValueSet(
                Element => '#UserLanguage',
                Value   => $Language,
            );
            $Selenium->find_element( '#UserLanguageUpdate', 'css' )->VerifiedClick();

            # check edited language value
            $Self->Is(
                $Selenium->find_element( '#UserLanguage', 'css' )->get_value(),
                "$Language",
                "#UserLanguage updated value",
            );

            # create language object
            my $LanguageObject = Kernel::Language->new(
                UserLanguage => "$Language",
            );

            # check for correct translation
            $Self->True(
                index( $Selenium->get_page_source(), $LanguageObject->Translate('Interface language') ) > -1,
                "Test widget 'Interface language' found on screen"
            );
            $Self->True(
                index( $Selenium->get_page_source(), $LanguageObject->Translate('Number of displayed tickets') ) > -1,
                "Test widget 'Number of displayed tickets' found on screen"
            );
            $Self->True(
                index( $Selenium->get_page_source(), $LanguageObject->Translate('Ticket overview') ) > -1,
                "Test widget 'Ticket overview' found on screen"
            );
        }

        # try updating the UserGoogleAuthenticatorSecret (which has a regex validation configured)
        $Selenium->find_element( "#UserGoogleAuthenticatorSecretKey",       'css' )->send_keys('Invalid Key');
        $Selenium->find_element( '#UserGoogleAuthenticatorSecretKeyUpdate', 'css' )->VerifiedClick();
        $Self->True(
            index( $Selenium->get_page_source(), $SharedSecretConfig->{'ValidateRegexMessage'} ) > -1,
            "Error message for invalid shared secret found on screen"
        );

        # now use a valid secret
        $Selenium->find_element( "#UserGoogleAuthenticatorSecretKey",       'css' )->send_keys('ABCABCABCABCABC2');
        $Selenium->find_element( '#UserGoogleAuthenticatorSecretKeyUpdate', 'css' )->VerifiedClick();
        $Self->True(
            index( $Selenium->get_page_source(), 'Preferences updated successfully!' ) > -1,
            "Success message found on screen"
        );

        # Inject malicious code in user language variable.
        my $MaliciousCode = 'en\\\'});window.iShouldNotExist=true;Core.Config.AddConfig({a:\\\'';
        $Selenium->execute_script(
            "\$('#UserLanguage').append(
                \$('<option/>', {
                    value: '$MaliciousCode',
                    text: 'Malevolent'
                })
            ).val('$MaliciousCode').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element( '#UserLanguageUpdate', 'css' )->VerifiedClick();

        # Check if malicious code was sanitized.
        $Self->True(
            $Selenium->execute_script(
                "return typeof window.iShouldNotExist === 'undefined';"
            ),
            'Malicious variable is undefined'
        );
    }
);

1;
