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

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # Get needed objects.
        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # Disable all dashboard plugins.
        my $Config = $ConfigObject->Get('DashboardBackend');
        $Helper->ConfigSettingChange(
            Valid => 0,
            Key   => 'DashboardBackend',
            Value => $Config,
        );

        # Get dashboard News plugin default sysconfig.
        my %NewsConfig = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemGet(
            Name    => 'DashboardBackend###0405-News',
            Default => 1,
        );

        # Set dashboard News plugin to valid.
        %NewsConfig = map { $_->{Key} => $_->{Content} }
            grep { defined $_->{Key} } @{ $NewsConfig{Setting}->[1]->{Hash}->[1]->{Item} };

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'DashboardBackend###0405-News',
            Value => \%NewsConfig,
        );

        my @NewsData;
        for ( 0 .. 1 ) {
            my $Number = $Helper->GetRandomNumber();
            push @NewsData, {
                Title => "UT Breaking News - $Number",
                Link  => "https://www.otrs.com/$Number",
            };
        }

        # Override Request() from WebUserAgent to always return some test data without making any
        #   actual web service calls. This should prevent instability in case cloud services are
        #   unavailable at the exact moment of this test run.
        my $CustomCode = <<"EOS";
use Kernel::System::WebUserAgent;
package Kernel::System::WebUserAgent;
use strict;
use warnings;
{
    no warnings 'redefine';
    sub Request {
        my \$JSONString = '{"Results":{"PublicFeeds":[{"Success":"1","Operation":"NewsFeed","Data":{"News":[{"Title":"$NewsData[0]->{Title}","Link":"$NewsData[0]->{Link}","Time":"2017-01-25T15:05:59+00:00"},{"Title":"$NewsData[1]->{Title}","Link":"$NewsData[1]->{Link}","Time":"2017-01-25T15:05:59+00:00"}]}}]},"ErrorMessage":"","Success":1}';
        return (
            Content => \\\$JSONString,
            Status  => '200 OK',
        );
    }
}
1;
EOS
        $Helper->CustomCodeActivate(
            Code => $CustomCode,
        );

        # Make sure cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->Delete(
            Type => 'Dashboard',
            Key  => 'RSSNewsFeed-en',
        );

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Get script alias.
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Navigate to dashboard screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentDashboard");

        # Check if News plugin has items with correct titles and links.
        for my $Item (@NewsData) {
            $Self->True(
                $Selenium->execute_script(
                    "return \$('#Dashboard0405-News tbody a[href=\"$Item->{Link}\"]:contains(\"$Item->{Title}\")').length;"
                ),
                "News dashboard plugin with title '$Item->{Title}' and link '$Item->{Link}' - found",
            );
        }
    }
);

1;
