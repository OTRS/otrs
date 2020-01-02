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

use Kernel::Config;

# Get needed objects
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject      = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $SysConfigObject   = $Kernel::OM->Get('Kernel::System::SysConfig');
my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');
my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');

# Delete sysconfig_modified_version
my $SQLDeleteModifiedSettingsVersion = 'DELETE FROM sysconfig_modified_version';
return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => $SQLDeleteModifiedSettingsVersion,
);

# Delete sysconfig_modified
my $SQLDeleteModifiedSettings = 'DELETE FROM sysconfig_modified';
return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => $SQLDeleteModifiedSettings,
);

# Delete sysconfig_default_version
my $SQLDeleteDefaultSettingsVersion = 'DELETE FROM sysconfig_default_version';
return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => $SQLDeleteDefaultSettingsVersion,
);

# Delete sysconfig_default
my $SQLDeleteDefaultSettings = 'DELETE FROM sysconfig_default';
return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => $SQLDeleteDefaultSettings,
);

# Initial call
my $Result = $SysConfigObject->ConfigurationXML2DB(
    UserID    => 1,
    Directory => "$ConfigObject->{Home}/scripts/test/sample/SysConfig/XML/",
);

# Read a couple of configuration from Defaults
# and add a modified setting entry for each one

my %DefaultSetting = $SysConfigDBObject->DefaultSettingGet(
    Name => 'Ticket::Frontend::AgentTicketPriority###ArticleTypes',
);

# Lock
my $GuID = $SysConfigDBObject->DefaultSettingLock(
    UserID    => 1,
    DefaultID => $DefaultSetting{DefaultID},
);

$Self->True(
    $GuID,
    "Check if locked before update."
);

# Update item
my $ModifiedSettingAddSuccess = $SysConfigDBObject->ModifiedSettingAdd(
    %DefaultSetting,
    ExclusiveLockGUID => $GuID,
    UserID            => 1,
);
$Self->True(
    $ModifiedSettingAddSuccess,
    "Add success.",
);

%DefaultSetting = $SysConfigDBObject->DefaultSettingGet(
    Name => 'Ticket::Frontend::AgentTicketResponsible###StateType',
);

# Lock
$GuID = $SysConfigDBObject->DefaultSettingLock(
    UserID    => 1,
    DefaultID => $DefaultSetting{DefaultID},
);

$Self->True(
    $GuID,
    "Check if locked before update."
);

# Update item
$ModifiedSettingAddSuccess = $SysConfigDBObject->ModifiedSettingAdd(
    %DefaultSetting,
    ExclusiveLockGUID => $GuID,
    UserID            => 1,
);
$Self->True(
    $ModifiedSettingAddSuccess,
    "Add success.",
);

# Call ConfigurationXML2DB with the same file as beginning

$Result = $SysConfigObject->ConfigurationXML2DB(
    UserID    => 1,
    Directory => "$ConfigObject->{Home}/scripts/test/sample/SysConfig/XML/",
);

# Verify both modified setting are still there
my @ModifiedSettingsList = $SysConfigDBObject->ModifiedSettingListGet();
my %ModifiedSettingsList = map { $_->{Name} => 1 } @ModifiedSettingsList;

$Self->True(
    $ModifiedSettingsList{"Ticket::Frontend::AgentTicketPriority###ArticleTypes"},
    "ArticleTypes setting should be present.",
);
$Self->True(
    $ModifiedSettingsList{"Ticket::Frontend::AgentTicketResponsible###StateType"},
    "StateType setting should be present.",
);

# Call ConfigurationXML2DB with the modified file
$Result = $SysConfigObject->ConfigurationXML2DB(
    UserID    => 1,
    Directory => "$ConfigObject->{Home}/scripts/test/sample/SysConfig/XMLMod/",
);

# Verify one of the modified setting is gone

@ModifiedSettingsList = $SysConfigDBObject->ModifiedSettingListGet();
%ModifiedSettingsList = map { $_->{Name} => 1 } @ModifiedSettingsList;

$Self->False(
    $ModifiedSettingsList{"Ticket::Frontend::AgentTicketPriority###ArticleTypes"},
    "ArticleTypes setting is gone.",
);
$Self->True(
    $ModifiedSettingsList{"Ticket::Frontend::AgentTicketResponsible###StateType"},
    "StateType setting should be present.",
);

1;
