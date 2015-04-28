# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get needed objects
my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');
my $LogObject         = $Kernel::OM->Get('Kernel::System::Log');
my $TimeObject        = $Kernel::OM->Get('Kernel::System::Time');
my $TaskManagerObject = $Kernel::OM->Get('Kernel::System::Scheduler::TaskManager');

my $Home = $ConfigObject->Get('Home');

my $Scheduler = $Home . '/bin/otrs.Scheduler.pl';
if ( $^O =~ /^mswin/i ) {
    $Scheduler = "\"$^X\" " . $Home . '/bin/otrs.Scheduler4win.pl';
    $Scheduler =~ s{/}{\\}g;
}

# get scheduler status
my $PreviousSchedulerStatus = `$Scheduler -a status`;

# stop scheduler if it was already running before this test
if ( $PreviousSchedulerStatus =~ /^running/i ) {
    `$Scheduler -a stop`;

    # wait to get scheduler fully stoped before test continues
    my $SleepTime = 2;
    if ( $^O =~ /^mswin/i ) {
        $SleepTime = 5;
    }

    print "A running Scheduler was detected and need to be stopped...\n";
    print 'Sleeping ' . $SleepTime . "s\n";
    sleep $SleepTime;
}

$Self->Is(
    ref $TaskManagerObject,
    'Kernel::System::Scheduler::TaskManager',
    "Kernel::System::Scheduler::TaskManager->new()",
);

my $SystemDataObject          = $Kernel::OM->Get('Kernel::System::SystemData');
my $OriginalRegistrationState = $SystemDataObject->SystemDataGet(
    Key => 'Registration::State',
);
my $OriginalRegistrationUniqueID = $SystemDataObject->SystemDataGet(
    Key => 'Registration::UniqueID',
);
my $OriginalTaskCount = scalar( grep { $_->{Type} eq 'RegistrationUpdate' } $TaskManagerObject->TaskList() );

my $SchedulerObject = $Kernel::OM->Get('Kernel::System::Scheduler');

#$SchedulerObject->Run();

# ok, fake a registered system
if ( defined $OriginalRegistrationState ) {
    $SystemDataObject->SystemDataUpdate(
        Key    => 'Registration::State',
        Value  => 'registered',
        UserID => 1,
    );
}
else {
    $SystemDataObject->SystemDataAdd(
        Key    => 'Registration::State',
        Value  => 'registered',
        UserID => 1,
    );

    # Fake a UniqueID if system was not registered yet.
    $SystemDataObject->SystemDataAdd(
        Key    => 'Registration::UniqueID',
        Value  => 'unittest',
        UserID => 1,
    );
}

$SchedulerObject->_SanityChecks();
$Self->Is(
    scalar( grep { $_->{Type} eq 'RegistrationUpdate' } $TaskManagerObject->TaskList() ),
    1,
    "Created RegistrationUpdate task on registered system",
);

# Ok, add another task to check if it is cleaned up
$TaskManagerObject->TaskAdd(
    Type => 'RegistrationUpdate',
    Data => {
        ReSchedule => 1,
    },
);

$SchedulerObject->_SanityChecks();
$Self->Is(
    scalar( grep { $_->{Type} eq 'RegistrationUpdate' } $TaskManagerObject->TaskList() ),
    1,
    "Created RegistrationUpdate task on registered system, cleaned up superfluous tasks",
);

# Purge all tasks to check if one is created
for my $Task ( grep { $_->{Type} eq 'RegistrationUpdate' } $TaskManagerObject->TaskList() ) {
    $TaskManagerObject->TaskDelete(
        ID => $Task->{ID},
    );
}

$SchedulerObject->_SanityChecks();
$Self->Is(
    scalar( grep { $_->{Type} eq 'RegistrationUpdate' } $TaskManagerObject->TaskList() ),
    1,
    "Created RegistrationUpdate task on registered system, missing task added",
);

# Fake a non registered system
$SystemDataObject->SystemDataUpdate(
    Key    => 'Registration::State',
    Value  => '',
    UserID => 1,
);

$SchedulerObject->_SanityChecks();
$Self->Is(
    scalar( grep { $_->{Type} eq 'RegistrationUpdate' } $TaskManagerObject->TaskList() ),
    0,
    "Removed RegistrationUpdate task on non registered system",
);

# restore original state
if ( defined $OriginalRegistrationState ) {
    $SystemDataObject->SystemDataUpdate(
        Key    => 'Registration::State',
        Value  => $OriginalRegistrationState,
        UserID => 1,
    );
}
else {
    $SystemDataObject->SystemDataDelete(
        Key    => 'Registration::State',
        UserID => 1,
    );

    # Remove fake UniqueID
    $SystemDataObject->SystemDataDelete(
        Key    => 'Registration::UniqueID',
        UserID => 1,
    );
}

$SchedulerObject->_SanityChecks();
my $FinalRegistrationState = $SystemDataObject->SystemDataGet(
    Key => 'Registration::State',
);
my $FinalRegistrationUniqueID = $SystemDataObject->SystemDataGet(
    Key => 'Registration::UniqueID',
);
my $FinalTaskCount = scalar( grep { $_->{Type} eq 'RegistrationUpdate' } $TaskManagerObject->TaskList() );
$Self->Is(
    $FinalRegistrationState,
    $OriginalRegistrationState,
    'Final registration state',
);
$Self->Is(
    $FinalRegistrationUniqueID,
    $OriginalRegistrationUniqueID,
    'Final registration UniqueID',
);
$Self->Is(
    $FinalTaskCount,
    $OriginalTaskCount,
    'Final task count',
);

# start scheduler if it was already running before this test
if ( $PreviousSchedulerStatus =~ /^running/i ) {
    `$Scheduler -a start`;
}

1;
