# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Linux::Distribution;

# Skip this test on CentOS 6, for now.
my $OSDist = Linux::Distribution::distribution_name()    || '';
my $OSVer  = Linux::Distribution::distribution_version() || '';
if ( $OSDist eq 'centos' && $OSVer =~ /^6/ ) {
    $Self->True(
        1,
        'CentOS 6 detected, skipping test...',
    );
    exit;
}

# get selenium object
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

        # Get dashboard ProductNotify plugin default sysconfig.
        my %ProductNotifyConfig = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemGet(
            Name    => 'DashboardBackend###0000-ProductNotify',
            Default => 1,
        );

        # Set dashboard ProductNotify plugin to valid.
        %ProductNotifyConfig = map { $_->{Key} => $_->{Content} }
            grep { defined $_->{Key} } @{ $ProductNotifyConfig{Setting}->[1]->{Hash}->[1]->{Item} };

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'DashboardBackend###0000-ProductNotify',
            Value => \%ProductNotifyConfig,
        );

        # Get current properties and set next version.
        my $Product                = $ConfigObject->Get('Product');
        my $Version                = $ConfigObject->Get('Version');
        my @Parts                  = split /\./, $Version;
        my $NextVersionFirstNumber = $Parts[0] + 1;

        my @ProductFeeds;
        for ( 0 .. 1 ) {
            my $Number = $Helper->GetRandomNumber();
            push @ProductFeeds, {
                Version => "$NextVersionFirstNumber.0.$Number",
                Link    => "https://www.otrs.com/release-notes-$Number",
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
        my \$JSONString = '{"Results":{"PublicFeeds":[{"Success":"1","Operation":"ProductFeed","Data":{"CacheTTL":"4320","Release":[{"Name":"OTRS","Severity":"Patch","Version":"$ProductFeeds[0]->{Version}","Link":"$ProductFeeds[0]->{Link}"},{"Name":"OTRS","Severity":"Patch","Version":"$ProductFeeds[1]->{Version}","Link":"$ProductFeeds[1]->{Link}"}]}}]},"ErrorMessage":"","Success":1}';
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
            Type => 'DashboardProductNotify',
            Key =>
                "CloudService::PublicFeeds::Operation::ProductFeed::Language::en::Product::${Product}::Version::$Version",
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

        # Check if ProductNotify plugin has items with correct text and links.
        for my $Item (@ProductFeeds) {
            $Self->True(
                $Selenium->execute_script(
                    "return \$('#Dashboard0000-ProductNotify tbody tr:contains(\"$Item->{Version}\") a[href=\"$Item->{Link}\"]').length;"
                ),
                "ProductNotify dashboard plugin which text contains '$Item->{Version}' and link '$Item->{Link}' - found",
            );
        }
    }
);

1;
