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

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {
        my $Helper          = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
        my $ScriptAlias     = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Load sample XML file.
        my $Directory = $Kernel::OM->Get('Kernel::Config')->Get('Home')
            . '/scripts/test/sample/SysConfig/XML/AdminSystemConfiguration/Deployment';

        my $XMLLoaded = $SysConfigObject->ConfigurationXML2DB(
            UserID    => 1,
            Directory => $Directory,
            Force     => 1,
            CleanUp   => 0,
        );

        $Self->True(
            $XMLLoaded,
            "ExampleComplex XML loaded.",
        );

        my %DeploymentResult = $SysConfigObject->ConfigurationDeploy(
            Comments    => "AdminSystemConfigurationFavourites.t deployment",
            UserID      => 1,
            Force       => 1,
            AllSettings => 1,
        );

        $Self->True(
            $DeploymentResult{Success},
            "Deployment successful.",
        );

        my $SettingName = 'DeployTestCheckbox';

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Navigate to 'DeployTestCheckbox' setting and check it.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminSystemConfiguration;Subaction=View;Setting=DeployTestCheckbox"
        );

        my $Prefix = "div[data-name=$SettingName]";

        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('$Prefix div.Content').length;",
        );

        $Selenium->execute_script("\$(\"$Prefix div.Content\").mouseenter();");
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('$Prefix button.CallForAction:visible').length;",
        );
        $Selenium->find_element( "$Prefix button.CallForAction", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && !\$('$Prefix .Overlay:visible').length;",
        );

        $Selenium->WaitFor(
            JavaScript => "return \$('#Checkbox_DeployTestCheckbox:visible').length;",
        );
        $Selenium->find_element( "#Checkbox_DeployTestCheckbox", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => "return \$('#Checkbox_DeployTestCheckbox:checked').length;",
        );

        $Selenium->WaitForjQueryEventBound(
            CSSSelector => "$Prefix button.Update",
        );
        $Selenium->find_element( $Prefix . ' button.Update', 'css' )->click();

        $Selenium->WaitFor(
            ElementExists => '//a[contains(@href,"Subaction=Deployment")]',
        );
        $Selenium->find_element('//a[contains(@href,"Subaction=Deployment")]')->VerifiedClick();

        $Selenium->WaitForjQueryEventBound(
            CSSSelector => "#DeploymentStart",
        );

        # Open the deployment dialog, exceeding its maximum length and check for the error.
        $Selenium->find_element( "#DeploymentStart", 'css' )->click();

        $Selenium->WaitFor(
            JavaScript => "return \$('#DeploymentComment:visible').length == 1;",
        );
        $Selenium->find_element( "#DeploymentComment", 'css' )->send_keys( 'A' x 251 );

        $Selenium->WaitFor(
            JavaScript => "return \$('#DialogDeployment .Overlay.Preparing:visible').length == 0;",
        );
        $Selenium->WaitForjQueryEventBound(
            CSSSelector => ".ButtonsRegular #Deploy",
        );
        $Selenium->find_element( "#Deploy", 'css' )->click();

        $Selenium->WaitFor(
            JavaScript => "return \$('#DeploymentComment.Error').length;",
        );
        $Self->True(
            $Selenium->execute_script("return \$('#DeploymentComment.Error').length;"),
            "Deployment dialog contains the error class.",
        );

        # Delete a character, try again and check if deployment was successful.
        $Selenium->find_element( "#DeploymentComment", 'css' )->clear();
        $Selenium->find_element( "#DeploymentComment", 'css' )->send_keys( 'A' x 250 );
        $Selenium->find_element( "#Deploy",            'css' )->click();

        $Selenium->WaitFor(
            JavaScript => "return \$('.Dialog .InnerContent .Overlay i.Success:visible').length;",
        );
        $Self->True(
            $Selenium->execute_script("return \$('.Dialog .InnerContent .Overlay i.Success:visible').length;"),
            "Deployment successful.",
        );

        # Wait until the animation has been finished.
        sleep 2;

        # Wait until redirect has been finished.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete;'
        );

        my %Setting = $SysConfigObject->SettingGet(
            Name => $SettingName,
        );

        $Self->Is(
            $Setting{EffectiveValue},
            1,
            "'DeployTestCheckbox' setting is changed and deployed successfully.",
        );

        # Set value back to 'unchecked'.
        my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
            Name   => $SettingName,
            Force  => 1,
            UserID => 1,
        );
        $Self->True(
            $ExclusiveLockGUID,
            "Setting 'DeployTestCheckbox' is locked successfully.",
        );

        my %Result = $SysConfigObject->SettingUpdate(
            Name              => $SettingName,
            EffectiveValue    => 0,
            ExclusiveLockGUID => $ExclusiveLockGUID,
            UserID            => 1,
        );
        $Self->True(
            $Result{Success},
            "Setting 'DeployTestCheckbox' is updated successfully.",
        );

        my $Success = $SysConfigObject->SettingUnlock(
            Name => $SettingName,
        );
        $Self->True(
            $Success,
            "Setting 'DeployTestCheckbox' is unlocked successfully.",
        );

        %Setting = $SysConfigObject->SettingGet(
            Name => $SettingName,
        );

        $Self->Is(
            $Setting{EffectiveValue},
            0,
            "'DeployTestCheckbox' setting is resetted successfully.",
        );
    }
);

1;
