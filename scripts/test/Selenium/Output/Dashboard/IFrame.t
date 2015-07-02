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

        # get dashboard IFrame plugin default sysconfig
        my %IFrameConfig = $SysConfigObject->ConfigItemGet(
            Name    => 'DashboardBackend###0300-IFrame',
            Default => 1,
        );

        # set dashboard IFrame plugin to valid
        my %IFrameConfigUpdate = map { $_->{Key} => $_->{Content} }
            grep { defined $_->{Key} } @{ $IFrameConfig{Setting}->[1]->{Hash}->[1]->{Item} };

        $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
            Valid => 1,
            Key   => 'DashboardBackend###0300-IFrame',
            Value => \%IFrameConfigUpdate,
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

        # test if IFrame plugin shows correct link
        my $IFrameLink = $IFrameConfig{Setting}->[1]->{Hash}->[1]->{Item}->[8]->{Content};
        $Self->True(
            index( $Selenium->get_page_source(), $IFrameLink ) > -1,
            "IFrame dashboard plugin link '$IFrameLink' - found",
        );
    }
);

1;
