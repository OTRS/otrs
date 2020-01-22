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

use Kernel::System::VariableCheck qw(:all);

my $Helper          = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

# NOTE: This test changes CommonJS###000-Framework.
# So the test works in transaction in order to avoid crash the system if tests is failed.
my $StartedTransaction = $Helper->BeginWork();
$Self->True(
    $StartedTransaction,
    'Started database transaction.',
);

my $SettingReset = sub {
    my %Param = @_;

    my $SettingName = $Param{SettingName};

    my %Setting = $SysConfigObject->SettingGet(
        Name      => $SettingName,
        Translate => 0,
    );

    my $Guid = $SysConfigObject->SettingLock(
        UserID    => 1,
        DefaultID => $Setting{DefaultID},
        Force     => 1,
    );
    $Self->True(
        $Guid,
        "Lock setting before reset($SettingName).",
    );

    my $Success = $SysConfigObject->SettingReset(
        Name              => $SettingName,
        ExclusiveLockGUID => $Guid,
        UserID            => 1,
    );
    $Self->True(
        $Success,
        "Setting $SettingName reset to the default value.",
    );

    $SysConfigObject->SettingUnlock(
        DefaultID => $Setting{DefaultID},
    );
};

my @Tests = (
    {
        SettingName => 'Loader::Agent::CommonJS###000-Framework',
        OldValue    => 'thirdparty/jquery-jstree-3.3.4/jquery.jstree.js',
        NewValue    => 'thirdparty/jquery-jstree-3.3.7/jquery.jstree.js',
    },
    {
        SettingName => 'Loader::Customer::CommonJS###000-Framework',
        OldValue    => 'thirdparty/jquery-jstree-3.3.4/jquery.jstree.js',
        NewValue    => 'thirdparty/jquery-jstree-3.3.7/jquery.jstree.js',
    },
    {
        SettingName => 'Loader::Agent::CommonJS###000-Framework',
        OldValue    => 'thirdparty/jquery-3.2.1/jquery.js',
        NewValue    => 'thirdparty/jquery-3.4.1/jquery.js',
    },
    {
        SettingName => 'Loader::Customer::CommonJS###000-Framework',
        OldValue    => 'thirdparty/jquery-3.2.1/jquery.js',
        NewValue    => 'thirdparty/jquery-3.4.1/jquery.js',
    },
);

# Test it in 'eval' block in order to avoid crash the system after failing the test.
eval {
    for my $Test (@Tests) {

        my $Result = $SysConfigObject->SettingsSet(
            UserID   => 1,
            Comments => "Deploy $Test->{SettingName} setting with test",
            Settings => [
                {
                    Name           => $Test->{SettingName},
                    EffectiveValue => [ $Test->{OldValue}, ],
                    IsValid        => 1,
                },
            ],
        );

        my %SettingCheck = $SysConfigObject->SettingGet(
            Name => $Test->{SettingName},
        );

        $Self->Is(
            $Test->{OldValue},
            $SettingCheck{EffectiveValue}[0],
            "Settings $Test->{SettingName} are set to old value.",
        );

        # Run migration module
        my $Success = $Kernel::OM->Get('scripts::DBUpdateTo6::MigrateModifiedSettings')->Run();

        $Self->True(
            $Success,
            "MigrateModifiedSettings: migration is done.",
        );

        %SettingCheck = $SysConfigObject->SettingGet(
            Name => $Test->{SettingName},
        );

        $Self->Is(
            $Test->{NewValue},
            $SettingCheck{EffectiveValue}[0],
            "Settings $Test->{SettingName} are migrated to new value.",
        );

    }
};

my $RollbackSuccess = $Helper->Rollback();
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();
$Self->True(
    $RollbackSuccess,
    'Rolled back all database changes and cleaned up the cache.',
);

for my $Test (@Tests) {

    # Reset setting to default value.
    $SettingReset->( SettingName => $Test->{SettingName} );
}

my %Result = $SysConfigObject->ConfigurationDeploy(
    Comments    => "Revert changes.",
    UserID      => 1,
    Force       => 1,
    AllSettings => 1,
);

$Self->True(
    $Result{Success},
    'Configuration restored.',
);

1;
