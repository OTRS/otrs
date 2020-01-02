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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # make sure that UserOutOfOffice is enabled
        my %UserOutOfOfficeSysConfig = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet(
            Name    => 'DashboardBackend###0390-UserOutOfOffice',
            Default => 1,
        );

        # enable UserOutOfOffice and set it to load as default plugin
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'DashboardBackend###0390-UserOutOfOffice',
            Value => $UserOutOfOfficeSysConfig{EffectiveValue},

        );

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get user object
        my $UserObject = $Kernel::OM->Get('Kernel::System::User');

        # get test user ID
        my $TestUserID = $UserObject->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # get time object
        my $DTObj    = $Kernel::OM->Create('Kernel::System::DateTime');
        my $DTValues = $DTObj->Get();

        # create OutOfOffice params
        my @OutOfOfficeTime = (
            {
                Key   => 'OutOfOffice',
                Value => 1,
            },
            {
                Key   => 'OutOfOfficeStartYear',
                Value => $DTValues->{Year},
            },
            {
                Key   => 'OutOfOfficeEndYear',
                Value => $DTValues->{Year} + 1,
            },
            {
                Key   => 'OutOfOfficeStartMonth',
                Value => $DTValues->{Month},
            },
            {
                Key   => 'OutOfOfficeEndMonth',
                Value => $DTValues->{Month},
            },
            {
                Key   => 'OutOfOfficeStartDay',
                Value => $DTValues->{Day},
            },
            {
                Key   => 'OutOfOfficeEndDay',
                Value => $DTValues->{Day},
            },
        );

        # set OutOfOffice preference
        for my $OutOfOfficePreference (@OutOfOfficeTime) {
            $UserObject->SetPreferences(
                UserID => $TestUserID,
                Key    => $OutOfOfficePreference->{Key},
                Value  => $OutOfOfficePreference->{Value},
            );
        }

        # clean up dashboard cache and refresh screen
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Dashboard' );
        $Selenium->VerifiedRefresh();

        # test OutOfOffice plugin
        my $ExpectedResult = sprintf(
            "$TestUserLogin until %02d/%02d/%d",
            $DTValues->{Month},
            $DTValues->{Day},
            $DTValues->{Year} + 1,
        );
        $Self->True(
            index( $Selenium->get_page_source(), $ExpectedResult ) > -1,
            "OutOfOffice message - found on screen"
        );

    }
);

1;
