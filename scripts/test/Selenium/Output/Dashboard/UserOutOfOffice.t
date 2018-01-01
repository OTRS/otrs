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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # make sure that UserOutOfOffice is enabled
        my %UserOutOfOfficeSysConfig = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemGet(
            Name    => 'DashboardBackend###0390-UserOutOfOffice',
            Default => 1,
        );

        %UserOutOfOfficeSysConfig = map { $_->{Key} => $_->{Content} }
            grep { defined $_->{Key} } @{ $UserOutOfOfficeSysConfig{Setting}->[1]->{Hash}->[1]->{Item} };

        # enable UserOutOfOffice and set it to load as default plugin
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'DashboardBackend###0390-UserOutOfOffice',
            Value => \%UserOutOfOfficeSysConfig,

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
        my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

        # get current system time
        my ( $Sec, $Min, $Hour, $Day, $Month, $Year, $WeekDay ) = $TimeObject->SystemTime2Date(
            SystemTime => $TimeObject->SystemTime(),
        );

        # create OutOfOffice params
        my @OutOfOfficeTime = (
            {
                Key   => 'OutOfOffice',
                Value => 1,
            },
            {
                Key   => 'OutOfOfficeStartYear',
                Value => $Year,
            },
            {
                Key   => 'OutOfOfficeEndYear',
                Value => $Year + 1,
            },
            {
                Key   => 'OutOfOfficeStartMonth',
                Value => $Month,
            },
            {
                Key   => 'OutOfOfficeEndMonth',
                Value => $Month,
            },
            {
                Key   => 'OutOfOfficeStartDay',
                Value => $Day,
            },
            {
                Key   => 'OutOfOfficeEndDay',
                Value => $Day,
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
        my $ExpectedResult = "$TestUserLogin until $Month/$Day/" . ( $Year + 1 );
        $Self->True(
            index( $Selenium->get_page_source(), $ExpectedResult ) > -1,
            "OutOfOffice message - found on screen"
        );

    }
);

1;
