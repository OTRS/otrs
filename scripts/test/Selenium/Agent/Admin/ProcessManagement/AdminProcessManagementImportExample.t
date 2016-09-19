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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        my $Home = $Kernel::OM->Get('Kernel::Config')->Get("Home");

        # TODO: Review, find a better solution
        # Copy post .pm file from samples to test if it works
        # system("cp $Home/scripts/test/sample/ProcessManagement/Sample_process_Application_for_leave_post.pm "
        #     . "$Home/var/processes/examples");

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

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AdminProcessManagement screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");

        # select Application for leave process
        $Selenium->execute_script(
            "\$('#ExampleProcess').val('Sample_process_Application_for_leave.yml')" .
                ".trigger('redraw.InputField').trigger('change');"
        );

        # Import
        $Selenium->find_element( "#ExampleProcesses button", "css" )->VerifiedClick();

        my $ProcessFound = $Selenium->execute_script(
            "return \$(\".ContentColumn a.AsBlock:contains('Application for leave')\").length;"
        );

        $Self->True(
            $ProcessFound,
            "Application for leave is imported."
        );

        # check imported dynamic fields (from pre .pm file)
        my $DynamicFieldList = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldList(
            ObjectType => 'Ticket',
            ResultType => 'HASH',
        );

        for my $DynamicFieldNeeded (
            qw(PreProcApplicationRecorded PreProcDaysRemaining PreProcVacationStart
            PreProcVacationEnd PreProcDaysUsed PreProcEmergencyTelephone PreProcRepresentationBy
            PreProcProcessStatus PreProcApprovedSuperior PreProcVacationInfo
            )
            )
        {
            my $Found = grep { $DynamicFieldNeeded eq $DynamicFieldList->{$_} } keys %{$DynamicFieldList};

            $Self->True(
                $Found,
                "Dynamic field is found($DynamicFieldNeeded)",
            );
        }
        }
);

1;
