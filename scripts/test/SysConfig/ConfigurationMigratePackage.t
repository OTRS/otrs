# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

use File::Copy;
use Kernel::Config;
use Kernel::System::VariableCheck qw(:all);

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

# get needed objects
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

my $Home = $Kernel::OM->Get('Kernel::Config')->{Home};

my $TestFile        = 'ZZZAutoOTRS5.pm';
my $TestPath        = $Home . '/scripts/test/sample/SysConfig/Migration/Package/';
my $TestLocation    = $TestPath . $TestFile;
my $OTRS5ConfigFile = "$Home/Kernel/Config/Backups/ZZZAutoOTRS5.pm";

# create backups directory if not existing
if ( !-d "$Home/Kernel/Config/Backups" ) {
    mkdir "$Home/Kernel/Config/Backups";
}

# copy ZZZAutoOTRS5.pm to backup folder from where it is processed during package upgrade
copy( $TestLocation, $OTRS5ConfigFile );

$Self->True(
    -e $OTRS5ConfigFile,
    "TestFile '$OTRS5ConfigFile' existing",
);

# check if ARCHIVE file exists, if not we create it
my $ArchiveFileCreated;
if ( !-e $Home . '/ARCHIVE' ) {

    # create an ARCHIVE file on developer systems to continue working
    my $ArchiveGeneratorTool = $Home . '/bin/otrs.CheckSum.pl';

    # if tool is not present we can't continue
    if ( !-e $ArchiveGeneratorTool ) {
        $Self->True(
            0,
            "$ArchiveGeneratorTool does not exist, we can't continue",
        );
        return;
    }

    # execute ARCHIVE generator tool
    my $Result = `$ArchiveGeneratorTool -a create`;

    # if archive file still does not exist or has zero length
    if ( !-e $Home . '/ARCHIVE' || -z $Home . '/ARCHIVE' ) {

        # if ARCHIVE file is not present we can't continue
        $Self->True(
            0,
            "ARCHIVE file is not generated, we can't continue",
        );
        return;
    }
    else {
        $Self->True(
            1,
            "ARCHIVE file is generated for UnitTest purpose",
        );

        # remeber that we created an ARCHIVE file so we can delete it again later
        $ArchiveFileCreated = 1;
    }
}

# build a 5.0.1 version of the test package
my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Dev::Package::Build');
my $ExitCode      = $CommandObject->Execute(
    '--version', '5.0.1', '--module-directory',
    'scripts/test/sample/SysConfig/Migration/Package/TestPackage/',
    'scripts/test/sample/SysConfig/Migration/Package/TestPackage/TestPackage.sopm', 'var/tmp/'
);

$Self->Is(
    $ExitCode,
    0,
    "Dev::Package::Build exit code",
);

# install the package
$CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Package::Install');
$ExitCode      = $CommandObject->Execute('var/tmp/TestPackage-5.0.1.opm');

$Self->Is(
    $ExitCode,
    0,
    "Admin::Package::Install exit code",
);

# list the installed packages
$CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Package::List');
$ExitCode      = $CommandObject->Execute();

# build a 6.0.1 version of the test package
$CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Dev::Package::Build');
$ExitCode      = $CommandObject->Execute(
    '--version',
    '6.0.1',
    '--module-directory',
    'scripts/test/sample/SysConfig/Migration/Package/TestPackage/',
    'scripts/test/sample/SysConfig/Migration/Package/TestPackage/TestPackage.sopm',
    'var/tmp/',
);

$Self->Is(
    $ExitCode,
    0,
    "Dev::Package::Build exit code",
);

# upgrade the package
$CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Package::Upgrade');
$ExitCode      = $CommandObject->Execute('var/tmp/TestPackage-6.0.1.opm');

$Self->Is(
    $ExitCode,
    0,
    "Admin::Package::Upgrade exit code",
);

# list the installed packages
$CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Package::List');
$ExitCode      = $CommandObject->Execute();

my @Tests = (
    {
        Name           => 'Ticket::Hook',
        EffectiveValue => 'TicketTestMigrated#',
    },
    {
        Name           => 'Frontend::Module###AgentTicketQueue',
        EffectiveValue => {
            'Description' => 'Overview of all open Tickets. Migrated.',
            'Group'       => [
                'admin'
            ],
            'GroupRo'    => [],
            'NavBarName' => 'Ticket',
            'Title'      => 'QueueView',
        },
    },
    {
        Name           => 'Frontend::Navigation###AgentTicketQueue###1',
        EffectiveValue => {
            'AccessKey'   => 'o',
            'Block'       => '',
            'Description' => 'Overview of all open Tickets. Migrated.',
            'Group'       => [
                'admin',
            ],
            'GroupRo'    => [],
            'Link'       => 'Action=AgentTicketQueue',
            'LinkOption' => '',
            'Name'       => 'Queue view',
            'NavBar'     => 'Ticket',
            'Prio'       => '100',
            'Type'       => '',
        },
    },
    {
        Name           => 'Frontend::Navigation###AgentTicketQueue###2',
        EffectiveValue => {
            'AccessKey'   => 't',
            'Block'       => 'ItemArea',
            'Description' => 'Test Migrated',
            'Group'       => [
                'admin',
            ],
            'GroupRo'    => [],
            'Link'       => 'Action=AgentTicketQueue',
            'LinkOption' => '',
            'Name'       => 'Tickets',
            'NavBar'     => 'Ticket',
            'Prio'       => '200',
            'Type'       => 'Menu',
        },
    },
);

my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

for my $Test (@Tests) {

    # get sysconfig setting
    my %OTRS6Setting = $SysConfigObject->SettingGet(
        Name => $Test->{Name},
    );

    # handle string setings
    if ( IsString( $Test->{EffectiveValue} ) ) {

        # check effective value
        $Self->Is(
            $OTRS6Setting{EffectiveValue},
            $Test->{EffectiveValue},
            "Check migrated setting for config setting '$Test->{Name}'",
        );
    }

    # handle complex data structure settings
    else {

        # check effective value
        $Self->IsDeeply(
            $OTRS6Setting{EffectiveValue},
            $Test->{EffectiveValue},
            "Check migrated setting for config setting '$Test->{Name}'",
        );
    }
}

# uninstall the package
$CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Package::Uninstall');
$ExitCode      = $CommandObject->Execute('TestPackage');

$Self->Is(
    $ExitCode,
    0,
    "Admin::Package::Uninstall exit code",
);

# cleanup ARCHIVE file
if ($ArchiveFileCreated) {
    my $Success = unlink $Home . '/ARCHIVE';
    $Self->True(
        $Success,
        "UnitTest ARCHIVE file is deleted",
    );
}

# cleanup otrs 5 config file
unlink $OTRS5ConfigFile;

$Self->False(
    -e $OTRS5ConfigFile,
    "UnitTest OTRS5Config file is deleted",
);

1;
