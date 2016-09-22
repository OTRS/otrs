# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));
use Kernel::Config;

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper             = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
        my $WebserviceObject   = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

        my $Home = $Kernel::OM->Get('Kernel::Config')->Get("Home");

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        # add needed dynamic field, but in wrong format
        my $ID = $DynamicFieldObject->DynamicFieldAdd(
            Name       => 'PreWebBugzillaID',
            Label      => 'Bugzilla ID',
            FieldType  => 'TextArea',
            ObjectType => 'Ticket',
            FieldOrder => 10000,
            Config     => {},
            ValidID    => 1,
            UserID     => 1,
        );
        $Self->True(
            $ID,
            "Dynamic field created.",
        );

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get test user ID
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AdminGenericInterfaceWebservice screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminGenericInterfaceWebservice");

        # add web service
        $Selenium->find_element( ".ActionList li:nth-child(1) button[type='submit']", "css" )->VerifiedClick();

        # select BugzillaConnector web service
        $Selenium->execute_script(
            "\$('#ExampleWebService').val('BugzillaConnector.yml')" .
                ".trigger('redraw.InputField').trigger('change');"
        );

        # Import
        $Selenium->find_element( "#ExampleWebServices button", "css" )->VerifiedClick();

        # check error message
        $Self->True(
            index(
                $Selenium->get_page_source(),
                "Dynamic field PreWebBugzillaID already exists, but definition is wrong."
                ) > -1,
            "Error message is shown.",
        );

        # delete wrong dynamic field
        my $DeleteSuccess = $DynamicFieldObject->DynamicFieldDelete(
            ID      => $ID,
            UserID  => 1,
            Reorder => 1,
        );
        $Self->True(
            $DeleteSuccess,
            "Dynamic field deleted successfully.",
        );

        # Try to import web service once again, but this time it should work.

        # navigate to AdminGenericInterfaceWebservice screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminGenericInterfaceWebservice");

        # add web service
        $Selenium->find_element( ".ActionList li:nth-child(1) button[type='submit']", "css" )->VerifiedClick();

        # select BugzillaConnector web service
        $Selenium->execute_script(
            "\$('#ExampleWebService').val('BugzillaConnector.yml')" .
                ".trigger('redraw.InputField').trigger('change');"
        );

        # Import
        $Selenium->find_element( "#ExampleWebServices button", "css" )->VerifiedClick();

        my $WebServiceFound = $Selenium->execute_script(
            "return \$(\".ContentColumn a.AsBlock:contains('BugzillaConnector')\").length;"
        );

        $Self->True(
            $WebServiceFound,
            "BugzillaConnector is imported."
        );

        # check imported dynamic fields (from pre .pm file)
        my $DynamicFieldList = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldList(
            ObjectType => 'Ticket',
            ResultType => 'HASH',
        );

        for my $DynamicFieldNeeded (qw(PreWebBugzillaID)) {
            my $Found = grep { $DynamicFieldNeeded eq $DynamicFieldList->{$_} } keys %{$DynamicFieldList};

            $Self->True(
                $Found,
                "Dynamic field is found($DynamicFieldNeeded)",
            );
        }

        # delete web service
        $Selenium->find_element("//a[text()='BugzillaConnector']")->VerifiedClick();
        $Selenium->find_element( "#DeleteButton",  "css" )->VerifiedClick();
        $Selenium->find_element( "#DialogButton2", "css" )->VerifiedClick();

        # delete dynamic field
        my $DynamicFieldData = $DynamicFieldObject->DynamicFieldGet(
            Name => 'PreWebBugzillaID',
        );
        my $DeleteSuccess2 = $DynamicFieldObject->DynamicFieldDelete(
            ID      => $DynamicFieldData->{ID},
            UserID  => 1,
            Reorder => 1,
        );
        $Self->True(
            $DeleteSuccess2,
            "Dynamic field deleted successfully.",
        );

    }
);

1;
