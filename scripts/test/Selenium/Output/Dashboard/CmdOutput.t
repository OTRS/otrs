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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 1,
            },
        );
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
        $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
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
