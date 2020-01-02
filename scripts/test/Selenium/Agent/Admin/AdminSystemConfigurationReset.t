# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper             = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $OTRSBusinessObject = $Kernel::OM->Get('Kernel::System::OTRSBusiness');
        my $SysConfigObject    = $Kernel::OM->Get('Kernel::System::SysConfig');

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AdminSysConfig screen.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminSystemConfiguration;Subaction=View;Setting=Ticket%3A%3AFrontend%3A%3AAgentTicketEscalationView%23%23%23Order%3A%3ADefault;"
        );

        # Hover
        my $SelectedItem = $Selenium->find_element( ".SettingEdit", "css" );
        $Selenium->mouse_move_to_location( element => $SelectedItem );

        # Lock setting.
        $Selenium->find_element( ".SettingEdit", "css" )->click();

        # Wait.
        $Selenium->WaitFor(
            Time       => 120,
            JavaScript => 'return $(".SettingsList .WidgetSimple:first").hasClass("HasOverlay") == 0',
        );

        # Change dropdown value do 'Down'.
        $Selenium->InputFieldValueSet(
            Element => '.SettingContent select',
            Value   => 'Down',
        );

        # Save.
        $Selenium->find_element( ".SettingUpdateBox button", "css" )->click();

        # Wait.
        $Selenium->WaitFor(
            Time       => 120,
            JavaScript => 'return $(".SettingsList .WidgetSimple:first").hasClass("HasOverlay") == 0',
        );

        # Make sure that it's saved properly.
        my %Setting = $SysConfigObject->SettingGet(
            Name => 'Ticket::Frontend::AgentTicketEscalationView###Order::Default',
        );

        $Self->Is(
            $Setting{EffectiveValue},
            'Down',
            'Make sure setting is updated.',
        );

        # Expand header.
        $Selenium->find_element( ".SettingsList .WidgetSimple .Header", "css" )->click();

        # Wait.
        $Selenium->WaitFor(
            JavaScript => 'return $(".ResetSetting:visible").length',
        );

        # Click on reset.
        $Selenium->execute_script('$(".ResetSetting").click()');

        # Wait.
        $Selenium->WaitFor(
            JavaScript => 'return $("#ResetConfirm").length',
        );

        # Confirm.
        $Selenium->find_element( "#ResetConfirm", "css" )->click();

        # Wait.
        $Selenium->WaitFor(
            Time       => 120,
            JavaScript => 'return $(".SettingsList .WidgetSimple:first").hasClass("HasOverlay") == 0',
        );

        # Discard Cache object.
        $Kernel::OM->ObjectsDiscard(
            Objects => ['Kernel::System::Cache'],
        );

        # Make sure that setting is reset properly.
        %Setting = $SysConfigObject->SettingGet(
            Name => 'Ticket::Frontend::AgentTicketEscalationView###Order::Default',
        );

        $Self->Is(
            $Setting{EffectiveValue},
            'Up',
            'Make sure setting is reset.',
        );

        if ( $OTRSBusinessObject->OTRSBusinessIsInstalled() ) {

            my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
                UserLogin => $TestUserLogin,
            );

            $Self->True(
                $UserID,
                "UserID found: $UserID",
            );

            # Set user preference.
            my %UpdateResult = $SysConfigObject->SettingUpdate(
                Name           => 'Ticket::Frontend::AgentTicketEscalationView###Order::Default',
                EffectiveValue => 'Down',
                TargetUserID   => $UserID,
                UserID         => $UserID,
            );

            $Self->True(
                $UpdateResult{Success},
                'Local setting updated.'
            );

            # Navigate to User Preferences screen.
            $Selenium->VerifiedGet(
                "${ScriptAlias}index.pl?Action=AgentPreferences;Subaction=Group;Group=Advanced;RootNavigation=Frontend%3A%3AAgent%3A%3AView%3A%3ATicketEscalation"
            );

            # Wait.
            $Selenium->WaitFor(
                JavaScript => 'return $(".SettingsList .WidgetSimple:first input:visible").length',
            );

            # Get user value.
            my $Value = $Selenium->execute_script(
                'return $(".SettingsList .WidgetSimple:first select").val();',
            );

            $Self->Is(
                $Value,
                'Down',
                'Make sure user preference is correctly rendered',
            );

            # Navigate to AdminSysConfig screen.
            $Selenium->VerifiedGet(
                "${ScriptAlias}index.pl?Action=AdminSystemConfiguration;Subaction=View;Setting=Ticket%3A%3AFrontend%3A%3AAgentTicketEscalationView%23%23%23Order%3A%3ADefault;"
            );

            # Expand header.
            $Selenium->find_element( ".SettingsList .WidgetSimple .Header", "css" )->click();

            # Wait.
            $Selenium->WaitFor(
                JavaScript => 'return $(".ResetSetting:visible").length',
            );

            # Click on reset.
            $Selenium->execute_script('$(".ResetSetting").click()');

            # Wait.
            $Selenium->WaitFor(
                JavaScript => 'return $("#ResetConfirm").length',
            );

            # Reset locally.
            $Selenium->InputFieldValueSet(
                Element => '#ResetOptions',
                Value   => "['reset-locally']",
            );

            # Confirm.
            $Selenium->find_element( "#ResetConfirm", "css" )->click();

            # Wait.
            $Selenium->WaitFor(
                Time       => 120,
                JavaScript => 'return $(".SettingsList .WidgetSimple:first").hasClass("HasOverlay") == 0',
            );

            my %UserSetting = $SysConfigObject->SettingGet(
                Name         => 'Ticket::Frontend::AgentTicketEscalationView###Order::Default',
                TargetUserID => $UserID,
            );

            $Self->Is(
                $UserSetting{EffectiveValue},
                'Up',
                'Make sure that user setting has been reset.',
            );
        }
    }
);

1;
