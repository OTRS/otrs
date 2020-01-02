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

use Kernel::Config;

# Get needed objects
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject      = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $SysConfigObject   = $Kernel::OM->Get('Kernel::System::SysConfig');
my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');
my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

# Delete sysconfig_modified_version
return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => 'DELETE FROM sysconfig_modified_version',
);

# Delete sysconfig_modified
return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => 'DELETE FROM sysconfig_modified',
);

# Delete sysconfig_default_version
return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => 'DELETE FROM sysconfig_default_version',
);

# Delete sysconfig_default
return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => 'DELETE FROM sysconfig_default',
);

# Load setting from sample XML file
my $LoadSuccess = $SysConfigObject->ConfigurationXML2DB(
    UserID    => 1,
    Directory => "$ConfigObject->{Home}/scripts/test/sample/SysConfig/XML/Entities",
);
$Self->True(
    $LoadSuccess,
    "Load settings from SampleEntities.xml."
);

# Basic tests
my @Tests1 = (
    {
        Description => 'Without EntityType',
        Config      => {
            EntityName => '3 normal',
        },
        ExpectedResult => undef,
    },
    {
        Description => 'Without EntityName',
        Config      => {
            EntityType => 'Priority',
        },
        ExpectedResult => undef,
    },
    {
        Description => '#1',
        Config      => {
            EntityName => 'open',
            EntityType => 'State',
        },
        ExpectedResult => [
            'Ticket::Frontend::AgentTicketPriority###ComplexEntity2',
            'Ticket::Frontend::AgentTicketPriority###StateDefault',
        ],
    },
    {
        Description => '#2',
        Config      => {
            EntityName => 'openßČĆ£øπ∂',
            EntityType => 'StateßČĆ£øπ∂',
        },
        ExpectedResult => [
            'Ticket::Frontend::AgentTicketPriority###EntityUnicode',
        ],
    },
);

# Caching tests (after updating item)
my @Tests2 = (
    {
        Description => 'Item updated - Check if cache is deleted',
        Config      => {
            EntityName => 'openßČĆ£øπ∂',
            EntityType => 'StateßČĆ£øπ∂',
        },
        ExpectedResult => [
            'Ticket::Frontend::AgentTicketPriority###EntityUnicode'
        ],
    },
);

# Caching tests (after item deleted)
my @Tests3 = (
    {
        Description => 'Item deleted - Check if cache is deleted',
        Config      => {
            EntityName => 'openßČĆ£øπ∂',
            EntityType => 'StateßČĆ£øπ∂',
        },
        ExpectedResult => [
        ],
    },
);

for my $Test (@Tests1) {
    my @Result = $SysConfigObject->ConfigurationEntityCheck( %{ $Test->{Config} } );

    if (@Result) {
        $Self->IsDeeply(
            \@Result,
            $Test->{ExpectedResult},
            $Test->{Description} . ': ConfigurationEntityCheck(): Result must match expected one.',
        );
    }
    else {
        $Self->False(
            $Test->{ExpectedResult},
            $Test->{Description} . ': ConfigurationEntityCheck(): Result must match expected one.',
        );
    }
}

my %DefaultSetting = $SysConfigDBObject->DefaultSettingGet(
    Name => 'Ticket::Frontend::AgentTicketPriority###EntityUnicode',
);

# Update setting navigation
$DefaultSetting{Navigation} = 'AnyOtherValue';

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
my $DefaultSettingUpdateSuccess = $SysConfigDBObject->DefaultSettingUpdate(
    %DefaultSetting,
    ExclusiveLockGUID => $GuID,
    UserID            => 1,
);
$Self->True(
    $DefaultSettingUpdateSuccess,
    "Update success.",
);

# Check result
for my $Test (@Tests2) {
    my @Result = $SysConfigObject->ConfigurationEntityCheck( %{ $Test->{Config} } );

    $Self->IsDeeply(
        \@Result,
        $Test->{ExpectedResult},
        $Test->{Description} . ': ConfigurationEntityCheck(): Result must match expected one.',
    );
}

# Delete item
my $DefaultSettingDeleteSuccess = $SysConfigDBObject->DefaultSettingDelete(
    DefaultID => $DefaultSetting{DefaultID},
);
$Self->True(
    $DefaultSettingDeleteSuccess,
    "Delete setting.",
);

# Check result
for my $Test (@Tests3) {
    my @Result = $SysConfigObject->ConfigurationEntityCheck( %{ $Test->{Config} } );

    $Self->IsDeeply(
        \@Result,
        $Test->{ExpectedResult},
        $Test->{Description} . ': ConfigurationEntityCheck(): Result must match expected one.',
    );
}

1;
