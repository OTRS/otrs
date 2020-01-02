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

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper            = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $ListCommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Config::ListInvalid');
my $FixCommandObject  = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Config::FixInvalid');
my $SysConfigObject   = $Kernel::OM->Get('Kernel::System::SysConfig');
my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

my ( $Result, $ExitCode );

{
    local *STDOUT;
    open STDOUT, '>:utf8', \$Result;    ## no critic
    $ExitCode = $ListCommandObject->Execute();
}

$Self->Is(
    $ExitCode,
    0,
    "Exit code",
);

$Self->True(
    $Result =~ m{All settings are valid\.} ? 1 : 0,
    'Check default list result.'
);

{
    local *STDOUT;
    open STDOUT, '>:utf8', \$Result;    ## no critic
    $ExitCode = $FixCommandObject->Execute();
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
    'Check default fix result'
);

# Set some settings to an invalid value.
my @PriorityList = $Kernel::OM->Get('Kernel::System::SysConfig::ValueType::Entity::Priority')->EntityValueList();
my @StateList    = $Kernel::OM->Get('Kernel::System::SysConfig::ValueType::Entity::State')->EntityValueList();
my %Settings     = (
    'Ticket::Frontend::AgentTicketPhone###Priority' => {
        InvalidValue => '-123 Invalid priority value',
        DefaultValue => $PriorityList[0],
        ValidValue   => '-124 Invalid priority value',
    },
    'Ticket::SubjectSize' => {
        InvalidValue => '1000',
        ValidValue   => '1',
    },
    'Ticket::Frontend::AgentTicketFreeText###StateDefault' => {
        InvalidValue => '-123 Invalid state value',
        ValidValue   => $StateList[-1],
    },
);

for my $SettingName ( sort keys %Settings ) {

    # Get Setting.
    my %Setting = $SysConfigObject->SettingGet(
        Name => $SettingName,
    );

    # Lock setting.
    my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
        Name   => $SettingName,
        Force  => 1,
        UserID => 1,
    );

    # Set to invalid value.
    my $Success;

    if ( $Setting{ModifiedID} ) {

        $Success = $SysConfigDBObject->ModifiedSettingUpdate(
            ModifiedID        => $Setting{ModifiedID},
            DefaultID         => $Setting{DefaultID},
            Name              => $SettingName,
            IsValid           => 1,
            EffectiveValue    => $Settings{$SettingName}->{InvalidValue},
            ExclusiveLockGUID => $ExclusiveLockGUID,
            UserID            => 1,
        );
    }
    else {
        $Success = $SysConfigDBObject->ModifiedSettingAdd(
            DefaultID         => $Setting{DefaultID},
            Name              => $Setting{Name},
            IsValid           => 1,
            EffectiveValue    => $Settings{$SettingName}->{InvalidValue},
            ExclusiveLockGUID => $ExclusiveLockGUID,
            UserID            => 1,
        );
    }

    $Self->True(
        $Success,
        "Setting '$SettingName' updated to invalid.",
    );
}

{
    local *STDOUT;
    open STDOUT, '>:utf8', \$Result;    ## no critic
    $ExitCode = $ListCommandObject->Execute();
}

$Self->Is(
    $ExitCode,
    1,
    "Exit code",
);

$Self->True(
    $Result
        =~ m{The following settings have an invalid value:.*?Ticket::Frontend::AgentTicketFreeText###StateDefault = '-123 Invalid state value';.*?Ticket::Frontend::AgentTicketPhone###Priority = '-123 Invalid priority value';.*?Ticket::SubjectSize = '1000';}s
    ? 1
    : 0,
    'Check invalid result.'
);

# Have ListInvalid write yml file with invalid config.
my $YAMLFile = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/var/tmp/ListInvalidFixInvalid.yml';
{
    local *STDOUT;
    open STDOUT, '>:utf8', \$Result;    ## no critic
    $ExitCode = $ListCommandObject->Execute( '--export-to-path', $YAMLFile );
}

$Self->Is(
    $ExitCode,
    1,
    "Exit code",
);

my $MainObject  = $Kernel::OM->Get('Kernel::System::Main');
my $FileContent = $MainObject->FileRead(
    Location => $YAMLFile,
);
$Self->True(
    $FileContent,
    'Read yml file',
);

my $ExportData = $Kernel::OM->Get('Kernel::System::YAML')->Load( Data => ${$FileContent} );
$Self->True(
    $ExportData,
    'Load yml',
);

for my $SettingName ( sort keys %Settings ) {
    $Self->Is(
        $ExportData->{$SettingName},
        $Settings{$SettingName}->{InvalidValue},
        "Exported value for setting '$SettingName'",
    );

    # Replace with valid value - or default value if we intentionally set an invalid value in file.
    $ExportData->{$SettingName} = $Settings{$SettingName}->{DefaultValue} // $Settings{$SettingName}->{ValidValue};
}

my $ValidValuesYAML = $Kernel::OM->Get('Kernel::System::YAML')->Dump(
    Data => $ExportData,
);
$Self->True(
    $ValidValuesYAML,
    'Dump yml',
);

# Write settings to a file.
my $FileLocation = $MainObject->FileWrite(
    Location => $YAMLFile,
    Content  => \$ValidValuesYAML,
    Mode     => 'utf8',
);
$Self->True(
    $FileLocation,
    'Write yml file',
);

{
    local *STDOUT;
    open STDOUT, '>:utf8', \$Result;    ## no critic
    $ExitCode = $FixCommandObject->Execute( '--values-from-path', $YAMLFile, '--non-interactive' );
}

$Self->Is(
    $ExitCode,
    0,
    "Exit code",
);

$Self->True(
    $Result
        =~ m{Corrected setting via input file:.*?Ticket::Frontend::AgentTicketFreeText###StateDefault.*?Corrected setting via input file:.*?Ticket::Frontend::AgentTicketPhone###Priority.*?Corrected setting via input file:.*?Ticket::SubjectSize}s
    ? 1
    : 0,
    'Check valid result.'
);

{
    local *STDOUT;
    open STDOUT, '>:utf8', \$Result;    ## no critic
    $ExitCode = $ListCommandObject->Execute();
}

$Self->Is(
    $ExitCode,
    0,
    "Exit code",
);

$Self->True(
    $Result =~ m{All settings are valid\.} ? 1 : 0,
    'Check new list result.'
);

my $Success = $MainObject->FileDelete(
    Location => $YAMLFile,
);
$Self->True(
    $Success,
    'Delete yml file',
);

# cleanup cache is done by RestoreDatabase

1;
