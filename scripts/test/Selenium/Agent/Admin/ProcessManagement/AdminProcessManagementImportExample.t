# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));
use Kernel::Config;

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper             = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

        my $Home = $Kernel::OM->Get('Kernel::Config')->Get("Home");

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        # Add needed dynamic field, but in wrong format.
        my $ID = $DynamicFieldObject->DynamicFieldAdd(
            Name       => 'PreProcApplicationRecorded',
            Label      => 'Days Remaining',
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            FieldOrder => 10001,
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

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AdminProcessManagement screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");

        # Select Application for leave process.
        $Selenium->execute_script(
            "\$('#ExampleProcess').val('Application_for_leave.yml')" .
                ".trigger('redraw.InputField').trigger('change');"
        );

        # Import.
        $Selenium->find_element( "#ExampleProcesses button", "css" )->VerifiedClick();

        # Check error message.
        $Self->True(
            index(
                $Selenium->get_page_source(),
                "Dynamic field PreProcApplicationRecorded already exists, but definition is wrong."
            ) > -1,
            "Error message is shown.",
        );

        # Delete wrong dynamic field.
        my $DeleteSuccess = $DynamicFieldObject->DynamicFieldDelete(
            ID      => $ID,
            UserID  => 1,
            Reorder => 1,
        );
        $Self->True(
            $DeleteSuccess,
            "Dynamic field deleted successfully.",
        );

        # Try to import process once again, but this time it should work.

        # Navigate to AdminProcessManagement screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");

        # Select Application for leave process.
        $Selenium->execute_script(
            "\$('#ExampleProcess').val('Application_for_leave.yml')" .
                ".trigger('redraw.InputField').trigger('change');"
        );
        sleep 2;

        # Import.
        $Selenium->find_element( "#ExampleProcesses button", "css" )->VerifiedClick();
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".MessageBox.Notice p").text().trim().includes("Application for leave");'
        );

        my $ProcessFound = $Selenium->execute_script(
            "return \$(\".ContentColumn a.AsBlock:contains('Application for leave')\").length;"
        );

        $Self->True(
            $ProcessFound,
            "Application for leave is imported."
        );

        # Check imported dynamic fields (from pre .pm file).
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

        # To check if _post.pm file is executed properly, compare sysconfig with expected value.
        delete $INC{ $Home . '/Kernel/Config/Files/ZZZAuto.pm' };
        my $ConfigObject = Kernel::Config->new();

        my $Value = $ConfigObject->Get("Ticket::Frontend::AgentTicketZoom");

        my %ExpectedValue = (
            'ProcessWidgetDynamicFieldGroups' => {
                'Application for Leave - Approval and HR data' =>
                    'PreProcApprovedSuperior,PreProcApplicationRecorded,PreProcVacationInfo',
                'Application for Leave - Request Data' =>
                    'PreProcVacationStart,PreProcVacationEnd,PreProcDaysUsed,PreProcDaysRemaining,' .
                    'PreProcEmergencyTelephone,PreProcRepresentationBy',
            },
            'ProcessWidgetDynamicField' => {
                'PreProcApplicationRecorded' => '1',
                'PreProcDaysRemaining'       => '1',
                'PreProcVacationStart'       => '1',
                'PreProcVacationEnd'         => '1',
                'PreProcDaysUsed'            => '1',
                'PreProcEmergencyTelephone'  => '1',

                # 'PreProcRepresentationBy'     => '1',
                # 'PreProcProcessStatus'        => '1',
                'PreProcApprovedSuperior' => '1',
                'PreProcVacationInfo'     => '1',
            },
        );

        for my $Key ( sort keys %ExpectedValue ) {
            for my $InnerKey ( sort keys %{ $ExpectedValue{$Key} } ) {

                $Self->True(
                    $Value->{$Key},
                    "Key $Key is present.",
                );
                if ( $Value->{$Key} ) {
                    $Self->Is(
                        $Value->{$Key}->{$InnerKey},
                        $ExpectedValue{$Key}->{$InnerKey},
                        "Check Ticket::Frontend::AgentTicketZoom###$Key###$InnerKey value."
                    );
                }
            }
        }

        # Delete wrong dynamic field.
        my $DynamicFieldData = $DynamicFieldObject->DynamicFieldGet(
            Name => 'PreProcApplicationRecorded',
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
