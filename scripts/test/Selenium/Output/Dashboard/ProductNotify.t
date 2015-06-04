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

        # get dashboard ProductNotify plugin default sysconfig
        my %ProductNotifyConfig = $SysConfigObject->ConfigItemGet(
            Name    => 'DashboardBackend###0000-ProductNotify',
            Default => 1,
        );

        # set dashboard ProductNotify plugin to valid
        %ProductNotifyConfig = map { $_->{Key} => $_->{Content} }
            grep { defined $_->{Key} } @{ $ProductNotifyConfig{Setting}->[1]->{Hash}->[1]->{Item} };

        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'DashboardBackend###0000-ProductNotify',
            Value => \%ProductNotifyConfig,
        );

        # get main object
        my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

        # get content of RELEASE
        my $Home    = $Kernel::OM->Get('Kernel::Config')->Get('Home');
        my $Content = $MainObject->FileRead(
            Location => "$Home/RELEASE",
            Result   => 'ARRAY',
        );

        # change version in RELEASE to one lower then current
        my $Version;
        my $OriginalContent = '';
        my $TestContent     = '';
        for my $Line ( @{$Content} ) {
            $OriginalContent .= $Line;
            if ( $Line =~ /^VERSION\s{0,2}=\s{0,2}(.*)$/i ) {
                $Version = $1;
                substr( $Version, 0, 1, substr( $Version, 0, 1 ) - 1 );
                $Line =~ s/$1/$Version/;
            }
            $TestContent .= $Line;
        }

        # update RELEASE with test version
        my $FileLocation = $MainObject->FileWrite(
            Location => "$Home/RELEASE",
            Content  => \$TestContent,
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

        # test if ProductNotify plugin shows correct link
        my $ProductNotifyLink = "https://www.otrs.com/release-notes-otrs-help-desk";
        $Self->True(
            index( $Selenium->get_page_source(), $ProductNotifyLink ) > -1,
            "ProductNotify dashboard plugin link - found",
        );

        # restore default RELEASE version
        $FileLocation = $MainObject->FileWrite(
            Location => "$Home/RELEASE",
            Content  => \$OriginalContent,
        );
        }
);

1;
