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

        # create test customer user
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate() || die "Did not get test customer user";

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # First page load, no links shown.
        $Helper->ConfigSettingChange(
            Valid => 0,
            Key   => 'PublicFrontend::FooterLinks',
            Value => {},
        );

        $Selenium->VerifiedGet("${ScriptAlias}customer.pl");

        $Self->Is(
            $Selenium->execute_script("return \$('#Footer ul.FooterLinks > li > a').length;"),
            0,
            "No links in footer area displayed",
        );

        # Display link for OTRS Homepage.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'PublicFrontend::FooterLinks',
            Value => {
                'https://www.otrs.com' => 'OTRS Homepage',
            },
        );

        $Selenium->VerifiedRefresh();

        $Self->Is(
            $Selenium->execute_script("return \$('#Footer ul.FooterLinks > li > a').length;"),
            1,
            "Links in footer area displayed",
        );

        $Self->True(
            index( $Selenium->get_page_source(), 'OTRS Homepage' ) > -1,
            'OTRS Homepage link is shown',
        );

        # Check public interface as well.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'PublicFrontend::CommonParam###Action',
            Value => 'PublicDefault',
        );

        $Selenium->VerifiedGet("${ScriptAlias}public.pl");

        $Self->Is(
            $Selenium->execute_script("return \$('#Footer ul.FooterLinks > li > a').length;"),
            1,
            "Links in footer area displayed",
        );

        $Self->True(
            index( $Selenium->get_page_source(), 'OTRS Homepage' ) > -1,
            'OTRS Homepage link is shown',
        );
    }
);

1;
