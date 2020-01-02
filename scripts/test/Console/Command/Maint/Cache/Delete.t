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

# get command object
my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Cache::Delete');

my ( $Result, $ExitCode );

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# create cache object and disable inmemory caching to force
# the cache to read from file system
my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
$CacheObject->Configure(
    CacheInMemory => 0,
);

my $ObjectType = $Helper->GetRandomID();
my $ObjectKey  = $Helper->GetRandomNumber();

# create dummy cache entry
my $CacheSet = $CacheObject->Set(
    Type  => $ObjectType,
    Key   => $ObjectKey,
    Value => 'TestData',
);
$Self->Is(
    $CacheSet,
    1,
    "Delete all - Cache set",
);

# delete all cache files
$ExitCode = $CommandObject->Execute();
$Self->Is(
    $ExitCode,
    0,
    "Delete all - exit code",
);

# check if entry is gone
my $CacheGet = $CacheObject->Get(
    Type => $ObjectType,
    Key  => $ObjectKey,
);

$Self->Is(
    $CacheGet,
    undef,
    "Delete all - check if file is still present",
);

# create another dummy cache entry with TTL 1 day
$ObjectType = $Helper->GetRandomID();
$ObjectKey  = $Helper->GetRandomNumber();

$CacheSet = $CacheObject->Set(
    Type  => $ObjectType,
    Key   => $ObjectKey,
    Value => 'TestData',
    TTL   => 60 * 60 * 24,
);
$Self->Is(
    $CacheSet,
    1,
    "Delete expired - Cache set",
);

# delete only expired cache files
$ExitCode = $CommandObject->Execute('--expired');
$Self->Is(
    $ExitCode,
    0,
    "Delete expired - exit code",
);

# entry should be still there
$CacheGet = $CacheObject->Get(
    Type => $ObjectType,
    Key  => $ObjectKey,
);

$Self->Is(
    $CacheGet,
    'TestData',
    "Delete expired - check if file is still present",
);

# create another dummy cache entry with TTL 1 day
$ObjectType = $Helper->GetRandomID();
$ObjectKey  = $Helper->GetRandomNumber();

$CacheSet = $CacheObject->Set(
    Type  => $ObjectType,
    Key   => $ObjectKey,
    Value => 'TestData',
);
$Self->Is(
    $CacheSet,
    1,
    "Delete only certain type - Cache set",
);
$CacheSet = $CacheObject->Set(
    Type  => $ObjectType . '_2',
    Key   => $ObjectKey,
    Value => 'TestData',
);
$Self->Is(
    $CacheSet,
    1,
    "Delete only certain type - Cache set (another type)",
);

# delete only expired cache files
$ExitCode = $CommandObject->Execute( '--type', $ObjectType );
$Self->Is(
    $ExitCode,
    0,
    "Delete only certain type - exit code",
);

# 1st entry should be deleted
$CacheGet = $CacheObject->Get(
    Type => $ObjectType,
    Key  => $ObjectKey,
);
$Self->Is(
    $CacheGet,
    undef,
    "Delete only certain type - check if file is still present",
);

# 2nd entry should be still there
$CacheGet = $CacheObject->Get(
    Type => $ObjectType . '_2',
    Key  => $ObjectKey,
);
$Self->Is(
    $CacheGet,
    'TestData',
    "Delete only certain type - check if file is still present (another type)",
);

# finally delete all caches
$ExitCode = $CommandObject->Execute();
$Self->Is(
    $ExitCode,
    0,
    "Delete all remaining caches",
);

1;
