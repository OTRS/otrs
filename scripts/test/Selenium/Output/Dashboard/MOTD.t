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

        # get sysconfig object
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # get dashboard MOTD plugin default sysconfig
        my %MOTDConfig = $SysConfigObject->ConfigItemGet(
            Name    => 'DashboardBackend###0210-MOTD',
            Default => 1,
        );

        # set dashboard MOTD plugin to valid
        my %MOTDConfigUpdate = map { $_->{Key} => $_->{Content} }
            grep { defined $_->{Key} } @{ $MOTDConfig{Setting}->[1]->{Hash}->[1]->{Item} };

        $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
            Valid => 1,
            Key   => 'DashboardBackend###0210-MOTD',
            Value => \%MOTDConfigUpdate,
        );

        # # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # test if MOTD plugin shows correct message
        my $DefaultMOTD = "This is the message of the day. You can edit this in Kernel/Output/HTML/Templates/Standard/Motd.tt.";
        $Self->True(
            index( $Selenium->get_page_source(), $DefaultMOTD ) > -1,
            "MOTD dashboard plugin message - found",
        );
        }
);

1;
