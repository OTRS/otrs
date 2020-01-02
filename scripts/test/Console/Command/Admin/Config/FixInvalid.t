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

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper            = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $CacheObject       = $Kernel::OM->Get('Kernel::System::Cache');
my $CommandObject     = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Config::FixInvalid');
my $SysConfigObject   = $Kernel::OM->Get('Kernel::System::SysConfig');
my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

my ( $Result, $ExitCode );

{
    local *STDOUT;
    open STDOUT, '>:utf8', \$Result;    ## no critic
    $ExitCode = $CommandObject->Execute();
}

# There are no invalid settings.
$Self->Is(
    $ExitCode,
    0,
    'Exit code'
);

# Check output text.
$Self->True(
    $Result =~ m{All settings are valid\.} ? 1 : 0,
    'Check default result'
);

# Get Setting.
my %Setting = $SysConfigObject->SettingGet(
    Name => 'Ticket::Frontend::AgentTicketPhone###Priority',
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

{
    local *STDOUT;
    open STDOUT, '>:utf8', \$Result;    ## no critic
    $ExitCode = $CommandObject->Execute('--non-interactive');
}

$Self->Is(
    $ExitCode,
    0,
    'Exit code'
);

$Self->True(
    (
        $Result
            =~ m{Auto-corrected setting:.*Ticket::Frontend::AgentTicketPhone###Priority.*Deployment successful\.}s
    ) // 0,
    'Check invalid result'
);

# cleanup cache is done by RestoreDatabase

1;
