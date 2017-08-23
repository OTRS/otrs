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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

my $CheckBredcrumb = sub {

    my %Param = @_;

    my $BreadcrumbText = $Param{BreadcrumbText} || '';
    my $Count = 1;

    for my $BreadcrumbText ( 'Web Service Management', $BreadcrumbText ) {
        $Self->Is(
            $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
            $BreadcrumbText,
            "Breadcrumb text '$BreadcrumbText' is found on screen"
        );

        $Count++;
    }
};

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get test user ID
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # get config object
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # get script alias
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # navigate to AdminGenericInterfaceWebservice screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminGenericInterfaceWebservice");

        # check breadcrumb on Overview screen
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # click 'Add web service' button
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

        # check GenericInterface Web Service Management - Add screen
        for my $ID (
            qw(Name Description RemoteSystem DebugThreshold ValidID ImportButton)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # check breadcrumb on Add screen
        $CheckBredcrumb->( BreadcrumbText => 'Add Web Service' );

        $Selenium->find_element( 'Cancel', 'link_text' )->VerifiedClick();

        # set test values
        my %Description = (
            webserviceconfig_1 => 'Connector to send and receive date from Nagios.',
            webserviceconfig_2 => 'Connector to send and receive date from Nagios 2.',
        );

        my %WebserviceNames = (
            webserviceconfig_1 => 'webserviceconfig_1',
            webserviceconfig_2 => $Helper->GetRandomID(),
        );

        for my $Webservice (
            qw(webserviceconfig_1 webserviceconfig_2)
            )
        {

            # click 'Add web service' button
            $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

            # import web service
            $Selenium->find_element( "#ImportButton", 'css' )->VerifiedClick();

            my $File     = $Webservice . '.yml';
            my $Location = $ConfigObject->Get('Home') . "/scripts/test/sample/Webservice/$File";
            my $Name     = $WebserviceNames{$Webservice};

            if ( $Name ne $Webservice ) {
                $Selenium->find_element( "#WebserviceName", 'css' )->send_keys($Name);
            }

            $Selenium->find_element( "#ConfigFile",         'css' )->send_keys($Location);
            $Selenium->find_element( "#ImportButtonAction", 'css' )->VerifiedClick();

            # verify that web service is created
            $Self->True(
                index( $Selenium->get_page_source(), "Web service \"$Name\" created!" ) > -1,
                "$Name is created",
            );

            # GenericInterface Web Service Management - Change screen
            $Selenium->find_element( $Name, 'link_text' )->VerifiedClick();
            $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");
            $Selenium->find_element( "#RemoteSystem", 'css' )->send_keys('Test remote system');

            # check breadcrumb on Edit screen
            $CheckBredcrumb->( BreadcrumbText => 'Edit Web Service: ' . $Name );

            # save edited value
            $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

            # check class of invalid web service in the overview table
            $Self->True(
                $Selenium->execute_script(
                    "return \$('tr.Invalid td:contains($Name)').length"
                ),
                "There is a class 'Invalid' for test web service",
            );

            # check web service values
            $Selenium->find_element( $Name, 'link_text' )->VerifiedClick();

            $Self->Is(
                $Selenium->find_element( '#Name', 'css' )->get_value(),
                $Name,
                "#Name stored value",
            );

            $Self->Is(
                $Selenium->find_element( '#Description', 'css' )->get_value(),
                $Description{$Webservice},
                '#Description stored value',
            );

            $Self->Is(
                $Selenium->find_element( '#RemoteSystem', 'css' )->get_value(),
                'Test remote system',
                '#RemoteSystem updated value',
            );

            $Self->Is(
                $Selenium->find_element( '#ValidID', 'css' )->get_value(),
                2,
                "#ValidID updated value",
            );

            # delete web service
            $Selenium->find_element( "#DeleteButton",  'css' )->VerifiedClick();
            $Selenium->find_element( "#DialogButton2", 'css' )->VerifiedClick();

            # wait until delete dialog has closed and action performed
            $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && !\$('#DialogButton2').length" );

            # verify that web service is deleted
            $Self->True(
                index( $Selenium->get_page_source(), "Web service \"$Name\" deleted!" ) > -1,
                "$Name is deleted",
            );

        }
    }
);

1;
