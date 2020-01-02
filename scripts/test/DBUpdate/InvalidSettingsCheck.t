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

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $CacheObject       = $Kernel::OM->Get('Kernel::System::Cache');
my $SysConfigObject   = $Kernel::OM->Get('Kernel::System::SysConfig');
my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

my $DBUpdateObject = $Kernel::OM->Create('scripts::DBUpdateTo6::InvalidSettingsCheck');

# Set one setting to the invalid value.
my $SettingName = 'Ticket::Frontend::AgentTicketPhone###Priority';

# Get Setting.
my %Setting = $SysConfigObject->SettingGet(
    Name => $SettingName,
);

# Lock setting.
my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
    Name   => $Setting{Name},
    Force  => 1,
    UserID => 1,
);

# Set to invalid value.
my $Success;

if ( $Setting{ModifiedID} ) {

    $Success = $SysConfigDBObject->ModifiedSettingUpdate(
        ModifiedID        => $Setting{ModifiedID},
        DefaultID         => $Setting{DefaultID},
        Name              => $Setting{Name},
        IsValid           => 1,
        EffectiveValue    => '-123 Invalid priority value',
        ExclusiveLockGUID => $ExclusiveLockGUID,
        UserID            => 1,
    );
}
else {
    $Success = $SysConfigDBObject->ModifiedSettingAdd(
        DefaultID         => $Setting{DefaultID},
        Name              => $Setting{Name},
        IsValid           => 1,
        EffectiveValue    => '-123 Invalid priority value',
        ExclusiveLockGUID => $ExclusiveLockGUID,
        UserID            => 1,
    );
}

$Self->True(
    $Success,
    'Setting updated'
);

$Success = $SysConfigObject->SettingUnlock(
    Name => $SettingName,
);
$Self->True(
    $Success,
    'Setting unlocked'
);

# Fix invalid setting during migration.
$Success = $DBUpdateObject->Run(
    CommandlineOptions => {
        NonInteractive => 1,
    },
);

$Self->True(
    $Success,
    'Migration went OK'
);

# Get invalid settings.
my @InvalidSettings = $SysConfigObject->ConfigurationInvalidList(
    Undeployed => 1,
    NoCache    => 1,
);

my $SettingIsInvalid = grep { $_ eq $SettingName } @InvalidSettings;

$Self->False(
    $SettingIsInvalid,
    'Make sure that setting is no longer invalid'
);

1;
