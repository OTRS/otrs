# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $Selenium     = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        my $Language = 'de';

        # Do not validate email addresses.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups   => ['admin'],
            Language => $Language,
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminEmail");

        # Check page.
        for my $ID (
            qw(From UserIDs GroupIDs GroupPermissionRO GroupPermissionRW Subject RichText)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # If there are roles, there will be select box for roles in AdminEmail.
        my %RoleList = $Kernel::OM->Get('Kernel::System::Group')->RoleList( Valid => 1 );
        if (%RoleList) {
            my $Element = $Selenium->find_element( "#RoleIDs", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        $Self->Is(
            $Selenium->find_element( '#From', 'css' )->get_value(),
            $Kernel::OM->Get('Kernel::Config')->Get("AdminEmail"),
            "#From stored value",
        );

        # Check client side validation.
        my $Element = $Selenium->find_element( "#Subject", 'css' );
        $Element->send_keys("");
        $Selenium->find_element( "#submitRichText", 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Subject.Error").length' );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Subject').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # Create test admin notification.
        my $RandomID = $Helper->GetRandomID();
        my $Text     = "Selenium Admin Notification test";
        my $UserID   = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        $Selenium->InputFieldValueSet(
            Element => '#UserIDs',
            Value   => $UserID,
        );
        $Selenium->find_element( "#Subject",        'css' )->send_keys($RandomID);
        $Selenium->find_element( "#RichText",       'css' )->send_keys($Text);
        $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick();

        # Check if test admin notification is success.
        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $Language,
        );

        my $Expected = $LanguageObject->Translate(
            "Your message was sent to"
        ) . ": $TestUserLogin\@localunittest.com";

        $Self->True(
            index( $Selenium->get_page_source(), $Expected ) > -1,
            "$RandomID admin notification was sent",
        );

    }

);

1;
