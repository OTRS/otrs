# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $Selenium     = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 1,
            },
        );
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        my $Language = 'de';

        # do not check RichText
        $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
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

        $Selenium->get("${ScriptAlias}index.pl?Action=AdminEmail");

        # check page
        for my $ID (
            qw(From UserIDs GroupIDs GroupPermissionRO GroupPermissionRW Subject RichText)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # if there are roles, there will be select box for roles in AdminEmail
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

        # check client side validation
        my $Element = $Selenium->find_element( "#Subject", 'css' );
        $Element->send_keys("");
        $Element->submit();

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Subject').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # create test admin notification
        my $RandomID = $Helper->GetRandomID();
        my $Text     = "Selenium Admin Notification test";
        my $UserID   = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        $Selenium->execute_script("\$('#UserIDs').val('$UserID').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Subject",  'css' )->send_keys($RandomID);
        $Selenium->find_element( "#RichText", 'css' )->send_keys($Text);
        $Selenium->find_element( "#Subject",  'css' )->submit();

        # check if test admin notification is success
        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $Language,
        );

        my $Expected = $LanguageObject->Get(
            "Your message was sent to"
        ) . ": $TestUserLogin\@localunittest.com";

        $Self->True(
            index( $Selenium->get_page_source(), $Expected ) > -1,
            "$RandomID admin notification was sent",
        );

    }

);

1;
