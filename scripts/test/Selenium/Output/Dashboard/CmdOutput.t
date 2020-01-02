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

        # get cmd sysconfig params
        my $CmdMessage = 'Selenium cmd output test';
        my %CmdParam   = (
            Block       => 'ContentSmall',
            CacheTTL    => 60,
            Cmd         => 'echo ' . $CmdMessage,
            Default     => 1,
            Description => '',
            Group       => '',
            Module      => 'Kernel::Output::HTML::Dashboard::CmdOutput',
            Title       => 'Sample command output'
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'DashboardBackend###0420-CmdOutput',
            Value => \%CmdParam,
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

        # check for cmd expected message
        $Self->True(
            index( $Selenium->get_page_source(), "$CmdMessage" ) > -1,
            "$CmdMessage - found on screen"
        );
    }
);

1;
