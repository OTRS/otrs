# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use Scalar::Util qw/weaken/;

use Kernel::System::ObjectManager;

local $Kernel::OM = Kernel::System::ObjectManager->new();

# test that all configured objects can be created and then destroyed;
# that way we know there are no cyclic references in the constructors

my @Objects = (
    'Kernel::Config',
    'Kernel::Language',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::ACL::DB::ACL',
    'Kernel::System::Auth',
    'Kernel::System::AuthSession',
    'Kernel::System::AutoResponse',
    'Kernel::System::Cache',
    'Kernel::System::CheckItem',
    'Kernel::System::CSV',
    'Kernel::System::CustomerAuth',
    'Kernel::System::CustomerCompany',
    'Kernel::System::CustomerGroup',
    'Kernel::System::CustomerUser',
    'Kernel::System::Daemon::SchedulerDB',
    'Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker',
    'Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::AsynchronousExecutor',
    'Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::Cron',
    'Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::GenericInterface',
    'Kernel::System::DB',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Email',
    'Kernel::System::Encode',
    'Kernel::System::Environment',
    'Kernel::System::FileTemp',
    'Kernel::System::GenericAgent',
    'Kernel::System::GenericInterface::DebugLog',
    'Kernel::System::GenericInterface::Webservice',
    'Kernel::System::Group',
    'Kernel::System::HTMLUtils',
    'Kernel::System::JSON',
    'Kernel::System::LinkObject',
    'Kernel::System::Loader',
    'Kernel::System::Lock',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Package',
    'Kernel::System::PDF',
    'Kernel::System::PID',
    'Kernel::System::Priority',
    'Kernel::System::Queue',
    'Kernel::System::Service',
    'Kernel::System::SLA',
    'Kernel::System::StandardTemplate',
    'Kernel::System::State',
    'Kernel::System::SysConfig',
    'Kernel::System::SystemAddress',
    'Kernel::System::Ticket',
    'Kernel::System::Time',
    'Kernel::System::Type',
    'Kernel::System::UnitTest',
    'Kernel::System::User',
    'Kernel::System::Valid',
    'Kernel::System::Web::Request',
    'Kernel::System::XML',
    'Kernel::System::YAML',
);

my %AllObjects;

for my $Object (@Objects) {
    my $PackageObject = $Kernel::OM->Get($Object);
    $AllObjects{$Object} = $PackageObject;
    $Self->True(
        $PackageObject,
        "ObjectManager could create $Object",
    );
}

for my $ObjectName ( sort keys %AllObjects ) {
    weaken( $AllObjects{$ObjectName} );
}

$Kernel::OM->ObjectsDiscard();

for my $ObjectName ( sort keys %AllObjects ) {
    $Self->True(
        !defined( $AllObjects{$ObjectName} ),
        "ObjectsDiscard got rid of $ObjectName",
    );
}

my %SomeObjects = (
    'Kernel::Config'         => $Kernel::OM->Get('Kernel::Config'),
    'Kernel::System::DB'     => $Kernel::OM->Get('Kernel::System::DB'),
    'Kernel::System::Ticket' => $Kernel::OM->Get('Kernel::System::Ticket'),
);

for my $ObjectName ( sort keys %SomeObjects ) {
    weaken( $SomeObjects{$ObjectName} );
}

$Kernel::OM->ObjectsDiscard(
    Objects => ['Kernel::System::DB'],
);

$Self->True(
    !$SomeObjects{'Kernel::System::DB'},
    'ObjectDiscard discarded Kernel::System::DB',
);
$Self->True(
    !$SomeObjects{'Kernel::System::Ticket'},
    'ObjectDiscard discarded Kernel::System::Ticket, because it depends on Kernel::System::DB',
);
$Self->True(
    $SomeObjects{'Kernel::Config'},
    'ObjectDiscard did not discard Kernel::Config',
);

# test custom objects
# note that scripts::test::ObjectManager::Dummy creates a scripts::test::ObjectManager::Dummy2 in its destructor,
# even though it didn't declare a dependency on it.
# The object manager must be robust enough to deal with that.
$Kernel::OM->ObjectParamAdd(
    'scripts::test::ObjectManager::Dummy' => {
        Data => 'Test payload',
    },
);

my $Dummy  = $Kernel::OM->Get('scripts::test::ObjectManager::Dummy');
my $Dummy2 = $Kernel::OM->Get('scripts::test::ObjectManager::Dummy2');

$Self->True( $Dummy,  'Can get Dummy object after registration' );
$Self->True( $Dummy2, 'Can get Dummy2 object after registration' );

$Self->Is(
    $Dummy->Data(),
    'Test payload',
    'Speciailization of late registered object',
);

weaken($Dummy);
weaken($Dummy2);

$Self->True( $Dummy, 'Object still alive' );

$Kernel::OM->ObjectsDiscard();

$Self->True( !$Dummy,  'ObjectsDiscard without arguments deleted Dummy' );
$Self->True( !$Dummy2, 'ObjectsDiscard without arguments deleted Dummy2' );

$Self->True(
    !$Kernel::OM->{Objects}{'scripts::test::ObjectManager::Dummy2'},
    'ObjecstDiscard also discarded newly autovivified objects'
);

$Dummy = $Kernel::OM->Get('scripts::test::ObjectManager::Dummy');
weaken($Dummy);
$Self->True( $Dummy, 'Object created again' );

$Kernel::OM->ObjectsDiscard(
    Objects => ['scripts::test::ObjectManager::Dummy'],
);
$Self->True( !$Dummy, 'ObjectsDiscard with list of objects deleted object' );

my $NonexistingObject = eval { $Kernel::OM->Get('Nonexisting::Package') };
$Self->True(
    $@,
    "Fetching a nonexisting object causes an exception",
);
$Self->False(
    $NonexistingObject,
    "Cannot construct a nonexisting object",
);

eval { $Kernel::OM->Get() };
$Self->True(
    $@,
    "Invalid object name causes an exception",
);

# Clean up
$Kernel::OM->ObjectsDiscard();

1;
